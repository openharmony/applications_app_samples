/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include "TextEditorMaker.h"
#include "baseUtils.h"
#include <arkui/styled_string.h>
#include <cstdint>
#include <hilog/log.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <resourcemanager/ohresmgr.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

#define LOG_TAG "TextEditorMaker"
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, LOG_TAG, __VA_ARGS__)

namespace {
// ===== 常量定义 =====
constexpr int32_t SIZE_1 = 1;
constexpr int32_t SIZE_4 = 4;
constexpr float COLUMN_WIDTH = 400.0f;
constexpr float PLACEHOLDER_FONT_SIZE = 10.0f;
constexpr float TITLE_FONT_SIZE = 10.0f;
constexpr uint32_t PLACEHOLDER_FONT_WEIGHT = 1;
constexpr float TEXT_EDITOR_BORDER_WIDTH = 1.0f;
constexpr float TEXT_EDITOR_WIDTH = 300.0f;
constexpr uint32_t COLOR_RED = 0xFFFF0000;
constexpr float TOP_MARGIN = 20.0f;
constexpr float BOTTOM_MARGIN = 5.0f;
}  // namespace

#define EVENT_ON_SELECTION_CHANGE 1
#define EVENT_ON_READY 2
#define EVENT_ON_PASTE 3
#define EVENT_ON_COPY 4
#define EVENT_ON_EDITING_CHANGE 5
#define EVENT_ON_SUBMIT 6
#define EVENT_ON_CUT 7
#define BTN_GET_CARET_OFFSET 8
#define BTN_SET_CARET_OFFSET 9
#define BTN_SET_TYPING_STYLE 10
#define BTN_GET_TYPING_STYLE 11
#define BTN_SET_TYPING_PARAGRAPH_STYLE 12
#define BTN_SET_SELECTION 13
#define BTN_IS_EDITING 14
#define BTN_STOP_EDITING 15
#define BTN_LAYOUT_MANAGER_LINE_COUNT 16
#define BTN_LAYOUT_MANAGER_RECTS_FOR_RANGE 17
#define BTN_LAYOUT_MANAGER_GLYPH_POS 18
#define BTN_LAYOUT_MANAGER_LINE_METRICS 19
#define BTN_PREVIEW_TEXT 20
#define BTN_DELETE_BACKWARD 21

static ArkUI_NodeHandle textContainer;

/**
 * @brief 添加文本编辑器编辑器的占位符
 * @param textEditor 文本编辑器编辑器节点
 * @param value 占位的内容
 */
void addPlaceHolder(ArkUI_NodeHandle& textEditor, const char* value)
{
    OH_ArkUI_TextEditorPlaceholderOptions* options = OH_ArkUI_TextEditorPlaceholderOptions_Create();
    OH_ArkUI_TextEditorPlaceholderOptions_SetValue(options, value);
    OH_ArkUI_TextEditorPlaceholderOptions_SetFontSize(options, PLACEHOLDER_FONT_SIZE);
    OH_ArkUI_TextEditorPlaceholderOptions_SetFontWeight(options, PLACEHOLDER_FONT_WEIGHT);
    ArkUI_AttributeItem menuOptionItem = {.object = options};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_PLACEHOLDER, &menuOptionItem);
}

/**
 * 初始化文本编辑器编辑器节点
 * @return 返回创建的文本编辑器编辑器节点句柄
 */
ArkUI_NodeHandle initTextEditor()
{
    ArkUI_NodeHandle textEditor = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_EDITOR);
    ArkUI_NumberValue borderWidth = {.f32 = TEXT_EDITOR_BORDER_WIDTH};
    ArkUI_AttributeItem borderWidthItem = {&borderWidth, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_NumberValue width = {.f32 = TEXT_EDITOR_WIDTH};
    ArkUI_AttributeItem widthItem = {&width, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_WIDTH, &widthItem);
    // 将文本编辑器编辑器添加到父容器中
    Manager::nodeAPI_->addChild(textContainer, textEditor);
    return textEditor;
}

/**
 * @brief 设置文本标题
 * @param title 文本标题内容
 */
void setTextTitle(const char* title)
{
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue topMargin = {.f32 = TOP_MARGIN};
    ArkUI_NumberValue bottomMargin = {.f32 = BOTTOM_MARGIN};
    ArkUI_NumberValue noMargin = {.f32 = 0};
    ArkUI_NumberValue marginValue[] = {topMargin, noMargin, bottomMargin, noMargin};
    ArkUI_AttributeItem marginItem = {marginValue, SIZE_4};
    Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue width = {.f32 = TEXT_EDITOR_WIDTH};
    ArkUI_AttributeItem widthItem = {&width, SIZE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue fontSize = {.f32 = TITLE_FONT_SIZE};
    ArkUI_AttributeItem fontSizeItem = {&fontSize, SIZE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_AttributeItem contentItem = {.string = title};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &contentItem);
    // 将标题的文本节点添加到父容器中
    Manager::nodeAPI_->addChild(textContainer, text);
}

/**
 * @brief 设置文本编辑器颜色相关属性
 */
void setTextEditorColor()
{
    setTextTitle("回车键(搜索)  光标颜色(红)  滚动条颜色(红)  选中背景色(红)  最大行数(4)  拖拽背景色(红)");
    ArkUI_NodeHandle textEditor = initTextEditor();
    // 设置EnterKeyType为SEARCH
    ArkUI_NumberValue enterKeyType = {.i32 = ARKUI_ENTER_KEY_TYPE_SEARCH};
    ArkUI_AttributeItem enterKeyTypeItem = {&enterKeyType, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENTER_KEY_TYPE, &enterKeyTypeItem);
    // 设置光标颜色
    ArkUI_NumberValue caretColor = {.u32 = COLOR_RED};
    ArkUI_AttributeItem caretColorItem = {&caretColor, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_CARET_COLOR, &caretColorItem);
    // 设置滚动条颜色
    ArkUI_NumberValue scrollBarColor = {.u32 = COLOR_RED};
    ArkUI_AttributeItem scrollBarColorItem = {&scrollBarColor, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_SCROLL_BAR_COLOR, &scrollBarColorItem);
    // 设置选中区域背景色
    ArkUI_NumberValue backgroundColor = {.u32 = COLOR_RED};
    ArkUI_AttributeItem backgroundColorItem = {&backgroundColor, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_SELECTED_BACKGROUND_COLOR, &backgroundColorItem);
    // 设置最大行数
    ArkUI_NumberValue maxLines = {.i32 = 4};
    ArkUI_AttributeItem maxLinesItem = {&maxLines, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_MAX_LINES, &maxLinesItem);
    // 设置拖拽背板颜色
    ArkUI_SelectedDragPreviewStyle* selectedDragPreviewStyle = OH_ArkUI_SelectedDragPreviewStyle_Create();
    OH_ArkUI_SelectedDragPreviewStyle_SetColor(selectedDragPreviewStyle, COLOR_RED);
    ArkUI_AttributeItem dragPreviewStyleItem = {.size = 1, .object = selectedDragPreviewStyle};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_SELECTED_DRAG_PREVIEW_STYLE, &dragPreviewStyleItem);
    OH_ArkUI_SelectedDragPreviewStyle_Dispose(selectedDragPreviewStyle);
}

