/**
 * BenchCoachAudio — the cue player. Owns the AudioComponents authored under
 * Audio/ (Zipper, Chime, Tick, Click, Nope, Done, Hiss, Pump, Finish): sets LowLatency playback, volumes and spatialization,
 * and moves each emitter to the world position a cue should come from.
 * Must not: decide when a cue fires — RepairManager / EdgeHint / UIBindings call it.
 * Pump is the one loop: startPumpAt() loops it while the valve is held, stopPump() ends it.
 * Expects: @inputs zipper, chime, tick, click, nope, done, hiss, pump, finish (AudioComponents on child objects).
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

  @input
  @hint("Tick cue (any button), on Audio/Tick")
  tick: AudioComponent

  @input
  @hint("Click cue (lever snaps into its socket), on Audio/Click")
  click: AudioComponent

  @input
  @hint("Nope cue (lever released far from the socket), on Audio/Nope")
  nope: AudioComponent

  @input
  @hint("Done cue (repair finished), on Audio/Done")
  done: AudioComponent

  @input
  @hint("Hiss cue (valve pressed on the deflate step), on Audio/Hiss")
  hiss: AudioComponent

  @input
  @hint("Pump loop (valve held on the inflate step), on Audio/Pump")
  @allowUndefined
  pump: AudioComponent

  @input
  @hint("Finish cue (flat fixed, step 11), on Audio/Finish")
  @allowUndefined
  finish: AudioComponent
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
  @hint("Tick volume (quietest: it plays on every button)")
  @widget(new SliderWidget(0, 1, 0.05))
  tickVolume: number = 0.25

  @input
  @hint("Click and nope volume")
  @widget(new SliderWidget(0, 1, 0.05))
  feedbackVolume: number = 0.4

  @input
  @hint("Done volume")
  @widget(new SliderWidget(0, 1, 0.05))
  doneVolume: number = 0.45

  @input
  @hint("Hiss volume (quiet air release)")
  @widget(new SliderWidget(0, 1, 0.05))
  hissVolume: number = 0.35

  @input
  @hint("Pump loop volume")
  @widget(new SliderWidget(0, 1, 0.05))
  pumpVolume: number = 0.4

  @input
  @hint("Finish cue volume")
  @widget(new SliderWidget(0, 1, 0.05))
  finishVolume: number = 0.5

  @input
  @hint("Play the cues from their world position (spatial audio)")
  spatial: boolean = true
  @ui.group_end

  zipperPlays: number = 0
  chimePlays: number = 0
  tickPlays: number = 0
  clickPlays: number = 0
  nopePlays: number = 0
  donePlays: number = 0
  hissPlays: number = 0
  pumpPlays: number = 0
  finishPlays: number = 0
  pumping: boolean = false

  onAwake(): void {
    this.configure(this.zipper, this.zipperVolume)
    this.configure(this.chime, this.chimeVolume)
    this.configure(this.tick, this.tickVolume)
    this.configure(this.click, this.feedbackVolume)
    this.configure(this.nope, this.feedbackVolume)
    this.configure(this.done, this.doneVolume)
    this.configure(this.hiss, this.hissVolume)
    this.configure(this.pump, this.pumpVolume)
    this.configure(this.finish, this.finishVolume)
  }

  playZipperAt(worldPos: vec3): void {
    this.zipperPlays += 1
    this.playAt(this.zipper, worldPos)
  }

  playChimeAt(worldPos: vec3): void {
    this.chimePlays += 1
    this.playAt(this.chime, worldPos)
  }

  playTickAt(worldPos: vec3): void {
    this.tickPlays += 1
    this.playAt(this.tick, worldPos)
  }

  playClickAt(worldPos: vec3): void {
    this.clickPlays += 1
    this.playAt(this.click, worldPos)
  }

  playNopeAt(worldPos: vec3): void {
    this.nopePlays += 1
    this.playAt(this.nope, worldPos)
  }

  playDoneAt(worldPos: vec3): void {
    this.donePlays += 1
    this.playAt(this.done, worldPos)
  }

  playHissAt(worldPos: vec3): void {
    this.hissPlays += 1
    this.playAt(this.hiss, worldPos)
  }

  playFinishAt(worldPos: vec3): void {
    this.finishPlays += 1
    this.playAt(this.finish, worldPos)
  }

  /** Start the pump loop at the valve (counts one play per hold). */
  startPumpAt(worldPos: vec3): void {
    this.pumpPlays += 1
    this.pumping = true
    const a = this.pump
    if (!a || !a.audioTrack) return
    a.getSceneObject().getTransform().setWorldPosition(worldPos)
    if (a.isPlaying()) a.stop(false)
    a.play(-1)
  }

  stopPump(): void {
    this.pumping = false
    if (this.pump && this.pump.isPlaying()) this.pump.stop(true)
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
