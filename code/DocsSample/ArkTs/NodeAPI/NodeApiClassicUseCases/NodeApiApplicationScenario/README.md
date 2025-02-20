# ArkTSNode-API使用场景

### 介绍

开发者通过pthread_create创建新线程后，可以通过napi_create_ark_runtime来创建一个新的ArkTS基础运行时环境，并通过该运行时环境加载ArkTS模块。当使用结束后，开发者需要通过napi_destroy_ark_runtime来销毁所创建的ArkTS基础运行时环境。

napi_create_threadsafe_function是Node-API接口之一，用于创建一个线程安全的JavaScript函数。主要用于在多个线程之间共享和调用，而不会出现竞争条件或死锁。例如异步计算、数据共享、多线程编程场景。

Node-API中的napi_call_threadsafe_function_with_priority接口的功能是从异步线程向ArkTS线程投递任务，底层队列会根据任务的优先级和入队方式来处理任务。

在自己创建的ArkTS运行环境中调用异步的ArkTS接口时，可以通过使用Node-API中的扩展接口napi_run_event_loop和napi_stop_event_loop来运行和停止ArkTS实例中的事件循环，该工程中展示的代码详细描述可查如下链接。

- [使用Node-API接口创建ArkTS运行时环境](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-ark-runtime.md)
- [使用Node-API接口进行线程安全开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-thread-safety.md)
- [使用Node-API接口从异步线程向ArkTS线程投递指定优先级和入队方式的的任务](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-call-threadsafe-function-with-priority.md)
- [使用扩展的Node-API接口在异步线程中运行和停止事件循环](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-event-loop.md)

### 效果预览

| 首页                                                         | 执行结果图                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/NodeApiApplicationScenario1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeApiApplicationScenario2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述首页效果，分别点击button组件可以执行对应文本内容的Node-API接口并将文本NodeAPI改为执行成功结果。
3. 运行测试用例NodeApiApplicationScenario.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── libentry
 │   │           ├── Index.d.ts
 │   │           ├── oh-package.json5
 │   │       ├── libentry1
 │   │           ├── Index.d.ts
 │   │           ├── oh-package.json5
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp
 │   │   ├── thread_safety.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets                           // Node-API使用场景
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── NodeApiApplicationScenario.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
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

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTs/NodeAPI/NodeApiClassicUseCases/NodeApiApplicationScenario > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````