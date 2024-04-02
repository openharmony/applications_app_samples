# 服务卡片开发指导（Stage模型）

### 介绍

本示例展示了在一个Stage模型中，开发基于ArkTS UI及JS UI的卡片指导。

本示例参考[应用模型](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/application-models)。 

### 效果预览

| 开发卡片事件                               | 卡片数据交互                                   |
| ------------------------------------------ | ---------------------------------------------- |
| <img src="screenshots/widget event.gif" /> | <img src="screenshots/data interaction1.gif"/> |

#### 使用说明

**开发基于ArkTS UI的卡片**

1.开发卡片页面

1）长按应用图标并点击<服务卡片>；

2）选择卡片属性动画示例并点击添加到桌面；

3）点击“改变旋转角度”按钮，按钮产生旋转动画效果；

4）回到主页，长按应用图标并点击<服务卡片>，选择卡片使用自定义绘制能力示例并点击添加到桌面；

5）示例代码实现了通过CanvasRenderingContext2D对象在画布的中心绘制一个笑脸。

2.开发卡片事件

1）回到主页，长按应用图标并点击<服务卡片>，选择卡片使用router事件跳转到指定UIAbility示例并点击添加到桌面；

2）点击“功能A”按钮，在UIAbility中接收router事件并获取参数，根据传递的params不同，选择拉起功能A页面；

3）点击“功能B”按钮，在UIAbility中接收router事件并获取参数，根据传递的params不同，选择拉起功能B页面；

4）回到主页，长按应用图标并点击<服务卡片>，选择通过message事件刷新卡片示例并点击添加到桌面；

5）在卡片页面点击“Update”按钮，观察卡片页面，其中title信息更新为'Title Update.'文字信息更新为'Description update success.'；

6）回到主页，长按应用图标并点击<服务卡片>，选择通过router事件刷新卡片内容示例并点击添加到桌面；

7）点击“router事件跳转”按钮；点击Home键返回桌面，查看卡片内容从“init”更新为“RouterFromCard”:UIAbility；当按home键的方式回到卡片界面点击按钮时，内容则更新为“RouterFromCard”:onNewWant UIAbility.；

8）回到主页，长按应用图标并点击<服务卡片>，选择通过call事件刷新卡片内容示例并点击添加到桌面；

9）点击“callee拉至后台”按钮，查看卡片文字，内容从“init”更新为“CallFrom”；

10）回到主页，长按应用图标并点击<服务卡片>，选择使用call事件拉起指定UIAbility到后台卡片示例并点击添加到桌面；

11）先后点击“功能A”，“功能B”按钮，先后分别后台打印FunACall param及FunBCall param信息；

3.卡片数据交互

1）回到主页，长按应用图标并点击<服务卡片>，选择卡片定时刷新示例并点击添加到桌面；

2）等待1小时后观察卡片显示，标题从‘Title default’更新为'Title Update.'文字从‘定时刷新’更新为'Description update success.'；

3）回到主页，长按应用图标并点击<服务卡片>，选择卡片定点刷新示例并点击添加到桌面；	

4）等待到指定时间10:30后观察卡片显示，标题从‘Title default’更新为'Title Update.'文字从‘定点刷新’更新为'Description update success.'

5）回到主页，长按应用图标并点击<服务卡片>，选择固定时间后刷新示例并点击添加到桌面；

6）点击“Update”按钮，等待5min后观察卡片显示；

7）标题从‘Title default’更新为'Title Update.'文字从‘Description default’更新为'Description update success.'；

8）回到主页，长按应用图标并点击<服务卡片>，选择刷新本地图片和网络图片示例并点击添加到桌面；

9）此时卡片上图片显示默认图片，点击添加到桌面。此时显示为本地图片；

10）点击“刷新”按钮  图片更新为网络下载图片；

11）回到主页，长按应用图标并点击<服务卡片>，选择根据卡片状态刷新不同内容示例并点击添加到桌面；

