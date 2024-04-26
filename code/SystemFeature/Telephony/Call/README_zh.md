# 拨打电话

### 介绍

本示例使用[call](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-telephony-kit/js-apis-call-sys.md)相关接口实现了拨打电话并显示电话相关信息的功能

### 效果预览

|主页|
|--------------------------------|
|![image](screenshots/device/call.png)|

使用说明

1.输入电话号码后，点击**电话**按钮，进行拨打电话。

2.拨打电话后文本框会显示拨打是否成功，是否存在通话，通话状态，是否紧急号码，格式化后的电话号码。

### 工程目录
```
entry/src/main/ets/
|---common
|   |---CallView.ets                   // 电话API
|---entryability
|   |---EntryAbility.ts
|---model
|   |---Logger.ts                      // 日志工具
|---pages
|   |---Index.ets                      // 首页
```
### 具体实现

* 该示例展示拨打电话功能，dial方法拨打电话，可设置通话参数，hasCall方法判断是否存在通话，getCallState方法获取当前通话状态，isEmergencyPhoneNumber方法判断是否是紧急电话号码，formatPhoneNumber方法格式化电话号码，formatPhoneNumberToE164方法将电话号码格式化为E.164表示形式。
* 源码链接：[CallView.ets](entry/src/main/ets/common/CallView.ets)
* 接口参考：[@ohos.telephony.call](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-telephony-kit/js-apis-call-sys.md)

### 相关权限

拨打电话权限: [ohos.permission.PLACE_CALL](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionplace_call)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要插入SIM卡，目前该功能仅支持部分机型。

3.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

4.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

5.本示例所配置的权限ohos.permission.PLACE_CALL为system_basic级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-guidelines.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Telephony/Call/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```