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
  <td width="140" align="center" rowspan="5" style='height:27.00pt' x:str><strong>UI</strong></td>
  <td rowspan="5" x:str><strong>声明式开发范式</strong></td>
  <td width="170" x:str><a href="code/UI/ArkTsComponentCollection/ComponentCollection">ArkTS组件集（API 12）</a></td>
  <td width="170" x:str><a href="code/UI/CalendarViewSwitch">日历视图切换</a></td>
  <td width="170" x:str><a href="code/UI/CitySearch">城市选择案例</a></td>
  <td width="170" x:str><a href="code/UI/CustomAnimationTab">自定义动效tab</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
<td width="170" x:str><a href="code/UI/DragAndExchange">Grid和List内拖拽交换子组件位置</a></td>
<td width="170" x:str><a href="code/UI/ExpandTitle">标题下拉缩放案例</a></td>
<td width="170" x:str><a href="code/UI/FoldableAdaptation">Navigation实现折叠屏适配案例</a></td>
<td width="170" x:str><a href="code/UI/ImageViewer">多图片预览效果实现</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td width="170" x:str><a href="code/UI/Immersive">沉浸式适配案例</a></td>
  <td width="170" x:str><a href="code/UI/ImperativeDynamicLayouts">FrameNode扩展实现动态布局类框架</a></td>
  <td width="170" x:str><a href="code/UI/KeyboardAvoid">组件随软键盘弹出避让</a></td>
  <td width="170" x:str><a href="code/UI/ListBeExchange">列表项交换案例</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td width="170" x:str><a href="code/UI/PageLoading">页面加载效果实现案例</a></td>
  <td width="170" x:str><a href="code/UI/PullToRefresh">下拉刷新与上滑加载案例</a></td>
  <td width="170" x:str><a href="code/UI/SearchComponent">搜索功能实现案例</a></td>
  <td width="170" x:str><a href="code/UI/TabContentTouchHotZone">Progress触摸热区增大案例</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td width="170" x:str><a href="code/UI/VerifyCode">验证码布局</a></td>
  <td width="170" x:str><a href="code/UI/WindowStartIcon">启动页实现案例</a></td>
  <td></td>
  <td></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="270" align="center" rowspan="35" style='height:202.50pt' x:str><strong>基础特性</strong></td>
  <td x:str><strong>能力增强</strong></td>
  <td x:str><a href="code/BasicFeature/Ability/AbilityFeature">基础能力增强</a></td>
  <td x:str><a href="code/BasicFeature/Ability/AbilityRuntime">基础能力增强</a></td>
  <td x:str><a href="code/BasicFeature/Ability/AppStartup">应用启动框架startup</a></td>
  <td x:str><a href="code/BasicFeature/Ability/UniversalLink">基础能力增强</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>广告</strong></td>
  <td x:str><a href="code/BasicFeature/Ads/OAIDSample">广告标识服务Sample</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>应用模型</strong></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/AbilityStartMode">Ability的启动方式</a></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/BundleManager/BundleManagement">支持5.0特性能力sample</a></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/DynamicRouter">Navigation动态路由</a></td>
  <td x:str><a href="code/BasicFeature/ApplicationModels/SystemRouter">Navigation系统路由</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="3" x:str><strong>网络与连接</strong></td>
  <td x:str><a href="code/BasicFeature/Connectivity/Bluetooth">蓝牙</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/Http">Http（API 10）</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/MultipleFilesDownload">多文件下载监听案例</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/NetworkObserver">网络状态监听</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Connectivity/RPC">RPC通信</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/Socket">网络管理-Socket连接（UDP）</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/StageSocket">Socket连接</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/UploadAndDownLoad">上传和下载（API 12）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Connectivity/VPN">VPN连接</a></td>
  <td x:str><a href="code/BasicFeature/Connectivity/WebSocket">WebSocket</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>DFX</strong></td>
  <td x:str><a href="code/BasicFeature/DFX/Debug">Debug调试</a></td>
  <td ><a href="code/BasicFeature/DFX/DotTest">测试打点</a></td>
  <td ><a href="code/BasicFeature/DFX/FaultLogger">故障日志获取</a></td>
  <td ><a href="code/BasicFeature/DFX/Logger">日志打印</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/DFX/AppRecovery">应用故障恢复（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>数据管理</strong></td>
  <td x:str><a href="code/BasicFeature/DataManagement/Preferences">首选项</a></td>
  <td x:str><a href="code/BasicFeature/DataManagement/UDMF/UDMFDemo">UDMF Demo</a></td>
  <td x:str><a href="code/BasicFeature/DataManagement/pasteboard">剪贴板Sample</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>设备管理</strong></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Location">位置服务</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/ScreenDetector">屏幕探测</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/DeviceManagementCollection">设备管理合集（API 10）</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Vibrator/CustomHaptic">自定义振动（API 10）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Vibrator/BasicVibration">振动</a></td>
  <td x:str><a href="code/BasicFeature/DeviceManagement/Sensor/Capi">传感器</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="1" x:str><strong>文件管理</strong></td>
  <td x:str><a href="code/BasicFeature/Extension/Contexttest">extension示例</a></td>
  <td x:str><a href="code/BasicFeature/FileManagement/FileBackupExtension">应用接入数据备份恢复（API 11）</a></td>
  <td x:str><a href="code/BasicFeature/FileManagement/FileShare/SandboxShare">文件分享与访问</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>图像</strong></td>
  <td x:str><a href="code/BasicFeature/Graphics/DisplaySoloist">DisplaySoloist分级管控</a></td>
  <td x:str><a href="code/BasicFeature/Graphics/DisplaySync">DisplaySync分级管控</a></td>
  <td x:str><a href="code/BasicFeature/Graphics/Graphics2d/Eraser">橡皮擦</a></td>
  <td x:str><a href="code/BasicFeature/Graphics/Graphics2d/ExpandText">字体文本展开</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Graphics/Graphics2d/PaintVerbatim">字体绘制</a></td>
  <td x:str><a href="code/BasicFeature/Graphics/Graphics2d/TsDrawingSample">图形绘制与显示的示例（TSDrawingSample）</a></td>
  <td x:str><a href="code/BasicFeature/Graphics/Graphics3d">3D引擎接口示例</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>国际化</strong></td>
  <td x:str><a href="code/BasicFeature/International/International">国际化</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
