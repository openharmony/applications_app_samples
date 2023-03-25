# 组件集合

### 介绍

本示例为ArkUI中组件、通用、动画、全局方法的集合。

本示例使用 [Tabs容器组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabs.md) 搭建整体应用框架，每个 [TabContent内容视图](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabcontent.md) 使用 [List容器组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-list.md) 布局，在每个 [ListItem](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-listitem.md) 中使用 [循环渲染](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ts-rending-control-syntax-foreach.md) 加载此分类下分类导航数据，底部导航菜单使用 [TabContent中tabBar属性](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-container-tabcontent.md#%E5%B1%9E%E6%80%A7) 设置自定义样式 。

使用说明：

1.点击**组件**、**通用**、**动画**、**全局方法**四个按钮或左右滑动切换不同视图。

2.点击二级导航（如通用属性、通用事件等），若存在三级导航则展开三级导航（如Border 边框、点击事件等）；若不存在三级导航，则跳转至详情页面。

3.若存在三级导航（如Border 边框、点击事件等），点击跳转至详情页面。

### 效果预览

|绑定|通用|动画|全局方法|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|![image](screenshots/devices/component.png)|![image](screenshots/devices/general.png)|![image](screenshots/devices/animation.png)|![image](screenshots/devices/global.png)|
|<center>Button 按钮</center>|<center>onClick 点击事件</center>|<center>元素共享转场</center>|<center>警告弹窗</center>|
|![image](screenshots/devices/button_zh.png)|![image](screenshots/devices/click_event_zh.png)|![image](screenshots/devices/share_element_transition_zh.png)|![image](screenshots/devices/warning_popup_zh.png)|


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.0 Release (Build Version: 3.0.0.993, built on September 4, 2022)才可编译运行。