/**
 * @brief 设置文本编辑器实体识别相关属性
 */
void setTextEditorDetector()
{
    setTextTitle("AI实体识别");
    ArkUI_NodeHandle textEditor = initTextEditor();
    // 设置实体识别开关
    ArkUI_NumberValue enableDataDetector = {.i32 = true};
    ArkUI_AttributeItem enableDataDetectorItem = {&enableDataDetector, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENABLE_DATA_DETECTOR, &enableDataDetectorItem);
    // 设置实体识别装饰线样式
    OH_ArkUI_DecorationStyleOptions* decorationStyle = OH_ArkUI_DecorationStyleOptions_Create();
    OH_ArkUI_DecorationStyleOptions_SetTextDecorationType(
        decorationStyle, ArkUI_TextDecorationType::ARKUI_TEXT_DECORATION_TYPE_LINE_THROUGH);
    OH_ArkUI_DecorationStyleOptions_SetColor(decorationStyle, COLOR_RED);
    OH_ArkUI_DecorationStyleOptions_SetTextDecorationStyle(
        decorationStyle, ArkUI_TextDecorationStyle::ARKUI_TEXT_DECORATION_STYLE_DOTTED);
    OH_ArkUI_DecorationStyleOptions_SetThicknessScale(decorationStyle, 2.0f);
    // 设置实体识别内容范围
    OH_ArkUI_TextDataDetectorConfig* dataDetectorConfig = OH_ArkUI_TextDataDetectorConfig_Create();
    ArkUI_TextDataDetectorType* types = new ArkUI_TextDataDetectorType[2];
    types[0] = ArkUI_TextDataDetectorType::ARKUI_TEXT_DATA_DETECTOR_TYPE_PHONE_NUMBER;
    types[1] = ArkUI_TextDataDetectorType::ARKUI_TEXT_DATA_DETECTOR_TYPE_ADDRESS;
    // 设置实体识别内容样式
    OH_ArkUI_TextDataDetectorConfig_SetTypes(dataDetectorConfig, types, 2);
    OH_ArkUI_TextDataDetectorConfig_SetColor(dataDetectorConfig, 0xFF0000FF);
    OH_ArkUI_TextDataDetectorConfig_SetDecorationStyleOptions(dataDetectorConfig, decorationStyle);
    OH_ArkUI_TextDataDetectorConfig_SetEnablePreviewMenu(dataDetectorConfig, true);
    // 设置实体识别内容回调
    OH_ArkUI_TextDataDetectorConfig_RegisterOnDetectResultUpdateCallback(
        dataDetectorConfig, nullptr, [](const char* result, int32_t length, void* userData) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "OnDetectResultUpdateCallback %{public}s %{public}d", result, length);
        });
    ArkUI_AttributeItem dataDetectorConfigItem = {.size = 2, .object = dataDetectorConfig};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_DATA_DETECTOR_CONFIG, &dataDetectorConfigItem);
    OH_ArkUI_DecorationStyleOptions_Destroy(decorationStyle);
    OH_ArkUI_TextDataDetectorConfig_Destroy(dataDetectorConfig);
    // 设置选中内容AI实体菜单开关
    ArkUI_NumberValue enableSelectedDataDetector = {.i32 = true};
    ArkUI_AttributeItem enableSelectedDataDetectorItem = {&enableSelectedDataDetector, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENABLE_SELECTED_DATA_DETECTOR,
                                    &enableSelectedDataDetectorItem);
}

/**
 * @brief 设置文本编辑器单行模式
 */
void setTextEditorSingleLine()
{
    setTextTitle("单行模式");
    ArkUI_NodeHandle textEditor = initTextEditor();
    ArkUI_NumberValue singleLine = {.i32 = true};
    ArkUI_AttributeItem singleLineItem = {&singleLine, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_SINGLE_LINE, &singleLineItem);
}

/**
 * @brief 设置文本编辑器样式相关属性
 */
void setTextEditorStyle()
{
    setTextTitle("autoSpacing(True)  fontPadding(True)  lineSpacing(True)  符号压缩(True)");
    ArkUI_NodeHandle textEditor = initTextEditor();
    // 配置enableAutoSpacing
    ArkUI_NumberValue enableAutoSpacing = {.i32 = true};
    ArkUI_AttributeItem enableAutoSpacingItem = {&enableAutoSpacing, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENABLE_AUTO_SPACING, &enableAutoSpacingItem);
    // 配置includeFontPadding
    ArkUI_NumberValue fontPadding = {.i32 = true};
    ArkUI_AttributeItem fontPaddingItem = {&fontPadding, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_INCLUDE_FONT_PADDING, &fontPaddingItem);
    // 配置fallbackLineSpacing
    ArkUI_NumberValue lineSpacing = {.i32 = true};
    ArkUI_AttributeItem lineSpacingItem = {&lineSpacing, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_FALLBACK_LINE_SPACING, &lineSpacingItem);
    // 配置compressLeadingPunctuation
    ArkUI_NumberValue compressLeadingPunctuation = {.i32 = true};
    ArkUI_AttributeItem compressLeadingPunctuationItem = {&compressLeadingPunctuation, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_COMPRESS_LEADING_PUNCTUATION,
                                    &compressLeadingPunctuationItem);
}

/**
 * @brief 设置文本编辑器自定义键盘
 */
