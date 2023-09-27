# 购物示例应用

### 介绍

本示例展示在进场时加载进场动画，整体使用**Tabs**容器设计应用框架，通过**TabContent**组件设置分页面，在子页面中绘制界面。在详情页中通过**Video**组件加载视频资源，使用**CustomDialogController**弹窗选择位置信息，点击首页及购物车返回主页面。

本示例使用[Tabs容器](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md) 实现通过页签进行内容视图切换。使用[自定义弹窗](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-methods-custom-dialog-box.md) 设置位置信息。使用[Swiper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-swiper.md) 组件实现页面展示图轮播。使用[Grid](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-list.md) 容器组件设置展示的商品信息。  

本示例用到了延迟任务回调能力接口[@ohos.WorkSchedulerExtensionAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-WorkSchedulerExtensionAbility.md) 。  

通知管理的能力接口[@ohos.notification](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-notification.md) 。

HTTP数据请求能力接口[@ohos.net.http]( https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-http.md) 。  

媒体查询接口[@system.mediaquery](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-system-mediaquery.md) 。  

管理窗口能力接口[@ohos.window](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-window.md) 。

### 效果预览
![](screenshots/device/shopping.gif)

使用说明：

1、启动应用进入进场动画，然后进入首页的时候会有升级弹窗的提示，判断应用需不需要升级，整个应用分四部分，首页、新品、购物车、我的。可以点击进行切换。

2、“首页”页面具有扫一扫功能、搜索框、轮播图、tabs、商品列表。

3、“首页”页面的扫一扫点击可以进行二维码扫描，点击商品可以跳转到详情页。

4、“商品详情页”上部分是视频，点击视频进行播放，也可以点击进入全屏模式，向下滑动详情页视频可以变成小窗口模式。点击右侧悬浮的直播按钮，可进入直播页面，直播页面可进行视频播放。

5.“商品详情页”有个分享功能，点击可进行分享。点击选择收货地址可弹出选择地址的选项，可进行选择地址。

6.断开网络链接，“商品详情页”中点击降价通知后，重新连接网络后通知栏有降价通知。

7.新品、购物车、我的目前是静态页面。

### 工程目录

```
OrangeShopping
├── AppScope                                    
│   └── app.json5                               // APP信息配置文件
├── entry/src/main                              // 商品主页
│   ├── ets
│   │   ├── Application
│   │   ├── Mainmability                        // 应用入口，在应用创建时进行必要的权限判断
│   │   ├── pages
│   │   │   ├── Index.ets                       // 首页的入口，首页加载页面(可点击跳过)
│   │   │   ├── Detail.ets                      // 商品详情页
│   │   │   ├── FullPage.ets                    // 商品详情页内的视频组件
│   │   │   ├── Home.ets                        // 首页
│   │   │   ├── LivePage.ets                    // 直播页
│   │   │   ├── ScanPage.ets                    // 二维码扫描组件
│   │   │   └── Setting.ets                     // 封装http请求页   
│   │   ├── utils
│   │   │   ├── RouterUtil.ets                  // 路由跳转配置
│   │   └── WorkAbility
│   │       └── WorkAbility.ts
│   ├── module.json5                            // Module的基本配置信息,应用运行过程中所需的权限信息。
│   ├── resources/base
│   │   ├── element                             // 文字信息列表
│   │   ├── profile                             // 全局路由配置
│   │   └── media                               // icon图片
├── feature/detailPage/src/main                 // 商品主页
│   ├── ets
│   │   ├── mock                                // mock的数据
│   │   ├── components                          // 组件模块
│   │   └── main                                // 商品详情页模块
├── feature/emitter/src/main                    
│   ├── ets
│   │   └── components                          // 订阅购物车模块
├── feature/navigationHome/src/main             
│   ├── ets
│   │   ├── good                                // 商品模块
│   │   ├── home                                // 首页模块
│   │   ├── user                                // 用户模块
│   │   └── shoppingCart                        // 商品购物车模块
```

### 具体实现

1.应用创建时进行必要的权限判断：在[app.json5](entry/src/main/ets/MainAbility/MainAbility.ts )文件中对```"requestPermission"```对象进行权限匹配。如果有如果权限列表中有-1，说明用户拒绝了授权。

2.配置Module信息：

* 在[module.json5]( entry/src/main/module.json5 )文件中配置```"extensionAbilities"```字段
* 在```"requestPermissions"```标签中添加需要开的权限，例如使用相机拍摄照片和录制视频权限： "name": "ohos.permission.CAMERA"

3.页面跳转: 通过在profile/main_pages.json中先配置好相关路由，并通过router.push()进行页面跳转,例如：跳转到搜索页面router.push({ url: 'pages/Detail' })。

4.多屏监听：在首页加载时会通过mediaquery.matchMediaSync()监听当前屏幕尺寸curBp=[sm代表小屏，md代表中屏，lg代表大屏]，并将当前值存储到Appstorage里，通过AppStorage.SetOrCreate('curBp', this.curBp)。

5.响应式渲染：通过全局的UI状态AppStorage存储，绑定了appstorage的数据会进行响应式屏幕尺寸渲染。  

6.订阅购物车事件：以持久化方式订阅并接收事件回调，持续订阅发布事件。通过emitter.emit(addToShoppingCartId, shoppingCartData)。[源码参考](feature/emitter/src/main/ets/components/feature/EmitterClass.ets) 。




### 相关权限

允许使用Internet网络: [ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioninternet)

允许应用控制马达振动：[ohos.permission.VIBRATE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionvibrate)

允许应用使用相机拍摄照片和录制视频：[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioncamera)

允许应用获取设备位置信息：[ohos.permission.LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionlocation)

允许应用在后台运行时获取设备位置信息：[ohos.permission.LOCATION_IN_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionlocation_in_background)

允许应用截取屏幕图像 ：[ohos.permission.CAPTURE_SCREEN ](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioncapture_screen)

允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionread_media)

允许应用访问用户媒体文件中的地理位置信息 ：[ohos.permission.MEDIA_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionmedia_location)

允许应用读写用户外部存储中的媒体文件信息  ：[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionwrite_media)

### 依赖

[数据请求](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Connectivity/Http) 本示例的网络配置服务依赖此示例。

[位置服务](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/DeviceManagement/Location) 本示例的详情页中的位置服务功能依赖此示例。

[媒体库视频](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/VideoShow) 本示例的详情页中的视频功能依赖此示例。

[分享](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/ApplicationModels/CustomShare) 本示例的详情页中的分享功能依赖此示例。

[事件通知](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Notification/CustomNotification) 本示例详情页中的降价通知功能依赖此示例。

[扫一扫](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/QRCodeScan) 本示首页中的扫码功能依赖此示例。

### 约束与限制
1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

5.本示例需联网运行。

6.弹窗升级需配置服务器后触发。

7.本示例所配置的权限ohos.permission.CAPTURE_SCREEN为system_core级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/)。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Solutions/Shopping/OrangeShopping/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````