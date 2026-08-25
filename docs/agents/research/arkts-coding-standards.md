# ArkTS 代码规范研究报告

> 调研时间：2025-07-27  
> 聚焦：中大型已实践项目的 ArkTS 代码规范、架构模式与工程化经验  
> 来源：华为官方文档、OpenHarmony 社区规范、已上线项目实战总结

---

## 一、规范来源体系

ArkTS 代码规范有三个层级的来源，形成从语言约束到工程实践的完整体系：

| 层级 | 来源 | 说明 |
|------|------|------|
| **语言级** | ArkTS 编程规范（华为官方） | 基于 TypeScript 强化静态检查，所有规则为"要求"级别 |
| **工具级** | @hw-stylistic Code Linter 规则 | DevEco Studio 内置 lint，自动检查代码风格 |
| **工程级** | 企业级项目实践总结 | 分层架构、模块化、状态管理等落地经验 |

### 1.1 官方规范文档索引

| 文档 | URL | 内容 |
|------|-----|------|
| ArkTS 编程规范 (V5) | `developer.huawei.com/.../arkts-coding-style-guide-V5` | 命名、格式、编程实践 |
| @hw-stylistic Lint 规则 | `developer.huawei.com/.../ide-hw-stylistic` | DevEco Studio 代码检查规则 |
| OpenHarmony ArkTS 编码规范 | `gitee.com/openharmony/docs/.../OpenHarmony-ArkTS-coding-style-guide.md` | 社区贡献指南 |
| 高性能编程指南 | `developer.huawei.com/.../arkts-high-performance-programming` | 性能优化红线 |
| 模块化设计最佳实践 | `developer.huawei.com/.../bpta-modular-design` | HarmonyOS 模块化架构 |

---

## 二、命名规范（语言级）

### 2.1 基本原则

- **清晰性**：名称应明确传达意图，避免单字母或无惯例缩写
- **英文使用**：使用正确英文单词和语法，禁止使用中文拼音
- **区分性**：名称应具有区分度，避免歧义

### 2.2 各类标识符命名

| 类型 | 风格 | 示例 |
|------|------|------|
| 类名、枚举名、命名空间名 | UpperCamelCase | `UserType`, `LunarCalendar`, `HeavenlyStems` |
| 变量名、方法名、参数名 | lowerCamelCase | `userName`, `getStem()`, `sendMsg()` |
| 常量名、枚举值名 | UPPER_SNAKE_CASE | `MAX_USER_SIZE`, `PRIMARY_GOLD` |
| 布尔变量 | is/has/can/should 前缀 | `isError`, `hasNext()`, `isEmpty()` |

### 2.3 布尔变量命名禁忌

```typescript
// ❌ 反例：否定前缀导致双重否定
let isNoError = true;
let isNotFound = false;
function empty() {}
function next() {}

// ✅ 正例
let isError = false;
let isFound = true;
function isEmpty() {}
function hasNext() {}
```

### 2.4 文件与目录命名（工程级）

来自"玄象"项目等已实践项目的经验：

| 类型 | 风格 | 示例 |
|------|------|------|
| 目录名 | 小写 | `mansion/`, `common/`, `utils/` |
| 文件名（.ets） | PascalCase + 功能后缀 | `MansionListPage.ets`, `GoldButton.ets` |
| 页面文件 | 功能名 + Page 后缀 | `HomePage.ets`, `ProductDetail.ets` |
| 组件文件 | 功能描述 + 类型后缀 | `BottomTabBar.ets`, `GoldBorderCard.ets` |

---

## 三、格式规范（语言级）

### 3.1 缩进

- 使用**空格缩进**，禁止使用 Tab
- 大部分场景用 **2 个空格**，换行导致的缩进用 **4 个空格**

### 3.2 行宽

- 行宽不超过 **120 个字符**
- 例外：注释中的长命令或 URL、预处理 error 信息

### 3.3 大括号规则

- `if/for/do/while` 执行体**必须使用大括号**
- 大括号放在控制语句或声明语句**同一行**
- `else` 放在 `if` 代码块关闭括号**同一行**
- `catch` 放在 `try` 代码块关闭括号**同一行**

```typescript
// ❌ 反例
if (condition)
  console.log('success');

// ✅ 正例
if (condition) {
  console.log('success');
}
```

### 3.4 空格规则

