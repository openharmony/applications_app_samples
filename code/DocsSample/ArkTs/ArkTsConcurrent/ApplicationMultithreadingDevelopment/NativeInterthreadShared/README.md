# ArkTS C++线程间数据共享场景

### 介绍

当应用在C++层进行多线程的并发计算时，因为ArkTS的API需要在ArkTS的环境执行，为了避免在非UI主线程每次回调等待UI主线程ArkTS环境中执行的API调用结果，需要在这些C++线程上创建ArkTS执行环境和直接调用API，并且可能需要在C++线程之间对Sendable对象进行共享和操作。

为了支持此类场景，需要实现在C++线程上创建调用ArkTS的能力，其次还需要对Sendable对象进行多线程共享和操作。

该工程中展示的代码详细描述可查如下链接：

- [C++线程间数据共享场景](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/native-interthread-shared.md)

### 效果预览

|                             首页                             |                           执行结果                           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="./screenshots/NativeInterthreadShared_1.png" style="zoom:33%;" /> | <img src="./screenshots/NativeInterthreadShared_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击hello world，开始执行。
2. 执行结果会即时反馈在屏幕中央。

### 工程目录

```
entry/src
 ├──main
 │   ├── cpp
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp                    // Naitve实现加载ArkTS模块的能力示例代码
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts               // 暴露接口
 │   │   │   │   ├── oh-package.json5
 │   ├── ets
 │   │   ├── entryability
 │   │   │   ├── EntryAbility.ets
 │   │   ├── entrybackupability
 │   │   │   ├── EntryBackupAbility.ets
 │   │   ├── pages
 │   │       ├── Index.ets                   // UI主线程发起调用示例代码
 │   │       ├── SendableObjTest.ets	     // ArkTS文件定义示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖s

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ApplicationMultithreadingDevelopment/NativeInterthreadShared > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````