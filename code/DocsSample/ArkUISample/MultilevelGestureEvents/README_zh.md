# ArkUI使用文本控件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [多层级手势事件](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-gesture-events-multi-level-gesture.md)。

### 效果预览
不涉及

### 具体实现

1. **GestureGroup 组合多级手势**：创建 GestureGroup 实例，传入手势协作模式（如 GestureMask.EXCLUSIVE 互斥、GestureMask.PARALLEL 并行），再添加需组合的基础手势（如 TapGesture、DoubleTapGesture），实现多级手势关联。
2. **hitTestBehavior 事件传递控制**：在手势的 withOptions 中配置 hitTestBehavior，支持三种模式 ——ACCEPT（响应事件不传递）、IGNORE（忽略事件传父组件）、BLOCK（拦截事件不响应不传递），控制组件手势事件交互。
3. **手势优先级配置**：通过手势的 withOptions 设置 recognizePriority 属性（数值越大优先级越高），或通过 GestureGroup 添加顺序（先加的优先），解决多级手势识别冲突。
4. **单击 + 双击多级手势实现**：创建 TapGesture（单击）和 DoubleTapGesture（双击），用 GestureGroup (GestureMask.EXCLUSIVE) 组合，配置双击优先级高于单击，绑定到组件实现 “双击优先响应，单击延后判断”。
5. **滑动 + 缩放多级手势实现**：组合 PanGesture（滑动）与 PinchGesture（缩放），设为 GestureMask.PARALLEL 并行模式，配置缩放优先级高于滑动，实现 “滑动平移 + 双指缩放” 同时支持。



### 使用说明

1. **GestureGroup 组合多级手势**: 适用于需要关联触发的手势场景，如图片查看页 “单击隐藏件 + 双击缩放图片”、地图页 “滑动平移 + 双指缩放”。互斥模式（EXCLUSIVE）用于手势互斥（如单 / 双击），并行模式（PARALLEL）用于手势共存（如滑动 / 缩放），可避免单手势功能局限。
2. **clipShape 属性裁剪图片形状**：适合父子组件手势交互场景，如弹窗组件设 BLOCK 拦截底层事件、列表子项设 ACCEPT 优先响应点击、装饰性组件设 IGNORE 不影响父组件手势，确保页面手势交互逻辑清晰。
3. **手势优先级配置**：用于解决手势识别冲突，如 “单击 + 双击” 中设双击优先级更高（recognizePriority:2），避免单击先触发导致双击失效；“滑动 + 长按” 中设长按优先级高，防止滑动误触发长按，提升手势识别准确性。
4. **常见多级手势应用**：单击 + 双击适用于图片或文档查看场景（双击放大、单击件）；滑动 + 缩放适用于地图或图表场景（滑动移动、双指缩放查看细节）；长按 + 滑动适用于拖拽长按激活拖拽、滑动移动位置），满足复杂交互需求。
### 工程目录
```
entry/src/main/ets/
|---entryability
|---pages
|   |---CustomEvent.ets                // hitTestBehavior对手势和事件的控制页面
|   |---GesturesEvents.ets             // 手势与事件页面
|   |---OverlayManager.ets             // OverlayManager的事件透传页面
|   |---TouchEvent.ets                 // 触摸事件页面    
            
|---pages
|   |---Index.ets                      // 应用主页面
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony**_5.0.2.57。**

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/MultilevelGestureEvents > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````