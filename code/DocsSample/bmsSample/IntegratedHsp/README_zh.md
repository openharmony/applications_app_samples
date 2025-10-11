# 集成态HSP文档示例

### 介绍

本示例通过相关配置调整，将HSP转化成集成态HSP，编译产物tgz包，提供给entry集成使用。

### 效果预览
![img.png](img.png)

### 使用说明

1. IDE配置自动签名，选择library模块，编译，构建成tgz产物，给entry模块集成。

2. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息
entry/
|   |--- src/
|       |--- main/
|           |--- module.json5                            // entry模块配置文件
|               |---ets/
|                   |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                   |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                   |---pages/index.ets                 // entry主应用入口页面
|   |--- libs/library-default.tgz                       // library编译出来的集成态HSP产物
library/src/
|   |--- main/
|        |--- module.json5                            // library模块配置文件
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API19版本SDK，版本号：5.1.1.212，镜像版本号：OpenHarmony_5.1.1.212。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.840, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/bmsSample/IntegratedHsp > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````