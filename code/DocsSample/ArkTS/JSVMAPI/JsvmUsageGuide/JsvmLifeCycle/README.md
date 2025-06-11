# ArkTs使用JSVM-API接口进行生命周期相关开发

### 介绍

在JSVM-API中，JSVM_Value是一个表示JavaScript值的抽象类型，它可以表示任何JavaScript值，包括基本类型（如数字、字符串、布尔值）和对象类型（如数组、函数、对象等）。 JSVM_Value的生命周期与其在JavaScript中的对应值的生命周期紧密相关。当JavaScript值被垃圾回收时，与之关联的JSVM_Value也将不再有效。重要的是不要在JavaScript值不再存在时尝试使用JSVM_Value。

框架层的scope通常用于管理JSVM_Value的生命周期。在JSVM-API中，可以使用OH_JSVM_OpenHandleScope和OH_JSVM_CloseHandleScope函数来创建和销毁scope。通过在scope内创建JSVM_Value，可以确保在scope结束时自动释放JSVM_Value，避免内存泄漏。

JSVM_Ref是一个JSVM-API类型，用于管理JSVM_Value的生命周期。JSVM_Ref允许您在JSVM_Value的生命周期内保持对其的引用，即使它已经超出了其原始上下文的范围。这使得您可以在不同的上下文中共享JSVM_Value，并确保在不再需要时正确释放其内存。

合理使用OH_JSVM_OpenHandleScope和OH_JSVM_CloseHandleScope管理JSVM_Value的生命周期，做到生命周期最小化，避免发生内存泄漏问题。

每个JSVM_Value属于特定的HandleScope，HandleScope通过OH_JSVM_OpenHandleScope和OH_JSVM_CloseHandleScope来建立和关闭，HandleScope关闭后，所属的JSVM_Value就会自动释放。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API接口进行生命周期相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-life-cycle.md)

### 效果预览

|                               首页                                |                        执行及结果即时反馈                         |
| :---------------------------------------------------------------: | :---------------------------------------------------------------: |
| <img src="./screenshots/JsvmLifeCycle_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmLifeCycle_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
addfinalizer/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
openescapablehandlescope/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
openhandlescope/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
referenceref/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：Phone。

2.本示例为Stage模型，支持API15版本SDK，版本号：5.0.3.135，镜像版本号：HarmonyOS NEXT_5.0.3.135。

3.本示例需要使用DevEco Studio 5.0.3 Release (Build Version: 5.0.9.300, built on March 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTs/JSVMAPI/JsvmUsageGuide/JsvmLifeCycle > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
