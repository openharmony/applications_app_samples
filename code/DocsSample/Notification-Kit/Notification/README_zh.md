# Notification Kit（用户通知服务）

### 介绍

本示例展示了在一个Stage模型中，开发者可借助[Notification Kit（用户通知服务）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/Readme-CN.md)将应用产生的通知直接在客户端本地推送给用户，本地通知根据通知类型及发布场景会产生对应的铃声、震动、横幅、锁屏、息屏、通知栏提醒和显示


### 效果预览

| 项目主界面                    | 弹窗通知授权                        | 半模态弹窗授权                     |
|----------------------------|----------------------------|----------------------------|
| ![image](screenshot/mainInterface.png) | ![image](screenshot/requestNotificationDialog.png) | ![image](screenshot/requestNotificationSetting.png) |


| 增加角标         | 减少角标个数                        |
|----------------------------|----------------------------|
| ![image](screenshot/addBadges.png) | ![image](screenshot/reduceBadges.png) |


| 发布普通类型文本通知                 | 发布多行文本类型通知                 | 发布进度条类型通知                  |
|----------------------------|----------------------------|----------------------------|
| ![image](screenshot/plaintextNotification.png) | ![image](screenshot/multLinesTextNotification.png) | ![image](screenshot/progressTextNotification.png) |


| 更新进度条类型通知                  | 取消单行文本类型通知                  |
|----------------------------|-----------------------------|
| ![image](screenshot/updateProgressNotification.png) | ![image](screenshot/cancelPlaintextNotification.png) |

### 使用说明

1. [请求通知授权](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-enable.md)，应用需要获取用户授权才能发送通知。

2. [管理通知角标](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-badge.md)，针对未读的通知，系统提供了角标设置接口，将未读通知个数显示在桌面图标的右上角角标上。 通知增加时，角标上显示的未读通知个数需要增加。 通知被查看后，角标上显示的未读通知个数需要减少，没有未读通知时，不显示角标。

3. [管理通知渠道](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-slot.md)，系统支持多种通知渠道，不同通知渠道对应的通知提醒方式不同，可以根据应用的实际场景选择适合的通知渠道，并对通知渠道进行管理（支持创建、查询、删除等操作）。

4. 发布通知
   * [发布文本类型通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/text-notification.md)，文本类型通知主要应用于发送短信息、提示信息等，支持普通文本类型和多行文本类型。
   * [发布进度条类型通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/progress-bar-notification.md)，进度条通知也是常见的通知类型，主要应用于文件下载、事务处理进度显示。当前系统提供了进度条模板，发布通知应用设置好进度条模板的属性值，如模板名、模板数据，通过通知子系统发送到通知栏显示。
   * [为通知添加行为意图](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-with-wantagent.md)，应用向Ability Kit申请WantAgent，并将WantAgent封装至通知中。当发布通知时，用户便可以通过点击通知栏中的消息或按钮，拉起目标应用组件或发布公共事件。

5. [更新通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-update.md)，更新已发布的通知。主要用于上传下载进度更新、IM会话消息更新等场景。

6. [取消通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-cancel.md)，用户收到通知提醒后，点击通知并拉起应用到前台时，应用可以选择取消某条通知或所有通知。

7. [跨设备协同通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-distributed-overview.md)，跨设备协同通知旨在以手机为中枢，实现与手表等其它设备的通知消息协同交互。

8. [清除跨设备场景下的重复通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-distributed-messageid.md)，从API version 20开始，为了避免不同渠道发布的通知重复打扰用户（例如，手机协同到当前设备的通知与Push推送服务发布的通知重复），可以使用通知去重功能，清除跨设备场景下的重复通知。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   │   └── EntryAbility.ets
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets
│   │   ├── pages
│   │   │   ├── AddWantAgent.ets
│   │   │   ├── CancelNotification.ets
│   │   │   ├── ClearDuplicateNotifications.ets
│   │   │   ├── Index.ets
│   │   │   ├── ManageNotificationBadges.ets
│   │   │   ├── ManageNotificationWays.ets
│   │   │   ├── PublishNotification.ets
│   │   │   ├── RequestEnableNotification.ets
│   │   │   └── UpdateNotification.ets
│   ├── module.json5
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets  // 自动化测试代码
            └── List.test.ets    // 测试套执行列表
