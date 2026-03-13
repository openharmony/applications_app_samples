# 本地媒体会话概述

## 介绍

本示例主要展示了本地媒体会话中，媒体会话提供方通过媒体会话管理器和媒体会话控制方进行信息交互。

## 效果预览

| 主页面                               |
|-----------------------------------|
| ![Index](./screenshots/Index.png) |

## 使用说明

1. 点击'hello world'文本触发AVSession创建。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 触发AVSession创建。
entry/src/ohosTest/
└── ets
    └── test
        └── AVSessionTest.test.ets // UI自动化用例。
```

## 具体实现

* 当点击文本时，会触发一个异步函数，通过AVSessionManager创建一个音频会话，并在控制台输出会话ID。

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
echo code/DocsSample/Media/AVSession/LocalAVSession/LocalAVSessionOverview > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
 ```
