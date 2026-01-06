# SyncMonitor API：SyncMonitor同步触发刷新

## 介绍

V1状态变量\@Watch是同步触发状态变量回调的，V2状态变量的\@Monitor是异步触发状态变量回调的，当V1的\@Watch向\@Monitor迁移时，需要修改回调中的逻辑，迁移成本高，为此，提供\@SyncMonitor，当V1的\@Watch向\@SyncMonitor迁移时，无需修改回调中的逻辑。

以下是\@SyncMonitor在不同场景中的代码示例及结果说明。

## 工程目录
```
entry/src/main/ets/
├── common
│   └── resource.ets
├── entryability
│   └── EntryAbility.ets
├── entrybackupability
│   └── EntryBackupAbility.ets
└── pages
    ├── CompareSyncMonitorWithMonitor.ets        // 测试Monitor和SyncMonitor监听状态变量差异
    ├── Index.ets                            // 页面入口
    ├── MonitorMultipleVariables.ets         // 测试SyncMonitor监听多个状态变量场景
    ├── MonitorObjectVariable.ets              // 测试SyncMonitor监听对象属性的场景
    ├── MonitorVariablesInObservedV2Class.ets          // 测试@SyncMonitor中监听@ObservedV2中属性的场景
    ├── MonitorTwoLayerVariablesInObservedV2Class.ets         // 测试SyncMonitor监听嵌套对象属性的场景
    ├── MonitorVariableInBaseDerivedClass.ets                     // 测试基类和继承类中监听变量属性的场景
    ├── MonitorEntireObjectChangeButPropertyNoChange.ets                     // 测试监听对象变化，属性未变化的场景
    ├── SyncMonitorBehavesDifferentlyFromMonitor.ets                     // 测试SyncMonitor跟Monitor行为不一样的场景
    ├── WildcardMonitorObjectPropertyChange.ets                     // 测试使用通配符监听对象属性的场景
    ├── WildcardMonitorArrayItemChange.ets                     // 测试使用通配符监听数组项的场景
    ├── WildcardMonitorNestedObjectPropertyChange.ets                     // 测试使用通配符监听嵌套对象属性的场景
    ├── WildcardMonitorArrayFirstItemChange.ets                     // 测试使用通配符监听数组第1项对象属性变化的场景
    ├── MonitorTheSameVariableTwoTimes.ets                     // 测试使用SyncMonitor监听变量两次的场景
    ├── EffectiveAndIneffectiveTimesOfVariableMonitoring.ets                     // 测试使用SyncMonitor监听失效时机场景
    ├── MonitorComputedVariable.ets                     // 测试使用SyncMonitor监听Computed变量场景
    ├── MonitorVariableFromAccessibleToInaccessible.ets                     // 测试使用SyncMonitor监听变量从可访问到不可访问场景
entry/src/ohosTest/
├── ets
│   └── test
│       ├── Ability.test.ets
│       ├── SyncMonitor.test.ets      // 测试用例代码
│       └── List.test.ets
└── module.json5
```

## 具体实现

1、从Index页面选择一个使用场景，点击进入。
2、点击页面内test按钮， 进入界面， 点击按钮， @SyncMonitor监听的变量会触发对应的回调。

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API23版本SDK，版本号：6.0.2.23，镜像版本号：OpenHarmony_6.1.0.25。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858， built on September 24, 2025)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/SyncMonitor > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````