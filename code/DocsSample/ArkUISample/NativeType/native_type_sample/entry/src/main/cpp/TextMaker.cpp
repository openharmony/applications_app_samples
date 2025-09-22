/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "TextMaker.h"
#include "baseUtils.h"
#include "manager.h"
#include <arkui/native_interface.h>
#include <arkui/native_type.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <sstream>

#define LOG_TAG "manager"
#define LOG_ERROR(...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0xD001400, LOG_TAG, __VA_ARGS__)
#define VALUE_0 0
#define VALUE_1 1
#define VALUE_30 30
#define VALUE_50 50
#define VALUE_200 200
#define VALUE_300 300
#define VALUE_350 350
#define VALUE_1024 1024

constexpr int32_t ON_ERROR_CODE_DEMO_106107 = 106107; // 参数下标越界
constexpr int32_t ON_ERROR_CODE_DEMO_106109 = 106109; // 不支持返回值

typedef struct {
    ArkUI_NodeHandle textNode;
    ArkUI_NativeNodeAPI_1 *nodeApi;
} FontChangeCtx;

void OnSystemFontChange(ArkUI_SystemFontStyleEvent *event, void *userData)
{
    if (event == nullptr || userData == nullptr) {
        return;
    }
    FontChangeCtx *ctx = (FontChangeCtx *)userData;
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "System font style changed!");
}

static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d", ARKUI_ERROR_CODE_NODE_EVENT_PARAM_INVALID);
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    auto nodeHandler = OH_ArkUI_NodeEvent_GetNodeHandle(event);
    switch (eventId) {
        // 参数下标越界
        case ON_ERROR_CODE_DEMO_106107: {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d",
                ARKUI_ERROR_CODE_NODE_EVENT_PARAM_INDEX_OUT_OF_RANGE);
            return;
        }
        // 不支持返回值
        case ON_ERROR_CODE_DEMO_106109: {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d", ARKUI_ERROR_CODE_NODE_EVENT_NO_RETURN);
            return;
        }
        default:
            break;
        }
}

void setBasicTextVal(ArkUI_NodeHandle &basicText)
{
    const char *textContent =
        "这是一段包含字体样式、字重、对齐方式、不支持复制、超长时跑马灯显示、的文字,以及无障碍文本";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_CONTENT, &contentItem);

    // 字体样式：斜体样式（ARKUI_FONT_STYLE_ITALIC）
    ArkUI_NumberValue fontStyleVal = {.i32 = ARKUI_FONT_STYLE_ITALIC};
    ArkUI_AttributeItem fontStyleItem = {&fontStyleVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_FONT_STYLE, &fontStyleItem);

    // 字重：600（ARKUI_FONT_WEIGHT_W600）
    ArkUI_NumberValue fontWeightVal = {.i32 = ARKUI_FONT_WEIGHT_W600};
    ArkUI_AttributeItem fontWeightItem = {&fontWeightVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_FONT_WEIGHT, &fontWeightItem);

    // 水平对齐：首部对齐（ARKUI_TEXT_ALIGNMENT_START）
    ArkUI_NumberValue hAlignVal = {.i32 = ARKUI_TEXT_ALIGNMENT_START};
    ArkUI_AttributeItem hAlignItem = {&hAlignVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_ALIGN, &hAlignItem);

    // 垂直对齐：基线对齐（ARKUI_TEXT_VERTICAL_ALIGNMENT_BASELINE）
    ArkUI_NumberValue vAlignVal = {.i32 = ARKUI_TEXT_VERTICAL_ALIGNMENT_BASELINE};
    ArkUI_AttributeItem vAlignItem = {&vAlignVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_VERTICAL_ALIGN, &vAlignItem);

    // 文本溢出：跑马灯（ARKUI_TEXT_OVERFLOW_MARQUEE）
    ArkUI_NumberValue overflowVal = {.i32 = ARKUI_TEXT_OVERFLOW_MARQUEE};
    ArkUI_AttributeItem overflowItem = {&overflowVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_OVERFLOW, &overflowItem);

    // 省略位置：行首省略（ARKUI_ELLIPSIS_MODE_START）
    ArkUI_NumberValue ellipsisVal = {.i32 = ARKUI_ELLIPSIS_MODE_START};
    ArkUI_AttributeItem ellipsisItem = {&ellipsisVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_ELLIPSIS_MODE, &ellipsisItem);

    // 复制粘贴：不支持复制（ARKUI_COPY_OPTIONS_NONE / ARKUI_TEXT_COPY_OPTIONS_NONE）
    ArkUI_NumberValue copyOptVal = {.i32 = ARKUI_COPY_OPTIONS_NONE};
    ArkUI_AttributeItem copyOptItem = {&copyOptVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_COPY_OPTION, &copyOptItem);
}

