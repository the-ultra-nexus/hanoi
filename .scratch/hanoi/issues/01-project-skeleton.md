# 01 — 工程骨架与空壳启动

**What to build:** 一个能在真机(Apple Silicon 主机亦可用模拟器,选型见 ADR-0001)上启动的空应用壳:工程结构就绪,单测脚手架(Hypium)能跑通一个空断言。首次建工程包含人工步骤(DevEco Studio 新建工程、真机 USB 调试与自动签名),已固化为可复用向导(`scripts/setup-real-device.sh`)。

**Blocked by:** None — can start immediately

**Status:** ready-for-agent

- [x] Hypium 单测能运行,有一例空断言通过
- [x] 规则引擎模块目录已建好,可被测试引用
- [ ] 设备可启动应用,显示空主页面 (方案已改为**真机**优先:可用 `scripts/setup-real-device.sh` 完成 USB 调试 + DevEco 自动签名 + hdc 安装/启动/校验;模拟器路径 `scripts/setup-emulator.sh` 仅 Apple Silicon 可用)

## Comments

**2026-08-20 — 实现 #01 (agent):**

- 工程骨架已落地:AppScope + entry 模块(stage 模式,modelVersion 6.0.0,runtimeOS HarmonyOS),规则引擎目录 `entry/src/main/ets/engine/hanoi.ets` 占位。
- `./hvigorw test` 跑通 Hypium 空断言(engineSkeleton/emptyAssertion,1 例通过,结果在 `entry/.test/.../test_result.txt`);`./hvigorw assembleHap` 产出 `entry-default-unsigned.hap`。
- 已固化的可复用产物:仓库根 `hvigorw` 包装脚本(自动带上 DevEco 随附 SDK/JDK 环境)、`scripts/setup-emulator.sh` 向导(见下)、`docs/agents/toolchain.md` 操作笔记。
- 模拟器验收因硬件受限未在本机完成:下载的 6.1.1 镜像是 `system-image-phone_all-arm64.zip`,Intel Mac(i5-7360U)无法引导。向导中已含硬件检测与人工步骤(Device Manager 下载镜像、建 AVD、启机、hdc 安装/启动/校验),在 Apple Silicon 机器上运行即可完成剩余勾选项。
- 注意:当前 HAP 未签名(unsigned);若模拟器拒绝安装,需先走向导第 7 阶段(DevEco 自动签名)或直接用 DevEco Run 一次生成调试签名包。

**2026-08-20 — 方案调整(agent, 用户提供真机):**

- 验收路径改为**真机优先**:新增 `scripts/setup-real-device.sh` 向导,按官方指南(ide-run-device)覆盖:手机开发者模式 → USB 调试 → MTP 连接授权 → AGC 应用(bundleName 一致)→ DevEco 自动签名(File > Project Structure > Signing Configs > Automatically generate signature,需登录 APP 管理员级华为账号)→ 自动 build/`hdc install`/启动/pidof 校验。任一宿主机(含本 Intel Mac)均可跑。
- `scripts/setup-emulator.sh` 在 Intel 分支直接引流到真机向导,不再尝试模拟器;模拟器仍作为 Apple Silicon 备选。
- `docs/agents/toolchain.md` 已更新:真机为默认验收路径,记录 hdc 路径与常用命令、自动签名写入 build-profile.json5 后 `assembleHap` 产出已签名 HAP(未签名真机报 9568320)。
- 待用户运行真机向导完成最后的勾选与真实验收。**2026-08-20 — bundleName 对齐既有 AGC 应用(agent):**
  - 用户 AGC 上已存在「汉诺塔游戏」应用,bundleName = `com.example1.hanoi`(项目 ai-gallery)。
  - 工程 bundleName 由 `com.example.hanoi` 改为 `com.example1.hanoi`(AppScope/app.json5 + 两个向导 BUNDLE 变量 + toolchain.md)。
  - 早前一次自动签名曾按旧包名签发过 profile(p7b 绑定 `com.example.hanoi`,今日到期 2027-08-20 且含设备 UDID),但 AGC 无此应用 → 视为残留;需在 DevEco 用新 bundle 重跑自动签名(File > Project Structure > Signing Configs > Sign in > Fix/Try Again)。
