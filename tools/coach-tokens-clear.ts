// ExecuteEditorCode snippet (Lens Studio editor, NOT a Lens script).
// Restores the RemoteServiceGatewayCredentials token fields to the package
// placeholders. Run this BEFORE every project save.
const model: any = pluginSystem.findInterface(Editor.Model.IModel);
const scene: any = model.project.scene;
const walk = (o: any): any => {
  for (const c of (o.components ?? [])) {
    const n = c.scriptAsset ? c.scriptAsset.name : '';
    if (n === 'RemoteServiceGatewayCredentials') return c;
  }
  for (const ch of (o.children ?? [])) { const r = walk(ch); if (r) return r; }
  return null;
};
let cred: any = null;
for (const r of scene.rootSceneObjects) { cred = walk(r); if (cred) break; }
if (!cred) return 'ERROR: RemoteServiceGatewayCredentials not found';
cred.snapToken = '[INSERT SNAP TOKEN]';
cred.openAIToken = '[INSERT OPEN AI TOKEN]';
cred.googleToken = '[INSERT GOOGLE TOKEN]';
return 'tokens cleared: ' + cred.snapToken + ' / ' + cred.openAIToken + ' / ' + cred.googleToken;