```

### 具体实现

* 请求通知授权，在通知发布前调用[requestEnableNotification()](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md#notificationmanagerrequestenablenotification10-1)接口，弹窗让用户选择是否允许发送通知。当用户拒绝授权后，将无法通过该接口再次拉起弹窗。如果应用需要向用户再次申请通知授权，则可以使用[openNotificationSettings](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md#notificationmanageropennotificationsettings13)接口拉起通知管理半模态弹窗。详情可参见[请求通知授权](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-enable.md)。
* 管理通知角标，其中增加角标数支持两种方法，第一种是发布通知时，在[NotificationRequest](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-inner-notification-notificationRequest.md#notificationrequest-1)的badgeNumber字段里携带，桌面收到通知后，在原角标数上累加、呈现，第二种是调用接口[setBadgeNumber()](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md#notificationmanagersetbadgenumber10)设置，桌面按设置的角标数呈现。而减少角标数，目前仅支持通过setBadgeNumber()设置。详情可参见[管理通知角标](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-badge.md)。
* 管理通知渠道，可以使用addSlot()创建通知渠道，还可以在发布通知的NotificationRequest中携带notificationSlotType字段，如果对应渠道不存在，会自动创建。其它接口介绍详情参见相关[API文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md)。详情可参见[管理通知渠道](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-slot.md)。
* 发布文本类型通知，通知发布接口publish()详情参见相关[API文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md)。通知发布的详情可通过入参[NotificationRequest](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-inner-notification-notificationRequest.md#notificationrequest-1)来进行指定，可以包括通知内容、通知ID、通知的通道类型和通知发布时间等信息。其中文本类型有两种：第一种为NOTIFICATION_CONTENT_BASIC_TEXT普通文本类型，第二种为NOTIFICATION_CONTENT_MULTILINE多行文本类型。详情可参见[发布文本类型通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/text-notification.md)。
* 发布进度条类型通知，目前系统模板仅支持进度条模板，首先通过[isSupportTemplate()](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-notificationManager.md#notificationmanagerissupporttemplate)查询模板是否支持接口，目前仅支持进度条模板。构造进度条模板，name字段当前需要固定配置为downloadTemplate。详情可参见[发布进度条类型通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/progress-bar-notification.md)。
* 为通知添加行为意图，首先创建[WantAgentInfo](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-inner-wantAgent-wantAgentInfo.md)信息，然后调用[getWantAgent()](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-wantAgent.md#wantagentgetwantagent)方法进行创建WantAgent，最后构造NotificationRequest对象，并发布携带WantAgent的通知。详情可参见[为通知添加行为意图](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-with-wantagent.md)。
* 更新通知，通知更新可通过入参[NotificationRequest](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-inner-notification-notificationRequest.md#notificationrequest-1)携带updateOnly字段来指定，不指定该字段默认为false。当updateOnly为true时，若相同ID通知存在，则更新通知；若相同ID通知不存在，则更新失败，不创建新的通知。当updateOnly为false时，若相同ID通知存在，则更新通知；若相同ID通知不存在，则创建通知。详情可参见[更新通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-update.md)。
* 取消通知，首先发布通知，参考[发布文本类型通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/text-notification.md)，然后取消通知，其中通知取消有两种方法，第一种是调用cancel()取消指定的通知，第二种是调用cancelAll()取消所有该应用发布的通知。详情可参见[取消通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-cancel.md)。
* 清除跨设备场景下的重复通知，应用发送通知时携带唯一标识字段[appMessageId](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-notification-kit/js-apis-inner-notification-notificationRequest.md#notificationrequest-1)，分布式通知接收到多渠道发布的通知后，会根据该字段进行判断，从而实现通知去重。详情可参见[清除跨设备场景下的重复通知](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/notification/notification-distributed-messageid.md)。


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568；
2. 本示例支持API20版本SDK，版本号：6.0.0.47；
3. 本示例已支持使DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2025年11月11日)编译运行；
4. 高等级APL特殊签名说明：无；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Notification-Kit/Notification > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```