#  多设备自适应服务卡片

### 介绍

本示例展示Js工程中服务卡片的布局和使用，其中卡片内容显示使用了一次开发，多端部署的能力实现多设备自适应。

使用说明

长按示例应用，等待出现服务卡片字样，点击后可左右滑动选择需要的卡片尺寸，添加到屏幕。

### 效果预览

|主页|卡片|
|-------|-------|
|![](screenshots/device/main.png)|![](screenshots/device/card.png)|

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例支持在标准系统上运行。

2.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

3.本示例已适配API version 9版本SDK，版本号：3.2.11.9。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/Widget/AdaptiveServiceWidget/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```