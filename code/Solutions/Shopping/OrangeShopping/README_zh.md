# 购物示例应用

### 介绍

本示例展示在进场时加载进场动画，整体使用**Tabs**容器设计应用框架，通过**TabContent**组件设置分页面，在子页面中绘制界面。通过Navigation完成页面之间的切换。在详情页中通过
**Video**组件加载视频资源，使用**CustomDialogController**弹窗选择位置信息，点击首页及购物车返回主页面。

本示例使用[Tabs容器](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md)
实现通过页签进行内容视图切换。使用[Navigation](https://gitee.com/openharmony/docs/blob/OpenHarmony-4.0-Beta2/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navigation.md#navigation)实现页面之间的切换。使用[自定义弹窗](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-methods-custom-dialog-box.md)
设置位置信息。使用[Swiper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-swiper.md)
组件实现页面展示图轮播。使用[Grid](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-list.md)
容器组件设置展示的商品信息。

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
├── feature/detailPageHsp/src/main              // 商品主页
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

### 相关概念

动效能力：动画应该尽可能减少冗余刷新，合理地使用[动效](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/animation_practice.md/)开发效率更高，可以获得更好的性能。

### 具体实现
Navigation相关的能力：NavPathStack路由转场，跨包引用Hsp,动态加载等能力[详见Navigation开发示例文章](docs/Navigation_zh.md) 。  
1.应用创建时进行必要的权限判断：在[app.json5](entry/src/main/ets/MainAbility/MainAbility.ts )
文件中对```"requestPermission"```对象进行权限匹配。如果有如果权限列表中有-1，说明用户拒绝了授权。

2.配置Module信息：

* 在[module.json5]( entry/src/main/module.json5 )文件中配置```"extensionAbilities"```字段
* 在```"requestPermissions"```标签中添加需要开的权限，例如使用相机拍摄照片和录制视频权限： "name": "
  ohos.permission.CAMERA"

**3.Navigation的使用：**
   [Navigation](https://gitee.com/openharmony/docs/blob/OpenHarmony-4.0-Beta2/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navigation.md#navigation)组件主要包含主页和内容页。主页由标题栏、内容区和工具栏组成，其中内容区默认首页显示导航内容(Navigation的子组件)
   或非首页显示(NavDestination的子组件)，首页和非首页通过路由进行切换。Navigation的路由切换的方式有两种，在API Version 9上，首页导航内容需要配合[NavRouter](https://gitee.com/openharmony/docs/blob/OpenHarmony-4.0-Beta2/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navrouter.md)组件实现页面路由，
   从API Version 10开始，首页推荐使用[NavPathStack](https://gitee.com/openharmony/docs/blob/OpenHarmony-4.0-Beta2/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navigation.md#navpathstack10)配合[NavDestination](https://gitee.com/openharmony/docs/blob/OpenHarmony-4.0-Beta2/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navdestination.md)属性进行页面路由。本次示例主要介绍NavPathStack的使用，如下步骤所示：
  * NavPathStack有两种路由切换方法，一种是pushPath，如主页---->设置页面，通过使用this.pageStack.pushPath({ name: 'SetPage' })进行跳转，源码参考[TitleBar.ets](feature/navigationHome/src/main/ets/components/home/TitleBar.ets)，
   另外一种是pushPathByName，如主页---->详情页面，通过使用this.pageStack.pushPathByName('DetailPage', item)进行跳转，其中item为需要传递的参数，源码参考[GoodsList.ets](feature/navigationHome/src/main/ets/components/good/GoodsList.ets)

  * NavPathStack支持pop、move、clear方法的使用；pop方法的作用是弹出路由栈栈顶元素，如首页进入商品详情页面，在详情页面使用this.pageStack.pop()方法返回到首页，clear方法的作用是清除栈中所有页面，
     如首页跳转到详情页面，详情页面再进入直播页面，在直播页面通过使用this.pageStack.clear()直接返回到首页。除此之外，还有popTo(回退路由栈到第一个名为name的NavDestination页面)、
     popToIndex(回退路由栈到index指定的NavDestination页面)、moveToTop(将第一个名为name的NavDestination页面移到栈顶)、moveIndexToTop(将index指定的NavDestination页面移到栈顶)方法,
     由于本示例暂时没有合适的按钮去承载这些功能，所以本示例未体现。

  * 路由栈信息,如下所示，源码参考[DetailPage.ets](feature/detailPageHsp/src/main/ets/main/DetailPage.ets);
      ```
      获取栈中所有NavDestination页面的名称：this.pageInfos.getAllPathName()
      获取index指定的NavDestination页面的参数信息：this.pageInfos.getParamByIndex(1)
      获取全部名为name的NavDestination页面的参数信息：this.pageInfos.getParamByName('pageTwo')
      获取全部名为name的NavDestination页面的位置索引：this.pageInfos.getIndexByName('pageOne')
      获取栈大小：this.pageInfos.size()
      ```
**4.动态加载的使用：** 

  * 定义需要被动态加载的组件DetailPage，本示例中组件加载使用搭配Navigation实现。源码参考[DetailPage.ets](feature/detailPageHsp/src/main/ets/main/DetailPage.ets)；
  * 定义一个DynamicLoader动态回调类作为容器，用来注册和调用动态加载函数。源码参考[DynamicLoader.ets](feature/navigationHome/src/main/ets/common/DynamicLoader.ets)；  
  * 将DetailPage组件用DetailPageLoader函数封装，当DetailPageLoader被调用时，会渲染DetailPage页面。源码参考[DetailPageLoader.ets](entry/src/main/ets/pages/DetailPageLoader.ets)；  
  * 在主页实现动态加载DetailPage的步骤如下：
  由于navDestination无法直接动态import组件（import是函数，组件中无法引用函数），此处采用声明@BuilderParam detailPageLoader函数，在点击时初始化此函数，此时navDestination中可以调用this.detailPageLoader()从而加载组件DetailPage。  

    a)主页Home中定义组件加载函数@BuilderParam detailPageLoader: () => void，用来承接await import异步导入detailPageLoader的结果。源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)，
     ```
     @BuilderParam detailPageLoader: () => void
     ```
    b)注册异步函数，点击时为detailPageLoader初始化,当满足key为DetailPage时，此时异步的加载DetailPageLoader，渲染DetailPage源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)，
    ```
    DynamicLoader.getInstance().register(
      async (key: string) => {
        if (key === "DetailPage") {
          let obj = await import("./DetailPageLoader")
          this.detailPageLoader = obj.DetailPageLoader;
        }
      }
    ```
    c) 定义NavDestination中动态加载函数，当存在跳转行为时，会调用此函数,源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)；
    ```
     PageMap(name: string, param: NavPathStack) {
       if (name === 'DetailPage') {
         this.detailPageLoader();
     })
    ```
    d)按钮触发点击函数，调用detailPageLoader，此时真正的初始化@BuilderParam detailPageLoader，并通过Navigation中PageMap动态加载组件DetailPage。,源码参考[GoodsList.ets](feature/navigationHome/src/main/ets/components/good/GoodsList.ets)，
    ```
    Column() // 首页goodsList组件
      .onClick(() => {
         // 动态加载组件
         DynamicLoader.getInstance().fire('DetailPage').then(()=>{
           this.active = true;
           this.pageStack.pushPathByName('DetailPage', item);
         })
      })
    ```
