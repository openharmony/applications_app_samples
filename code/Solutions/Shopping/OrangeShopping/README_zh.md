# 购物示例应用

### 介绍

本实例展示在进场时加载进场动画，整体使用**Tabs**容器设计应用框架，通过**TabContent**组件设置分页面，在子页面中绘制界面。在详情页中通过**Video**组件加载视频资源，使用**CustomDialogController**弹窗选择位置信息，点击首页及购物车返回主页面。

本实例使用[Tabs容器](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md)实现通过页签进行内容视图切换。使用[自定义弹窗](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-methods-custom-dialog-box.md)设置位置信息。使用[Swiper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-swiper.md)组件实现页面展示图轮播。使用[Grid](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-list.md)容器组件设置展示的商品信息。

使用说明：

1、启动应用进入进场动画，然后进入首页的时候会有升级弹窗的提示，判断应用需不需要升级，整个应用分四部分，首页、新品、购物车、我的。可以点击进行切换。

2、“首页”页面具有扫一扫功能、搜索框、轮播图、tabs、商品列表。

3、“首页”页面的扫一扫点击可以进行二维码扫描，点击商品可以跳转到详情页。

4、“商品详情页”上部分是视频，点击视频进行播放，也可以点击进入全屏模式，向下滑动详情页视频可以变成小窗口模式。点击右侧悬浮的直播按钮，可进入直播页面，直播页面可进行视频播放。

5.“商品详情页”有个分享功能，点击可进行分享。点击选择收货地址可弹出选择地址的选项，可进行选择地址。

6.断开网络链接，“商品详情页”中点击降价通知后，重新连接网络后通知栏有降价通知。

6.新品、购物车、我的目前是静态页面。

效果预览：

![](screenshots/device/shopping.gif)

### 相关权限

允许使用Internet网络: [ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

允许应用控制马达振动：[ohos.permission.VIBRATE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

允许应用使用相机拍摄照片和录制视频：[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

允许应用获取设备位置信息：[ohos.permission.LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

允许应用在后台运行时获取设备位置信息：[ohos.permission.LOCATION_IN_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

 允许应用截取屏幕图像 ：[ohos.permission.CAPTURE_SCREEN ](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

 允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

 允许应用访问用户媒体文件中的地理位置信息 ：[ohos.permission.MEDIA_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

 允许应用读写用户外部存储中的媒体文件信息  ：[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

[转场动画](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/TransitionAnimation) 本示例的进场动画依赖此示例。

[数据请求](https://gitee.com/openharmony/app_samples/tree/master/Network/Http) 本示例的网络配置服务依赖此示例。

[位置服务](https://gitee.com/openharmony/app_samples/tree/master/device/Location) 本示例的详情页中的位置服务功能依赖此示例。

[自定义弹窗](https://gitee.com/openharmony/app_samples/tree/master/ETSUI/UpgradePopup) 本示例的升级弹窗功能依赖此示例。

[媒体库视频](https://gitee.com/openharmony/app_samples/tree/master/media/VideoShow) 本示例的详情页中的视频功能依赖此示例。

[分享](https://gitee.com/openharmony/applications_app_samples/tree/master/Share/Share) 本示例的详情页中的分享功能依赖此示例。

[事件通知](https://gitee.com/openharmony/applications_app_samples/tree/master/Ntification/CustomNotification) 本示例详情页中的降价通知功能依赖此示例。

[扫一扫](https://gitee.com/openharmony/applications_app_samples/tree/master/media/QRCodeScan) 本示首页中的扫码功能依赖此示例。

### 约束与限制
1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。

5.本示例需联网运行。

6.弹窗升级需配置服务器后触发。