- `if` 和左括号之间加空格：`if (isJedi) {`
- 函数名和左括号之间**不加空格**：`function fight(): void {`
- `else` 与前面的 `}` 之间加空格：`} else {`
- 逗号后面加空格，逗号前面不加：`[1, 2, 3]`, `myFunc(bar, foo)`
- 每个语句只声明一个变量

### 3.5 字符串引号

建议使用**单引号**：`let message = 'world';`

### 3.6 对象字面量

超过 4 个属性时，统一换行：

```typescript
// ❌ 反例
let obj: I = { name: 'tom', age: 16, value: 1, sum: 2, foo: true, bar: false }

// ✅ 正例
let obj: I = {
  name: 'tom',
  age: 16,
  value: 1,
  sum: 2,
  foo: true,
  bar: false
}
```

---

## 四、编程实践规范（语言级）

### 4.1 类属性可访问修饰符

建议添加 `private`、`protected` 或 `public`：

```typescript
// ❌ 反例
class C {
  count: number = 0
  getCount(): number { return this.count }
}

// ✅ 正例
class C {
  private count: number = 0
  public getCount(): number { return this.count }
}
```

### 4.2 浮点数表示

不建议省略小数点前后的 0：

```typescript
const num = 0.5;   // ✅ 正例
const num = .5;    // ❌ 反例
```

### 4.3 Number.NaN 判断

必须使用 `Number.isNaN()`，禁止直接比较：

```typescript
if (Number.isNaN(foo)) { ... }  // ✅ 正例
if (foo == Number.NaN) { ... }  // ❌ 反例
```

### 4.4 数组遍历

优先使用 `Array` 对象方法（`map`, `filter`, `forEach`, `reduce` 等）：

```typescript
const increasedByOne = numbers.map(num => num + 1);  // ✅ 正例
```

### 4.5 数组类型表示

统一使用 `T[]` 语法，而非 `Array<T>`：

```typescript
let x: number[] = [1, 2, 3];    // ✅ 正例
let x: Array<number> = [1, 2, 3]; // ❌ 反例
```

### 4.6 ESObject 使用限制

非跨语言调用场景中，**避免使用 ESObject** 标注类型，直接使用具体接口类型。

### 4.7 finally 代码块

`finally` 中不要使用 `return/break/continue` 或抛出异常。

### 4.8 控制性条件表达式

不要在 `if/while/for/?:` 中执行赋值操作。

---

## 五、状态管理规范（框架级）

### 5.1 装饰器体系

ArkTS 通过装饰器实现响应式状态管理，按作用范围划分：

| 装饰器 | 作用范围 | 说明 |
|--------|----------|------|
| `@State` | 组件内部 | 组件私有状态，变化触发当前组件更新 |
| `@Prop` | 父→子 | 单向数据传递 |
| `@Link` | 父↔子 | 双向数据绑定 |
| `@Provide/@Consume` | 跨层级 | 无需逐层传递的状态共享 |
| `@Observed/@ObjectLink` | 嵌套对象 | 嵌套对象的响应式监听 |
| `@StorageLink` | 全局持久化 | 与本地存储绑定 |

### 5.2 状态管理核心原则

| 原则 | 说明 |
|------|------|
| **状态下推** | 状态保存在最底层的使用组件，减少影响范围 |
| **单一数据源** | 相同状态只保存在一处 |
| **状态不可变性** | 修改状态时生成新对象 |
| **全局状态划分** | 按业务模块划分，避免单一大状态对象 |

### 5.3 常见陷阱与解决方案

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 状态变化后 UI 不更新 | 未使用响应式装饰器 | 添加正确的装饰器，修改对象/数组时生成新实例 |
| 嵌套对象修改不生效 | 未使用 `@Observed+@ObjectLink` | 嵌套对象类加 `@Observed`，组件中用 `@ObjectLink` |
| `@Provide/@Consume` 失效 | 层级不匹配或类型不一致 | 确保父级声明 `@Provide`，子级用 `@Consume`，类型一致 |
| 非组件类中使用 `@State` | `@State` 仅用于 `@Component` | 数据层使用普通属性 + getter/setter |

---

## 六、工程架构规范（工程级）

### 6.1 分层架构模式

#### 模式一：四层架构（华为推荐）