void setBasicText(ArkUI_NodeHandle &textContainer)
{
    // --------------------------基础Text组件（应用文本样式枚举）--------------------------
    auto basicText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = VALUE_200}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = VALUE_30}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_HEIGHT, &textHeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = VALUE_1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText, NODE_BORDER_WIDTH, &borderWidthItem);
    if (basicText != nullptr) {
        setBasicTextVal(basicText);
        // 设置无障碍文本
        ArkUI_AccessibilityValue *accessibilityVal = OH_ArkUI_AccessibilityValue_Create();
        OH_ArkUI_AccessibilityValue_SetText(accessibilityVal, "基础文本组件，包含字体样式和对齐设置");
        const char *a11yItemVal = OH_ArkUI_AccessibilityValue_GetText(accessibilityVal);
        ArkUI_AttributeItem a11yItem = {.string = a11yItemVal};
        Manager::nodeAPI_->setAttribute(basicText, NODE_TEXT_CONTENT, &a11yItem);

        FontChangeCtx *ctx = (FontChangeCtx *)malloc(sizeof(FontChangeCtx));
        if (ctx != nullptr) {
            ctx->textNode = basicText;
            ctx->nodeApi = Manager::nodeAPI_;
            int32_t ret = OH_ArkUI_RegisterSystemFontStyleChangeEvent(basicText, // 目标Text节点
                                                                      ctx,       // 自定义数据（回调中传回）
                                                                      OnSystemFontChange); // 字体变化回调
            if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager",
                             "Register system font event failed, code: %{public}d", ret);
                free(ctx); // 注册失败释放数据
            }
        }
        Manager::nodeAPI_->addChild(textContainer, basicText);
    }
}

void setBasicText1(ArkUI_NodeHandle &textContainer)
{
    //--------------------------第二段text文本-----------------------------------------------------
    auto basicText1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth1[] = {{.f32 = VALUE_350}};
    ArkUI_AttributeItem textWidthItem1 = {.value = textWidth1, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText1, NODE_WIDTH, &textWidthItem1);
    ArkUI_NumberValue borderWidth1[] = {{.f32 = VALUE_1}};
    ArkUI_AttributeItem borderWidthItem1 = {.value = borderWidth1, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText1, NODE_BORDER_WIDTH, &borderWidthItem1);
    if (basicText1 != nullptr) {
        const char *textContent = "this is a egg: case_upper、braeak_normal、max_lines_first ";
        ArkUI_AttributeItem contentItem = {.string = textContent};
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_CONTENT, &contentItem);

        // 文本大小写：（ARKUI_TEXT_CASE_UPPER）
        ArkUI_NumberValue textCaseVal = {.i32 = ARKUI_TEXT_CASE_UPPER};
        ArkUI_AttributeItem textCaseItem = {&textCaseVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_CASE, &textCaseItem);
    
        // 断行规则：CJK任意断行（ARKUI_WORD_BREAK_NORMAL）
        ArkUI_NumberValue wordBreakVal = {.i32 = ARKUI_WORD_BREAK_NORMAL};
        ArkUI_AttributeItem wordBreakItem = {&wordBreakVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_WORD_BREAK, &wordBreakItem);

        // 自适应高度：MaxLines优先（ARKUI_TEXT_HEIGHT_ADAPTIVE_POLICY_MAX_LINES_FIRST）
        ArkUI_NumberValue adaptPolicyVal = {.i32 = ARKUI_TEXT_HEIGHT_ADAPTIVE_POLICY_MAX_LINES_FIRST};
        ArkUI_AttributeItem adaptPolicyItem = {&adaptPolicyVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_HEIGHT_ADAPTIVE_POLICY, &adaptPolicyItem);

        // 装饰线：下划线（ARKUI_TEXT_DECORATION_TYPE_UNDERLINE）
        ArkUI_NumberValue decoTypeVal = {.i32 = ARKUI_TEXT_DECORATION_TYPE_UNDERLINE};
        ArkUI_NumberValue decoStyleVal = {.i32 = ARKUI_TEXT_DECORATION_STYLE_SOLID};
        ArkUI_AttributeItem decoTypeItem = {&decoTypeVal, VALUE_1};
        ArkUI_AttributeItem decoStyleItem = {&decoStyleVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_DECORATION, &decoTypeItem);
        Manager::nodeAPI_->setAttribute(basicText1, NODE_TEXT_DECORATION, &decoStyleItem);

        // 添加到容器
        Manager::nodeAPI_->addChild(textContainer, basicText1);
    }
}

