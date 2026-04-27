# TV SystemUI 项目

### 介绍

本示例为 OpenHarmony TV 场景下的 SystemUI 系统应用（`com.ohos.systemui`），基于 Stage 模型与多模块工程组织，向用户提供系统信息展示与系统级交互能力，包括音量面板、窗口与焦点管理、遥控/输入事件监听与分发、配件蓝牙配对服务等。工程包含主入口模块 `tv_entry`、公共 HAR `common`，以及 TV 音量面板、配件配对、通用对话框等特性模块，可作为大屏 SystemUI 相关能力的参考实现。

使用说明：

1. 应用以 `ServiceExtensionAbility` 作为主入口，在系统侧拉起后初始化 SystemUI 相关窗口与子系统能力。
2. TV 形态采用 TV 风格交互；相较手机默认形态，通常不包含锁屏、通知中心、通知管理、控制中心、状态栏等部件，并侧重遥控器键值响应与分发。
3. 音量相关展示与交互由 TV 音量面板特性模块承载，可与系统音频策略协同。
4. 配件配对由 `tv_pairservice` 特性模块提供蓝牙发现、配对等流程（依赖系统蓝牙与权限能力）。
5. 公共日志、窗口管理、Ability 协调等能力沉淀在 `common` HAR 中，由各模块按需引用。

### 工程目录

```text
TVSystemUi/
|---AppScope/app.json5                              // 应用级配置（包名、版本等）
|---build-profile.json5                             // 工程构建配置（SDK、签名、模块列表）
|---oh-package.json5                                // 工程依赖配置
|---signature/                                     // 签名材料（.p12 / .cer / .p7b 等）
|---entry/tv/                                      // TV 主入口模块（tv_entry）
|   |---build-profile.json5
|   |---src/main/
|   |   |---module.json5                            // 入口模块配置（ExtensionAbility、权限）
|   |   |---ets/
|   |   |   |---Application/AbilityStage.ets        // AbilityStage，全局初始化与公共事件订阅
|   |   |   |---ServiceExtAbility/ServiceExtAbility.ets  // 主 ServiceExtensionAbility，窗口与输入链路等
|   |   |   |---pages/                              // 页面：首页、对话框、悬浮窗、清晰度设置等
|   |   |   |---components/                         // TV 设置列表、亮度等 UI 组件
|   |   |   |---model/                              // 导航栏事件、用户存储等模型
|   |   |   |---controlPanelModel/                  // 投屏、亮度等业务模型
|   |   |   |---utils/                              // 样式、事件、指针等工具
|---common/                                         // 公共 HAR（@ohos/common）
|   |---src/main/ets/default/                       // 日志、窗口、Ability 管理、初始化等
|---product/tv/volumepanel/                        // TV 音量面板特性模块（tv_volumepanel）
|   |---src/main/ets/ServiceExtAbility/ServiceExtAbility.ets
|---product/tv/pairService/                         // TV 配件配对特性模块（tv_pairservice）
|   |---src/main/ets/service/PartsPairService.ets   // 配对 Service 主入口
|---product/default/dialog/                        // 通用对话框特性模块（default_dialog）
|---features/volumepanelcomponent/                 // 音量面板组件特性 HAR
|---features/navigationservice/                    // 导航服务特性 HAR
```

### 具体实现

- 应用级生命周期与全局事件订阅见 [AbilityStage.ets](entry/tv/src/main/ets/Application/AbilityStage.ets)。
- SystemUI 主服务能力集中在 [ServiceExtAbility.ets](entry/tv/src/main/ets/ServiceExtAbility/ServiceExtAbility.ets)：
  - 窗口创建与层级管理、音频与显示相关协同；
  - 输入监听、遥控与触摸等事件的响应与分发逻辑；
  - 与 `common` 中 `InitSystemUi`、`WindowManager`、`AbilityManager` 等协作完成子模块协调。