| 层级 | 职责 | 技术实现 |
|------|------|----------|
| UI 层 | 页面组件、UI 交互、状态管理 | ArkTS 组件、`@State` 等装饰器 |
| 视图模型层 | 业务逻辑封装、数据转换、状态聚合 | ViewModel 类、`@Observed` |
| 领域层 | 业务实体定义、核心业务规则 | Model 类、领域服务 |
| 数据层 | 网络请求、本地存储、数据缓存 | HTTP 客户端、数据库、KV 存储 |

#### 模式二：Clean Architecture（"知墨"项目实践）

```
ets/
├── domain/           # 领域层（纯逻辑，无框架依赖）
│   ├── models/       # 实体模型（interface + 工厂函数）
│   └── usecases/     # 业务用例
├── data/             # 数据层（实现持久化）
│   ├── repositories/ # 仓库实现（含内存缓存）
│   └── services/     # 基础设施服务（Preferences 封装）
├── ui/               # UI 组件层
│   └── core/         # 可复用组件
└── pages/            # 页面层（仅编排）
```

**依赖方向**：`pages → domain ← data`，领域层在最中心，谁都不依赖。

#### 模式三：六层架构（"玄象"项目实践）

```
entry/src/main/ets/
├── entryability/            # Ability 层
├── common/
│   ├── components/          # 公共组件层（复用度 ≥ 3）
│   ├── constants/           # 常量层（纯定义，无逻辑）
│   └── utils/               # 工具层（静态方法，纯函数）
├── pages/                   # 页面层（按模块分目录）
│   ├── Index.ets            # 路由根
│   ├── mansion/             # 星宿模块
│   ├── yijing/              # 周易模块
│   └── ...
```

**依赖规则矩阵**：