void setBasicText2(ArkUI_NodeHandle &textContainer)
{
    //--------------------------第三段text文本-----------------------------------------------------
    auto basicText2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth2[] = {{.f32 = VALUE_350}};
    ArkUI_AttributeItem textWidthItem2 = {.value = textWidth2, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText2, NODE_WIDTH, &textWidthItem2);
    ArkUI_NumberValue textHeight1[] = {{.f32 = VALUE_50}};
    ArkUI_AttributeItem textHeight1Item = {.value = textHeight1, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText2, NODE_HEIGHT, &textHeight1Item);
    ArkUI_NumberValue borderWidth2[] = {{.f32 = VALUE_1}};
    ArkUI_AttributeItem borderWidthItem2 = {.value = borderWidth2, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText2, NODE_BORDER_WIDTH, &borderWidthItem2);

    // 设置文本识别
    ArkUI_NumberValue enableDataDetector = {.i32 = true};
    ArkUI_AttributeItem enableDataDetectorItem = {.value = &enableDataDetector, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(basicText2, NODE_TEXT_ENABLE_DATA_DETECTOR, &enableDataDetectorItem);
    ArkUI_NumberValue detectorConfig = {.i32 = ARKUI_TEXT_DATA_DETECTOR_TYPE_PHONE_NUMBER};
    ArkUI_AttributeItem detectorConfigItem = {.value = &detectorConfig, .size = 2};
    Manager::nodeAPI_->setAttribute(basicText2, NODE_TEXT_ENABLE_DATA_DETECTOR_CONFIG, &detectorConfigItem);

    auto testText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    const char *testTextStr = "测试ARKUI_ERROR_CODE_INVALID_STYLED_STRING";
    ArkUI_AttributeItem testTextItem = {.string = testTextStr};
    Manager::nodeAPI_->setAttribute(testText, NODE_TEXT_CONTENT, &testTextItem);
    Manager::nodeAPI_->addChild(textContainer, testText);
    // 序列化过程中返回空值，会打印ARKUI_ERROR_CODE_INVALID_STYLED_STRING的值
    if (basicText2 != nullptr) {
        ArkUI_StyledString_Descriptor *descriptor = OH_ArkUI_StyledString_Descriptor_Create();
        uint8_t buffer[VALUE_1024] = {VALUE_0};
        size_t resultSize = VALUE_0;
        // 序列化  字节数组
        int32_t marshalResult =
            OH_ArkUI_MarshallStyledStringDescriptor(buffer, sizeof(buffer), descriptor, &resultSize);
        if (marshalResult != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "序列化失败%{public}d", marshalResult);
        } else if (marshalResult == ARKUI_ERROR_CODE_INVALID_STYLED_STRING) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "无效的属性字符串错误码%{public}d", marshalResult);
        }
        const char *invalidA11yText = "序列化过程中返回值为空";
        ArkUI_AttributeItem a11yItem = {.string = invalidA11yText};
        int32_t setA11yRet = Manager::nodeAPI_->setAttribute(basicText2, NODE_TEXT_CONTENT, &a11yItem);

        Manager::nodeAPI_->addChild(textContainer, basicText2);
    }
}

