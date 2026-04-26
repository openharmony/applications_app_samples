# 发送短信（仅供系统应用使用）

### 介绍

短信服务模块提供了管理短信的一些基础能力，包括创建/发送短信、获取/设置发送短信的默认SIM卡槽ID、获取/设置短信服务中心地址，以及检查当前设备是否具备短信发送和接收能力等。

使用说明：
1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮，观察自定义占位节点的不同应用。
3. 本示例涉及[相关权限]为system_basic(或者system_core)级别（相关权限级别可通过[权限定义列表]查看），需要配置高权限签名，可参考[特殊权限配置方法]；
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
entry/src/ohosTest/
|---ets
|   |---index.test.ets                 // 示例代码测试代码
```
### 具体实现

## 发送短信（仅供系统应用使用）

1. 声明接口调用所需要的权限：

   - 如果是想发送短信，则调用sendShortMessage接口，需要配置ohos.permission.SEND_MESSAGES权限，权限级别为system_basic。
   - 如果是想设置短信服务中心地址，则调用setSmscAddr接口，需要配置ohos.permission.SET_TELEPHONY_STATE权限，权限级别为system_basic。
   - 如果是想获取短信服务中心地址，则调用getSmscAddr接口，需要配置ohos.permission.GET_TELEPHONY_STATE权限，权限级别为system_basic。
   在申请权限前，请保证符合[权限使用的基本原则](../security/AccessToken/app-permission-mgmt-overview.md#权限使用的基本原则)。然后参考[申请应用权限](../security/AccessToken/determine-application-mode.md#system_basic等级应用申请权限的方式)声明对应权限。
2. import需要的模块。

3. 发送SMS消息。



### 相关权限

ohos.permission.SEND_MESSAGES。

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