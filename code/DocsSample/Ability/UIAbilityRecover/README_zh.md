# UIAbility备份恢复

### 介绍
当应用后台运行时，可能由于系统资源管控等原因导致应用关闭、进程退出，应用直接退出可能会导致用户数据丢失。如果应用在UIAbilityContext中启用了UIAbility备份恢复功能，并对临时数据进行保存，则可以在应用退出后的下一次启动时恢复先前的状态和数据（包括应用的页面栈以及onSaveState接口中保存的数据），从而保证用户体验的连贯性。

1.[UIAbility备份恢复](https://gitcode.com/tianlongdevcode/docs_zh/blob/master/zh-cn/application-dev/application-models/ability-recover-guideline.md)

### 效果预览
不涉及

### 使用说明

1）如果应用在UIAbilityContext中启用了UIAbility备份恢复功能，并对临时数据进行保存，则可以在应用退出后的下一次启动时恢复先前的状态和数据；

2）应用正常关闭时，不会触发UIAbility备份流程；

3）UIAbility备份恢复支持多实例，备份数据保存7天，以文件的形式存储在应用的沙箱路径中;

4）备份数据存储在Want中的parameter字段中，由于序列化大小限制，支持的最大数据量为200KB；

5）重启设备不支持还原备份；

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

* UIAbility备份恢复接口由UIAbilityContext模块提供，开发者可以通过在UIAbility中通过this.context直接调用。
    * 在应用模块初始化时，在UIAbility的onCreate()回调函数中启用UIAbility的备份恢复功能，源码参考[EntryAbility](/entry/src/main/ets/entryability/EntryAbility.ets)。
    * 开发者需要主动保存数据，调用onSaveState保存数据，以在UIAbility启动时恢复，源码参考[EntryAbility](/entry/src/main/ets/entryability/EntryAbility.ets)。

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
echo code/DocsSample/Ability/UIAbilityRecover > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```