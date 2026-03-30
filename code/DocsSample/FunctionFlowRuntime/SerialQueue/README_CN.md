# FFRT 串行队列范式示例

## 项目简介

本示例基于**FFRT**提供的串行队列范式，通过异步日志系统样例的简易实现向开发者展示具体的串行队列特性接口使用方法。

## 效果预览
|             应用效果（图片）             |
|:--------------------------------:|
| ![image](res/FFRT_SerialQueue.gif) |

_界面展示C接口与C++接口串行队列任务。点击按钮即可触发任务串行执行。_

## 功能特性
FFRT串行队列基于协程调度模型实现，提供高效的消息队列功能，支持异步通信、流量削峰、无锁化状态和资源管理以及架构解耦等多种业务场景。FFRT串行队列支持以下功能：

* **队列创建销毁**，支持创建和销毁队列，创建时可指定队列名称和优先级。每个队列功能上相当于一个单独的线程，队列中的任务相对于用户线程异步执行。
* **任务延迟**，支持在任务提交时设置延迟时间（delay），单位为微秒（us）。延迟任务将在uptime（提交时刻+延迟时间）后调度执行。
* **串行调度**，同一队列中的任务按照uptime升序排列，严格串行执行。确保队列中上一个任务完成后，下一个任务才会开始执行。
* **任务取消**，支持根据任务句柄取消未出队的任务。若任务已开始执行或执行完成，则无法取消。
* **任务等待**，支持根据任务句柄等待任务完成。指定任务完成时，队列中所有uptime早于该任务的任务均已执行完成。
* **任务优先级**，支持在任务提交时设置单个任务的优先级。优先级仅在任务出队后相对于系统其他负载生效，不影响同一队列内任务的串行顺序。若未设置任务优先级，则默认继承队列的优先级。

## 示例：异步日志系统
举例实现一个异步日志系统，主线程将日志任务提交到队列，后台线程从队列中取出任务并写入文件。这种方式既能保证日志的顺序性，又能避免文件写入操作阻塞主线程。

借助FFRT并行化框架API，开发者只需专注于业务逻辑的实现，无需关注异步线程管理、线程安全及调度效率等问题。

## 使用说明

1. 打开应用，中部显示两个测试区块（C接口与C++接口实现）
2. 点击**“串行队列 C接口”**按钮
    - 调用 C 接口
    - 在hilog中显示任务结果
3. 点击**“串行队列 Cpp接口”**按钮
    - 调用 C++ 接口
    - 在hilog中显示任务结果

## 工程目录

```plain
├──entry/src
├──common
│  └──CommonConstants.ets         // 常量定义
├──cpp
│  ├──types/libentry
│  │  ├──index.d.ts               // NAPI 接口声明
│  │  └──oh-package.json5         // 接口注册配置
│  ├──CMakeLists.txt              // CMake 配置
│  ├──napi_init.cpp               // NAPI 接口实现
│  ├──serial_queue.cpp            // 串行任务C接口实现
│  ├──serial_queue_cpp.cpp        // 串行任务C++接口实现
├──ets
│  ├──entryability
│  │  └──EntryAbility.ets         // 程序入口
│  └──pages
│     └──Index.ets                // UI 主界面
└──resources                      // 资源文件
```

## 具体实现

### 1. 串行任务调度

使用 **FFRT串行队列** 模式串行执行任务。

### 2. NAPI 模块封装

`napi_init.cpp` 中实现 NAPI 接口注册，ArkTS 调用 `testNapi.SerialQueueExec(true|false)` 时提交串行队列任务, true为C接口任务，false为C++接口任务。

### 3. HarmonyOS 用户界面

使用 ArkTS + Declarative UI 组件布局，`CommonConstants` 管理样式常量，按钮触发任务执行，结果显示于Hilog中。

### 4. 工程化与可移植性

采用 CMake 构建 C++ 模块，OpenHarmony 三方库依赖管理 (`@ppd/ffrt` v1.1.0+)，清晰的目录结构便于扩展。

## 相关权限

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机、平板。
2. HarmonyOS系统：HarmonyOS 6.0.0及以上。
3. DevEco Studio版本：DevEco Studio 6.0.0及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.0.0 SDK及以上。

## 依赖

1. OpenHarmony三方库`@ppd/ffrt`版本：1.1.0及以上。

## 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/DeviceUsageStatistics/DeviceUsageStatistics/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```