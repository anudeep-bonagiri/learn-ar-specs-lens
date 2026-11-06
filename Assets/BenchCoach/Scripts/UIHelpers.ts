/**
 * UIHelpers — the Bench Coach design system (pass D2) and the shared UIKit
 * composition helpers for every BenchCoach*UI module.
 * Owns: the colour tokens (COLOR: one meaning each), the text roles (UIRole on top
 * of the type scale), the spacing grid (grid(d), scaled by viewing distance so every
 * panel has the same angular padding), the one plate style (makePlate: a UIKit
 * BackPlate with a thin edge), the button looks (primary / neutral, toggles latch
 * in the accent), the leader line, the card builder (buildCard), and the flex,
 * text, image and button builders.
 * Expects: Assets/BenchCoach/Materials/ImageMaterial.mat (ImageMaterialPreset)
 * to exist — the bootstrap creates it.
 * Must not: hold any game state or know about RepairManager.
 */
import {FlexLayout} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexLayout"
import {FlexItem} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexItem"
import {
  FlexAlign,
  FlexAlignSelf,
  FlexDirection,
  FlexJustify,
} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {BackPlate} from "SpectaclesUIKit.lspkg/Scripts/BackPlate"
import {RoundedRectangle, GradientParameters} from "SpectaclesUIKit.lspkg/Scripts/Visuals/RoundedRectangle/RoundedRectangle"
import {
  RoundedRectangleVisual,
  RoundedRectangleVisualState,
} from "SpectaclesUIKit.lspkg/Scripts/Visuals/RoundedRectangle/RoundedRectangleVisual"
import {StateName} from "SpectaclesUIKit.lspkg/Scripts/Components/Element"
import {MeshKit} from "./MeshKit"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {ElementContent} from "SpectaclesUIKit.lspkg/Scripts/Components/Content/ElementContent"
import {TargetingMode} from "SpectaclesInteractionKit.lspkg/Core/Interactor/Interactor"
import {InteractorEvent} from "SpectaclesInteractionKit.lspkg/Core/Interactor/InteractorEvent"

export const LAYOUT_Z_LIFT = 0.02
export const BUTTON_LABEL_Z = 0.08
export const PANEL_CONTENT_Z = 0.6

const imageMaterial = requireAsset("../Materials/ImageMaterial.mat") as Material
const markerMaterial = requireAsset("../Materials/MarkerMat.mat") as Material

// ── Colour tokens (pass D2): one meaning each, nothing else in the UI ─────────
// The display is additive (black is transparent), so every token is light.
export const COLOR = {
  /** "Do it here": markers, the step leader line, the primary button, latched toggles. */
  accent: new vec4(0.1, 0.95, 1.0, 1),
  /** A mistake or a warning. */
  amber: new vec4(1.0, 0.72, 0.22, 1),
  /** Done. */
  green: new vec4(0.42, 0.95, 0.52, 1),
  /** Primary text. */
  text: new vec4(1, 1, 1, 1),
  /** Secondary text (light grey). */
  textSecondary: new vec4(0.76, 0.79, 0.82, 1),
  /** Neutral plate edge and the info leader (a light grey line, not a colour). */
  edge: new vec4(0.85, 0.88, 0.92, 0.38),
}

/**
 * The one plate style. Checked on screenshots in the Evening and Sunlit rooms (pass
 * D2): "dark" (a linear 0.09 to 0.26 grey) keeps the most contrast under white text;
 * on the additive display every plate is mostly see-through, so the light edge is what
 * draws the panel.
 */
export const PLATE_STYLE: "default" | "dark" | "simple" = "dark"

// ── Typography: the single source of truth for text size + weight ────────────
const FONT_SIZE_SCALE = 1.0

export type TextRole =
  | "Title1"
  | "Title2"
  | "HeadlineXL"
  | "Headline1"
  | "Headline2"
  | "Subheadline"
  | "Button"
  | "Callout"
  | "Body"
  | "Caption"

const TYPE_SCALE: Record<TextRole, {size: number; weight: number}> = {
  Title1: {size: 105, weight: 700},
  Title2: {size: 93, weight: 700},
  HeadlineXL: {size: 62, weight: 700},
  Headline1: {size: 54, weight: 700},
  Headline2: {size: 48, weight: 700},
  Subheadline: {size: 41, weight: 700},
  Button: {size: 39, weight: 500},
  Callout: {size: 39, weight: 700},
  Body: {size: 39, weight: 500},
  Caption: {size: 38, weight: 500},
}

export function roleSize(role: TextRole, distanceCm: number = 110): number {
  return TYPE_SCALE[role].size * FONT_SIZE_SCALE * (distanceCm / 110)
}

export function applyTextRole(t: Text, role: TextRole, distanceCm: number = 110): void {
  t.size = roleSize(role, distanceCm)
  ;(t as Text & {weight?: number}).weight = TYPE_SCALE[role].weight
}

/**
 * Text roles of the design system, one size each: card titles, instructions, body
 * lines (answers, card values), secondary lines (grey), button labels, and (pass V)
 * display, the big numbers on the Finish card.
 */
export type UIRole = "title" | "instruction" | "body" | "secondary" | "button" | "display"