void setTextEditorCustomKeyboard()
{
    setTextTitle("自定义键盘");
    ArkUI_NodeHandle textEditor = initTextEditor();
    // 构造一个Button作为自定义键盘
    auto button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue buttonHeightValue{.f32 = 300};
    ArkUI_AttributeItem heightItem = {&buttonHeightValue, 1};
    Manager::nodeAPI_->setAttribute(button, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue customKeyboardValue[] = {{.i32 = true}};
    ArkUI_AttributeItem customKeyboard = {customKeyboardValue, sizeof(customKeyboardValue) / sizeof(ArkUI_NumberValue)};
    customKeyboard.object = button;
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_CUSTOM_KEYBOARD, &customKeyboard);
}

/**
 * @brief 设置文本编辑器自定义菜单
 */
void setTextEditorSelectionMenu()
{
    setTextTitle("自定义菜单");
    ArkUI_NodeHandle textEditor = initTextEditor();
    OH_ArkUI_TextEditorSelectionMenuOptions* menuOptions = OH_ArkUI_TextEditorSelectionMenuOptions_Create();
    // 设置菜单交互属性
    OH_ArkUI_TextEditorSelectionMenuOptions_SetSpanType(menuOptions,
                                                        OH_ArkUI_TextEditorSpanType::OH_ARKUI_TEXT_EDITOR_SPAN_TYPE_TEXT);
    OH_ArkUI_TextEditorSelectionMenuOptions_SetResponseType(
        menuOptions, OH_ArkUI_TextEditorResponseType::OH_ARKUI_TEXT_EDITOR_RESPONSE_TYPE_LONG_PRESS);
    OH_ArkUI_TextEditorSelectionMenuOptions_SetMenuType(menuOptions, OH_ArkUI_TextMenuType::OH_ARKUI_TEXT_EDITOR_PREVIEW_MENU);
    OH_ArkUI_TextEditorSelectionMenuOptions_SetHapticFeedbackMode(
        menuOptions, ArkUI_HapticFeedbackMode::ARKUI_HAPTIC_FEEDBACK_MODE_AUTO);
    // 构造菜单主体
    ArkUI_NodeHandle menuRoot = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue menuRootWidthValue[] = {{.f32 = 100}};
    ArkUI_AttributeItem menuRootWidthItem = {.value = menuRootWidthValue, .size = 1};
    Manager::nodeAPI_->setAttribute(menuRoot, NODE_WIDTH, &menuRootWidthItem);
    ArkUI_NumberValue menuRootHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem menuHeightItem = {.value = menuRootHeightValue, .size = 1};
    Manager::nodeAPI_->setAttribute(menuRoot, NODE_HEIGHT, &menuHeightItem);
    ArkUI_NumberValue menuBkValue[] = {{.u32 = COLOR_RED}};
    ArkUI_AttributeItem menuBk = {.value = menuBkValue, .size = 1};
    Manager::nodeAPI_->setAttribute(menuRoot, NODE_BACKGROUND_COLOR, &menuBk);
    // 构造菜单内容
    ArkUI_NodeHandle menuText = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue menuTextWidthValue[] = {{.f32 = 100}};
    ArkUI_AttributeItem menuTextWidthItem = {.value = menuTextWidthValue, .size = 1};
    Manager::nodeAPI_->setAttribute(menuText, NODE_WIDTH, &menuTextWidthItem);
    ArkUI_NumberValue menuTextHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem menuTextHeightItem = {.value = menuTextHeightValue, .size = 1};
    Manager::nodeAPI_->setAttribute(menuText, NODE_HEIGHT, &menuTextHeightItem);
    ArkUI_AttributeItem menuTextContent = {.string = "我是长按自定义菜单中的文本"};
    Manager::nodeAPI_->setAttribute(menuText, NODE_TEXT_CONTENT, &menuTextContent);
    Manager::nodeAPI_->addChild(menuRoot, menuText);
    OH_ArkUI_TextEditorSelectionMenuOptions_SetContentNode(menuOptions, menuRoot);
    // 设置菜单相关回调
    char* menuShowData = "menu show data";
    OH_ArkUI_TextEditorSelectionMenuOptions_RegisterOnMenuShowCallback(
        menuOptions, reinterpret_cast<void*>(menuShowData), [](int32_t start, int32_t end, void* userData) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "MenuShow %{public}d, %{public}d, userData: %{public}s", start, end,
                         reinterpret_cast<char*>(userData));
        });
    char* menuHideData = "menu hide data";
    OH_ArkUI_TextEditorSelectionMenuOptions_RegisterOnMenuHideCallback(
        menuOptions, reinterpret_cast<void*>(menuHideData), [](int32_t start, int32_t end, void* userData) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "MenuHide %{public}d, %{public}d, userData: %{public}s", start, end,
                         reinterpret_cast<char*>(userData));
        });
    char* menuAppearData = "menu appear data";
    OH_ArkUI_TextEditorSelectionMenuOptions_RegisterOnMenuAppearCallback(
        menuOptions, reinterpret_cast<void*>(menuAppearData), [](int32_t start, int32_t end, void* userData) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "MenuAppear %{public}d, %{public}d, userData: %{public}s", start, end,
                         reinterpret_cast<char*>(userData));
        });
    char* menuDisappearData = "menu disappear data";
    OH_ArkUI_TextEditorSelectionMenuOptions_RegisterOnMenuDisappearCallback(
        menuOptions, reinterpret_cast<void*>(menuDisappearData), [](void* userData) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "TextEditorMaker", "MenuDisappear, userData: %{public}s",
                         reinterpret_cast<char*>(userData));
        });

    ArkUI_AttributeItem textBindSelectionItem = {.object = menuOptions};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_BIND_SELECTION_MENU, &textBindSelectionItem);
    // 销毁内存占用
    OH_ArkUI_TextEditorSelectionMenuOptions_Destroy(menuOptions);
}

/**
 * @brief 设置文本编辑器部分属性
 */
