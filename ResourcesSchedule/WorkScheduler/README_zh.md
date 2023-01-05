# 延迟任务调度

### 介绍

本示例展示了延迟任务注册、取消能力的使用，使用**workScheduler**接口实现一个延迟任务调度。 

本示例使用[延迟任务调度接口](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-resourceschedule-workScheduler.md)，让开发者在开发应用时，通过调用延迟任务注册接口，注册对实时性要求不高的延迟任务，该任务默认由系统安排，在系统空闲时根据性能、功耗、热等情况进行调度执行。

使用说明：

1.点击**升级**按钮，注册延迟任务。

2.连接网络触发延迟任务回调，发送通知。

### 效果预览

![](./screenshots/device/notification.png) ![](./screenshots/device/index.png)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例仅支持API9版本SDK，版本号：3.2 Beta4。

3.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.992, built on July 14, 2022)才可编译运行。
