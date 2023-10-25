## 一多导航栏

### 介绍

本示例展示了导航组件在不同设备形态下的样式。

* 在sm设备上，以tabs形式展示，内容、导航为上下样式布局，通过点击底部tabs切换内容；
* 在md/lg设备上，以[SideBarContainer](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-sidebarcontainer.md)形式展示，内容、导航为左右布局，通过点击侧边一二级菜单进行内容切换。

本示例使用[一次开发多端部署](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/key-features/multi-device-app-dev)
中介绍的自适应布局能力和响应式布局能力进行多设备（或多窗口尺寸）适配，主要通过组件提供窗口断点事件，保证应用在不同设备或不同窗口尺寸下可以正常显示。

### 预览效果

本示例在预览器中的效果：

| SM设备                                | MD设备                                | LG设备                                |
|-------------------------------------|-------------------------------------|-------------------------------------|
| ![](screenshots/Devices/image1.png) | ![](screenshots/Devices/image2.png) | ![](screenshots/Devices/image4.png) |

| 侧边栏折叠                               | 侧边栏展开                               |
|-------------------------------------|-------------------------------------|
| ![](screenshots/Devices/image3.png) | ![](screenshots/Devices/image2.png) |

使用说明：

1. 打开首页，在IDE编辑器中打开预览器查看预览效果。
2. 在预览器中开启窗口拖拽模式，拖动窗口变化，可以查看组件的响应式变化，如下图所示：
![](screenshots/Devices/image11.png)
3. 手动自由拖拽窗口，将应用窗口在sm/md/lg三种设备形态下进行切换并查看预览效果。
4. 在sm/lg窗口下，点击左上角图标进行侧边栏样式切换

### 工程目录

```
MultiNavBar/entry/src/main/ets/
|---model
|   |---MenuType.ets                       // 侧边栏菜单数据类型
|   |---SideListData.ets                   // 侧边栏数据
|---pages                                  
|   |---AppStore.ets                       // 首页
|---common                                    
|   |---BreakpointSystem.ets               // 媒体查询
|   |---CommonMainTabs.ets                 // 一级Tabs
|   |---CommonSubTabs.ets                  // 二级Tabs
|   |---Configuration.ets                  // 样式配置
|   |---RecommendationList.ets             // 推荐页面
|   |---SideBarController.ets              // 侧边栏控制器                                  
```

### 具体实现

本示例介绍如何使用自适应布局能力和响应式布局能力适配不同尺寸窗口,将页面分拆为2部分。

#### 整体布局

1.通过GridRow组件提供的断点事件，获取到当前窗口的断点，通过visibility属性将[Tabs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md)组件与[SideBarContainer](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-sidebarcontainer.md)组件分别在sm/(md、lg)
形态下展示/隐藏。

2.同时通过断点，对组件设置不同的样式属性，以最优的效果展示。

#### 侧边栏SideBar/底部TabsController

1.侧边栏内容布局通过Flex容器分别在sm/(md、lg)形态下进行横竖展示。

2.内容区域通过不同的窗口断点进行选择显隐。

3.md、lg形态侧边栏一级菜单对应sm形态最外层的TabsController组件、二级菜单对应里层的TabsController组件。

4.侧边栏同时存在两种形态list/tabs，通过侧边栏左上角图标切换，list模式下内容区域较小，根据窗口断点只显示图标/图标+文字，tabs模式下内容区域较大，显示图标+文字。

#### 内容区域

1.Swiper组件通过获取窗口断点，设置displayCount属性，在不同窗口下显示不同数量的图片。

2.Gird组件通过获取窗口断点，设置columnsTemplate与rowsTemplate属性，在不同窗口下显示不同数量的Item。

3.内容浏览的连续性，进行窗口切换时，内容区域的浏览进度可以保持，不会进行重新刷新。

### 相关权限

不涉及。

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0 Release)

3.本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SuperFeature/MultiDeviceAppDev/multiNavBar/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```