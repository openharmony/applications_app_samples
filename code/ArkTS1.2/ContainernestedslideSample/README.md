# Scroll容器嵌套多种组件事件处理案例

### 介绍

Scroll容器嵌套多种组件事件处理案例；

### 效果预览

效果如下所示：

|Scroll容器嵌套多种组件事件处理案例|
|--------------------------------|
|![Alt text](entry/src/main/resources/base/media/sample.png)|

使用说明

主界面显示Scroll容器嵌套多种组件事件处理案例。
    * 超过一屏可以上下滑动。

### 工程目录

```
entry/src/main/ets/
|---components
|   |---CommentPage.ets
|---entryability
|   |---EntryAbility.ets
|---mock
|   |---NewsDetailData.ets
|---model
|   |---NewsCommentModel.ets
|---pages
|   |---Index.ets
```

### 具体实现

* Scroll容器嵌套多种组件事件处理案例，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)
  * 创建新闻内容和评论区组件，使用Scroll组件进行嵌套。
  * 使用ForEach和List组件循环渲染构造评论区列表。
  * 禁用List滚动手势。

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
echo code/ArkTS1.2/ContainernestedslideSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```