12）勾选“状态A”，等待30min后观察卡片显示，卡片中只更新状态A文字“待刷新”为“AAA”；

13）勾选“状态B”，等待30min后观察卡片显示，卡片中只更新状态B文字“待刷新”为“BBB”；

14）回到主页，安装<共享数据>应用并点击打开，页面显示有“更新过程数据”，“更新持久化数据”按钮；

15）长按应用图标并点击<服务卡片>，选择<卡片代理刷新(过程数据)>示例；添加后观察卡片显示，卡片中央内容显示“加载中”；

16）返回“代理刷新卡片”应用主页面，点击<更新过程数据>，弹出“更新过程数据成功”提示。点击Home键返回桌面，观察卡片显示。卡片中央内容刷新，从“加载中”更新为”Qing“，且卡片提供方应用没有被拉起；

17）长按应用图标并点击<服务卡片>，选择<卡片代理刷新(持久化数据)>示例；添加后观察卡片显示，卡片中央内容显示“a”；

18）返回“共享数据”应用主页面，点击<更新持久化数据>，弹出“更新持久化数据成功”提示。点击Home键返回桌面，观察卡片显示。卡片中央内容刷新，从“a”更新为”snow“，该过程卡片提供方应用没有被拉起；

19）使用方刷新卡片内容：已确认无法在卡片内主动更新卡片，故该功能无法实现。

**开发基于JS UI的卡片**

1）回到主页，长按应用图标并点击<服务卡片>，选择开发基于JS UI的卡片示例并点击添加到桌面；

2）等待30min后观察卡片显示，title从“titleOnCreate”刷新为“titleOnUpdate”，文字内容从“detailOnCreat”刷新为“detailOnUpdate”；

### 工程目录
```
entry/src/main/ets/
├── attranimation
│   └── pages
│       └── AttrAnimationCard.ets			//属性动画示例
├── customcanvasdrawing
│   └── pages
│       └── CustomCanvasDrawingCard.ets		//卡片使用自定义绘制能力示例
├── entryability
│   └── EntryAbility.ts						//router事件跳转到指定UIAbility逻辑
├── entryformability
│   └── EntryFormAbility.ts					//卡片业务逻辑模块，提供卡片创建、销毁、刷新等生命周期回调。
├── jscardentryability
│   └── JsCardEntryAbility.ts				//JS卡片UIAbility实例
├── jscardformability
│   └── JsCardFormAbility.ts				//JS卡片业务逻辑模块
├── nextrefreshtime
│   └── pages
│       └── NextRefreshTimeCard.ets			//固定时间后刷新卡片页面
├── pages
│   ├── FunA.ets							//router调起ability页面A
│   ├── FunB.ets							//router调起ability页面B
│   └── Index.ets							//应用的默认页面
├── persistentdataformability
│   └── PersistentDataFormAbility.ts		//持久化数据下代理刷新卡片业务逻辑模块
├── processdataentryability
│   └── ProcessDataFormAbility.ts			//基于过程数据的卡片代理刷新订阅逻辑
├── scheduledupdatetime
│   └── pages
│       └── ScheduledUpdateTimeCard.ets		//定点刷新卡片页面
├── updatebymessage
│   └── pages
│       └── UpdateByMessageCard.ets			//message事件刷新卡片内容页面
├── updatebystatusformability
│   └── UpdateByStatusFormAbility.ts		//根据卡片状态刷新不同内容业务逻辑模块
├── updatebytimeformability
│   └── UpdateByTimeFormAbility.ts			//定时刷新卡片业务逻辑模块
├── updateduration
│   └── pages
│       └── UpdateDurationCard.ets			//定时刷新卡片页面
├── wgtimgupdateentryformability
│   └── WgtImgUpdateEntryFormAbility.ts		//本地图片和网络图片更新逻辑模块
├── widgetcalleeentryability
│   └── WidgetCalleeEntryAbility.ts			//通过call事件刷新卡片内容订阅逻辑
├── widgetcalleeformability
│   └── WidgetCalleeFormAbility.ts			//通过router或call事件刷新卡片内容页面更新逻辑
├── widgeteventcall
│   └── pages
│       └── WidgetEventCallCard.ets			//使用call事件拉起指定UIAbility到后台卡片页面
├── widgeteventcallentryability
│   └── WidgetEventCallEntryAbility.ts		//使用call事件拉起指定UIAbility到后台订阅逻辑
├── widgetevententryability
│   └── WidgetEventRouterEntryAbility.ts	//通过router事件刷新卡片内容逻辑入口
├── widgeteventrouter
│   └── pages
│       └── WidgetEventRouterCard.ets		//使用router事件跳转到指定UIAbility示例页面
├── widgetimageupdate
│   └── pages
│       └── WidgetImageUpdateCard.ets		//本地图片和网络图片更新示例页面
├── widgetpersistentdata
│   └── pages
│       └── WidgetPersistentDataCard.ets	//持久化数据下卡片代理刷新示例页面
├── widgetprocessdata
│   └── pages
│       └── WidgetProcessDataCard.ets		//基于过程数据的卡片代理刷新示例页面
├── widgetupdatebystatus
│   └── pages
│       └── WidgetUpdateByStatusCard.ets	//根据卡片状态刷新不同内容示例页面
├── widgetupdatecall
│   └── pages
│       └── WidgetUpdateCallCard.ets		//通过call事件刷新卡片内容示例页面
└── widgetupdaterouter
    └── pages
        └── WidgetUpdateRouterCard.ets		//通过router事件刷新卡片内容示例页面
```
### 具体实现

