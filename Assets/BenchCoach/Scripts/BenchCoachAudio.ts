/**
 * BenchCoachAudio — the cue player. Owns the AudioComponents authored under
 * Audio/ (Zipper, Chime): sets LowLatency playback, volumes and spatialization,
 * and moves each emitter to the world position a cue should come from.
 * Must not: decide when a cue fires — RepairManager / EdgeHint call it.
 * Expects: @inputs zipper, chime (AudioComponents on child objects).
 */
@component
export class BenchCoachAudio extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachAudio – cue player</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Zipper cue (bead peel), on Audio/Zipper")
  zipper: AudioComponent

  @input
  @hint("Chime cue (far-side marker), on Audio/Chime")
  chime: AudioComponent
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Zipper volume (kept low; it retriggers per bead segment)")
  @widget(new SliderWidget(0, 1, 0.05))
  zipperVolume: number = 0.35

  @input
  @hint("Chime volume")
  @widget(new SliderWidget(0, 1, 0.05))
  chimeVolume: number = 0.4

  @input
  @hint("Play the cues from their world position (spatial audio)")
  spatial: boolean = true
  @ui.group_end

  zipperPlays: number = 0
  chimePlays: number = 0

  onAwake(): void {
    this.configure(this.zipper, this.zipperVolume)
    this.configure(this.chime, this.chimeVolume)
  }

  playZipperAt(worldPos: vec3): void {
    this.zipperPlays += 1
    this.playAt(this.zipper, worldPos)
  }

  playChimeAt(worldPos: vec3): void {
    this.chimePlays += 1
    this.playAt(this.chime, worldPos)
  }

  private configure(a: AudioComponent | null, volume: number): void {
    if (!a) return
    a.playbackMode = Audio.PlaybackMode.LowLatency
    a.volume = volume
    a.spatialAudio.enabled = this.spatial
  }

  private playAt(a: AudioComponent | null, worldPos: vec3): void {
    if (!a || !a.audioTrack) return
    a.getSceneObject().getTransform().setWorldPosition(worldPos)
    if (a.isPlaying()) a.stop(false)
    a.play(1)
  }
}
