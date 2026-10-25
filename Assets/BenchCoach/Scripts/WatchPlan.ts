/**
 * WatchPlan — the watch-mode script (pass 10): one beat per step, 0..11.
 * Each beat waits `waitSec` on the new step (long enough to read its label and see
 * the ghost lever on 3 and 4), then runs `action` through the step's own public
 * controls. The step's own events advance RepairManager; `actSec` is how long the
 * action normally takes, used only for the director's safety timeout.
 * Owns: timings and the action per step. Must not: touch the scene (data only).
 * Total is about 60 s from Watch to the Finish card.
 */

/**
 * none:  nothing to do (0 is started by the Watch button, 11 is the end).
 * next:  RepairManager.next() (the halfway card's Continue).
 * valve: WheelTargets.pinchValve() (hiss, deflate).
 * beads: WheelTargets.pinchBead(i) on each loosen bead in turn.
 * hookA: LeverPlacement.playPlace() on lever A (the ghost already played on entry).
 * sweep: lever B playPlace(), then RimDrag.playSweep() once it is hooked.
 * pull:  TubePull.playPull().
 * find:  ThornHotspot.flash() on entry, then findInstant().
 * demo:  RefitSteps.demo(step) (8 fit, 9 seat, 10 inflate).
 */
export type WatchAction = "none" | "next" | "valve" | "beads" | "hookA" | "sweep" | "pull" | "find" | "demo"

export interface WatchBeat {
  step: number
  waitSec: number
  action: WatchAction
  actSec: number
}

export const WATCH_BEATS: WatchBeat[] = [
  {step: 0, waitSec: 0, action: "none", actSec: 0},
  {step: 1, waitSec: 3.5, action: "valve", actSec: 0.5},
  {step: 2, waitSec: 3.5, action: "beads", actSec: 3.2},
  {step: 3, waitSec: 3.5, action: "hookA", actSec: 1.0},
  {step: 4, waitSec: 3.5, action: "sweep", actSec: 5.0},
  {step: 5, waitSec: 3.5, action: "pull", actSec: 3.5},
  {step: 6, waitSec: 3.5, action: "find", actSec: 3.0},
  {step: 7, waitSec: 4.5, action: "next", actSec: 0.2},
  {step: 8, waitSec: 3.5, action: "demo", actSec: 2.6},
  {step: 9, waitSec: 3.5, action: "demo", actSec: 2.8},
  {step: 10, waitSec: 3.5, action: "demo", actSec: 2.5},
  {step: 11, waitSec: 0, action: "none", actSec: 0},
]

/** Seconds between bead pinches on the loosen beat. */
export const WATCH_BEAD_GAP_SEC = 0.8
/** Seconds for a lever to fly from the tray into its socket. */
export const WATCH_PLACE_SEC = 0.8
/** Seconds for lever B's slide round to 5 o'clock. */
export const WATCH_SWEEP_SEC = 4.0
/** Seconds to draw the tube end out to the pull threshold. */
export const WATCH_PULL_SEC = 1.6
/** Extra seconds past actSec before the director gives up waiting and calls next(). */
export const WATCH_TIMEOUT_PAD_SEC = 8
