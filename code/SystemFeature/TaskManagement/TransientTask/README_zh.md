# 短时任务

### 介绍

本示例主要展示后台任务中的短时任务。

通过[@ohos.resourceschedule.backgroundTaskManager](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-backgroundtasks-kit/js-apis-resourceschedule-backgroundTaskManager.md)，[Timer](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/common/js-apis-timer.md) 等接口，实现应用退后台仍然可以计数的功能，展现短时任务的机制。

### 效果预览

|退后台前                                   |退后台一段时间在进前台                                |
|---------------------------------------|-------------------------------------|
|![image](screenshots/device/before.png) |![image](screenshots/device/after.png)|

使用说明

1.进入应用，点击申请短时任务按钮，点击开始计数按钮；

2.将应用退出到后台后关闭；

3.应用在后台一段时间（单次不超过3分钟、一天不超过10分钟）内，仍然可以进行计数；

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts                    
|---pages
|   |---Index.ets                            // 首页
|   |---Interval.ets                         // 定时计数
|   |---TitleBar.ets                         // 标题
|   |---TransientTaskDialog.ets              // 短时任务
|---util
|   |---Logger.ts                            // 日志工具
```
### 具体实现

* 该示例使用requestSuspendDelay方法申请短时任务，延迟挂起，setInterval方法进行计数，实现应用退后台仍然可以计数的功能。
* 源码链接：[Interval.ets](entry/src/main/ets/pages/Interval.ets)，[TransientTaskDialog.ets](entry/src/main/ets/pages/TransientTaskDialog.ets)
* 接口参考：[@ohos.resourceschedule.backgroundTaskManager](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-backgroundtasks-kit/js-apis-resourceschedule-backgroundTaskManager.md)，[timer](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/common/js-apis-timer.md)

### 相关权限

不涉及

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568；

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9；

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/TaskManagement/TransientTask/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master

```