const UI_ROLES: Record<UIRole, TextRole> = {
  title: "Title2",
  instruction: "Headline2",
  body: "Body",
  secondary: "Caption",
  button: "Subheadline",
  display: "Title1",
}

/**
 * Pass V, the type scale for video and the glasses: Text.size of each role at 110 cm
 * (it scales with the viewing distance, so every panel has the same angular size).
 * D2 used the UIKit scale (title 93, instruction 48, body 39, secondary 38, button 41);
 * in the Garage captures from the recording pose that gave body lines an x-height of
 * 0.6% of the frame height. These sizes give body and instruction lines at least 1.5%
 * (MIN_BODY_XHEIGHT_DEG) and titles at least 2.2% (MIN_TITLE_XHEIGHT_DEG); ui-layout
 * asserts both from the live eye.
 */
const UI_ROLE_SIZE: Record<UIRole, number> = {
  title: 165,
  instruction: 118,
  body: 118,
  secondary: 66,
  button: 64,
  display: 190,
}

export function uiSize(role: UIRole, distanceCm: number): number {
  return UI_ROLE_SIZE[role] * FONT_SIZE_SCALE * (distanceCm / 110)
}

/** x-height of the UI font as a fraction of Text.size's em (measured on captures, pass V: 0.40 to 0.44 depending on the role; 0.42 keeps the check on the safe side). */
export const FONT_XHEIGHT_EM = 0.42
/** The preview frame is about 36.6 degrees tall; 1.5% of it, the smallest body x-height. */
export const MIN_BODY_XHEIGHT_DEG = 0.55
/** 2.2% of the frame, the smallest title x-height. */
export const MIN_TITLE_XHEIGHT_DEG = 0.81

/** x-height in degrees of a Text seen from `distanceCm` (its size and world scale). */
export function xHeightDeg(t: Text, distanceCm: number): number {
  const s = t.getSceneObject().getTransform().getWorldScale().y
  const xh = (t.size / 43.886) * FONT_XHEIGHT_EM * s
  return (Math.atan2(xh, Math.max(1, distanceCm)) * 180) / Math.PI
}

/**
 * Pass V: plates grow with the text. A panel's D2 width (its panelWidth input) times
 * PLATE_GROW, but never wider than MAX_PLATE_DEG at its viewing distance (the recording
 * frame is about 30 degrees wide), so lines carry fewer words instead of leaving the frame.
 */
export const PLATE_GROW = 1.6
export const MAX_PLATE_DEG = 25

export function plateCm(baseCm: number, distanceCm: number): number {
  const max = 2 * distanceCm * Math.tan((MAX_PLATE_DEG * Math.PI) / 360)
  return Math.min(baseCm * PLATE_GROW, max)
}

/**
 * Pass V: keeps a clock position on one line ("5 o'clock" never breaks after the 5): the
 * space becomes a no-break space at display time, so the step texts (and the voice
 * lines exported from them) stay as written.
 */
