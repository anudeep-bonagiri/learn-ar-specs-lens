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
  /** The instruction on the step callout: one short sentence (step 0 and 7 show their card instead). */
  label: string
  /**
   * Pass D2: the coach's spoken line for the step (at most 12 words, plain and calm,
   * the same meaning as the label). Exported to Assets/BenchCoach/Voice/voice-lines.json
   * as step-NN for the pre-generated clips.
   */
  voiceLine: string
  /** Idle hint (IdleHint shows it on the label after idleSec without progress). */
  hint: string
  /** True if the step has a dot on the progress rail (the cards 0, 7 and 11 do not). */
  railDot: boolean
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

/** A flat cause: where it sits in the tire, what the reveal looks like, what the cards say. */
export interface FlatCause {
  /** Short name for the Finish card ("Cause: glass shard"). */
  label: string
  /** Step label once it is found on the inspect step. */
  foundLabel: string
  /** Prevention tip on the Finish card ("Next time: ..."). */
  tip: string
  /** What's this? fact for the revealed cause. */
  fact: string
  /** Clockwise angle from 12 o'clock (deg) of the hotspot in the tire. */
  angleDeg: number
  /** Reveal shape built by ThornHotspot. */
  shape: "spike" | "shard" | "dots"
}

/** Flat causes; RepairManager.foundIt() picks one at random unless forceCause is set. */
export const FLAT_CAUSES: {[id: string]: FlatCause} = {
  thorn: {
    label: "thorn",
    foundLabel: THORN_FOUND_LABEL,
    tip: "run a hand round inside the tire before fitting a tube.",
    fact: "Thorn: went through tire and tube.",
    angleDeg: THORN_ANGLE_DEG,
    shape: "spike",
  },
  glass: {
    label: "glass shard",
    foundLabel: "Glass shard. Pick it out of the tire.",
    tip: "check the tread for glass after riding through debris.",
    fact: "Glass: a sliver cut through the tread.",
    // 8 o'clock (the thorn's mirror). Not 200: the body-locked control bar covers the
    // bottom of the wheel from the start pose, so the found label would sit behind it.
    angleDeg: 240,
    shape: "shard",
  },
  snakebite: {
    label: "snakebite",
    foundLabel: "Snakebite: two slits from a rim pinch.",
    tip: "keep the tire pumped to its rated pressure.",
    fact: "Snakebite: tube pinched on the rim.",
    angleDeg: 300,
    shape: "dots",
  },
}

export const FLAT_CAUSE_IDS: string[] = ["thorn", "glass", "snakebite"]

/** Mistake codes and the reason CoachFeedback shows on the label (short: one line on the label). */
export const MISTAKES: {[code: string]: string} = {
  beadBeforeDeflate: "Let the air out first. Pinch the valve.",
  valveAlreadyDeflated: "It's already flat. Push the beads in.",
  leverBBeforeA: "First lever first. Hook the other one.",
  leverTooFar: "Too far. Drop the tip on the ghost.",
  tubeBeforePeel: "Peel the bead off first, then the tube.",
  tubeFitMiss: "Start at the valve hole at the top.",
  inflateBeforeSeat: "Seat the bead first, or the tube pinches.",
}

/**
 * Pass 11, coach report: one "practice this next" line per mistake code, shown on
 * the Finish card for the run's most frequent mistake (RunStats.practiceTip()).
 * Short: one line on the 30 cm card.
 */
export const MISTAKE_TIPS: {[code: string]: string} = {
  beadBeforeDeflate: "Practice next: let all the air out before the beads.",
  valveAlreadyDeflated: "Practice next: once it's flat, go straight to the beads.",
  leverBBeforeA: "Practice next: hook the first lever by the valve first.",
  leverTooFar: "Practice next: lever tips. Drop each tip on the ghost.",
  tubeBeforePeel: "Practice next: peel the bead fully before the tube.",
  tubeFitMiss: "Practice next: start the new tube at the valve hole.",
  inflateBeforeSeat: "Practice next: seat every bead before you pump.",
}

