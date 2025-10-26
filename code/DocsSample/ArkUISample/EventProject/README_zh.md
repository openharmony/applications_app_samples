# ArkUI使用支持交互事件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitCode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [触屏事件](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-common-events-touch-screen-event.md)
2. [键鼠事件](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-common-events-device-input-event.md)
3. [焦点事件](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-common-events-focus-event.md)
4. [拖拽事件](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-common-events-drag-event.md)
5. [单一手势](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-gesture-events-single-gesture.md)
6. [组合手势](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-gesture-events-combined-gestures.md)
7. [手势拦截](https://gitCode.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/ui/arkts-gesture-events-gesture-judge.md)
### 效果预览

| 首页                                 | 交互类组件目录                            | 单一手势示例                             |
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
|   |---device                            //键鼠事件     
|   |       |---HoverEffect.ets
|   |       |---OnHover.ets
|   |       |---OnKey.ets
|   |       |---OnKeyPreIme.ets
|   |       |---OnMouse.ets
|   |       |---Index.ets
|   |---focus                              //焦点事件
|   |       |---DefaultFocus.ets
|   |       |---Focusable.ets
|   |       |---FocusActive.ets
|   |       |---FocusAndClick.ets
|   |       |---FocusController.ets
|   |       |---FocusOnClick.ets
|   |       |---FocusPriority.ets
|   |       |---FocusScopeId.ets
|   |       |---FocusScopePriority.ets
|   |       |---FocusScopePriorityPrevious.ets
|   |       |---FocusStyle.ets
|   |       |---FocusTransfer.ets
|   |       |---FocusTraversalGuidelines.ets
|   |       |---FrojectAreaFocusFlex.ets
|   |       |---Index.ets
|   |       |---NextFocus.ets
|   |       |---onFocusBlur.ets
|   |       |---OnFocusOnBlurEvents.ets
|   |       |---ProjectionBasedFocus.ets
|   |       |---RequestFocus.ets
|   |       |---ScopeFocus.ets
|   |       |---TabIndex.ets
|   |       |---TabIndexFocus.ets
|   |       |---TabStop.ets
|   |---drag                                //拖拽事件
|   |       |---DefaultDrag.ets
|   |       |---Index.ets
|   |       |---MoreDrag.ets
|   |---gesturejudge                        //手势拦截
|   |       |---Index.ets  
|   |       |---GestureJudge.ets
|   |---singlegesture                       //单一手势
|   |       |---LongPressGesture.ets
|   |       |---PanGesture.ets
|   |       |---Index.ets
|   |       |---PinchGesture.ets
|   |       |---RotationGesture.ets
|   |       |---SwipeGesture.ets
|   |       |---TapGesture.ets
|   |---Touch                                //触屏事件
|   |       |---ClickEvent.ets
|   |       |---Index.ets
|   |       |---TouchEvent.ets    
|   |---groupgesture                          //组合手势
|   |       |---Exclusive.ets
|   |       |---Index.ets
|   |       |---Parallel.ets
|   |       |---Sequence.ets                    
|---pages
|   |---Index.ets                       // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                       // 示例代码测试代码
```

### 具体实现
焦点：指向当前应用界面上唯一的一个可交互元素，当用户使用键盘、电视遥控器、车机摇杆/旋钮等非指向性输入设备与应用程序进行间接交互时，基于焦点的导航和交互是重要的输入手段。
焦点链：在应用的组件树形结构中，当一个组件获得焦点时，从根节点到该组件节点的整条路径上的所有节点都会处于焦点状态，形成一条连续的焦点链。
走焦：指焦点在应用内的组件之间转移的行为。这一过程对用户是透明的，但开发者可以通过监听onFocus（焦点获取）和onBlur（焦点失去）事件来捕捉这些变化。关于走焦的具体方式和规则，详见走焦规范。
焦点激活态：焦点激活是用来显示当前获焦组件焦点框的视觉样式。
焦点传递规则:焦点传递是指当用户激活应用焦点系统时，焦点如何从根节点逐级向下传递到具体组件的过程。
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Canary1 (Build Version: 6.0.0.270， built on May 9, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/EventProject > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````