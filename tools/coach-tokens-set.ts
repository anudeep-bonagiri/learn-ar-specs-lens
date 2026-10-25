// ExecuteEditorCode snippet (Lens Studio editor, NOT a Lens script).
// Generates SNAP, OPENAI and GOOGLE Remote Service Gateway tokens from the
// signed-in Lens Studio account and writes them, in memory only, into the
// RemoteServiceGatewayCredentials component. DO NOT SAVE THE PROJECT while
// tokens are set: run coach-tokens-clear.ts first. Prints 6 chars at most.
const Network: any = await import('LensStudio:Network');
const model: any = pluginSystem.findInterface(Editor.Model.IModel);
const scene: any = model.project.scene;
const findCred = (): any => {
  const walk = (o: any): any => {
    for (const c of (o.components ?? [])) {
      const n = c.scriptAsset ? c.scriptAsset.name : '';
      if (n === 'RemoteServiceGatewayCredentials') return c;
    }
    for (const ch of (o.children ?? [])) { const r = walk(ch); if (r) return r; }
    return null;
  };
  for (const r of scene.rootSceneObjects) { const f = walk(r); if (f) return f; }
  return null;
};
const gen = (kind: string): Promise<string> => new Promise((resolve, reject) => {
  const req = new Network.HttpRequest();
  req.url = 'https://gcp.api.snapchat.com/smart-gate/v2/token/' + kind;
  req.method = Network.HttpRequest.Method.Post;
  Network.performAuthorizedHttpRequest(req, (resp: any) => {
    if (resp.statusCode === 200) {
      try { resolve(JSON.parse(resp.body).token); } catch (e) { reject('parse ' + kind); }
    } else { reject('HTTP ' + resp.statusCode + ' for ' + kind); }
  });
});
const [snap, openai, google] = await Promise.all([gen('SNAP'), gen('OPENAI'), gen('GOOGLE')]);
const cred = findCred();
if (!cred) return 'ERROR: RemoteServiceGatewayCredentials not found';
cred.snapToken = snap;
cred.openAIToken = openai;
cred.googleToken = google;
return 'tokens set (in memory). snap ' + snap.slice(0, 6) + '.. openai ' + openai.slice(0, 6) +
  '.. google ' + google.slice(0, 6) + '.. Clear before saving.';
