# Garage preview room

`Garage/` is a simulated room for Lens Studio's **Interactive Preview**: a home garage that Bench Coach sits in while the demo video is recorded. It is a stand-in for the user's real garage and is **not part of the Lens**. Nothing in the Lens references it, and it is not in the published Lens.

## Use it

1. Open the Preview panel's input settings, choose **Interactive**, and point the scene at this folder:
   `<this repo>/preview-room/Garage` (the full path on your machine)
   (through the MCP: `PreviewPanelTool setConfig`, inputType `Interactive`, sourcePath as above).
2. Reset the Lens with the preview camera at the start eye (0, 0, 0), looking down at the work spot for about 12 s. FloorLevel decides the floor at -165 cm (World Query).

After a project switch or a Lens Studio restart the preview can come back on a built-in room; select the folder again.

## What the folder is

An exported Lens in folder form, laid out like the built-in rooms in
`/Applications/Lens Studio.app/Contents/Resources/InteractiveResources.bundle/Scenes/`:
`scene.scn`, `metainfo.json`, `checksum.json`, `system/` and one folder per resource. 23 MB.

- `WorldTrackingMeshSimulator > meshes` holds every mesh (floor, walls, props). The preview's World Query hits come from these.
- `NavigationNodes > Start` is the start eye, 165 cm above the floor, facing -Z. `Camera` sits under it.
- `Lighting`: an envmap, a warm directional light with shadow maps, two LED shop-light points, a warm clamp-lamp point, a right-wall fill and a dim ambient.
- No scripts.

The source project is outside this repo, at `~/dev/bench-coach-garage-room/GarageRoom.esproj`. To rebuild:

1. Save the source project.
2. Copy it without its `*.lock`, `Cache/` and `Workspaces/`. The CLI refuses a project that is open in the GUI.
3. Run:
   ```
   "/Applications/Lens Studio.app/Contents/MacOS/Lens Studio" export-lens --source <copy>/GarageRoom.esproj --output <tmp> --pack Folder --include-all-platforms
   ```
4. Move `<tmp>/GarageRoom` here as `Garage`.
5. Write `checksum.json`: base64 MD5 of every file, keyed by relative path, the same format as the built-in rooms.

## What is in the room, and where it came from

The room is about 600 x 560 cm and 260 cm high.

| Item | Source |
| --- | --- |
| Shell, roll-up door frame, tracks and opener, LED bars, workbench, pegboard frame and hooks, hex keys, tire levers, chain whip, hammer, hacksaw, clamp lamp, tall cabinet, paint-can shelf, shelving and bins, floor pump, spare tires, entry door, roll carts, fire extinguisher, power strip, broom | Lens Studio's built-in Box, Cylinder, Plane and Cone meshes with Simple PBR materials, built for this room |
| Road bike, mountain bike, red tool chest, bench vise (about 30,000 triangles each) | Generated with Lens Studio's `GenerateFast3DAssets` (Fast3D) |
| Roll-up door texture, concrete base texture | Generated with Lens Studio's `GenerateTexture` (Snap's text-to-image service) |
| Floor (concrete with wear, oil stains and saw-cut joints), pegboard, butcher-block bench top | Made for this room with Python (PIL and numpy); the floor starts from the generated concrete texture |
| Wrench, pliers, two screwdrivers, utility knife, tape measure, insulating tape | Lens Studio Asset Library, **Tools Pack** v1.0.0 (Snap) |

### Licences

- **Tools Pack (Asset Library):** no licence text was found. The downloaded package contains only meshes, a texture, a material, a shader, a prefab and a descriptor whose only text is the description. The Asset Library search listing gives a name, version and download URL, but no licence. Lens Studio's documentation search could not be used: it needs a signed-in Snapchat account, and this Lens Studio was not signed in.
- **`GenerateFast3DAssets` and `GenerateTexture` output:** no licence text was found, for the same reasons. The tools' own descriptions do not state any terms.
- **Primitive meshes and the Python-made textures:** made for this room.

Check Snap's Lens Studio terms before using any of the generated or Asset Library assets outside this preview.
