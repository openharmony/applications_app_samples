#  设备使用信息统计

### 介绍

本示例使用[bundleState](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-deviceUsageStatistics.md)相关接口完成设备中应用时长的统计功能。

使用说明：

1.顶部的数据面板展示了最常用的五个应用的使用时间占比情况。

2.中部的竖向滑动栏展示了每个应用的使用总时长和最后一次使用的时间。

3.底部的横向滑动栏展示了不常用应用列表。

### 效果预览

|主页|
|--------------------------------|
|![](screenshots/devices/main.png)|

### 相关权限

应用信息权限：[ohos.permission.BUNDLE_ACTIVE_INFO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

4.本示例涉及使用系统接口：queryBundleStateInfos()，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。

5.本示例所配置的权限为ohos.permission.BUNDLE_ACTIVE_INFO为system_basic级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2Beta/zh-cn/application-dev/security/hapsigntool-overview.md/))。