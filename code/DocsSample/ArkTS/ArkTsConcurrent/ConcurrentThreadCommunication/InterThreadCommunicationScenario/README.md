# ArkTS 线程间通信场景

### 介绍

#### 使用TaskPool执行独立的耗时任务

对于一个独立运行的耗时任务，只需要在任务执行完毕后将结果返回给宿主线程，没有上下文依赖。

#### 使用TaskPool执行多个耗时任务

如果有多个任务同时执行，由于任务的复杂度不同，执行时间会不一样，返回数据的时间也是不可控的。如果宿主线程需要所有任务执行完毕的数据，那么可以通过下面这种方式实现。

除此以外，如果需要处理的数据量较大（比如一个列表中有10000条数据），把这些数据都放在一个Task中处理也是比较耗时的。那么就可以将原始数据拆分成多个列表，并将每个子列表分配给一个独立的Task进行执行，并且等待全部执行完毕后拼成完整的数据，这样可以节省处理时间，提升用户体验。

#### TaskPool任务与宿主线程通信

如果一个Task不仅需要返回的执行结果，还需要定时向宿主线状态或数据的变化，或者需要分段返回大量数据（例如从数据库中读取大量数据）。

#### Worker和宿主线程的即时消息通信

在ArkTS中，Worker相对于Taskpool存在一定的差异性，有数量限制但是可以长时间存在。一个[Worker](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/worker-introduction.md)中可能会执行多个不同的任务，每个任务执行的时长或者返回的结果可能都不相同，宿主线程需要根据情况调用Worker中的不同方法，Worker则需要及时地将结果返回给宿主线程。

#### Worker同步调用宿主线程的接口

如果一个接口在主线程中已经实现了，Worker需要调用该接口。

### 多级Worker间高性能消息通信
多级Worker（即通过父Worker创建子Worker的机制形成层级线程关系）间通信是一种常见的需求，由于Worker线程生命周期由用户自行管理，因此需要注意多级Worker生命周期的正确管理，建议开发者确保销毁父Worker前先销毁所有子Worker。

该工程中展示的代码详细描述可查如下链接：

- [使用TaskPool执行独立的耗时任务](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/independent-time-consuming-task.md)
- [使用TaskPool执行多个耗时任务](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/multi-time-consuming-tasks.md)
- [TaskPool任务与宿主线程通信](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/taskpool-communicates-with-mainthread.md)
- [Worker和宿主线程的即时消息通信](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/worker-communicates-with-mainthread.md)
- [Worker同步调用宿主线程的接口](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/worker-invoke-mainthread-interface.md)
- [多级Worker间高性能消息通信](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/worker-postMessage-sendable.md)

### 效果预览

|                                         首页                                          |                                  执行及结果即时反馈                                   |
| :-----------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------: |
| <img src="./screenshots/InterThreadCommunicationScenario_1.png" style="zoom: 30%;" width="360;" /> | <img src="./screenshots/InterThreadCommunicationScenario_2.png" style="zoom: 30%;" width="360;" /> |

### 使用说明

1. 在主界面，点击任意按钮进行跳转，点击Hello World执行程序。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── managers
 │   │       ├── CopyEntry.ets      			        // 一个Sendable类CopyEntry
 │   │       ├── IconItemSource.ets      			    // 公共资源文件
 │   │       ├── IndependentTask.ets                    // 公共资源文件
 │   │       ├── IndependentTimeConsumingTask.ets       // 使用TaskPool执行独立的耗时任务
 │   │       ├── MultiTask.ets                          // 公共资源文件
 │   │       ├── MultiTimeConsumingTasks.ets		    // 使用TaskPool执行多个耗时任务
 │   │       ├── TaskSendDataUsage.ets                  // TaskPool任务与宿主线程通信
 │   │       ├── WorkerCallGlobalUsage.ets              // Worker同步调用宿主线程的接口
 │   │       ├── WorkerCommunicatesWithMainthread.ets   // Worker和宿主线程的即时消息通信
 │   │       ├── WorkerPostMessageSendable.ets          // 多级Worker间高性能消息通信
 │   │   ├── pages
 │   │       ├── Index.ets                              // 首页
 │   │   ├── util
 │   │       ├── CommonButton.ets 		                // 首页跳转UI
 │   │       ├── resource.ets 		                    // 资源引用转换
 │   │   ├── workers
 │   │       ├── Worker.ets 		                    // 公共资源文件
 │   │       ├── ChildWorker.ets 		                // 子Worker
 │   │       ├── ParentWorker.ets 		                // 父Worker
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets                       // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.820, built on June 28, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ConcurrentThreadCommunication/InterThreadCommunicationScenario > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
