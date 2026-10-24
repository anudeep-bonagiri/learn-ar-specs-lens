/**
 * WheelMath — shared wheel geometry helpers (no component, no state).
 * Owns: the bead-offset rule (Bead_i moves radially along its mid angle,
 * i * 45 + 22.5 degrees clockwise from 12 o'clock) and a direct-child lookup.
 * Used by RepairManager (loosen, lift, peel) and RefitSteps (seat).
 */

/** Sweep of one bead segment in degrees. */
export const BEAD_SWEEP_DEG = 45

/** Mid angle of Bead_i, in degrees clockwise from 12 o'clock. */
export function beadMidDeg(i: number): number {
  return i * BEAD_SWEEP_DEG + BEAD_SWEEP_DEG / 2
}

/** Local offset of Bead_i for a radial shift in cm (positive = outward, away from the hub). */
export function beadOffset(i: number, radialCm: number): vec3 {
  const mid = (beadMidDeg(i) * Math.PI) / 180
  return new vec3(Math.sin(mid) * radialCm, Math.cos(mid) * radialCm, 0)
}

/** Direct child of `parent` named `name`, or null. */
export function findChild(parent: SceneObject, name: string): SceneObject | null {
  if (!parent) return null
  const n = parent.getChildrenCount()
  for (let c = 0; c < n; c++) {
    const child = parent.getChild(c)
    if (child.name === name) return child
  }
  return null
}

/** Bead_i under the tire group, or null. */
export function findBead(tire: SceneObject, i: number): SceneObject | null {
  return findChild(tire, `Bead_${i}`)
}

/** Set Bead_i's local position to a radial shift of radialCm (0 = seated / home). */
export function setBeadOffset(tire: SceneObject, i: number, radialCm: number): void {
  const bead = findBead(tire, i)
  if (bead) bead.getTransform().setLocalPosition(beadOffset(i, radialCm))
}
