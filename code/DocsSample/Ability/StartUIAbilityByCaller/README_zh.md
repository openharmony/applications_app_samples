# 启动应用内的UIAbility组件

## 通过Call调用实现UIAbility交互

### 介绍
Call调用是UIAbility能力的扩展，它为UIAbility提供一种能够被外部调用并与外部进行通信的能力。Call调用支持前台与后台两种启动方式，使UIAbility既能被拉起到前台展示UI，也可以在后台被创建并运行。Call调用在调用方与被调用方间建立了IPC通信，因此应用开发者可通过Call调用实现不同UIAbility之间的数据共享。

### 效果预览

不涉及

### 使用说明

1）启动应用，进入应用首页，首页显示startAbilityByCall按钮；

2）点击startAbilityByCall按钮，通过startAbilityByCall()启动其他UIAbility；

3）页面弹出toast提示“CallerSuccess”，表示启动成功。

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
Call调用是UIAbility能力的扩展，它为UIAbility提供一种能够被外部调用并与外部进行通信的能力。Call调用支持前台与后台两种启动方式，使UIAbility既能被拉起到前台展示UI，也可以在后台被创建并运行。Call调用在调用方与被调用方间建立了IPC通信，因此应用开发者可通过Call调用实现不同UIAbility之间的数据共享。
1. 创建Callee被调用端
    * 配置UIAbility的启动模式，将CalleeAbility配置为单实例模式singleton。
    * 定义约定的序列化数据。 调用端及被调用端发送接收的数据格式需协商一致，如约定数据由number和string组成。源码参考[CalleeAbility](/entry/src/main/ets/calleeability/CalleeAbility.ets)。
    * 实现Callee.on监听及Callee.off解除监听。
2. 创建访问Callee的调用端
    * 构建被调用端Callee的want参数信息。
    * 通过startAbilityByCall()方法发起调用，获取Caller通信接口。源码参考[Index](/entry/src/main/ets/pages/Index.ets)。
### 相关权限
1. ohos.permission.DISTRIBUTED_DATASYNC

2. ohos.permission.ABILITY_BACKGROUND_COMMUNICATION

3. ohos.permission.START_ABILITIES_FROM_BACKGROUND
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