# 标准化数据结构 (C/C++)指南文档示例

### 介绍

标准化数据结构主要针对部分标准化数据类型定义了统一的数据内容结构，并明确了对应的描述信息。应用间使用标准化数据结构进行数据交互后，将遵从统一的解析标准，可有效减少适配相关的工作量。一般用于跨应用跨设备间的数据交互，比如拖拽。本示例以PlainText、fileUri类型数据为例，说明如何使用标准化数据结构。

### 效果预览

| 桌面                                |
|-----------------------------------|
| ![image.PNG](screenshots/image.PNG) |

### 使用说明

1. 在主界面，点击geiPlainText按钮，插入并在控制台打印PlainText数据内容。

2. 在主界面，点击getFileUri按钮，插入并在控制台打印fileUri数据内容。

### 工程目录
```
entry/src/
|   |--- main/
|       |---ets/
|           |---entryability/EntryAbility.ets   // 应用启动加载的入口ability
|           |---entrybackupability/EntryBackupAbility.ets  // extensionAbility。
|           |---pages/index.ets                 // entry主应用入口页面
|           |---pages/UdmfInterface.ets                 // 标准化数据通路相关接口封装
|       |---cpp/
|           |---CMakeLists.txt                            // CMake配置文件
|           |---napi_init.cpp                             // Napi模块注册及接口调用实现
```

### 具体实现

* 主UI界面，功能包括纯文本类型及fileUri类型数据结构的使用，源码参考：[Index.ets](entry/src/main/cpp/napi_init.cpp)。
    * 添加及获取纯文本类型数据结构
    * 添加及获取fileUri类型数据结构。

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
echo code/DocsSample/ArkData/Udmf/UniformDataStructure_C > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````