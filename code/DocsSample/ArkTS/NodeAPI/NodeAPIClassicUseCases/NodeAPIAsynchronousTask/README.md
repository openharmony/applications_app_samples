# ArkTS使用Node-API接口进行异步任务开发

### 介绍

本工程展示了使用Node-API接口进行异步任务开发中的Promise方式和callback方式，详细描述可查如下链接。

- [使用Node-API接口进行异步任务开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-asynchronous-task.md)

### 效果预览

| 首页                                                                        | 执行结果图                                                                 |
| --------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| <img src="./screenshots/NodeAPIAsynchronousTask1.png" style="zoom: 67%;" /> | <img src="./screenshots/NodeAPIAsynchronousTask2.png" style="zoom:67%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现如上图效果，和两个按钮，依次点击按钮后可以调用Promise方式和callback方式的方法，并将结果呈现到text文本中，并在控制台中打印出对应日志。
3. 运行测试用例NodeAPIAsynchronousTask.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── libentry
 │   │       └── libentry1
 │   │   ├── callback.cpp                // callback方式实现
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp               // Promise方式实现
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 异步任务
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeAPIAsynchronousTask.test.ets  // 自动化测试代码
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

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIClassicUseCases/NodeAPIAsynchronousTask > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