void setTextEditorOther()
{
    setTextTitle(
        "高度(40)  最大字数(40)  滚动条(OFF)  键盘(DARK)  复制(NONE)  振动(开)  禁止返回(开) 提示文本（提示文本）");
    ArkUI_NodeHandle textEditor = initTextEditor();
    addPlaceHolder(textEditor, "提示文本");
    // 设置组件高度
    ArkUI_NumberValue height = {40};
    ArkUI_AttributeItem heightItem = {&height, 1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_HEIGHT, &heightItem);
    // 设置最大字数
    ArkUI_NumberValue maxLength = {.i32 = 40};
    ArkUI_AttributeItem maxLengthItem = {&maxLength, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_MAX_LENGTH, &maxLengthItem);
    // 设置滚动条状态
    ArkUI_NumberValue barState = {.i32 = ARKUI_BAR_STATE_OFF};
    ArkUI_AttributeItem barStateItem = {&barState, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_BAR_STATE, &barStateItem);
    // 设置键盘属性
    ArkUI_NumberValue keyboardAppearance = {.i32 = ARKUI_KEYBOARD_APPEARANCE_DARK_IMMERSIVE};
    ArkUI_AttributeItem keyboardAppearanceItem = {&keyboardAppearance, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_KEYBOARD_APPEARANCE, &keyboardAppearanceItem);
    // 设置复制选项
    ArkUI_NumberValue copyOptions = {.i32 = ARKUI_COPY_OPTIONS_NONE};
    ArkUI_AttributeItem copyOptionsItem = {&copyOptions, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_COPY_OPTIONS, &copyOptionsItem);
    // 设置振动开关
    ArkUI_NumberValue hapticFeedback = {.i32 = true};
    ArkUI_AttributeItem hapticFeedbackItem = {&hapticFeedback, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENABLE_HAPTIC_FEEDBACK, &hapticFeedbackItem);
    // 设置阻止返回
    ArkUI_NumberValue stopBackPress = {.i32 = true};
    ArkUI_AttributeItem stopBackPressItem = {&stopBackPress, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_STOP_BACK_PRESS, &stopBackPressItem);
    // 设置获焦是否拉起键盘
    ArkUI_NumberValue keyboardOnFocus = {.i32 = true};
    ArkUI_AttributeItem keyboardOnFocusItem = {&keyboardOnFocus, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_ENABLE_KEYBOARD_ON_FOCUS, &keyboardOnFocusItem);
}

/**
 * 向界面中添加一个按钮，并关联按钮的回调事件
 * @param btnContent 按钮显示的文本内容
 * @param eventId 按钮点击事件ID
 * @param controller 属性字符串的控制器
 */
void addButton(char* btnContent, int32_t eventId, ArkUI_TextEditorStyledStringController* controller)
{
    ArkUI_NumberValue widthValue[] = {{.f32 = 100}};
    ArkUI_AttributeItem widthItem = {.value = widthValue, .size = 1};
    ArkUI_NumberValue heightValue[] = {{.f32 = 40}};
    ArkUI_AttributeItem heightItem = {.value = heightValue, .size = 1};
    // 新建按钮
    ArkUI_NodeHandle btn = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    Manager::nodeAPI_->setAttribute(btn, NODE_WIDTH, &widthItem);
    Manager::nodeAPI_->setAttribute(btn, NODE_HEIGHT, &heightItem);
    ArkUI_AttributeItem btnTextItem = {.string = btnContent};
    Manager::nodeAPI_->setAttribute(btn, NODE_BUTTON_LABEL, &btnTextItem);
    // 关联按钮对应回调事件
    Manager::nodeAPI_->registerNodeEvent(btn, NODE_ON_CLICK_EVENT, eventId, controller);
    Manager::nodeAPI_->addChild(textContainer, btn);
}

/**
 * 设置输入样式
 * @param controller 属性字符串的控制器
 */
void setTypingStyle(ArkUI_TextEditorStyledStringController* controller)
{
    OH_ArkUI_TextEditorTextStyle* textStyle = OH_ArkUI_TextEditorTextStyle_Create();
    OH_ArkUI_TextEditorTextStyle_SetFontColor(textStyle, COLOR_RED);
    OH_ArkUI_TextEditorTextStyle_SetFontSize(textStyle, 20);
    OH_ArkUI_TextEditorTextStyle_SetFontStyle(textStyle, ArkUI_FontStyle::ARKUI_FONT_STYLE_ITALIC);
    OH_ArkUI_TextEditorTextStyle_SetFontWeight(textStyle, 1);
    OH_ArkUI_TextEditorTextStyle_SetFontFamily(textStyle, "aaaaaaaa");

    OH_ArkUI_DecorationStyleOptions* decoration = OH_ArkUI_DecorationStyleOptions_Create();
    OH_ArkUI_DecorationStyleOptions_SetTextDecorationType(
        decoration, ArkUI_TextDecorationType::ARKUI_TEXT_DECORATION_TYPE_UNDERLINE);
    OH_ArkUI_DecorationStyleOptions_SetColor(decoration, 0xFF00FFFF);
    OH_ArkUI_DecorationStyleOptions_SetTextDecorationStyle(
        decoration, ArkUI_TextDecorationStyle::ARKUI_TEXT_DECORATION_STYLE_DOUBLE);
    OH_ArkUI_DecorationStyleOptions_SetThicknessScale(decoration, 2);
    OH_ArkUI_TextEditorTextStyle_SetDecoration(textStyle, decoration);

    auto shadow = OH_ArkUI_ShadowOptions_Create();
    OH_ArkUI_ShadowOptions_SetRadius(shadow, 5);
    OH_ArkUI_ShadowOptions_SetType(shadow, ArkUI_ShadowType::ARKUI_SHADOW_TYPE_BLUR);
    OH_ArkUI_ShadowOptions_SetColor(shadow, 0xFF0000FF);
    OH_ArkUI_ShadowOptions_SetOffsetX(shadow, 1);
    OH_ArkUI_ShadowOptions_SetOffsetY(shadow, 2);
    OH_ArkUI_ShadowOptions_SetFill(shadow, true);
    const OH_ArkUI_ShadowOptions* shadows[] = {shadow};
    OH_ArkUI_TextEditorTextStyle_SetTextShadows(textStyle, shadows, 1);

    OH_ArkUI_TextEditorTextStyle_SetLineHeight(textStyle, 10);
    OH_ArkUI_TextEditorTextStyle_SetLetterSpacing(textStyle, 9);
    OH_ArkUI_TextEditorTextStyle_SetFontFeature(textStyle, "\"ss01\" 1,");
    OH_ArkUI_TextEditorTextStyle_SetHalfLeading(textStyle, true);
    OH_ArkUI_TextEditorTextStyle_SetTextBackgroundColor(textStyle, 0xFF00FF00);
    OH_ArkUI_TextEditorTextStyle_SetTextBackgroundRadius(textStyle, 10, 15, 20, 25);
    OH_ArkUI_TextEditorStyledStringController_SetTypingStyle(controller, textStyle);
}

