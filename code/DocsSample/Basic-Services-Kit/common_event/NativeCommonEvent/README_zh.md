# 公共事件简介
<!--Kit: Basic Services Kit-->
<!--Subsystem: Notification-->
<!--Owner: @peixu-->
<!--Designer: @dongqingran; @wulong158-->
<!--Tester: @wanghong1997-->
<!--Adviser: @fang-jinxu-->

CES（Common Event Service，公共事件服务）为应用程序提供订阅、发布、退订公共事件的能力。

## 公共事件分类
公共事件从系统角度可分为：系统公共事件和自定义公共事件。


- 系统公共事件：CES内部定义的公共事件，当前仅支持系统应用和系统服务发布，例如HAP安装、更新、卸载等公共事件。
- 自定义公共事件：应用定义的公共事件，可用于实现跨进程的事件通信能力。


公共事件按发送方式可分为：无序公共事件、有序公共事件和粘性公共事件。


- 无序公共事件：CES在转发公共事件时，不考虑订阅者是否接收到该事件，也不保证订阅者接收到该事件的顺序与其订阅顺序一致。
- 有序公共事件：CES在转发公共事件时，根据订阅者设置的优先级，优先将公共事件发送给优先级订阅者，等待其成功该公共事件之后，再将事件发送给优先级较低的订阅者。如果多个订阅者具有相同的优先级，则这些订阅者接收到事件的顺序不确定。
- 粘性公共事件：能够让订阅者收到在订阅前已经发送的公共事件就是粘性公共事件。普通的公共事件只能在订阅后发送才能收到，而粘性公共事件的特殊性就是可以先发送后订阅，同时也支持先订阅后发送。发送粘性事件必须是系统应用或系统服务，粘性事件发送后会一直存在系统中，且发送者需要申请`ohos.permission.COMMONEVENT_STICKY`权限。

## 运作机制

<!--Del-->
公共事件服务提供了动态订阅和静态订阅两种订阅方式。动态订阅与静态订阅最大的区别在于，动态订阅是应用运行时的行为，而静态订阅是后台服务，无需处于运行状态。

- 动态订阅：指订阅方在运行时调用公共事件订阅的API实现对公共事件的订阅。

- 静态订阅：订阅方通过配置文件声明和实现继承自StaticSubscriberExtensionAbility的类实现对公共事件的订阅。
<!--DelEnd-->

**图1** 公共事件示意图  
![common-event](figures/common-event.png)

## 安全注意事项

- **公共事件发布方**：如果不加限制，任何应用都可以订阅公共事件并读取相关信息，应避免在公共事件中携带敏感信息。采用以下方式，可以限制公共事件接收方的范围。
    - 通过CommonEventPublishData中的subscriberPermissions参数指定订阅者所需权限。
    - 通过CommonEventPublishData中的bundleName参数指定订阅者的包名。
- **公共事件订阅方**：订阅自定义公共事件后，任意应用都可以向订阅者发送潜在的恶意公共事件。采用以下方式，可以限制公共事件发布方的范围。
    - 通过CommonEventSubscribeInfo中的publisherPermission参数指定发布者所需权限。
    - 通过CommonEventSubscribeInfo中的publisherBundleName参数指定发布者的包名。

### 工程目录
```
├─entry/src/main
│  │  module.json5
│  │
│  ├─cpp
│  │  │  CMakeLists.txt
│  │  │  common_event_publisher.cpp   // Common Event Publish 发布事件
│  │  │  common_event_publisher.h
│  │  │  common_event_subscriber.cpp  // Common Event Subscriber 公共事件订阅
│  │  │  common_event_subscriber.h
│  │  │  common_event_unsubscriber.cpp  // Common Event Unsubscriber 公共事件取消
│  │  │  common_event_unsubscriber.h
│  │  │  napi_init.cpp                  // napi接口
│  │  │
│  │  └─types
│  │      └─libentry
│  │              Index.d.ts
│  │              oh-package.json5
│  │
│  ├─ets
│  │  ├─entryability
│  │  │      EntryAbility.ets
│  │  │
│  │  ├─entrybackupability
│  │  │      EntryBackupAbility.ets
│  │  │
│  │  └─pages
│  │          Index.ets
│  │
│  └─resources
│      ├─base
│      │  ├─element
│      │  │      color.json
│      │  │      float.json
│      │  │      string.json
│      │  │
│      │  ├─media
│      │  │      background.png
│      │  │      foreground.png
│      │  │      layered_image.json
│      │  │      startIcon.png
│      │  │
│      │  └─profile
│      │          backup_config.json
│      │          main_pages.json
│      │
│      ├─dark
│      │  └─element
│      │          color.json
│      │
│      └─rawfile
├─mock
│      Libentry.mock.ets
│      mock-config.json5
│
├─ohosTest
│  │  module.json5
│  │
│  └─ets
│      └─test
│              Ability.test.ets
│              List.test.ets
│
└─test
List.test.ets
LocalUnit.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

    1.本示例仅支持标准系统上运行。
    2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。
    2.本示例需要使用(Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo BasicFeature/Notification/CommonEventPublish > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```