# 汉诺塔项目 ArkTS 编码规范

> 基于华为官方 ArkTS 编程规范、OpenHarmony 社区规范及中大型项目实践经验，结合本仓库已有代码约定制定。
>
> 本文件是本仓库 ArkTS 代码的唯一风格真源；任何偏离此处规则的已有代码视为待修正，而非先例。
>
> 最后更新：2025-07-27

---

## 一、术语锚定

所有代码中的命名必须使用 `CONTEXT.md` 定义的领域术语（圆盘/Disk、柱/Peg、源柱/Source peg、目标柱/Target peg、合法移动/Legal move、步数/Move count、最少步数/Minimum moves、胜利/Victory）。禁止使用同义替换（如"饼"、"杆"、"难度"、"通关"）。

---

## 二、目录与文件结构

### 2.1 当前单模块布局

```
entry/src/main/ets/
├── engine/          # 纯逻辑层（无 UI 依赖）
│   └── hanoi.ets
├── view/            # UI 组件层（自定义组件）
│   ├── DiskView.ets
│   └── PegView.ets
├── pages/           # 页面层（@Entry 入口）
│   └── Index.ets
└── entryability/    # 应用入口 Ability
    └── EntryAbility.ets
```

### 2.2 依赖方向（严格单向）

```
pages/ → view/ → engine/
                  ↑
          （engine 不依赖任何 UI 模块）
```

- `engine/` 只导出纯类与接口，不 import 任何 `@kit.ArkUI` 或组件
- `view/` 可 import `engine/` 和同层其他组件
- `pages/` 可 import `engine/`、`view/`，负责编排与状态托管
- **禁止**循环依赖和反向依赖

### 2.3 文件命名

| 类型 | 风格 | 示例 |
|------|------|------|
| 目录名 | 小写 | `engine/`, `view/`, `pages/` |
| 组件/页面文件 | PascalCase + 功能名 | `DiskView.ets`, `PegView.ets`, `Index.ets` |
| 纯逻辑文件 | camelCase（或小写） | `hanoi.ets` |
| 测试文件 | `<被测>.test.ets` | `LocalUnit.test.ets` |
| 资源/常量文件 | PascalCase | `Colors.ets`（若后续引入） |

---

## 三、命名规范

### 3.1 标识符

| 类型 | 风格 | 示例 |
|------|------|------|
| 类名、结构体名 | UpperCamelCase | `TowerOfHanoi`, `DiskView`, `PegView` |
| 枚举名 | UpperCamelCase | `PegType`（若引入） |
| 常量 | UPPER_SNAKE_CASE | `DISK_COLORS` |
| 变量、方法 | lowerCamelCase | `moveCountValue`, `tryMove()`, `onPegTap()` |
| 布尔变量 | is/has/can 前缀 | `isWon`, `selected`, `cheerAnimating` |
| 参数 | lowerCamelCase | `diskCount`, `fromPeg`, `toPeg` |

### 3.2 命名禁忌

- 禁止单字母变量（循环索引 `i/j/k` 除外）
- 禁止无惯例缩写（如 `cnt` 应写 `count`）
- 禁止中文拼音命名
- 布尔变量禁止否定前缀（`isNoError` → `isError`）
- 类名禁止使用动词（`User` 而非 `UserManager`；`Disk` 而非 `DiskCreator`）

---

## 四、格式规范

### 4.1 缩进与行宽

- **2 个空格**缩进，禁止 Tab
- 行宽不超过 **120 字符**

### 4.2 大括号

- 控制语句（`if/for/while/switch`）的执行体**必须**使用大括号
- 大括号放在声明语句**同一行**（K&R 风格）
- `else`/`catch` 放在闭括号**同一行**

```typescript
// ✅ 正例
if (moved) {
  this.pegsView = this.game.pegs;
} else {
  this.feedback = '不合法的移动';
}

// ❌ 反例
if (moved)
  this.pegsView = this.game.pegs;
```

### 4.3 空格

