# app_samples部件<a name="ZH-CN_TOPIC_0000001115464207"></a>

## 简介<a name="section1470103520301"></a>

为帮助开发者快速熟悉OpenHarmony SDK所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的DevEco Studio工程项目，开发者可以将工程导入到DevEco Studio开发工具，通过浏览代码、编译工程、安装和运行应用示例来了解应用示例中涉及API的使用方法。

**编码规范**

<!--

【示例贡献温馨提示】感谢您关注OpenHarmony，如果您希望提交代码样例/示例/Demo，请参考知识体系的[《如何共建开发样例》](https://gitee.com/openharmony-sig/knowledge/blob/master/docs/co-construct_demos/README_zh.md)，首先提交到SIG（兴趣组）仓，知识体系SIG仓中的提交也是有效贡献。再次感谢您的关注！)  

-->

<table width="990" border="0" cellpadding="0" cellspacing="0" style='border-collapse:collapse;table-layout:fixed;'>
 <tr height="18" style='height:13.50pt;'>
  <td width="330"><a href="CodeCommitChecklist.md#社区共建Sample合入要求" target="_blank">社区共建Sample合入要求</a></td>
  <td width="330"><a href="CodeCommitChecklist.md#代码规范" target="_blank">代码规范</a></td>
  <td width="330"><a href="CodeCommitChecklist.md#readme编写规范" target="_blank">README编写规范</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td width="330"><a href="CodeCommitChecklist.md#ui自动化用例编写规范" target="_blank">UI自动化用例编写规范</a></td>
  <td width="330"><a href="CodeCommitChecklist.md#工程结构规范" target="_blank">工程结构规范</a></td>
  <td width="330"><a href="CodeCommitChecklist.md#pr提交格式规范" target="_blank">PR提交格式规范</a></td>
 </tr>
</table>

**架构组成**

<table  width="990" border="0" cellpadding="0" cellspacing="0" style='border-collapse:collapse;table-layout:fixed;'>
 <tr height="18" style='height:13.50pt;'>
  <td width="140" x:str><strong>一级分类</strong></td>
  <td width="170" x:str><strong>子分类</strong></td>
  <td width="680" colspan="4" align="center" x:str><strong>应用示例</strong></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td width="140" align="center" rowspan="2" style='height:27.00pt' x:str><strong>UI</strong></td>
  <td width="170" x:str><strong>声明式开发范式</strong></td>
  <td width="170" x:str><a href="code/UI/ArkTsComponentClollection/ComponentCollection">ArkTS组件集</a></td>
  <td width="170" x:str><a href="code/UI/ArkTsComponentClollection/MediaQuery">媒体查询</a></td>
  <td width="170"></td>
  <td width="170"></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>类Web开发范式</strong></td>
  <td x:str><a href="code/UI/JsComponentClollection/JsComponentCollection">Js组件集</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="270" align="center" rowspan="19" style='height:202.50pt' x:str><strong>基础特性</strong></td>
  <td x:str><strong>应用模型</strong></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/StageModel">Stage模型</a></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/AbilityStartMode">Ability的启动方式</a></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/CustomShare">使用want分享数据</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>通知</strong></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomEmitter">自定义Emitter</a></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomNotification">自定义通知</a></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomCommonEvent">公共事件的订阅和发布</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>窗口管理</strong></td>
  <td x:str><a href="code/BasicFeature/WindowManagement/WindowManage">窗口管理</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>Web</strong></td>
  <td x:str><a href="code/BasicFeature/Web/Browser">浏览器</a></td>
  <td x:str><a href="code/BasicFeature/Web/RunJsInWeb">JS注入与执行</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>媒体</strong></td>
  <td x:str><a href="code/BasicFeature/Media/Image">图片显示及处理</a></td>
  <td x:str><a href="code/BasicFeature/Media/VideoShow">视频播放</a></td>
  <td x:str><a href="code/BasicFeature/Media/GamePuzzle">图片裁剪与分割</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Media/Recorder">录音机</a></td>
  <td x:str><a href="code/BasicFeature/Media/QRCodeScan">二维码扫描</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>安全</strong></td>
  <td x:str><a href="code/BasicFeature/Security/Cipher">加解密</a></td>
  <td ><a href="code/BasicFeature/Security/AppAccountManager">应用账号管理</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>网络与连接</strong></td>
  <td x:str><a href="code/BasicFeature/Connectivity/Http">Http</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/RPC">RPC通信</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>数据管理</strong></td>
  <td x:str><a href="code/BasicFeature/DataManagement/Preferences">首选项</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>文件管理</strong></td>
  <td x:str><a href="code/BasicFeature/FileManagement/FileManager">文件管理</a></td>
  <td x:str><a href="code/BasicFeature/FileManagement/MediaCollections">媒体管理合集</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>设备管理</strong></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/USBManager">USB管理</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Location">位置服务</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/ScreenDetector">屏幕探测</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Vibrator">振动</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Sensor">传感器</a></td>
  <td ></td> 
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>电话服务</strong></td>
  <td x:str><a href="code/BasicFeature/Telephony/Call">拨打电话</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/SimManager">SIM卡管理</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/Message">短信</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/Contact">联系人</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Telephony/Observer">网络和Sim卡状态订阅</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/MobileNetwork">蜂窝数据</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/RadioTech">网络搜索</td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="1" x:str><strong>任务管理</strong></td>
  <td x:str><a href="code/BasicFeature/TaskManagement/ReminderAgentManager">后台代理提醒</a></td>
  <td x:str><a href="code/BasicFeature/TaskManagement/WorkScheduler">延迟任务调度</a></td>
  <td x:str><a href="code/BasicFeature/TaskManagement/Flybird">资源调度接口使用</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>设备信息统计</strong></td>
  <td x:str><a href="code/BasicFeature/DeviceUsageStatistics/DeviceUsageStatistics">设备使用信息统计</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>DFX</strong></td>
  <td x:str><a href="code/BasicFeature/DFX/Debug">Debug调试</a></td>
  <td ><a href="code/BasicFeature/DFX/DotTest">测试打点</a></td>
  <td ><a href="code/BasicFeature/DFX/FaultLogger">故障日志获取</a></td>
  <td ><a href="code/BasicFeature/DFX/Logger">日志打印</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>国际化</strong></td>
  <td x:str><a href="code/BasicFeature/Internationalnation/ResourceManager">资源管理</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>IDL</strong></td>
  <td x:str><a href="code/BasicFeature/IDL/AbilityConnectServiceExtension">Ability与ServiceExtensionAbility通信</a></td>
  <td x:str></td>
  <td x:str></td>
  <td x:str></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="90" align="center" rowspan="9" style='height:67.50pt;' x:str><strong>系统特性</strong></td>
  <td rowspan="2" x:str><strong>应用模型</strong></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/Launcher">仿桌面应用</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/MissionManager">任务管理</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/StaticSubscriber">静态订阅</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/AccessibilityExtAbility">无障碍扩展</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/ApplicationModels/EnterpriseAdminExtensionAbility">企业设备管理扩展</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>媒体</strong></td>
  <td x:str><a href="code/SystemFeature/Media/Screenshot">截屏</a></td>
  <td x:str><a href="code/SystemFeature/Media/ScreenRecorder">录屏</a></td>
  <td ></td>
  <td ></td>
 </tr>
 </tr>
  <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>安全</strong></td>
  <td x:str><a href="code/SystemFeature/Security/AbilityAccessCtrl">应用访问权限控制</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>窗口管理</strong></td>
  <td x:str><a href="code/SystemFeature/WindowManagement/WindowExtAbility">窗口扩展</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>网络与连接</strong></td>
  <td x:str><a href="code/SystemFeature/Connectivity/Wlan">Wlan</a></td>
  <td x:str><a href="code/SystemFeature/Connectivity/Bluetooth">蓝牙</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>数据管理</strong></td>
  <td x:str><a href="code/SystemFeature/DataManagement/CrossAppDataShare">系统应用跨应用数据共享</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>设备管理</strong></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/PowerManager">系统电源管理</a></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/StorageStatistic">存储空间统计</a></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/Screen">屏幕属性</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>国际化</strong></td>
  <td x:str><a href="code/SystemFeature/Internationalnation/International">时区和语言设置</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 <tr height="18" style='height:13.50pt;'>
  <td height="90" align="center" rowspan="5" style='height:67.50pt;' x:str><strong>关键特性</strong></td>
  <td rowspan="2" x:str><strong>一次开发，多端部署</strong></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/AdaptiveCapabilities">ArkTS一多能力集合</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/JsAdaptiveCapabilities">Js一多能力集合（Js）（API 8）</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/Weather">入门示例：天气应用</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/HealthyDiet">典型页面场景：健康饮食</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/AppMarket">典型页面场景：应用市场首页</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/MusicAlbum">典型页面场景：音乐专辑页</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/Settings">典型页面场景：设置应用页面</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>分布式</strong></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/ArkTSDistributedMusicPlayer">ArkTS分布式音乐播放</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/ArkTSDistributedCalc">分布式计算器</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedNote">分布式对象</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedRdb">分布式关系型数据库</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/Kvstore">分布式数据管理</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedAuthentication">分布式组网认证</a></td>
  <td x:str></td>
  <td></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>卡片</strong></td>
  <td x:str><a href="code/SuperFeature/Widget/FormExtAbility">Stage模型卡片</a></td>
  <td></td>
  <td></td>
  <td></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="90" align="center" rowspan="4" style='height:67.50pt' x:str><strong>行业解决方案</strong></td>
  <td x:str><strong>即时通信</strong></td>
  <td x:str><a href="code/Solutions/IM/Chat">聊天实例应用</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>电商</strong></td>
  <td x:str><a href="code/Solutions/Shopping/OrangeShopping">购物示例应用</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>游戏</strong></td>
  <td x:str><a href="code/Solutions/Game/Game2048">游戏2048</a></td>
  <td x:str><a href="code/Solutions/Game/Lottie">Lottie</a></td>
  <td x:str><a href="code/Solutions/Game/DistributedDataGobang">分布式五子棋</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>工具</strong></td>
  <td x:str><a href="code/Solutions/Tools/PatternLock">图案密码锁</a></td>
  <td x:str><a href="code/Solutions/Tools/FlipClock">翻页时钟</a></td>
  <td x:str><a href="code/Solutions/Tools/ArkTSClock">ArkTS时钟</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="54" align="center" rowspan="3" style='height:40.50pt' x:str><strong>工程能力</strong></td>
  <td x:str><strong>资源配置</strong></td>
  <td x:str><a href="code/Project/ResourceAllocation/ApplicationThemeSwitch">应用主题切换</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>三方库使用</strong></td>
  <td x:str><a href="code/Project/ThirdPartyLibrary/Npm">npm的使用</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>应用程序包</strong></td>
  <td x:str><a href="code/Project/ApplicationHap/MultiHap">多hap</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="1" align="center" x:str><strong>语言基础类库</strong></td>
  <td rowspan="1" x:str><strong>语言基础类库</strong></td>
  <td x:str><a href="code/LaunguageBaseClassLibrary/LanguageBaseClassLibrary">语言基础类库</a></td>
  <td x:str><a href="code/LaunguageBaseClassLibrary/JsWorker">启动一个worker</a></td>
  <td x:str><a href="code/LaunguageBaseClassLibrary/ZipLib">压缩与解压</a></td>
  <td ></td>
 </tr>
 <tr>
 <![if supportMisalignedColumns]>
   <tr height="18" style="display:none;">
   </tr>
  <![endif]>
</table>





## 目录<a name="sectionMenu"></a>

Sample仓下所展示的组件能力：

```
code
|---UI                         # UI开发
  |---ArkTsComponentClollection    # ArkTs组件集
  |---JsComponentClollection       # 类Web开发范式组件集
|---BasicFeature               # 基础特性
  |---ApplicationModels            # 应用模型
  |---Notification                 # 通知
  |---WindowManagement             # 窗口管理
  |---Web                          # Web
  |---Media                        # 媒体
  |---Security                     # 安全
  |---Connectivity                 # 网络与连接
  |---DataManagement               # 数据管理
  |---FileManagement               # 文件管理
  |---Telephony                    # 电话服务
  |---TaskManagement               # 任务管理
  |---DeviceManagement             # 设备管理
  |---DeviceUsageStatistics        # 设备使用信息统计
  |---DFX                          # DFX
  |---Internationalnation          # 国际化
  |---IDL                          # IDL
|---SystemFeature              # 系统特性
  |---ApplicationModels            # 应用模型
  |---WindowManagement             # 窗口管理
  |---Media                        # 媒体
  |---Connectivity                 # 网络与连接
  |---DataManagement               # 数据管理
  |---DeviceManagement             # 设备管理
  |---Internationalnation          # 国际化
|---SuperFeature               # 关键特性
  |---MultiDeviceAppDev            # 一多
  |---DistributedAppDev            # 分布式
  |---Widget                       # 卡片
|---Solutions                  # 行业解决方案
  |---IM                           # 即时通信
  |---Shopping                     # 电商
  |---Game                         # 游戏	
  |---Tools                        # 工具
|---Project                    # 工程能力
  |---ResourceAllocation           # 资源配置
  |---ThirdPartyLibrary            # 三方库使用
  |---ApplicationHap               # 应用程序包
|---LaunguageBaseClassLibrary  # 语言基础类库
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

