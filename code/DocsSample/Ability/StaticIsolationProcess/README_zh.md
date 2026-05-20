# 静态指定进程

### 介绍

本示例展示了[静态指定进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/process-model-stage.md)的配置与使用方法：

1. 支持同一应用中的UIAbility通过静态配置运行到不同进程；
2. 通过在[module.json5配置文件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/module-configuration-file.md)的abilities标签中将process字段配置为不同的字符串，使UIAbility运行在指定的独立进程中；
3. 如果多个UIAbility的process字段配置了相同的字符串，则这些UIAbility会运行在同一个进程内。

### 效果展示

不涉及。

### 测试代码说明

不涉及。

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   │   └── EntryAbility.ets     // 主Ability，运行在主进程
│   │   ├── entryability1
│   │   │   └── EntryAbility1.ets    // 静态指定进程Ability（process: ":processTag"）
│   │   ├── entryability2
│   │   │   └── EntryAbility2.ets    // 静态指定进程Ability（process: ":processTag"），与EntryAbility1同进程
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets  // 备份能力
│   │   └── pages
│   │       └── Index.ets            // 主页面，点击拉起EntryAbility1和EntryAbility2
│   ├── module.json5                 // 模块配置（含process静态指定进程配置）
│   ├── syscap.json
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets     // 自动化测试代码
            └── List.test.ets        // 测试套执行列表

```

### 使用说明

1. 配置静态指定进程：在module.json5的abilities标签中，为目标UIAbility添加process字段，值以冒号开头（如":processTag"），表示该Ability运行在以"包名:processTag"命名的独立进程中。
2. 多个Ability共享进程：如果多个UIAbility配置了相同的process字符串（如本示例中EntryAbility1和EntryAbility2都配置了":processTag"），则它们会运行在同一个独立进程中。
3. 启动静态独立进程Ability：在主页面中通过startAbility接口拉起配置了process字段的UIAbility，系统自动将其分配到对应的静态进程中。

### 具体实现

1. 配置静态指定进程：在module.json5的abilities标签中，为EntryAbility1和EntryAbility2分别添加"process": ":processTag"字段。EntryAbility不配置process字段，运行在主进程中；EntryAbility1和EntryAbility2配置了相同的process值，运行在同一个独立进程（进程名为"com.sample.staticisolationprocess:processTag"）中。

2. 实现跨Ability启动：在EntryAbility的Index页面中，分别提供两个文本按钮"Start EntryAbility1"和"Start EntryAbility2"，点击时构造Want对象（bundleName: "com.sample.staticisolationprocess"、moduleName: "entry"、abilityName分别为"EntryAbility1"和"EntryAbility2"），通过globalThis.abilityContext.startAbility拉起对应的Ability。

3. EntryAbility1和EntryAbility2的实现：两者均继承自UIAbility，在onWindowStageCreate回调中加载pages/Index页面。由于配置了相同的process字段，拉起时会运行在同一个独立进程中。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 静态指定进程功能支持在2in1和Tablet设备上使用。
2. process字段值以冒号开头表示私有进程（进程名为"包名:自定义字符串"），不以冒号开头表示全局进程。
3. 本示例中EntryAbility1和EntryAbility2配置了相同的process值":processTag"，因此它们共享同一个独立进程。
4. 本示例为Stage模型，支持API22及以上的版本SDK，要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/StaticIsolationProcess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
