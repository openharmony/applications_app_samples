# MVVM模式（状态管理V2）示例

### 介绍
本教程通过一个简单的待办事项应用示例，逐步引入了状态管理V2装饰器，并通过代码重构实现了MVVM架构。最终，将数据、逻辑和视图分层，使得代码结构更加清晰、易于维护。

### 效果预览
|TodoList页面                                   |
|----------------------------------------------|
|![todolist](./screenshots/MVVMV2-todolist.gif)|

使用说明
1. 点击任务切换任务完成状态；
2. 点击删除、输入添加新任务完成任务增删；
3. 点击全部完成、全部未完成更新所有任务完成状态；
4. 点击设置，更新是否显示已完成任务。

### 工程目录
```
/src
├── /main
│   ├── /ets
│   │   ├── /entryability
│   │   ├── /model                       //重构后的Model层
│   │   │   ├── TaskListModel.ets
│   │   │   └── TaskModel.ets
│   │   ├── /pages                       //通过状态管理V2版本实现ViewModel
│   │   │   ├── 1-Basic.ets
│   │   │   ├── 2-Local.ets
│   │   │   ├── 3-Param.ets
│   │   │   ├── 4-Event.ets
│   │   │   ├── 5-Repeat.ets
│   │   │   ├── 6-ObservedV2Trace.ets
│   │   │   ├── 7-MonitorComputed.ets
│   │   │   ├── 8-AppStorageV2.ets
│   │   │   ├── 9-PersistenceV2.ets
│   │   │   ├── 10-Builder.ets
│   │   │   ├── SettingPage.ets          //设置页
│   │   │   └── TodoListPage.ets         //重构后的主页面
│   │   ├── /settingability
│   │   ├── /view                        //重构后的View层
│   │   │   ├── BottomView.ets
│   │   │   ├── ListView.ets
│   │   │   └── TitleView.ets
│   │   ├── /viewmodel                   //重构后的ViewModel层
│   │   │   ├── TaskListViewModel.ets
│   │   │   └── TaskViewModel.ets
│   └── /resources
│       ├── ...
├─── ... 
```

### 相关权限
不涉及。

### 依赖
不涉及。

### 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：RK3568;
2. 本示例为Stage模型，已适配API12版本SDK，SDK版本号5.0.0.71;
3. 本示例需要使用DevEco Studio 版本号(5.0.3.900)版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/StateMgmtV2MVVM > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
