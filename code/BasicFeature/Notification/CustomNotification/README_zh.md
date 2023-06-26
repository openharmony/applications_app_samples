# 自定义通知

### 介绍

本示例使用[@ohos.notification](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-notification.md)等接口，展示了如何初始化不同类型通知的通知内容以及通知的发布、取消，包括基本类型、长文本类型、多行文本类型、图片类型、带按钮的通知、点击可跳转到应用的通知。

### 效果预览：

| 首页                                                         | 通知列表1                                                    | 通知列表2                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img alt="home" height="640" src="screenshots/zh/home.png" width="360"/> | <img alt="notifications" height="640" src="screenshots/zh/notifications.png" width="360"/> | <img alt="notifications_expanded" height="640" src="screenshots/zh/notifications_expanded.png" width="360"/> |

使用说明

1.启动应用后，弹出是否允许发送通知的弹窗，点击允许后开始操作；

2.点击界面中对应的按钮发布不同类型的通知，下拉状态栏，在通知栏可以看到发布的通知；

3.打开提示音和震动效果开关后，再点击对应按钮发布不同类型的通知，在通知的同时会伴有提示音或震动效果；

4.点击取消所有通知，可以取消本应用发布的所有通知；


### 工程目录
```
entry/src/main/ets/
|---Application
|---feature
|   |---NotificationOperations.ets           // 对外提供发布通知的接口
|---MainAbility
|---pages
|   |---Index.ets                            // 首页
entry/src/ohosTest/ets/
|---test
|   |---Index.test.ets                       // 首页的自动化测试    
notification/src/main/ets/
|---notification
|   |---NotificationContentUtil.ets          // 封装各种通知的主体内容
|   |---NotificationRequestUtil.ets          // 接收通知的主体内容，返回完整的通知
|   |---NotificationUtil.ets                 // 封装允许发布通知、发布通知、关闭通知的接口
|   |---WantAgentUtil.ets                    // 封装wantAgent
|---util                                     // 日志文件
```

### 具体实现

* 允许发送通知、发送通知、取消通知的功能接口封装在NotificationUtil，源码参考：[NotificationUtil.ets](notification/src/main/ets/notification/NotificationUtil.ets)
  * 允许发送通知：在进入[Index.ets](entry/src/main/ets/pages/Index.ets)
    前通过notificationUtil.enableNotification()调用notification.requestEnableNotification()接口向用户请求发送通知；
  * 发送通知：通过publishNotification()封装发布通知的接口；
  * 取消通知：在[Index.ets](entry/src/main/ets/pages/Index.ets)
    页面中通过点击事件调用cancelAllNotifications()取消所有的通知或者通过cancelNotificationById()取消指定id的通知；

* NotificationOperations向外提供接口，在页面中调用它们来实现功能，源码参考：[NotificationOperations.ets](entry/src/main/ets/feature/NotificationOperations.ets)
  * 发布通知：在[Index.ets](entry/src/main/ets/pages/Index.ets)
    页面中通过点击事件调用NotificationOperations中封装的对应的方法，然后从NotificationContentUtil中获取对应的主体内容content，将
    content传递给NotificationRequestUtil得到完整的发布信息，最后调用NotificationUtil.publishNotification()发布内容；

* 播放提示音、马达震动的功能在NotificationUtil调用发布通知的接口处进行判断是否开启，源码参考：[NotificationOperations.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomNotification/entry/src/main/ets/feature/NotificationOperations.ets)
  * 发布通知：在[Index.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomNotification/entry/src/main/ets/pages/Index.ets)
    通过publishNotification()封装发布通知的接口的同时，根据NotificationUtil类中对应变量的值判断是否开启了提示音或马达，若已开启，则执行对应代码段；
  * 控制提示音或马达的开关：在[Index.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/Notification/CustomNotification/entry/src/main/ets/pages/Index.ets)
    通过调用NotificationUtil类两个方法对NotificationUtil类中对应变量进行更改，开启为true，关闭为false；
* 自动化测试，对应用接口或系统接口进行单元测试，并且对基于UI操作进行UI自动化测试
  * 模拟点击：在Index.test.ets
    的beforeAll中调用startAbility()拉起应用并进入首页，然后通过Driver的assertComponentExist、findComponent和findWindow等获取到对应组件的位置，最后通过click()模拟出人工点击对应组件的效果；
  * 模拟各种操作流程：在Index.test.ets
    的每个it里面，按一定逻辑顺序排好点击组件的顺序，从而模拟出人为操作的过程，最终，所有的it组成了整一个应用的自动化测试。

### 相关权限

1.调用马达需要应用权限，ohos.permission.VIBRATE：允许应用控制马达振动，权限级别为normal，授权方式为system_grant，ACL使能为TRUE

### 依赖

1.大禹200的板子上没有马达，需要手动自己安装一个，购买链接：https://item.szlcsc.com/2787125.html

###  约束与限制

1.本示例仅支持标准系统上运行。

2.本示例需自行使用工具签名。

3.本示例仅支持API10版本SDK，版本号：4.0.7.5，镜像版本号：Openharmony 4.0.7.5。

4.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on May 18, 2023)编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Notification/CustomNotification/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