<tr height="18" style='height:13.50pt;'>
  <td rowspan="5" x:str><strong>媒体</strong></td>
  <td x:str><a href="code/BasicFeature/Media/AVRecorder">音视频录制</a></td>
  <td x:str><a href="code/BasicFeature/Media/AVSession/AvCastPickerForCall">通话设备切换</a></td>
  <td x:str><a href="code/BasicFeature/Media/AVSession/MediaProvider">媒体会话——提供方（API 10）</a></td>
  <td x:str><a href="code/BasicFeature/Media/AVSession/VideoPlayer">视频播放</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Media/Audio">音频管理（API 12）</a></td>
  <td x:str><a href="code/BasicFeature/Media/AudioHaptic">音振</a></td>
  <td x:str><a href="code/BasicFeature/Media/AudioToVideoSync">实现音画同步播放效果</a></td>
  <td x:str><a href="code/BasicFeature/Media/Camera">相机示例</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Media/Camera_js">相机示例（JS）</a></td>
  <td x:str><a href="code/BasicFeature/Media/CustomScan">折叠屏扫描二维码方案</a></td>
  <td x:str><a href="code/BasicFeature/Media/Image">图片编辑（API 14）</a></td>
  <td x:str><a href="code/BasicFeature/Media/ImageEffect">图片编辑</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Media/ImageShow">图片显示</a></td>
  <td x:str><a href="code/BasicFeature/Media/QRCodeScan">二维码扫描</a></td>
  <td x:str><a href="code/BasicFeature/Media/VideoListAutoPlay">滑动视频自动播放</a></td>
  <td x:str><a href="code/BasicFeature/Media/VideoPlay">视频播放（API 12）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Media/VideoShow">媒体库视频</a></td>
  <td x:str><a href="code/BasicFeature/Media/VideoSwitching">短视频切换案例</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="4" x:str><strong>Native</strong></td>
  <td x:str><a href="code/BasicFeature/Native/ArkTSXComponent">XComponent</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkDrawing">Native Drawing</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkNativeImage">基于NdkNativeImage的平滑渐变动画效果</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkNativeWindow">Native Window</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Native/NdkNotification">Native Notification</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkOpenGL">OpenGL三棱椎（API 10）</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkQoS">Native QoS</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkRawfile">获取Rawfile资源</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Native/NdkRenderNodeDrawing">Native RenderNode Drawing</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkTsDrawing">NdkTsDrawing</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkVulkan">XComponent组件对接Vulkan</a></td>
  <td x:str><a href="code/BasicFeature/Native/NdkXComponent">Native XComponent（API 10）</a></td>
 </tr>
  <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Native/XComponent">XComponent</a></td>
  <td x:str><a href="code/BasicFeature/Native/XComponent3D">XComponent3D</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>通知</strong></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomCommonEvent">公共事件的订阅和发布（API 11）</a></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomCommonEventRely">自定义Emitter</a></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomEmitter">自定义Emitter</a></td>
  <td x:str><a href="code/BasicFeature/Notification/CustomNotification">自定义通知（API 10）</a></td>
 </tr>
  <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Notification/CustomNotificationBadge">自定义通知角标（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>打印</strong></td>
  <td x:str><a href="code/BasicFeature/Print/ScanNapiInterfaceDemo">扫描仪应用demo</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>资源</strong></td>
  <td x:str><a href="code/BasicFeature/Resource/ResourceManager">资源管理（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2"><strong>安全</strong></td>
  <td x:str><a href="code/BasicFeature/Security/AppAccountManager">应用帐号管理</a></td>
  <td x:str><a href="code/BasicFeature/Security/Asset">关键资产存储</a></td>
  <td x:str><a href="code/BasicFeature/Security/CertManager">证书管理</a></td>
  <td x:str><a href="code/BasicFeature/Security/Cipher">加解密</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Security/CryptoFramework">通用密钥库系统（cryptoFramework）</a></td>
  <td x:str><a href="code/BasicFeature/Security/Huks">通用密钥库系统（huks）（API 10）</a></td>
  <td x:str><a href="code/BasicFeature/Security/PaySecurely">支付</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>任务管理</strong></td>
  <td x:str><a href="code/BasicFeature/TaskManagement/ContinuousTask">长时任务</a></td>
  <td x:str><a href="code/BasicFeature/TaskManagement/ReminderAgentManager">后台代理提醒</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>电话服务</strong></td>
  <td x:str><a href="code/BasicFeature/Telephony/Contact">联系人</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/MobileNetwork">蜂窝数据</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/Observer">网络和Sim卡状态订阅</a></td>
  <td x:str><a href="code/BasicFeature/Telephony/RadioTech">网络搜索</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/BasicFeature/Telephony/SimManager">SIM卡管理</a></td>
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
  <td x:str><strong>窗口</strong></td>
  <td x:str><a href="code/BasicFeature/Window/MediaFullScreen">视频全屏切换案例</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
