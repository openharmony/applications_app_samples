# 获取应用异常退出原因

### 介绍

当应用异常退出后再次启动时，开发者往往需要获取上次异常退出的具体原因和当时的应用状态信息，比如应用内存占用的rss、pss值、上次应用退出的时间等等。通过UIAbility和UIExtensionAbility的OnCreate生命周期函数中的launchParam参数，开发者可以获取到相关信息，并将其应用于应用体验的分析改进，从而调整业务逻辑、提高应用的存活率。

### 效果预览

不涉及。

### 使用说明

具体说明主要有异常获取和异常处理两个：
1. 异常获取
   获取UIAbility上次退出的原因：在UIAbility类的OnCreate成员函数的launchParam参数中读取Ability上次退出的信息。
2. 异常处理
   根据上次退出的信息做相应的业务处理,包含以下处理：
   1. 对于不同的退出原因，开发者可以增加不同的处理逻辑。
   2. 对于不同的退出原因，开发者可以增加不同的处理逻辑。
   3. 根据异常退出时刻的时间戳，明确异常发生的时刻，便于问题定位。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── exitability                       // 获取应用异常退出原因
 │   │       ├── exitAbility1.ets            
 │   │       ├── exitAbility2.ets
 │   │   ├── pages
 │   │       ├── Index.ets                   // 首页
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets            // 自动化测试代码
```
### 具体实现

* 获取应用异常退出原因
    * 获取应用异常通过AbilityConstant.LaunchParam参数lastExitReason字段获取，具体源码参考：[ExitAbility1](./entry/src/main/ets/exitability/ExitAbility1.ets)
* 获取应用异常退出原因类型：
    * 通过lastExitReason获取不同的退出原因类型（取APP_FREEZE和SIGNAL等）退出原因。源码参考：[ExitAbility](./entry/src/main/ets/exitability/ExitAbility.ets)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：RK3568。

2. 本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3. 本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858, built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/UnexpExit > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
