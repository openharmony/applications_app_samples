# ArkTS模块加载副作用及优化

### 介绍

当使用ArkTS模块化时，模块的加载和执行可能会引发副作用。副作用是指在模块导入过程中，除了导出功能或对象之外，还产生了额外的行为或状态变化。这些行为可能影响程序别的部分，并导致非预期的顶层代码执行、全局状态变化、原型链修改、导入内容未定义等问题。

本项目展现了模块加载副作用及优化，包括模块执行顶层代码、修改全局对象、修改应用级ArkUI组件的状态变量信息、修改内置全局变量或原型链、循环依赖和延迟加载改变模块执行顺序等场景，对比产生副作用的场景和优化后场景。代码详细描述可查如下链接。

- [模块加载副作用及优化](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/arkts-module-side-effects.md)

### 效果预览

| 首页                                                                       |
| -------------------------------------------------------------------------- |
| <img src="./screenshots/ModuleLoadingSideEffects.png" style="zoom:50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面中呈现五个按钮分别对应介绍中五个场景，分别点击按钮可以跳转到各个场景的页面，页面中有副作用以及优化后结果进行对比，并在工作台打印日志。
3. 运行测试用例ModuleLoadingSideEffects.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │   |   ├── LazyImportChangeExecutionOrder    // 延迟加载改变模块执行顺序
 │   │   |   ├── ModifyGlobalObject                // 修改全局对象
 │   │   |   ├── ModifyingGlobalVariables          // 修改内置全局变量或原型链
 │   │   |   ├── ModifyTheApplicationLevelArkUI    // 修改应用级ArkUI组件的状态变量信息
 │   │   |   ├── TopCodeModification               // 模块执行顶层代码
 │   │   |   └── Index.ets                         // 首页
 │   │   ├── util
 │   │       ├── CommonButton.ets
 │   │       └── resource.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── ModuleLoadingSideEffects.test.ets // 自动化测试代码
 │   │       └── List.test
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.34，镜像版本号：OpenHarmony_6.0.0.34。

3.本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTs/ArkTSRuntime/ArkTSModule/ModuleLoadingSideEffects > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
