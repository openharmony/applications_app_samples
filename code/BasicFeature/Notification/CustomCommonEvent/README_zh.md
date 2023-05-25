# 公共事件的订阅和发布

### 介绍

本示例主要展示了公共事件相关的功能，实现了一个检测用户部分行为的应用。具体而言实现了如下几点功能：

1.通过订阅系统公共事件，实现对用户操作行为（亮灭屏、断联网）的监测；

2.通过在用户主动停止监测行为时发布自定义有序公共事件，实现对用户主动触发监听行为的持久化记录；

3.通过在用户设置对某一事件的监听状态时发布粘性事件，记录下本次应用运行期间允许监听的事件列表，同时在应用退出时将临时允许的修改为不允许。

### 效果预览

| 主页                                 | 监控页面                           | 设置页面                               | 历史记录页面                          |
| ------------------------------------ | ---------------------------------- | -------------------------------------- | ------------------------------------- |
| <img src="screenshots/launch.jpg" /> | <img src="screenshots/main.jpg" /> | <img src="screenshots/settings.jpg" /> | <img src="screenshots/history.jpg" /> |

使用说明：

1.安装编译生成的hap包，桌面上显示应用图标如下，点击图标即可进入应用。

<img src="screenshots/icon.png" style="zoom:80%;" />

2.进入应用显示菜单页，可选择“进入”，“历史”，“设置”及“关于”几个选项。

3.点击“进入”后跳转至主页面，点击主页面“开始监控”按钮，将开始监听系统公共事件，并进行计时，此时按钮内容变更为“停止监听”；点击停止监听按钮，页面上将显示本次监听时长及监听期间收到的干扰信息汇总，并在页面右下角显示“查看详情”按钮，点击按钮将跳转至详情页，显示监听期间收到的干扰信息，应用当前仅监听了亮灭屏、断联网等用户可操作的系统公共事件，后续可根据需求快速扩展。

4.返回至应用菜单页面，点击“历史”可查看用户操作监听的历史记录，当前支持每次运行期间最多存储20条历史记录，超过20条后将删除历史数据。

5.返回至应用菜单页面，点击“设置”可进行具体系统事件的监听配置，应用提供了“一直”、“仅本次”及“从不”三个选项，其中“仅本次”选项是指本次应用运行期间将监听特定系统公共事件，应用退出后该选项将自动调整为“从不”。

6.返回至应用菜单页面，点击“关于”可查看应用版本信息及本示例的说明。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts                    
|---component
|   |---Header.ets                            // 头部组件
|---feature
|   |---HistoryFeature.ts                    
|   |---LaunchFeature.ts                    
|   |---MainFeature.ts                    
|   |---SettingFeature.ts                    
|---LauncherAbility 
|   |---LauncherAbility.ts
|---MainAbility
|   |---MainAbility.ts
|---model
|   |---Consts.ts                            // 数据定义
|   |---Logger.ts                            // 日志打印  
|   |---SurveillanceEventsManager.ts         // 公共事件模块
|   |---Utils.ts                        
|---pages
|   |---About.ets                            // 关于页面
|   |---Detail.ets                           // 详情页面
|   |---History.ets                          // 历史页面
|   |---Launch.ets                           // 发起页面
|   |---Main.ets                             // 进入页面
|   |---Setting.ets                          // 设置页面
```
   
### 具体实现

* 该示例分为四个模块：
  * 进入模块
    * 使用到应用文上下文，createSubscriber方法创建订阅者，getCurrentTime获取获取自Unix纪元以来经过的时间进行对用户操作行为的监测功能页面开发。
    * 源码链接：[Consts.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/Consts.ts)，[LaunchFeature.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/feature/LaunchFeature.ts)，[LauncherAbility.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/LauncherAbility/LauncherAbility.ts)，[SurveillanceEventsManager.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/SurveillanceEventsManager.ts)
    * 参考接口：[@ohos.app.ability.common](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-common.md)，[@ohos.commonEventManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-commonEventManager.md)，[@ohos.data.preferences](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-preferences.md)，[@ohos.commonEvent](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-commonEvent.md)，[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)，[@ohos.systemTime](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-system-time.md)
  
  * 历史模块
    * 使用到应用文上下文，getPreferences方法获取Preferences实例，组件Header进行历史页面开发。
    * 源码链接：[Header.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/component/Header.ets)，[Consts.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/Consts.ts),[HistoryFeature.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/feature/HistoryFeature.ts)
    * 参考接口：[@ohos.app.ability.common](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-common.md)，[@ohos.data.preferences](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-preferences.md)
  
  * 设置模块
    * 本模块分为三个事件，分别为记录联网事件，记录灭屏事件，记录亮屏事件，每一个事件都可进行一直，仅本次和从不的单项选择，使用到应用文上下文吗，CommonEvent.publish发布公共事件，getPreferences方法获取Preferences实例进行功能页面开发
    * 源码链接：[Header.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/component/Header.ets)，[Consts.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/Consts.ts)，[SettingFeature.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/feature/SettingFeature.ts)，[SurveillanceEventsManager.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/SurveillanceEventsManager.ts)
    * 参考接口：[@ohos.app.ability.common](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-common.md)，[@ohos.data.preferences](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-preferences.md)，[@ohos.commonEvent](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-commonEvent.md),[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)，[@ohos.commonEvent](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-commonEvent.md)
  
  * 关于模块
    * 该模块开发主要介绍了本示例的功能作用以及说明了什么情况下不能使用
    * 源码链接：[Header.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/component/Header.ets)，[Consts.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomCommonEvent/entry/src/main/ets/module/Consts.ts)
    
### 相关权限

[ohos.permission.COMMONEVENT_STICKY](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。


### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)及以上版本才可编译运行。

4.本示例运行需要具有系统应用签名，因此需要手动配置系统应用的权限签名(具体操作可查看[自动化签名方案](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ohos-auto-configuring-signature-information-0000001271659465))，需要注意的是，在修改签名json文件时，不需要调整“apl”字段，需要调整“app-feature”字段为“hos_system_app”。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Notification/CustomCommonEvent/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```