/**
 * 获取输入样式
 * @param controller 属性字符串的控制器
 */
void getTypingStyle(ArkUI_TextEditorStyledStringController* controller)
{
    OH_ArkUI_TextEditorTextStyle* textStyle = OH_ArkUI_TextEditorTextStyle_Create();
    OH_ArkUI_TextEditorStyledStringController_GetTypingStyle(controller, textStyle);
    uint32_t fontColor;
    OH_ArkUI_TextEditorTextStyle_GetFontColor(textStyle, &fontColor);
    float fontSize;
    OH_ArkUI_TextEditorTextStyle_GetFontSize(textStyle, &fontSize);
    ArkUI_FontStyle fontStyle;
    OH_ArkUI_TextEditorTextStyle_GetFontStyle(textStyle, &fontStyle);
    uint32_t fontWeight;
    OH_ArkUI_TextEditorTextStyle_GetFontWeight(textStyle, &fontWeight);
    char* buffer = new char[9];
    int32_t writeLength = 0;
    OH_ArkUI_TextEditorTextStyle_GetFontFamily(textStyle, buffer, 9, &writeLength);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "getTypingStyle font fontColor=%{public}d fontSize=%{public}f fontStyle=%{public}d"
                 "fontWeight=%{public}d buffer=%{public}s writeLength=%{public}d",
                 fontColor, fontSize, fontStyle, fontWeight, buffer, writeLength);
    OH_ArkUI_DecorationStyleOptions* decorationGet = OH_ArkUI_DecorationStyleOptions_Create();

    OH_ArkUI_TextEditorTextStyle_GetDecoration(textStyle, decorationGet);
    ArkUI_TextDecorationType decorationType;
    OH_ArkUI_DecorationStyleOptions_GetTextDecorationType(decorationGet, &decorationType);
    uint32_t decorationColor;
    OH_ArkUI_DecorationStyleOptions_GetColor(decorationGet, &decorationColor);
    ArkUI_TextDecorationStyle decorationStyle;
    OH_ArkUI_DecorationStyleOptions_GetTextDecorationStyle(decorationGet, &decorationStyle);
    float thicknessScale;
    OH_ArkUI_DecorationStyleOptions_GetThicknessScale(decorationGet, &thicknessScale);

    int32_t lineHeight;
    OH_ArkUI_TextEditorTextStyle_GetLineHeight(textStyle, &lineHeight);
    int32_t letterSpacing;
    OH_ArkUI_TextEditorTextStyle_GetLetterSpacing(textStyle, &letterSpacing);
    char* fontFeatureBuffer = new char[21];
    int32_t fontFeatureWriteLength = 0;
    OH_ArkUI_TextEditorTextStyle_GetFontFeature(textStyle, fontFeatureBuffer, 21, &fontFeatureWriteLength);
    bool halfLeading;
    OH_ArkUI_TextEditorTextStyle_GetHalfLeading(textStyle, &halfLeading);
    uint32_t bgColor;
    OH_ArkUI_TextEditorTextStyle_GetTextBackgroundColor(textStyle, &bgColor);
    float topLeft;
    float topRight;
    float bottomLeft;
    float bottomRight;
    OH_ArkUI_TextEditorTextStyle_GetTextBackgroundRadius(textStyle, &topLeft, &topRight, &bottomLeft, &bottomRight);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "getTypingStype textStyle lineHeight=%{public}d letterSpacing=%{public}d fontFeatureBuffer=%{public}s "
                 "fontFeatureWriteLength=${public}d halfLeading=%{public}d bgColor=%{public}d topLeft=%{public}f "
                 "topRight=%{public}f bottomLeft=%{public}f bottomRight=%{public}f",
                 lineHeight, letterSpacing, fontFeatureBuffer, fontFeatureWriteLength, halfLeading, bgColor, topLeft,
                 topRight, bottomLeft, bottomRight);
    OH_ArkUI_ShadowOptions* shadow = OH_ArkUI_ShadowOptions_Create();
    OH_ArkUI_ShadowOptions* shadow3[] = {shadow, shadow};
    OH_ArkUI_ShadowOptions** shadows3 = shadow3;
    uint32_t length;
    OH_ArkUI_TextEditorTextStyle_GetTextShadows(textStyle, shadows3, 1, &length);
    for (int32_t i = 0; i < length; i++) {
        OH_ArkUI_ShadowOptions* tempShadow = shadows3[i];
        if (!tempShadow) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Shadow is empty");
            continue;
        }
        float radius;
        OH_ArkUI_ShadowOptions_GetRadius(tempShadow, &radius);
        ArkUI_ShadowType shadowType;
        OH_ArkUI_ShadowOptions_GetType(tempShadow, &shadowType);
        uint32_t shadowColor;
        OH_ArkUI_ShadowOptions_GetColor(tempShadow, &shadowColor);
        float offsetX;
        OH_ArkUI_ShadowOptions_GetOffsetX(tempShadow, &offsetX);
        float offsetY;
        OH_ArkUI_ShadowOptions_GetOffsetY(tempShadow, &offsetY);
        bool isFill;
        OH_ArkUI_ShadowOptions_GetFill(tempShadow, &isFill);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "getTypingStyle shadow "
                     "params radius=%{public}f shadowType=%{public}d shadowColor=%{public}d "
                     "offsetX=%{public}f offsetY=%{public}f isFill=%{public}d",
                     radius, shadowType, shadowColor, offsetX, offsetY, isFill);
    }
}

/**
 * 设置段落样式
 * @param controller 属性字符串的控制器
 */
