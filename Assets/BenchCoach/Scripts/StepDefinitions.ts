/**
 * StepDefinitions — the step table for the flat-fix procedure (steps 0..11:
 * 0..7 take the tube out and find the cause, 7 is the halfway card, 8..10 fit the
 * new tube, seat the bead and inflate, 11 is the Finish card). Steps are content,
 * not code: RepairManager reads this table to decide what to show and what
 * completes each step.
 * Owns: step ids, labels, marker anchors, visibility flags, completion action.
 * Must not: touch the scene.
 */
export type StepAction =
  | "foundIt"
  | "valve"
  | "beads"
  | "leverA"
  | "leverB"
  | "tubePull"
  | "thorn"
  | "tryAgain"
  | "tubeFit"
  | "seat"
  | "inflate"
  | "restart"

/**
 * "inspect" is the search step: the label sits above the wheel and no ring is
 * shown until the thorn is found (a ring on the answer would make it a card, not a search).
 */
/** "module": the step's StepModule (RefitSteps) places the live ring; its tick uses tickAngleDeg. */
export type MarkerAnchor = "none" | "valve" | "bead" | "socket" | "tubeEnd" | "inspect" | "module"

export interface StepDef {
  id: number
  name: string
  /** One-line instruction shown on StepLabel (step 0 and 7 show their card instead). */
  label: string
  /** What the user must do to complete the step (Next always works too). */
  action: StepAction
  /** Where the StepMarker sits. */
  markerAnchor: MarkerAnchor
  /** Clockwise angle from 12 o'clock for bead / inspect anchors, in degrees (inspect: where the thorn is). */
  markerAngleDeg: number
  /** Where the dim tick sits once the step is done, if not at markerAngleDeg (where the work ended). */
  tickAngleDeg?: number
  showStartCard: boolean
  showWheel: boolean
  showTray: boolean
  showGhost: boolean
  /** Which socket the ghost lever animates into when showGhost is true. */
  ghostSocket: "A" | "B" | "none"
  showDoneCard: boolean
  /** Final card (step 11): time, stats, prevention tip, Restart. */
  showFinishCard: boolean
  /** The new tube coil (NewTube / NewTubeEnd) sits in the tool tray until it is fitted. */
  showNewTube: boolean
  /** Steps whose model, completion and marker belong to the StepModule (RefitSteps). */
  module: boolean
}

/**
 * The seam that keeps RepairManager the only step machine: it delegates the
 * module's steps (8..10) through the default branches of completeStep / undoStep,
 * one call in applyStep and one in markerAnchorFor.
 */
export interface StepModule {
  ownsStep(step: number): boolean
  /** Model state as if the step was done (Next / jumpToStep). */
  complete(step: number): void
  /** Back / reset: undo what completing (and entering) the step changed. */
  undo(step: number): void
  /**
   * Called on every step change (for every step, owned or not). `instant` is true on
   * Back / reset / jumpToStep so entry changes snap instead of tweening.
   */
  apply(step: number, paused: boolean, instant?: boolean): void
  markerAnchor(step: number, live: boolean): {pos: vec3; angleDeg: number; radius: number} | null
  /** True if the module replayed something itself (otherwise RepairManager chimes from the ring). */
  replay(step: number): boolean
  /** Pass 10: animate the step, return seconds. */
  demo(step: number): number
}

/** Beads lit in step 2, in the order the marker visits them (12, 3, 6, 9 o'clock). */
export const LOOSEN_BEADS: number[] = [0, 2, 4, 6]

/** Clockwise angle from 12 o'clock (deg) of the lever socket on Bead_0, next to the valve. */
export const SOCKET_ANGLE_DEG = 12

/** Bead major radius in cm; the second socket sits 5 cm further along this circle. */
export const BEAD_RADIUS_CM = 33.4

/** Clockwise angle (deg) of the second lever socket: 5 cm along the rim from socket A. */
export const SOCKET_B_ANGLE_DEG = SOCKET_ANGLE_DEG + (5 / BEAD_RADIUS_CM) * (180 / Math.PI)

/**
 * Absolute clockwise angle (deg) where the rim drag completes: lever B at 5 o'clock,
 * so Bead_1..3 lift. Not 180: lever B would park on TubeEnd's hit box and the tick
 * would stack on step 5's.
 */
export const PEEL_END_ANGLE_DEG = 150

/** Clockwise angle (deg) of the thorn in the tire: 4 o'clock. */
export const THORN_ANGLE_DEG = 120

/** Label shown on the thorn once it is found, before the Done card. */
export const THORN_FOUND_LABEL = "Thorn. Pull it out before the new tube goes in."

