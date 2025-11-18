# 应用启动框架AppStartup

### 介绍

Emitter是一种作用在进程内的事件处理机制，为应用程序提供订阅事件、发布事件、取消事件订阅的能力。

Emitter用于同一进程内相同线程或不同线程间的事件处理，事件异步执行。使用时需要先订阅一个事件，然后发布该事件，发布完成后Emitter会将已发布的事件分发给订阅者，订阅者就会执行该事件订阅时设置的回调方法。当不需要订阅该事件时应及时取消订阅释放Emitter资源。

### 运行机制

Emitter通过维护一个内部事件队列，来进行任务分发。应用需要先订阅某个事件并设置好该事件的回调方法，当应用程序发布事件后，就会往队列里面插入一个事件。任务队列会串行执行队列里面的任务，执行任务时会调用该任务订阅者的回调方法进行事件处理。

### 使用说明

1. 打开应用，点击emitterOn按钮会进行事件的发送
2. 在日志界面会打印出具体的事件信息
3. 点击emitterOff按钮会取消事件订阅
4. 再次点击emitterOn按钮发送事件但不会打印事件信息

### 工程目录

```
entry/src/main
├─ets                      // ArkTS 源码核心目录
│  ├─entryability          // 应用入口能力类目录（程序启动入口）
│  ├─entrybackupability    // 备份入口能力类目录
│  └─pages                 // 页面代码目录（存放 UI 页面逻辑）
│      └─index             // Emitter通信
└─resources                // 模块专属资源目录
    ├─base                 // 基础资源目录（默认主题）
    │  ├─element           // 基础元素配置（字符串、颜色、尺寸等）
    │  ├─media             // 基础媒体资源（图片、图标等）
    │  └─profile           // 基础配置文件（如页面路由配置）
    ├─dark                 // 深色主题资源目录
    │  └─element           // 深色主题元素配置（字符串、颜色等）
    └─rawfile              // 原始文件目录（存放无需编译的原生文件）
```

### 具体实现

1. 导入emitter和Callback 模块。
2. 订阅事件使用on（持续订阅）或者once（单次订阅）接口进行订阅，设置要订阅的事件以及接收到事件后的回调函数。
3. 发送事件使用emit接口进行发送，设置要发送的事件以及要传递的参数。
4. 取消事件订阅使用off接口进行取消，已通过emit接口发布但尚未被执行的事件将被取消。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 20版本SDK，版本号：6.0.0。

3.本示例需要使用DevEco Studio 6.0 及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Basic-Services-Kit/common_event/Emitter > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```