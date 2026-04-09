# 设置项目

### 介绍

设置应用是 OpenHarmony 的预置系统应用，为用户提供系统属性配置入口，覆盖系统声音、屏幕亮度、有线网络、无线网络、蓝牙连接、设备名称、时间日期等常用系统设置能力。

本工程为 TV 形态的设置应用示例，适配电视端遥控器交互和大屏界面展示。

使用说明：

1. 首页采用 TV 风格焦点交互，支持使用遥控器在各类设置入口之间切换。
2. 网络页面支持有线网络、无线网络、热点等相关配置与状态查看。
3. 显示页面支持 HDMI、HDR、色温、显示区域、显示制式等图像参数设置。
4. 系统、蓝牙、音量、输入源、恢复出厂设置等能力均可通过对应页面进行管理。

### 工程目录
```text
product/tv/src/main/ets/
|---Application
|   |---AbilityStage.ets                 // 应用生命周期入口
|---MainAbility
|   |---AbilityContextManager.ets        // Ability 上下文管理
|   |---BluetoothPairDialogAbility.ets   // 蓝牙配对弹窗 Ability
|   |---MainAbility.ets                  // 主 Ability
|---common
|   |---constants/                       // 常量定义
|   |---BytesFormatManager.ets           // 数据格式化工具
|   |---DateUtil.ets                     // 日期工具
|   |---EventUtil.ets                    // 事件工具
|   |---UserStorageManager.ets           // 用户存储管理
|---controller
|   |---bluetooth/                       // 蓝牙控制逻辑
|   |---password/                        // 密码校验逻辑
|   |---restoreFactorySettings/          // 恢复出厂设置控制逻辑
|---default
|   |---layout/                          // TV 默认布局组件
|   |---model/                           // TV 默认布局模型
|---enterpriseadminability
|   |---EnterpriseAdminAbility.ets       // 企业管理能力
|---model
|   |---aboutDeviceImpl/                 // 设备信息模型
|   |---bluetoothImpl/                   // 蓝牙数据模型
|   |---display/                         // 显示设置模型
|   |---general/                         // 通用设置模型
|   |---wifiImpl/                        // Wi-Fi 设置模型
|---pages
|   |---bluetooth/                       // 蓝牙页面
|   |---display/                         // 显示页面
|   |---general/                         // 通用设置页面
|   |---hotspot/                         // 热点页面
|   |---network/                         // 网络页面
|   |---system/                          // 系统页面
|   |---volume/                          // 音量页面
|   |---SettingList.ets                  // 设置列表入口页
```

### 具体实现

- 应用入口与生命周期管理能力封装在 [MainAbility.ets](product/tv/src/main/ets/MainAbility/MainAbility.ets)
    * 负责主界面启动、窗口初始化和 TV 端应用入口拉起；
    * 配合 [AbilityStage.ets](product/tv/src/main/ets/Application/AbilityStage.ets) 管理 Stage 生命周期。
- 设置首页与列表渲染能力封装在 [EntrySetting.ets](product/tv/src/main/ets/default/layout/EntrySetting.ets)
    * 提供 TV 风格设置首页入口与焦点切换逻辑；
    * 结合 `SettingItemTvComponent`、`SettingListTvComponent` 完成设置项渲染与交互。
- 网络与连接能力封装在 [Network.ets](product/tv/src/main/ets/pages/network/Network.ets)
    * 支持有线网络、Wi-Fi、热点、IP、网关、DNS 等网络配置页面；
    * 网络数据处理依赖 `WifiModel`、`WifiProvider` 等模型能力。
- 蓝牙、显示和系统设置能力分别封装在 [BluetoothDeviceEntry.ets](product/tv/src/main/ets/pages/bluetooth/BluetoothDeviceEntry.ets)、[Display.ets](product/tv/src/main/ets/pages/display/Display.ets)、[System.ets](product/tv/src/main/ets/pages/system/System.ets)
    * 蓝牙页面支持设备发现、配对与连接管理；
    * 显示页面支持 HDR、色温、HDMI、显示区域等图像能力配置；
    * 系统页面支持设备信息、时间日期、软件升级等系统设置。

### 相关权限

| 权限名                                   | 权限说明                     | 级别 |
|---------------------------------------|--------------------------|------|
| ohos.permission.MANAGE_WIFI_CONNECTION | 允许应用管理 Wi-Fi 连接          | -    |
| ohos.permission.MANAGE_BLUETOOTH      | 允许应用管理蓝牙设备与连接           | -    |
| ohos.permission.FACTORY_RESET         | 允许应用执行恢复出厂设置相关操作       | -    |
| ohos.permission.MODIFY_AUDIO_SETTINGS | 允许应用修改系统音频与音量相关设置      | -    |

### 依赖

本工程主要依赖 `common/component`、`common/search`、`common/settingsBase`、`common/utils` 等公共模块，并结合系统设置相关能力接口完成 TV 端功能实现。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568, V900。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 12 Release),镜像版本号(5.0 Release)

3.本示例需要使用DevEco Studio 版本号(5.0 Release)及以上版本才可编译运行。

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
，把配置文件中的“apl”字段信息改为“system_core”。

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVSettings > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```