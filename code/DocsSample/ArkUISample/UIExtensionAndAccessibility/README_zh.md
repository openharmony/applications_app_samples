# 使用UIExtension控件与ArkUI无障碍指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解UIExtension控件与ArkUI无障碍属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [跨进程应用能力扩展（UIExtension，仅对系统应用开放）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-ui-extension-components.md)。
2. [同应用进程嵌入式组件 (EmbeddedComponent)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-embedded-components.md)。
3. [全屏启动原子化服务组件（FullScreenLaunchComponent）](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-FullScreenComponent.md)。
4. [跨线程嵌入式组件 (IsolatedComponent，仅对系统应用开放)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-isolated-components.md)。
5. [支持无障碍](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-universal-attributes-accessibility.md)。

### 效果预览

| 首页选项目录                                 | Isolated目录                            | Isolated示例                            |
|------------------------------------|------------------------------------|------------------------------------|
| ![](screenshots/device/image1.jpg) | ![](screenshots/device/image2.jpg) | ![](screenshots/device/image3.jpg) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---EmbeddedComponent                   // EmbeddedComponent 组件
|   |       |---Embedded.ets
|   |       |---Extension.ets
|   |       |---Index.ets
|   |---FullScreenLaunchComponent           // FullScreenLaunchComponent 组件
|   |       |---FullScreenLaunch.ets
|   |       |---Index.ets
|   |---IsolatedComponent                   // IsolatedComponent 组件
|   |       |---Extension.ets
|   |       |---Index.ets
|   |       |---Isolated.ets
|   |---UIExtensionComponent                // UIExtensionComponent 组件
|   |       |---Extension.ets
|   |       |---Index.ets
|   |       |---UIExtension.ets
|   |---UniversalAttributesAccessibility    // ArkUI 无障碍能力
|   |       |---AccessibilityGroup.ets
|   |       |---AccessibilityText.ets
|   |       |---Index.ets
|---pages
|   |---Index.ets                           // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                      // 示例代码测试代码
```

### 相关权限

ohos.permission.RUN_DYN_CODE

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API18版本SDK，版本号：5.1.0.59，镜像版本号：OpenHarmony_5.1.0.59。

3.本示例需要使用DevEco Studio 5.0.3 Release (Build Version: 5.0.9.300, built on March 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/UIExtensionAndAccessibility > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````