<td height="90" align="center" rowspan="26" style='height:67.50pt;' x:str><strong>系统特性（仅对系统应用开放）</strong></td>
  <td x:str><strong>能力增强</strong></td>
  <td x:str><a href="code/SystemFeature/Ability/AbilityFeatureSystem">基础能力增强</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="3" x:str><strong>应用模型</strong></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/CustomShare">自定义分享（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/EmbeddedUIExtensionAbility">EmbeddedUIExtensionAbility</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/EnterpriseAdminExtensionAbility">企业设备管理扩展</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/UIExtensionAbility">UIExtensionAbility</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/ApplicationModels/Launcher">仿桌面应用（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/MissionManager">任务管理</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/StageModel">Stage模型（API10）</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/StaticSubscriber">静态订阅（API 10）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/ApplicationModels/TestRely/LauncherTest/CrossChainBack">跨任务链返回</a></td>
  <td x:str><a href="code/SystemFeature/ApplicationModels/TestRely/LauncherTest/StartRecentAbility">启动上一次的组件实例</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>自动填充</strong></td>
  <td x:str><a href="code/SystemFeature/AutoFill/AutoFill">AutoFill自动填充能力</a></td>
  <td x:str><a href="code/SystemFeature/AutoFill/AutoFillScenarioization">情景化自动填充能力</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>网络与连接</strong></td>
  <td x:str><a href="code/SystemFeature/Connectivity/Wlan">WLAN</a></td>
  <td x:str><a href="code/SystemFeature/Connectivity/Bluetooth">蓝牙</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>数据管理</strong></td>
  <td x:str><a href="code/SystemFeature/DataManagement/CrossAppDataShare">跨应用数据共享</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>设备管理</strong></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/DeviceManagementCollection">设备管理合集（API 11）</a></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/Mouse">鼠标外设（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/Screen">屏幕属性（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/DeviceManagement/StorageStatistic">存储空间统计（API 10）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>设备信息统计</strong></td>
  <td x:str><a href="code/SystemFeature/DeviceUsageStatistics/DeviceUsageStatistics">设备使用信息统计</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>分布式</strong></td>
  <td x:str><a href="code/SystemFeature/DistributedAppDev/DistributedAccount">分布式帐号（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/DistributedAppDev/DistributedAuthentication">分布式组网认证（API 10）</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>文件管理</strong></td>
  <td x:str><a href="code/SystemFeature/FileManagement/FileManager">文件管理（API 11）</a></td>
  <td x:str><a href="code/SystemFeature/FileManagement/FileShare/Picker">选择并查看文档与媒体文件（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/FileManagement/MediaCollections">媒体管理合集</a></td>
  <td x:str><a href="code/SystemFeature/FileManagement/Photos">相册（API 12）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>全屏启动原子化服务</strong></td>
  <td x:str><a href="code/SystemFeature/FullScreenStart/FullScreenStart">全屏启动原子化服务</a></td>
  <td x:str><a href="code/SystemFeature/FullScreenStart/FullScreenStart_Service">原子化服务</a></td>
  <td ></td>
  <td ></td>
 </tr>
  <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>IDL</strong></td>
  <td x:str><a href="code/SystemFeature/IDL/AbilityConnectServiceExtension">Ability与ServiceExtensionAbility通信</a></td>
  <td x:str></td>
  <td x:str></td>
  <td x:str></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>国际化</strong></td>
  <td x:str><a href="code/SystemFeature/Internationalnation/International">时区和语言设置（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="3" x:str><strong>媒体</strong></td>
  <td x:str><a href="code/SystemFeature/Media/AVSession/MediaController">媒体会话——控制方（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/Media/Audio">音频管理（仅对系统应用开放）</a></td>
  <td x:str><a href="code/SystemFeature/Media/Camera">相机和媒体库（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/Media/GamePuzzle">图片裁剪与分割</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/Media/MusicPlayer">折叠屏音乐播放器案例</a></td>
  <td x:str><a href="code/SystemFeature/Media/Recorder">录音机</a></td>
  <td x:str><a href="code/SystemFeature/Media/ScreenRecorder">录屏</a></td>
  <td x:str><a href="code/SystemFeature/Media/Screenshot">截屏</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/Media/VoiceCallDemo">音频通话示例（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>通知</strong></td>
  <td x:str><a href="code/SystemFeature/Notification/CustomNotificationPush">自定义通知推送（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/Notification/Publish">实况通知推送</a></td>
  <td x:str><a href="code/SystemFeature/Notification/Subscribe">通知发布订阅</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>资源配置</strong></td>
  <td x:str><a href="code/SystemFeature/ResourceAllocation/ApplicationThemeSwitch">应用主题切换</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>安全</strong></td>
  <td x:str><a href="code/SystemFeature/Security/AbilityAccessCtrl">应用访问权限控制</a></td>
  <td x:str><a href="code/SystemFeature/Security/AuthorizedButton">安全控件类型的UI控件（API 10）</a></td>
  <td x:str><a href="code/SystemFeature/Security/CertificateFramework">证书算法库框架</a></td>
  <td x:str><a href="code/SystemFeature/Security/DLP">DLP</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SystemFeature/Security/DLPManager">DLPManager</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>任务管理</strong></td>
  <td x:str><a href="code/SystemFeature/TaskManagement/Flybird">小鸟避障游戏</a></td>
  <td x:str><a href="code/SystemFeature/TaskManagement/TransientTask">短时任务</a></td>
  <td x:str><a href="code/SystemFeature/TaskManagement/WorkScheduler">延迟任务调度</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>电话服务</strong></td>
  <td x:str><a href="code/SystemFeature/Telephony/Message">短信</a></td>
  <td x:str><a href="code/SystemFeature/Telephony/Call">拨打电话</a></td>
  <td ></td>
 </tr>
