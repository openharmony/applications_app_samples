# FFRT 并发队列范式示例

## 项目简介

本示例基于**FFRT**提供的并发队列范式，通过银行服务系统样例的简易实现向开发者展示具体的并发队列特性使用方式。

## 效果预览
|             应用效果（图片）             |
|:--------------------------------:|
| ![image](res/FFRT_ConcurrentQueue.gif) |

_界面展示C接口与C++接口并发队列任务。点击按钮即可触发任务并发执行。_

## 功能特性
FFRT并发队列提供了设置任务优先级（Priority）和队列并发度的能力，使得队列中的任务能同时在多个线程上执行，获得更高的并行效果。

* **队列并发度**：通过队列最大并发度设置，可以控制同一时刻同时执行的任务数量。这有助于避免任务并发过多对系统资源造成冲击，从而保证系统的稳定性和性能。
* **任务优先级**：用户可以为每个任务设置优先级，不同的任务将严格按照优先级进行调度和执行。相同优先级的任务按照排队顺序执行，高优先级的任务将优先于低优先级的任务执行，确保关键任务能够及时处理。

## 示例：银行服务系统
举例实现一个银行服务系统，每个客户向系统提交一个服务请求，可以区分普通用户和VIP用户，VIP用户的服务请求可以优先得到执行。银行系统中有2个窗口，可以并行取出用户提交的服务请求办理。

可以利用FFRT的并行队列范式做如下建模：

* 排队逻辑：并行队列。
* 服务窗口：并行队列的并发度，同时也对应FFRT Worker数量。
* 用户等级：并行队列任务优先级。

## 使用说明

1. 打开应用，中部显示两个测试区块（C接口与C++接口实现）
2. 点击**“并发队列 C接口”**按钮
    - 调用 C 接口
    - 在hilog中显示任务结果
3. 点击**“并发队列 Cpp接口”**按钮
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
│  ├──concurrent_queue.cpp        // 并发队列任务C接口实现
│  ├──concurrent_queue_cpp.cpp    // 并发队列任务C++接口实现
├──ets
│  ├──entryability
│  │  └──EntryAbility.ets         // 程序入口
│  └──pages
│     └──Index.ets                // UI 主界面
└──resources                      // 资源文件
```

## 具体实现

### 1. 并发队列任务调度

使用 **FFRT并发队列** 模式执行指定并发度与优先级的并发任务。

### 2. NAPI 模块封装

`napi_init.cpp` 中实现 NAPI 接口注册，ArkTS 调用 `testNapi.ConcurrentQueueExec(true|false)` 时提交并发队列任务, true为C接口任务，false为C++接口任务。

### 3. HarmonyOS 用户界面

使用 ArkTS + Declarative UI 组件布局，`CommonConstants` 管理样式常量，按钮触发任务执行，结果显示于Hilog中。

### 4. 工程化与可移植性

采用 CMake 构建 C++ 模块，OpenHarmony 三方库依赖管理 (`@ppd/ffrt` v1.1.0+)，清晰的目录结构便于扩展。

## 相关权限

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机、平板。
2. OpenHarmony系统：OpenHarmony 6.0.0 及以上。
3. DevEco Studio版本：DevEco Studio 6.0.0 及以上。
4. OpenHarmony SDK版本：OpenHarmony 6.0.0 SDK及以上。

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