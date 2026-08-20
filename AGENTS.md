## Agent skills

### Issue tracker

Issues live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical roles map to same-named label strings. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` + `docs/adr/` at repo root. See `docs/agents/domain.md`.

## Tooling: DevEco Code delegation

`deveco` CLI (DevEco Code, OpenCode-based) owns HarmonyOS-specific operations this repo's flow agents do not: creating projects, hvigor builds, HDC deploy/run on device or Previewer, ArkTS API lookups and lint fixes.

- Delegate: `deveco run "<one explicit task>"` (default model deveco/GLM-5.1, free)
- Requires `DEVECO_HOME=/Applications/DevEco-Studio.app/Contents` (build/run features)
- Flow skills (implement → tdd → code-review) always run in this repo by the main agent — never handed to deveco
- No concurrent edits to the same files by deveco and this repo's agent