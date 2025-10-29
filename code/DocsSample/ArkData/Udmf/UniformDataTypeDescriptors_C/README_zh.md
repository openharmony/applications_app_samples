# 标准化数据类型 (C/C++)指南文档示例

### 介绍

标准化数据类型主要针对同一种数据类型，提供统一定义，即标准数据类型描述符，定义了包括标识数据类型的ID、类型归属关系等相关信息，用于解决OpenHarmony系统中的类型模糊问题。一般用于过滤或者识别某一种数据类型的场景，比如文件预览、文件分享等。本示例以媒体类文件的归属类型查询场景为例，提供基本的开发步骤。

### 效果预览

| 桌面                                |
|-----------------------------------|
| ![image.PNG](screenshots/image.PNG) |

### 使用说明

1. 使用IDE自动签名，编译，安装。

2. 启动应用->点击getTypesAndCompare按钮，在控制台打印相关数据比较信息。

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

* 主UI界面，功能包括通过不同方式获取不同类型数据并且比较它们之间的关系，源码参考：[Index.ets](entry/src/main/cpp/napi_init.cpp)。
    * 通过getTypesAndCompare()接口获取不同类型数据，创建UTD实例对象并比较比较UTD实例对象是否相等、两种方式获取到的typeId是否存在归属关系及是否高低层级类型。

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
echo code/DocsSample/ArkData/Udmf/UniformDataTypeDescriptors_C > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````