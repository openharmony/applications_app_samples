# 访问权限控制（仅对系统应用开放）

### 介绍

本示例使用@ohos.abilityAccessCtrl，展示了应用申请权限场景。

### 效果预览

|主页|授权弹窗|
|------------|-------------------|
|![](screenshots/device/main.png)| ![](screenshots/device/dialog.png)|

使用说明

1.打开应用，页面出现弹窗，点击 **取消** 按钮。

2.页面跳转显示 **检测权限** 按钮，点击检测权限，出现提示信息“权限未授予”。

3.关闭应用再次打开，页面出现弹窗，点击 **确认** 按钮。

4.页面跳转显示 **检测权限** 按钮，点击**检测权限** 按钮，出现提示信息“权限已授予”。

5.关闭应用再次打开，页面不出现弹窗，点击 **检测权限** 按钮，点击检测权限，出现提示信息“权限已授予”。

### 工程目录
```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets
|---model
|   |---Logger.ts                      // 日志工具
|---pages
|   |---Index.ets                      // 首页
|---verifyability
|   |---VerifyAbility.ets              
|   |---pages
|   |   |---Index.ets                  // 检测权限
```
### 具体实现

* 该示例使用abilityAccessCtrl接口中abilityAccessCtrl方法获取访问控制模块对象，GrantStatus.PERMISSION_GRANTED方法表示已授权状态，bundleManager接口中getApplicationInfo方法根据包名获取ApplicationInfo等展示应用申请权限场景
* 源码链接：[Index.ets](entry/src/main/ets/verifyability/pages/Index.ets)
* 接口参考：[@ohos.abilityAccessCtrl](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-abilityAccessCtrl.md)，[@ohos.bundle.bundleManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-bundleManager.md)

### 相关权限

1.允许应用读取其他应用的敏感权限的状态权限：[ohos.permission.GET_SENSITIVE_PERMISSIONS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_sensitive_permissions)

2.允许应用撤销给其他应用授予的敏感信息权限：[ohos.permission.REVOKE_SENSITIVE_PERMISSIONS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionrevoke_sensitive_permissions)

3.允许应用为其他应用授予敏感权限：[ohos.permission.GRANT_SENSITIVE_PERMISSIONS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissiongrant_sensitive_permissions)

4.允许应用同时查询其他多个应用的信息权限：[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_bundle_info_privileged)

5.允许应用查询其他单个应用的信息权限：[ohos.permission.GET_BUNDLE_INFO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionget_bundle_info)

6.允许应用使用麦克风权限：[ohos.permission.MICROPHONE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionmicrophone)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

3.工程编译前需要先执行Make Module 'entry'。

4.本示例涉及使用系统接口：grantUserGrantedPermission()，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

5.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

6.本示例所配置的权限ohos.permission.GET_SENSITIVE_PERMISSIONS、ohos.permission.REVOKE_SENSITIVE_PERMISSIONS、ohos.permission.GRANT_SENSITIVE_PERMISSIONS为system_core级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/))。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Security/AbilityAccessCtrl/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```
