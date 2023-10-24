# N-Body模拟程序

### 介绍

在本示例中，使用ArkTS编程语言开发了业界编程语言基准测试项目[Benchmarks Game](https://salsa.debian.org/benchmarksgame-team/benchmarksgame/)中的[N体问题模拟程序](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody)，实现类木星体轨道计算。

本示例用到了[@ohos.taskpool](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-taskpool.md)和[@ohos.worker](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-worker.md) 接口。示例中的程序可以用于AOT(Ahead Of Time)等性能测试。

### 效果预览
|主页|计算中|重复点击|计算结果|
|-------|-------|-------|-------|
|![](screenshots/device/n-body_entry.jpeg)|![](screenshots/device/n-body_calculating.jpeg)|![](screenshots/device/n-body_reClick.jpeg)|![](screenshots/device/n-body_result.jpeg)|

使用说明

1.点击按钮Calculate By TaskPool，会从任务池创建一个任务，进行N-Body计算。

2.点击按钮Calculate By Worker，会创建一个Worker，进行N-Body计算。

### 工程目录
```
entry/src/main/ets
|---/entryability
|   |---EntryAbility.ts                  // 封装整个模块启用
|---/model
|   |---CalculateUtil.ets                // worker和taskpool都在这里调用            
|   |---NBody_ETS_6.ets                  // 天体轨道计算
|---/pages
|   |---Index.ets                        // 首页
|---/utils
|   |---Constants.ets                    // 封装只读常量
|   |---Logger.ets                       // 封装整个日志
|---/worker
|   |---CalculateWorker.ts               // worker线程        
                                            
```
### 相关概念

AOT(Ahead Of Time)，即预先编译，在应用程序运行前，将代码预先编译成高性能机器代码，避免在运行时的编译性能消耗和内存消耗，让程序在首次运行就能通过执行高性能机器码获得性能收益。

### 具体实现

- 使用TaskPool开启子线程运行，计算500万次时间推移天体运行轨道，源码参考[CalculateUtil.ets ](entry/src/main/ets/model/CalculateUtil.ets )
  - 通过调用computeNBodyByTaskPool()创建一个task任务，并向taskpool线程池派发子线程任务。
  - 等待子线程执行任务computeTask()，计算完成后再把结果返回主线程。

- 使用Worker开启子线程运行，计算5000万次时间推计算移天体运行轨道，源码参考[CalculateUtil.ets ](entry/src/main/ets/model/CalculateUtil.ets )
  - 通过调用computeNBodyByWorker()创建一个worker线程，把要计算的时间推移量发送给worker线程。
  - 等待worker线程调用computeTask()计算完成后再把结果返回主线程。
- computeTask()完成具体计算任务，源码参考[NBody_ETS_6.ets](entry/src/main/ets/model/NBody_ETS_6.ets) 
  - offsetMomentum() 建立孤立系统的动量守恒。
  - advance() 更新天体在按指定的时间变化后的位置信息。
  - energy() 判断系统计算前后机械能守恒。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例已适配API version 10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0Release) 。

2.本示例需要使用DevEco Studio 版本号(4.0Release)及以上才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Performance/ArkRuntime/NBody/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````