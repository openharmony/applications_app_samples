# BuilderNode自定义组件复用实现案例

### 介绍

本示例是BuilderNode自定义组件复用实现的示例代码，主要讲解如何通过BuilderNode创建自定义组件复用池，实现跨页面的组件复用。

### 效果预览

效果如下所示：

![main.jpg](entry/src/main/resources/base/media/sample.png)

使用说明
* 点击顶部tab页签切换自定义组件
* 轮播图、瀑布流组件从复用池NodePool中获取组件加载到页面中

### 工程目录

```
entry/src/main/ets/
|---constants
|   |---Constants.ets
|---data
|   |---MockData.ets
|   |---TitleBean.ets
|   |---ViewItem.ets
|---pages
|   |---Index.ets
|   |---BuilderNodePoolDemo.ets
|---utils
|   |---BuilderNodePool.ets
|---view
|   |---FlowItemView.ets
|   |---SwiperView.ets
|   |---TabNode.ets
```

### 具体实现
* BuilderNode自定义组件复用，源码参考：[BuilderNodePool.ets](entry/src/main/ets/utils/BuilderNodePool.ets)
* 轮播图播放，瀑布流列表支持滚动浏览。

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
echo code/ArkTS1.2/CustomComponentSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```