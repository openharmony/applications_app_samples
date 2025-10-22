# ArkUI使用文本控件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [文本显示 (Text/Span)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-text-display.md)。
2. [文本输入 (TextInput/TextArea)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-text-input.md)。
3. [富文本 (RichEditor)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-richeditor.md)。
4. [图标小符号 (SymbolGlyph/SymbolSpan)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-symbol.md)。
5. [属性字符串 (StyledString/MutableStyledString)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-styled-string.md)。
6. [图文混排](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-text-image-layout.md)。

### 效果预览

| 首页                                  | 文本显示组件目录                    | 创建文本示例                        |
|-------------------------------------| ----------------------------------- | ----------------------------------- |
| ![](screenshots/device/image1.jpeg) | ![](screenshots/device/image2.jpeg) | ![](screenshots/device/image3.jpeg) |

### 具体实现

1. 到对应模块的官网文档，理解模块功能和使用说明

2. 补充对应的代码片段，确保可以运行

3. 拿真机，填写测试用例，运行项目

4. 拿真机对用例进行自动测试

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
|   |---ndk                                          // ndk接口使用文本
|   |       |---index.ets
|   |       |---TextDrawingDisplay.ets
|   |       |---ListenTextBoxEvents.ets
|   |---propertyString                               // 属性字符串
|   |       |---CreateApply.ets
|   |       |---index.ets
|   |       |---StyledStringGestureStyle.ets
|   |       |---StyledStringHtml.ets
|   |       |---StyledStringImageAttachment.ets
|   |       |---StyledStringParagraphStyle.ets
|   |       |---StyledStringSceneExample.ets
|   |       |---StyledStringStyle.ets
|   |---richEditor                                   // 富文本
|   |       |---AddBuilderDecoratorContent.ets
|   |       |---AddEvent.ets
|   |       |---AddImageContent.ets
|   |       |---AddSymbolSpanContent.ets
|   |       |---AddTextContent.ets
|   |       |---BackplaneHighlighting.ets
|   |       |---CreateRichEditor.ets
|   |       |---GetGraphicInfoInComponent.ets
|   |       |---index.ets
|   |       |---SetAttributes.ets
|   |       |---SetUserPresetTextStyles.ets
|   |---symbol                                       // 图标小符号
|   |       |---CreatSymbolGlyph.ets
|   |       |---index.ets
|   |       |---SymbolAddEvent.ets
|   |       |---SymbolAddToText.ets
|   |       |---SymbolCustomIconAnimation.ets
|   |       |---SymbolSceneExample.ets
|   |       |---SymbolShadowAndColor.ets
|   |---text                                         // 文本显示     
|   |       |---AIMenu.ets
|   |       |---CreatText.ets
|   |       |---CustomTextStyle.ets
|   |       |---index.ets
|   |       |---SelectMenu.ets
|   |       |---TextAddEvent.ets
|   |       |---TextHotSearch.ets
|   |       |---TextSpan.ets
|   |---textImageMixedLayout                       // 图文混排
|   |       |---index.ets
|   |       |---TextImageAttribute.ets
|   |       |---TextImageComponent.ets
|   |---testInput                                    // 文本输入
|   |       |---ProhibitSelectMenu
|   |       |   |---DisableMenuItems.ets
|   |       |   |---DisableSystemServiceMenuItems.ets
|   |       |   |---index.ets
|   |       |---AutoFill.ets
|   |       |---CreatTextInput.ets
|   |       |---CursorAvoidance.ets
|   |       |---CustomTextInputStyle.ets
|   |       |---index.ets
|   |       |---KeyboardAvoidance.ets
|   |       |---SelectMenu.ets
|   |       |---SetProperty.ets
|   |       |---SetTextInputType.ets
|   |       |---SetTextMargin.ets
|   |       |---TextInputAddEvent.ets
|---pages
|   |---Index.ets                                    // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                               // 示例代码测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.34，镜像版本号：OpenHarmony_6.0.0.34。

3.本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/TextComponent > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````