| 依赖方 → 被依赖方 | 允许 | 说明 |
|---------------------|------|------|
| pages → common/* | ✓ | 页面使用公共层 |
| common/components → common/constants | ✓ | 组件使用常量 |
| common/components → common/utils | ✓ | 组件使用工具类 |
| common/utils → common/components | ✗ | 工具类不应依赖组件 |
| pages → pages（跨模块） | ✗ | 页面不应跨模块互相依赖 |

#### 模式四：三层架构（测试优化型）

```
src/
├── view/       # 视图层：页面与组件
├── service/    # 业务层：逻辑处理与流程编排
├── model/      # 数据层：状态、接口、实体类
└── utils/      # 工具类
```

### 6.2 目录结构规范（华为推荐）

```
src/main/ets/
├── common/                # 公共资源
│   ├── components/        # 基础公共组件
│   ├── styles/            # 全局样式
│   ├── utils/             # 工具函数
│   ├── constants/         # 常量定义
│   └── types/             # 通用类型定义
├── features/              # 业务特性模块
│   ├── home/
│   │   ├── components/    # 首页私有组件
│   │   ├── viewmodels/    # 首页 ViewModel
│   │   ├── models/        # 首页数据模型
│   │   ├── api/           # 首页接口
│   │   └── pages/         # 首页页面
│   ├── product/
│   └── user/
├── router/                # 路由配置
├── store/                 # 全局状态管理
└── entryability/          # 应用入口配置
```

### 6.3 组件拆分规范

| 层级 | 位置 | 特征 |
|------|------|------|
| 基础组件库 | `common/components/` | 与业务无关，可跨项目复用 |
| 业务组件库 | `features/*/components/` | 与特定业务相关，项目内复用 |
| 页面组件 | `pages/` | 完整页面，仅在路由中使用 |
| 页面内组件 | 页面内 `@Builder` | 单页面使用的私有组件 |

**组件入库准则**（来自"玄象"项目）：

- 复用度 ≥ 3（至少被 3 个页面引用）
- 无业务逻辑（不依赖特定业务数据）
- 接口稳定（通过 `@Prop/@Link` 暴露）
- 自包含样式（不依赖外部传入）

### 6.4 文件大小建议

| 文件类型 | 建议行数 | 超出处理 |
|----------|----------|----------|
| 页面组件 | ≤ 500 行 | 拆分为多个 `@Builder` |
| 公共组件 | ≤ 300 行 | 拆分子组件 |
| 工具类 | ≤ 800 行 | 按职责拆分为多个类 |
| 常量类 | ≤ 200 行 | 按主题拆分 |

---

## 七、性能优化规范

### 7.1 渲染性能红线

| 指标 | 目标值 |
|------|--------|
| 页面首帧渲染时间 | ≤ 200ms |
| 列表滑动帧率 | ≥ 55fps |
| 内存占用 | ≤ 应用总内存的 30% |
| 冷启动时间 | ≤ 1s |

### 7.2 渲染优化要点

| 实践 | 说明 |
|------|------|
| **LazyForEach 替代 ForEach** | 超过 20 项的列表必须用 LazyForEach + reuseId |
| **避免 build() 中复杂计算** | 复杂计算移到 aboutToAppear 或 ViewModel |
| **频繁切换用 Visibility** | 避免 if/else 反复创建销毁组件 |
| **@Computed 缓存派生状态** | 复杂计算的派生状态使用 @Computed |
| **减少组件重渲染** | 合理划分组件边界，状态最小化 |

### 7.3 内存优化

| 实践 | 说明 |
|------|------|
| **资源及时释放** | aboutToDisappear 中清理定时器、事件监听、订阅 |
| **图片内存优化** | 使用自适应分辨率图片，及时释放不可见图片 |
| **避免内存泄漏** | 禁止在组件中持有全局静态引用，使用弱引用 |
| **列表缓存策略** | 长列表设置合理缓存数量 |

### 7.4 启动性能优化

| 实践 | 说明 |
|------|------|
| **懒加载非首屏模块** | 使用动态 import 加载非首屏页面与组件 |
| **减少初始化逻辑** | 首页初始化逻辑精简，非必要逻辑延迟执行 |
| **资源预加载** | 合理预加载首屏需要的资源 |
| **AOT 编译优化** | 开启编译优化选项 |

---

## 八、模块化与共享包规范

### 8.1 包类型选择

| 包类型 | 特征 | 使用场景 |
|--------|------|----------|
| **HAR** (Harmony Archive) | 静态共享，编译时合并 | 可独立复用的功能工具 |
| **HSP** (Harmony Shared Package) | 动态共享，运行时加载 | 大型功能模块拆分 |
| **HAP** (Harmony Ability Package) | 应用入口模块 | 主入口与基础能力 |

### 8.2 模块拆分触发条件

| 触发条件 | 演进方向 |
|----------|----------|
| 团队规模扩大（≥ 5 人） | 按功能拆分 HSP |
| 应用体积超过 100MB | 拆分动态加载 HSP |
| 出现可独立复用的功能 | 拆分为 HAR 发布 |
| 出现跨应用共享需求 | 发布到 OHPM |

---

## 九、代码审查检查清单

基于华为推荐的企业级代码审查标准：

### 9.1 架构与设计

- [ ] 遵循 UI = f(State) 思想，无手动操作视图的代码
- [ ] 业务逻辑与 UI 分离，无业务逻辑耦合在组件中
- [ ] 组件遵循单一职责原则，代码行数不超过 300/500 行
- [ ] 遵循项目目录结构规范，组件按层级划分

### 9.2 状态管理

- [ ] 状态使用正确的响应式装饰器，无冗余状态定义
- [ ] 嵌套对象使用 @Observed + @ObjectLink
- [ ] 跨层级通信使用 @Provide/@Consume
- [ ] 全局状态按业务模块划分

### 9.3 代码质量

- [ ] 所有变量、方法有明确类型定义，无 any 类型使用
- [ ] 类属性添加 private/protected/public 修饰符
- [ ] 常量使用 UPPER_SNAKE_CASE，变量使用 lowerCamelCase
- [ ] 布尔变量使用 is/has/can 前缀

### 9.4 性能

- [ ] 长列表使用 LazyForEach 配合 reuseId
- [ ] build() 方法中无复杂计算、日志输出、网络请求
- [ ] 资源在 aboutToDisappear 中正确释放
- [ ] 非首屏模块使用懒加载

### 9.5 安全与健壮性

- [ ] 异常处理完整，finally 中无 return/break/continue
- [ ] Number.isNaN() 而非直接比较
- [ ] 浮点数不省略小数点前后的 0
- [ ] 控制性条件表达式中无赋值操作

---

## 十、import 顺序规范

来自"玄象"项目等已实践项目的约定：

```typescript
// 1. HarmonyOS 官方 Kit
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 2. 三方库
import { describe, it } from '@ohos/hypium';