void setBasicInputText(ArkUI_NodeHandle &textContainer)
{
    // --------------------------TextInput组件（单行输入框）--------------------------
    auto inputText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    const char *inputTextStr = "单行输入框：输入框风格只支持InputType.Normal，回车newline";
    ArkUI_AttributeItem inputTextItem = {.string = inputTextStr};
    Manager::nodeAPI_->setAttribute(inputText, NODE_TEXT_CONTENT, &inputTextItem);
    Manager::nodeAPI_->addChild(textContainer, inputText);
    auto textInput = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_INPUT);
    if (textInput != nullptr) {
        // 输入类型：基本模式（ARKUI_TEXTINPUT_TYPE_NORMAL）
        ArkUI_NumberValue inputTypeVal = {.i32 = ARKUI_TEXTINPUT_TYPE_NORMAL};
        ArkUI_AttributeItem inputTypeItem = {&inputTypeVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textInput, NODE_TEXT_INPUT_TYPE, &inputTypeItem);

        // 回车键类型
        ArkUI_NumberValue enterKeyVal = {.i32 = ARKUI_ENTER_KEY_TYPE_NEW_LINE};
        ArkUI_AttributeItem enterKeyItem = {&enterKeyVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textInput, NODE_TEXT_INPUT_ENTER_KEY_TYPE, &enterKeyItem);

        // 自动填充类型
        ArkUI_NumberValue autoFillVal = {.i32 = ARKUI_TEXTINPUT_CONTENT_TYPE_USER_NAME};
        ArkUI_AttributeItem autoFillItem = {&autoFillVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textInput, NODE_TEXT_INPUT_CONTENT_TYPE, &autoFillItem);

        // 输入框风格
        ArkUI_NumberValue inputStyleVal = {.i32 = ARKUI_TEXTINPUT_STYLE_INLINE};
        ArkUI_AttributeItem inputStyleItem = {&inputStyleVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textInput, NODE_TEXT_INPUT_STYLE, &inputStyleItem);

        // 键盘样式
        ArkUI_NumberValue keyboardStyleVal = {.i32 = ARKUI_KEYBOARD_APPEARANCE_DARK_IMMERSIVE};
        ArkUI_AttributeItem keyboardStyleItem = {&keyboardStyleVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textInput, NODE_TEXT_INPUT_KEYBOARD_APPEARANCE, &keyboardStyleItem);

        // 添加到容器
        Manager::nodeAPI_->addChild(textContainer, textInput);
    }
    auto textInput2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_INPUT);
    // 清除按钮
    ArkUI_NumberValue cancelButton[] = {{.i32 = ARKUI_CANCELBUTTON_STYLE_CONSTANT}};
    ArkUI_AttributeItem cancelButtonItem = {cancelButton, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_CANCEL_BUTTON, &cancelButtonItem);
    Manager::nodeAPI_->addChild(textContainer, textInput2);
}

void setBasicAreaText(ArkUI_NodeHandle &textContainer)
{
    // --------------------------TextArea组件（多行输入框，应用多行输入枚举）--------------------------
    auto areaText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    const char *areaTextStr = "多行输入框：基本模式";
    ArkUI_AttributeItem areaTextItem = {.string = areaTextStr};
    Manager::nodeAPI_->setAttribute(areaText, NODE_TEXT_CONTENT, &areaTextItem);
    Manager::nodeAPI_->addChild(textContainer, areaText);
    auto textArea = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_AREA);
    if (textArea != nullptr) {
        // 多行输入类型：基本模式（ARKUI_TEXTAREA_TYPE_NORMAL）
        ArkUI_NumberValue textAreaTypeVal = {.i32 = ARKUI_TEXTAREA_TYPE_NORMAL};
        ArkUI_NumberValue textAreaTypeVal1 = {.u32 = 0xFFFF0000};
        ArkUI_AttributeItem textAreaTypeItem = {&textAreaTypeVal, VALUE_1};
        Manager::nodeAPI_->setAttribute(textArea, NODE_TEXT_AREA_TYPE, &textAreaTypeItem);
        // 添加到容器
        Manager::nodeAPI_->addChild(textContainer, textArea);
    }
}