<tr height="18" style='height:13.50pt;'>
  <td x:str><strong>基础能力增强</strong></td>
  <td x:str><a href="code/SystemFeature/UIExtensionSamples">基础能力增强</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>卡片</strong></td>
  <td x:str><a href="code/SystemFeature/Widget/FormExtAbility">Stage模型卡片</a></td>
  <td x:str><a href="code/SystemFeature/Widget/RequestAddForm">应用主动添加数据代理卡片到桌面</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>窗口管理</strong></td>
  <td x:str><a href="code/SystemFeature/WindowManagement/WindowExtAbility">窗口扩展</a></td>
  <td x:str><a href="code/SystemFeature/WindowManagement/WindowManage">窗口管理（API 12）</a></td>
  <td x:str><a href="code/SystemFeature/WindowManagement/WindowRatio">悬浮窗（API 10）</a></td>
  <td ></td>
 </tr>
  <td height="90" align="center" rowspan="9" style='height:67.50pt;' x:str><strong>关键特性</strong></td>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="3" x:str><strong>分布式</strong></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/ArkTSDistributedCalc">分布式计算器（API 14）</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/ArkTSDistributedMusicPlayer">ArkTS分布式音乐播放</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributeCalc">JS分布式计算器（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedFilemanager">分布式文件管理</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedJotNote">跨端迁移随手记</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedNote">分布式对象（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/JsDistributedMusicPlayer">JS分布式音乐播放（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/DistributedRdb">分布式关系型数据库（API 10）</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/DistributedAppDev/Kvstore">分布式数据管理</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
  <td rowspan="3" x:str><strong>一次开发，多端部署</strong></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/AdaptiveCapabilities">ArkTS一多能力集合（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/AppMarket">典型页面场景：应用市场首页</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/HealthyDiet">典型页面场景：健康饮食</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/JsAdaptiveCapabilities">JS一多能力集合</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/MultiColumns">典型页面场景：一多分栏控件（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/MultiMusic">典型页面场景：一多音乐典型场景</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/MultiNavBar">典型页面场景：一多导航栏（API 10）</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/MusicAlbum">典型页面场景：音乐专辑页</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/Settings">典型页面场景：设置应用页面</a></td>
  <td x:str><a href="code/SuperFeature/MultiDeviceAppDev/Weather">入门示例：天气应用</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" x:str><strong>卡片</strong></td>
  <td x:str><a href="code/SuperFeature/Widget/AdaptiveServiceWidget">JS多设备自适应服务卡片</a></td>
  <td x:str><a href="code/SuperFeature/Widget/ArkTSCard/Calculator">ArkTS卡片计算器</a></td>
  <td x:str><a href="code/SuperFeature/Widget/ArkTSCard/CanvasGame">ArkTS卡片Canvas小游戏</a></td>
  <td x:str><a href="code/SuperFeature/Widget/ArkTSCard/MusicControl">ArkTs音乐卡片</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><a href="code/SuperFeature/Widget/FormGame">Stage模型卡片JS与C++通信（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
  <td height="90" align="center" rowspan="8" style='height:67.50pt' x:str><strong>行业解决方案</strong></td>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>游戏</strong></td>
  <td x:str><a href="code/Solutions/Game/DistributedDataGobang">分布式五子棋</a></td>
  <td x:str><a href="code/Solutions/Game/Game2048">游戏2048</a></td>
  <td x:str><a href="code/Solutions/Game/Lottie">Lottie</a></td>
  <td ></td>
 </tr>
  <td x:str><strong>即时通信</strong></td>
  <td x:str><a href="code/Solutions/IM/Chat">聊天实例应用（API 10）</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>输入法</strong></td>
  <td x:str><a href="code/Solutions/InputMethod/CustomInputText">自绘编辑框（API 10）</a></td>
  <td x:str><a href="code/Solutions/InputMethod/KikaInput">轻量级输入法（API 10）</a></td>
  <td x:str><a href="code/Solutions/InputMethod/KikaInputMethod">Kika输入法应用（API 10）</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>媒体</strong></td>
  <td x:str><a href="code/Solutions/Media/MultiMedia">仿相机</a></td>
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
<tr height="18" style='height:13.50pt;'>
  <td x:str><strong>社交</strong></td>
  <td x:str><a href="code/Solutions/Social/GrapeSquare">葡萄广场</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>工具</strong></td>
  <td x:str><a href="code/Solutions/Tools/ArkTSClock">ArkTS时钟</a></td>
  <td x:str><a href="code/Solutions/Tools/FlipClock">翻页时钟</a></td>
  <td x:str><a href="code/Solutions/Tools/JsClock">JS时钟（API 10）</a></td>
  <td x:str><a href="code/Solutions/Tools/PatternLock">图案密码锁</a></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td height="54" align="center" rowspan="3" style='height:40.50pt' x:str><strong>工程能力</strong></td>
  <td x:str><strong>应用程序包</strong></td>
  <td x:str><a href="code/Project/ApplicationHap/MultiHap">多HAP</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>HapBuild</strong></td>
  <td x:str><a href="code/Project/HapBuild">流水线预测试工具</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td x:str><strong>Test</strong></td>
  <td x:str><a href="code/Project/Test">测试框架</a></td>
  <td ></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="1" align="center" x:str><strong>语言基础类库</strong></td>
  <td rowspan="1" x:str><strong>语言基础类库</strong></td>
  <td x:str><a href="code/LanguageBaseClassLibrary/ConcurrentModule">多线程任务</a></td>
  <td x:str><a href="code/LanguageBaseClassLibrary/LanguageBaseClassLibrary">语言基础类库（API 10）</a></td>
  <td x:str><a href="code/LanguageBaseClassLibrary/ZipLib">压缩与解压</a></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="2" align="center" x:str><strong>性能</strong></td>
  <td rowspan="1" x:str><strong>方舟运行时</strong></td>
  <td x:str><a href="code/Performance/ArkRuntime/NBody"> N-Body模拟程序（API 10）</a></td>
  <td x:str><a href="code/Performance/OperateRDBInTaskPool">在TaskPool线程中操作关系型数据库实现案例</a></td>
  <td ></td>
  <td ></td>
 </tr>
 <tr height="18" style='height:13.50pt;'>
  <td rowspan="1" x:str><strong>性能提升</strong></td>
  <td x:str><a href="code/Performance/PerformanceLibrary"> 性能示例 </a></td>
  <td x:str><a href="code/Performance/renderGroup"> 性能示例（renderGroup 接口）</a></td>
  <td ></td>
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
  |---ArkTsComponentCollection    # ArkTs组件集
  |---CalendarViewSwitch          # 日历视图切换
  |---CitySearch                  # 城市选择案例
  |---CustomAnimationTab          # 自定义动效tab
  |---DragAndExchange             # Grid和List内拖拽交换子组件位置
  |---ExpandTitle                 # 标题下拉缩放案例
  |---FoldableAdaptation          # Navigation实现折叠屏适配案例
  |---ImageViewer                 # 多图片预览效果实现
  |---Immersive                   # 沉浸式适配案例
  |---ImperativeDynamicLayouts    # 动态布局类框架
  |---KeyboardAvoid               # 组件随软键盘弹出避让
  |---ListBeExchange              # 列表项交换案例
  |---PageLoading                 # 页面加载效果实现案例
  |---PullToRefresh               # 下拉刷新与上滑加载案例
  |---SearchComponent             # 搜索功能实现案例
  |---TabContentTouchHotZone      # 触摸热区增大案例
  |---VerifyCode                  # 验证码布局
  |---WindowStartIcon             # 启动页实现案例
