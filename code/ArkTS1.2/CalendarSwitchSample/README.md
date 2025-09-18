
# 日历切换案例

### 介绍
使用Swiper实现自定义日历年视图、月视图、周视图左右滑动切换年、月、周的效果。同时使用Tabs实现年视图、月视图、周视图之间的切换效果。
### 效果图预览
| 主界面                  |
|------------------------|
| ![main](entry/src/main/resources/base/media/main.png) |  

**使用说明**
  * 点击周按钮 在周视图上手指往右滑动，可切换到上一周，往左滑动可切换到下一周。
  * 点击月按钮 在月视图上手指往右滑动，可切换到上一月，往左滑动可切换到下一月。
  * 点击年按钮 在年视图上手指往右滑动，可切换到上一年，往左滑动可切换到下一年。

### 工程结构&模块类型

```
entry/src/main/ets/pages
|---CalenderSwitch
|   |---customcalendar
|   |   |---common
|   |   |   |---CommonData.ets             // 公共数据类
|   |   |---components
|   |   |   |---CustomCalendar.ets         // 自定义日历组件CustomCalendar
|   |   |---constant
|   |   |   |---Constants.ets              // 常量
|   |   |---model
|   |   |   |---CalendarModel.ets          // 自定义日历样式
|   |   |   |---OffscreenCanvas.ets        // 离屏画布
|   |   |---utils
|   |   |   |---StyleUtils.ets             // 样式类
|   |   |   |---TimeUtils.ets              // 时间工具类
|   |   |---utils
|   |   |   |---MonthView.ets              // 月视图
|   |   |   |---MonthViewItem.ets          // 月视图子组件
|   |   |   |---WeekView.ets               // 周视图
|   |   |   |---WeekViewItem.ets           // 周视图子组件
|   |   |   |---YearView.ets               // 年视图
|   |   |   |---YearViewItem.ets           // 年视图子组件            
|   |---CustomCalendarSample.ets           // 创建自定义日历组件
|   |---index.ets                          // 首页
```

### 具体实现

* CalenderSwitch(日历切换案例) 源码参考: [CalenderSwitch](entry/src/main/ets/pages/CalenderSwitch)
  * 通过使用Swiper实现自定义日历年视图、月视图、周视图左右滑动切换年、月、周的效果。同时使用Tabs实现年视图、月视图、周视图之间的切换效果。源码参考:[CustomCalendarSample.ets](entry/src/main/ets/pages/CalenderSwitch/CustomCalendarSample.ets)
  * 进入页面，在月视图上手指往右滑动，可切换到上个月，往左滑动可切换到下个月。源码参考:[MonthView.ets](entry/src/main/ets/pages/CalenderSwitch/customcalendar/view/MonthView.ets)
  * 周视图左右滑动可切换下一周和上一周。源码参考:[WeekView.ets](entry/src/main/ets/pages/CalenderSwitch/customcalendar/view/WeekView.ets)
  * 年视图左右滑动可切换下一年和上一年。源码参考:[YearView.ets](entry/src/main/ets/pages/CalenderSwitch/customcalendar/view/YearView.ets)


### 相关权限

无

### 依赖

无

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：Phone;
2. 本示例为Stage模型，支持API20版本SDK，SDK版本号(API Version 20),镜像版本号(6.0.0.31)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0.21)版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/ArkTS1.2/CalenderSwitchSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```