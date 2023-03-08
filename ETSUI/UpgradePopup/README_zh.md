# 自定义弹窗

### 介绍

本示例展示了通过**CustomDialogController**组件显示一个自定义的升级弹窗。

### 效果预览

|弹窗|
|--------|
|![](screenshots/devices/zh/popup.png)|

使用说明
1. 进入主页，界面会弹出升级弹窗，通过RichText显示升级相关信息。
2. 点击**取消**按钮或**立即升级**按钮，弹窗会关闭。

### 工程目录
```
updatedialog/src/main/ets/
|---components
|   |---feature
|   |   |---DialogFeature.ts                        // 弹窗功能
|   |---mock
|   |   |---DialogData.ts                           // 弹窗数据
|   |---model
|   |   |---DialogDataModel.ts                      // 弹窗数据结构
|   |---net
|   |   |---RequestResopnse.ts                      // 网络请求类
|   |---pages
|   |   |---UpdateDialog.ts                         // 更新弹窗页面
|   |---util
|   |   |---Logger.ts                               // 日志工具类
```

### 具体实现
+ 本示例使用 [CustomDialogController](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-methods-custom-dialog-box.md) 组件实现自定义弹窗，用于给用户反馈升级信息。使用 [RichText](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-richtext.md) 组件实现富文本的显示。发送请求参考[@ohos.net.http](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-http.md)。

### 相关权限

[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，仅支持API9版本SDK，版本号：3.2.10.6。
3. 本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo ETSUI/UpgradePopup/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```