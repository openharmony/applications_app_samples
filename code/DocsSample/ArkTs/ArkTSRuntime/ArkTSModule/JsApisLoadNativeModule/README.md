# ArkTS同步方式动态加载native模块

### 介绍

本工程主要展示了使用loadNativeModule接口能力进行同步方式加载native模块。该工程中展示的代码详细描述可查如下链接部分。

- [同步方式动态加载native模块](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/js-apis-load-native-module.md)

### 效果预览

| 首页                                                         | 点击HAP加载系统库模块按钮后                                  | 点击HAP加载Native库按钮后                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/JsApisLoadNativeModule1.png" style="zoom:50%;" /> | <img src="./screenshots/JsApisLoadNativeModule2.png" style="zoom:50%;" /> | <img src="./screenshots/JsApisLoadNativeModule3.png" style="zoom:50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面中Text组件文本呈现LoadNativeModule效果并有两个按钮，分别点击之后第两个个按钮Text文本变化如上图并在工作台打印日志。
3. 运行测试用例JsApisLoadNativeModule.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   ├── libentry
 │   │   │   │   ├── index.d.ts
 │   │   │   ├── CMakeList.txt
 │   │   │   ├── napi_init.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 同步方式动态加载native模块
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── JsApisLoadNativeModule.test.ets  // 自动化测试代码
 │   │       └── List.test
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
echo code/DocsSample/ArkTs/ArkTSRuntime/ArkTSModule/JsApisLoadNativeModule > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````