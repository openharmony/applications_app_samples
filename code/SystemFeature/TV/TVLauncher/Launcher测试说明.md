# TVLauncher 测试说明（ohosTest / UiTest + Hypium）

> 本文档参考当前写法，并结合 `product/tv/src/ohosTest/ets/test` 目录下现有用例进行整理，用于说明 TVLauncher 自动化测试的组织方式、覆盖范围、关键约定与新增用例的推荐写法。

## 1. 文档目的

- 说明 TVLauncher 在 `product/tv` 模块下的 **ohosTest** 自动化测试（Hypium）如何组织与运行。
- 解释 `product/tv/src/ohosTest/ets/test` 下各测试套件的关注点与覆盖维度。
- 固化当前测试基建（尤其是 `SharedDriver.ets`）的使用规范，降低新增/维护用例的成本与不稳定性。

## 2. 测试对象

- **TVLauncher 桌面核心链路**：Home 进入桌面、方向键导航、Enter 启动、Back 返回、编辑态（Edit）进入/退出。
- **系统交互与稳定性**：焦点移动、返回链路、Home/Back/Edit 组合操作在长链路与压力循环下的稳定性。
- **显示相关能力**：屏幕旋转（`DisplayRotation`）下桌面可用性与组合链路稳定性。

## 3. 测试资产目录与入口

测试用例主要位于：

- `code/SystemFeature/TV/TVLauncher/product/tv/src/ohosTest/ets/test`

目录中用例文件以 `*.test.ets` 命名，另有共享基建文件：

- `SharedDriver.ets`：全局单例 Driver + 串行化 UI 操作队列 + 按键码/超时/容差等常量。

> 说明：当前目录下包含大量以“功能/契约/回归/深度/压力”等维度划分的套件，例如：
> `Launcher.test.ets`、`RotationResolutionPerformanceDeep.test.ets`、`FocusAndNavigation.test.ets`、`StorageAndPolicyDeep.test.ets` 等。

## 4. 测试基建与关键约定（SharedDriver）

### 4.1 为什么要共享 Driver

`SharedDriver.ets` 的核心目标是：**所有 suite 共享同一 Driver 实例，并把 UI 操作串行化**，避免多套件并发 `Driver.create()` 或并发操作导致的 native 冲突/不稳定。

- `getDriver()`：懒创建全局 Driver。
- `createFreshDriver()`：每个 suite 开始时调用；复用 Driver，只重置串行队列。
- `runSerializedUiOperation()`：将 UI 操作排队串行执行。
- `triggerSerializedKey()`/`pressAndWait()` 等：对按键与等待逻辑做统一封装。

### 4.2 按键/超时/容差的统一管理

`SharedDriver.ets` 中集中定义：

- 遥控按键：`KEY_LEFT/RIGHT/UP/DOWN/ENTER/BACK/HOME/EDIT` 等。
- 关键超时：
  - `TIMEOUT_HOME`：回桌面/Home 响应等待
  - `TIMEOUT_EDIT`：编辑态进出等待
  - `TIMEOUT_COLD_START`：冷启动首屏等待
- 稳定性与波动容差：
  - `TOLERANCE_SINGLE_OP`：单次操作的 surface 波动容差
  - `TOLERANCE_EDIT_CYCLE`：编辑态进出一轮的容差
  - `TOLERANCE_STRESS`：压力循环后的累计漂移上限
  - `STABLE_TOLERANCE`、`STABLE_ROUNDS`：判定“UI 稳定”的连续采样要求

> 建议：新增用例不要在测试文件里到处散落硬编码超时与阈值；优先复用 `SharedDriver.ets` 的常量。

### 4.3 “surfaceCount”与“稳定性”判定思路

当前大量用例使用 `surfaceCount(driver)`（Image + Text 组件数）与 `waitForStableSurface()` 来衡量：

- 页面是否渲染完成（最低数量门槛）
- 在采样窗口内是否稳定（波动不超过容差）
- 长链路/压力场景后是否出现异常累积（漂移不超过容差）

该策略的优点是：不依赖具体 UI 文案/布局 id，适合桌面类 UI 的“存活性 + 稳定性”回归门禁。

## 5. 典型套件说明（结合现有用例）

### 5.1 桌面基础回归：`Launcher.test.ets`

关注点：

