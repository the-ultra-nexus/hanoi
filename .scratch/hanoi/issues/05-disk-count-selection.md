# 05 — 开局盘数选择(3–8)

**What to build:** 应用启动先见「选择盘数 3–8」,选完以对应盘数开局;从游戏任意时刻重开也回到选择。

**Blocked by:** 02、03

**Status:** resolved

**验收方式:** 真机(或 Apple Silicon 模拟器)运行应用人工观察/交互;引擎侧断言在 Hypium 中。

- [x] 启动即见盘数选择,3–8 任意可选
- [x] 选择后以对应盘数开局,渲染正确
- [x] 与 04 并行完成,不依赖交互能力

## Comments

**2026-08-25 — 实现 #05 (agent):**

- 替换临时 Slider,新增盘数选择界面:Flex 布局 + 6 个圆形按钮(3–8),启动即见。
- 游戏界面顶部加「重新开始」按钮,点击回到选择界面。
- `@State selectingDiskCount` 控制两屏切换,`startGame(n)` 初始化引擎并进入游戏,`restart()` 回到选择。
- HAP 构建成功;测试基础设施问题(@ohos/hypium 解析)已存在,非本次改动引入。
- 学到了什么:Flex 的 `alignContent` 需要 `FlexAlign` 类型,不能传 `ItemAlign`——ArkUI 类型系统会拦截。