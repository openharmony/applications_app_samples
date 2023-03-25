# 图片显示

### 介绍

本示例展示从相册选择图片展示在商品评价页面。

本示例使用 [TextArea](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-textarea.md) 组件实现多文本属于，使用 [mediaLibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-mediaquery.md) 实现图片的获取，选择。

使用说明： 

1.点击添加图片/照片，页面跳转到图片选择页面。

2.进入图片选择页面后，选择需要显示的图片，选择的图片数量会显示在右上方，选择的图片会显示在下方。最多选择6张图片。

3.选定图片后点击下一步，页面会跳转回主页面，图片显示在主页。若不确定选择，点击添加图片/照片进行重新选择。

4.图片选择后，点击文本输入框，可以对商品进行评价。

5.点击返回按钮，退出应用。

### 效果预览

![](screenshots/devices/zh/index.png) ![](screenshots/devices/zh/not_choice.png) ![](screenshots/devices/zh/choice.png) ![](screenshots/devices/zh/show.png)

### 相关权限

允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100, built on November 3, 2022)才可编译运行。