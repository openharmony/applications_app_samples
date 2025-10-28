# 创建应用分身指南文档示例

### 介绍

本示例通过配置app.json5配置文件multiAppMode字段，配置应用分身。

### 效果预览

| 桌面                              |
|---------------------------------|
|![img.png](screenshots/img.png) |

### 使用说明

1. 使用IDE自动签名，编译，安装。

2. 设置 -> 系统 -> 应用分身 -> 点击应用 创建分身。

2. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息，multiAppMode字段配置应用分身
entry/src/
|   |--- main/
|        |--- module.json5                            // entry模块配置hap类型："type": "entry"
|             |---ets/
|                 |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                 |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                 |---pages/index.ets                 // entry主应用入口页面
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：tablet（平板或者平板模拟器）。

2.本示例为Stage模型，支持API19版本SDK，版本号：5.1.1.212，镜像版本号：OpenHarmony_5.1.1.212。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.840, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/bmsSample/AppClone > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````