/** Pass 11: short step names for the Finish card's time row (repair steps only). */
export const STEP_SHORT_NAMES: {[step: number]: string} = {
  1: "Deflate",
  2: "Loosen",
  3: "Lever A",
  4: "Peel",
  5: "Pull",
  6: "Inspect",
  7: "Halfway",
  8: "Fit tube",
  9: "Seat",
  10: "Inflate",
}

/**
 * What's this? facts. `target` is the SceneObject the pinch box follows (found by
 * name under the wheel, stand and tray); `offset` is in the target's rotated frame,
 * in cm; `size` is the box in cm (a little larger than any collider it encloses, so
 * the info box takes the ray first). `cause`: the fact text comes from the current
 * flat cause and the box exists only once it is found.
 */
export interface PartFact {
  id: string
  target: string
  title: string
  fact: string
  offset: number[]
  size: number[]
  cause?: boolean
}

export const PART_FACTS: PartFact[] = [
  {id: "Rim", target: "Wheel", title: "Rim", fact: "hoop the tire bead hooks onto.", offset: [-21.2, -21.2, 0], size: [5, 5, 3.4]},
  {id: "Hub", target: "Wheel", title: "Hub", fact: "the center. It spins on the axle.", offset: [0, 0, 0], size: [7, 7, 9]},
  {id: "Spoke", target: "Spoke_2", title: "Spoke", fact: "holds the rim true under load.", offset: [0, 0, 0], size: [4, 16, 4]},
  {id: "Tire", target: "Wheel", title: "Tire", fact: "grips the road. Beads hold it on.", offset: [29.4, 17, 0], size: [5, 5, 4.5]},
  {id: "Tube", target: "TubeEnd", title: "Tube", fact: "holds the air. Easy to puncture.", offset: [0, 0, 0], size: [8, 8, 8]},
  {id: "Valve", target: "Valve", title: "Valve", fact: "unscrew the tip, then press.", offset: [0, 0, 0], size: [6, 8, 6]},
  {id: "LeverA", target: "LeverA", title: "Lever", fact: "lifts the bead over the rim.", offset: [0, 0, 0], size: [13, 2.2, 2]},
  {id: "LeverB", target: "LeverB", title: "Lever", fact: "lifts the bead over the rim.", offset: [0, 0, 0], size: [13, 2.2, 2]},
  {id: "Stand", target: "StandPost", title: "Stand", fact: "holds the wheel at work height.", offset: [0, 0, 0], size: [8, 150, 8]},
  {id: "Cause", target: "ThornHotspot", title: "Cause", fact: "", offset: [0, 0, 0], size: [5, 5, 5], cause: true},
]

/** Rail dots: the steps with railDot, in order. */
export function railSteps(): number[] {
  return STEPS.filter((d) => d.railDot).map((d) => d.id)
}

