# 异步等待

## 介绍

ArkTS语言支持异步操作，现已增加异步任务的等待和唤醒功能。当异步任务收到唤醒通知或等待超时后，将继续执行。

## 相关概念

ArkTS引入了异步任务的等待和被唤醒能力，以解决多线程任务时序控制问题。
异步任务的等待和被唤醒ConditionVariable对象支持跨线程引用传递。

## 效果预览

| 初始页面                                 |
|--------------------------------------|
| ![sendable](./screenshots/index.png) |

## 使用说明

1. 点击“点击触发异步等待事件”按钮，将触发异步等待事件。
2. 创建conditionVariable对象。
3. 将实例conditionVariable传递给wait线程。
4. 将实例conditionVariable传递给notifyAll线程，唤醒wait线程，日志输出"TaskPool Thread Wait: success"。
5. 将实例conditionVariable传递给waitFor线程。
6. 将实例conditionVariable传递给notifyOne线程，唤醒waitFor线程，日志输出"TaskPool Thread WaitFor: success"。
7. 创建有name的conditionVariable对象。
8. 将实例conditionVariableRequest传递给wait线程。
9. 将实例conditionVariableRequest传递给notifyAll线程，唤醒wait线程，日志输出"TaskPool Thread Wait: success"。
10. 将实例conditionVariableRequest传递给waitFor线程。
11. 将实例conditionVariableRequest传递给notifyOne线程，唤醒waitFor线程，日志输出"TaskPool Thread WaitFor: success"。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 触发异步等待事件页面。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
  * 调用notifyAll，notifyOne，wait，waitFor函数。
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
echo code/DocsSample/ArkTS/ArkTsConcurrent/ConcurrentThreadCommunication/InterThreadCommunicationObjects/SendableObject/AsynchronousWaiting/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
