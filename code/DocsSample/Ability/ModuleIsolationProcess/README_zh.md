# 模块独立进程

### 介绍

本示例展示了[模块独立进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/process-model-stage.md)的配置与使用方法：

1. 支持多HAP应用中，不同HAP的UIAbility运行在不同的独立进程中；
2. 通过在[module.json5配置文件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/module-configuration-file.md)中将isolationMode字段配置为isolationOnly或isolationFirst，使该HAP下的所有UIAbility运行在独立的进程中；
3. entry模块中的UIAbility可以通过startAbility拉起feature模块中的UIAbility，实现跨模块、跨进程的Ability启动。

### 效果展示

不涉及。

### 测试代码说明

1. ModuleIsolationProcess_startFeature_001：通过文本定位entry页面组件并点击，触发跨模块拉起FeatureAbility。
2. ModuleIsolationProcess_startFeature_002：通过id定位entry页面组件并点击，触发跨模块拉起FeatureAbility后返回。

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   │   └── EntryAbility.ets    // entry模块Ability，设置全局context
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets  // 备份能力
│   │   └── pages
│   │       └── Index.ets           // entry模块主页面，点击拉起feature模块
│   ├── module.json5               // entry模块配置（含isolationMode配置）
│   ├── syscap.json
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets   // 自动化测试代码
            └── List.test.ets      // 测试套执行列表

feature/src/
├── main
│   ├── ets
│   │   ├── featureability
│   │   │   └── FeatureAbility.ets  // feature模块Ability
│   │   └── pages
│   │       └── Index.ets           // feature模块主页面
│   ├── module.json5               // feature模块配置（含isolationMode配置）
│   ├── syscap.json
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets   // 自动化测试代码
            └── List.test.ets      // 测试套执行列表

```

### 使用说明

1. 配置模块独立进程：在entry模块的module.json5中，将isolationMode字段设置为isolationOnly（只在独立进程中运行）或isolationFirst（优先在独立进程中运行），使该模块的UIAbility运行在独立进程中。
2. 跨模块启动Ability：在entry模块页面中，通过构造包含bundleName、moduleName和abilityName的Want参数，调用startAbility接口拉起feature模块的FeatureAbility。
3. 模块独立进程运行：当isolationMode配置生效后，entry模块和feature模块的UIAbility将分别运行在各自独立的进程中。

### 具体实现

1. 配置模块独立进程：在module.json5的module标签下添加isolationMode字段。本示例中entry模块的isolationMode配置为isolationOnly，表示entry模块下的UIAbility只在独立进程中运行（当前默认以注释形式提供，取消注释即可生效）。

2. 实现跨模块Ability启动：在entry模块的Index.ets页面中，点击文本组件时构造Want对象，设置bundleName为"com.sample.moduleisolationprocess"、moduleName为"feature"、abilityName为"FeatureAbility"，通过globalThis.abilityContext.startAbility拉起feature模块的FeatureAbility。

3. feature模块实现：FeatureAbility继承自UIAbility，在onWindowStageCreate回调中加载feature模块的Index页面，展示独立进程中的UI内容。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 模块独立进程功能支持在2in1和Tablet设备上使用。
2. 本示例仅展示模块独立进程的配置方式和跨模块Ability启动流程，实际运行时需要取消module.json5中isolationMode字段的注释以启用独立进程。
3. 本示例为Stage模型，支持API22及以上的版本SDK，要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ModuleIsolationProcess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
