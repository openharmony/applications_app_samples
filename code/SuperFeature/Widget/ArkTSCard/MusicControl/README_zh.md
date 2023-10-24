# ArkTs音乐卡片

### 介绍

本示例展示了如何通过ArkTS卡片实现一个简单的音乐卡片

### 效果预览

|服务卡片界面                                    |音乐卡片任务                                |
|---------------------------------------|-------------------------------------|
|![image](screenshots/device/card.jpg) |![image](screenshots/device/start.jpg)|

### 使用说明

1.安装应用，并在桌面上长按本应用的桌面图标，长按后弹出选项列表。

2.点击弹出列表中的服务卡片选项进入卡片添加界面。

3.点击正下方的添加到桌面按钮，卡片就会出现在桌面上。

### 工程目录

```
entry/src/main/ets/
|---feature
    |---BackgroundPlayerFeature.ts        // 音乐功能处理文件
|---mock
    |---BackgroundPlayerData.ts           // 音乐文件数据
|---entryability
    |---EntryAbility.ts                    // Ability声明周期处理文件
|---entryformability
|   |---EntryFormAbility.ts                // 卡片声明周期处理文件
|---pages
|   |---index.ets                          // 首页
|---music
|   |---pages
|   |   |---MusicCard.ets                  // 音乐卡片页面
```

### 相关权限

[ohos.permission.KEEP_BACKGROUND_RUNNING](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionkeep_background_running)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4.本示例需要使用系统权限的系统接口，需要使用Full SDK编译。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

5.本示例使用了ServiceExtensionAbility，需要在签名证书UnsgnedReleasedProfileTemplate.json中配置"app-privilege-capabilities": ["AllowAppUsePrivilegeExtension"]，否则安装失败。具体操作指南可参考[应用特权配置指南](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)。

6.本示例所配置的权限均为system_basic或system_core级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/))。

7.本示例类型为系统应用，需要手动配置对应级别的应用类型("app-feature": "hos_system_app")。具体可参考profile配置文件[bundle-info对象内部结构](https://gitee.com/openharmony/docs/blob/eb73c9e9dcdd421131f33bb8ed6ddc030881d06f/zh-cn/application-dev/security/app-provision-structure.md#bundle-info%E5%AF%B9%E8%B1%A1%E5%86%85%E9%83%A8%E7%BB%93%E6%9E%84)
