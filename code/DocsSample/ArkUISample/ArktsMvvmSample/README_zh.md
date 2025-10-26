# MVVM模式

### 介绍

本示例展示了[MVVM模式](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-mvvm.md)的使用方法：

1. 当开发者掌握了状态管理的基本概念后，通常会尝试开发自己的应用，在应用开发初期，如果未能精心规划项目结构，随着项目扩展和复杂化，状态变量的增多将导致组件间关系变得错综复杂。此时，开发新功能可能引起连锁反应，维护成本也会增加。为此，本示例旨在示例MVVM模式以及ArkUI的UI开发模式与MVVM的关系，给开发者予以参考，以便在产品迭代和升级时，能更轻松的开发和维护。;
2. 在应用开发中，UI更新需要实时同步数据状态变化，这直接影响应用程序的性能和用户体验。为了解决数据与UI同步的复杂性，ArkUI采用了 Model-View-ViewModel（MVVM）架构模式。MVVM 将应用分为Model、View和ViewModel三个核心部分，实现数据、视图与逻辑的分离。通过这种模式，UI可以自动更新状态变化，从而更高效地管理数据和视图的绑定与更新。

### 效果展示


| @State实现备忘录演示                                | @Prop和@Link实现备忘录演示                           |
|-------------------------------------------|-------------------------------------------|
| ![](screenshots/StateEffectPreview.gif)   | ![](screenshots/PropLinkPreview.gif)      |
| ForEach实现备忘录演示                               | @Builder实现备忘录演示                              |
| ![](screenshots/ForEachEffectPreview.gif) | ![](screenshots/BuilderEffectPreview.gif) |
| Mvvm实现备忘录使用演示                             | 
| ![](screenshots/MvvmEffectPreview.gif)    |

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   ├── entrybackupability
│   │   ├── model
│   │   │   ├── ThingModel.ets
│   │   │   └── TodoListModel.ets
│   │   ├── pages
│   │   │   ├── BuilderIndex.ets
│   │   │   ├── ForEachIndex.ets
│   │   │   ├── Index.ets
│   │   │   ├── PropLinkIndex.ets
│   │   │   └── StateIndex.ets
│   │   ├── viewModel
│   │   │   ├── ThingViewModel.ets
│   │   │   └── TodoListViewModel.ets
│   │   └── view
│   │   │   ├── AllChooseComponent.ets
│   │   │   ├── ThingComponent.ets
│   │   │   ├── TodoComponent.ets
│   │   │   └── TodoListComponent.ets
│   ├── module.json5
│   ├── syscap.json
│   └── resources
│   │   ├── base
│   │   ├── dark
│   │   └── rawfile
│   │       └── default_tasks.json
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets  // 自动化测试代码
            └── List.test.ets    // 测试套执行列表

```

### 使用说明

1. 必须搭配 @Param：仅能与 @Param 共同使用，不可单独使用或与 @State、@Local 等其它装饰器搭配，且仅支持 @ComponentV2 组件（API 12+）。
2. 初始化仅同步一次：变量初始化时接收外部传入值，后续外部数据源变化时，子组件变量不再同步更新。
3. 允许本地修改：解除 @Param 默认 “不可本地修改” 的限制，修改后可触发 UI 刷新，且不影响外部数据源。


### 具体实现

1. 通过装饰器修饰变量，在变量修改时，数据发生变化，实现备忘录。
2. 进一步使用@Builder装饰器将组件进一步抽离，进一步靠近mvvm模式的结构。
3. 分层职责：Model 层仅管数据结构 / 加载，ViewModel 层处理业务逻辑（如全选、状态切换），View 层只负责 UI 渲染，严格遵循 “不跨层访问” 原则。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

不涉及。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArktsMvvmSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```