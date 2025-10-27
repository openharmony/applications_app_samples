# ArkUI使用动效组件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [@Watch装饰器](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-watch.md)。


### 效果预览

| 首页                                 |
|------------------------------------|
| ![](screenshots/device/image1.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---Index.ets                       // 应用主页面
|   |---CountModifier.ets                       // @Watch和自定义组件更新
|   |---BasketModifier.ets                       // @Watch与@Link组合使用
|   |---ParentComponent.ets                       // @Watch的触发时机
|   |---UsePropertyName.ets                       // 使用changedPropertyName进行不同的逻辑处理
entry/src/ohosTest/
|---ets
|   |---test
|   |   |---Ability.test.ets                      // @Watch装饰器示例代码测试代码
```
### 具体实现
1. @Watch装饰器：@Watch用于监听状态变量的变化，当状态变量变化时，@Watch的回调方法将被调用。@Watch在ArkUI框架内部判断数值有无更新使用的是严格相等（===），遵循严格相等规范。当严格相等判断的结果是false（即不相等）的情况下，就会触发@Watch的回调。源码参考[watch/pages/Index.ets](https://gitcode.com/openharmony/applications_app_samples/blob/master/code/DocsSample/ArkUISample/Watch/entry/src/main/ets/pages/Index.ets)
    * @Watch和自定义组件更新。展示组件更新和@Watch的处理步骤。count在CountModifier中由@State装饰，在TotalView中由@Prop装饰。
    * @Watch与@Link组合使用。展示如何在子组件中观察@Link变量。
    * @Watch的触发时机。展示@Watch回调触发时间是根据状态变量真正变化的时间，本示例在子组件中同时使用@Link和@ObjectLink装饰器，分别观察不同的状态对象。通过在父组件中更改状态变量并观察@Watch回调的先后顺序，来表明@Watch触发的时机与赋值、同步的关系。
    * 使用changedPropertyName进行不同的逻辑处理。说明了如何在@Watch函数中使用changedPropertyName进行不同的逻辑处理。
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Canary1 (Build Version: 6.0.0.270， built on May 9, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/Watch > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples
git pull origin master
````