- TV 音量面板由特性模块承载，入口见 [product/tv/volumepanel/.../ServiceExtAbility.ets](product/tv/volumepanel/src/main/ets/ServiceExtAbility/ServiceExtAbility.ets)，具体 UI 与业务可参考 `features/volumepanelcomponent` 与 `product/tv/volumepanel` 下的页面与 ViewModel。
- 配件配对流程见 [PartsPairService.ets](product/tv/pairService/src/main/ets/service/PartsPairService.ets) 及同目录下相关 Model、IDL 实现。
- TV 设置与辅助页面见 `entry/tv/src/main/ets/pages/`（如 [index.ets](entry/tv/src/main/ets/pages/index.ets)、[dialog.ets](entry/tv/src/main/ets/pages/dialog.ets) 等）。

### 相关权限

以下权限主要声明于 [entry/tv/src/main/module.json5](entry/tv/src/main/module.json5)（入口模块）：

| 权限名 | 说明 |
|--------|------|
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | 获取应用包特权信息 |
| ohos.permission.MANAGE_LOCAL_ACCOUNTS | 管理本地账户 |
| ohos.permission.INTERACT_ACROSS_LOCAL_ACCOUNTS_EXTENSION | 跨本地账户扩展交互 |
| ohos.permission.NOTIFICATION_CONTROLLER | 通知控制能力 |
| ohos.permission.GET_WIFI_INFO / SET_WIFI_INFO / MANAGE_WIFI_CONNECTION | Wi-Fi 信息与连接管理 |
| ohos.permission.GET_NETWORK_INFO | 获取网络连接状态 |
| ohos.permission.USE_BLUETOOTH / DISCOVER_BLUETOOTH / MANAGE_BLUETOOTH | 蓝牙使用、发现与管理 |
| ohos.permission.CAPTURE_SCREEN | 屏幕捕获相关能力 |
| ohos.permission.MANAGE_SECURE_SETTINGS | 安全设置管理 |
| ohos.permission.ACCESS_NOTIFICATION_POLICY | 通知策略访问 |
| ohos.permission.MODIFY_AUDIO_SETTINGS | 音频设置（如音量调节场景） |
| ohos.permission.DISTRIBUTED_DATASYNC | 分布式数据同步 |
| ohos.permission.START_INVISIBLE_ABILITY / START_ABILITIES_FROM_BACKGROUND | 不可见 Ability 与后台拉起 |
| ohos.permission.GET_TELEPHONY_STATE | 获取电话相关状态（随系统集成策略使用） |
| ohos.permission.INPUT_MONITORING | 输入监控（键鼠/遥控事件链路） |
| ohos.permission.STORAGE_MANAGER | 存储管理 |
| ohos.permission.GET_RUNNING_INFO | 运行信息获取 |
| ohos.permission.ACCESS_SERVICE_DM | 设备管理相关服务访问 |
| ohos.permission.ACCESS_SCREEN_LOCK_INNER | 锁屏内部能力 |
| ohos.permission.POWER_MANAGER | 电源管理 |

配件配对特性模块在 [product/tv/pairService/src/main/module.json5](product/tv/pairService/src/main/module.json5) 中补充声明蓝牙与后台拉起等权限（如 `ACCESS_BLUETOOTH` 等）。权限等级与签名需按产品安全要求配置；本工程 `build-profile.json5` 中提供了示例签名路径。

### 依赖

- 各模块通过工程内 HAR 与相对路径依赖 `common`、`features` 等，详见各子模块 `oh-package.json5`（若存在）。
- 开发依赖：`@ohos/hypium`（声明于工程根目录 [oh-package.json5](oh-package.json5)）。

### 约束与限制

1. 本示例面向 TV / 大屏 SystemUI 场景，需在支持对应系统能力与签名要求的 OpenHarmony 设备或模拟环境上运行。
2. 当前工程配置 `compileSdkVersion`、`compatibleSdkVersion`、`targetSdkVersion` 为 `18`，建议使用匹配版本 SDK 与 DevEco Studio 构建。
3. 输入监听、蓝牙、后台拉起、电源与锁屏等能力依赖系统实现与权限授予，在能力受限环境中部分功能可能不可用。
4. README_zh 中建议：使用本工程 `signature` 目录下签名材料进行调试与集成验证；开发语言为 ArkTS（eTS）。

### 下载

如需单独下载本工程，可执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVSystemUi > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
