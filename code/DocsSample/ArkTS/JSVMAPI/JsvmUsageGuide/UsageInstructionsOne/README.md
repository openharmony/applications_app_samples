# ArkTS JSVM-API使用指导

### 介绍

使用JSVM-API实现跨语言交互，首先需要按照JSVM-API的机制实现模块的注册和加载等相关动作。

- ArkTS/JS侧：实现C++方法的调用。代码比较简单，import一个对应的so库后，即可调用C++方法。
- Native侧：.cpp文件，实现模块的注册。需要提供注册lib库的名称，并在注册回调方法中定义接口的映射关系，即Native方法及对应的JS/ArkTS接口名称等。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API接口进行函数创建和调用](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-function-call.md)
- [使用JSVM-API接口进行虚拟机快照相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-create-snapshot.md)
- [使用JSVM-API接口进行JSON操作](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-about-JSON.md)
- [使用JSVM-API接口进行任务队列相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-execute_tasks.md)
- [使用JSVM-API接口进行WebAssembly模块相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-about-wasm.md)

### 效果预览

|                                   首页                                   |                            执行及结果即时反馈                            |
| :----------------------------------------------------------------------: | :----------------------------------------------------------------------: |
| <img src="./screenshots/UsageInstructionsOne_1.png" style="zoom:33%;" /> | <img src="./screenshots/UsageInstructionsOne_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击hello world，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
aboutjson/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libaboutjson
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口
 │   ├── ets
 │   │   ├── aboutjsonability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
createsnapshot/src/
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
functioncall/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libfunctioncall
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── functioncallability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
pumpmessageloop/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libpumpmessageloop
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── pumpmessageloopability
 │   │   ├── pages
 │   │       ├── Index.ets               // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
 webassembly/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libwebassembly
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5 	 // 将index.d.ts与cpp文件关
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接
 │   ├── ets
 │   │   ├── webassemblyability
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
echo code/DocsSample/ArkTS/JSVMAPI/UsageInstructionsOne > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