- 关键字与左括号之间加空格：`if (condition)`, `for (let i = 0; ...)`
- 函数名与参数列表左括号之间**不加空格**：`tryMove(fromPeg, toPeg)`
- 逗号后加空格，逗号前不加
- 一元运算符不加空格：`i++`, `!flag`
- 二元运算符两侧加空格：`a + b`, `x === y`

### 4.4 引号

- 字符串使用**单引号**：`'不合法的移动'`
- 仅在包含单引号时使用双引号

### 4.5 每行一条语句

```typescript
// ✅ 正例
let maxCount = 10;
let isCompleted = false;

// ❌ 反例
let maxCount = 10, isCompleted = false;
```

### 4.6 对象字面量

超过 4 个属性时统一换行：

```typescript
// ✅ 正例
const config: GameConfig = {
  diskCount: 3,
  targetPeg: 2,
  animateMoves: true,
  showMinMoves: true,
  theme: 'light',
};
```

---

## 五、类型规范

### 5.1 显式类型标注

所有变量、方法参数、返回值**必须**有明确类型标注，禁止 `any`。

```typescript
// ✅ 正例
private moveCountValue: number = 0;
public tryMove(fromPeg: number, toPeg: number): boolean { ... }

// ❌ 反例
private moveCountValue = 0;  // 无类型标注（非 const 场景）
```

### 5.2 数组类型

统一使用 `T[]` 语法：

```typescript
// ✅ 正例
private readonly pegsAll: Disk[][];

// ❌ 反例
private readonly pegsAll: Array<Array<Disk>>;
```

### 5.3 类属性修饰符

所有类属性**必须**声明访问修饰符：

```typescript
// ✅ 正例
class TowerOfHanoi {
  private readonly pegsAll: Disk[][];
  private moveCountValue: number = 0;

  get pegs(): Disk[][] { ... }
  get moveCount(): number { ... }
}
```

### 5.4 readonly 使用

不被重新赋值的属性声明为 `readonly`：

```typescript
export class Disk {
  public readonly size: number;  // ✅ size 一旦创建不可变

  constructor(size: number) {
    this.size = size;
  }
}
```

---

## 六、编程实践

### 6.1 浮点数

不省略小数点前后的 0：

```typescript
const opacity = 0.5;   // ✅
const opacity = .5;    // ❌
```

### 6.2 Number.NaN

必须使用 `Number.isNaN()`，禁止直接比较：

```typescript
if (Number.isNaN(value)) { ... }  // ✅
if (value === Number.NaN) { ... } // ❌
```

### 6.3 数组遍历

优先使用 `Array` 方法（`map`, `filter`, `forEach`, `reduce`）：

```typescript
// ✅ 正例
const sizes = this.disks.map(disk => disk.size);

// ❌ 反例
const sizes: number[] = [];
for (let i = 0; i < this.disks.length; i++) {
  sizes.push(this.disks[i].size);
}
```

### 6.4 控制性条件表达式

禁止在 `if/while/for/?:` 中执行赋值：

```typescript
// ❌ 反例
if (isFoo = someValue) { ... }

// ✅ 正例
const isFoo = someValue;
if (isFoo) { ... }
```

### 6.5 finally 块

`finally` 中禁止 `return/break/continue` 或抛出异常。

### 6.6 ESObject

非跨语言调用场景禁止使用 `ESObject`。

---

## 七、组件规范（UI 层）

### 7.1 组件声明

- 使用 `@Component export struct` 声明可复用组件
- 使用 `@Entry @Component struct` 声明页面入口组件
- 组件名 PascalCase + 类型后缀（`DiskView`, `PegView`）

### 7.2 组件拆分原则

| 类型 | 位置 | 行数上限 | 复用度 |
|------|------|----------|--------|
| 页面组件 | `pages/` | ≤ 500 行 | 仅路由使用 |
| UI 组件 | `view/` | ≤ 300 行 | ≥ 2 处引用 |
| 页面内片段 | `@Builder` 方法 | ≤ 50 行 | 仅本页面 |

