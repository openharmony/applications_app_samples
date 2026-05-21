# 配置应用图标和名称指南文档示例

### 介绍

本示例展示了应用如何配置和使用备用图标。

1.应用需要在[app.json5配置文件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/app-configuration-file.md)中添加[alternateIcons标签](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/app-configuration-file.md#alternateicons%E6%A0%87%E7%AD%BE)，声明备用图标列表。

2.使用[bundleManager.setAlternateIcon](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-bundleManager.md#bundlemanagersetalternateicon)接口启用备用图标或恢复默认图标。

3.使用[bundleManger.getAlternateIcons](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-bundleManager.md#bundlemanagergetalternateicons)接口查询本应用配置的备用图标及其启用状态。

### 效果预览

| 桌面                              |首页                              |
|---------------------------------|---------------------------------|
| ![img.png](screenshots/img.png) |![img_1.png](screenshots/img_1.png)|

### 使用说明

1. 使用IDE自动签名，编译，安装，运行。

2. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息
entry/src/
|   |--- main/
|        |--- module.json5                            // entry模块配置hap类型："type": "entry"
|             |---ets/
|                 |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                 |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                 |---pages/index.ets                 // entry主应用入口页面
```

### 具体实现

1. **设置备用图标**：通过`bundleManager.setAlternateIcon`接口，传入在app.json5中配置的备用图标的名称（如`summer_theme`），来为本应用设置一个备用图标。

2. **恢复默认图标**：通过`bundleManager.setAlternateIcon`接口，传入空字符串，来将本应用的图标恢复为默认图标。

3. **查询备用图标**：通过`bundleManager.getAlternateIcons`接口，获取本应用配置的所有备用图标。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：tablet（平板或者平板模拟器）。

2.本示例为Stage模型，支持API版本26.0.0版本SDK，版本号：7.0.0.24，镜像版本号：OpenHarmony_7.0.0.24。

3.本示例需要使用DevEco Studio 6.1.0 Release (Build Version: 6.1.0.850, built on May 18, 2026)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/bmsSample/LayeredImage3 > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````