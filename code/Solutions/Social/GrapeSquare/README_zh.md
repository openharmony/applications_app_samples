# 葡萄广场

### 介绍

本示例是一个社交分享类APP，搭建了不同的页面向用户提供获取社交信息等能力。为了减少频繁权限弹窗对用户的干扰，同时提供更小的授权范围，使用了[安全控件](https://gitee.com/openharmony/applications_app_samples/tree/master/code/SystemFeature/Security/AuthorizedButton)做临时授权场景。当用户实际点击了某种类型的安全控件时，会由系统弹出相关通知弹窗，并对应用进行相应的临时授权。

### 效果预览

|                  Home                  |                    Location                    |                            Paste                            |
|:--------------------------------------:|:----------------------------------------------:|:-----------------------------------------------------------:|
| ![main](screenshots/devices/Home.jpeg) | ![location](screenshots/devices/Location.jpeg) |          ![paste](screenshots/devices/Paste.jpeg)           |
|                  Save                  |                        Notication                        |                        SameCrityPage                        |
| ![save](screenshots/devices/Save.jpeg) | ![notication](screenshots/devices/NotificationPage.jpeg) | ![sameCrityPage](screenshots/devices/SameCrityPage.jpeg) |

使用说明：

1. 启动应用进入广告动画界面，动画结束后进入应用，整个应用分为三个部分"主页"、"发现"、"我的"，可以通过底部导航进行页面间的切换。
2. "主页"可以查看各个用户发布的动态，点击任一图文可以进入动态详情界面。
3. "动态详情页"主要包括上下两部分，上部分主要展示用户发布的动态，可以包括文字、图片、视频，长按图片或视频会浮出"保存"按钮，点击后会弹出授权通知弹窗，点击"知道了"，可以通过安全控件中的保存控件将图片或者视频保存到图库当中。
4. "动态详情页"下部分展示用户的评论情况，点击底部"评论"按钮，在文本框中输入评论，长按文本框出现"复制 粘贴"按钮，点击"复制"按钮可以将选定信息写入剪贴板，点击"粘贴"按钮，可以通过安全控件中的粘贴控件从剪贴板中读取信息。
5. "发现"页面，点击"同城"按钮可以通过安全控件中的位置控件获取当前定位，点击后会弹出授权通知弹窗，点击"知道了"，会跳转到"同城榜"界面并显示当前定位城市。点击"发现"页面中的"全部"按钮可以跳转到"热搜榜"界面。
6. "热搜榜"、"我的"界面当前是静态页面。

### 工程目录

```
features/authorizedControl/src/main/ets             // 安全控件类HAR共享包
|---/authorizedControl    
|   |---LocationControl.ets                         // 位置控件            
|   |---PasteControl.ets                            // 粘贴控件
|   |---SaveControl.ets                             // 保存控件
|---/commonComponent
|   |---TrendsItem.ets                              // 单一动态组件         
|---/model
|   |---BaseMsg.ets                                 // 数据类型  
|   |---BasicDataSource.ets                         // 懒加载基本数据资源 
|   |---DataFactory.ets                             // 构造数据方法 
|   |---MockData.ets                                // 模拟数据  
|   |---TrendsDataSource.ets                        // 主页动态数据资源类  
|---/utils
|   |---Constants.ets                               // 封装常量
|   |---Logger.ets                                  // 封装日志类
|---/view
|   |---CommentDetailView.ets                       // 发现详情模块
|   |---MainView.ets                                // 主页模块
|   |---MineView.ets                                // 个人显示模块
|   |---SameCityListView.ets                        // 同城显示模块
|   |---SquareView.ets                              // 发现模块
|   |---TrendsDetailView.ets                        // 动态详情模块
products/phone/entry/src/main/ets
|---/entryability
|   |---EntryAbility.ts                             // Ability模块
|---/pages                                                               
|   |---AdvertisingPage.ets                         // 广告页面
|   |---CommentDetailPage.ets                       // 动态详情页面
|   |---HomePage.ets                                // 主页
|   |---SameCityListPage.ets                        // 同城页面
|---/utils
|   |---Constants.ets                               // 常量
|   |---Logger.ets                                  // 封装日志类
|   |---ResourceUtils.ets                           // 资源转换函数
```

### 具体实现
#### 安全控件的使用：
* 本示例安全控件的使用主要从图片和视频的保存、文本的复制和粘贴以及位置信息的获取三个模块体现：
  * 图片和视频的保存

    * 使用SaveButton控件保存图片或者视频到图库，首先点击保存按钮调用photoAccessHelper.getPhotoAccessHelper()得到媒体库图片管理器helper，
      然后通过helper.createAsset()方法得到媒体库图片的uri， resourceManager.getMediaContent()可以得到存放在Resources/base/media文件下的banner.png图片内容，
      使用fs.open()和fs.write()方法将图片内容通过得到的uri写到媒体库中，最后通过fs.close()方法关闭文件
    * 源码链接：[SaveControl.ets](feature/authorizedControl/src/main/ets/authorizedControl/SaveControl.ets)
    * 接口参考：[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-photoAccessHelper.md)，[@ohos.file.fs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fs.md#fsopen)
  
  * 文本的复制和粘贴

    * 使用PasteButton控件获取剪贴板信息，在其点击回调onclick事件中调用systemPasteboard.setData()方法将文本复制到剪贴板中，然后通过systemPasteboard.getData()方法得到剪贴板内容
    * 源码链接：[PasteButton.ets](feature/authorizedControl/src/main/ets/authorizedControl/PasteControl.ets)
    * 接口参考：[@ohos.pasteboard](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-pasteboard.md#getdata9)

  * 位置信息的获取
  
    * 使用LocationButton控件获取定位信息，在其点击回调onclick事件中调用geoLocationManager.getCurrentLocation()方法得到当前定位信息经纬度。
    * 源码链接：[LocationButton.ets](feature/authorizedControl/src/main/ets/authorizedControl/LocationControl.ets)
    * 接口参考：[@ohos.geoLocationManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-geoLocationManager.md#geolocationmanagergetcurrentlocation)

  
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：GPS定位功能仅支持部分机型。
2. 本示例仅支持API10版本SDK，SDK版本号(API Version 10 Release), 镜像版本号(4.0 Release)。
3. 本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Solutions/IM/GrapeSquare/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
