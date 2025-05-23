# ArkUI使用滚动类指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [创建列表 (List)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-create-list.md)。
2. [创建弧形列表 (ArcList)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-create-arclist.md)（圆形屏幕推荐使用）
3. [创建网格 (Grid/GridItem)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-create-grid.md)。
4. [创建瀑布流 (WaterFlow)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-create-waterflow.md)
5. [创建轮播 (Swiper)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-create-looping.md)。
6. [创建弧形轮播 (ArcSwiper)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-layout-development-arcswiper.md)（圆形屏幕推荐使用）
7. [选项卡 (Tabs)](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.1.0-Release/zh-cn/application-dev/ui/arkts-navigation-tabs.md)
### 效果预览

| 首页                                 | 列表类组件目录                            | 列表中显示数据示例                            |
|------------------------------------|------------------------------------|------------------------------------|
| ![](screenshots/device/image1.png) | ![](screenshots/device/image2.png) | ![](screenshots/device/image3.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---arcList                             //弧形列表  
|   |       |---ArcListAcrScrollBar.ets
|   |       |---ArcListArcIndexerBar.ets
|   |       |---arcListBuiltInScrollerBar.ets
|   |       |---ArcListContents.ets
|   |       |---ArcListCrown.ets
|   |       |---ArcListShow.ets
|   |       |---ArcListSideSlip.ets
|   |       |---ArcListStyles.ets
|   |       |---ArcLongList.ets
|   |       |---index.ets
|   |---arcSwiper                            //弧形轮播 
|   |       |---ArcSwiperAction.ets
|   |       |---ArcSwiperHorizontal.ets
|   |       |---ArcSwiperSideSlip.ets
|   |       |---ArcSwiperStyles.ets
|   |       |---ArcSwiperToggle.ets
|   |       |---ArcSwiperVertical.ets
|   |       |---index.ets
|   |---grid                                 //列表  
|   |       |---DataInGrid.ets
|   |       |---GridDataSource.ets
|   |       |---GridLayout.ets
|   |       |---GridScrollbar.ets
|   |       |---GridSideToSide.ets
|   |       |---index.ets
|   |       |---LongGrid.ets
|   |       |---ScrollableGrid.ets
|   |       |---ScrollPosition.ets
|   |---list                                 //网格
|   |       |---AddListItem.ets
|   |       |---CollapseAndExpand.ets
|   |       |---ControlledScrollPositionList.ets
|   |       |---CustomListStyle.ets
|   |       |---DataInList.ets
|   |       |---DeleteListItem.ets
|   |       |---GroupedList.ets
|   |       |---index.ets
|   |       |---ListChatRoom.ets
|   |       |---ListDataSource.ets
|   |       |---ListIteration.ets
|   |       |---ListLayout.ets
|   |       |---LongList.ets
|   |       |---ResponsiveScrollPositionList.ets
|   |       |---StickyHeaderList.ets
|   |       |---SwipeListItem.ets
|   |       |---TaggedListItems.ets
|   |---swiper                               //轮播
|   |       |---index.ets
|   |       |---SwiperAndTabsLinkage.ets
|   |       |---SwiperAutoPlay.ets
|   |       |---SwiperCustomAnimation.ets
|   |       |---SwiperDirection.ets
|   |       |---SwiperIgnoreComponentSize.ets
|   |       |---SwiperIndicatorStyle.ets
|   |       |---SwiperLoop.ets
|   |       |---SwiperMultiPage.ets
|   |       |---SwiperPageSwitchMethod.ets
|   |---tabs                                 //选项卡
|   |       |---AgeFriendlyTabs.ets  
|   |       |---BottomTabBar.ets
|   |       |---ContentWillChange.ets 
|   |       |---CustomTabBar.ets
|   |       |---FixedTabBar.ets
|   |       |---index.ets
|   |       |---ScrollableTabBar.ets
|   |       |---SideTabBar.ets
|   |       |---SwipeLockedTabBar.ets
|   |       |---TabsLayout.ets
|   |       |---TopTabBar.ets
|   |---waterFlow                             //瀑布流
|   |       |---AgeFriendlyTabs.ets  
|   |       |---BottomTabBar.ets
|   |       |---ContentWillChange.ets 
|   |       |---CustomTabBar.ets
|   |       |---FixedTabBar.ets
|   |       |---index.ets
|   |       |---WaterFlowDataSource.ets
|   |       |---WaterFlowDynamicSwitchover.ets
|   |       |---WaterFlowGroupingMixing.ets
|   |       |---WaterFlowInfiniteScrolling.ets
|   |       |---WaterFlowInfiniteScrollingEarly.ets   
|---pages
|   |---Index.ets                       // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                       // 示例代码测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API18版本SDK，版本号：5.1.0.107，镜像版本号：OpenHarmony_5.1.0 Release。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200， built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/ScrollableComponent > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````