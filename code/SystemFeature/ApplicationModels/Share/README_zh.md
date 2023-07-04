# 发起分享应用

### 介绍

本示例主要实现了点击“分享”按钮发起分享，显示出分享文本应用图标和分享编辑应用图标，点击相对应应用图标可以发起分享并跳转到其对应应用显示。

### 效果预览

| 应用主页面                                                                 | 选择分享页面 |
|-----------------------------------------------------------------------| ------- |
| ![shareMain](./screenshots/zh/shareMain.jpeg) | ![sharePopup](./screenshots/zh/sharePopup.jpeg) |

使用说明

1.点击“分享”按钮，弹出支持分享的应用列表；

2.选择应用图标进行点击，跳转到对应的应用。

### 工程目录

```
entry/src/main/
|---ets
|  |---entryability
|  |  └---EntryAbility.ts
|  └---pages
|     |---Index.ets                          // EntryAbility页面
|     └---Picker.ets                         // 自定义弹窗页面
|---model
|  └---Logger.ts
└---resources                                // 资源信息
```

### 具体实现

- ”分享“按钮显示并实现在Index.ets中,  源码参考[Index.ets](./entry/src/main/ets/pages/Index.ets)。
  - 在“分享”按钮的点击事件中，通过创建CustomDialogController对象并将对应Picker组件绑定，然后调用open接口打开自定义ButtonDialogBuilder对话框容器。
- 弹出的对话框样式及内容封装在picker.ets中，源码参考：[Picker.ets](./entry/src/main/ets/pages/Picker.ets)。

### 相关权限

不涉及。

### 依赖

本应用需分享文本应用（Template应用）及分享编辑应用（Receiver应用）配合使用，Template应用地址：[Template](../../ApplicationModels/Template/)，Receiver应用地址：[Receiver](../../ApplicationModels/Receiver/)。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 10版本SDK，版本号：4.0.8.5。

3.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。

4.本示例需要使用Full SDK编译。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/ApplicationModels/Share/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```