# ArkTS使用JSVM-API实现JS与C/C++语言交互开发流程

### 介绍

使用JSVM-API实现跨语言交互，首先需要按照JSVM-API的机制实现模块的注册和加载等相关动作。

- ArkTS/JS侧：实现C++方法的调用。代码比较简单，import一个对应的so库后，即可调用C++方法。
- Native侧：.cpp文件，实现模块的注册。需要提供注册lib库的名称，并在注册回调方法中定义接口的映射关系，即Native方法及对应的JS/ArkTS接口名称等。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM-API实现JS与C/C++语言交互开发流程](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-process.md)

### 效果预览

|                              首页                               |                       执行及结果即时反馈                        |
| :-------------------------------------------------------------: | :-------------------------------------------------------------: |
| <img src="./screenshots/JsvmProcess_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmProcess_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击hello world，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 使用JSVM-API实现JS与C/C++语言交互开发流程示例代码
 │   │   │   │   ├── oh-package.json5 	 // 使用JSVM-API实现JS与C/C++语言交互开发流程示例代码
 │   │   ├── CMakeLists.txt              // 使用JSVM-API实现JS与C/C++语言交互开发流程示例代码
 │   │   ├── hello.cpp                   // 使用JSVM-API实现JS与C/C++语言交互开发流程示例代码
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 使用JSVM-API实现JS与C/C++语言交互开发流程示例代码
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
echo code/DocsSample/ArkTs/JSVMAPI/JsvmProcess > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
