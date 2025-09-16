# 通用信息展示模板

### 介绍

本示例介绍使用了Swiper组件和List组件实现轮播图和评论列表展示功能。

### 效果预览

效果如下所示：

![main.jpg](entry/src/main/resources/base/media/sample.png)

使用说明

内容展示功能
* 顶部轮播图播放
* 底部评论区支持滚动浏览

### 工程目录

```
entry/src/main/ets/
|---components
|   |---CommentPage
|---data
|   |---MockData
|   |---NewsDetailData
|---model
|   |---NewsCommentModel
|---pages
|   |---Index.ets
```

### 具体实现

* 轮播图和评论列表展示功能，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)
* 轮播图循环播放，评论列表支持滚动浏览。

### 相关权限

无

### 依赖

无

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：Phone;
2. 本示例为Stage模型，支持API20版本SDK，SDK版本号(API Version 20),镜像版本号(6.0.0.31)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0.6)版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/ArkTS1.2/InformationSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```