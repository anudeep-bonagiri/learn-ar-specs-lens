/**
 * StepDefinitions — the step table for the flat-fix procedure. Steps are content,
 * not code: RepairManager reads this table to decide what to show and what
 * completes each step.
 * Owns: step ids, labels, marker anchors, visibility flags, completion action.
 * Must not: touch the scene.
 */
export type StepAction = "foundIt" | "valve" | "beads" | "leverA" | "leverB" | "tubePull" | "thorn" | "tryAgain"

/**
 * "inspect" is the search step: the label sits above the wheel and no ring is
 * shown until the thorn is found (a ring on the answer would make it a card, not a search).
 */
export type MarkerAnchor = "none" | "valve" | "bead" | "socket" | "tubeEnd" | "inspect"

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
  },
]

export const LAST_STEP = STEPS.length - 1
