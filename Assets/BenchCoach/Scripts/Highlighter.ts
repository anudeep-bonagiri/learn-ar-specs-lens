/**
 * Highlighter — makes the parts the current step wants touched glow. set(parts)
 * swaps the main material of every RenderMeshVisual on each part (a tire bead has
 * two: tread and sidewall band) for a cached clone
 * whose baseColor is lerped toward glowTint, pulsing the lerp between
 * minBlend..maxBlend of glowStrength at pulseHz; clear() puts the original
 * materials back. `current` lists the highlighted part names (a field, not a
 * getter, so tests can read it through a component reference).
 * Owns: material swaps on highlighted parts. Must not: decide which parts —
 * RepairManager calls set() / clear() per step.
 * Expects: nothing wired; parts are passed in.
 */
@component
export class Highlighter extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">Highlighter – pulsing glow on the parts to touch</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input("vec4", "{0.6, 1, 1, 1}")
  @hint("Glow color the part's base color is pulled toward (light cyan; never dark)")
  @widget(new ColorWidget())
  glowTint: vec4 = new vec4(0.6, 1, 1, 1)

  @input
  @hint("How far the base color moves toward the glow at the pulse peak (0.7 = 70 percent)")
  @widget(new SliderWidget(0, 1, 0.05))
  glowStrength: number = 0.7

  @input
  @hint("Pulse low point, as a fraction of glowStrength")
  @widget(new SliderWidget(0, 1, 0.05))
  minBlend: number = 0.5

  @input
  @hint("Pulse high point, as a fraction of glowStrength")
  @widget(new SliderWidget(0, 1, 0.05))
  maxBlend: number = 1

  @input
  @hint("Pulses per second")
  @widget(new SliderWidget(0.1, 4, 0.1))
  pulseHz: number = 1.2
  @ui.group_end

  /** Names of the highlighted parts, in the order passed to set(). */
  current: string[] = []

  private parts: SceneObject[] = []
  private originals: Material[][] = []
  private clones: Material[] = []
  private cloneSources: Material[] = []
  private baseColors: vec4[] = []
  private time = 0

  onAwake(): void {
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Highlight exactly these parts (others go back to normal). */
  set(parts: SceneObject[]): void {
    const keep = parts.filter((p) => !!p)
    for (let i = this.parts.length - 1; i >= 0; i--) {
      if (keep.indexOf(this.parts[i]) < 0) this.restoreAt(i)
    }
    for (const p of keep) {
      if (this.parts.indexOf(p) >= 0) continue
      const rmvs = this.visualsOf(p)
      if (rmvs.length === 0) continue
      const originals: Material[] = []
      for (const rmv of rmvs) {
        originals.push(rmv.mainMaterial)
        rmv.mainMaterial = this.cloneFor(rmv.mainMaterial)
      }
      this.parts.push(p)
      this.originals.push(originals)
    }
    this.current = keep.filter((p) => this.parts.indexOf(p) >= 0).map((p) => p.name)
    this.tick()
  }

  clear(): void {
    for (let i = this.parts.length - 1; i >= 0; i--) this.restoreAt(i)
    this.current = []
  }

  /** The part's own RenderMeshVisuals that have a material (children are not touched). */
  private visualsOf(p: SceneObject): RenderMeshVisual[] {
    return (p.getComponents("Component.RenderMeshVisual") as RenderMeshVisual[]).filter((r) => !!r.mainMaterial)
  }

  private restoreAt(i: number): void {
    const rmvs = this.visualsOf(this.parts[i])
    for (let k = 0; k < rmvs.length && k < this.originals[i].length; k++) rmvs[k].mainMaterial = this.originals[i][k]
    this.parts.splice(i, 1)
    this.originals.splice(i, 1)
  }

  /** One clone per source material, shared by every part that uses it (the beads share TireMat). */
  private cloneFor(source: Material): Material {
    const k = this.cloneSources.indexOf(source)
    if (k >= 0) return this.clones[k]
    const clone = source.clone()
    this.cloneSources.push(source)
    this.clones.push(clone)
    this.baseColors.push(source.mainPass.baseColor)
    return clone
  }

  private tick(): void {
    if (this.parts.length === 0) return
    this.time += getDeltaTime()
    const wave = 0.5 + 0.5 * Math.sin(this.time * this.pulseHz * 2 * Math.PI)
    const blend = this.glowStrength * (this.minBlend + (this.maxBlend - this.minBlend) * wave)
    for (let k = 0; k < this.clones.length; k++) {
      const c = this.baseColors[k]
      const g = this.glowTint
      this.clones[k].mainPass.baseColor = new vec4(
        c.x + (g.x - c.x) * blend,
        c.y + (g.y - c.y) * blend,
        c.z + (g.z - c.z) * blend,
        c.w
      )
    }
  }
}
