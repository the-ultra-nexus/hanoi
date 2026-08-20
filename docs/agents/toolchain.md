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

## Acceptance: real device (primary) or emulator

The ticket 01 acceptance that used to require the emulator can be done on a
**real phone** on any host (this Intel Mac included). Official guide:
<https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-run-device>.

```bash
scripts/setup-real-device.sh   # phone: dev mode + USB debug → MTP → AGC app →
                               # DevEco auto-sign → build/install/launch/verify
```

Essentials the guide hides:

- Phone: 设置→通用→关于手机→连点版本号 7 次开开发者模式; 开发者选项里开 USB 调试 + 允许 USB 安装.
- USB 连接后手机端选「文件传输 (MTP)」, 电脑端授权弹框勾选始终允许.
- 自动签名前提: DevEco 已登录 APP 管理员级华为账号、已连接设备、AGC 上已存在
  bundleName 一致的应用(`com.example1.hanoi`). 自动签名会把 signingConfig 'default'
  写入 `build-profile.json5` → 之后 `./hvigorw assembleHap` 产出的是**已签名** HAP,
  可被 `hdc install` 装到真机(未签名真机会报 9568320).
- hdc 在 `$DEVECO_HOME/Contents/sdk/default/openharmony/toolchains/hdc`;
  `hdc install -r <hap>`、`hdc shell aa start -a EntryAbility -b com.example1.hanoi`、
  `hdc shell pidof com.example1.hanoi` 可用于无 IDE 安装运行校验.

Emulator alternative (Apple Silicon macOS only; Intel macOS cannot boot the
arm64-only 6.x images): `scripts/setup-emulator.sh`.

## Dependencies

- `ohpm install` resolves `@ohos/hypium` (devDependency in root
  `oh-package.json5`; registry default `https://ohpm.openharmony.cn/ohpm/`).
- Everything (SDK, hvigor 6.24.3, ohpm, emulator) ships inside
  `/Applications/DevEco-Studio.app` — no standalone SDK install is needed.