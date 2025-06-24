# ArkTS使用Node-API进行life-cycle相关开发

### 介绍

在Node-API中，napi_value是一个表示ArkTS值的抽象类型，它可以表示任何ArkTS值，包括基本类型（如数字、字符串、布尔值）和复杂对象类型（如数组、函数、对象等），napi_value的生命周期与其在ArkTS中的对应值的生命周期紧密相关。当ArkTS值被垃圾回收时，与之关联的napi_value也将不再有效。重要的是不要在ArkTS值不再存在时尝试使用napi_value，框架层的scope通常用于管理napi_value的生命周期。在Node-API中，可以使用napi_open_handle_scope和napi_close_handle_scope函数来创建和销毁scope。通过在scope内创建napi_value，可以确保在scope结束时自动释放napi_value，避免内存泄漏，napi_ref是一个Node-API类型，用于管理napi_value的生命周期。napi_ref允许您在napi_value的生命周期内保持对其的引用，即使它已经超出了其原始上下文的范围。这使得您可以在不同的上下文中共享napi_value，并确保在不再需要时正确释放其内存，本工程中展示的代码详细描述可查如下链接。

- [使用Node-API进行life-cycle相关开发](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-life-cycle.md)

### 效果预览

| 首页                                                                 | 执行结果图                                                           |
| -------------------------------------------------------------------- | -------------------------------------------------------------------- |
| <img src="./screenshots/NodeAPILifeCycle1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeAPILifeCycle2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述首页效果，分别点击ListItem组件可以执行对应文本内容的Node-API接口并将文本Result:改为执行成功结果，然后在控制台中打印出对应日志。
3. 运行测试用例NodeAPILifeCycle.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── Index.d.ts
 │   │       ├── oh-package.json5
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets                 // 使用Node-API进行life-cycle相关开发示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeAPILifeCycle.test.ets  // 自动化测试代码
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
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIUse/NodeAPILifeCycle > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
