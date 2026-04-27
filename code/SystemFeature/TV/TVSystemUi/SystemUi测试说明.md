# TVSystemUi 测试设计说明

## 1. 文档目的

本文档说明 TVSystemUi（OpenHarmony TV 场景 SystemUI 示例工程）当前测试设计的覆盖维度、设计要素与充分性依据，用于解释 `entry/tv` 模块 **ohosTest**（Hypium）用例集合为什么能够支撑当前版本在公共能力、窗口与音量链路等关键路径上的质量判断。

## 2. 测试对象

- **主入口与 Extension 链路**：`tv_entry` 下 `AbilityStage`、`ServiceExtAbility` 所承载的 SystemUI 启动、窗口与输入协同路径（与 `common` 中初始化、窗口与 Ability 管理能力联动）。
- **公共 HAR（`common`）**：日志、窗口管理、Ability 协调、事件总线、插件数据源、样式与工具类等可被多模块复用的基础能力。
- **TV 音量面板链路**：`features/volumepanelcomponent`、`product/tv/volumepanel` 等与音量展示、窗口控制器、ViewModel、服务侧逻辑相关的行为与契约。
- **配件配对相关模型**：`product/tv/pairService` 侧配对模型、IDL 契约在业务层的可测行为（以单元/集成断言为主）。
- **对话框与导航等特性**：`product/default/dialog`、`features/navigationservice` 等与 SystemUI 子能力相关的公共逻辑（测试主要通过 `common` 与入口侧可触达模块间接覆盖）。
- **测试基建**：Hypium 套件注册入口 `entry/tv/src/ohosTest/ets/test/List.test.ets`、`TestAbility` 与测试运行配置。

## 3. 测试资产概览

### 3.1 自动化测试套

当前在 `List.test.ets` 中串联 **23** 个自动化测试套，分别覆盖：

1. Ability 管理与上下文契约（`AbilityManager.test.ets`）
2. 空值与集合检查工具（`CheckEmptyUtils.test.ets`）
3. 公共样式管理（`CommonStyleManager.test.ets`）
4. 对话框模块（`DialogModule.test.ets`）
5. 装饰器行为（`Decorators.test.ets`）
6. 事件总线（`EventBus.test.ets`）
7. 高度配置工具（`HeightConfigUtils.test.ets`）
8. 日志封装（`Log.test.ets`）
9. 配件配对部件模型（`PartsPairModel.test.ets`）
10. 配对相关模型组合（`PairModels.test.ets`）
11. 资源工具（`ResourceUtil.test.ets`）
12. 场景类组合用例（`SceneTests.test.ets`）
13. 时间管理（`TimeManager.test.ets`）
14. 音量相关常量（`VolumeConstants.test.ets`）
15. 音量面板 ViewModel（`VolumePanelVM.test.ets`）
16. 音量窗口控制器（`VolumeWindowController.test.ets`）
17. 设置工具集成（`SettingsUtilIntegration.test.ets`）
18. 窗口管理全量用例（`WindowManagerFull.test.ets`）
19. 字符串工具（`StringUtil.test.ets`）
20. 音量面板服务侧逻辑（`VolumePanelService.test.ets`）
21. ArrayBuffer 工具（`ArrayBufferUtil.test.ets`）
22. 事件工具（`EventUtil.test.ets`）
23. 超时 Promise 工具（`TimeoutPromise.test.ets`）

测试入口：`entry/tv` 模块 **ohosTest**（模块名以工程 `module.json5` 为准，常见为 `tv_entry_test`），由 **Hypium** 驱动；套件注册见 `src/ohosTest/ets/test/List.test.ets`。

### 3.2 覆盖规划规模

依据当前仓库中 **ohosTest** 源码规模与套件划分，测试设计可概括为：

- **1** 个 TV 入口模块自动化测试入口（`entry/tv` / ohosTest）
- **23** 个 Hypium 测试套（与 `List.test.ets` 导入一致）
- **约 4500+ 行** ohosTest 测试源码规模（随用例扩充持续增长）
- **10+** 个逻辑覆盖域（Ability/窗口、工具类、事件、音量、配对、设置集成、场景组合等）
- 以 **契约与回归断言** 为主的设计取向：常量、上下文键、窗口生命周期与跨模块约定优先固化在自动化用例中

更细粒度的用例表与预置条件可参考同目录 **`ohosTest.md`**。

## 4. 测试设计优势说明

### 4.1 功能链路维度

测试重点对齐 SystemUI 在 TV 上的核心链路，而非单点 API 调用：

- **入口与协调**：通过 `AbilityManager` 等用例固化 Ability 名称、上下文存取等契约，降低跨模块路由静默失败风险。
- **窗口与展示**：`WindowManagerFull` 等对窗口类型、显隐与事件进行校验，支撑音量面板、悬浮层等依赖窗口栈的行为稳定。
- **音量子系统**：`VolumeConstants`、`VolumePanelVM`、`VolumeWindowController`、`VolumePanelService` 形成从常量、VM、窗口到服务的分层验证。
- **配对与扩展业务**：`PartsPairModel`、`PairModels`、`SceneTests` 等覆盖配件配对相关模型与组合场景。
- **系统设置与集成**：`SettingsUtilIntegration` 等对设置侧集成路径进行专项断言。

该维度体现测试对「SystemUI 公共能力 + 音量 + 配对」主路径的聚焦，与 README 中工程模块划分一致。

### 4.2 模块分层维度

测试与工程分层对应，便于定位失败归属：

