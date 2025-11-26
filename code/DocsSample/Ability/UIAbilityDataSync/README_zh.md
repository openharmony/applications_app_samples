# UIAbility组件与UI的数据同步

### 介绍
本示例展示了UIAbility组件与UI的数据同步功能。 EventHub是系统提供的基于发布-订阅模式实现的事件通信机制。通过事件名，实现了发送方和订阅方之间的解耦，支持不同业务模块间的高效数据传递和状态同步。 主要用于UIAbility组件与UI的数据通信。

1.[UIAbility组件与UI的数据同步](https://gitcode.com/tianlongdevcode/docs_zh/blob/master/zh-cn/application-dev/application-models/uiability-data-sync-with-ui.md)

### 效果预览
不涉及

### 使用说明

1）启动应用，进入应用首页；

2）在UIAbility中调用eventHub.on()方法注册一个自定义事件“event1”，在UI中通过eventHub.emit()方法触发该事件

3）点击EventHubFuncA，触发事件event1；

4）点击EventHubFuncB，取消事件event1；

### 工程目录
```
UIAbilityLaunchType/
├── AppScope
│   ├── resources
│   ├── app.json5                       // 应用级配置文件
├── entry/src/main
│   ├── ets
│   │   ├── entryability
│   │   │   ├── EntryAbility.ets
│   │   ├── entrybackupability
│   │   │   ├── EntryBackupAbility.ets
│   │   ├── pages
│   │   │   ├── Index.ets               // 首页
│   │   │   ├── EventHubPage.ets
│   ├── module.json5                    // 模块级配置文件
│   └── resources
├── entry/src/ohosTest
│   ├── ets
│   │   └── test
│   │       ├── Ability.test.ets
│   │       └── List.test.ets
```
### 具体实现

* 本示例基于EventHub实现了UIAbility与UI之间的数据同步，EventHub为UIAbility组件提供了事件机制，使它们能够进行订阅、取消订阅和触发事件等数据通信能力。
    * 在UIAbility中调用eventHub.on()方法注册一个自定义事件“event1”，源码参考[EntryAbility](/entry/src/main/ets/entryability/EntryAbility.ets)。
    * 在UI中通过eventHub.emit()方法触发该事件，在触发事件的同时，根据需要传入参数信息，源码参考[EventHubPage](/entry/src/main/ets/pages/EventHubPage.ets)。
    * 在自定义事件“event1”使用完成后，可以根据需要调用eventHub.off()方法取消该事件的订阅，源码参考[EventHubPage](/entry/src/main/ets/pages/EventHubPage.ets)。

### 相关权限
不涉及
### 依赖
不涉及
### 约束与限制
1. 本示例仅支持标准系统上运行, 支持设备：RK3568。
2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.47。
3. 本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。
### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/UIAbilityDataSync > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```