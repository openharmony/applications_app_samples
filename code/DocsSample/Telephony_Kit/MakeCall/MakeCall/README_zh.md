# sms方式跳转到短信编辑界面

### 介绍

开发者可以通过以下方式实现拨打电话的功能：

对于三方应用，开发者可以使用makeCall接口，拉起系统电话应用，用户可以自行呼出通话。

使用说明：
1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮，观察自定义占位节点的不同应用。
### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---Index.ets                       // 应用主页面
```
### 具体实现

导入call和observer模块。

调用hasVoiceCapability，确认当前设备是否支持拨号。

调用makeCall接口，跳转到拨号界面并显示待拨号的号码。

（可选）订阅通话业务状态变化。



### 相关权限

不涉及。

### 依赖

1.仅支持在标准系统上运行。
2.需授予发送短信权限且插入SIM卡才可成功发送短信。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/SmsService_Web > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````