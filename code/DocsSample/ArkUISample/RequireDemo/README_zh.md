# ArkTs Require装饰器简介

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [@Require装饰器：校验构造传参](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-require.md)

### 效果预览

| 首页选项目录            | SceneRequire示例                          | ParentPage示例                            | PageOne示例                           | Example 
|-------------------|------------------------------------|------------------------------------|--------------------------------------|--------------------------------------|
| ![](screenshots/Screenshot_2025-10-24T173700.png) | ![](screenshots/Screenshot_2025-10-24T173714.png) | ![](screenshots/Screenshot_2025-10-24T173738.png) | ![](screenshots/Screenshot_2025-10-24T173811.png) | ![](screenshots/Screenshot_2025-10-24T173835.png) |

### 使用说明

1. 应用在启动后显示首页4个按钮。
2. 分别点击4个按钮进入相应代码片段的页面。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Example.ets                   
 │   │       ├── Index.ets                   // 首页
 │   │       ├── PageOne.ets                   
 │   │       ├── ParentPage.ets                   
 │   │       ├── SceneRequire.ets                   
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1. 当Child组件内使用@Require装饰器和@Prop、@State、@Provide、@BuilderParam、@Param和普通变量(无状态装饰器修饰的变量)结合使用时，父组件Index在构造Child时必须传参，否则编译不通过。
2. 使用@ComponentV2修饰的自定义组件ChildPage通过父组件ParentPage进行初始化，因为有@Require装饰@Param，所以父组件必须进行构造赋值。
3. 当Child组件内将@Require装饰器与@Prop、@State、@Provide、@BuilderParam、普通变量（无状态装饰器修饰的变量）结合使用时，若父组件Index在构造Child时未传递相应参数，则会导致编译失败。当ChildV2组件内将@Require装饰器与@Param结合使用时，若父组件Index在构造ChildV2时未传递相应参数，则同样会导致编译失败。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API21版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/RequireDemo > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
