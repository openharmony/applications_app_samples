
# ArkUI使用内容修改器指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [内容修改器 (ContentModifier)](https://gitcode.com/openharmony/docs/blob/OpenHarmony-6.0-Release/zh-cn/application-dev/ui/arkts-common-attributes-content-modifier.md)。
### 效果预览

| 首页                                | 选中                                | 未选中                                 |
|-----------------------------------|-----------------------------------|-------------------------------------|
| ![](screenshots/device/start.png) | ![](screenshots/device/check.png) | ![](screenshots/device/uncheck.png) |

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
|   |---Index.ets                       // 应用主页面
|   |---MyCheckboxStyle.ets             // 内容修改器 (ContentModifier)
entry/src/ohosTest/
|---ets
|   |---index.test.ets                       // 示例代码测试代码
```

## 具体实现

1. 内容修改器 (ContentModifier)

    * 当开发者期望自定义组件的内容区时，比如Checkbox的内部显示一个五角星等场景时，可以使用此功能。

    * 仅Button、Checkbox、DataPanel、TextTimer、Slider、Select、Rating、Radio、Gauge、Toggle、TextClock组件支持该能力。

    * 使用ContentModifier自定义Checkbox样式，用五边形Checkbox替换默认Checkbox。选中时，五边形内部显示红色三角图案，标题显示“选中”；取消选中时，红色三角图案消失，标题显示“非选中”。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio NEXT Developer Preview2 (Build Version: 5.0.5.306， built on December 12, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/Modifier > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````