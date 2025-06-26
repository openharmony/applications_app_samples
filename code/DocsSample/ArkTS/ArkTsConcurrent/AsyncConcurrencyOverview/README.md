# ArkTS 异步并发 (Promise和async/await)

### 介绍

Promise和async/await提供异步并发能力，是标准的JS异步语法。异步代码会被挂起并在之后继续执行，同一时间只有一段代码执行，适用于单次I/O任务的场景开发，例如一次网络请求、一次文件读写等操作。无需另外启动线程执行。

异步语法是一种编程语言的特性，允许程序在执行某些操作时不必等待其完成，而是可以继续执行其他操作。该工程中展示的代码详细描述可查如下链接：

- [异步并发 (Promise和async/await)](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/async-concurrency-overview.md)

### 效果预览

|                                     首页                                     |                              执行及结果即时反馈                              |
| :--------------------------------------------------------------------------: | :--------------------------------------------------------------------------: |
| <img src="./screenshots/AsyncConcurrencyOverview_1.png" style="zoom:33%;" /> | <img src="./screenshots/AsyncConcurrencyOverview_2.png" style="zoom:33%;" /> |

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 异步并发示例代码
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

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTs/ArkTsConcurrent/AsyncConcurrencyOverview > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