|---BasicFeature               # 基础特性
  |---Ability                      # 能力增强
  |---Ads                          # 广告
  |---ApplicationModels            # 应用模型
  |---Connectivity                 # 网络与连接
  |---DFX                          # DFX
  |---DataManagement               # 数据管理
  |---DeviceManagement             # 设备管理
  |---Extension                    # Extension
  |---FileManagement               # 文件管理
  |---Graphics                     # 图像
  |---International                # 国际化
  |---Media                        # 媒体
  |---Native                       # Native c++
  |---Notification                 # 通知
  |---Print                        # 打印
  |---Resource                     # 资源
  |---Security                     # 安全
  |---TaskManagement               # 任务管理
  |---Telephony                    # 电话服务
  |---Web                          # Web
  |---Window                       # 窗口
|---SystemFeature              # 系统特性
  |---Ability                      # 能力增强
  |---ApplicationModels            # 应用模型
  |---AutoFill                     # 自动填充
  |---Connectivity                 # 网络与连接
  |---DataManagement               # 数据管理
  |---DeviceManagement             # 设备管理
  |---DeviceUsageStatistics        # 设备使用信息
  |---DistributedAppDev            # 分布式
  |---FileManagement               # 文件管理
  |---FullScreenStart              # 全屏原子化服务
  |---IDL                          # IDL 
  |---Internationalnation          # 国际化
  |---Media                        # 媒体
  |---Notification                 # 通知
  |---ResourceAllocation           # 资源配置
  |---Security                     # 安全
  |---TaskManagement               # 任务管理
  |---Telephony                    # 电话服务
  |---UIExtensionSamples           # 基础能力增强
  |---Widget                       # 卡片
  |---WindowManagement             # 窗口管理
