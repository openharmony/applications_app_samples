# ArkTS使用JSVM-API接口进行object相关开发

### 介绍

使用JSVM-API接口进行object相关开发，处理JavaScript对象的基本操作的功能，例如创建对象、获取原型、冻结和密封对象，检查对象的类型等。这些操作是在处理JavaScript对象时非常常见的，提供了一种与JavaScript对象交互的方式。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API接口进行object相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-about-object.md)

### 效果预览

|                                首页                                 |                         执行及结果即时反馈                          |
| :-----------------------------------------------------------------: | :-----------------------------------------------------------------: |
| <img src="./screenshots/JsvmAboutObject_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmAboutObject_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
checkobjecttypetag/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libcheckobjecttypetag
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── checkobjecttypetagability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
createexternal/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libcreateexternal
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── createexternalability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
createobject/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libcreateobject
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── createobjectability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
createsymbol/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libcreatesymbol
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── createsymbolability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
getprototype/src/
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
getvalueexternal/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libgetvalueexternal
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── getvalueexternalability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
instanceof/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libinstanceof
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── instanceofability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
objectfreeze/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libobjectfreeze
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── objectfreezeability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
objectseal/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libobjectseal
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── objectsealability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
symbolfor/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libsymbolfor
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── symbolforability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
typeof/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libtypeof
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── typeofability
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
echo code/DocsSample/ArkTS/JSVMAPI/JsvmUsageGuide/JsvmAboutObject > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
