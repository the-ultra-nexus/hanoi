# 真机作为唯一的设备侧验收路径(模拟器仅 Apple Silicon 备选)

Spec 原定"运行在 DevEco Studio 模拟器上",但 DevEco 6.x 的 HarmonyOS 模拟器镜像仅提供 arm64(本仓库开发机为 Intel Mac,无法引导);因此设备侧验收改为**真机优先**(开发者模式 + USB 调试 + DevEco 自动签名 + hdc 安装/启动/校验,任一宿主机可跑),模拟器仅作为 Apple Silicon 主机上的备选路径。

对自动签名与 USB 调试的人工一次性配置(AGC 应用、账号授权、签名写入 build-profile.json5)及其对构建产物形态的影响(签名后 `assembleHap` 产出可安装 HAP),在未来阅读向导/文档时若不知背景会感到困惑;这是一个真实的取舍,故记录。

**Status:** accepted

## Considered Options

- **模拟器优先(原方案)**:无签名负担、IDE 内一键运行;但镜像仅 arm64(约 2–3 GB),Intel Mac 无法引导,且模拟行为与真机有差异(深色主题、性能、传感器)。
- **真机优先(当前方案)**:官方文档完善的流程,任何宿主机可用;代价是需一次性人工配置(AGC 应用 bundleName 一致、华为账号自动签名、USB 授权),未签名 HAP 真机安装报 9568320。
- 两者共存,真机为默认、模拟器为 Apple Silicon 备选(取舍结果)。

## Consequences

- 每张涉及"运行/观察/交互"的工单,验收措辞统一为"在真机(或 Apple Silicon 模拟器)上验收";纯引擎工单(02)由 `./hvigorw test` 验收,无设备依赖。
- 仓库新增 `scripts/setup-real-device.sh`(真机向导)与 `scripts/setup-emulator.sh`(Apple Silicon 备选);hdc 位于 `$DEVECO_HOME/Contents/sdk/default/openharmony/toolchains/`。
- 自动签名将 signingConfigs 写入 build-profile.json5(明文存储密钥口令,仅限本机开发,不提交敏感材料;该文件可在签名后继续提交——内含路径而非密钥本体)。
- 后续若恢复模拟器为主,需 arm64 主机 + `scripts/setup-emulator.sh`,向导与工单措辞随之回退。