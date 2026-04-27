# TV Settings Data 项目

### 介绍

本示例为 OpenHarmony TV 场景下的系统设置数据服务应用（`com.ohos.settingsdata`），基于 Stage 模型与多模块工程组织：`entry` 为入口模块，`product/tv` 为 TV 特性模块。工程通过 `DataShareExtensionAbility` 对外提供设置项的 DataShare 能力，结合关系型数据库（RDB）与 `default_settings.json` 等初始化数据，支撑设置类数据的查询、插入与更新；`entry` 模块在扩展侧完成数据库初始化与部分系统设置同步（如音量、时间等逻辑，见 `DataExtAbility` 实现），可作为大屏设置数据托管与跨应用共享的参考实现。

使用说明：

1. 数据共享入口为 `dataShare` 类型扩展能力：`entry` 模块注册为 [DataExtAbility.ets](entry/src/main/ets/DataAbility/DataExtAbility.ets)，`product/tv` 模块注册为 [SettingsDsExtAbility](product/tv/src/main/ets/DataAbility/DataExtAbility.ets)（名称不同，URI 均为 `datashare://com.ohos.settingsdata.DataAbility`）。
2. DataShare 表与 URI 映射见 [data_share_config.json](entry/src/main/resources/base/profile/data_share_config.json)；写入方需具备 `ohos.permission.MANAGE_SECURE_SETTINGS`（扩展上配置的 `writePermission`）。
3. 应用级 `AbilityStage`：`entry` 为 [DataAbilityStage.ets](entry/src/main/ets/Application/DataAbilityStage.ets)，`tv` 为 [AbilityStage.ets](product/tv/src/main/ets/Application/AbilityStage.ets)。
4. 数据库与配置键定义见 [SettingsDBHelper.ets](entry/src/main/ets/Utils/SettingsDBHelper.ets)、[SettingsDataConfig.ets](entry/src/main/ets/Utils/SettingsDataConfig.ets)；`tv` 模块内含用户变更相关 [UserChangeStaticSubscriber.ets](product/tv/src/main/ets/StaticSubscriber/UserChangeStaticSubscriber.ets) 示例（是否启用以模块配置为准）。
5. 公共日志见 [Log.ets](entry/src/main/ets/Utils/Log.ets)。

### 工程目录

```text
TVSettingsData/
|---AppScope/app.json5                              // 应用级配置（包名、版本等）
|---build-profile.json5                             // 工程构建配置（SDK、签名、模块列表）
|---oh-package.json5                                // 工程依赖配置
|---signature/                                     // 签名材料（.p12 / .cer / .p7b 等）
|---entry/                                         // 入口模块（DataShare、权限与 data_share 元数据）
|   |---build-profile.json5
|   |---oh-package.json5
|   |---src/main/
|   |   |---module.json5                            // 模块配置（ExtensionAbility、权限）
|   |   |---ets/
|   |   |   |---Application/DataAbilityStage.ets  // AbilityStage
|   |   |   |---DataAbility/DataExtAbility.ets     // DataShare 扩展能力
|   |   |   |---Utils/                             // Log、SettingsDBHelper、SettingsDataConfig 等
|   |   |---resources/base/profile/
|   |   |   |---data_share_config.json              // DataShare URI 与表配置
|   |   |   |---static_subscriber_config.json      // 静态订阅配置（若启用）
|   |   |---resources/rawfile/default_settings.json
|---product/tv/                                    // TV 特性模块
|   |---build-profile.json5
|   |---oh-package.json5
|   |---src/main/
|   |   |---module.json5
|   |   |---ets/
|   |   |   |---Application/AbilityStage.ets
|   |   |   |---DataAbility/DataExtAbility.ets     // SettingsDsExtAbility 实现
|   |   |   |---StaticSubscriber/UserChangeStaticSubscriber.ets
|   |   |   |---Utils/、common/
```

### 具体实现

- 应用级生命周期：`entry` 见 [DataAbilityStage.ets](entry/src/main/ets/Application/DataAbilityStage.ets)，`tv` 见 [AbilityStage.ets](product/tv/src/main/ets/Application/AbilityStage.ets)。
- DataShare 扩展在 `onCreate` 中初始化上下文与 RDB，并处理 `insert` / `query` / `update` 等请求（实现见各模块 `DataExtAbility.ets`）。
- `entry` 侧扩展注册了 `ohos.extension.dataShare` 元数据，资源指向 [data_share_config.json](entry/src/main/resources/base/profile/data_share_config.json)。
- 页面/源码列表注册见各模块 [main_pages.json](entry/src/main/resources/base/profile/main_pages.json)。

### 相关权限

以下权限主要声明于 [entry/src/main/module.json5](entry/src/main/module.json5)：

| 权限名 | 说明 |
|--------|------|
| ohos.permission.ACCESS_NOTIFICATION_POLICY | 通知策略相关访问 |
| ohos.permission.ACCESS_BLUETOOTH | 蓝牙访问（DataExtAbility 使用场景） |
| ohos.permission.GET_NETWORK_INFO | 获取网络信息 |
| ohos.permission.SET_TIME | 设置系统时间（与设置同步等逻辑相关） |

对 DataShare 写入方：`DataShareExtensionAbility` 上配置了 `writePermission` 为 `ohos.permission.MANAGE_SECURE_SETTINGS`，调用方需具备相应权限与签名策略。

权限等级与签名需按产品安全要求配置；本工程 [build-profile.json5](build-profile.json5) 中提供了示例签名路径（`signature` 目录）。

### 依赖

- 开发依赖：`@ohos/hypium`、`@ohos/hamock`（声明于工程根目录 [oh-package.json5](oh-package.json5)）。

### 约束与限制

1. 本示例面向 TV / 大屏设置数据托管与 DataShare 场景，需在支持对应系统能力与签名要求的 OpenHarmony 设备或模拟环境上运行。
2. 当前工程配置 `compileSdkVersion`、`compatibleSdkVersion` 为 `18`，建议使用匹配版本 SDK 与 DevEco Studio 构建。
3. DataShare、安全设置写入等能力依赖系统实现与权限授予，在能力受限环境中部分功能可能不可用。
4. 建议使用本工程 `signature` 目录下签名材料进行调试与集成验证；开发语言为 ArkTS。

### 下载

如需单独下载本工程，可执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVSettingsData > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
