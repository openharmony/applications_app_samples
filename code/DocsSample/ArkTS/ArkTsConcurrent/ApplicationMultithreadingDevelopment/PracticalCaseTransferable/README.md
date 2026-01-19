# 自定义Native Transferable对象的多线程操作场景

## 介绍

Native Transferable对象有两种模式：共享模式和转移模式。

## 相关概念

在ArkTS应用开发中，有很多场景需要将ArkTS对象与Native对象进行绑定。ArkTS对象将数据写入Native对象，Native对象再将数据写入目的地。
例如，将ArkTS对象中的数据写入C++数据库场景。

## 效果预览

| 初始页面                                | 共享模式                              | 传输模式                                        |
|-------------------------------------|-----------------------------------|---------------------------------------------|
| ![sendable](./screenShots/index.png) | ![share](./screenShots/share.png) | ![sendable](./screenShots/transferable.png) |

## 使用说明

1. 点击“共享模式”按钮，将触发共享模式，跨线程传递后，原来的ArkTS对象还可以继续访问Native对象，获取到主机线程的大小为6。
2. 点击“转移模式”按钮，将触发转移模式，跨线程传递后，原来的ArkTS对象与Native对象解绑，因此不能继续访问，获取到主机线程的大小为undefined。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 触发Native Transferable对象的多线程操作场景。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
    * 调用getAddress，store，erase，clear, test函数。
    * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)

## 依赖

无。

## 相关权限

无。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API23版本的SDK，版本号：6.1.0.25；

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ApplicationMultithreadingDevelopment/PracticalCaseTransferable/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
