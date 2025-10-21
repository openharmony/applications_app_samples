# UIAbility组件基本用法

### 介绍
本示例展示了UIAbility组件的基本用法包括：指定UIAbility的启动页面以及获取UIAbility的上下文UIAbilityContext。

### 使用说明

1）进入首页，点击拉起UIAbilityB；

2）点击FuncAbilityB，终止UIAbilityB；

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
echo code/BasicFeature/Ability/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```