void setCustomSpanText(ArkUI_NodeHandle &textContainer)
{
    // -------------------------自定义段落组件（应用CustomSpan相关结构体及函数）--------------------------
    auto customSpanText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    const char *customSpanTextStr = "自定义段落组件：";
    ArkUI_AttributeItem customSpanTextItem = {.string = customSpanTextStr};
    Manager::nodeAPI_->setAttribute(customSpanText, NODE_TEXT_CONTENT, &customSpanTextItem);
    Manager::nodeAPI_->addChild(textContainer, customSpanText);
    // 创建自定义段落测量信息
    ArkUI_CustomSpanMeasureInfo *measureInfo = OH_ArkUI_CustomSpanMeasureInfo_Create();
    if (measureInfo != nullptr) {
        // 获取父Text组件字体大小（模拟场景）
        float parentFontSize = OH_ArkUI_CustomSpanMeasureInfo_GetFontSize(measureInfo);

        // 创建自定义段落度量指标
        ArkUI_CustomSpanMetrics *metrics = OH_ArkUI_CustomSpanMetrics_Create();
        // 设置自定义段落宽度（200vp）、高度（30vp）
        int32_t setWidthRet = OH_ArkUI_CustomSpanMetrics_SetWidth(metrics, 200.0f);
        int32_t setHeightRet = OH_ArkUI_CustomSpanMetrics_SetHeight(metrics, 30.0f);
        if (setWidthRet == ARKUI_ERROR_CODE_NO_ERROR && setHeightRet == ARKUI_ERROR_CODE_NO_ERROR) {
            // 创建自定义段落绘制信息
            ArkUI_CustomSpanDrawInfo *drawInfo = OH_ArkUI_CustomSpanDrawInfo_Create();
            if (drawInfo != nullptr) {
                // 获取绘制偏移量、边距等信息
                float xOffset = OH_ArkUI_CustomSpanDrawInfo_GetXOffset(drawInfo);
                float lineTop = OH_ArkUI_CustomSpanDrawInfo_GetLineTop(drawInfo);
                float lineBottom = OH_ArkUI_CustomSpanDrawInfo_GetLineBottom(drawInfo);
                float baseline = OH_ArkUI_CustomSpanDrawInfo_GetBaseline(drawInfo);
            }
            // 基于自定义信息创建Text组件（模拟自定义段落渲染）
            auto customSpanText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
            if (customSpanText != nullptr) {
                const char *customText = "自定义段落组件：宽度200vp，高度30vp";
                ArkUI_AttributeItem customTextItem = {.string = customText};
                Manager::nodeAPI_->setAttribute(customSpanText, NODE_TEXT_CONTENT, &customTextItem);
                Manager::nodeAPI_->addChild(textContainer, customSpanText);
            }
            // 销毁绘制信息
            OH_ArkUI_CustomSpanDrawInfo_Dispose(drawInfo);
            }
            // 销毁度量指标
        OH_ArkUI_CustomSpanMetrics_Dispose(metrics);
        // 销毁测量信息
        OH_ArkUI_CustomSpanMeasureInfo_Dispose(measureInfo);
    }
}

void setSpanText(ArkUI_NodeHandle &textContainer)
{
    auto SpanText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle imageSpan = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE_SPAN);
    ArkUI_AttributeItem spanUrl = {.string = "/resources/base/media/background.png"};
    ArkUI_NumberValue widthVal[VALUE_1]{};
    widthVal[VALUE_0].f32 = 30.f;
    ArkUI_AttributeItem width = {.value = widthVal, .size = VALUE_1};
    ArkUI_NumberValue heightVal[VALUE_1]{};
    heightVal[VALUE_0].f32 = 30.f;
    ArkUI_AttributeItem height = {.value = heightVal, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_WIDTH, &width);
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_HEIGHT, &height);
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_SRC, &spanUrl);
    ArkUI_NumberValue imageSpanVal = {.i32 = ARKUI_IMAGE_SPAN_ALIGNMENT_BASELINE};
    ArkUI_AttributeItem imageSpanValItem = {&imageSpanVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_VERTICAL_ALIGNMENT, &imageSpanValItem);
    Manager::nodeAPI_->addChild(SpanText, imageSpan);
    Manager::nodeAPI_->addChild(textContainer, SpanText);
}

ArkUI_NodeHandle TextMaker::createTextPage()
{
// 创建父容器column
    ArkUI_NodeHandle textContainer = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = VALUE_300}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(textContainer, NODE_WIDTH, &widthItem);
    setBasicText(textContainer);
    setBasicText1(textContainer);
    setBasicText2(textContainer);
    OnEventReceive(nullptr);
    setBasicInputText(textContainer);
    setBasicAreaText(textContainer);
    setCustomSpanText(textContainer);
    setSpanText(textContainer);
    return textContainer;
}