- 桌面首屏可用（存在 Text/Image 等组件）
- 方向键移动/边界连按不崩溃
- Enter 启动与 Back 返回后 UI 仍可用
- Home/Back/Edit 组合链路在多轮循环中稳定
- 基于 `surfaceCount` 的波动与压力漂移约束

典型结构：

- `beforeAll`：
  - `createFreshDriver()`
  - `KEY_HOME` 回桌面
  - `waitForSurface` + `waitForStableSurface` 等待稳定
- `afterAll`：回 Home 并等待稳定
- `it`：以“可用性断言 + 波动/漂移阈值”为主

### 5.2 旋转 + 性能/深度：`RotationResolutionPerformanceDeep.test.ets`

关注点：

- 多角度旋转（0/90/180/270）下桌面 surface 仍可用
- Edit 进出耗时（latency）阈值约束
- Rotation + Home/Back/Edit 混合链路在多轮操作后仍稳定
- 仍以 `surfaceCount` 与 `countNonEmptyTexts` 等“可感知输出”作为断言锚点

该套件的特点：

- 引入 `DisplayRotation` 与 `driver.setDisplayRotation()`
- 用 `costMs()` 统计关键链路耗时，并用阈值（如 `THRESHOLD_EDIT_MS`）做门禁
- 通过 `runSerializedUiOperation()` 将旋转与 delay 等动作纳入串行队列

## 6. 用例覆盖维度（现有文件命名映射）

`product/tv/src/ohosTest/ets/test` 目录下的用例大致可按下列维度理解：

- **基础桌面回归**：`Launcher.test.ets`
- **旋转/分辨率/性能深测**：`Rotation*.test.ets`、`RotationResolutionPerformanceDeep.test.ets`、`PerformanceAndRender.test.ets`
- **焦点与导航**：`FocusAndNavigation.test.ets`、`FocusNavigationDeep.test.ets`、`KeyEvent*.test.ets`
- **编辑态与桌面编排**：`AppEdit*.test.ets`、`DesktopAndEditFlow.test.ets`
- **近期任务/生命周期**：`Recent*.test.ets`、`Lifecycle*.test.ets`
- **窗口/多窗口**：`MultiWindow.test.ets`、`LauncherWindowDockerContracts.test.ets`
- **存储与策略/契约回归**：`Storage*.test.ets`、`DockerPolicy.test.ets`、`*Contracts*.test.ets`
- **组合场景/回归集**：`IntegrationEndToEnd.test.ets`、`ScenarioRegression.test.ets`、`FullContractRegression.test.ets`、`StressChaosRegressionDeep.test.ets`

> 说明：命名中的 `Contracts` 通常表示“契约/回归锚点”类断言；`Deep/Stress` 通常表示更长链路或更多轮次。

## 7. 新增用例推荐写法（与当前风格一致）

### 7.1 suite 模板

- 每个套件默认模式：`export default function xxxTest() { describe(...) }`
- suite 级 Driver 初始化统一放在 `beforeAll`：
  - `driver = createFreshDriver();`
  - `pressAndWait(driver, KEY_HOME, ...)`
  - `waitForSurface`/`waitForStableSurface`

### 7.2 断言建议

- **存活性断言**：`surfaceCount >= 1/2`、`countNonEmptyTexts >= 1`
- **稳定性断言**：多次采样 `surfaceCount` 的波动不超过 `TOLERANCE_SINGLE_OP`
- **压力漂移断言**：循环后与基线差值不超过 `TOLERANCE_EDIT_CYCLE/TOLERANCE_STRESS`
- **性能阈值**：关键链路用 `costMs()` 计时并约束在阈值内（按套件目标选择阈值）

### 7.3 避坑要点

- 不要在多个 suite 并发创建 Driver；统一使用 `createFreshDriver()`/`getDriver()`。
- 尽量通过 `pressAndWait()` 或 `runSerializedUiOperation()` 间接触发 UI 操作，避免并发调用。
- 需要等待 UI 稳定时优先 `waitForStableSurface()`，减少读到动画中间态导致的偶发失败。

## 8. 结论

当前 TVLauncher 的 ohosTest 用例集合以 `SharedDriver.ets` 为基建核心，通过“可用性（surface/text）+ 稳定性（波动/漂移）+ 组合链路（Home/Back/Edit/Enter/Rotation）”的方式形成自动化回归能力。

后续新增用例建议继续沿用：

- 统一的 Driver 与串行队列
- 统一的超时与容差
- 以“存活 + 稳定 + 长链路”作为主要门禁指标
