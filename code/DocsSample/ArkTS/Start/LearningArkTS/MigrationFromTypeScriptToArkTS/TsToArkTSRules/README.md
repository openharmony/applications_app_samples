# 从TypeScript到ArkTS的适配规则

## 介绍

本示例在ArkTSLimitations文件夹列了ArkTS不支持或部分支持的TypeScript特性。完整的列表以及详细的代码示例和重构建议，参考华为开发者文档。

## 相关概念

ArkTS规范约束了TypeScript（简称TS）中影响开发正确性或增加运行时开销的特性。本文罗列了ArkTS中限制的TS特性，并提供重构代码的建议。
ArkTS保留了TS大部分语法特性，未在本文中约束的TS特性，ArkTS完全支持。例如，ArkTS支持自定义装饰器，语法与TS一致。
按本文约束进行代码重构后，代码仍为合法有效的TS代码。

## 效果预览

| 初始页面                              |
|-----------------------------------|
| ![Index](./screenshots/index.png) |

## 使用说明

1. 点击“3 + 10”按钮，调用ArkTS示例代码addTen。

## 工程目录

```
entry/src/main/ets/
└── ArkTSLimitations // 约束说明。
└── pages
    └── Index.ets // 触发Native Sendable对象的多线程操作场景。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
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
 echo code/DocsSample/ArkTS/Start/LearningArkTS/MigrationFromTypeScriptToArkTS/TsToArkTSRules > .git/info/sparse-checkout	 
 git remote add origin OpenHarmony/applications_app_samples	 
 git pull origin master	 
 ```
