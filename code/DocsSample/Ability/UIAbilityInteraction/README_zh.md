# 启动应用内的UIAbility组件

### 介绍
本示例主要介绍启动应用内的UIAbility组件的方式，UIAbility是系统调度的最小单元。在设备内的功能模块之间跳转时，会涉及到启动特定的UIAbility。

### 效果预览
首页

![启动页](./screenshots/main.png)

子页面

![子页面](./screenshots/stop.png)

### 使用说明

1）启动应用，进入应用首页；

2）点击”拉起FuncAbilityA“按钮，启动FuncAbilityA，点击”终止FuncAbilityA“返回首页；

3）点击”拉起FuncAbilityA With Result“按钮，启动FuncAbilityA；

4）点击”终止FuncAbilityA WithResult“返回首页，弹出toast提示：来自FuncAbility Index页面；

5）点击”冷启动指定页面“，启动ColdAbility，页面显示ColdPage；

6）点击”热启动指定页面“，启动HotAbility，页面显示HotPage；

7）返回首页，再次点击”热启动指定页面“，启动HotAbility，页面显示PageOne;
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
│   │   ├── innerability
│   │   │   ├── FuncAbilityA.ets
│   │   │   ├── FuncAbilityAPage.ets
│   │   ├── pages
│   │   │   ├── Index.ets               // HotAbility首页
│   │   │   ├── ColdPage.ets            // ColdAbility首页
│   │   │   ├── MainPage.ets            // 应用首页
│   │   │   ├── PageOne.ets             // HotAbility子页面
│   │   ├── specifiedability
│   │   │   ├── ColdAbility.ets
│   │   │   ├── HotAbility.ets
│   ├── module.json5                    // 模块级配置文件
│   └── resources
├── entry/src/ohosTest
│   ├── ets
│   │   └── test
│   │       ├── Ability.test.ets
│   │       └── List.test.ets
```
### 具体实现
UIAbility是系统调度的基本单元。在设备内的功能模块之间跳转时，会涉及到启动特定的UIAbility，包括应用内的UIAbility、或者其它应用的UIAbility（例如启动第三方支付UIAbility）。
1. 启动应用内的UIAbility
    * 在EntryAbility中，通过调用startAbility()方法启动UIAbility，want为UIAbility实例启动的入口参数。源码参考[MainPage](/entry/src/main/ets/pages/MainPage.ets)。
    * 在FuncAbilityA的onCreate()或者onNewWant()生命周期回调文件中接收EntryAbility传递过来的参数。。源码参考[FuncAbilityA](/entry/src/main/ets/innerability/FuncAbilityA.ets)。
    * 在FuncAbilityA业务完成之后，如需要停止当前UIAbility实例，在FuncAbility中通过调用terminateSelf()方法实现。源码参考[FuncAbilityAPage](/entry/src/main/ets/innerability/FuncAbilityAPage.ets)。
2. UIAbility指定启动页面
    * 调用方UIAbility启动另外一个UIAbility时，在传入的want参数中配置指定的页面路径信息。源码参考[冷启动指定页面](entry/src/main/ets/pages/MainPage.ets)。
    * 在目标UIAbility的onCreate()生命周期回调中，接收调用方传过来的参数。然后在onWindowStageCreate()生命周期回调中，解析调用方传递过来的want参数。源码参考[ColdStartAbility](/entry/src/main/ets/specifiedability/ColdStartAbility.ets)。

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
echo code/DocsSample/Ability/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```