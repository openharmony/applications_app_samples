# MVVM模式（状态管理V2）示例

### 介绍
本教程通过一个简单的待办事项应用示例，逐步引入了状态管理V2装饰器，并通过代码重构实现了MVVM架构。最终，将数据、逻辑和视图分层，使得代码结构更加清晰、易于维护。
[AppStorageV2: 应用全局UI状态存储](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-new-appstoragev2.md)指南文档中示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

### 效果预览
|TodoList页面                                   |
|----------------------------------------------|
|![todolist](./screenshots/MVVMV2-todolist.gif)|

使用说明
1. 点击任务切换任务完成状态；
2. 点击删除、输入添加新任务完成任务增删；
3. 点击全部完成、全部未完成更新所有任务完成状态；
4. 点击设置，更新是否显示已完成任务。
5. 点击AppStorageV2，查看存储全局UI状态状态变量。

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
│   │   │   ├── AppStorageV2.ets         //AppStorageV2.ets
│   │   │   ├── Page1.ets                //在Page1和Page2两个页面之间存储数据Sample
│   │   │   ├── Page2.ets 
│   │   │   ├── Sample.ets               //Sample数据页面               
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

## 具体实现

1. 使用AppStorageV2，AppStorageV2使用connect接口即可实现对AppStorageV2中数据的修改和同步，如果修改的数据被@Trace装饰，该数据的修改会同步更新UI。
2. 在两个页面之间存储数据，先定义Sample数据页面，然后在Page1和Page2之间实现数据存储。

### 相关权限
不涉及。

### 依赖
不涉及。

### 约束与限制
1. 本示例支持标准系统上运行，支持设备：RK3568等。
2. 本示例支持API22版本SDK，版本号：6.0.2.54。
3. 本示例已支持使DevEco Studio 6.0.0 Release 编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/StateMgmtV2MVVM > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
