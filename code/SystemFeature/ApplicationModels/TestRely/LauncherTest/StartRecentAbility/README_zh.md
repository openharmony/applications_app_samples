# 启动上一次的组件实例

### 介绍

本示例为一个仿桌面应用测试demo，测试的功能为：点击仿桌面应用上的应用图标，若应用未启动则启动应用，若应用已经被启动并创建多个实例则启动上一次拉起的实例。

### 效果预览

| EntryAbility                                          | EntryAbility（通过点击按钮打开的）                    | SecondAbility                                         |
| ----------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
| ![entryAbility1](./screenshots/zh/entryAbility1.jpg) | ![entryAbility2](./screenshots/zh/entryAbility2.jpg) | ![secondAbility](./screenshots/zh/secondAbility.jpg) |

使用说明

1.安装编译的hap包，将应用安装在仿桌面上。（仅在仿桌面中使用才会有以下情况）

2.点击应用主界面上的应用图标，可以启动应用。

3.长按应用图标弹出菜单，点击打开，可以正常启动应用。

4.打开EntryAbility页面，页面中会有时间戳显示，点击”StartEntryAbility“按钮，新建一个EntryAbility实例，会有一个新的时间戳显示，此时返回桌面并再次打开应用，会看到时间戳显示为第二个时间戳。

5.打开EntryAbility页面，会有时间戳显示，点击”startSingletonAbility“打开单实例的SecondAbility（页面中显示”SingletonAbility“），当打开SecondAbility后，返回桌面并再次打开应用，显示为EntryAbility且时间戳内容未改变。

### 工程目录

```
entry/src/main/ets/
|---entryability
|  |---EntryAbility.ts                         
|---logger
|  |---Logger.ts
|---pages
|  |---Index.ets                               // EntryAbilit页面
|  |---IndexSecond.ets                         // SecondAbility页面
|---secondability
|  |---SecondAbility.ts
```

### 具体实现

- 应用启动的功能接口封装在LauncherAbilityManager，源码参考：[LauncherAbilityManager.ts](./base/src/main/ets/default/manager/LauncherAbilityManager.ts)
  - 启动上次打开的的组件实例：拉起上次打开的任务至前台显示，若应用Ability未启动时，则拉起新创建的应用Ability显示到前台。
  
### 相关权限

不涉及

### 依赖

本测试demo需要安装在仿桌面应用上进行测试。launcher应用地址：[Launcher](../../../Launcher)

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/ApplicationModels/TestRely/LauncherTest/StartRecentAbility/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```