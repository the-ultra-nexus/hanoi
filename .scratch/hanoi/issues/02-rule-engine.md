# 02 — 规则引擎:状态 / 合法移动 / 胜利 / 步数

**What to build:** 游戏的纯逻辑心脏:按盘数开局(3–8)、尝试一次移动并给出合法/非法结论、记录步数、告知最少步数与胜利状态。UI 尚未接入,它只被测试调用。

**Blocked by:** 01

**Status:** resolved

**验收方式:** Hypium 引擎测试经 `./hvigorw test` 验证(经 previewer 无头执行,无设备依赖)。

- [x] 开局(n)生成三根柱与按序堆叠的圆盘,盘数 3–8 任一可用
- [x] 尝试移动返回合法/非法;非法覆盖「大压小」「空柱取盘」等情形
- [x] 合法移动后局面正确(源柱减一、目标柱加一)
- [x] 步数随合法移动递增;最少步数 = 2ⁿ−1
- [x] 全部圆盘到齐目标柱时胜利为真,其余为假
- [x] 只测外部行为;故意改坏逻辑时测试必须变红

## Comments

- TDD 红→绿完成,9 例 Hypium 测试经 `./hvigorw test` 全绿(previewer 无头执行,无设备依赖)。接缝:`new TowerOfHanoi(n)` / `tryMove(from,to)` / `pegs` / `moveCount` / `minMoves` / `isWon`(`entry/src/main/ets/engine/hanoi.ets`,测试在 `entry/src/test/LocalUnit.test.ets`)。
- 变异验证:删掉「大压小」判定 → 2 例红;把胜利判定改成「目标柱非空即胜」 → 1 例红;恢复后全绿。满足「故意改坏逻辑时测试必须变红」。
- 学到了什么:ArkTS 编译期就把「引用不存在的成员」拦成红(比运行时断言失败更早的红);Hypium 对数组无深度相等断言,用 `join(',')` 序列化后比较最稳。