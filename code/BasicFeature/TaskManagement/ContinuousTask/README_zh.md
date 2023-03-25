# 长时任务

### 介绍

本示例展示后台任务的长时任务。通过使用[@ohos.resourceschedule.backgroundTaskManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-resourceschedule-backgroundTaskManager.md)实现后台播放音乐时避免进入挂起（Suspend）状态。

### 效果预览

|进入长时任务                                    |退出长时任务                                |
|---------------------------------------|-------------------------------------|
|![image](screenshots/device/start.png) |![image](screenshots/device/stop.png)|

使用说明

场景一：后台播放音乐

1.进入应用，点击播放，退出音乐界面推送至后台执行，当任务在后台开始执行时下拉菜单栏会有通知提醒；

2.再次进入应用，音乐播放进度条显示正常；

3.点击暂停播放，取消长时任务。

### 相关权限

[ohos.permission.KEEP_BACKGROUND_RUNNING](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备：RK3568；

2.本示例已适配API10版本SDK，版本号：4.0.5.1；

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。