当单个组件超过 300 行时，提取子组件或 `@Builder`。

### 7.3 状态管理原则

- **状态下推**：状态保存在最底层的使用组件
- **单一数据源**：相同状态只保存在一处
- `@State` 仅用于 `@Component/@Entry` 内部
- 父→子单向传递用 `@Prop`
- 父↔子双向绑定用 `@Link`
- 跨层级通信用 `@Provide/@Consume`
- 嵌套对象响应式用 `@Observed/@ObjectLink`

### 7.4 build() 方法

`build()` 内禁止：
- 复杂计算（移至 `aboutToAppear` 或 ViewModel）
- 网络请求
- 日志输出（`console.log`）
- 直接状态修改

`build()` 仅做 UI 描述与事件转发。

### 7.5 链式调用格式

每个属性占一行，按逻辑分组：

```typescript
Text('汉诺塔')
  .fontSize(20)
  .fontWeight(FontWeight.Bold)

Button('重新开始')
  .type(ButtonType.Normal)
  .fontSize(14)
  .height(36)
  .backgroundColor('#8D6E63')
  .fontColor('#FFFFFF')
  .borderRadius(18)
  .onClick(() => this.restart())
```

---

## 八、引擎/逻辑层规范

### 8.1 纯逻辑原则

`engine/` 目录下的文件：
- 禁止 import 任何 `@kit.*` UI Kit
- 禁止使用 `@Component`, `@State`, `@Builder` 等装饰器
- 只导出 class、interface、type、function
- 所有方法必须可独立单测

### 8.2 类设计

- 领域对象使用 `class`（带构造函数与方法）
- 纯数据传输对象使用 `interface`
- 属性显式标注 `private/public/protected`
- 不可变属性使用 `readonly`
- 通过 getter 暴露只读视图，避免直接暴露内部可变引用

```typescript
// ✅ 正例：getter 返回深拷贝，外部无法修改内部状态
get pegs(): Disk[][] {
  return this.pegsAll.map(peg => peg.slice());
}

// ❌ 反例：直接返回内部引用
get pegs(): Disk[][] {
  return this.pegsAll;
}
```

### 8.3 副作用标注

有副作用的方法（修改内部状态、I/O）在 JSDoc 中说明：

```typescript
/**
 * 尝试一次移动;合法则生效并返回 true,非法则不动局面并返回 false
 */
public tryMove(fromPeg: number, toPeg: number): boolean { ... }
```

---

## 九、注释规范

### 9.1 JSDoc

所有导出的 class、method、property 使用 `/** */` JSDoc 注释：

```typescript
/**
 * 规则引擎 —— 汉诺塔游戏逻辑的纯 ArkTS 承载处(无任何 UI 依赖)。
 *
 * 状态模型:pegs 为三根柱,每根柱是从柱底到柱顶的圆盘数组;
 * 移动 = 源柱 pop、目标柱 push,合法移动只需比较两柱顶盘大小。
 */
export class TowerOfHanoi { ... }
```

### 9.2 行内注释

- 复杂逻辑使用 `//` 行内注释解释 **为什么**，而非 **做什么**
- 工单引用使用 `(工单 XX)` 或 `(学习点 ①)` 格式（保留现有约定）
- 禁止注释掉的代码（删除或用版本控制）

### 9.3 注释语言

中文注释（与现有代码一致），专业术语可保留英文。

---

## 十、测试规范

### 10.1 测试范围

- 仅测试 `engine/` 层（唯一接缝）
- UI 层不写测试（薄转发层）
- 测试外部行为：构造、操作、查询的输入输出
- 不测内部实现细节

### 10.2 测试风格

使用 Hypium 框架：

```typescript
import { describe, it, expect } from '@ohos/hypium';
import { TowerOfHanoi } from '../main/ets/engine/hanoi';

export default function localUnitTest() {
  describe('towerOfHanoi', () => {
    it('描述行为的中文短句', 0, () => {
      let game = new TowerOfHanoi(3);
      expect(game.moveCount).assertEqual(0);
    });
  });
}
```

