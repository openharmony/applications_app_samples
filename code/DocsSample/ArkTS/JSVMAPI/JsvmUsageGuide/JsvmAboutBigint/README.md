# ArkTS使用JSVM-API接口操作bigint类型值

### 介绍

BigInt是JavaScript中用于表示任意精度整数的数据类型，它能够处理比Number类型更大范围的整数值。通过JSVM-API提供的接口，可以在JSVM模块中创建、获取和操作BigInt类型值，从而实现与BigInt相关的功能扩展。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API接口操作bigint类型值](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-about-bigint.md)

### 效果预览

|                                首页                                 |                         执行及结果即时反馈                          |
| :-----------------------------------------------------------------: | :-----------------------------------------------------------------: |
| <img src="./screenshots/JsvmAboutBigint_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmAboutBigint_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
createbigintint64/src/
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
createbigintuint64/src/
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
createbigintwords/src/
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
getvaluebigintint64/src/
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
getvaluebigintuint64/src/
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
getvaluebigintwords/src/
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
echo code/DocsSample/ArkTs/JSVMAPI/JsvmUsageGuide/JsvmAboutBigint > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
