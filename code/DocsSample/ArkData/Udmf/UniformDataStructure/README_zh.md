# 标准化数据结构指南文档示例

### 介绍

本示例使用标准化数据结构定义数据内容（包含超链接、纯文本两条数据记录）为例，提供基本的开发步骤。数据提供方可通过UDMF提供的addRecord()接口添加数据记录，使用getRecords()接口获取当前数据对象内的所有数据记录。

### 效果预览

| 桌面                                |
|-----------------------------------|
| ![image.PNG](screenshots/image.PNG) |

### 使用说明

1. 使用IDE自动签名，编译，安装。

2. 启动应用->点击uniformDataStructure，在控制台打印详细数据信息。

### 工程目录
```
entry/src/
|   |--- main/
|       |---ets/
|           |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|           |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|           |---pages/index.ets                 // entry主应用入口页面
|           |---pages/UdmfInterface.ets                 // 接口调用实现
```

### 具体实现

* 主UI界面，功能包括添加及获取数据记录，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。
    * 数据提供方通过UDMF提供的addRecord()接口添加数据记录。
    * 使用getRecords()接口获取当前数据对象内的所有数据记录。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.53，镜像版本号：OpenHarmony_6.0.0.53。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 5, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkData/Udmf/UniformDataStructure > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````