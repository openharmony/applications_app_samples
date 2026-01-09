# 自定义Native Sendable对象的多线程操作场景

## 介绍

本示例将详细说明如何使用自定义Native Sendable对象实现并发实例间数据共享。

## 相关概念

ArkTS支持开发者自定义Native Sendable对象，Sendable对象提供了并发实例间高效的通信能力，即引用传递，
适用于开发者自定义大对象需要线程间通信的场景，例如子线程读取数据库数据并返回给宿主线程。

## 效果预览

| 初始页面                                | 数据共享成功页面                            | 
|-------------------------------------|-------------------------------------|
| ![sendable](./screenshots/index.png) | ![result](./screenshots/result.png) |

## 使用说明

1. 点击“使用Sendable对象进行线程间通信”按钮，ArkTS侧在UI主线程中定义Sendable实例对象并传递给TaskPool子线程，子线程处理完数据后返回UI主线程。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 触发Native Sendable对象的多线程操作场景。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
    * 源码参考：[napi_init.cpp](./entry/src/main/cpp/napi_init.cpp)

## 依赖

无。

## 相关权限

无。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API20版本SDK，版本号： 6.0.0.43；

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ApplicationMultithreadingDevelopment/PracticalCaseSendable/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
