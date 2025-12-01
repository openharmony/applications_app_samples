# 使用公共事件进行进程间通信（C/C++）

### 介绍

本工程主要实现了对以下三个指南文档[订阅公共事件（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/common-event/native-common-event-subscription.md)、
[取消订阅公共事件（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/common-event/native-common-event-unsubscription.md)、
[发布公共事件（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/basic-services/common-event/native-common-event-publish.md)中示例代码片段的工程化，
主要目标是帮助开发者快速了解如何使用公共事件进行进程间通信。

### 效果预览

| 主界面                            | 订阅事件                           | 中止当前的有序公共事件                    |
|--------------------------------|--------------------------------|--------------------------------|
| ![image](screenshots/img1.png) | ![image](screenshots/img2.png) | ![image](screenshots/img3.png) |

| 取消当前有序公共事件的内容                  | 修改当前有序公共事件的内容                  | 取消订阅公共事件                       |
|--------------------------------|--------------------------------|--------------------------------|
| ![image](screenshots/img4.png) | ![image](screenshots/img5.png) | ![image](screenshots/img6.png) |

| 发布公共事件                         | 输出日志                           | 
|--------------------------------|--------------------------------|
| ![image](screenshots/img7.png) | ![image](screenshots/img8.png) | 

### 使用说明

1. 通过OH_CommonEvent_CreateSubscriber创建的订阅者可以对某个公共事件进行订阅，如果有订阅的事件发布那么订阅了这个事件的订阅者将会收到该事件及其传递的参数，也可以通过订阅者对象进一步处理有序公共事件。
2. 订阅者在完成业务需求之后，需要取消订阅公共事件。
3. 当需要发布某个公共事件时，可以通过OH_CommonEvent_Publish和OH_CommonEvent_PublishWithInfo方法发布事件。发布的公共事件可以携带数据，供订阅者解析并进行下一步处理。
4. CES（Common Event Service，公共事件服务）为应用程序提供订阅、发布、退订公共事件的能力。

### 公共事件分类
1. 公共事件从系统角度可分为：系统公共事件和自定义公共事件。
- 系统公共事件：CES内部定义的公共事件，当前仅支持系统应用和系统服务发布，例如HAP安装、更新、卸载等公共事件。
- 自定义公共事件：应用定义的公共事件，可用于实现跨进程的事件通信能力。
2. 公共事件按发送方式可分为：无序公共事件、有序公共事件和粘性公共事件。
- 无序公共事件：CES在转发公共事件时，不考虑订阅者是否接收到该事件，也不保证订阅者接收到该事件的顺序与其订阅顺序一致。
- 有序公共事件：CES在转发公共事件时，根据订阅者设置的优先级，优先将公共事件发送给优先级订阅者，等待其成功该公共事件之后，再将事件发送给优先级较低的订阅者。如果多个订阅者具有相同的优先级，则这些订阅者接收到事件的顺序不确定。
- 粘性公共事件：能够让订阅者收到在订阅前已经发送的公共事件就是粘性公共事件。普通的公共事件只能在订阅后发送才能收到，而粘性公共事件的特殊性就是可以先发送后订阅，同时也支持先订阅后发送。发送粘性事件必须是系统应用或系统服务，粘性事件发送后会一直存在系统中，且发送者需要申请`ohos.permission.COMMONEVENT_STICKY`权限。

### 工程目录

```
entry/src/
├── main
│   ├── cpp
│   │   ├── types
│   │   │   └── libentry
│   │   │       ├── Index.d.ts
│   │   │       └── oh-package.json5
│   │   ├── CMakeLists.txt
│   │   ├── common_event_publish.cpp
│   │   ├── common_event_publisher.h
│   │   ├── common_event_subscriber.cpp
│   │   ├── common_event_subscriber.h
│   │   ├── common_event_unsubscriber.cpp
│   │   ├── common_event_unsubscriber.h
│   │   └── napi_init.cpp
│   ├── ets
│   │   ├── entryability
│   │   │   └── EntryAbility.ets
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets
│   │   ├── pages
│   │   │   └── Index.ets
│   ├── module.json5
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets  // 自动化测试代码
            └── List.test.ets    // 测试套执行列表
```

### 具体实现

1. 基础无序事件交互：发布无优先级的无序公共事件，订阅端创建订阅者并绑定回调函数，接收事件后解析名称、代码、发布者包名等基础信息。
2. 带参事件发布订阅：发布端创建参数对象，向事件中添加 int、数组等多类型附加数据；订阅端从回调数据里解析并读取这些自定义参数。
3. 有序事件优先级处理：发布有序公共事件，订阅端按优先级接收，可执行中止事件传递、取消中止等操作，处理完毕后标记事件处理结束。
4. 订阅与资源释放：业务完成后调用接口取消公共事件订阅，按序销毁订阅者、订阅信息等对象，完成资源清理避免内存泄漏。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。
3. 本示例需要使用(Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Basic-Services-Kit/common_event/NativeCommonEvent > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```