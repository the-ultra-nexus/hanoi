## Agent skills

### Issue tracker

Issues live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical roles map to same-named label strings. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` + `docs/adr/` at repo root. See `docs/agents/domain.md`.

## Coding standards

**`CODING-STANDARDS.md`** at repo root is the binding coding standard for this project. Every agent that writes or reviews code must read it before starting work.

Enforcement points:

- **`/implement`** — before writing any `.ets` or `.ts` file, read `CODING-STANDARDS.md` in full. Every file produced must comply.
- **`/tdd`** — same: read the standards before the first red-green slice. Test code is code.
- **`/code-review`** — the Standards sub-agent automatically picks up `CODING-STANDARDS.md` as its primary source. No manual flag needed.
- **`/grill-with-docs`** — when the grilling surfaces design decisions that touch code shape, reference the standards to keep the idea grounded.

If a standard feels wrong for a specific case, **override it explicitly** with a comment (`// deviation: <reason>`) or record the exception as an ADR. Don't silently skip.

## Tooling: DevEco Code delegation

> **Note:** DevEco Code (`deveco`) handles HarmonyOS build/run/deploy tasks only. It does **not** own coding standards — those are enforced by this repo's flow skills (implement → tdd → code-review), which always run in-repo.

`deveco` CLI (DevEco Code, OpenCode-based) owns HarmonyOS-specific operations this repo's flow agents do not: creating projects, hvigor builds, HDC deploy/run on device or Previewer, ArkTS API lookups and lint fixes.

- Delegate: `deveco run "<one explicit task>"` (default model deveco/GLM-5.1, free)
- Requires `DEVECO_HOME=/Applications/DevEco-Studio.app/Contents` (build/run features)
- Flow skills (implement → tdd → code-review) always run in this repo by the main agent — never handed to deveco
- No concurrent edits to the same files by deveco and this repo's agent