**5.hsp包的创建与使用：**
 本示例以创建detailPageHsp的hsp包为例，[Hsp包介绍及详细操作步骤](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/in-app-hsp.md/)   
  * 在根目录右键新创建module为Shared Library类型的hsp模块，并将模块命名为detailPageHsp并拖拽至feature文件夹下做包的统一管理；
  * 定义hsp出口：在创建后的hsp包内编写业务代码，并在index.ets中export组件。[源码参考](feature/detailPageHsp/Index.ets)；
  * 引用方hap如何使用hsp：通过在oh-package.json5文件中加入定义的hsp依赖。[源码参考](entry/oh-package.json5)；
 ```
  "dependencies": {
     "@ohos/details-page-hsp": "file:../feature/detailPageHsp",
   }
 ```
  * hap中使用：在组件中引入依赖。[源码参考](entry/src/main/ets/pages/Detail.ets)
 ```
 import { DetailPage } from '@ohos/details-page-hsp';
 ```
  * 编译时需选中detailPageHsp模块，在ide的工具栏中选择build-Make Module 'detailPageHsp'。  
  * 运行时，需要在运行模块处配置edit Configuration并勾选Deploy Multi Hap Packages进行混合编译，即可运行。[详细操作步骤](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/in-app-hsp.md/)

6.多屏监听：在首页加载时会通过mediaquery.matchMediaSync()监听当前屏幕尺寸curBp=[sm代表小屏，md代表中屏，lg代表大屏]
，并将当前值存储到Appstorage里，通过AppStorage.SetOrCreate('curBp', this.curBp)。

7.响应式渲染：通过全局的UI状态AppStorage存储，绑定了appstorage的数据会进行响应式屏幕尺寸渲染。

8.订阅购物车事件：以持久化方式订阅并接收事件回调，持续订阅发布事件。通过emitter.emit(addToShoppingCartId,
shoppingCartData)。[源码参考](feature/emitter/src/main/ets/components/feature/EmitterClass.ets) 。


### 相关权限

允许使用Internet网络: [ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioninternet)

允许应用控制马达振动：[ohos.permission.VIBRATE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionvibrate)

允许应用使用相机拍摄照片和录制视频：[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioncamera)

允许应用获取设备位置信息：[ohos.permission.LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionlocation)

允许应用在后台运行时获取设备位置信息：[ohos.permission.LOCATION_IN_BACKGROUND](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionlocation_in_background)

允许应用截取屏幕图像 ：[ohos.permission.CAPTURE_SCREEN ](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioncapture_screen)

允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionread_media)

允许应用访问用户媒体文件中的地理位置信息 ：[ohos.permission.MEDIA_LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionmedia_location)

允许应用读写用户外部存储中的媒体文件信息 ：[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionwrite_media)

### 依赖

[数据请求](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Connectivity/Http)
本示例的网络配置服务依赖此示例。

[位置服务](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/DeviceManagement/Location)
本示例的详情页中的位置服务功能依赖此示例。

[媒体库视频](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/VideoShow)
本示例的详情页中的视频功能依赖此示例。

[分享](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/ApplicationModels/CustomShare)
本示例的详情页中的分享功能依赖此示例。

[事件通知](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Notification/CustomNotification)
本示例详情页中的降价通知功能依赖此示例。

[扫一扫](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/QRCodeScan)
本示首页中的扫码功能依赖此示例。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco
Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

5.本示例需联网运行。

6.弹窗升级需配置服务器后触发。

7.本示例所配置的权限ohos.permission.CAPTURE_SCREEN为system_core级别(
相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)
查看)，需要手动配置对应级别的权限签名(
具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/)。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Solutions/Shopping/OrangeShopping/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````