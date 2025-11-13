# sms方式跳转到短信编辑界面

### 介绍

应用内跳转到短信编辑界面
发送短信的接口需要系统权限才可调用，三方应用如果有发送短信需求，需要在应用内实现跳转到短信编辑的功能，并且需要携带编辑内容和收件人号码，可以通过调用元能力startAbility接口指定号码并跳转到发送短信页面的方式实现。
使用说明：
1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮，观察自定义占位节点的不同应用。

### 效果预览

| 首页                                 | 列表类组件目录                            | 列表中显示数据示例                            |
|------------------------------------|------------------------------------|------------------------------------|


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

拉起方开发步骤
从网页拉起

网页中的超链接需要满足sms协议。示例如下：

<a href="sms:106XXXXXXXXXX?body=%E5%8F%91%E9%80%81%E7%9F%AD%E4%BF%A1%E5%86%85%E5%AE%B9">发送短信</a>
实际开发时，需要将收件人号码替换为真实的号码，短信内容可以根据需要进行配置。

从应用拉起

保证sms字符串传入uri参数即可，在应用中page页面可通过 this.getUIContext().getHostContext() 获取context，在ability中可通过this.context获取context。



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