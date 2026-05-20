# 动态指定进程

### 介绍

本示例展示了[动态指定进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/process-model-stage.md)的配置与使用方法：

1. 支持同一HAP中的UIAbility实例根据运行时状态动态分配到不同进程；
2. 通过在[module.json5配置文件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/module-configuration-file.md)中将UIAbility的isolationProcess字段配置为true，启用动态指定进程能力；
3. 系统在启动该UIAbility实例时，回调主控进程AbilityStage的[onNewProcessRequest](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-abilityStage.md#onnewprocessrequest11)接口，开发者在回调中返回自定义字符串作为进程标识，系统根据该标识分配或复用进程。

### 效果展示

不涉及。

### 测试代码说明

1. DynamicIsolationProcess_startAbility1_001：通过文本定位点击entry页面组件，触发动态指定进程拉起EntryAbility1。
2. DynamicIsolationProcess_startAbility1_002：通过id定位点击entry页面组件，触发动态指定进程拉起EntryAbility1后返回。

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── MyAbilityStage
│   │   │   └── MyAbilityStage.ets   // AbilityStage，实现onNewProcessRequest回调返回进程标识
│   │   ├── entryability
│   │   │   └── EntryAbility.ets     // 主Ability，加载Index页面
│   │   ├── entryability1
│   │   │   └── EntryAbility1.ets    // 动态独立进程Ability（isolationProcess: true），加载Page页面
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets  // 备份能力
│   │   └── pages
│   │       ├── Index.ets            // 主页面，点击拉起EntryAbility1
│   │       └── Page.ets             // EntryAbility1加载的页面
│   ├── module.json5                 // 模块配置（含isolationProcess和srcEntry配置）
│   ├── syscap.json
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets     // 自动化测试代码
            └── List.test.ets        // 测试套执行列表

```

### 使用说明

1. 配置AbilityStage：在module.json5中通过srcEntry字段指定AbilityStage的实现文件路径，用于接收onNewProcessRequest回调。
2. 配置动态指定进程：在module.json5的abilities标签中，将目标UIAbility（EntryAbility1）的isolationProcess字段设置为true。
3. 实现进程标识回调：在AbilityStage中重写onNewProcessRequest方法，返回开发者自定义的字符串作为进程标识，独立进程名称拼接规则为"包名:开发者自定义的字符串"。
4. 启动动态独立进程Ability：在主页面中通过startAbility接口拉起配置了isolationProcess的UIAbility，系统自动回调onNewProcessRequest分配进程。

### 具体实现

1. 配置AbilityStage入口：在module.json5的module标签下添加srcEntry字段，指向AbilityStage实现文件"./ets/MyAbilityStage/MyAbilityStage.ets"。

2. 配置动态指定进程：在module.json5的abilities标签中，为EntryAbility1添加"isolationProcess": true，表示该Ability需要动态分配到独立进程。

3. 实现onNewProcessRequest回调：MyAbilityStage继承自AbilityStage，重写onNewProcessRequest方法，返回自定义字符串'testKey'。系统根据返回值拼接进程名称为"com.sample.dynamicisolationprocess:testKey"，若该进程已存在则复用，否则创建新进程。

4. 跨Ability启动：在EntryAbility的Index页面中，点击文本组件时构造Want对象（bundleName: "com.sample.dynamicisolationprocess"、moduleName: "entry"、abilityName: "EntryAbility1"），通过globalThis.abilityContext.startAbility拉起EntryAbility1，系统触发onNewProcessRequest回调将其分配到独立进程。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 动态指定进程功能支持在2in1和Tablet设备上使用。
2. onNewProcessRequest回调中返回的字符串用于标识进程，相同字符串会复用同一进程，不同字符串会创建新进程。
3. 本示例中EntryAbility1加载的是Page页面，展示独立进程中的UI内容。
4. 本示例为Stage模型，支持API22及以上的版本SDK，要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/DynamicIsolationProcess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