export function keepTogether(text: string): string {
  return text.replace(/(\d) o'clock/g, "$1\u00A0o'clock")
}

/** Lines a text needs at a width in a role (estimate: 0.43 em per glyph, words kept whole; measured 0.38 to 0.40). */
export function linesFor(text: string, role: UIRole, widthCm: number, distanceCm: number): number {
  const glyph = (uiSize(role, distanceCm) / 43.886) * 0.43
  let lines = 1
  let used = 0
  for (const word of text.split(" ")) {
    const w = word.length * glyph
    const add = used === 0 ? w : used + glyph + w
    if (add > widthCm && used > 0) {
      lines += 1
      used = w
    } else used = add
  }
  return lines
}

/** Line height in cm for a role at a distance (em height x 1.3). */
export function lineCm(role: UIRole, distanceCm: number): number {
  return (uiSize(role, distanceCm) / 43.886) * 1.3
}

/** Average glyph advance in cm (0.56 em, bold-safe) for width budgets. */
export function charCm(role: UIRole, distanceCm: number): number {
  return (uiSize(role, distanceCm) / 43.886) * 0.56
}

/** The spacing grid at a viewing distance: the same angular padding on every panel. */
export interface Grid {
  k: number
  pad: number
  gap: number
  radius: number
  edge: number
}

export function grid(distanceCm: number): Grid {
  const k = distanceCm / 90
  return {k, pad: 1.1 * k, gap: 0.5 * k, radius: 1.0 * k, edge: 0.09 * k}
}

/**
 * Size in cm that spans `deg` degrees at a viewing distance. Snap's target rule (pass G,
 * carried onto D2 in pass M): a hit box at least 2 degrees, neighbours at least 1 degree apart.
 */
export function targetCm(distanceCm: number, deg: number = 2): number {
  return distanceCm * Math.tan((deg * Math.PI) / 180)
}

// ── SceneObject helpers ───────────────────────────────────────────────────────
export function obj(parent: SceneObject, name: string, position?: vec3): SceneObject {
  const so = global.scene.createSceneObject(name)
  so.setParent(parent)
  if (position) so.getTransform().setLocalPosition(position)
  return so
}

export function liftInZ(so: SceneObject, zOffset: number): void {
  const tr = so.getTransform()
  const p = tr.getLocalPosition()
  tr.setLocalPosition(new vec3(p.x, p.y, p.z + zOffset))
}

export interface FlexOpts {
  gap?: number
  padY?: number
  padX?: number
  justify?: FlexJustify
  align?: FlexAlign
}

export function makeFlex(
  parent: SceneObject,
  direction: FlexDirection,
  width: number,
  height: number,
  opts?: FlexOpts
): SceneObject {
  const container = obj(parent, "Flex")
  liftInZ(container, LAYOUT_Z_LIFT)
  const flex = container.createComponent(FlexLayout.getTypeName()) as FlexLayout
  flex.autoDiscoverItemsOnStart = false
  const item = container.createComponent(FlexItem.getTypeName()) as FlexItem
  if (width > 0) item.overrideWidth = width
  if (height > 0) item.overrideHeight = height
  flex.onInitialized.add(() => {
    flex.width = width
    flex.height = height
    flex.direction = direction
    if (direction === FlexDirection.Row) {
      flex.columnGap = opts?.gap ?? 0
    } else {
      flex.rowGap = opts?.gap ?? 0
    }
    flex.paddingTop = opts?.padY ?? 0
    flex.paddingBottom = opts?.padY ?? 0
    flex.paddingLeft = opts?.padX ?? 0
    flex.paddingRight = opts?.padX ?? 0
    flex.justifyContent = opts?.justify ?? FlexJustify.Start
    flex.alignItems = opts?.align ?? FlexAlign.Stretch
  })
  hideUntilLaidOut(container, flex, parent)
  return container
}

/**
 * Pass P: UIKit's FlexLayout runs its first layout from OnStartEvent, in the next
 * LateUpdate. A panel that is off at Lens start (the step callout, the cards, What's
 * this?, Ask) starts on the frame it first shows, so for that one frame every child sat
 * at the column's centre: the kicker "Step 2 of 10" was drawn over the instruction (the
 * "doubled text" in the pass R footage). The container stays at zero scale until its
 * first layout is done. Only when no parent flex owns its scale (a FlexItem's scale is
 * set by the parent's layout pass).
 */
function hideUntilLaidOut(container: SceneObject, flex: FlexLayout, parent: SceneObject): void {
  if (parent.getComponent(FlexLayout.getTypeName())) return
  const tr = container.getTransform()
  const scale = tr.getLocalScale()
  tr.setLocalScale(vec3.zero())
  let shown = false
  flex.onLayoutComplete.add(() => {
    if (shown) return
    shown = true
    tr.setLocalScale(scale)
  })
}

export function flexColumn(parent: SceneObject, w: number, h: number, opts?: FlexOpts): SceneObject {
  return makeFlex(parent, FlexDirection.Column, w, h, opts)
}

export function flexRow(parent: SceneObject, w: number, h: number, opts?: FlexOpts): SceneObject {
  return makeFlex(parent, FlexDirection.Row, w, h, opts)
}

export function flexChild(
  parent: SceneObject,
  size: {w?: number; h?: number; grow?: number; stretch?: boolean; name?: string},
  builder: (child: SceneObject) => void
): SceneObject {
  const child = obj(parent, size.name ?? "Item")
  liftInZ(child, LAYOUT_Z_LIFT)
  const item = child.createComponent(FlexItem.getTypeName()) as FlexItem
  if (size.w !== undefined && size.w > 0) item.overrideWidth = size.w
  if (size.h !== undefined && size.h > 0) item.overrideHeight = size.h
  if (size.stretch) item.alignSelf = FlexAlignSelf.Stretch
  item.flexGrow = size.grow ?? 0
  item.flexShrink = 0
  builder(child)
  const parentFlex = parent.getComponent(FlexLayout.getTypeName()) as FlexLayout | null
  if (parentFlex) parentFlex.addItems([item])
  return child
}

// ── Text ─────────────────────────────────────────────────────────────────────
export interface TextOpts {
  color?: vec4
  align?: HorizontalAlignment
  distanceCm?: number
}

/** Attach a Text to an existing SceneObject with a row-style rect (widthCM x heightCM). */
export function textOn(
  so: SceneObject,
  text: string,
  role: TextRole,
  widthCM: number,
  heightCM: number,
  opts?: TextOpts
): Text {
  const t = so.createComponent("Component.Text") as Text
  t.text = text
  t.depthTest = true
  applyTextRole(t, role, opts?.distanceCm ?? 110)
  t.horizontalAlignment = opts?.align ?? HorizontalAlignment.Center
  t.verticalAlignment = VerticalAlignment.Center
  t.horizontalOverflow = HorizontalOverflow.Overflow
  t.verticalOverflow = VerticalOverflow.Overflow
  t.layoutRect = Rect.create(-widthCM / 2, widthCM / 2, -heightCM / 2, heightCM / 2)
  if (opts?.color) t.textFill.color = opts.color
  return t
}

export interface UITextOpts {
  color?: vec4
  align?: HorizontalAlignment
  /** Wrap onto more lines inside the rect (default: one line). */
  wrap?: boolean
}

/**
 * Design-system text: a role, a rect that never lets a glyph out (one line shrinks to
 * fit its width; wrapped text shrinks to fit its height), secondary text in grey.
 */
export function uiTextOn(
  so: SceneObject,
  text: string,
  role: UIRole,
  widthCM: number,
  heightCM: number,
  distanceCm: number,
  opts?: UITextOpts
): Text {
  const t = textOn(so, text, UI_ROLES[role], widthCM, heightCM, {
    distanceCm,
    align: opts?.align ?? HorizontalAlignment.Left,
    color: opts?.color ?? (role === "secondary" ? COLOR.textSecondary : COLOR.text),
  })
  t.size = uiSize(role, distanceCm)
  if (opts?.wrap) {
    t.horizontalOverflow = HorizontalOverflow.Wrap
    t.verticalOverflow = VerticalOverflow.Shrink
  } else {
    t.horizontalOverflow = HorizontalOverflow.Shrink
    t.verticalOverflow = VerticalOverflow.Truncate
  }
  return t
}

/** A design-system text row in a flex column (explicit width, so it can be left aligned). */
export function addUIText(
  parentFlex: SceneObject,
  name: string,
  text: string,
  role: UIRole,
  widthCM: number,
  heightCM: number,
  distanceCm: number,
  opts?: UITextOpts
): Text {
  let result: Text | null = null
  flexChild(parentFlex, {w: widthCM, h: heightCM, name}, (child) => {
    result = uiTextOn(child, text, role, widthCM, heightCM, distanceCm, opts)
  })
  return result as unknown as Text
}

/** A text row inside a column-direction flex: stretched to the column width. */
export function addColumnText(
  parentFlex: SceneObject,
  name: string,
  text: string,
  role: TextRole,
  heightCM: number,
  opts?: TextOpts
): Text {
  let result: Text | null = null
  flexChild(parentFlex, {h: heightCM, stretch: true, name}, (child) => {
    result = textOn(child, text, role, 1, 1, opts)
  })
  return result as unknown as Text
}

/** A text cell inside a row-direction flex: explicit width so neighbors don't overlap. */
export function addRowText(
  parentFlex: SceneObject,
  name: string,
  text: string,
  role: TextRole,
  widthCM: number,
  heightCM: number = 2.4,
  opts?: TextOpts
): Text {
  let result: Text | null = null
  flexChild(parentFlex, {w: widthCM, h: heightCM, name}, (child) => {
    result = textOn(child, text, role, widthCM, heightCM, opts)
  })
  return result as unknown as Text
}

// ── Images and buttons ────────────────────────────────────────────────────────
/** Logs which targeting path triggered a UI button (1 Direct, 2 Indirect, 4 Poke). */
function logTrigger(name: string, e: InteractorEvent): void {
  const mode = e?.interactor?.activeTargetingMode ?? TargetingMode.None
  const label = mode === TargetingMode.Indirect ? "ray" : mode === TargetingMode.Direct ? "direct pinch" : mode === TargetingMode.Poke ? "poke" : `mode ${mode}`
  print(`[UI] ${name} triggered by ${label}`)
}

/**
 * Pass F: a UI button answers only a deliberate ray pinch. UIKit's Element.initialize()
 * sets TargetingMode.All (Direct + Indirect + Poke), so a hand passing through the
 * body-locked control bar on its way to the wheel poked its buttons. Grabbable tools
 * and wheel parts keep their own targeting.
 */
export function rayOnly(btn: Button): void {
  btn.onInitialized.add(() => {
    btn.interactable.targetingMode = TargetingMode.Indirect
  })
}

export function imageOn(so: SceneObject, texture: Texture, sizeCM: number): Image {
  const img = so.createComponent("Component.Image") as Image
  const mat = imageMaterial.clone()
  mat.mainPass.baseTex = texture
  mat.mainPass.depthTest = true
  mat.mainPass.depthWrite = false
  img.clearMaterials()
  img.addMaterial(mat)
  so.getTransform().setLocalScale(new vec3(sizeCM, sizeCM, 1))
  return img
}

/**
 * Swap the leading icon of a button built by addLabelButton / addIconButton (its "Icon"
 * child's Image). Pass G3 on D2: a toggle that is on shows a different shape, not only a tint.
 */
export function setButtonIcon(button: Button | null, texture: Texture): boolean {
  if (!button) return false
  const find = (o: SceneObject): Image | null => {
    if (o.name === "Icon") {
      const img = o.getComponent("Component.Image") as Image
      if (img) return img
    }
    for (let i = 0; i < o.getChildrenCount(); i++) {
      const hit = find(o.getChild(i))
      if (hit) return hit
    }
    return null
  }
  const img = find(button.getSceneObject())
  if (!img || !img.mainMaterial) return false
  img.mainMaterial.mainPass.baseTex = texture
  return true
}

export function addRowImage(parentFlex: SceneObject, texture: Texture, sizeCM: number): SceneObject {
  return flexChild(parentFlex, {w: sizeCM, h: sizeCM, name: "Icon"}, (child) => {
    imageOn(child, texture, sizeCM)
  })
}

/** Button looks: "primary" is the one accent action on a panel; "neutral" is everything else. */
export type ButtonKind = "primary" | "neutral"

function grad(a: vec4, b: vec4): GradientParameters {
  return {
    enabled: true,
    type: "Linear",
    start: new vec2(-1.5, 1),
    end: new vec2(1.5, -1),
    stop0: {enabled: true, percent: 0, color: a},
    stop1: {enabled: true, percent: 1, color: b},
  }
}

function gray(v: number): vec4 {
  return new vec4(v, v, v, 1)
}

function tint(c: vec4, k: number): vec4 {
  return new vec4(c.x * k, c.y * k, c.z * k, 1)
}

/** Per-state look of a design-system button (UIKit RoundedRectangleVisual states). */
function buttonStates(kind: ButtonKind, edgeCm: number): Partial<Record<StateName, RoundedRectangleVisualState>> {
  const accent = COLOR.accent
  const st = (base: GradientParameters, border: vec4, size: number, z: number): RoundedRectangleVisualState => ({
    baseType: "Gradient",
    baseGradient: base,
    hasBorder: true,
    borderType: "Color",
    borderColor: border,
    borderSize: size,
    shouldPosition: true,
    shouldScale: false,
    localScale: new vec3(1, 1, 1),
    localPosition: new vec3(0, 0, z),
  })
  const latched = grad(tint(accent, 0.16), tint(accent, 0.3))
  const latchedHi = grad(tint(accent, 0.24), tint(accent, 0.4))
  if (kind === "primary") {
    return {
      default: st(grad(tint(accent, 0.18), tint(accent, 0.34)), accent, edgeCm * 1.5, 0),
      hovered: st(grad(tint(accent, 0.26), tint(accent, 0.46)), accent, edgeCm * 1.8, 0.4),
      triggered: st(grad(tint(accent, 0.36), tint(accent, 0.58)), accent, edgeCm * 1.8, 0.2),
      toggledDefault: st(latched, accent, edgeCm * 1.5, 0),
      toggledHovered: st(latchedHi, accent, edgeCm * 1.8, 0.4),
      toggledTriggered: st(latchedHi, accent, edgeCm * 1.8, 0.2),
      inactive: st(grad(gray(0.08), gray(0.12)), COLOR.edge, edgeCm, 0),
    }
  }
  return {
    default: st(grad(gray(0.1), gray(0.19)), COLOR.edge, edgeCm, 0),
    hovered: st(grad(gray(0.15), gray(0.26)), accent, edgeCm * 1.3, 0.4),
    triggered: st(grad(gray(0.22), gray(0.32)), accent, edgeCm * 1.5, 0.2),
    toggledDefault: st(latched, accent, edgeCm * 1.5, 0),
    toggledHovered: st(latchedHi, accent, edgeCm * 1.8, 0.4),
    toggledTriggered: st(latchedHi, accent, edgeCm * 1.8, 0.2),
    inactive: st(grad(gray(0.08), gray(0.12)), COLOR.edge, edgeCm, 0),
  }
}

/** A UIKit Button with the design-system look, ray-only (pass F), on `so`. */
function styledButton(so: SceneObject, kind: ButtonKind, w: number, h: number, distanceCm: number): Button {
  const btn = so.createComponent(Button.getTypeName()) as Button
  rayOnly(btn)
  const g = grid(distanceCm)
  const visual = new RoundedRectangleVisual({sceneObject: so, style: buttonStates(kind, g.edge)})
  visual.cornerRadius = Math.min(g.radius * 0.8, h / 2)
  btn.visual = visual
  btn.onInitialized.add(() => {
    btn.size = new vec3(w, h, 1)
  })
  return btn
}

/** Icon-only UIKit Button named `name` (LEAF finds it by this name). */
export function addIconButton(
  parentFlex: SceneObject,
  name: string,
  icon: Texture | null,
  sizeCM: number,
  onClick: () => void,
  distanceCm: number = 90,
  kind: ButtonKind = "neutral"
): Button {
  let button: Button | null = null
  flexChild(parentFlex, {w: sizeCM, h: sizeCM, name}, (so) => {
    const btn = styledButton(so, kind, sizeCM, sizeCM, distanceCm)
    if (icon) {
      const ec = so.createComponent(ElementContent.getTypeName()) as ElementContent
      ec.leadingIcon = icon
      ec.leadingIconSize = sizeCM * 0.5
    }
    btn.onTriggerUp.add((e) => {
      logTrigger(name, e)
      onClick()
    })
    button = btn
  })
  return button as unknown as Button
}

/** UIKit Button with an optional leading icon and a width-budgeted label (design-system look). */
export function addLabelButton(
  parentFlex: SceneObject,
  name: string,
  label: string,
  icon: Texture | null,
  widthCM: number,
  heightCM: number,
  distanceCm: number,
  onClick: () => void,
  kind: ButtonKind = "neutral"
): Button {
  let button: Button | null = null
  flexChild(parentFlex, {w: widthCM, h: heightCM, name}, (so) => {
    const btn = styledButton(so, kind, widthCM, heightCM, distanceCm)
    const iconSize = icon ? Math.min(heightCM * 0.5, lineCm("button", distanceCm) * 1.15) : 0
    const gap = icon ? grid(distanceCm).gap : 0
    const labelW = Math.min(widthCM - 2 * grid(distanceCm).pad - iconSize - gap, charCm("button", distanceCm) * (label.length + 1))
    const row = flexRow(so, widthCM - 0.5, heightCM - 0.5, {justify: FlexJustify.Center, align: FlexAlign.Center, gap})
    liftInZ(row, BUTTON_LABEL_Z)
    if (icon) addRowImage(row, icon, iconSize)
    flexChild(row, {w: labelW, h: lineCm("button", distanceCm), name: "Label"}, (child) => {
      uiTextOn(child, label, "button", labelW, lineCm("button", distanceCm), distanceCm, {align: HorizontalAlignment.Center})
    })
    btn.onTriggerUp.add((e) => {
      logTrigger(name, e)
      onClick()
    })
    button = btn
  })
  return button as unknown as Button
}

/**
 * Pass 12: a text-only UIKit Button whose label changes at runtime (Ask chips), left
 * aligned; returns the label Text too.
 */
export function addTextButton(
  parentFlex: SceneObject,
  name: string,
  label: string,
  widthCM: number,
  heightCM: number,
  distanceCm: number,
  onClick: () => void
): {button: Button; label: Text} {
  let button: Button | null = null
  let text: Text | null = null
  flexChild(parentFlex, {w: widthCM, h: heightCM, name}, (so) => {
    const btn = styledButton(so, "neutral", widthCM, heightCM, distanceCm)
    const g = grid(distanceCm)
    const row = flexRow(so, widthCM - 0.5, heightCM - 0.5, {justify: FlexJustify.Center, align: FlexAlign.Center})
    liftInZ(row, BUTTON_LABEL_Z)
    const tw = widthCM - 2 * g.pad
    flexChild(row, {w: tw, h: heightCM - 0.6, name: "Label"}, (child) => {
      text = uiTextOn(child, label, "button", tw, heightCM - 0.6, distanceCm)
    })
    btn.onTriggerUp.add((e) => {
      logTrigger(name, e)
      onClick()
    })
    button = btn
  })
  return {button: button as unknown as Button, label: text as unknown as Text}
}

// ── Plates ────────────────────────────────────────────────────────────────────
/**
 * The one plate: Canvas + UIKit BackPlate (PLATE_STYLE) with the grid's corner radius
 * and a thin edge (neutral by default; setEdge() turns it amber for a mistake or pulses
 * it in the accent for a hint), plus a Content child lifted +0.6 cm for the layout.
 */
export class Plate {
  backPlate: BackPlate
  content: SceneObject
  width: number
  height: number
  g: Grid
  private rect: RoundedRectangle | null = null
  private edgeColor: vec4

  constructor(root: SceneObject, widthCM: number, heightCM: number, distanceCm: number, edge: vec4 = COLOR.edge) {
    this.width = widthCM
    this.height = heightCM
    this.g = grid(distanceCm)
    this.edgeColor = edge
    root.createComponent("Component.Canvas")
    this.backPlate = root.createComponent(BackPlate.getTypeName()) as BackPlate
    this.backPlate.style = PLATE_STYLE
    this.backPlate.size = new vec2(widthCM, heightCM)
    this.content = obj(root, "Content", new vec3(0, 0, PANEL_CONTENT_Z))
    this.backPlate.onInitialized.add(() => {
      this.rect = root.getComponent(RoundedRectangle.getTypeName()) as RoundedRectangle
      if (!this.rect) return
      this.rect.cornerRadius = Math.min(this.g.radius, heightCM / 2)
      this.rect.border = true
      this.rect.borderSize = this.g.edge
      this.rect.borderColor = this.edgeColor
    })
  }

  /** Pass P: a new plate height in cm (the step callout grows by its hint line). */
  setHeight(h: number): void {
    if (Math.abs(h - this.height) < 1e-3) return
    this.height = h
    this.backPlate.size = new vec2(this.width, h)
    if (this.rect) this.rect.cornerRadius = Math.min(this.g.radius, h / 2)
  }

  /** Edge colour (COLOR.edge, COLOR.amber, the accent at any alpha). */
  setEdge(c: vec4): void {
    this.edgeColor = c
    if (this.rect) this.rect.borderColor = c
  }

  /** Corner radius in cm (a pill uses height / 2). */
  setRadius(r: number): void {
    this.backPlate.onInitialized.add(() => {
      if (this.rect) this.rect.cornerRadius = r
    })
    if (this.rect) this.rect.cornerRadius = r
  }

  setSize(widthCM: number, heightCM: number): void {
    this.width = widthCM
    this.height = heightCM
    this.backPlate.size = new vec2(widthCM, heightCM)
  }
}

export function makePlate(root: SceneObject, widthCM: number, heightCM: number, distanceCm: number, edge?: vec4): Plate {
  return new Plate(root, widthCM, heightCM, distanceCm, edge)
}

// ── Panel skeleton (kept for older callers) ──────────────────────────────────
export interface Panel {
  backPlate: BackPlate
  content: SceneObject
}

/** Canvas + BackPlate on `root` (the design-system plate at 90 cm), plus a Content child. */
export function backPlatePanel(root: SceneObject, widthCM: number, heightCM: number): Panel {
  const p = makePlate(root, widthCM, heightCM, 90)
  return {backPlate: p.backPlate, content: p.content}
}

// ── Leader line ───────────────────────────────────────────────────────────────
/**
 * A thin straight line from a panel to the thing it is about: the accent for the step
 * callout ("do it here"), light grey for an info callout. A unit box along +Z,
 * stretched and turned each frame by set(a, b).
 */
export class LeaderLine {
  so: SceneObject
  private tr: Transform
  private thickness: number

  constructor(parent: SceneObject, name: string, thicknessCm: number, color: vec4 | null) {
    this.so = obj(parent, name)
    this.tr = this.so.getTransform()
    this.thickness = thicknessCm
    const kit = new MeshKit()
    kit.box(new vec3(0, 0, 0.5), new vec3(0.5, 0.5, 0.5), vec3.right(), vec3.up(), new vec3(0, 0, 1))
    let mat = markerMaterial
    if (color) {
      mat = markerMaterial.clone()
      mat.mainPass.baseColor = color
    }
    kit.toVisual(this.so, null, mat)
    this.so.enabled = false
  }

  /** Draw from a to b (world cm); hides itself when the two are closer than 0.5 cm. */
  set(a: vec3, b: vec3): void {
    const d = b.sub(a)
    const len = d.length
    if (len < 0.5) {
      this.setEnabled(false)
      return
    }
    this.tr.setWorldPosition(a)
    this.tr.setWorldRotation(quat.rotationFromTo(new vec3(0, 0, 1), d.uniformScale(1 / len)))
    this.tr.setWorldScale(new vec3(this.thickness, this.thickness, len))
    this.setEnabled(true)
  }

  setEnabled(on: boolean): void {
    if (this.so.enabled !== on) this.so.enabled = on
  }
}

/**
 * The point on a billboarded plate's edge nearest to `target` (plate center `c`,
 * right vector `right`, world up), for a leader line's start.
 */
export function plateEdgePoint(c: vec3, right: vec3, w: number, h: number, target: vec3): vec3 {
  const d = target.sub(c)
  const x = d.dot(right)
  const y = d.y
  const hx = w / 2
  const hy = h / 2
  // Scale the direction onto the rectangle's border.
  const sx = Math.abs(x) > 1e-4 ? hx / Math.abs(x) : Number.POSITIVE_INFINITY
  const sy = Math.abs(y) > 1e-4 ? hy / Math.abs(y) : Number.POSITIVE_INFINITY
  const s = Math.min(sx, sy, 1)
  return c.add(right.uniformScale(x * s)).add(new vec3(0, y * s, 0))
}

// ── Card ──────────────────────────────────────────────────────────────────────
export interface CardRow {
  name: string
  text: string
  role: UIRole
  color?: vec4
  /** Lines the row can hold (wraps beyond one). */
  lines?: number
}

export interface CardPair {
  /** Name of the value Text (tests find it); the label Text is `${name}Label`. */
  name: string
  label: string
  value: string
}

export interface CardButton {
  name: string
  label: string
  icon: Texture | null
  kind: ButtonKind
  width: number
  onClick: () => void
}

/** Pass V: a big number with its caption under it (the Finish card's time and counts). */
export interface CardStat {
  /** Name of the number Text (tests find it); the caption Text is `${name}Label`. */
  name: string
  label: string
  value: string
  /** Share of the row's width (default 1). */
  weight?: number
}

export interface CardSpec {
  /** The D2 width; the card grows it with plateCm (pass V). */
  width: number
  distanceCm: number
  title: {name: string; text: string; kicker?: {name: string; text: string; color: vec4}}
  rows: CardRow[]
  /** Pass V: a row of big numbers with captions, under the title. */
  stats?: CardStat[]
  pairs?: CardPair[]
  rowsAfter?: CardRow[]
  buttons: CardButton[]
}

export interface Card {
  plate: Plate
  texts: {[name: string]: Text}
  width: number
  height: number
}

/**
 * The card component (start, halfway and finish cards): an optional kicker, a title,
 * rows, a tidy two-column list (label grey, value white), more rows, and a button row.
 * Height comes from the content, so no text ever touches the plate edge.
 */
export function buildCard(root: SceneObject, spec: CardSpec): Card {
  const d = spec.distanceCm
  const g = grid(d)
  const width = plateCm(spec.width, d)
  const innerW = width - 2 * g.pad * 1.3
  const btnH = Math.max(4.4 * (d / 80), lineCm("button", d) * 2.6)
  // Pass V: a row holds as many lines as its text needs at this width (never fewer than asked).
  const lines = (r: CardRow) => Math.max(r.lines ?? 1, linesFor(r.text, r.role, innerW, d))
  const rowH = (r: CardRow) => lineCm(r.role, d) * lines(r)
  const pairs = spec.pairs ?? []
  const labelW = innerW * 0.34
  const valueW = innerW - labelW - g.gap
  const pairLines = (p: CardPair) => linesFor(p.value, "body", valueW, d)
  const pairH = (p: CardPair) => lineCm("body", d) * pairLines(p)
  const listH = pairs.reduce((a, p) => a + pairH(p), 0) + Math.max(0, pairs.length - 1) * g.gap * 0.4
  const stats = spec.stats ?? []
  const statH = lineCm("display", d) + lineCm("secondary", d)
  const items: number[] = []
  if (spec.title.kicker) items.push(lineCm("secondary", d))
  items.push(lineCm("title", d))
  for (const r of spec.rows) items.push(rowH(r))
  if (stats.length > 0) items.push(statH)
  if (pairs.length > 0) items.push(listH)
  for (const r of spec.rowsAfter ?? []) items.push(rowH(r))
  items.push(btnH)
  let h = 2 * g.pad * 1.3 + items.reduce((a, b) => a + b, 0) + (items.length - 1) * g.gap
  h += g.gap // the button row breathes a little more
  const plate = makePlate(root, width, h, d)
  const col = flexColumn(plate.content, width, h, {
    gap: g.gap,
    padX: g.pad * 1.3,
    padY: g.pad * 1.3,
    justify: FlexJustify.Center,
    align: FlexAlign.Center,
  })
  const texts: {[name: string]: Text} = {}
  const row = (r: CardRow) => {
    texts[r.name] = addUIText(col, r.name, r.text, r.role, innerW, rowH(r), d, {color: r.color, wrap: lines(r) > 1})
    // Pass V: a wrapped row starts at its top, so a shorter text leaves no gap above it.
    if (lines(r) > 1) texts[r.name].verticalAlignment = VerticalAlignment.Top
  }
  if (spec.title.kicker) {
    const k = spec.title.kicker
    texts[k.name] = addUIText(col, k.name, k.text, "secondary", innerW, lineCm("secondary", d), d, {color: k.color})
  }
  texts[spec.title.name] = addUIText(col, spec.title.name, spec.title.text, "title", innerW, lineCm("title", d), d)
  for (const r of spec.rows) row(r)
  if (stats.length > 0) {
    // Pass V: the numbers in the display role, each with its caption under it.
    const total = stats.reduce((a, st) => a + (st.weight ?? 1), 0)
    const cellsW = innerW - (stats.length - 1) * g.gap
    flexChild(col, {w: innerW, h: statH, name: "Stats"}, (holder) => {
      const r = flexRow(holder, innerW, statH, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Start})
      for (const st of stats) {
        const cw = (cellsW * (st.weight ?? 1)) / total
        flexChild(r, {w: cw, h: statH, name: `${st.name}Cell`}, (cell) => {
          const c = flexColumn(cell, cw, statH, {gap: 0, justify: FlexJustify.Start, align: FlexAlign.Start})
          texts[st.name] = addUIText(c, st.name, st.value, "display", cw, lineCm("display", d), d)
          texts[`${st.name}Label`] = addUIText(c, `${st.name}Label`, st.label, "secondary", cw, lineCm("secondary", d), d)
        })
      }
    })
  }
  if (pairs.length > 0) {
    flexChild(col, {w: innerW, h: listH, name: "List"}, (holder) => {
      const list = flexColumn(holder, innerW, listH, {gap: g.gap * 0.4, justify: FlexJustify.Start, align: FlexAlign.Start})
      for (const p of pairs) {
        const ph = pairH(p)
        flexChild(list, {w: innerW, h: ph, name: `${p.name}Row`}, (rowSo) => {
          const r = flexRow(rowSo, innerW, ph, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Start})
          texts[`${p.name}Label`] = addUIText(r, `${p.name}Label`, p.label, "secondary", labelW, lineCm("body", d), d)
          texts[p.name] = addUIText(r, p.name, p.value, "body", valueW, ph, d, {wrap: pairLines(p) > 1})
          // Level with its label on the first line.
          if (pairLines(p) > 1) texts[p.name].verticalAlignment = VerticalAlignment.Top
        })
      }
    })
  }
  for (const r of spec.rowsAfter ?? []) row(r)
  const btnRowW = innerW
  flexChild(col, {w: btnRowW, h: btnH + g.gap, name: "Buttons"}, (holder) => {
    // At least 1 degree between the buttons (pass G: 1.6 cm at 86 cm).
    const btnGap = Math.max(g.gap * 1.5, targetCm(d, 1))
    const r = flexRow(holder, btnRowW, btnH, {gap: btnGap, justify: FlexJustify.Center, align: FlexAlign.Center})
    // The extra gap goes above the buttons, between the last line and the row.
    const rp = r.getTransform().getLocalPosition()
    r.getTransform().setLocalPosition(new vec3(rp.x, rp.y - g.gap / 2, rp.z))
    // Pass V: buttons grow with the plate, but the row always fits inside it.
    const sum = spec.buttons.reduce((a, b) => a + b.width, 0)
    const grow = Math.min(PLATE_GROW, (btnRowW - (spec.buttons.length - 1) * btnGap) / Math.max(1, sum))
    for (const b of spec.buttons) addLabelButton(r, b.name, b.label, b.icon, b.width * grow, btnH, d, b.onClick, b.kind)
  })
  return {plate, texts, width, height: h}
}