void setTypingParagraphStyle(ArkUI_TextEditorStyledStringController* controller)
{
    // 创建pixelMap
    uint8_t data[960000];
    size_t dataSize = 960000;
    for (auto i = 0; i < dataSize; i = i + 4) {
        data[i] = uint8_t(0);
        data[i + 1] = uint8_t(0);
        data[i + 2] = uint8_t(255);
        data[i + 3] = uint8_t(255);
    }
    // 创建参数结构体实例，并设置参数
    OH_Pixelmap_InitializationOptions* createOpts;
    OH_PixelmapInitializationOptions_Create(&createOpts);
    OH_PixelmapInitializationOptions_SetWidth(createOpts, 200);
    OH_PixelmapInitializationOptions_SetHeight(createOpts, 200);
    OH_PixelmapInitializationOptions_SetPixelFormat(createOpts, PIXEL_FORMAT_BGRA_8888);
    OH_PixelmapInitializationOptions_SetAlphaType(createOpts, PIXELMAP_ALPHA_TYPE_UNKNOWN);
    // 创建pixelMap
    OH_PixelmapNative* pixelmap;
    OH_PixelmapNative_CreatePixelmap(data, dataSize, createOpts, &pixelmap);
    OH_PixelmapNative_Opacity(pixelmap, 0.8f);
    OH_ArkUI_TextEditorParagraphStyle* style = OH_ArkUI_TextEditorParagraphStyle_Create();
    OH_ArkUI_TextEditorParagraphStyle_SetTextAlign(style, ArkUI_TextAlignment::ARKUI_TEXT_ALIGNMENT_CENTER);
    ArkUI_TextAlignment align;
    OH_ArkUI_TextEditorParagraphStyle_GetTextAlign(style, &align);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "get OH_ArkUI_TextEditorParagraphStyle_GetTextAlign %{public}d", static_cast<int32_t>(align));
    OH_ArkUI_TextEditorParagraphStyle_SetLeadingMarginPixelMap(style, pixelmap);
    OH_PixelmapNative* pixelmap1;
    OH_ArkUI_TextEditorParagraphStyle_GetLeadingMarginPixelMap(style, &pixelmap1);
    OH_Pixelmap_ImageInfo* imageInfo;
    OH_PixelmapImageInfo_Create(&imageInfo);
    OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
    // 获取图片的宽，高，pixel格式，透明度等信息。
    uint32_t width, height, rowStride;
    int32_t pixelFormat, alphaType;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &height);
    OH_PixelmapImageInfo_GetRowStride(imageInfo, &rowStride);
    OH_PixelmapImageInfo_GetPixelFormat(imageInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetAlphaType(imageInfo, &alphaType);
    OH_PixelmapImageInfo_Release(imageInfo);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest GetImageInfo success, width: %{public}d, height: %{public}d, rowStride: "
                 "%{public}d, pixelFormat: %{public}d, alphaType: %{public}d.",
                 width, height, rowStride, pixelFormat, alphaType);

    OH_ArkUI_TextEditorParagraphStyle_SetLeadingMarginWidth(style, 10);
    OH_ArkUI_TextEditorParagraphStyle_GetLeadingMarginWidth(style, &width);
    OH_ArkUI_TextEditorParagraphStyle_SetLeadingMarginHeight(style, 10);
    OH_ArkUI_TextEditorParagraphStyle_GetLeadingMarginHeight(style, &height);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetLeadingMarginWidth success, width: "
                 "%{public}d, height: %{public}d",
                 width, height);
    OH_ArkUI_TextEditorParagraphStyle_SetWordBreak(style, ArkUI_WordBreak::ARKUI_WORD_BREAK_NORMAL);
    ArkUI_WordBreak workbreak;
    OH_ArkUI_TextEditorParagraphStyle_GetWordBreak(style, &workbreak);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetWordBreak success, workbreak: %{public}d",
                 workbreak);

    OH_ArkUI_TextEditorParagraphStyle_SetLineBreakStrategy(style,
                                                           OH_ArkUI_LineBreakStrategy::OH_ARKUI_LINE_BREAK_STRATEGY_BALANCE);
    OH_ArkUI_LineBreakStrategy LineBreakStrategy;
    OH_ArkUI_TextEditorParagraphStyle_GetLineBreakStrategy(style, &LineBreakStrategy);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetLineBreakStrategy success, "
                 "LineBreakStrategy: %{public}d",
                 LineBreakStrategy);
    uint32_t spacing;
    OH_ArkUI_TextEditorParagraphStyle_SetParagraphSpacing(style, 5);
    OH_ArkUI_TextEditorParagraphStyle_GetParagraphSpacing(style, &spacing);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetParagraphSpacing success, spacing: %{public}d",
                 spacing);

    OH_ArkUI_TextEditorParagraphStyle_SetTextVerticalAlign(
        style, ArkUI_TextVerticalAlignment::ARKUI_TEXT_VERTICAL_ALIGNMENT_BOTTOM);
    ArkUI_TextVerticalAlignment TextVerticalAlignment;
    OH_ArkUI_TextEditorParagraphStyle_GetTextVerticalAlign(style, &TextVerticalAlignment);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetTextVerticalAlign success, "
                 "TextVerticalAlignment: %{public}d",
                 TextVerticalAlignment);
    OH_ArkUI_TextEditorParagraphStyle_SetTextDirection(style, ArkUI_TextDirection::ARKUI_TEXT_DIRECTION_AUTO);
    ArkUI_TextDirection TextDirection;
    OH_ArkUI_TextEditorParagraphStyle_GetTextDirection(style, &TextDirection);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "pixelmapTest OH_ArkUI_TextEditorParagraphStyle_GetTextDirection success, TextDirection: %{public}d",
                 TextDirection);

    OH_ArkUI_TextEditorStyledStringController_SetTypingParagraphStyle(controller, style);
}

/**
 * 获取预上屏内容
 * @param controller 属性字符串的控制器
 */
void getPreviewText(ArkUI_TextEditorStyledStringController* controller)
{
    uint32_t previewTextOffset;
    char* buffer = new char[100];
    int32_t writeLength = 0;
    OH_ArkUI_TextEditorStyledStringController_GetPreviewText(controller, &previewTextOffset, buffer, 9, &writeLength);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                 "getPreviewText offset=%{public}d buffer=%{public}s writeLength=%{public}d", previewTextOffset, buffer,
                 writeLength);
}