- **公共能力层**：`Log`、`CheckEmptyUtils`、`ResourceUtil`、`CommonStyleManager`、`HeightConfigUtils` 等对 `common` HAR 可测逻辑进行回归。
- **协调与事件层**：`EventBus`、`EventUtil`、`Decorators`、`DialogModule` 等覆盖消息、装饰器与对话框模块约定。
- **窗口与 Ability 层**：`WindowManagerFull`、`AbilityManager` 与窗口/Ability 契约强相关。
- **业务特性层**：音量与配对相关测试套与 `features/volumepanelcomponent`、`product/tv/volumepanel`、`product/tv/pairService` 等业务代码形成映射。

分层覆盖有助于在门禁与 CI 失败时快速判断是基础设施回归还是特性逻辑回归。

### 4.3 交互行为维度

本工程面向 **TV / 大屏**，业务代码大量涉及遥控输入、焦点与系统级窗口行为。当前自动化以 **Hypium 单元/模块测试** 为主，在可测范围内覆盖：

- 与 **按键、事件分发、事件总线** 相关的逻辑分支（如 `EventBus`、`EventUtil`）。
- 与 **窗口显隐、控制器状态** 相关的逻辑（如 `VolumeWindowController`）。
- **UI 组件与装饰器** 侧的可断言行为（如 `Decorators`、`DialogModule`）。

完整 **端到端遥控轨迹、真机焦点矩阵** 建议在系统侧或专项 UI 自动化中补充；本文档所述套件为其提供底层契约与逻辑回归基础。

### 4.4 数据与状态维度

测试设计关注 **状态与约定** 的一致性，而不仅是一次性返回值：

- **全局上下文与 Ability 名**：`AbilityManager` 用例强调常量与 `globalThis` 存取约定。
- **窗口可见性与矩形信息**：`WindowManagerFull` 等对窗口状态变更进行校验。
- **音量与配对模型**：相关 test 套对模型状态转换与边界进行断言（具体以各 `.test.ets` 内 `describe/it` 为准）。
- **异步与时序**：`TimeoutPromise` 等对异步工具行为进行固化，减少时序类缺陷。

### 4.5 边界与异常维度

各测试套在实现中通常包含 **空值、非法参数、边界分支** 等用例（例如 `CheckEmptyUtils`、工具类与窗口逻辑中的异常路径）。建议在新增业务代码时 **同步补充** 对应 describe 块，保持与 TVPhotos 类大型工程相同的「成功路径 + 异常路径」治理习惯。

### 4.6 运行与环境维度

本工程测试有效性的前置条件包括：

- **SDK / 工程配置**：与根目录及各模块 `build-profile.json5`、`compileSdkVersion` 等保持一致（参见 README 约束说明）。
- **系统能力与权限**：SystemUI 依赖输入监听、蓝牙、音频、后台拉起等权限与系统实现；部分用例在能力受限环境可能跳过或弱化，需在流水线与真机报告中标注环境。
- **执行方式**：DevEco Studio 选择 ohosTest 目标或命令行执行 Hypium 任务，与 `ohosTest.md` 描述一致。

该维度说明当前测试结论需与 **运行环境** 联合解读，而非脱离设备的纯语法检查。

## 5. 用例与维度映射

| 维度 | 代表测试套 | 主要验证点 |
| --- | --- | --- |
| Ability / 上下文契约 | `AbilityManager.test.ets` | Ability 名称常量、`context` 存取、跨模块 key 契约 |
| 窗口管理 | `WindowManagerFull.test.ets` | 窗口类型、显隐、事件与状态组合 |
| 音量链路 | `VolumeConstants.test.ets`、`VolumePanelVM.test.ets`、`VolumeWindowController.test.ets`、`VolumePanelService.test.ets` | 常量、VM、窗口控制、服务逻辑分层断言 |
| 配对与场景 | `PartsPairModel.test.ets`、`PairModels.test.ets`、`SceneTests.test.ets` | 配对模型与组合场景 |
| 事件与消息 | `EventBus.test.ets`、`EventUtil.test.ets` | 事件发布订阅与工具函数 |
| 公共工具与样式 | `CheckEmptyUtils.test.ets`、`ResourceUtil.test.ets`、`StringUtil.test.ets`、`ArrayBufferUtil.test.ets`、`CommonStyleManager.test.ets`、`HeightConfigUtils.test.ets` | 工具与 UI 相关可测逻辑 |
| 日志与时间 | `Log.test.ets`、`TimeManager.test.ets` | 日志封装、时间相关行为 |
| 装饰器与对话框 | `Decorators.test.ets`、`DialogModule.test.ets` | 装饰器约定、对话框模块 |
| 设置集成 | `SettingsUtilIntegration.test.ets` | 设置工具集成路径 |
| 异步工具 | `TimeoutPromise.test.ets` | 超时与 Promise 组合行为 |

## 6. 为什么当前测试设计是有力的

- **聚焦 SystemUI 高风险契约**：Ability 名、上下文与窗口约定一旦错误会导致跨模块静默失败，相关用例提供持续回归锚点。
- **音量与窗口分层覆盖**：从常量到 Service 的多层测试套与工程模块划分一致，便于定位缺陷层次。
- **公共 HAR 广覆盖**：大量工具与基础设施具备独立测试套，降低重构 `common` 时的回归成本。
- **可执行、可门禁**：套件集中于单一 ohosTest 入口，便于流水线集成与版本对比。
- **与文档双轨**：本说明阐述设计意图，`ohosTest.md` 提供用例表与运行提示，二者互补。

## 7. 结论

当前 TVSystemUi 的 Hypium 测试集合已形成以 **公共能力 + 窗口与 Ability 契约 + 音量链路 + 配对与场景组合** 为核心的自动化回归能力，能够支撑本示例工程在持续集成中的 **逻辑正确性与关键契约稳定性** 评估。若需进一步贴近用户操作的 **全链路 TV 遥控与焦点矩阵** 验证，建议在系统测试阶段补充专项 UI/场景自动化，并与本文档所述单元/模块测试协同使用。
