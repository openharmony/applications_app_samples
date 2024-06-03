# 短时任务

### 介绍

本示例主要展示后台任务中的短时任务。

通过[@ohos.resourceschedule.backgroundTaskManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-backgroundtasks-kit/js-apis-resourceschedule-backgroundTaskManager-sys.md) ，[@ohos.app.ability.quickFixManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-quickFixManager-sys.md) 等接口实现应用热更新的方式去展现短时任务机制。

### 效果预览

|首页更新前                                   |首页更新后                                |
|---------------------------------------|-------------------------------------|
|![image](screenshots/device/before.png) |![image](screenshots/device/after.png)|

使用说明

1.安装本应用之前，先编译好未签名的应用包，然后在终端执行工程里的脚本[b_sign_hap_release.bat](signature/material/b_sign_hap_release.bat) 去生成签名的应用包，再将此签名应用包进行安装即可；

2.进入应用，点击检查更新按钮，点击弹出框更新按钮会进行下载补丁包；

3.将应用退出到后台后关闭；

4.再次进入应用，页面版本信息由3.1.7.5更新为3.2.8.3；

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts                    
|---feature
|   |---LoadFile.ts                          // 文件加载
|   |---SaveFile.ts                          // 文件保存
|---MainAbility
|   |---MainAbility.ts                       // 短时任务
|---pages
|   |---Index.ets                            // 首页
|   |---TitleBar.ets                         // 标题
|   |---UpdateDialog.ets                     // 检查更新
|---util
|   |---Logger.ts                            // 日志工具
```
### 具体实现

* 该示例使用cancelSuspendDelay方法取消延迟挂起，applyQuickFix方法快速修复补丁，createHttp方法创建一个HTTP请求，openSync方法同步打开文件，writeSync方法同步将数据写入文件，closeSync方法同步关闭文件流等接口实现应用热更新的方式去展现短时任务机制。
* 源码链接：[MainAbility.ts](entry/src/main/ets/MainAbility/MainAbility.ts)，[LoadFile.ts](entry/src/main/ets/feature/LoadFile.ts)，[SaveFile.ts](entry/src/main/ets/feature/SaveFile.ts)，[UpdateDialog.ets](entry/src/main/ets/pages/UpdateDialog.ets)
* 接口参考：[@ohos.backgroundTaskManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-backgroundtasks-kit/js-apis-resourceschedule-backgroundTaskManager-sys.md)，[@ohos.app.ability.quickFixManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-quickFixManager-sys.md)，[@ohos.net.http](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-network-kit/js-apis-http.md)，[@ohos.fileio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileio.md)

### 相关权限

1.允许应用安装、卸载其他应用权限：[ohos.permission.INSTALL_BUNDLE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissioninstall_bundle)

2.允许使用Internet网络权限：[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568；

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9；

3.本示例仅支持模块化编译，在build-profile.json5文件的buildOption字段添加"compileMode": "esmodule"；

4.本示例需要使用系统权限的接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)；

5.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/TaskManagement/TransientTask/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```