void getLineMetrics(ArkUI_TextLayoutManager* layoutManager)
{
    if (!layoutManager) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getLineMetrics no layout manager");
        return;
    }
    OH_Drawing_LineMetrics* lineMetrics = new OH_Drawing_LineMetrics();
    auto res = OH_ArkUI_TextLayoutManager_GetLineMetrics(layoutManager, 0, lineMetrics);
    if (res == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "lineMetrics ascender: %{public}f descender: %{public}f capHeight: %{public}f "
                     "xHeight: %{public}f width: %{public}f height: %{public}f x: %{public}f "
                     "y: %{public}f startIndex: %{public}zu endIndex: %{public}zu",
                     lineMetrics->ascender, lineMetrics->descender, lineMetrics->capHeight, lineMetrics->xHeight,
                     lineMetrics->width, lineMetrics->height, lineMetrics->x, lineMetrics->y, lineMetrics->startIndex,
                     lineMetrics->endIndex);
        OH_Drawing_Font_Metrics fontMetrics = lineMetrics->firstCharMetrics;
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "fontMetrics flags: %{public}u top: %{public}f ascent: %{public}f descent: %{public}f "
                     "bottom: %{public}f leading: %{public}f avgCharWidth: %{public}f "
                     "maxCharWidth: %{public}f xMin: %{public}f xMax: %{public}f xHeight: %{public}f "
                     "capHeight: %{public}f underlineThickness: %{public}f underlinePosition: %{public}f "
                     "strikeoutThickness: %{public}f strikeoutPosition: %{public}f",
                     fontMetrics.flags, fontMetrics.top, fontMetrics.ascent, fontMetrics.descent, fontMetrics.bottom,
                     fontMetrics.leading, fontMetrics.avgCharWidth, fontMetrics.maxCharWidth, fontMetrics.xMin,
                     fontMetrics.xMax, fontMetrics.xHeight, fontMetrics.capHeight, fontMetrics.underlineThickness,
                     fontMetrics.underlinePosition, fontMetrics.strikeoutThickness, fontMetrics.strikeoutPosition);
        OH_Drawing_DestroyLineMetrics(lineMetrics);
    }
}

void getGlyphPosition(ArkUI_TextLayoutManager* layoutManager)
{
    if (!layoutManager) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getGlyphPosition no layout manager");
        return;
    }
    OH_Drawing_PositionAndAffinity* pa;
    auto res = OH_ArkUI_TextLayoutManager_GetGlyphPositionAtCoordinate(layoutManager, 30, 20, &pa);
    if (res == ARKUI_ERROR_CODE_NO_ERROR) {
        size_t position = OH_Drawing_GetPositionFromPositionAndAffinity(pa);
        int32_t affinity = OH_Drawing_GetAffinityFromPositionAndAffinity(pa);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "getGlyphPosition position: %{public}zu affinity: %{public}d", position, affinity);
        OH_Drawing_DestroyPositionAndAffinity(pa);
    }
}

void getRectsForRange(ArkUI_TextLayoutManager* layoutManager)
{
    if (!layoutManager) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getRectsForRange no layout manager");
        return;
    }
    OH_Drawing_TextBox* textBoxes;
    auto res = OH_ArkUI_TextLayoutManager_GetRectsForRange(layoutManager, 0, 100, RECT_WIDTH_STYLE_TIGHT,
                                                           RECT_HEIGHT_STYLE_TIGHT, &textBoxes);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getRectsForRange %{public}d", res);
    if (res == ARKUI_ERROR_CODE_NO_ERROR) {
        size_t size = OH_Drawing_GetSizeOfTextBox(textBoxes);
        float left = OH_Drawing_GetLeftFromTextBox(textBoxes, 0);
        float right = OH_Drawing_GetRightFromTextBox(textBoxes, 0);
        float top = OH_Drawing_GetTopFromTextBox(textBoxes, 0);
        float bottom = OH_Drawing_GetBottomFromTextBox(textBoxes, 0);
        int direction = OH_Drawing_GetTextDirectionFromTextBox(textBoxes, 0);
        OH_Drawing_TypographyDestroyTextBox(textBoxes);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "getRectsForRange textBoxSize: %{public}zu left: %{public}f, right: %{public}f,"
                     "top: %{public}f, bottom: %{public}f direction: %{public}d",
                     size, left, right, top, bottom, direction);
    }
}

void getLineCount(ArkUI_TextLayoutManager* layoutManager)
{
    if (!layoutManager) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getLineCount no layout manager");
        return;
    }
    int32_t lineCount = 0;
    OH_ArkUI_TextLayoutManager_GetLineCount(layoutManager, &lineCount);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getLineCount  %{public}d", lineCount);
}

static void OnBtnClickReceive(ArkUI_NodeEvent* event)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    if (eventType != NODE_ON_CLICK_EVENT) {
        return;
    }
    auto userData = OH_ArkUI_NodeEvent_GetUserData(event);
    auto controllerGet = reinterpret_cast<ArkUI_TextEditorStyledStringController*>(userData);
    int eventIndex = OH_ArkUI_NodeEvent_GetTargetId(event);
    int32_t caretPos = 0;
    auto layoutManager = reinterpret_cast<ArkUI_TextLayoutManager*>(userData);
    switch (eventIndex) {
        case BTN_GET_CARET_OFFSET:
            OH_ArkUI_TextEditorStyledStringController_GetCaretOffset(controllerGet, &caretPos);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "GetCaretOffset %{public}d",
                         caretPos);
            break;
        case BTN_SET_CARET_OFFSET:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "SetCaretOffset 1");
            OH_ArkUI_TextEditorStyledStringController_SetCaretOffset(controllerGet, 1);
            break;
        case BTN_SET_TYPING_STYLE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "setTypingStyle");
            setTypingStyle(controllerGet);
            break;
        case BTN_GET_TYPING_STYLE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "getTypingStyle");
            getTypingStyle(controllerGet);
            break;
        case BTN_SET_TYPING_PARAGRAPH_STYLE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "setTypingParagraphStyle");
            setTypingParagraphStyle(controllerGet);
            break;
        case BTN_SET_SELECTION:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "setSelection(0, 2)");
            OH_ArkUI_TextEditorStyledStringController_SetSelection(controllerGet, 0, 2,
                                                                   ArkUI_MenuPolicy::ARKUI_MENU_POLICY_HIDE);
            break;
        case BTN_IS_EDITING:
            bool isEditing;
            OH_ArkUI_TextEditorStyledStringController_IsEditing(controllerGet, &isEditing);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "isEditing=%{public}d", isEditing);
            break;
        case BTN_STOP_EDITING:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "stopEditing");
            OH_ArkUI_TextEditorStyledStringController_StopEditing(controllerGet);
            break;
        case BTN_LAYOUT_MANAGER_LINE_COUNT:
            getLineCount(layoutManager);
            break;
        case BTN_LAYOUT_MANAGER_RECTS_FOR_RANGE:
            getRectsForRange(layoutManager);
            break;
        case BTN_LAYOUT_MANAGER_GLYPH_POS:
            getGlyphPosition(layoutManager);
            break;
        case BTN_LAYOUT_MANAGER_LINE_METRICS:
            getLineMetrics(layoutManager);
            break;
        case BTN_PREVIEW_TEXT:
            getPreviewText(controllerGet);
            break;
        case BTN_DELETE_BACKWARD:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "deleteBackward");
            OH_ArkUI_TextEditorStyledStringController_DeleteBackward(controllerGet);
            break;
        default:
            break;
    }
}