|---SuperFeature               # 关键特性
  |---DistributedAppDev            # 分布式
  |---MultiDeviceAppDev            # 一多
  |---Widget                       # 卡片
|---Solutions                  # 行业解决方案
  |---Game                         # 游戏
  |---IM                           # 即时通信
  |---InputMethod                  # 输入法
  |---Media                        # 媒体
  |---Shopping                     # 电商
  |---Social                       # 社交
  |---Tools                        # 工具
|---Project                    # 工程能力
  |---ApplicationHap               # 应用程序包
  |---HapBuild                     # 流水线预测试工具
  |---Test                         # 测试框架
|---LanguageBaseClassLibrary  # 语言基础类库
  |---ConcurrentModule             # 多线程任务
  |---LanguageBaseClassLibrary    # 语言基础类库
  |---ZipLib                       # 解压与压缩
|---Performance                # 性能
  |---ArkRuntime                   # 方舟运行时
  |---OperateRDBInTaskPool         # TaskPool线程中操作关系型数据库
  |---PerformanceLibrary           # 性能示例
  |---renderGroup                  # 性能示例
```

## 约束<a name="section18841871178"></a>

安装应用示例之前，请先查看"README_zh.md"文件来确认应用示例是否为stage模型，若为Stage模型需要查看entry/src/main路径下的module.json5文件中的"deviceType"字段来确认该应用支持的设备类型；否则为FA模型，查看entry/src/main路径下的config.json文件中的"deviceType"字段来确认该应用示例支持的设备类型，两种模型都可尝试通过修改该字段使其可以在相应类型的设备上运行。

## 使用方法<a name="section17988202503116"></a>

1. 将独立的应用示例工程导入DevEco Studio进行编译构建及运行调试。
2. 部分应用示例中含有多个模块，开发者可以选择对单个模块进行编译构建，生成一个HAP应用安装包，也可以对整个工程进行编译构建，生成多个HAP应用安装包。
3. 安装运行后，即可在设备上查看应用示例运行效果，以及进行相关调试。

## Changlog<a name="section17988202503117"></a>

应用修改记录：[changelog](changelog.md)

## releasenote

应用发布版本分支说明：[releasenote](releasenote.md)

## 相关仓<a name="section17988202503118"></a>

1. [app_sample](https://gitee.com/openharmony/app_samples) 已废弃
2. [applications_app_sample](https://gitee.com/openharmony/applications_app_samples)
