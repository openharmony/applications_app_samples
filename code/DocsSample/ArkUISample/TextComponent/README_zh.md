# ArkUI使用文本控件指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitCode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)
中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [文本显示 (Text/Span)](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-text-display.md)。
2. [文本输入 (TextInput/TextArea)](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-text-input.md)。
3. [富文本 (RichEditor)](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-richeditor.md)。
4. [图标小符号 (SymbolGlyph/SymbolSpan)](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-symbol.md)。
5. [属性字符串 (StyledString/MutableStyledString)](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-styled-string.md)。
6. [Text组件的文本绘制与显示](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-styled-string.md)。
7. [监听输入框事件](https://gitCode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-textarea-event.md)。

### 效果预览

| 首页                                  | 文本显示组件目录                            | 创建文本示例                              |
|-------------------------------------|-------------------------------------|-------------------------------------|
| ![](screenshots/device/image1.jpeg) | ![](screenshots/device/image2.jpeg) | ![](screenshots/device/image3.jpeg) |

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
|   |       |---StyledStringBaselineOffsetStyle.ets  //创建及应用文本基线偏移量对象（BaselineOffsetStyle）示例
|   |       |---StyledStringConvertedToParagraph.ets //支持将属性字符串转换成Paragraph示例
|   |       |---StyledStringDecorationStyle.ets      //创建及应用文本装饰线对象（DecorationStyle）示例
|   |       |---StyledStringGestureStyle.ets
|   |       |---StyledStringHtml.ets
|   |       |---StyledStringHtmlOne.ets              //格式转换场景二示例
|   |       |---StyledStringImageAttachment.ets
|   |       |---StyledStringLetterSpacingStyle.ets   //创建及应用文本字符间距对象（LetterSpacingStyle）示例
|   |       |---StyledStringLineHeightStyle.ets      //创建及应用文本行高对象（LineHeightStyle）示例
|   |       |---StyledStringParagraphStyle.ets
|   |       |---StyledStringParagraphStyleOne.ets    //设置段落样式方法一示例
|   |       |---StyledStringReplaceParagraphStyle.ets  //设置段落样式方法二示例
|   |       |---StyledStringSceneExample.ets
|   |       |---StyledStringStyle.ets
|   |       |---StyledStringTextShadowStyle.ets      //创建及应用文本阴影对象（TextShadowStyle）示例
|   |       |---StyledStringTextStyle.ets            //创建及应用文本字体样式对象（TextStyle）示例
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
|   |---text                                         // 文本显示     
|   |       |---AIMenu.ets
|   |       |---CreatText.ets
|   |       |---CustomTextStyle.ets
|   |       |---index.ets
|   |       |---SelectMenu.ets
|   |       |---TextAddEvent.ets
|   |       |---TextHotSearch.ets
|   |       |---TextSpan.ets
|   |---testInput                                    // 文本输入
|   |       |---AutoFill.ets
|   |       |---CreatTextInput.ets
|   |       |---CursorAvoidance.ets
|   |       |---CustomTextInputStyle.ets
|   |       |---index.ets
|   |       |---KeyboardAvoidance.ets
|   |       |---LoginRegisterPage.ets
|   |       |---SelectMenu.ets
|   |       |---SetOmissionProperty.ets
|   |       |---SetTextInputType.ets
|   |       |---TextInputAddEvent.ets
|---pages
|   |---Index.ets                                    // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                               // 示例代码测试代码
```

## 具体实现

1. 属性字符串（StyledString/MutableStyledString）
   属性字符串StyledString/MutableStyledString（其中MutableStyledString继承自StyledString，下文统称为StyledString），可用于在字符或段落级别上设置文本样式。将StyledString应用到文本组件上，可以采用多种方式修改文本，包括调整字号、添加字体颜色、使文本具备可点击性，以及通过自定义方式绘制文本等。
   属性字符串提供多种类型样式对象，涵盖各种常见的文本样式格式，例如文本装饰线样式、文本行高样式、文本阴影样式等。也可以自行创建CustomSpan，以应用自定义样式。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.0.2.55，镜像版本号：OpenHarmony_6.0.2.55。

3.本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/TextComponent > .git/info/sparse-checkout
git remote add origin https://gitCode.com/openharmony/applications_app_samples.git
git pull origin master
````