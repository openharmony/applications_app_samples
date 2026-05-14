# TVDeviceManagerUi 测试用例归档

## 项目概述

TVDeviceManagerUi 是 OpenHarmony TV 场景下的 DeviceManager 交互界面应用，提供系统级对话框能力，包括连接确认、PIN 码展示与输入等功能。测试基于 Hypium 框架，覆盖 UIExtensionAbility、对话框交互、窗口管理、无障碍、国际化、性能稳定性等多个维度。

## 测试用例表

### 基础测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 基础测试用例运行 | 1. 构建并安装测试 hap（`entry_test`）<br/>2. 设备支持运行 Hypium | 执行 `ohosTest` 用例 | 用例执行完成，无异常崩溃 | 是 | Pass |
| 测试框架初始化 | 已安装测试 hap | 执行 `Foundation.test.ets` | 旋转矩阵、生命周期事件、覆盖率批次等基础断言通过 | 是 | Pass |
| 常量与类型验证 | 已安装测试 hap | 执行 `ConstantsAndTypes.test.ets` | KeyCode、StyleConstants、ExtensionWindowTypes 等常量验证通过 | 是 | Pass |

### 核心对话框测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 确认对话框核心功能 | 已安装测试 hap | 执行 `ConfirmDialogCore.test.ets` | 确认/取消/始终允许按钮交互、倒计时、焦点管理、窗口销毁顺序验证通过 | 是 | Pass |
| PIN 码对话框功能 | 已安装测试 hap | 执行 `PinDialogMerged.test.ets` | PIN 码展示、窗口几何计算、资源释放验证通过 | 是 | Pass |
| PIN 输入对话框功能 | 已安装测试 hap | 执行 `InputDialogMerged.test.ets` | PIN 输入、按钮状态、焦点切换验证通过 | 是 | Pass |

### Ability 与生命周期测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| Ability 和 Stage 生命周期 | 已安装测试 hap | 执行 `AbilityAndStageLifecycle.test.ets` | AbilityStage、UIAbility、UIExtensionAbility 生命周期事件验证通过 | 是 | Pass |
| MainAbility 生命周期契约 | 已安装测试 hap | 执行 `MainAbilityLifecycleContract.test.ets` | MainAbility 窗口创建、页面加载、焦点控制验证通过 | 是 | Pass |
| 模块契约测试 | 已安装测试 hap | 执行 `ModuleContract.test.ets` | 模块接口契约、Extension 会话管理验证通过 | 是 | Pass |

### 窗口与扩展能力测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| Extension 窗口场景 | 已安装测试 hap | 执行 `ExtensionWindowMerged.test.ets` | UIExtensionAbility 窗口创建、尺寸计算、会话管理验证通过 | 是 | Pass |
| Extension 窗口场景扩展 | 已安装测试 hap | 执行 `ExtensionWindowScenarioExpansion.test.ets` | 多分辨率窗口适配、旋转场景验证通过 | 是 | Pass |
| Extension 会话存储契约 | 已安装测试 hap | 执行 `ExtensionSessionStorageContract.test.ets` | 会话数据存储、读取、一致性验证通过 | 是 | Pass |
| 并发窗口场景 | 已安装测试 hap | 执行 `ConcurrentWindowScenario.test.ets` | 多窗口并发创建、销毁顺序验证通过 | 是 | Pass |
| 窗口计数器释放门控 | 已安装测试 hap | 执行 `WindowCounterReleaseGate.test.ets` | 窗口计数、会话/Extension 终止时机验证通过 | 是 | Pass |
| 透明载体契约 | 已安装测试 hap | 执行 `TransparentCarrierContract.test.ets` | 透明页面加载、窗口属性验证通过 | 是 | Pass |

### 业务场景测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 业务场景目录 | 已安装测试 hap | 执行 `BusinessScenarioCatalog.test.ets` | 分布式连接确认、PIN 码展示/输入等场景覆盖验证通过 | 是 | Pass |
| 场景矩阵扩展 | 已安装测试 hap | 执行 `ScenarioMatrixExpansion.test.ets` | 多场景组合、边界条件验证通过 | 是 | Pass |
| 场景用例规模计划 | 已安装测试 hap | 执行 `ScenarioCaseScalePlan.test.ets` | 场景用例数量、覆盖率验证通过 | 是 | Pass |
| 启动与终止场景 | 已安装测试 hap | 执行 `LaunchAndTerminationScenario.test.ets` | 应用启动、Extension 拉起、资源释放验证通过 | 是 | Pass |

### 无障碍与国际化测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 无障碍功能 | 已安装测试 hap | 执行 `AccessibilityFeatures.test.ets` | 焦点导航、遥控器操作、可读文本验证通过 | 是 | Pass |
| 无障碍与可读文本 | 已安装测试 hap | 执行 `AccessibilityAndReadableText.test.ets` | 按钮标签、倒计时文本、无障碍属性验证通过 | 是 | Pass |
| 国际化支持 | 已安装测试 hap | 执行 `InternationalizationSupport.test.ets` | 多语言文本、本地化格式验证通过 | 是 | Pass |

