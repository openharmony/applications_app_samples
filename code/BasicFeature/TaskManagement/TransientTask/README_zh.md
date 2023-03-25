# 长时任务与短时任务

### 介绍

本示例主要展示后台任务中的短时任务。通过[@ohos.resourceschedule.backgroundTaskManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-resourceschedule-backgroundTaskManager.md)，[@ohos.app.ability.quickFixManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-quickFixManager.md)等接口实现应用热更新的方式去展现短时任务机制。

### 效果预览

|首页更新前                                   |首页更新后                                |
|---------------------------------------|-------------------------------------|
|![image](screenshots/device/before.png) |![image](screenshots/device/after.png)|

使用说明

1.安装本应用之前，先编译好未签名的应用包，然后在终端执行工程里的脚本[b_sign_hap_release.bat](https://gitee.com/openharmony/applications_app_samples/blob/master/codeBasicFeature/TaskManagement/TransientTask/signature/material/b_sign_hap_release.bat)去生成签名的应用包，再将此签名应用包进行安装即可；

2.进入应用，点击检查更新按钮，点击弹出框更新按钮会进行下载补丁包；

3.将应用退出到后台后关闭；

4.再次进入应用，页面版本信息由3.1.7.5更新为3.2.8.3。

### 相关权限

[ohos.permission.INSTALL_BUNDLE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)
[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568；

2.本示例已适配API10版本SDK，版本号：4.0.5.1；

3.本示例仅支持模块化编译，在build-profile.json5文件的buildOption字段添加"compileMode": "esmodule"；

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)；

5.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)才可编译运行。