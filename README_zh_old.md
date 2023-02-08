# app_samples部件<a name="ZH-CN_TOPIC_0000001115464207"></a>

## 简介<a name="section1470103520301"></a>

【示例贡献温馨提示】感谢您关注OpenHarmony，如果您希望提交代码样例/示例/Demo，请参考知识体系的[《如何共建开发样例》](https://gitee.com/openharmony-sig/knowledge/blob/master/docs/co-construct_demos/README_zh.md)，首先提交到SIG（兴趣组）仓，知识体系SIG仓中的提交也是有效贡献。再次感谢您的关注！

新Sample合入需遵循[Sample编码规范](CodeCommitChecklist.md)。

**内容简介**

为帮助开发者快速熟悉OpenHarmony SDK所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

**架构组成**

- Basic
  - [`Container`：线性容器ArrayList（ArkTS）（API8）](Basic/Container)
  - [`Screenshot`：屏幕截图（ArkTS）（API9）（Full SDK）](Basic/Screenshot)
- AppSample
  - [`Chat`：聊天示例应用（ArkTS）（API8）](AppSample/Chat)
  - [`Shopping`：购物示例应用（ArkTS）（API8）](AppSample/Shopping)
- Account
  - [`AppAccountManager`：应用帐号管理（ArkTS）（API8）](Account/AppAccountManager)
  - [`DistributeAccount`：分布式帐号管理（ArkTS）（API8）](Account/DistributeAccount)
- Communication
  - [`RPC`：RPC连接（ArkTS）（API8）](Communication/RPC)
  - [`Wlan`：WLAN（ArkTS）（API8）（Full SDK）](Communication/Wlan)
- ability
  - [`DMS`：分布式Demo（ArkTS）（API8）（Full SDK）](ability/DMS)
  - [`JsDistributedMusicPlayer`：分布式音乐播放（JS）（API8）（Full SDK）](ability/JsDistributedMusicPlayer)
  - [`DataAbility`：DataAbility的创建与访问（ArkTS）（API8）](ability/DataAbility)
  - [`ServiceAbility`：ServiceAbility的创建与使用（ArkTS）（API8）](ability/ServiceAbility)
  - [`FormAbility`：FA模型卡片（ArkTS）（API8）](ability/FormAbility)
  - [`FormExtAbility`：Stage模型卡片（ArkTS）（API9）](ability/FormExtAbility)
  - [`FormLauncher`：卡片使用方（ArkTS）（API8）（Full SDK）](ability/FormLauncher)
  - [`ServiceExtAbility`：StageExtAbility的创建与使用（ArkTS）（API9）（Full SDK）](ability/ServiceExtAbility)
  - [`DistributedGraffiti`：分布式涂鸦（ArkTS）（API8）（Full SDK）](ability/DistributedGraffiti)
  - [`MissionManager`：系统任务管理（ArkTS）（API9）（Full SDK）](ability/MissionManager)
  - [`GalleryForm`：图库卡片（ArkTS）（API9）](ability/GalleryForm)
  - [`Launcher`：仿桌面应用（ArkTS）（API9）（Full SDK）](ability/Launcher)
  - [`FaModel`：FA模型（ArkTS）（API9）](ability/FaModel)
  - [`StageModel`：Stage模型（ArkTS）（API9）（Full SDK）](ability/StageModel)
  - [`AbilityConnectServiceExtension`：Ability与ServiceExtensionAbility通信（ArkTS）（API9）（Full SDK）](ability/AbilityConnectServiceExtension)
  - [`WindowExtAbility`：窗口扩展（ArkTS）（API9）（Full SDK）](ability/WindowExtAbility)
- common
  - [`Clock`：时钟（JS）（API8）](common/Clock)
  - [`DistributeCalc`：分布式计算器（JS）（API8）（Full SDK）](common/DistributeCalc)
  - [`ResourceManager`：资源管理器（ArkTS）（API8）](common/ResourceManager)
  - [`Runninglock`：运行锁（ArkTS）（API8）](common/Runninglock)
  - [`JsHelloWorld`：你好世界（JS）（API8）](common/JsHelloWorld)
  - [`PowerManager`：系统电源管理（ArkTS）（API8）（Full SDK）](common/PowerManager)
  - [`International`：国际化（ArkTS）（API8）（Full SDK）](common/International)
- data
  - [`KvStore`：分布式数据库（ArkTS）（API8）（Full SDK）](data/Kvstore)
  - [`LiteStorage`：轻量级存储（ArkTS）（API8）](data/LiteStorage)
  - [`DDMQuery`：结果集与谓词（ArkTS）（API8）](data/DDMQuery)
  - [`DistributedRdb`：分布式关系型数据库（ArkTS）（API8）（Full SDK）](data/DistributedRdb)
  - [`Preferences`：首选项（ArkTS）（API9）](data/Preferences)
  - [`DistributedNote`：分布式备忘录（ArkTS）（API9）（Full SDK）](data/DistributedNote)
  - [`DistributedDataGobang`：分布式五子棋（ArkTS）（API9）（Full SDK）](data/DistributedDataGobang)
  - [`DistributedObjectDms`：分布式跑马灯（ArkTS）（API9）（Full SDK）](data/DistributedObjectDms)
- device
  - [`DeviceManager`：设备管理（ArkTS）（API8）（Full SDK）](device/DeviceManager)
  - [`Sensor`：传感器（ArkTS）（API8）](device/Sensor)
  - [`Vibrator`：振动（ArkTS）（API8）](device/Vibrator)
  - [`DeviceUsageStatistics`：设备使用信息统计（ArkTS）（API8）（Full SDK）](device/DeviceUsageStatistics)
  - [`Browser`：浏览器（ArkTS）（API9）（Full SDK）](device/Browser)
  - [`Screen`：屏幕属性（ArkTS）（API9）（Full SDK）](device/Screen)
  - [`USBManager`：USB管理（ArkTS）（API8）](device/USBManager)
  - [`Bluetooth`：蓝牙（ArkTS）（API9）（Full SDK）](device/Bluetooth)
  - [`Location`：位置服务（ArkTS）（API9）](device/Location)
- Graphics
  - [`JsWebGL`：WebGL（JS）（API8）](Graphics/JsWebGL)
  - [`Window`：窗口（ArkTS）（API9）](Graphics/Window)
- media
  - [`JsAudioPlayer`：音频播放和管理（JS）（API8）](media/JsAudioPlayer)
  - [`JsVideo`：视频播放（JS）（API8）](media/JsVideo)
  - [`Recorder`：录音机（ArkTS）（API8）（Full SDK）](media/Recorder)
  - [`MultiMedia`：相机和媒体库（ArkTS）（API9）（Full SDK）](media/MultiMedia)
  - [`VideoPlayer`：视频播放（ArkTS）（API9）（Full SDK）](media/VideoPlayer)
  - [`Image`：图片处理（ArkTS）（API9）](media/Image)
  - [`GamePuzzle`：拼图（ArkTS）（API9）](media/GamePuzzle)
  - [`VideoShow`：媒体库视频（ArkTS）（API9）](media/VideoShow)
  - [`ImageShow`：图片显示（ArkTS）（API9）](media/ImageShow)
  - [`MediaCollections`：媒体管理合集（ArkTS）（API9）（Full SDK）](media/MediaCollections)
- DFX
  - [`JsDotTest`：测试打点（JS）（API8）](DFX/JsDotTest)
  - [`FaultLogger`：故障日志获取（ArkTS）（API8）](DFX/FaultLogger)
  - [`Logger`：日志打印（ArkTS）（API9）](DFX/Logger)
  - [`Debug`：Debug（ArkTS）（API9）](DFX/Debug)
- Safety
  - [`Cipher`：加解密（ArkTS）（API8）](Safety/Cipher)
  - [`AbilityAccessCtrl`：访问权限控制（ArkTS）（API8）（Full SDK）](Safety/AbilityAccessCtrl)
- Telephony
  - [`Call`：拨打电话（ArkTS）（API8）](Telephony/Call)
  - [`Message`：短信服务（ArkTS）（API8）（Full SDK）](Telephony/Message)
  - [`RadioTech`：网络搜索（ArkTS）（API8）](Telephony/RadioTech)
  - [`SimManager`：SIM卡管理（ArkTS）（API8）](Telephony/SimManager)
  - [`MobileNetwork`：蜂窝数据（ArkTS）（API9）](Telephony/MobileNetwork)
  - [`Observer`：Observer（ArkTS）（API9）](Telephony/Observer)
  - [`Contact`：Contact（ArkTS）（API8）](Telephony/Contact)
- thread
  - [`JsWorker`：启动一个worker（JS）（API8）](thread/JsWorker)
- CompleteApps
  - [`KikaInput`：轻量级输入法（JS）（API9）（Full SDK）](CompleteApps/KikaInput)
  - [`FlipClock`：翻页时钟（ArkTS）（API8）（Full SDK）](CompleteApps/FlipClock)
- EngineeringCapability
  - [`Npm`：npm的使用（ArkTS）（API9）](EngineeringCapability/Npm)
- ETSUI
  - [`Canvas`：画布组件（ArkTS）（API8）](ETSUI/Canvas)
  - [`CustomComponent`：组件化（ArkTS）（API8）](ETSUI/CustomComponent)
  - [`Process`：进程信息（ArkTS）（API9）（Full SDK）](ETSUI/Process)
  - [`BuildCommonView`：创建简单视图（ArkTS）（API8）](ETSUI/BuildCommonView)
  - [`DefiningPageLayoutAndConnection`：页面布局和连接（ArkTS）（API8）](ETSUI/DefiningPageLayoutAndConnection)
  - [`Drag`：拖拽事件（ArkTS）（API8）](ETSUI/Drag)
  - [`ArkUIAnimation`：动画（ArkTS）（API8）](ETSUI/ArkUIAnimation)
  - [`MediaQuery`：媒体查询（AekTS）（API8）](ETSUI/MediaQuery)
  - [`MouseEvent`：鼠标事件（ArkTS）（API8）](ETSUI/MouseEvent)
  - [`Web`：Web（ArkTS）（API8）](ETSUI/Web)
  - [`Gallery`：组件集合（ArkTS）（API8）](ETSUI/Gallery)
  - [`BringApp`：拉起系统应用（ArkTS）（API8）（Full SDK）](ETSUI/BringApp)
  - [`Game2048`：2048游戏（ArkTS）（API8）](ETSUI/Game2048)
  - [`Lottie`：Lottie（ArkTS）（API8）（Full SDK）](ETSUI/Lottie)
  - [`TransitionAnimation`：转场动画（ArkTS）（API9）](ETSUI/TransitionAnimation)
  - [`PatternLock`：图案密码锁组件（ArkTS）（API9）](ETSUI/PatternLock)
  - [`Search`：Search组件（ArkTS）（API9）](ETSUI/Search)
  - [`QRCode`：二维码（ArkTS）（API9）（Full SDK）](ETSUI/QRCode)
  - [`UpgradePopup`：自定义弹窗（ArkTS）（API9）](ETSUI/UpgradePopup)
  - [`HealthyDiet`：健康饮食（ArkTS）（API9）](ETSUI/HealthyDiet)
  - [`OrangeShopping`：购物示例应用（ArkTS）（API9）](ETSUI/OrangeShopping)
  - [`ComponentCollection`：组件集合（ArkTS）（API9）](ETSUI/ComponentCollection)
- FileManager
  - [`FileIo`：文件管理（ArkTS）（API8）](FileManager/FileIo)
- Notification
  - [`CommonEvent`：订阅公共事件（ArkTS）（API8）](Notification/CommonEvent)
  - [`Emitter`：处理进程内事件（ArkTS）（API8）](Notification/Emitter)
  - [`AlarmClock`：后台代理提醒（ArkTS）（API8）](Notification/AlarmClock)
  - [`Notification`：订阅、发送通知（ArkTS）（API9）（Full SDK）](Notification/Notification)
  - [`CustomNotification`：自定义通知（ArkTS）（API9）](Notification/CustomNotification)
- Network
  - [`Http`：数据请求（ArkTS）（API9）](Network/Http)
  - [`Socket`：Socket 连接（ArkTS）（API9）](Network/Socket)
  - [`WebSocket`：WebSocket（ArkTS）（API9）](Network/WebSocket)
  - [`UploadDownload`：上传下载（ArkTS）（API8）](Network/UploadDownload)
- Preset
  - [`Clock`：简单时钟（ArkTS）（API9）](Preset/Clock)
  - [`DistributeCalc`：分布式计算器（ArkTS）（API8）（Full SDK）](Preset/DistributeCalc)
  - [`DistributedMusicPlayer`：分布式音乐（ArkTS）（API9）（Full SDK）](Preset/DistributedMusicPlayer)
- PackageManagement
  - [`ZipLib`：压缩与解压（ArkTS）（API8）](PackageManagement/ZipLib)
- ResourcesSchedule
  - [`Flybird`：小鸟避障游戏（ArkTS）（API8）](ResourcesSchedule/Flybird)
  - [`BackgroundTaskManager`：后台任务管理（ArkTS）（API8）](ResourcesSchedule/BackgroundTaskManager)
  - [`WorkScheduler`：延迟任务调度（ArkTS）（API9）](ResourcesSchedule/WorkScheduler)
- UI
  - [`AtomicLayout`：原子布局（JS）（API8）](UI/AtomicLayout)
  - [`Badge`：事件标记控件（JS）（API8）](UI/Badge)
  - [`International`：国际化（JS）（API8）](UI/International)
  - [`JsFA`：FA示例应用（JS）（API8）](UI/JsFA)
  - [`JsShopping`：购物示例应用（JS）（API8）](UI/JsShopping)
  - [`JSMenu`：菜单（JS）（API8）](UI/JSMenu)
  - [`JSUICustomComponent`：自定义组件（JS）（API8）](UI/JSUICustomComponent)
  - [`JsAnimation`：动效示例应用（JS）（API8）](UI/JsAnimation)
  - [`JsAnimationStyle`：动画与自定义字体（JS）（API8）](UI/JsAnimationStyle)
  - [`JsBasicComponents`：基础组件（JS）（API8）](UI/JsBasicComponents)
  - [`JsBrightness`：设置屏幕亮度（JS）（API8）（Full SDK）](UI/JsBrightness)
  - [`JsCanvas`：画布组件（JS）（API8）](UI/JsCanvas)
  - [`JsDevice`：设备信息（JS）（API8）](UI/JsDevice)
  - [`JsDialog`：页面弹窗（JS）（API8）](UI/JsDialog)
  - [`JsGrid`：栅格布局（JS）（API8）](UI/JsGrid)
  - [`JsList`：商品列表（JS）（API8）](UI/JsList)
  - [`JsPanel`：内容展示面板（JS）（API8）](UI/JsPanel)
  - [`JsRouter`：页面路由（JS）（API8）](UI/JsRouter)
  - [`JsSvg`：可缩放矢量图形（JS）（API8）](UI/JsSvg)
  - [`JsTimer`：定时器与系统时间设置（JS）（API8）](UI/JsTimer)
  - [`Picker`：滑动选择器（JS）（API8）](UI/Picker)
  - [`Popup`：气泡（JS）（API8）](UI/Popup)
  - [`RefreshContainer`：下拉刷新容器（JS）（API8）](UI/RefreshContainer)
  - [`Slider`：滑动条（JS）（API8）](UI/Slider)
  - [`Stack`：堆叠容器（JS）（API8）](UI/Stack)
  - [`StepNavigator`：步骤导航器（JS）（API8）](UI/StepNavigator)
  - [`Swiper`：内容滑动容器（JS）（API8）](UI/Swiper)
  - [`Tabs`：页签容器（JS）（API8）](UI/Tabs)
  - [`Toolbar`：工具栏（JS）（API8）](UI/Toolbar)
  - [`chart`：图表组件（JS）（API8）](UI/chart)
  - [`JsAdaptivePortalList`：多设备自适应的效率型首页（JS）（API8）](UI/JsAdaptivePortalList)
  - [`JsAdaptivePortalPage`：多设备自适应的FA页面（JS）（API8）](UI/JsAdaptivePortalPage)
  - [`JsImage`：基本动画（JS）（API8）](UI/JsImage)
  - [`JsGallery`：图库示例应用（JS）（API8）](UI/JsGallery)
  - [`JSComponments`：Js组件（JS）（API8）](UI/JSComponments)
  - [`JsUserRegistration`：用户注册（JS）（API8）](UI/JsUserRegistration)
  - [`JsAdaptiveServiceWidget`：多设备自适应服务卡片（JS）（API8）](UI/JsAdaptiveServiceWidget)
  - [`JsAnimator`：动画（JS）（API8）](UI/JsAnimator)
  - [`JsComponentCollection`：组件集合（JS）（API9）](UI/JsComponentCollection)
- Util
  - [`UtilBase64Codec`：Base64编解码（ArkTS）（API8）](Util/UtilBase64Codec)
  - [`UtilScope`：范围判断（ArkTS）（API8）](Util/UtilScope)
  - [`UtilStringCodec`：字符串编解码（ArkTS）（API8）](Util/UtilStringCodec)
  - [`UtilLruBuffer`：缓冲区（ArkTS）（API9）](Util/UtilLruBuffer)
  - [`UtilRationalNumber`：有理数（ArkTS）（API8）](Util/UtilRationalNumber)
  - [`UtilTypeCheck`：内置对象类型检查（ArkTS）（API8）](Util/UtilTypeCheck)
  - [`UtilUrlString`：URL字符串解析（ArkTS）（API8）](Util/UtilUrlString)
  - [`XmlTextConvert`：xml文本转换（ArkTS）（API8）](Util/XmlTextConvert)
- MultiDeviceAppDev
  - [`AdaptiveCapabilities`：多设备自适应能力（ArkTS）（API9）](MultiDeviceAppDev/AdaptiveCapabilities)
  - [`JsAdaptiveCapabilities`：多设备自适应能力（JS）（API8）](MultiDeviceAppDev/JsAdaptiveCapabilities)
  - [`AppMarket`：一多应用市场首页（ArkTS）（API9）](MultiDeviceAppDev/AppMarket)
  - [`Vegetable`：一多蔬菜百科主页（ArkTS）（API9）](MultiDeviceAppDev/Vegetable)
  - [`Weather`：一多天气（ArkTS）（API9）](MultiDeviceAppDev/Weather)
  - [`MusicAlbum`：一多音乐专辑主页（ArkTS）（API9）](MultiDeviceAppDev/MusicAlbum)
- Share
  - [`CustomShare`：自定义分享（ArkTS）（API9）（Full SDK）](Share/CustomShare)

## 目录<a name="sectionMenu"></a>

Sample仓下所展示的组件能力：

```
app_samples
|---ability                # 页面能力
|---Account                # 账号管理
|---AppSample              # 示例应用
|---Basic                  # 基础组件
|---common                 # 公共能力
|---Communication          # 通信与连接
|---CompleteApps           # 完整应用
|---data                   # 数据管理
|---device                 # 设备管理
|---DFX                    # 日志打印
|---EngineeringCapability  # 工程能力
|---ETSUI                  # eTS UI能力
|---FileManager            # 文件管理
|---Graphics               # 图像绘制
|---media                  # 媒体
|---MultiDeviceAppDev      # 一多应用
|---Network                # 网络连接
|---Notification           # 消息通知
|---PackageManagement      # 包管理
|---Preset                 # 预设应用
|---ResourcesSchedule      # 资源调度
|---Safety                 # 安全
|---Share                  # 分享
|---Telephony              # 电话功能
|---thread                 # 线程操作
|---UI                     # Js UI能力
|---Util                   # 基础工具类
```



## 约束<a name="section18841871178"></a>

安装应用示例之前，请先查看"README_zh.md"文件来确认应用示例是否为stage模型，若为Stage模型需要查看entry/src/main路径下的module.json5文件中的"deviceType"字段来确认该应用支持的设备类型；否则为FA模型，查看entry/src/main路径下的config.json文件中的"deviceType"字段来确认该应用示例支持的设备类型，两种模型都可尝试通过修改该字段使其可以在相应类型的设备上运行。


## 使用方法<a name="section17988202503116"></a>

1.  本仓默认下载全量工程代码，如需下载单个应用工程代码，请先下载并执行工具[【Windows版本】](DirCloneTool/CloneSpecifyDirForWindows.bat)、[【macOS版本】]()、[【Linux版本】]()
2.  将独立的应用示例工程导入DevEco Studio进行编译构建及运行调试。
3.  部分应用示例中含有多个模块，开发者可以选择对单个模块进行编译构建，生成一个HAP应用安装包，也可以对整个工程进行编译构建，生成多个HAP应用安装包。
4.  安装运行后，即可在设备上查看应用示例运行效果，以及进行相关调试。

## Changlog<a name="section17988202503117"></a>

应用修改记录：[changelog](changelog.md)

## releasenote

应用发布版本分支说明：[releasenote](releasenote.md)

## 相关仓<a name="section17988202503118"></a>

1. [app_sample](https://gitee.com/openharmony/app_samples) 已废弃
2. [applications_app_sample](https://gitee.com/openharmony/applications_app_samples)

