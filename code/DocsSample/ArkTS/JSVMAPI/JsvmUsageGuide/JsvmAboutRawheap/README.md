# ArkTS使用JSVM接口进行堆内存管理开发

## 介绍

使用JSVM-API接口进行堆内存管理开发，包括获取原始堆快照和监控堆内存阈值等功能。

该工程中展示的代码详细描述可查如下链接：

- [使用JSVM获取堆快照及监控堆内存阈值](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-jsvm-threshold-callback.md)

## 效果预览

|                                首页                                |                         执行及结果即时反馈                         |
| :----------------------------------------------------------------: | :----------------------------------------------------------------: |
| <img src="./screenshots/JsvmAboutRawheap_1.png" style="zoom:33%;" /> | <img src="./screenshots/JsvmAboutRawheap_2.png" style="zoom:33%;" /> |

## 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

## 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── Index.d.ts          // 提供JS侧的接口方法
 │   │   │   │   ├── oh-package.json5    // 将index.d.ts与cpp文件关联
 │   │   ├── CMakeLists.txt              // 配置CMake打包参数
 │   │   ├── hello.cpp                   // 实现Native侧的runTest接口，包含堆内存管理测试代码
 │   ├── ets
 │   │   ├── entryability
 │   │   │       ├── EntryAbility.ets    // 应用入口Ability
 │   │   ├── pages
 │   │   │       ├── Index.ets           // ArkTS侧调用C/C++方法实现
 │   ├── module.json5
 │   └── resources
 │       └── base
 │           ├── element                 // 元素配置
 │           ├── media                   // 媒体资源
 │           └── profile                 // 页面配置
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │   │       ├── Ability.test.ets    // 自动化测试代码
 │   │   │       └── List.test.ets       // 测试用例列表
```

## 核心功能

本工程实现了以下JSVM堆内存管理接口的测试：

1. **OH_JSVM_TakeRawHeapSnapshot**：获取VM的原始堆快照，保存为二进制文件
2. **OH_JSVM_SetHeapThresholdCallback**：为VM注册堆内存阈值回调函数
3. **OH_JSVM_ClearHeapThresholdCallback**：移除已注册的堆内存阈值回调函数

## 测试场景

- 获取原始堆快照（基础场景）
- 注册堆阈值回调（合法注册、重复注册、无效参数）
- 触发堆阈值回调（内存分配达到阈值）
- 移除堆阈值回调（合法移除、重复移除、阈值不匹配）

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：Phone。

2. 本示例为Stage模型，支持API26版本SDK，版本号：5.0.3.135，镜像版本号：OpenHarmony 5.0.3.135。

3. 本示例需要使用DevEco Studio 6.0.2 Release (Build Version: 6.0.2.650, built on March 27, 2026)及以上版本才可编译运行。

## 预期输出

```
Set heap threshold callback success
Set repeated callback failed (expected)
Set callback with 0 threshold failed (expected)
== Heap threshold reached ==
Threshold: 1048576 bytes
User data: 305419896
Clear heap threshold callback success
Clear repeated callback failed (expected)
Clear mismatch threshold callback failed (expected)
Heap management test: SUCCESS
```

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/JSVMAPI/JsvmUsageGuide/JsvmAboutRawheap > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```