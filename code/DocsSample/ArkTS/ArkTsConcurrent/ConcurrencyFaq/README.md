# 并发常见问题

## 介绍

本示例主要演示了使用TaskPool执行任务时以及使用Sendable特性可能会出现的问题及其解决方案。

## 效果预览

| 初始页面                            | 结果                                  |
|---------------------------------|-------------------------------------|
| ![add](./screenshots/index.png) | ![result](./screenshots/result.png) |

## 使用说明

1. 点击“创建任务 1 + 2”按钮，将调用TaskPool执行任务createTask的add函数,返回调用结果“任务执行结果:3”。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── ExecuteFailedTask.ets
    └── ExecuteSpportTask.ets
    └── Index.ets
    └── IsExecute.ets
    └── SaveResult.ets
    └── Sendable.ets
    └── SoluteItemInitialized.ets
    └── SoluteMismatchTypeOne.ets
    └── SoluteMismatchTypeThree.ets
    └── SoluteMismatchTypeTwo.ets
    └── TestInstancof.ets
    └── ui.ets
    └── utils.ets   
└── workers    
    └── Worker.ets    
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
  * createTask。
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
echo code/DocsSample/ArkTS/ArkTsConcurrent/ConcurrencyFaq > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
