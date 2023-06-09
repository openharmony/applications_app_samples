# 一多应用市场首页

### 介绍

本示例展示了应用市场首页，页面中包括Tab栏、运营横幅、精品应用、精品游戏等。

本示例使用[一次开发多端部署](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/key-features/multi-device-app-dev)中介绍的自适应布局能力和响应式布局能力进行多设备（或多窗口尺寸）适配，保证应用在不同设备或不同窗口尺寸下可以正常显示。  

用到了媒体查询接口[@ohos.mediaquery](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-mediaquery.md)。  

### 效果预览

本示例在预览器中的效果：

![](screenshots/Devices/preview.png)

本示例在开发板上运行的效果：

| 全屏显示                         | 窗口操作按钮                      | 悬浮窗口显示                      |
| ----------------------------- | -------------------------------------------- | -------------------------------------------- |
| ![](screenshots/Devices/img.png) | ![](screenshots/Devices/img2.png) | ![](screenshots/Devices/img3.png) |

使用说明：

1. 启动应用，可以查看本应用在全屏状态下的显示效果。

2. 在应用顶部，下滑出现窗口操作按钮。（建议通过外接鼠标操作，接入鼠标只需要将鼠标移动至顶部即可出现窗口）

3. 点击悬浮图标，将应用悬浮在其它界面上显示。

4. 拖动应用悬浮窗口的边框，改变窗口尺寸，触发应用刷新，即可查看应用在不同窗口下的显示效果。

5. 改变窗口尺寸的过程中，窗口尺寸可能超出屏幕尺寸。此时在屏幕中只能看到应用部分区域的显示，但可以通过移动窗口位置，查看应用其它区域的显示。

### 工程目录
```
AppMarket/entry/src/main/ets/
|---model
|   |---HomeData.ets                       // 主页用到的图片资源
|   |---HomeDataType.ets                   // 事件监听函数
|---pages                                  
|   |---index.ets                          // 首页
|---common                                    
|   |---BreakpointSystem.ets               // 媒体查询
|   |---Home.ets                           // 主容器
|   |---IndexApps.ets                      // app模块(包含安装，展示图片，更多功能)
|   |---IndexContent.ets                   // 内容模块
|   |---IndexEntrance.ets                  // 下一步模块(箭头跳转组件)
|   |---IndexHeader.ets                    // 头部组件
|   |---IndexSwiper.ets                    // 轮播图   
|   |---TabBarItem.ets                     // 导航栏                                            
```

### 具体实现
本示例介绍如何使用自适应布局能力和响应式布局能力适配不同尺寸窗口，将页面分拆为5个部分。   
#### 底部/侧边导航栏
1、在sm和md断点下，导航栏在底部；在lg断点下，导航栏在左侧。   
2、通过Tab组件的barPosition和vertical属性控制TabBar的位置在主轴方向起始或结尾位置和水平或垂直方向，同时还可以通过barWidth和barHeight属性控制TabBar的尺寸，[源码参考](entry/src/main/ets/pages/index.ets )。

#### 标题栏与搜索栏
通过栅格实现标题栏和搜索栏：在sm和md断点下分两行显示，在lg断点下单行显示，[源码参考](entry/src/main/ets/common/IndexHeader.ets )。  
2、在sm和md断点下，标题栏和搜索栏占满12列，此时会自动换行显示。  
3、在lg断点下，标题栏占8列而搜索栏占4列，此时标题栏和搜索栏在同一行中显示。
#### 运营横幅
实现不同断点下的运营横幅：通过Swiper组件的displayCount属性，sm断点下显示一张图片，md断点下显示两张图片，lg断点下显示三张图片。
#### 快捷入口
通过将justifyContent参数配置为FlexAlign.SpaceEvenly实现均分布局：在不同的断点下，快捷入口的5个图标始终均匀排布。
#### 精品应用
通过List组件能力，实现延伸能力场景：随着可用显示区域的增加，精品应用中显示的图标数量也不断增加，[源码参考](entry/src/main/ets/common/IndexApps.ets )。
#### 总体运行效果
通过将上述各页面在List() {}中引用组件后，可实现首页的组件整合渲染，即可完成整体页面开发。  

### 相关权限

不涉及。

### 依赖

不涉及

### 约束与限制
1. 本示例仅支持在标准系统上运行。

2. 本示例已适配API version 9版本的SDK，版本号： 3.2.11.9。

3. 本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

4. 本示例在开发板上运行时，需要修改开发板系统配置文件以使能应用窗口能力。

```shell
# 将开发板文件系统的权限配置为可读写
hdc shell mount -o rw,remount /
# 取出原始配置文件
hdc file recv system/etc/window/resources/window_manager_config.xml C:\
# 将文件中<decor enable="false"></decor>改为<decor enable="true"></decor>
# 用修改后的文件替换系统中的原始文件
hdc file send C:\window_manager_config.xml system/etc/window/resources/window_manager_config.xml
# 重启后生效
hdc shell reboot
```

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SuperFeature/MultiDeviceAppDev/AppMarket/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```