* 本示例分为基于ArkTS UI的卡片，基于JS UI的卡片两部分。其中ArkTS UI卡片下分为卡片页面，卡片事件，卡片数据交互三部分。
  * 开发卡片页面：

    * ArkTS卡片具备JS卡片的全量能力，并且新增了动效能力和自定义绘制的能力，支持声明式范式的部分组件、事件、动效、数据管理、状态管理能力。

    * 示例分别展示了animation动效及自定义绘制的能力。

  * 开发卡片事件：

    * 针对动态卡片，ArkTS卡片中提供了postCardAction()接口用于卡片内部和提供方应用间的交互，当前支持router、message和call三种类型的事件，仅在卡片中可以调用。
  * 接口定义：postCardAction(component: Object, action: Object): void
  
  * 卡片数据交互：

    * ArkTS卡片框架提供了updateForm()接口和requestForm()接口主动触发卡片的页面刷新，通过[LocalStorageProp](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/arkts-localstorage.md#localstorageprop)确认需要刷新的卡片数据。
  * 介绍了按时间刷新方式（通过form_config.json配置文件的updateDuration字段中进行设置），代理刷新，刷新网络数据等能力。
  

### 相关权限

[ohos.permission.KEEP_BACKGROUND_RUNNING](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionkeep_background_running)

[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

[ohos.permission.GET_BUNDLE_INFO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionget_bundle_info)

[ohos.permission.START_ABILITIES_FROM_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionstart_abilities_from_background)

### 依赖

1.本示例依赖共享数据的更新，由另一应用<共享数据>完成。测试代理刷新卡片功能时需要优先安装该应用。

- `app_signature`字段配置为应用的指纹信息，指纹信息的配置请参见[应用特权配置指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md#install_list_capabilityjson中配置)。

  ```
  [
    ...
    {
      "signingConfigs": ["****"], // 指纹信息
    }
  ]
  ```


### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568。

2.本示例为Stage模型，已适配API version 11版本SDK，版本号：4.1.3.1

3.本示例需要使用DevEco Studio 3.1.1 Release (Build Version: 3.1.0.501, built on June 20, 2023)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ApplicationModels/StageServiceWidgetCards/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```



