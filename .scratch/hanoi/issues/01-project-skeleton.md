# 01 — 工程骨架与空壳启动

**What to build:** 一个能在模拟器上启动的空应用壳:工程结构就绪,单测脚手架(Hypium)能跑通一个空断言。首次建工程包含人工步骤(DevEco Studio 新建工程,SDK 随向导安装),建议顺路固化成可复用的向导。

**Blocked by:** None — can start immediately

**Status:** ready-for-agent

- [x] Hypium 单测能运行,有一例空断言通过
- [x] 规则引擎模块目录已建好,可被测试引用
- [ ] 模拟器可启动应用,显示空主页面 (硬件门槛:本机为 Intel Mac,6.x 模拟器镜像仅 arm64;需在 Apple Silicon Mac / Windows 上运行 `scripts/setup-emulator.sh`)

## Comments

**2026-08-20 — 实现 #01 (agent):**

- 工程骨架已落地:AppScope + entry 模块(stage 模式,modelVersion 6.0.0,runtimeOS HarmonyOS),规则引擎目录 `entry/src/main/ets/engine/hanoi.ets` 占位。
- `./hvigorw test` 跑通 Hypium 空断言(engineSkeleton/emptyAssertion,1 例通过,结果在 `entry/.test/.../test_result.txt`);`./hvigorw assembleHap` 产出 `entry-default-unsigned.hap`。
- 已固化的可复用产物:仓库根 `hvigorw` 包装脚本(自动带上 DevEco 随附 SDK/JDK 环境)、`scripts/setup-emulator.sh` 向导(见下)、`docs/agents/toolchain.md` 操作笔记。
- 模拟器验收因硬件受限未在本机完成:下载的 6.1.1 镜像是 `system-image-phone_all-arm64.zip`,Intel Mac(i5-7360U)无法引导。向导中已含硬件检测与人工步骤(Device Manager 下载镜像、建 AVD、启机、hdc 安装/启动/校验),在 Apple Silicon 机器上运行即可完成剩余勾选项。
- 注意:当前 HAP 未签名(unsigned);若模拟器拒绝安装,需先走向导第 7 阶段(DevEco 自动签名)或直接用 DevEco Run 一次生成调试签名包。