# Native QoS

### 介绍

本示例中主要介绍开发者如何使用Native QoS的接口来设置、查询以及重置线程的QoS等级，并在界面上显示不同QoS等级的线程完成相同计算任务的时间。功能主要包括点击不同的按钮分别创建高、低QoS等级的线程来完成同样的复杂计算任务；在计算完成后，弹窗显示当前创建线程完成任务执行所花费的时间；同时，可以在日志中查看调用QoS相关接口的结果。

### 效果预览

| 主页                                 | 弹窗显示高等级Qos任务计算时间                                    | 弹窗显示低等级Qos任务计算时间                                            |
| ------------------------------------ | --------------------------------------------- | --------------------------------------------------- |
| ![main](screenshots/device/main.jpeg) | ![draw star](screenshots/device/showhighQoScomputingTime.jpeg) | ![change color](screenshots/device/showlowQoScomputingTime.jpeg) |

日志打印

在日志中过滤"QoS"关键字，可以看到和QoS接口调用相关的日志打印，包括设置线程QoS等级的结果、查询线程QoS等级的结果以及重置线程QoS等级的结果。

![log](screenshots/device/QoSLog.png)

#### 使用说明

1. 安装编译生成的hap包，并打开应用；

2. 点击页面中间的“High level QoS test”按钮或者“Low level QoS test”按钮，页面将弹窗显示使用该QoS等级创建的线程完成计算任务所花费的时间；

3. 点击上述按钮后，在日志中过滤“QoS"关键字，可以查看调用QoS接口的时间以及响应的结果；

4. 点击弹窗中的“完成”按钮，则可以返回主界面。

### 工程目录

```
├──entry/src/main
│  ├──cpp                           // C++代码区
│  │  ├──CMakeLists.txt             // CMake配置文件
│  │  ├──main.cpp                   // QoS调用相关逻辑实现
│  │  └── types
│  │      └── libentry
│  │          └── index.d.ts        // native侧暴露给ArkTS侧接口的声明            
├──ets                              // ets代码区
│  │──entryability
│  │  └──EntryAbility.ts            // 程序入口类
│  └──pages                         // 页面文件
│  │  └──Index.ets                  // 主界面
├──resources         	            // 资源文件目录
```

### 具体实现
通过在IDE中创建Native C++ 工程，在C++代码中定义对外接口为useHighQos和useLowQos，在js侧调用该接口可在系统中创建对应QoS等级的线程完成任务。

每次调用useHighQos或useLowQos时，会先在系统中启动若干线程模拟系统负载（如果之前已经启动了相关的线程，则不再重复启动）；系统负载模拟完成后，会单独启动一个新的、用于完成计算任务的线程，并根据js侧实际调用的接口，调用设置QoS等级的接口为线程设置不同的QoS等级。为了更加清楚地展示不同QoS等级之间的效果区别，本样例中将负载线程以及设置了QoS等级用于完成任务计算的线程都绑到同一个CPU核上。样例运行中，可以通过日志查看线程设置QoS等级的结果，如果设置成功则会查询该线程的QoS等级，并通过日志打印出来，以此判断是否符合预期。

新启动的线程会执行斐波那契数列某项数值的计算；当计算完成后，会重置该线程的QoS等级，然后返回整个计算完成的时间（单位毫秒）到js侧，并通过弹窗显示该时间。


源码参考：[cpp目录](entry/src/main/cpp/main.cpp)下的文件。

涉及到的相关接口：

| 接口名 | 描述 |
| -------- | -------- |
| OH_QoS_SetThreadQoS(QoS_Level level) | 设置当前任务的QoS等级 |
| OH_QoS_ResetThreadQoS() | 取消当前任务设置的QoS等级 |
| OH_QoS_GetThreadQoS(QoS_Level *level) | 获取当前任务的QoS等级 |


详细的接口说明请参考[NativeQoS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/napi/qos-guidelines.md)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行；

2. 本示例已适配API version 12版本SDK，SDK版本号(API Version 12 Release)，镜像版本号(5.0 Release)；

3. 本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Native/NdkQoS/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

