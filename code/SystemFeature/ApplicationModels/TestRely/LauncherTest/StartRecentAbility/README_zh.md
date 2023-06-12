# 启动最近的组件实例

### **介绍**

本示例为一个仿桌面应用测试demo，测试的功能为：

点击仿桌面应用上的应用图标，若应用未启动则启动应用，若应用已经被启动并创建多个实例则启动最近拉起的实例。

### 效果预览

| EntryAbility                                          | EntryAbility（通过点击按钮打开的）                    | SecondAbility                                         |
| ----------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
| ![entryAbility1](.\screenshots\zh\entryAbility1.jpeg) | ![entryAbility2](.\screenshots\zh\entryAbility2.jpeg) | ![secondAbility](.\screenshots\zh\secondAbility.jpeg) |

### 使用说明

1.安装编译的hap包，将应用安装在仿桌面上。（仅在仿桌面中使用才会有以下情况）

2.点击应用主界面上的应用图标，可以启动应用。

3.长按应用图标弹出菜单，点击打开，可以正常启动应用。

4.打开EntryAbility页面，页面中会有时间戳显示，点击”StartEntryAbility“按钮，新建一个EntryAbility实例，会有一个新的时间戳显示，此时返回桌面并再次打开应用，会看到时间戳显示为第二个时间戳。

5.打开EntryAbility页面，会有时间戳显示，点击”startSingletonAbility“打开单实例的SecondAbility（页面中显示”SingletonAbility“），当打开SecondAbility后，返回桌面并再次打开应用，显示为EntryAbility且时间戳内容未改变。

###  工程目录

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

- 启动最近的组件实例
  - 当新建多个主Ability实例时，返回桌面并再次打开应用，会将最近的主Ability实例拉至前台，不会新建Ability实例。
  - 当在主Ability上打开一个单实例Ability，返回桌面并点击应用图标再次打开应用后，将最近的主Ability拉至前台，不会新建实例也不会打开单实例Ability。

### 依赖

本测试demo需要安装在仿桌面应用上进行测试。[Launcher](code/SystemFeature/ApplicationModels/Launcher · OpenHarmony/applications_app_samples - 码云 - 开源中国 (gitee.com))

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。