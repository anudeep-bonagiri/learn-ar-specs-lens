/**
 * UIHelpers — shared UIKit composition helpers for every BenchCoach*UI module.
 * Owns: the type scale (applyTextRole), flex container/child builders, text,
 * image and icon-button builders, and the BackPlate panel skeleton.
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
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {ElementContent} from "SpectaclesUIKit.lspkg/Scripts/Components/Content/ElementContent"
import {TargetingMode} from "SpectaclesInteractionKit.lspkg/Core/Interactor/Interactor"
import {InteractorEvent} from "SpectaclesInteractionKit.lspkg/Core/Interactor/InteractorEvent"

export const LAYOUT_Z_LIFT = 0.02
export const BUTTON_LABEL_Z = 0.08
export const PANEL_CONTENT_Z = 0.6

const imageMaterial = requireAsset("../Materials/ImageMaterial.mat") as Material

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
  return container
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

export function addRowImage(parentFlex: SceneObject, texture: Texture, sizeCM: number): SceneObject {
  return flexChild(parentFlex, {w: sizeCM, h: sizeCM, name: "Icon"}, (child) => {
    imageOn(child, texture, sizeCM)
  })
}

/** Icon-only UIKit Button named `name` (LEAF finds it by this name). */
export function addIconButton(
  parentFlex: SceneObject,
  name: string,
  icon: Texture | null,
  sizeCM: number,
  onClick: () => void
): Button {
  let button: Button | null = null
  flexChild(parentFlex, {w: sizeCM, h: sizeCM, name}, (so) => {
    const btn = so.createComponent(Button.getTypeName()) as Button
    btn.onInitialized.add(() => {
      btn.size = new vec3(sizeCM, sizeCM, 1)
    })
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

/** UIKit Button with an optional leading icon and a width-budgeted raw Text label. */
export function addLabelButton(
  parentFlex: SceneObject,
  name: string,
  label: string,
  icon: Texture | null,
  widthCM: number,
  heightCM: number,
  distanceCm: number,
  onClick: () => void,
  style?: string
): Button {
  let button: Button | null = null
  flexChild(parentFlex, {w: widthCM, h: heightCM, name}, (so) => {
    const btn = so.createComponent(Button.getTypeName()) as Button
    // Optional UIKit style (e.g. "Primary"): must be set before the button initializes.
    if (style) btn.setVariant({theme: "SnapOS2", style})
    btn.onInitialized.add(() => {
      btn.size = new vec3(widthCM, heightCM, 1)
    })
    const iconSize = icon ? heightCM * 0.45 : 0
    const row = flexRow(so, widthCM - 1, heightCM - 1, {
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
      gap: icon ? 0.8 : 0,
    })
    liftInZ(row, BUTTON_LABEL_Z)
    if (icon) addRowImage(row, icon, iconSize)
    const labelW = widthCM - 1.5 - (icon ? iconSize + 0.8 : 0)
    addRowText(row, "Label", label, "Button", labelW, heightCM - 1.5, {distanceCm})
    btn.onTriggerUp.add((e) => {
      logTrigger(name, e)
      onClick()
    })
    button = btn
  })
  return button as unknown as Button
}

// ── Panel skeleton ────────────────────────────────────────────────────────────
export interface Panel {
  backPlate: BackPlate
  content: SceneObject
}

/** Canvas + BackPlate on `root`, plus a Content child lifted +0.6 cm for the layout. */
export function backPlatePanel(root: SceneObject, widthCM: number, heightCM: number): Panel {
  root.createComponent("Component.Canvas")
  const backPlate = root.createComponent(BackPlate.getTypeName()) as BackPlate
  backPlate.size = new vec2(widthCM, heightCM)
  const content = obj(root, "Content", new vec3(0, 0, PANEL_CONTENT_Z))
  return {backPlate, content}
}

/**
 * Pass 12: a text-only UIKit Button whose label changes at runtime (Ask chips).
 * Same layout as addLabelButton without an icon; returns the label Text too.
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
    const btn = so.createComponent(Button.getTypeName()) as Button
    btn.onInitialized.add(() => {
      btn.size = new vec3(widthCM, heightCM, 1)
    })
    const row = flexRow(so, widthCM - 1, heightCM - 1, {justify: FlexJustify.Center, align: FlexAlign.Center})
    liftInZ(row, BUTTON_LABEL_Z)
    text = addRowText(row, "Label", label, "Button", widthCM - 1.5, heightCM - 1.5, {distanceCm})
    btn.onTriggerUp.add((e) => {
      logTrigger(name, e)
      onClick()
    })
    button = btn
  })
  return {button: button as unknown as Button, label: text as unknown as Text}
}
