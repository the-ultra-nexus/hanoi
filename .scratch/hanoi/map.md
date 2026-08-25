# 汉诺塔 — map

Effort notes / decisions. Child tickets live in `issues/`.

## Decisions so far

- **ADR-0001** (`docs/adr/0001-real-device-primary-acceptance.md`): 真机为设备侧验收主路径;模拟器仅 Apple Silicon 备选。原因:DevEco 6.x macOS 模拟器镜像 arm64-only,本 Intel 开发机无法引导。
- **bundleName = `com.example1.hanoi`**(对齐用户 AGC 既有应用「汉诺塔游戏」,项目 ai-gallery)。签名走 DevEco 自动签名(debug profile,设备绑定),`build-profile.json5` 内 `signingConfig` 引用需与产物一致,否则 hvigor 产出 unsigned HAP → 真机 9568320。
- **验收纪律**:引擎侧断言在 Hypium(经 `./hvigorw test` 无头执行);设备侧仅 run/observe/interact(见各工单「验收方式」)。

## Fog

- 01 已 resolved:空壳工程真机启动 + 空页面显示;Hypium 空断言通过;引擎目录可引用。见 `issues/01-project-skeleton.md`。
- 02 已 resolved:规则引擎落地(`tryMove` / `pegs` / `moveCount` / `minMoves` / `isWon`),9 例 Hypium 全绿,变异验证可变红。测试样板确立于 `entry/src/test/LocalUnit.test.ets`。见 `issues/02-rule-engine.md`。
- 03 已 resolved:真机目视验收通过;`DiskView` / `PegView` 自定义组件拆分(学习点 ①),临时盘数滑条待 05 替换。见 `issues/03-peg-and-disk-rendering.md`。