# HSP指南文档示例

### 介绍

本示例介绍HSP中使用说明，介绍利用Navigation跳转，从entry模块跳转到library，在返回到entry模块。

### 效果预览


### 使用说明

1. 编译library模块，最后编译安装entry模块。

1. 进入首页，点击click_to_menu文本跳转到library模块的页面，点击back_to_index按钮返回entry模块。

1. 通过自动测试框架可进行测试及维护。

### 工程目录
```
AppScope/
|   |---resources/                                    // 工程级的资源目录
|   |--- app.json5                                    // 应用的全局配置信息
entry/src/
|   |--- main/
|        |--- module.json5                            // entry模块配置文件
|             |---ets/
|                 |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|                 |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|                 |---pages/index.ets                 // entry主应用入口页面
library/src/
|   |--- main/
|       |--- module.json5                           // library模块配置文件
|       |--- cpp/                                   // native模块
|       |--- ets/
|           |--- pages/library_menu.ets             // HSP的页面
|           |--- utils/                             // 工具
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
echo code/DocsSample/bmsSample/InAppHsp2 > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````