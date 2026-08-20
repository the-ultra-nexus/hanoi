# Toolchain: building & testing without the IDE

Operational notes for agents working on this repo. Domain knowledge lives in
`CONTEXT.md`; this is purely "how to build/test locally" knowledge.

## One-liner

```bash
./hvigorw test                                      # local unit tests (Hypium, previewer-run)
./hvigorw assembleHap --mode module -p product=default -p buildMode=debug
```

`./hvigorw` is a wrapper that points at the DevEco Studio bundle:
- **SDK**: `DEVECO_SDK_HOME` → `<DevEco>/Contents/sdk` — the *parent* of `default/`
  (HarmonyOS SDK components resolve as `<sdk>/default/hms/{ets,native,previewer,toolchains}`,
  discovered via `sdk-pkg.json` at `<sdk>/default/`).
- **JDK**: HAP packaging (`PackageHap`) needs `JAVA_HOME` → DevEco-bundled jbr.
  The hvigor **daemon caches env**, so a stale daemon breaks `PackageHap` with
  "Unable to locate a Java Runtime" — the wrapper always passes `--no-daemon`.

## Layout facts that trips people up

- `modelVersion` must be **identical** in `hvigor/hvigor-config.json5` and root
  `oh-package.json5` (range: 5.0.0…latest supported platform, e.g. "6.0.0").
- `runtimeOS: "HarmonyOS"` in `build-profile.json5` → SDK API fields must be
  **quoted strings** (`compatibleSdkVersion: "6.0.0(20)"`); compatible must be
  x.0.0 base; target ≤ compile, and compatible ≤ both.
- Unit tests live at `entry/src/test/*.test.ets`, import main sources by
  relative path (`../main/ets/engine/…`), and are run by the `test` task via
  the SDK **previewer**. Pass/fail is in:
  `entry/.test/default/intermediates/test/coverage_data/test_result.txt`
  (gitignored via `**/.test`).

## Acceptance: emulator

The HarmonyOS 6.x emulator images are **arm64-only for macOS** — Intel Macs
cannot run them (this machine is an Intel i5 → build/test work, emulator does
not). Human steps (image download via Device Manager, AVD create/boot, optional
signing) are captured in the reusable wizard:

```bash
scripts/setup-emulator.sh   # run on an Apple Silicon Mac or Windows host
```

## Dependencies

- `ohpm install` resolves `@ohos/hypium` (devDependency in root
  `oh-package.json5`; registry default `https://ohpm.openharmony.cn/ohpm/`).
- Everything (SDK, hvigor 6.24.3, ohpm, emulator) ships inside
  `/Applications/DevEco-Studio.app` — no standalone SDK install is needed.