// 3. 项目内模块（按层级从外到内）
import { Colors } from '../common/constants/Colors';
import { LunarCalendar } from '../common/utils/LunarCalendar';
```

---

## 十一、设计模式实践

### 11.1 已验证的模式（ArkTS 适配）

| 模式 | 适用场景 | ArkTS 实现要点 |
|------|----------|----------------|
| **Builder 模式** | 复杂组件构建 | `@Builder` 装饰器 |
| **单例模式** | 全局服务（Preferences、Theme） | class + static instance |
| **工厂模式** | 实体对象创建 | 工厂函数（非 class constructor） |
| **观察者模式** | 状态变化通知 | `@Observed/@ObjectLink` |
| **策略模式** | 可切换的业务规则 | 接口 + 多实现 |
| **Repository 模式** | 数据持久化封装 | 内存缓存 + Preferences |

### 11.2 ViewModel 实践

```typescript
@Observed
class ProductListViewModel {
  productList: Product[] = [];
  isLoading: boolean = false;
  hasMore: boolean = true;
  page: number = 1;

  async loadProductList(isRefresh: boolean = false) {
    if (isRefresh) { this.page = 1; }
    this.isLoading = true;
    try {
      const result = await ProductApi.getList(this.page, 20);
      if (isRefresh) {
        this.productList = result.data;
      } else {
        this.productList = [...this.productList, ...result.data];
      }
      this.hasMore = result.data.length === 20;
      this.page += 1;
    } catch (e) {
      console.error("加载失败", e);
    } finally {
      this.isLoading = false;
    }
  }
}
```

---

## 十二、已知坑点与避雷

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 列表滑动卡顿 | 使用 ForEach 渲染大量数据 | 替换为 LazyForEach + reuseId |
| 页面跳转卡顿 | build() 中存在复杂计算 | 移到 aboutToAppear 或异步执行 |
| 内存持续增长 | 资源未释放 | 检查 aboutToDisappear 中的清理逻辑 |
| 多设备显示不一致 | 使用固定像素单位 | 使用 vp/fp 单位 + 媒体查询 |
| `@State not supported in non-component class` | 在非 @Component 类中使用了 @State | 数据层用普通属性 + getter/setter |
| `Cannot find module 'xxx'` | 测试文件路径未正确配置 | 确保测试目录包含在构建路径中 |
| 真机调试时组件不刷新 | 未开启 DevTools 调试模式 | 启用 USB 调试 + Attach to Process |

---

## 十三、参考来源

| # | 来源 | 类型 | URL |
|---|------|------|-----|
| 1 | 华为 ArkTS 编程规范 V5 | 官方文档 | `developer.huawei.com/.../arkts-coding-style-guide-V5` |
| 2 | @hw-stylistic Code Linter 规则 | 官方文档 | `developer.huawei.com/.../ide-hw-stylistic` |
| 3 | OpenHarmony ArkTS 编码规范 | 社区规范 | `gitee.com/openharmony/docs/.../OpenHarmony-ArkTS-coding-style-guide.md` |
| 4 | ArkTS 高性能编程指南 | 官方文档 | `developer.huawei.com/.../arkts-high-performance-programming` |
| 5 | HarmonyOS 模块化设计最佳实践 | 官方文档 | `developer.huawei.com/.../bpta-modular-design` |
| 6 | ArkTS 声明式开发企业级技术指南 | 社区实践 | `cnblogs.com/zdt168/p/19831647` |
| 7 | ArkTS Programming Specification | 社区翻译 | `dev.to/liu_yang_fc0e605820ac220c/arkts-programming-specification1-8ml` |
| 8 | 鸿蒙 Next ArkTS 编程规范总结 | 社区总结 | `segmentfault.com/a/1190000045670295` |
| 9 | Clean Architecture in ArkTS（"知墨"项目） | 项目实战 | `blog.csdn.net/2502_93949915/article/details/161696712` |
| 10 | ArkTS 模块化架构实践 | 社区文章 | `segmentfault.com/a/1190000047143231` |
| 11 | 3 层架构优化 ArkTS 测试与调试 | 项目实战 | `ost.51cto.com/posts/42316` |
| 12 | "玄象"项目六层架构 | 项目实战 | `jishuzhan.net/article/2081616619905359873` |
| 13 | ArkTS 工程目录结构（Stage 模型） | 官方文档 | `developer.aliyun.com/article/1644741` |
| 14 | 鸿蒙开发 ArkTS 工程目录结构详解 | 社区文章 | `cloud.tencent.com/developer/article/2474777` |
