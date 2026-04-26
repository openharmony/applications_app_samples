# TV Demand Player 项目

### 介绍

本示例为 OpenHarmony TV 场景下的点播播放器应用，基于 Stage 模型实现网络点播、本地视频浏览播放、文件管理器拉起播放、DLNA 播放与分布式流转等能力。项目包含主应用 `entry` 与公共工具 HAR `Utilslibrary`，可用于大屏视频播放场景的功能参考。

使用说明：

1. 主页提供「网络视频」与「本地视频」两类入口，支持遥控器/键盘焦点导航与按键操作。
2. 网络视频列表页支持在线媒体资源展示与播放跳转。
3. 本地视频支持按目录浏览，选择后进入播放器页面进行播放控制。
4. 支持通过 `ohos.want.action.viewData` 从文件管理器直接拉起并播放视频文件。
5. 支持 DLNA 相关能力与跨设备流转场景（依赖设备与系统配置）。

### 工程目录

```text
TVDemandPlayer/
|---AppScope/app.json5                              // 应用级配置
|---build-profile.json5                             // 工程构建配置（SDK/模块）
|---oh-package.json5                                // 工程依赖配置
|---entry/                                          // 主应用模块
|   |---build-profile.json5
|   |---src/main/
|   |   |---module.json5                            // entry 模块配置（Ability、权限）
|   |   |---ets/
|   |   |   |---Application/MyAbilityStage.ets      // AbilityStage 入口
|   |   |   |---MainAbility/MainAbility.ets         // 主 UIAbility，处理入口参数与窗口初始化
|   |   |   |---serviceability/ServiceAbility.ets   // ServiceExtensionAbility，流转连接与控制
|   |   |   |---dlnaAbility/DlnaAbility.ets         // DLNA 相关 Ability
|   |   |   |---pages/                              // 页面：主页、网络列表、本地目录/列表、播放器
|   |   |   |---components/                         // 播放控制与设置等组件
|   |   |   |---Model/                              // 播放器、DRM、数据库等模型
|   |   |   |---utils/                              // 日志、权限、时间、事件等工具
|   |   |   |---const/                              // 常量与类型定义
|---Utilslibrary/                                   // 公共 HAR（@ohos/utilslibrary）
|   |---index.ts                                    // HAR 导出入口
|   |---src/main/ets/                               // 公共能力：日志、权限、窗口、网络等
|---sdk/apis/                                       // 本地 API 声明补充
```

### 具体实现

- 应用入口与生命周期管理见 [MainAbility.ets](entry/src/main/ets/MainAbility/MainAbility.ets)
  - 初始化播放器实例、窗口属性与全局状态。
- 播放主流程集中在 `pages` 与 `Model`：
  - [Index.ets](entry/src/main/ets/pages/Index.ets) 提供主页入口与焦点交互；
  - [HttpVideoList.ets](entry/src/main/ets/pages/HttpVideoList.ets)、[LocalFolderList.ets](entry/src/main/ets/pages/LocalFolderList.ets)、[LocalVideoList.ets](entry/src/main/ets/pages/LocalVideoList.ets) 管理媒体列表；
  - [VideoPlayer.ets](entry/src/main/ets/pages/VideoPlayer.ets) 与 [AvPlayer.ets](entry/src/main/ets/Model/AvPlayer.ets) 实现播放控制能力。
- 分布式与服务能力封装在 [ServiceAbility.ets](entry/src/main/ets/serviceability/ServiceAbility.ets) 与 `DlnaService` 目录。
- 公共日志、权限申请、窗口与输入辅助能力沉淀在 `Utilslibrary`，由工程通过 `@ohos/utilslibrary` 引用。

### 相关权限

以下权限声明位于 [entry/src/main/module.json5](entry/src/main/module.json5)：

| 权限名 | 说明 |
|--------|------|
| ohos.permission.INTERNET | 访问网络媒体资源 |
| ohos.permission.GET_NETWORK_INFO | 获取网络连接状态 |
| ohos.permission.READ_MEDIA / WRITE_MEDIA | 读取与写入媒体文件 |
| ohos.permission.READ_IMAGEVIDEO / READ_AUDIO / READ_DOCUMENT | 读取本地多媒体与文档 |
| ohos.permission.MEDIA_LOCATION | 读取媒体位置信息 |
| ohos.permission.FILE_ACCESS_MANAGER / STORAGE_MANAGER | 文件与存储管理 |
| ohos.permission.DISTRIBUTED_DATASYNC / DISTRIBUTED_SOFTBUS_CENTER | 分布式流转与设备协同 |
| ohos.permission.MODIFY_AUDIO_SETTINGS / MANAGE_AUDIO_CONFIG | 音频设置与配置管理 |
| ohos.permission.CAPTURE_SCREEN | 屏幕捕获相关能力 |
| ohos.permission.START_ABILITIES_FROM_BACKGROUND / START_INVISIBLE_ABILITY | 后台拉起相关能力 |
| ohos.permission.GET_BUNDLE_INFO / GET_BUNDLE_INFO_PRIVILEGED | 获取应用包信息 |
| ohos.permission.MANAGE_MISSIONS / GET_RUNNING_INFO | 任务与运行信息管理 |
| ohos.permission.INJECT_INPUT_EVENT | 注入输入事件（交互场景） |

权限等级与签名配置需按设备产品安全要求进行适配。

### 依赖

- 工程依赖本地 HAR：`@ohos/utilslibrary`（路径：`Utilslibrary`），声明于 [oh-package.json5](oh-package.json5)。
- 测试依赖：`@ohos/hypium`。

### 约束与限制

1. 本示例面向 TV/大屏视频点播场景，需在支持对应能力的 OpenHarmony 系统上运行。
2. 当前工程配置 `compileSdkVersion` 与 `compatibleSdkVersion` 为 `18`，建议使用匹配版本 SDK 与 DevEco Studio 构建。
3. 分布式流转、DLNA、后台拉起等能力对系统权限与设备环境有要求，若权限或系统能力不足，相关功能可能不可用。

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVDemandPlayer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
