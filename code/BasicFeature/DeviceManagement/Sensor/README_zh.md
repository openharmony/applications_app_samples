# 传感器

### 介绍

本示例使用@ohos.sensor中的方向传感器相关接口，实现指南针的功能。

使用说明

转动设备，指针跟随转动，转动的角度为偏离正北方的角度，并在界面下方显示。

### 效果预览

![](./screenshots/device/sensor.png)

### 相关权限

[ohos.permission.VIBRATE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.打开应用后需要对传感器进行画8校准。

2.本示例仅支持在标准系统上运行。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上才可编译运行。

4.本示例需要特殊模块与特定传感器，目前该功能仅支持部分机型。

5.本示例仅支持API9版本SDK，版本号：3.2.10.6。