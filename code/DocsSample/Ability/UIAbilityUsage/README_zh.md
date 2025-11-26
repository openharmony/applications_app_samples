# UIAbility组件基本用法

### 介绍
本示例展示了UIAbility组件的基本用法包括：指定UIAbility的启动页面以及获取UIAbility的上下文UIAbilityContext。

1.[UIAbility组件基本用法](https://gitcode.com/tianlongdevcode/docs_zh/blob/master/zh-cn/application-dev/application-models/uiability-usage.md)

### 效果预览
不涉及

### 使用说明

1）启动应用，进入应用首页；

2）在应用首页创建“拉起UIAbilityB”按钮；

3）获取UIAbility的上下文信息;

4）点击拉起UIAbilityB按钮，跳转到UIAbilityB页面；

5）点击FuncAbilityB，终止UIAbilityB；

### 工程目录
```
UIAbilityLaunchType/
├── AppScope
│   ├── resources
│   ├── app.json5                       // 应用级配置文件
├── entry/src/main
│   ├── ets
│   │   ├── context
│   │   │   ├── BasicUsage.ets
│   │   ├── entryability
│   │   │   ├── EntryAbility.ets
│   │   │   ├── UIAbilityB.ets
│   │   ├── entrybackupability
│   │   │   ├── EntryBackupAbility.ets
│   │   ├── pages
│   │   │   ├── Index.ets               // 首页
│   ├── module.json5                    // 模块级配置文件
│   └── resources
├── entry/src/ohosTest
│   ├── ets
│   │   └── test
│   │       ├── Ability.test.ets
│   │       └── List.test.ets
```
### 具体实现

* UIAbility组件的基本用法包括：指定UIAbility的启动页面以及获取UIAbility的上下文UIAbilityContext。
    * UIAbility类拥有自身的上下文信息，该信息为UIAbilityContext类的实例，UIAbilityContext类拥有abilityInfo、currentHapModuleInfo等属性。
    * 在UIAbility的onCreate()回调函数中可以通过this.context获取UIAbility实例的上下文信息，源码参考[EntryAbility](/entry/src/main/ets/entryability/EntryAbility.ets)。
    * 也可以在页面中获取到UIAbility的上下文信息context，然后调用context的startAbility()方法启动一个UIAbility，源码参考[Index](/entry/src/main/ets/pages/Index.ets)。
    * 当业务完成后，开发者如果想要终止当前UIAbility实例，可以通过调用terminateSelf()方法实现，源码参考[Index](/entry/src/main/ets/pages/Index.ets)。

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
echo code/DocsSample/Ability/UIAbilityUsage > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```