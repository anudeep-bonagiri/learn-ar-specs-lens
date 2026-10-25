# Setting the Ask-the-coach tokens before a demo

"Ask the coach" calls Gemini (`gemini-2.5-flash`) through the Remote Service Gateway
(RSG). RSG needs short-lived tokens (about 1 hour) from your Snap login. Without them
the Lens still works: every chip shows its canned answer, tagged "offline".

**Never save the project while tokens are set.** They are written into the
`RemoteServiceGatewayCredentials` component (under `RemoteServiceGatewayExamples` in
the scene), and a save puts them into `Assets/Scene.scene`. Clear them first.

## Before the demo

1. Open `Specs Base Template.esproj` in Lens Studio, signed in to your Snap account.
2. Run `tools/coach-tokens-set.ts` with the `ExecuteEditorCode` MCP tool (pass the
   file as `path`). It generates the SNAP, OPENAI and GOOGLE tokens from your login
   and sets them in memory. It prints the first 6 characters of each, nothing more.
   - By hand instead: Window > Remote Service Gateway Token > Generate, then paste each
     token into the credentials component in the Inspector. The same rule applies.
3. Press Ask on the control bar, then a chip. The answer's tag reads "coach" when the
   live call worked and "offline" when it fell back (no token, no internet, an error,
   or no reply within 6 s).
4. Tokens expire after about an hour. Run step 2 again if answers turn "offline".

## Before saving or committing

1. Run `tools/coach-tokens-clear.ts` with `ExecuteEditorCode`. It puts the package
   placeholders back (`[INSERT SNAP TOKEN]`, `[INSERT OPEN AI TOKEN]`,
   `[INSERT GOOGLE TOKEN]`).
2. Save (Cmd+S, or `pluginSystem.findInterface(Editor.Model.IModel).project.save()`).
3. Run `tools/check-no-tokens.sh`. It must print `check-no-tokens: OK`; it exits 1 and
   names the file and line if a real token value is found in a tracked, untracked
   (not ignored) or staged file.

If Lens Studio autosaves or you save by accident while tokens are set: clear them,
save again, and run the check before any `git add`.