### 10.3 测试命名

- `describe` 使用被测类名（camelCase）
- `it` 使用描述行为的中文短句，不用技术术语
- 测试文件 `<被测>.test.ets`

### 10.4 红绿纪律

- 先写红（失败测试），再写绿（最小实现），再重构
- 测试必须在"行为坏了"时变红
- `./hvigorw test` 本地执行，无需设备

---

## 十一、import 顺序

```typescript
// 1. HarmonyOS 官方 Kit
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

// 2. 三方库
import { describe, it, expect } from '@ohos/hypium';

// 3. 项目内模块（从远到近）
import { Disk } from '../engine/hanoi';
import { DiskView } from './DiskView';
```

---

## 十二、错误处理

### 12.1 异常捕获

- 只捕获已知异常类型
- `catch` 中至少记录日志
- `finally` 中不做控制流操作

### 12.2 非法状态

引擎层对非法输入返回 `false` 而非抛异常（保持当前 `tryMove` 的模式）。

---

## 十三、性能红线

| 指标 | 目标值 |
|------|--------|
| 页面首帧渲染 | ≤ 200ms |
| 列表滑动帧率 | ≥ 55fps |
| 冷启动时间 | ≤ 1s |

### 13.1 当前适用的优化

- 长列表（若有）使用 `LazyForEach` + `reuseId`
- `ForEach` 提供唯一 key 生成函数
- 避免 `build()` 中的深拷贝或复杂计算
- `aboutToDisappear` 中清理定时器（当前 `setTimeout` 反馈）

---

## 十四、代码审查检查清单

每次提交前核对：

### 架构
- [ ] `engine/` 无任何 UI 依赖
- [ ] 依赖方向严格单向（pages → view → engine）
- [ ] 单文件不超过 500 行（页面）/ 300 行（组件）/ 800 行（逻辑）

### 命名与类型
- [ ] 所有标识符遵循命名规范
- [ ] 无 `any` 类型
- [ ] 类属性有访问修饰符
- [ ] 常量使用 UPPER_SNAKE_CASE

### 状态管理
- [ ] `@State` 仅在组件内使用
- [ ] 状态在最底层组件持有
- [ ] `build()` 内无复杂计算

### 代码质量
- [ ] 无注释掉的代码
- [ ] 导出的 class/method 有 JSDoc
- [ ] 数组使用 `T[]` 语法
- [ ] 浮点数不省略 0

### 测试
- [ ] 引擎层新行为有对应测试
- [ ] 测试描述为中文行为短句
- [ ] `./hvigorw test` 全绿

---

## 十五、演进方向

当项目规模增长时，按以下顺序引入：

1. **常量层** — 颜色、样式提取到 `common/constants/`（`DISK_COLORS` 已是事实上的常量）
2. **工具层** — 通用工具函数到 `common/utils/`
3. **业务组件层** — 通用 UI 组件到 `common/components/`（复用度 ≥ 2）
4. **模块化** — 若拆分为多 HAP/HSP，遵循单向依赖 + OHPM 发布规范

---

## 参考来源

| 来源 | 说明 |
|------|------|
| [ArkTS 编程规范 V5](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-v5/arkts-coding-style-guide-V5) | 华为官方语言级规范 |
| [OpenHarmony ArkTS 编码规范](https://gitee.com/openharmony/docs/blob/master/zh-cn/contribute/OpenHarmony-ArkTS-coding-style-guide.md) | 社区贡献指南 |
| [ArkTS 声明式开发企业级技术指南](https://www.cnblogs.com/zdt168/p/19831647) | 企业级实践总结 |
| [Clean Architecture in ArkTS](https://blog.csdn.net/2502_93949915/article/details/161696712) | 分层架构实践 |
| ["玄象"项目六层架构](https://jishuzhan.net/article/2081616619905359873) | 目录约定实践 |
| 本仓库已有代码 | `engine/hanoi.ets`, `DiskView.ets`, `PegView.ets`, `Index.ets` |
