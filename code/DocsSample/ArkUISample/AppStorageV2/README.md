# MVVM模式（状态管理V2）示例

### 介绍
本教程通过一个简单的待办事项应用示例，逐步引入了状态管理V2装饰器，并通过代码重构实现了MVVM架构。最终，将数据、逻辑和视图分层，使得代码结构更加清晰、易于维护。具体介绍链接：

1. [AppStorageV2: 应用全局UI状态存储](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-new-appstoragev2.md)指南文档中示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。
   
### 效果预览
| AppStorageV2应用按钮                           | 使用AppStorageV2                               | 在两个页面之间存储数据                                  |
|-----------------------------------------------|----------------------------------------------|----------------------------------------------|
|![AppV2](./screenshots/AppStorageV2.png)| ![AppV2-1](./screenshots/AppStorageV2-1.png) | ![AppV2-2](./screenshots/AppStorageV2-1.png) |

使用说明
1. 点击AppStorageV2，查看存储全局UI状态状态变量。

### 工程目录
```
/src
├── /main
│   ├── /ets
│   │   ├── /entryability
│   │   ├── /pages                       //通过状态管理V2版本实现ViewModel
│   │   │   ├── AppStorageV2.ets         //使用AppStorageV2
│   │   │   ├── PageOne.ets              //在PageOne和PageTwo两个页面之间存储数据Sample
│   │   │   ├── PageTwo.ets 
│   │   │   ├── Sample.ets               //Sample数据页面               
│   │   │   └── Index.ets                //重构后的主页面
│   │   ├── /settingability
│   └── /resources
│       ├── ...
├─── ... 
```

### 具体实现

一、AppStorageV2: 应用全局UI状态存储
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