/** Beads lifted by the levers (Bead_0 at socket A, Bead_1..3 by the peel): step 9 seats them. */
export const SEAT_BEADS: number[] = [0, 1, 2, 3]

/**
 * Flat causes: what the Finish card names and how to prevent it. Pass 9 has the
 * thorn only; pass 8 adds the glass shard and the snakebite (with their angles).
 */
export const FLAT_CAUSES: {[id: string]: {label: string; tip: string; angleDeg: number}} = {
  thorn: {
    label: "thorn",
    tip: "run a hand round inside the tire before fitting a tube.",
    angleDeg: THORN_ANGLE_DEG,
  },
}

export const STEPS: StepDef[] = [
  {
    id: 0,
    name: "Start",
    label: "Fix a flat. Pinch Found it when your wheel is in the stand.",
    action: "foundIt",
    markerAnchor: "none",
    markerAngleDeg: 0,
    showStartCard: true,
    showWheel: false,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 1,
    name: "Deflate",
    label: "Unthread the tip and press to deflate",
    action: "valve",
    markerAnchor: "valve",
    markerAngleDeg: 0,
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 2,
    name: "Loosen the bead",
    label: "Push the bead toward the rim center",
    action: "beads",
    markerAnchor: "bead",
    markerAngleDeg: 22.5,
    tickAngleDeg: 292.5, // the last lit bead (9 o'clock side), clear of the lever sockets
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 3,
    name: "First lever",
    label: "Hook the lever under the bead",
    action: "leverA",
    markerAnchor: "socket",
    markerAngleDeg: SOCKET_ANGLE_DEG,
    showStartCard: false,
    showWheel: true,
    showTray: true,
    showGhost: true,
    ghostSocket: "A",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 4,
    name: "Second lever and peel",
    label: "Hook the second lever, then slide it round to 5 o'clock",
    action: "leverB",
    markerAnchor: "socket",
    markerAngleDeg: SOCKET_B_ANGLE_DEG,
    tickAngleDeg: 150, // the peel ends at 5 o'clock (180 would stack on step 5's tick)
    showStartCard: false,
    showWheel: true,
    showTray: true,
    showGhost: true,
    ghostSocket: "B",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 5,
    name: "Pull the tube",
    label: "Start opposite the valve. Pull the tube out.",
    action: "tubePull",
    markerAnchor: "tubeEnd",
    markerAngleDeg: 180,
    showStartCard: false,
    showWheel: true,
    showTray: true,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 6,
    name: "Inspect",
    label: "Find what caused it",
    action: "thorn",
    markerAnchor: "inspect",
    markerAngleDeg: THORN_ANGLE_DEG,
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 7,
    name: "Done",
    label: "Tube out, cause found. Ready for the new tube.",
    action: "tryAgain",
    markerAnchor: "none",
    markerAngleDeg: 0,
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: true,
    showFinishCard: false,
    showNewTube: false,
    module: false,
  },
  {
    id: 8,
    name: "Fit the new tube",
    label: "Start at the valve. Feed the new tube in.",
    action: "tubeFit",
    markerAnchor: "module",
    markerAngleDeg: 0,
    tickAngleDeg: 0, // top of the tire, 5 cm outside the deflate tick on the valve
    showStartCard: false,
    showWheel: true,
    showTray: true,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: true,
    module: true,
  },
  {
    id: 9,
    name: "Seat the bead",
    label: "Push the bead back over the rim",
    action: "seat",
    markerAnchor: "module",
    markerAngleDeg: 22.5,
    tickAngleDeg: 67.5, // Bead_1, clear of the lever-socket and peel ticks
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: true,
  },
  {
    id: 10,
    name: "Inflate",
    label: "Pinch and hold the valve to inflate",
    action: "inflate",
    markerAnchor: "module",
    markerAngleDeg: 0,
    tickAngleDeg: 330, // the valve side, clear of the deflate (valve) and fit (top) ticks
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: false,
    showNewTube: false,
    module: true,
  },
  {
    id: 11,
    name: "Done",
    label: "Flat fixed.",
    action: "restart",
    markerAnchor: "none",
    markerAngleDeg: 0,
    showStartCard: false,
    showWheel: true,
    showTray: false,
    showGhost: false,
    ghostSocket: "none",
    showDoneCard: false,
    showFinishCard: true,
    showNewTube: false,
    module: false,
  },
]

/** The halfway card: tube out, cause found (plays the Done cue). */
export const HALFWAY_STEP = 7

export const LAST_STEP = STEPS.length - 1