export const STEPS: StepDef[] = [
  {
    id: 0,
    name: "Start",
    label: "Put your wheel in the stand, then pinch Found it.",
    voiceLine: "Put your wheel in the stand, then pinch Found it.",
    hint: "Pinch Found it on the card to start.",
    railDot: false,
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
    label: "Unthread the valve tip, then press it to let the air out.",
    voiceLine: "Unthread the valve tip, then press it to let the air out.",
    hint: "Pinch the brass valve at the top.",
    railDot: true,
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
    label: "Push each glowing bead toward the middle of the rim.",
    voiceLine: "Push each glowing bead toward the middle of the rim.",
    hint: "Pinch each glowing bead.",
    railDot: true,
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
    label: "Hook the first lever under the bead, on the ghost.",
    voiceLine: "Hook the first lever under the bead, on the ghost.",
    hint: "Drag a blue lever onto the ghost.",
    railDot: true,
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
    label: "Hook the second lever, then slide it round to 5 o'clock.",
    voiceLine: "Hook the second lever, then slide it round to five o'clock.",
    hint: "Hook the second lever on the ghost, then slide it down.",
    railDot: true,
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
    label: "Go round the stand, then pull the tube out at the bottom.",
    voiceLine: "Go round the stand, then pull the tube out at the bottom.",
    hint: "Grab the tube end at 6 o'clock. Pull.",
    railDot: true,
    action: "tubePull",
    markerAnchor: "tubeEnd",
    markerAngleDeg: 180,
    showStartCard: false,
    showWheel: true,
    // Pass D2: both levers are in the wheel by now, so the empty tray would only sit in the
    // downward gaze along the floor path (Back to step 4 shows it again).
    showTray: false,
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
    label: "Find the cause: look for a glint on the tire.",
    voiceLine: "Find the cause. Look for a glint on the tire.",
    hint: "Look for a glint on the tire. Pinch it.",
    railDot: true,
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
    voiceLine: "Halfway. The tube is out and the cause is found.",
    hint: "Pinch Fit the new tube to go on.",
    railDot: false,
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
    label: "Start at the valve, then feed the new tube in.",
    voiceLine: "Start at the valve, then feed the new tube in.",
    hint: "Drag the brass valve end to the top.",
    railDot: true,
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
    label: "Push the bead back over the rim with your thumbs.",
    voiceLine: "Push the bead back over the rim with your thumbs.",
    hint: "Pinch each glowing bead.",
    railDot: true,
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
    label: "Pinch and hold the valve to pump the tire up.",
    voiceLine: "Pinch and hold the valve to pump the tire up.",
    hint: "Pinch the valve and keep holding.",
    railDot: true,
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
    voiceLine: "Flat fixed. The wheel is ready to ride.",
    hint: "Pinch Start over to go again.",
    railDot: false,
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

/**
 * Pass 12, Ask the coach: preset questions per repair step (1..6, 8..10; the cards
 * 0, 7 and 11 have none), each with a canned answer used offline, on a timeout or
 * when AskCoach.forceCanned is set. Answers are one or two short sentences,
 * paraphrasing the Park Tool tube-repair procedure.
 */
export interface CoachQuestion {
  q: string
  a: string
}

export const COACH_QUESTIONS: {[step: number]: CoachQuestion[]} = {
  1: [
    {q: "Why unthread the tip?", a: "A Presta valve has a small lock nut on its tip. Unthread it a few turns, then press it to let the air out."},
    {q: "Presta or Schrader?", a: "Presta is thin with a lock nut on the tip. Schrader is wider, like a car valve, with a spring pin inside."},
    {q: "Why let all the air out?", a: "A soft tire lets the bead drop into the rim's center channel. With air in, the bead stays locked on the rim."},
  ],
  2: [
    {q: "Why push to the center?", a: "The rim's center channel is deeper, so the bead sits on a smaller circle there. That gives the slack the levers need."},
    {q: "Both sides of the tire?", a: "Yes, squeeze both beads into the channel all the way round. Then only one side has to come off."},
    {q: "What is the bead?", a: "The bead is the stiff edge of the tire. It hooks under the rim's lip and holds the tire on."},
  ],
  3: [
    {q: "How far under the bead?", a: "Just under the bead edge, scoop side up. Then hook the other end on a spoke so it stays put."},
    {q: "Can I use a screwdriver?", a: "No. Metal tools scratch the rim and can cut the tube. Plastic tire levers are made for this."},
    {q: "Why hook it on a spoke?", a: "The spoke holds the lever and keeps the bead lifted. Your hand is free for the second lever."},
  ],
  4: [
    {q: "Why a second lever?", a: "One lever lifts only a short stretch of bead. A second one a few cm along frees enough to slide round."},
    {q: "Why slide it round?", a: "Sliding the lever along the rim unzips the bead. Once a good stretch is off, the rest comes free easily."},
    {q: "Only one side comes off?", a: "Yes. With one bead off, the tube can come out. The other side can stay on the rim."},
  ],
  5: [
    {q: "Why start opposite the valve?", a: "The valve end is held by the rim. Starting opposite gives slack so the tube slides out without tearing at the valve."},
    {q: "When does the valve come out?", a: "Last. Once the rest of the tube is out, push the valve up through the rim hole."},
    {q: "Keep the tube lined up?", a: "Yes, it helps. The hole in the tube points to the spot on the tire where the cause is."},
  ],
  6: [
    {q: "How do I check the tire?", a: "Run your fingers slowly round the inside of the tire and look over the tread. Feel for anything sharp."},
    {q: "Why find the cause?", a: "Whatever made the flat may still be in the tire. Leave it there and the new tube goes flat too."},
    {q: "What is a snakebite?", a: "Two small slits side by side. The tube got pinched against the rim, often from low pressure."},
  ],
  8: [
    {q: "Why start at the valve?", a: "Put the valve through the rim hole first. The rest of the tube then tucks in evenly from there."},
    {q: "Why a little air first?", a: "A tube with a bit of air keeps its round shape. It is less likely to twist or get pinched."},
    {q: "Does tire direction matter?", a: "Many tires have an arrow on the sidewall. Point it the way the wheel turns."},
  ],
  9: [
    {q: "Why thumbs, not levers?", a: "Levers can pinch the new tube against the rim. Thumbs are safer for putting the bead back."},
    {q: "Where do I finish?", a: "Finish at the valve. Push the valve up into the tire so the bead can seat under it."},
    {q: "What should I check?", a: "Look round both sides for tube showing under the bead. A caught tube can burst when you pump."},
  ],
  10: [
    {q: "How hard should it be?", a: "Pump to the pressure printed on the tire sidewall. It is a range; stay inside it."},
    {q: "Why pump slowly at first?", a: "Add a little air and check the bead line is even all round. Then pump up to full pressure."},
    {q: "Anything after pumping?", a: "On a Presta valve, thread the lock nut on the tip back down, then put the cap on."},
  ],
}

/** The step's preset questions ([] on the cards). */
export function coachQuestions(step: number): CoachQuestion[] {
  return COACH_QUESTIONS[step] ? COACH_QUESTIONS[step] : []
}

/**
 * Pass D2, voice-ready text: the lines the voice coach will speak (pre-generated clips,
 * next pass). Plain and calm, at most 12 words each. Steps speak their `voiceLine`, a
 * mistake its MISTAKES reason, an idle hint the step's `hint`; these are the rest.
 */
export const VOICE_FLOOR_FOUND = "Floor found. You're ready to start."
export const VOICE_HALFWAY = "Nice work, you're halfway. Next, fit the new tube."
export const VOICE_FINISH = "Flat fixed. Nice work, the wheel is ready to ride."

export interface VoiceLine {
  id: string
  text: string
}

function pad2(n: number): string {
  return n < 10 ? `0${n}` : `${n}`
}

/**
 * Every voice line with its stable id: step-01..step-10, mistake-<code>,
 * idle-step-NN, floor-found, halfway, finish. Assets/BenchCoach/Voice/voice-lines.json
 * is this list: tools/export-voice-lines.py writes it from this file and fails if a
 * line runs over 12 words.
 */
export function voiceLines(): VoiceLine[] {
  const out: VoiceLine[] = []
  for (const def of STEPS) {
    if (def.id >= 1 && def.id <= LAST_STEP - 1) out.push({id: `step-${pad2(def.id)}`, text: def.voiceLine})
  }
  for (const code of Object.keys(MISTAKES)) out.push({id: `mistake-${code}`, text: MISTAKES[code]})
  for (const def of STEPS) {
    if (def.id >= 1 && def.id <= LAST_STEP - 1) out.push({id: `idle-step-${pad2(def.id)}`, text: def.hint})
  }
  out.push({id: "floor-found", text: VOICE_FLOOR_FOUND})
  out.push({id: "halfway", text: VOICE_HALFWAY})
  out.push({id: "finish", text: VOICE_FINISH})
  return out
}
