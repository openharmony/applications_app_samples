# ApplicationContext简介

### 介绍

[Context](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-inner-application-context.md)是应用中对象的上下文，其提供了应用的一些基础信息，例如resourceManager（资源管理）、applicationInfo（当前应用信息）、area（文件分区）等。

### 效果预览

不涉及。
### 使用说明

1. 应用在启动后显示文本"hello world"。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── abilitystagecontextability
 │   │       ├── MyAbilityStage.ets   // 模块级别的上下文
 │   │   ├── entryability
 │   │   ├── entryareaability
 │   │       ├── EntryAbility.ets   // 模块级别的上下文
 │   │   ├── entrybackupability
 │   │   ├── entryexampleability
 │   │       ├── EntryAbility.ets   // 应用的全局上下文
 │   │   ├── entrylifecycleability
 │   │       ├── EntryLifecycleAbility.ets            // 监听UIAbility生命周期变化
 │   │   ├── entrysceneability
 │   │       ├── EntryAbility.ets            // 获取基本信息
 │   │   ├── extensionability
 │   │       ├── MyFormExtensionAbility.ets            // ExtensionAbility组件的上下文
 │   │   ├── lifecycleability
 │   │       ├── LifecycleAbility.ets            // 监听应用前后台变化
 │   │   ├── pages
 │   │       ├── ApplicationContextCache.ets                   // 获取应用缓存目录
 │   │       ├── ApplicationContextFile.ets                   // 获取应用文件目录
 │   │       ├── AreaContext.ets                   // 加密分区使用
 │   │       ├── CreateModuleContext.ets                   // 获取本应用中其他Module的模块级别的上下文
 │   │       ├── EventHub.ets                   // 在页面中获取UIAbility实例的上下文信息
 │   │       ├── Index.ets                   // 首页
 │   │       ├── UIAbilityComponentsBasicUsage.ets                   // 可以在具体使用UIAbilityContext前进行变量定义
 │   │       ├── UIAbilityComponentsUsage.ets                   // 当业务完成后，开发者如果想要终止当前UIAbility实例
 │   │   ├── uiAbilitycontextability
 │   │       ├── UIAbilityContextAbility.ets            // 通过this.context获取UIAbility实例的上下文信息
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

1.获取ApplicationContext（应用的全局上下文）

ApplicationContext在基类Context的基础上提供了监听应用内应用组件的生命周期的变化、监听系统内存变化、监听应用内系统环境变化、设置应用语言、设置应用颜色模式、清除应用自身数据的同时撤销应用向用户申请的权限等能力，在UIAbility、ExtensionAbility、AbilityStage中均可以获取。

entry/src/main/ets/entryexampleability/EntryExampleAbility.ets

```ts
import { UIAbility, AbilityConstant, Want } from '@kit.AbilityKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let applicationContext = this.context.getApplicationContext();
    //...
  }
}
```

2.获取ApplicationContext（应用的全局上下文）

AbilityStageContext和基类Context相比，额外提供HapModuleInfo、Configuration等信息。

entry/src/main/ets/abilitystagecontextability/MyAbilityStage.ets

```ts
import { AbilityStage } from '@kit.AbilityKit';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    let abilityStageContext = this.context;
    //...
  }
}
```
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ApplicationContextDemo > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
