# HAR指南文档示例

### 介绍

本示例介绍HAR中使用说明，介绍HAR定义的功能，组件，native方法，以及被集成使用说明。

### 效果预览
![img.png](screenshots/img.png)
![img_1.png](screenshots/img_1.png)
![img_2.png](screenshots/img_2.png)

### 使用说明

1. 编译dayjs模块，编译lottie模块，在编译library模块，最后编译安装entry模块。

1. 进入首页，点击button调用HAR中的func()方法。点击native_add按钮调用native方法。

1. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息
dayjs                                                 // 资源名称与lottie冲突模块
entry/src/
|   |--- main/
|        |--- module.json5                            // entry模块配置文件
|             |---ets/
|                 |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                 |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                 |---pages/index.ets                 // entry主应用入口页面
library/src/
|   |--- main/
|        |--- module.json5                            // library模块配置文件
lottie                                                // 资源名称与dayjs冲突模块
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
echo code/DocsSample/bmsSample/HarPackage > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````