### 性能与稳定性测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 性能合并测试 | 已安装测试 hap | 执行 `PerformanceMerged.test.ets` | 对话框加载时间、内存占用验证通过 | 是 | Pass |
| 性能稳定性扩展 | 已安装测试 hap | 执行 `PerformanceStabilityExtended.test.ets` | 长时间运行、多次拉起稳定性验证通过 | 是 | Pass |
| 压力与浸泡场景 | 已安装测试 hap | 执行 `StressAndSoakScenario.test.ets` | 高频操作、长时间浸泡测试验证通过 | 是 | Pass |

### 异常处理测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 异常处理 | 已安装测试 hap | 执行 `ExceptionHandling.test.ets` | 空值保护、异常捕获、降级处理验证通过 | 是 | Pass |
| 异常边界扩展 | 已安装测试 hap | 执行 `ExceptionBoundaryExtended.test.ets` | 边界条件、异常恢复验证通过 | 是 | Pass |
| 故障注入场景 | 已安装测试 hap | 执行 `FaultInjectionScenario.test.ets` | 服务不可用、权限拒绝等故障场景验证通过 | 是 | Pass |

### 数据一致性与持久化测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 数据一致性与竞态 | 已安装测试 hap | 执行 `DataConsistencyAndRace.test.ets` | 多线程数据访问、竞态条件验证通过 | 是 | Pass |
| 数据持久化 | 已安装测试 hap | 执行 `DataPersistence.test.ets` | 配置保存、状态恢复验证通过 | 是 | Pass |

### 安全与网络测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 安全合并测试 | 已安装测试 hap | 执行 `SecurityMerged.test.ets` | 权限校验、敏感数据保护验证通过 | 是 | Pass |
| 安全权限扩展 | 已安装测试 hap | 执行 `SecurityPermissionsExtended.test.ets` | 权限声明、权限授予验证通过 | 是 | Pass |
| 网络合并测试 | 已安装测试 hap | 执行 `NetworkMerged.test.ets` | 网络连接状态、分布式同步验证通过 | 是 | Pass |
| 网络连接扩展 | 已安装测试 hap | 执行 `NetworkConnectivityExtended.test.ets` | 网络断开重连、超时处理验证通过 | 是 | Pass |

### 兼容性与多分辨率测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 兼容性扩展 | 已安装测试 hap | 执行 `CompatibilityExtended.test.ets` | 不同 SDK 版本、设备类型兼容验证通过 | 是 | Pass |
| 多分辨率适配 | 已安装测试 hap | 执行 `MultiResolutionAdaptation.test.ets` | 不同屏幕尺寸、DPI 适配验证通过 | 是 | Pass |
| 旋转与分辨率矩阵 | 已安装测试 hap | 执行 `RotationAndResolutionMatrix.test.ets` | 横竖屏旋转、分辨率切换验证通过 | 是 | Pass |

### 回归与集成测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 回归测试套件 | 已安装测试 hap | 执行 `RegressionSuite.test.ets` | 核心功能回归验证通过 | 是 | Pass |
| 回归覆盖矩阵 | 已安装测试 hap | 执行 `RegressionCoverageMatrix.test.ets` | 回归覆盖率达标验证通过 | 是 | Pass |
| 综合集成测试 | 已安装测试 hap | 执行 `ComprehensiveIntegration.test.ets` | 端到端流程、多模块集成验证通过 | 是 | Pass |

### UI 测试框架测试

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| UI 测试定位器策略 | 已安装测试 hap | 执行 `UiHarnessLocatorStrategy.test.ets` | 元素定位、查找策略验证通过 | 是 | Pass |
| 对话框缩放精度 | 已安装测试 hap | 执行 `DialogScalePrecision.test.ets` | 对话框尺寸计算精度验证通过 | 是 | Pass |
| PIN 码显示深度契约 | 已安装测试 hap | 执行 `PincodeDisplayDeepContract.test.ets` | PIN 码掩码、显示格式验证通过 | 是 | Pass |
| PIN 码共享样式 | 已安装测试 hap | 执行 `PincodeShareStyle.test.ets` | PIN 码样式一致性验证通过 | 是 | Pass |
| 输入共享样式 | 已安装测试 hap | 执行 `InputShareStyle.test.ets` | 输入框样式一致性验证通过 | 是 | Pass |
| 边界条件测试 | 已安装测试 hap | 执行 `BoundaryConditionTesting.test.ets` | 极值、空值、溢出边界验证通过 | 是 | Pass |
| 列表测试 | 已安装测试 hap | 执行 `List.test.ets` | 列表组件渲染、交互验证通过 | 是 | Pass |
| 覆盖率计划 | 已安装测试 hap | 执行 `CoveragePlan.test.ets` | 测试覆盖率统计、批次验证通过 | 是 | Pass |

## 测试统计

- **测试文件总数**: 50+ 个测试文件
- **测试覆盖领域**: 基础框架、对话框核心、Ability 生命周期、窗口管理、业务场景、无障碍、国际化、性能稳定性、异常处理、数据安全、网络、兼容性、回归集成等
- **测试框架**: @ohos/hypium
- **测试类型**: 单元测试、集成测试、场景测试、回归测试

## 执行方式

```bash
# 构建测试 hap
hvigorw assembleHap -p product=default -p buildMode=debug

# 执行 ohosTest
hvigorw ohosTest -p product=default
```
