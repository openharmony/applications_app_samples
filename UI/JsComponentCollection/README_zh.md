# 组件集合

### 介绍

本示例为ArkUI中组件、通用、动画、全局方法的集合。

本示例使用 [Tabs容器组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-container-tabs.md)搭建整体应用框架，每个 [TabContent内容视图](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-container-tab-content.md) 使用 [div容器组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-container-div.md) 嵌套布局，在每个 [div](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-container-div.md) 中使用 [循环渲染](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-common-attributes.md) 加载此分类下分类导航数据，底部导航菜单使用 [TabContent中tabBar属性](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-js/js-components-container-tab-content.md) 设置自定义样式 。通过组件、通用、动画、全局方法四个大类展现了ArkUI的能力，并把四大类中的功能进行了分类，方便开发者查看，每个示例又结合了不同的展现方式，以契合实际应用场景为主生动的体现了ArkUI能力的用法。

使用说明：

1.点击**组件**、**通用**、**动画**、**全局方法**四个按钮或左右滑动切换不同Tab内容。

2.点击二级导航（如通用属性、通用事件等），若存在三级导航则展开三级导航（如Border 边框、点击事件等）；若不存在三级导航，则点击跳转详情页面。

3.若存在三级导航，点击三级导航则跳转详情页面。

### 效果预览

|绑定|通用|动画|全局方法|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|![image](screenshots/devices/component.png)|![image](screenshots/devices/general.png)|![image](screenshots/devices/animation.png)|![image](screenshots/devices/global.png)|
|<center>Button 按钮</center>|<center>onClick 点击事件</center>|<center>页面间转场</center>|<center>自定义弹窗</center>|
|![image](screenshots/devices/button.png)|![image](screenshots/devices/click.png)|![image](screenshots/devices/pageTransitionOne.png)|![image](screenshots/devices/dialog.png)|


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例仅支持API9版本SDK，版本号：3.2.7.5 Beta3。

3.本示例需要使用DevEco Studio 3.0 Release (Build Version: 3.0.0.993, built on September 4, 2022)编译运行。