/**
 * @brief 处理节点事件的回调函数.根据事件类型执行相应的操作。
 * @param event 节点事件
 */
static void OnEventReceive(ArkUI_NodeEvent* event)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "OnEventReceive");
    int eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    ArkUI_PreventableEvent* preventableEvent;
    ArkUI_NodeComponentEvent* nodeComponentEvent;
    switch (eventType) {
        case NODE_TEXT_EDITOR_ON_READY:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "NODE_TEXT_EDITOR_ON_READY");
            break;
        case NODE_TEXT_EDITOR_ON_SELECTION_CHANGE:
            nodeComponentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "TextEditorMaker",
                         "NODE_TEXT_EDITOR_ON_SELECTION_CHANGE %{public}d %{public}d", nodeComponentEvent->data[0].i32,
                         nodeComponentEvent->data[1].i32);
            break;
        case NODE_TEXT_EDITOR_ON_PASTE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "NODE_TEXT_EDITOR_ON_PASTE");
            break;
        case NODE_TEXT_EDITOR_ON_COPY:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "NODE_TEXT_EDITOR_ON_COPY");
            break;
        case NODE_TEXT_EDITOR_ON_EDITING_CHANGE:
            nodeComponentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "NODE_TEXT_EDITOR_ON_EDITING_CHANGE %{public}d", nodeComponentEvent->data[0].i32);
        case NODE_TEXT_EDITOR_ON_SUBMIT:
            nodeComponentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "NODE_TEXT_EDITOR_ON_SUBMIT %{public}d", nodeComponentEvent->data[0].i32);
        case NODE_TEXT_EDITOR_ON_CUT:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "NODE_TEXT_EDITOR_ON_CUT");
            break;
        case NODE_ON_CLICK_EVENT:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "onClick");
            OnBtnClickReceive(event);
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "no callback match");
    };
}

void setTextEditorStyledStringController()
{
    setTextTitle("controller测试");
    ArkUI_NodeHandle textEditor = initTextEditor();
    ArkUI_TextEditorStyledStringController* controller = OH_ArkUI_TextEditorStyledStringController_Create();
    ArkUI_AttributeItem controllerItem = {.object = controller};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_STYLED_STRING_CONTROLLER, &controllerItem);
    addButton("GetCaretOffset", BTN_GET_CARET_OFFSET, controller);
    addButton("SetCaretOffset", BTN_SET_CARET_OFFSET, controller);
    addButton("SetTypingStyle", BTN_SET_TYPING_STYLE, controller);
    addButton("GetTypingStyle", BTN_GET_TYPING_STYLE, controller);
    addButton("SetTypingParagraphStyle", BTN_SET_TYPING_PARAGRAPH_STYLE, controller);
    addButton("SetSelection", BTN_SET_SELECTION, controller);
    addButton("IsEditing", BTN_IS_EDITING, controller);
    addButton("StopEditing", BTN_STOP_EDITING, controller);
    addButton("LM_LineCount", BTN_LAYOUT_MANAGER_LINE_COUNT, controller);
    addButton("LM_RectsForRange", BTN_LAYOUT_MANAGER_RECTS_FOR_RANGE, controller);
    addButton("LM_GlyphPos", BTN_LAYOUT_MANAGER_GLYPH_POS, controller);
    addButton("LM_LineMetrics", BTN_LAYOUT_MANAGER_LINE_METRICS, controller);
    addButton("PreviewText", BTN_PREVIEW_TEXT, controller);
    addButton("DeleteBackward", BTN_DELETE_BACKWARD, controller);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

/**
 * @brief 设置文本编辑器事件
 */
void setTextEditorEvent()
{
    setTextTitle("预上屏（True）");
    ArkUI_NodeHandle textEditor = initTextEditor();
    ArkUI_NumberValue previewText = {.i32 = true};
    ArkUI_AttributeItem previewTextItem = {&previewText, SIZE_1};
    Manager::nodeAPI_->setAttribute(textEditor, NODE_TEXT_EDITOR_STOP_BACK_PRESS, &previewTextItem);

    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_SELECTION_CHANGE, EVENT_ON_SELECTION_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_READY, EVENT_ON_READY, nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_PASTE, EVENT_ON_PASTE, nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_COPY, EVENT_ON_COPY, nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_EDITING_CHANGE, EVENT_ON_EDITING_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_SUBMIT, EVENT_ON_SUBMIT, nullptr);
    Manager::nodeAPI_->registerNodeEvent(textEditor, NODE_TEXT_EDITOR_ON_CUT, EVENT_ON_CUT, nullptr);
}

ArkUI_NodeHandle TextEditorMaker::CreateNativeNode()
{
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    textContainer = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = COLUMN_WIDTH}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = SIZE_1};
    Manager::nodeAPI_->setAttribute(textContainer, NODE_WIDTH, &widthItem);
    setTextEditorColor();
    setTextEditorDetector();
    setTextEditorCustomKeyboard();
    setTextEditorSingleLine();
    setTextEditorStyle();
    setTextEditorSelectionMenu();
    setTextEditorOther();
    setTextEditorEvent();
    setTextEditorStyledStringController();
    Manager::nodeAPI_->addChild(scroll, textContainer);
    return scroll;
}