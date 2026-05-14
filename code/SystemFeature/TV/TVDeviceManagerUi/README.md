# TV DeviceManager UI 项目

### 介绍

本示例为 OpenHarmony TV 场景下的 DeviceManager 交互界面应用（`com.ohos.devicemanagerui`），基于 Stage 模型与单入口模块工程组织，在分布式连接、设备管理等流程中向用户提供系统级对话框能力，包括连接确认、PIN 码展示与输入等。工程以 `entry` 为主模块，通过 `UIExtensionAbility`（`sysDialog/common`）承载 TV 风格弹窗页面，公共日志与样式常量等沉淀在 `entry` 内 `common` 目录，可作为大屏 DeviceManager 相关 UI 的参考实现。

使用说明：

1. 应用以 `UIAbility`（`MainAbility`）作为可启动入口，窗口阶段默认加载确认类页面；分布式/设备管理侧通常通过拉起对应 `UIExtensionAbility` 展示系统对话框。
2. TV 形态采用 TV 风格交互与布局（含遥控器键值等，见 `common/constants/KeyCode.ts`）；弹窗尺寸随显示参数缩放（见各 `ServiceExtAbility` 与 `StyleConstants`）。
3. 连接确认流程由 `ConfirmUIExtAbility` 与页面 [ConfirmDialog.ets](entry/src/main/ets/pages/ConfirmDialog.ets) 等承载。
4. PIN 码展示与输入分别由 `PincodeUIExtAbility`、`InputUIExtAbility` 及 [PinDialog.ets](entry/src/main/ets/pages/PinDialog.ets)、[InputPinDialog.ets](entry/src/main/ets/pages/InputPinDialog.ets) 等页面承载。
5. 全局 `AbilityStage` 见 [MyAbilityStage.ets](entry/src/main/ets/Application/MyAbilityStage.ets)，公共能力见 [Logger.ets](entry/src/main/ets/common/Logger.ets) 与同目录常量定义。

### 工程目录

```text
TVDeviceManagerUi/
|---AppScope/app.json5                              // 应用级配置（包名、版本等）
|---build-profile.json5                             // 工程构建配置（SDK、签名、模块列表）
|---oh-package.json5                                // 工程依赖配置
|---signature/                                     // 签名材料（.p12 / .cer / .p7b 等）
|---entry/                                         // 主入口模块
|   |---build-profile.json5
|   |---oh-package.json5
|   |---src/main/
|   |   |---module.json5                            // 模块配置（Ability、ExtensionAbility、权限）
|   |   |---ets/
|   |   |   |---Application/MyAbilityStage.ets      // AbilityStage，应用级生命周期
|   |   |   |---MainAbility/MainAbility.ets         // 主 UIAbility 入口
|   |   |   |---ServiceExtAbility/
|   |   |   |   |---ConfirmServiceExtAbility.ets    // 确认类系统对话框 Extension
|   |   |   |   |---PincodeServiceExtAbility.ets    // PIN 展示类 Extension
|   |   |   |   |---InputServiceExtAbility.ets      // PIN 输入类 Extension
|   |   |   |---pages/                              // ConfirmDialog、PinDialog、InputPinDialog、Transparent 等
|   |   |   |---common/                             // Logger、样式与键值常量等
```

### 具体实现

- 应用级生命周期见 [MyAbilityStage.ets](entry/src/main/ets/Application/MyAbilityStage.ets)。
- 可启动入口 [MainAbility.ets](entry/src/main/ets/MainAbility/MainAbility.ets) 在 `onWindowStageCreate` 中加载 [ConfirmDialog.ets](entry/src/main/ets/pages/ConfirmDialog.ets)（可按产品策略调整首屏页面）。
- 三类系统对话框 Extension 均继承 `UIExtensionAbility`，在 `onSessionCreate` 中创建会话、按屏幕尺寸计算对话框区域并加载对应页面：
  - 确认：[ConfirmServiceExtAbility.ets](entry/src/main/ets/ServiceExtAbility/ConfirmServiceExtAbility.ets)
  - PIN 展示：[PincodeServiceExtAbility.ets](entry/src/main/ets/ServiceExtAbility/PincodeServiceExtAbility.ets)
  - PIN 输入：[InputServiceExtAbility.ets](entry/src/main/ets/ServiceExtAbility/InputServiceExtAbility.ets)
- 页面路由注册见 [main_pages.json](entry/src/main/resources/base/profile/main_pages.json)。

### 相关权限

以下权限主要声明于 [entry/src/main/module.json5](entry/src/main/module.json5)：

| 权限名 | 说明 |
|--------|------|
| ohos.permission.GET_BUNDLE_INFO | 获取应用包信息 |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | 获取应用包特权信息 |
| ohos.permission.DISTRIBUTED_DATASYNC | 分布式数据同步（分布式连接相关场景） |
| ohos.permission.SYSTEM_FLOAT_WINDOW | 系统悬浮窗 |
| ohos.permission.ACCESS_SERVICE_DM | 设备管理相关服务访问 |

权限等级与签名需按产品安全要求配置；本工程 [build-profile.json5](build-profile.json5) 中提供了示例签名路径（`signature` 目录）。

### 依赖

- 运行时依赖：`@ohos/axios`（声明于工程根目录 [oh-package.json5](oh-package.json5)）。
- 开发依赖：`@ohos/hypium`（声明于工程根目录 [oh-package.json5](oh-package.json5)）。

### 约束与限制

1. 本示例面向 TV / 大屏 DeviceManager 交互场景，需在支持对应系统能力与签名要求的 OpenHarmony 设备或模拟环境上运行。
2. 当前工程配置 `compileSdkVersion`、`compatibleSdkVersion` 为 `18`，建议使用匹配版本 SDK 与 DevEco Studio 构建。
3. 分布式同步、设备管理服务等能力依赖系统实现与权限授予，在能力受限环境中部分功能可能不可用。
4. 建议使用本工程 `signature` 目录下签名材料进行调试与集成验证；开发语言为 ArkTS。

### 下载

如需单独下载本工程，可执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVDeviceManagerUi > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
