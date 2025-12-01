# 通知订阅扩展能力概述

### 介绍

[NotificationSubscriberExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationSubscriberExtensionAbility.md)提供扩展能力，允许第三方应用接收系统通知并将其同步到穿戴设备。该能力主要用于支持手机与第三方穿戴设备之间的通知协同。

### 效果预览	
<img src="screenshots/Index.png" style="width: 200%; max-width: 400px;" />
 
使用说明

1.启动应用后，弹出是否允许访问蓝牙的弹窗，点击允许后开始操作。

2.点击主页面openSubscriberSettings按钮，调用openSubscriptionSettings接口，打开通知扩展订阅设置页面，该页面以半模态弹窗显示。

3.点击主页面queryBluetooth按钮，获取已蓝牙配对设备信息。

4.连接穿戴设备，使用蓝牙模块接口获取地址，通过subscribe/unsubscribe按钮调用接口订阅或取消订阅通知。
 
### 工程目录

```
entry/src/main/ets
|--- entryability
|   |--- EntryAbility.ets
|--- extensionability
|   |--- NotificationSubscriberExtAbility.ets  // 通知订阅扩展能力
|--- pages
|   |--- Index.ets                             // 主页面
|--- utils
|   |--- SppClientManager.ets                  // 蓝牙模块接口能力
```

### 相关权限

[ohos.permission.SUBSCRIBE_NOTIFICATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/restricted-permissions.md#ohospermissionsubscribe_notification)

[ohos.permission.ACCESS_BLUETOOTH](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionaccess_bluetooth)

### 具体实现
- 通知订阅扩展能力封装在NotificationSubscriberExtAbility中，源码参考：[NotificationSubscriberExtAbility.ets](entry/src/main/ets/extensionability/NotificationSubscriberExtAbility.ets)
    * 收到通知后，通过[SppClientManager](entry/src/main/ets/utils/SppClientManager.ets)将notificationInfo序列化并发送到对端蓝牙设备；发送前若通道未就绪，先触发startConnect 并等待 3 s 握手完成，失败自动再重连一次。
    * 通知被取消时，将hashCodes数组封装后调用sendCancelNotificationData，异常捕获后同收到通知逻辑，再次调用sendCancelNotificationData方法。
    * 能力销毁时onDestroy 中统一 stopConnect，防止蓝牙句柄泄漏。
- 连接地址动态获取：
    * 通过 getSubscribeInfo 读取订阅信息，取首条记录的 addr 字段作为对端地址；后续重连均沿用该值。

### 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：手机和平板。
2. 本示例为Stage模型，支持API22版本SDK，版本号：6.0.2.54；
3. 本示例需要使用DevEco Studio 6.0.0 beta5 版本及以上版本(Build Version: 6.0.0.848, built on September 12, 2025)才可编译运行；
4. 本示例涉及[ohos.permission.SUBSCRIBE_NOTIFICATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/restricted-permissions.md#ohospermissionsubscribe_notification)权限为system_core级别，需要配置高权限签名；

### 下载
```shell
git init
git config core.sparsecheckout true
echo code/DocsSample/Notification/ThirdpartyWerableDemo/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```