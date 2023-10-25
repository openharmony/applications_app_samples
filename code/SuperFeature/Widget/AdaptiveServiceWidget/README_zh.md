#  多设备自适应服务卡片

### 介绍

本示例展示Js工程中服务卡片的布局和使用，其中卡片内容显示使用了一次开发，多端部署的能力实现多设备自适应。    
用到了卡片扩展模块接口，[@ohos.app.form.FormExtensionAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-form-formExtensionAbility.md) 。  

卡片信息和状态等相关类型和枚举接口，[@ohos.app.form.formInfo](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-form-formInfo.md) 。  

卡片数据绑定的能力接口[@ohos.app.form.formBindingData](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-form-formBindingData.md) 。  



### 效果预览

|主页|卡片|
|-------|-------|
|![](screenshots/device/main.png)|![](screenshots/device/card.png)|

使用说明

长按示例应用，等待出现服务卡片字样，点击后可左右滑动选择需要的卡片尺寸，添加到屏幕。

### 工程目录
```
entry/src/main
|---module.json5                           // 添加卡片拓展能力
|---/ets/pages
|   |---index.ets                          // 首页
|---/ets/entryformability                                 
|   |---EntryFormAbility.ets               // 定义卡片对象首次被创建时需要做的操作
|---js/complex/pages/index                 // 定义卡片内容                 
|   |---index.hml                                                   
|   |---index.css                          
|   |---index.json                         
|---resources/base/profile                                  
|   |---form_config.json                   // 配置卡片（卡片名称，引入js卡片，卡片窗口大小等）                          
```

### 具体实现
1、在module.json5文件添加拓展能力，类型为卡片，并设置卡片入口srcEntrance和卡片元数据metadata。[源码参考](entry/src/main/module.json5) 例如："metadata": [
{
"name": "ohos.extension.form",
"resource": "$profile:form_config"
}。  
2、初始化卡片：通过实现@ohos.app.form.FormExtensionAbility卡片操作类，在卡片对象首次被创建时，初始化卡片绑定数据为空，并将卡片状态设置为就绪状态READY。 例如：onCreate(){
formBindingData.createFormBindingData({}) onAcquireFormState(want) {
return formInfo.FormState.READY }。   
3、配置卡片：用js编写相应的卡片，将卡片配置到resources/base/profile/form_config, [源码参考](entry/src/main/resources/base/profile/form_config.json) 。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例支持在标准系统上运行。

2.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

3.本示例已适配API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/Widget/AdaptiveServiceWidget/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```