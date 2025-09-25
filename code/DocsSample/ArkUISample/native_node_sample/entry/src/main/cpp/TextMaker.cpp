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
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_round_rect.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_text_declaration.h>
#include <sstream>
#include <string>
#include <vector>

#define LOG_TAG "manager"
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, LOG_TAG, __VA_ARGS__)

#define VALUE_0 0
#define VALUE_1 1
#define VALUE_2 2
#define VALUE_3 3
#define VALUE_4 4
#define VALUE_5 5
#define VALUE_8 8
#define VALUE_10 10
#define VALUE_11 11
#define VALUE_20 20
#define VALUE_28 28
#define VALUE_30 30
#define VALUE_50 50
#define VALUE_100 100
#define VALUE_300 300
#define VALUE_380 380
#define VALUE_400 400
#define EVENT_SPAN_LONG_PRESS 1
#define EVENT_TEXT_INPUT_CHANGE 2
#define EVENT_TEXT_INPUT_SUBMIT 3
#define EVENT_TEXT_INPUT_CUT 4
#define EVENT_TEXT_INPUT_PASTE 5
#define EVENT_TEXT_INPUT_SELECTION_CHANGE 6
#define EVENT_TEXT_INPUT_EDIT_CHANGE 7
#define EVENT_TEXT_INPUT_CONTENT_SIZE_CHANGE 8
#define EVENT_TEXT_INPUT_FILTER_ERROR 9
#define EVENT_TEXT_INPUT_CONTENT_SCROLL 10
#define EVENT_TEXT_INPUT_WILL_INSERT 11
#define EVENT_TEXT_INPUT_DID_INSERT 12
#define EVENT_TEXT_INPUT_WILL_DELETE 13
#define EVENT_TEXT_INPUT_DID_DELETE 14
#define EVENT_TEXT_INPUT_CHANGE_PREVIEW 15
#define EVENT_TEXT_INPUT_WILL_CHANGE 16
#define EVENT_TEXT_AREA_CHANGE 17
#define EVENT_TEXT_AREA_PASTE 18
#define EVENT_TEXT_AREA_SELECTION_CHANGE 19
#define EVENT_TEXT_AREA_CONTENT_SCROLL 20
#define EVENT_TEXT_AREA_EDIT_CHANGE 21
#define EVENT_TEXT_AREA_SUBMIT 22
#define EVENT_TEXT_AREA_CONTENT_SIZE_CHANGE 23
#define EVENT_TEXT_AREA_DID_INSERT 24
#define EVENT_TEXT_AREA_DID_DELETE 25
#define EVENT_TEXT_AREA_CHANGE_PREVIEW 26
#define EVENT_TEXT_AREA_FILTER_ERROR 27
#define EVENT_TEXT_AREA_WILL_INSERT 28
#define EVENT_TEXT_AREA_WILL_DELETE 29
#define EVENT_TEXT_AREA_WILL_CHANGE 30
#define EVENT_TEXT_DETECT_RESULT_UPDATE 31

// 处理Span事件
static void HandleSpanEvent(int32_t eventId)
{
    if (eventId == EVENT_SPAN_LONG_PRESS) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "spanOnLongPress回调函数被执行");
    }
}

// 处理TextInput事件(1)
static void HandleTextInputEvent1(int32_t eventId)
{
    switch (eventId) {
    case EVENT_TEXT_INPUT_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnChange回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_SUBMIT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnSubmit回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_CUT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnCut回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_PASTE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnPaste回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_SELECTION_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnSelectionChange回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_EDIT_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnEditChange回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_CONTENT_SIZE_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnContentSizeChange回调函数被执行");
        break;
    default:
        break;
    }
}

// 处理TextInput事件(2)
static void HandleTextInputEvent2(int32_t eventId)
{
    switch (eventId) {
    case EVENT_TEXT_INPUT_FILTER_ERROR:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnInputFiterError回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_CONTENT_SCROLL:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnontentScroll回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_WILL_INSERT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnWillInsert回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_DID_INSERT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnDidInsert回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_WILL_DELETE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnWillDelete回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_DID_DELETE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnDidDelete回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_CHANGE_PREVIEW:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnChangeWithPreviewText回调函数被执行");
        break;
    case EVENT_TEXT_INPUT_WILL_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textInputOnWillChange回调函数被执行");
        break;
    default:
        break;
    }
}

// 处理TextArea事件(1)
static void HandleTextAreaEvent1(int32_t eventId)
{
    switch (eventId) {
    case EVENT_TEXT_AREA_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnChange回调函数被执行");
        break;
    case EVENT_TEXT_AREA_PASTE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnPaste回调函数被执行");
        break;
    case EVENT_TEXT_AREA_SELECTION_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnTextSelectionChange回调函数被执行");
        break;
    case EVENT_TEXT_AREA_CONTENT_SCROLL:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnContentScroll回调函数被执行");
        break;
    case EVENT_TEXT_AREA_EDIT_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnEditChange回调函数被执行");
        break;
    case EVENT_TEXT_AREA_SUBMIT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnSubmit回调函数被执行");
        break;
    case EVENT_TEXT_AREA_CONTENT_SIZE_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnContentSizeChange回调函数被执行");
        break;
    default:
        break;
    }
}

// 处理TextArea事件(2)
static void HandleTextAreaEvent2(int32_t eventId)
{
    switch (eventId) {
    case EVENT_TEXT_AREA_DID_INSERT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnDidInsert回调函数被执行");
        break;
    case EVENT_TEXT_AREA_DID_DELETE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnDidDelete回调函数被执行");
        break;
    case EVENT_TEXT_AREA_CHANGE_PREVIEW:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnChangeWithPreviewText回调函数被执行");
        break;
    case EVENT_TEXT_AREA_FILTER_ERROR:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnInputFilterError回调函数被执行");
        break;
    case EVENT_TEXT_AREA_WILL_INSERT:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnWillInsert回调函数被执行");
        break;
    case EVENT_TEXT_AREA_WILL_DELETE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnWillDelete回调函数被执行");
        break;
    case EVENT_TEXT_AREA_WILL_CHANGE:
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textAreaOnWillChange回调函数被执行");
        break;
    default:
        break;
    }
}

// 处理其他事件
static void HandleOtherEvent(int32_t eventId)
{
    if (eventId == EVENT_TEXT_DETECT_RESULT_UPDATE) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textOnDetectResultUpdate回调函数被执行");
    }
}

// 主事件处理函数
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    // 处理字符串异步事件
    ArkUI_StringAsyncEvent *asyncEvent = OH_ArkUI_NodeEvent_GetStringAsyncEvent(event);
    if (asyncEvent != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "text组件事件数据获取成功");
    }
    // 处理文本变化事件
    ArkUI_TextChangeEvent *textChangeEvent = OH_ArkUI_NodeEvent_GetTextChangeEvent(event);
    if (asyncEvent != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "textChange组件事件数据获取成功");
    }
    // 处理字符串值
    char *eventStr = nullptr;
    int32_t strSize = VALUE_0;
    int32_t ret = OH_ArkUI_NodeEvent_GetStringValue(event, VALUE_0, &eventStr, &strSize);
    if (ret == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "text组件事件数据获取成功");
    }
    // 分发事件处理
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    HandleSpanEvent(eventId);
    HandleTextInputEvent1(eventId);
    HandleTextInputEvent2(eventId);
    HandleTextAreaEvent1(eventId);
    HandleTextAreaEvent2(eventId);
    HandleOtherEvent(eventId);
}

void setText1(ArkUI_NodeHandle &text)
{
    ArkUI_NumberValue textWidth[] = {{.f32 = VALUE_380}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = VALUE_100}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    if (text != nullptr) {
        // span仅作为text的子组件形式展示
        ArkUI_NodeHandle span = Manager::nodeAPI_->createNode(ARKUI_NODE_SPAN);
        const char *spanContent = "This is a span";
        ArkUI_AttributeItem spanContentItem = {.string = spanContent};
        Manager::nodeAPI_->setAttribute(span, NODE_SPAN_CONTENT, &spanContentItem);
        if (span != nullptr) {
            // 设置Span背景样式
            ArkUI_NumberValue spanBackground[] = {
                {.u32 = 0xFFFF0000}, // 背景颜色
                {.f32 = 5.0f},       // 左上角半径
                {.f32 = 5.0f},       // 右上角半径
                {.f32 = 5.0f},       // 左下角半径
                {.f32 = 5.0f}        // 右下角半径
            };
            ArkUI_AttributeItem spanBackgroundItem = {.value = spanBackground, .size = VALUE_5};
            Manager::nodeAPI_->setAttribute(span, NODE_SPAN_TEXT_BACKGROUND_STYLE, &spanBackgroundItem);

            // 文本基线的偏移量属性
            ArkUI_NumberValue baselineOffsetVal = {.f32 = VALUE_10};
            ArkUI_AttributeItem baselineOffsetItem = {&baselineOffsetVal, VALUE_1};
            Manager::nodeAPI_->setAttribute(text, NODE_SPAN_BASELINE_OFFSET, &baselineOffsetItem);
            // 长按span组件，触发回调
            Manager::nodeAPI_->registerNodeEvent(span, NODE_TEXT_SPAN_ON_LONG_PRESS, EVENT_SPAN_LONG_PRESS, nullptr);
            Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
        }
        Manager::nodeAPI_->addChild(text, span);
    }
}

static void setTextInput1Base(ArkUI_NodeHandle &textInput1)
{
    // 控制单行文本输入框编辑态属性
    ArkUI_NumberValue inputEditing = {.i32 = true};
    ArkUI_AttributeItem inputEditingItem = {&inputEditing, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_EDITING, &inputEditingItem);
    // 单行文本设置文本选中并高亮的区域
    ArkUI_NumberValue inputTextSelection[] = {{.i32 = VALUE_0}, {.i32 = VALUE_10}};
    ArkUI_AttributeItem inputTextSelectionItem = {inputTextSelection, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_TEXT_SELECTION, &inputTextSelectionItem);
    // 设置是否启用自动填充
    ArkUI_NumberValue enableAutoFill = {.i32 = false};
    ArkUI_AttributeItem enableAutoFillItem = {&enableAutoFill, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_ENABLE_AUTO_FILL, &enableAutoFillItem);
    // 设置是否启用自动填充动效
    ArkUI_NumberValue enableFillAnimation = {.i32 = false};
    ArkUI_AttributeItem enableFillAnimationItem = {&enableFillAnimation, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_ENABLE_FILL_ANIMATION, &enableFillAnimationItem);
    // 自动填充类型（密码保险箱支持）
    ArkUI_NumberValue inputContentType = {.i32 = ARKUI_TEXTINPUT_CONTENT_TYPE_PASSWORD};
    ArkUI_AttributeItem inputContentTypeItem = {&inputContentType, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_CONTENT_TYPE, &inputContentTypeItem);
    // 定义生成密码规则
    const char *passwordRulesVal = "这是密码规则";
    ArkUI_AttributeItem passwordRulesItem = {.string = passwordRulesVal};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_PASSWORD_RULES, &passwordRulesItem);
    // 设置初始状态，是否全选文本
    ArkUI_NumberValue inputSelectAll = {.i32 = false};
    ArkUI_AttributeItem inputSelectAllItem = {&inputSelectAll, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_SELECT_ALL, &inputSelectAllItem);
}

// 设置TextInput1的基础属性（提示文本、光标、字体、输入模式等）
static void SetTextInput1BaseAttrs(ArkUI_NodeHandle &textInput1)
{
    // 默认提示文本内容
    const char *inputPlaceHolederVal = "please info password";
    ArkUI_AttributeItem placeHolederItem = {.string = inputPlaceHolederVal};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_PLACEHOLDER, &placeHolederItem);
    // 光标颜色属性
    ArkUI_NumberValue caretColor = {.u32 = 0xFFFF0000};
    ArkUI_AttributeItem caretColorItem = {&caretColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_CARET_COLOR, &caretColorItem);
    // 光标风格属性，光标宽度
    ArkUI_NumberValue caretStyle = {.f32 = VALUE_2};
    ArkUI_AttributeItem caretStyleItem = {&caretStyle, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_CARET_STYLE, &caretStyleItem);
    // 无输入时默认字体颜色属性
    ArkUI_NumberValue placeholderColor = {.u32 = 0xFFFF0000};
    ArkUI_AttributeItem placeholderColorItem = {&placeholderColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_PLACEHOLDER_COLOR, &placeholderColorItem);
    // 无输入时默认字体配置（斜体，字体大小 20）
    ArkUI_NumberValue placeholderFont[] = {{.f32 = VALUE_20}, {.i32 = ARKUI_FONT_STYLE_ITALIC}};
    ArkUI_AttributeItem placeholderFontItem = {placeholderFont, VALUE_2};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_PLACEHOLDER_FONT, &placeholderFontItem);
    // 聚焦是否绑定输入法
    ArkUI_NumberValue enableKeyboard = {.i32 = false};
    ArkUI_AttributeItem enableKeyboardItem = {&enableKeyboard, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_ENABLE_KEYBOARD_ON_FOCUS, &enableKeyboardItem);
    // 输入框类型属性（密码输入模式）
    ArkUI_NumberValue inputTyple = {.i32 = ARKUI_TEXTINPUT_TYPE_PASSWORD};
    ArkUI_AttributeItem inputTypleItem = {&inputTyple, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_TYPE, &inputTypleItem);
    // 密码输入模式是否显示末尾图标属性
    ArkUI_NumberValue showPasswordIcon = {.i32 = false};
    ArkUI_AttributeItem showPasswordIconItem = {&showPasswordIcon, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_SHOW_PASSWORD_ICON, &showPasswordIconItem);
    // 输入框文本被选中时的背景色
    ArkUI_NumberValue selectedBackgroundColor = {.u32 = 0xFFFFFF00};
    ArkUI_AttributeItem selectedBackgroundColorItem = {&selectedBackgroundColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput1, NODE_TEXT_INPUT_SELECTED_BACKGROUND_COLOR,
                                    &selectedBackgroundColorItem);
    setTextInput1Base(textInput1);
}

// 注册 TextInput1 的所有事件
static void RegisterTextInput1Events(ArkUI_NodeHandle &textInput1)
{
    // TextInput 输入内容发生变化时触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_CHANGE, EVENT_TEXT_INPUT_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // TextInput 按下输入法回车键触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_SUBMIT, EVENT_TEXT_INPUT_SUBMIT, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 长按弹出剪贴板后点击剪切触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_CUT, EVENT_TEXT_INPUT_CUT, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 长按弹出剪贴板后点击粘贴触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_PASTE, EVENT_TEXT_INPUT_PASTE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 文本选择变化触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_TEXT_SELECTION_CHANGE,
                                         EVENT_TEXT_INPUT_SELECTION_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 输入状态变化触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_EDIT_CHANGE, EVENT_TEXT_INPUT_EDIT_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 文本内容滚动触发
    Manager::nodeAPI_->registerNodeEvent(textInput1, NODE_TEXT_INPUT_ON_CONTENT_SCROLL, EVENT_TEXT_INPUT_CONTENT_SCROLL,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

void setTextInput1(ArkUI_NodeHandle &textInput1)
{
    SetTextInput1BaseAttrs(textInput1);
    RegisterTextInput1Events(textInput1);
}

static void setTextInputVal(ArkUI_NodeHandle &textInput2)
{
    // 设置输入框风格，（内联只支持输入框类型设置为normal)
    ArkUI_NumberValue textInputStyle = {.i32 = ARKUI_TEXTINPUT_STYLE_INLINE};
    ArkUI_AttributeItem textInputStyleItem = {&textInputStyle, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_STYLE, &textInputStyleItem);

    // 单行文本输入框的默认文本内容属性
    ArkUI_AttributeItem textInputText = {.string = "this is textinput 2"};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_TEXT, &textInputText);

    // 设置长按、双击输入框或者右键输入框时，是否不弹出文本选择菜单(true是隐藏，false是显示，默认值是false)
    ArkUI_NumberValue selelctionMenuHidden = {.i32 = true};
    ArkUI_AttributeItem selelctionMenuHiddenItem = {&selelctionMenuHidden, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_SELECTION_MENU_HIDDEN, &selelctionMenuHiddenItem);

    // 回车键类型
    ArkUI_NumberValue enterKeyType = {.i32 = ARKUI_ENTER_KEY_TYPE_SEND};
    ArkUI_AttributeItem enterKeyTypeItem = {&enterKeyType, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_ENTER_KEY_TYPE, &enterKeyTypeItem);

    // 是否弹出键盘(默认true，false将不弹出键盘)
    ArkUI_NumberValue showKeyboardOnFocus = {.i32 = true};
    ArkUI_AttributeItem showKeyboardOnFocusItem = {&showKeyboardOnFocus, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_SHOW_KEYBOARD_ON_FOCUS, &showKeyboardOnFocusItem);

    // 调整textInput组件之间的字符间距
    ArkUI_NumberValue inputLetterSpacing = {.f32 = VALUE_10};
    ArkUI_AttributeItem inputLetterSpacingItem = {&inputLetterSpacing, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_LETTER_SPACING, &inputLetterSpacingItem);

    // 是否开启输入预上屏
    ArkUI_NumberValue enablePreviewText = {.i32 = false};
    ArkUI_AttributeItem enablePreviewTextItem = {&enablePreviewText, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_ENABLE_PREVIEW_TEXT, &enablePreviewTextItem);

    // 设置文本将行间距平分至行的顶部与底部
    ArkUI_NumberValue inputHalfLeading = {.i32 = true};
    ArkUI_AttributeItem inputHalfLeadingItem = {&inputHalfLeading, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_HALF_LEADING, &inputHalfLeadingItem);

    // 设置输入框拉起的键盘样式
    ArkUI_NumberValue keyboardAppenrance = {.i32 = ARKUI_KEYBOARD_APPEARANCE_DARK_IMMERSIVE};
    ArkUI_AttributeItem keyboardAppenranceItem = {&keyboardAppenrance, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_KEYBOARD_APPEARANCE, &keyboardAppenranceItem);

    // 设置输入框文本的高度(设置为undefined时，文本的高度设置为5）
    ArkUI_NumberValue inputLineHeight = {.i32 = VALUE_30};
    ArkUI_AttributeItem inputLineHeightItem = {&inputLineHeight, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput2, NODE_TEXT_INPUT_LINE_HEIGHT, &inputLineHeightItem);
}

void setTextInput2(ArkUI_NodeHandle &textInput2)
{
    setTextInputVal(textInput2);
    // 获取已编辑文本内容区域相对组件的位置和大小
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager",
                 "NODE_TEXT_INPUT_CARET_OFFSET:%{public}f、%{public}f、%{public}f、%{public}f",
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_RECT)->value[VALUE_0].f32,
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_RECT)->value[VALUE_1].f32,
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_RECT)->value[VALUE_2].f32,
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_RECT)->value[VALUE_3].f32);

    // 获取已编辑内容的行数
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_TEXT_INPUT_CONTENT_LINE_COUNT:%{public}d、%{public}d",
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_LINE_COUNT)->value[VALUE_0].i32,
                 Manager::nodeAPI_->getAttribute(textInput2, NODE_TEXT_INPUT_CONTENT_LINE_COUNT)->value[VALUE_1].i32);

    // TextInput输入内容发生变化时触发该事件
    Manager::nodeAPI_->registerNodeEvent(textInput2, NODE_TEXT_INPUT_ON_CONTENT_SIZE_CHANGE,
                                         EVENT_TEXT_INPUT_CONTENT_SIZE_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在输入完成时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput2, NODE_TEXT_INPUT_ON_DID_INSERT, EVENT_TEXT_INPUT_DID_INSERT,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在删除完成时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput2, NODE_TEXT_INPUT_ON_DID_DELETE, EVENT_TEXT_INPUT_DID_DELETE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义TextInput组件在内容改变时（包含预上屏内容），触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput2, NODE_TEXT_INPUT_ON_CHANGE_WITH_PREVIEW_TEXT,
                                         EVENT_TEXT_INPUT_CHANGE_PREVIEW, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在删除完成时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput2, NODE_TEXT_INPUT_ON_WILL_CHANGE, EVENT_TEXT_INPUT_WILL_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

void setTextInput3(ArkUI_NodeHandle &textInput3)
{
    // 输入框下划线
    ArkUI_NumberValue showUnderLine = {.i32 = true};
    ArkUI_AttributeItem showUnderLineItem = {&showUnderLine, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_SHOW_UNDERLINE, &showUnderLineItem);

    // 设置输入框最大文本数属性
    ArkUI_NumberValue maxLength = {.i32 = VALUE_10};
    ArkUI_AttributeItem maxLengthItem = {&maxLength, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_MAX_LENGTH, &maxLengthItem);
    
    // 单行文本右侧清除按钮样式
    ArkUI_NumberValue cancelButton[] = {{.i32 = ARKUI_CANCELBUTTON_STYLE_CONSTANT}};
    ArkUI_AttributeItem cancelButtonItem = {cancelButton, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_CANCEL_BUTTON, &cancelButtonItem);

    // 开启下划线时，配置下划线的颜色
    ArkUI_NumberValue underlineColor[] = {
        {.u32 = 0xFFFF0000}, {.u32 = 0xFFFF1493}, {.u32 = 0xFFFFB7C5}, {.u32 = 0xFFFFE4E1}};
    ArkUI_AttributeItem underlineColorItem = {underlineColor, VALUE_4};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_UNDERLINE_COLOR, &underlineColorItem);

    // 通过正则表达式设置输入，支持字符串匹配，例如粘贴
    ArkUI_AttributeItem filterItem = {.string = "a"};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_INPUT_FILTER, &filterItem);
    // 设置自定义键盘
    ArkUI_NumberValue inputCustomKeyBoard = {.i32 = false};
    ArkUI_AttributeItem inputCustomKeyBoardItem = {&inputCustomKeyBoard, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_CUSTOM_KEYBOARD, &inputCustomKeyBoardItem);

    // 断行规则：CJK任意断行（ARKUI_WORD_BREAK_NORMAL）
    ArkUI_NumberValue wordBreakVal = {.i32 = ARKUI_WORD_BREAK_NORMAL};
    ArkUI_AttributeItem wordBreakItem = {&wordBreakVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_WORD_BREAK, &wordBreakItem);

    // 设置输入框在submit状态下，触发回车键是否失焦
    ArkUI_NumberValue blurOrSubmit = {.i32 = false};
    ArkUI_AttributeItem blurOrSubmitItem = {&blurOrSubmit, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_BLUR_ON_SUBMIT, &blurOrSubmitItem);

    // 定义在将要输入时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput3, NODE_TEXT_INPUT_ON_WILL_INSERT, EVENT_TEXT_INPUT_WILL_INSERT,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在将要删除时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textInput3, NODE_TEXT_INPUT_ON_WILL_DELETE, EVENT_TEXT_INPUT_WILL_DELETE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 设置光标所在位置
    ArkUI_NumberValue textInputCaretOffset = {.i32 = VALUE_5};
    ArkUI_AttributeItem textInputCaretOffsetItem = {&textInputCaretOffset, VALUE_1};
    Manager::nodeAPI_->setAttribute(textInput3, NODE_TEXT_INPUT_CARET_OFFSET, &textInputCaretOffsetItem);

    // 获取已编辑内容的行数
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_TEXT_AREA_CONTENT_LINE_COUNT:%{public}d",
                 Manager::nodeAPI_->getAttribute(textInput3, NODE_TEXT_INPUT_CONTENT_LINE_COUNT)->value[VALUE_0].i32);

    // 设置NODE_TEXT_INPUT_INPUT_FILTER，正则匹配失败时触发。触发该事件的条件：正则匹配失败时
    Manager::nodeAPI_->registerNodeEvent(textInput3, NODE_TEXT_INPUT_ON_INPUT_FILTER_ERROR,
                                         EVENT_TEXT_INPUT_FILTER_ERROR, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

static void setTextArea1Val(ArkUI_NodeHandle &textArea1)
{
    // 多行文本输入框的默认提示文本内容属性
    const char *textAreaPlaceholder = "this is textArea1";
    ArkUI_AttributeItem textAreaPlaceholderItem = {.string = textAreaPlaceholder};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_PLACEHOLDER, &textAreaPlaceholderItem);

    // 输入框支持的最大文本数属性
    ArkUI_NumberValue textAreaMaxLength = {.i32 = VALUE_11};
    ArkUI_AttributeItem textAreaMaxLengthItem = {&textAreaMaxLength, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_MAX_LENGTH, &textAreaMaxLengthItem);

    // 无输入时默认提示文本的颜色属性
    ArkUI_NumberValue textAreaPlaceholederColor = {.u32 = 0xFFFFC0CB};
    ArkUI_AttributeItem textAreaPlaceholederColorItem = {&textAreaPlaceholederColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_PLACEHOLDER_COLOR, &textAreaPlaceholederColorItem);

    // 光标颜色属性
    ArkUI_NumberValue textAreaCaretColor = {.u32 = 0xFFFFE4E1};
    ArkUI_AttributeItem textAreaCaretColorItem = {&textAreaCaretColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_CARET_COLOR, &textAreaCaretColorItem);

    // 控制多行文本输入框编辑态属性
    ArkUI_NumberValue textAreaEditing = {.i32 = true};
    ArkUI_AttributeItem textAreaEditingItem = {&textAreaEditing, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_EDITING, &textAreaEditingItem);

    // 输入框的类型属性
    ArkUI_NumberValue textAreaType = {.i32 = ARKUI_TEXTAREA_TYPE_NUMBER};
    ArkUI_AttributeItem textAreaTypeItem = {&textAreaType, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_TYPE, &textAreaTypeItem);

    // 设置输入的字符数超过阈值时是否显示计数器,超出阈值高亮边框
    ArkUI_NumberValue textAreaShowCounter[] = {{.i32 = true}, {.f32 = VALUE_100}, {.i32 = true}};
    ArkUI_AttributeItem textAreaShowCounterItem = {textAreaShowCounter, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_SHOW_COUNTER, &textAreaShowCounterItem);

    // 设置长按、双击输入框或者右键输入框时，是否不弹出文本选择菜单
    ArkUI_NumberValue textAreaSelectionMenuHidden = {.i32 = true};
    ArkUI_AttributeItem textAreaSelectionMenuHiddenItem = {&textAreaSelectionMenuHidden, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_SELECTION_MENU_HIDDEN, &textAreaSelectionMenuHiddenItem);

    // 设置文本选中底板颜色
    ArkUI_NumberValue textAreaSelectedBackgroundColor = {.u32 = 0xFFFF0000};
    ArkUI_AttributeItem textAreaSelectedBackgroundColorItem = {&textAreaSelectedBackgroundColor, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_SELECTED_BACKGROUND_COLOR,
                                    &textAreaSelectedBackgroundColorItem);

    // 回车键类型
    ArkUI_NumberValue enterKeyType = {.i32 = ARKUI_ENTER_KEY_TYPE_SEND};
    ArkUI_AttributeItem enterKeyTypeItem = {&enterKeyType, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_ENTER_KEY_TYPE, &enterKeyTypeItem);

    // 是否弹出键盘(默认true，false将不弹出键盘)
    ArkUI_NumberValue showKeyboardOnFocus = {.i32 = true};
    ArkUI_AttributeItem showKeyboardOnFocusItem = {&showKeyboardOnFocus, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_SHOW_KEYBOARD_ON_FOCUS, &showKeyboardOnFocusItem);

    // 设置文本将行间距平分至行的顶部与底部
    ArkUI_NumberValue areaHalfLeading = {.i32 = true};
    ArkUI_AttributeItem areaHalfLeadingItem = {&areaHalfLeading, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_HALF_LEADING, &areaHalfLeadingItem);

    // 设置节点的最小行数
    ArkUI_NumberValue textAreaMinLines = {.i32 = VALUE_1};
    ArkUI_AttributeItem textAreaMinLinesItem = {&textAreaMinLines, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_MIN_LINES, &textAreaMinLinesItem);
}

void setTextArea1(ArkUI_NodeHandle &textArea1)
{
    setTextArea1Val(textArea1);
    // 设置输入框文本的高度
    ArkUI_NumberValue textAreaLineHeight = {.i32 = VALUE_30};
    ArkUI_AttributeItem textAreaLineHeightItem = {&textAreaLineHeight, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_LINE_HEIGHT, &textAreaLineHeightItem);

    // 组件在获焦状态下，调用该接口设置文本选择区域并高亮显示，且只有在selectionStart小于selectionEnd时，文字才会被选取、高亮显示。
    ArkUI_NumberValue textAreaSelection[] = {{.i32 = VALUE_2}, {.i32 = VALUE_8}};
    ArkUI_AttributeItem textAreaSelectionItem = {textAreaSelection, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_TEXT_SELECTION, &textAreaSelectionItem);

    // 设置是否启用自动填充
    ArkUI_NumberValue textAreaEnableAutoFill = {.i32 = false};
    ArkUI_AttributeItem textAreaEnableAutoFillItem = {&textAreaEnableAutoFill, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_ENABLE_AUTO_FILL, &textAreaEnableAutoFillItem);

    // NODE_TEXT_AREA_CONTENT_TYPE
    ArkUI_NumberValue textAreaContentType = {.i32 = ARKUI_TEXTINPUT_CONTENT_TYPE_USER_NAME};
    ArkUI_AttributeItem textAreaContentTypeItem = {&textAreaContentType, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea1, NODE_TEXT_AREA_CONTENT_TYPE, &textAreaContentTypeItem);

    // 获取光标所在位置信息
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_TEXT_AREA_CARET_OFFSET:%{public}d",
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CARET_OFFSET)->value[VALUE_0].i32);

    // 获取已编辑文本内容区域相对组件的位置和大小
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager",
                 "NODE_TEXT_AREA_CARET_OFFSET:%{public}f、%{public}f、%{public}f、%{public}f",
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_RECT)->value[VALUE_0].f32,
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_RECT)->value[VALUE_1].f32,
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_RECT)->value[VALUE_2].f32,
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_RECT)->value[VALUE_3].f32);

    // 获取已编辑内容的行数
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_TEXT_AREA_CONTENT_LINE_COUNT:%{public}d、%{public}d",
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_LINE_COUNT)->value[VALUE_0].i32,
                 Manager::nodeAPI_->getAttribute(textArea1, NODE_TEXT_AREA_CONTENT_LINE_COUNT)->value[VALUE_1].i32);

    // 输入内容发生变化时，触发该回调
    Manager::nodeAPI_->registerNodeEvent(textArea1, NODE_TEXT_AREA_ON_CHANGE, EVENT_TEXT_AREA_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

void setTextArea2(ArkUI_NodeHandle &textArea2)
{
    // 多行文本输入框的默认提示文本内容属性
    const char *textAreaText = "这里是默认文本内容";
    ArkUI_AttributeItem textAreaTextItem = {.string = textAreaText};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_PLACEHOLDER, &textAreaTextItem);

    // 设置输入框文本的行间距
    ArkUI_NumberValue textAreaLineSpacing = {.i32 = VALUE_10};
    ArkUI_AttributeItem textAreaLineSpacingItem = {&textAreaLineSpacing, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_LINE_SPACING, &textAreaLineSpacingItem);

    // 设置TextArea组件是否开启输入预上屏
    ArkUI_NumberValue enablePrevireText = {.i32 = ARKUI_ENTER_KEY_TYPE_SEND};
    ArkUI_AttributeItem enablePrevireTextItem = {&enablePrevireText, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_ENABLE_PREVIEW_TEXT, &enablePrevireTextItem);

    // 设置输入框拉起的键盘样式
    ArkUI_NumberValue keyboardAppenrance = {.i32 = ARKUI_KEYBOARD_APPEARANCE_DARK_IMMERSIVE};
    ArkUI_AttributeItem keyboardAppenranceItem = {&keyboardAppenrance, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_KEYBOARD_APPEARANCE, &keyboardAppenranceItem);

    // 设置输入框文本的行间距
    ArkUI_NumberValue textAreaLetterSpacing = {.i32 = VALUE_10};
    ArkUI_AttributeItem textAreaLetterSpacingItem = {&textAreaLetterSpacing, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_LETTER_SPACING, &textAreaLetterSpacingItem);

    // 设置输入框内联模式编辑态时文本可显示的最大行数
    ArkUI_NumberValue textAreaMaxLines = {.i32 = VALUE_8};
    ArkUI_AttributeItem textAreaMaxLinesItem = {&textAreaMaxLines, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_MAX_LINES, &textAreaMaxLinesItem);

    // 设置输入框在submit状态下，触发回车键是否失焦
    ArkUI_NumberValue blurOrSubmit = {.i32 = false};
    ArkUI_AttributeItem blurOrSubmitItem = {&blurOrSubmit, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_BLUR_ON_SUBMIT, &blurOrSubmitItem);

    // 通过正则表达式设置输入，支持字符串匹配，例如粘贴
    ArkUI_AttributeItem filterItem = {.string = "a"};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_INPUT_FILTER, &filterItem);

    // 设置TextArea通过点击以外的方式获焦时，是否绑定输入法
    ArkUI_NumberValue keyboardOnFocus = {.i32 = false};
    ArkUI_AttributeItem keyboardOnFocusItem = {&keyboardOnFocus, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea2, NODE_TEXT_AREA_ENABLE_KEYBOARD_ON_FOCUS, &keyboardOnFocusItem);

    // 设置NODE_TEXT_AREA_INPUT_FILTER，正则匹配失败时触发。触发该事件的条件：正则匹配失败时
    Manager::nodeAPI_->registerNodeEvent(textArea2, NODE_TEXT_AREA_ON_INPUT_FILTER_ERROR, EVENT_TEXT_AREA_FILTER_ERROR,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在将要输入时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea2, NODE_TEXT_AREA_ON_WILL_INSERT, EVENT_TEXT_AREA_WILL_INSERT,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义在将要删除时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea2, NODE_TEXT_AREA_ON_WILL_DELETE, EVENT_TEXT_AREA_WILL_DELETE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);

    // 定义TextArea组件在内容将要改变时（包含预上屏内容），触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea2, NODE_TEXT_AREA_ON_WILL_CHANGE, EVENT_TEXT_AREA_WILL_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

static void onFontStyleChange(ArkUI_SystemFontStyleEvent *event, void *userData)
{
    float fontSizeScale = OH_ArkUI_SystemFontStyleEvent_GetFontSizeScale(event);
    float fontWeightScale = OH_ArkUI_SystemFontStyleEvent_GetFontWeightScale(event);
    ArkUI_NodeHandle textNode = static_cast<ArkUI_NodeHandle>(userData);
}

void setText2(ArkUI_NodeHandle &text2)
{
    const char *textContent = "this is text 2 this is text 2 this is text 2!!!! ";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_CONTENT, &contentItem);
    // 设置文本样式
    ArkUI_NumberValue fontSize[] = {{.f32 = VALUE_28}};
    ArkUI_AttributeItem fontSizeItem = {.value = fontSize, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_NumberValue fontColor = {.u32 = 0xFFFF0000};
    ArkUI_AttributeItem fontColorItem = {.value = &fontColor, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_FONT_COLOR, &fontColorItem);

    // 字体样式：斜体样式（ARKUI_FONT_STYLE_ITALIC）
    ArkUI_NumberValue fontStyleVal = {.i32 = ARKUI_FONT_STYLE_ITALIC};
    ArkUI_AttributeItem fontStyleItem = {&fontStyleVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_FONT_STYLE, &fontStyleItem);

    // 文本字符间距
    ArkUI_NumberValue letterSpaceVal = {.f32 = VALUE_10};
    ArkUI_AttributeItem letterSpaceItem = {&letterSpaceVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_LETTER_SPACING, &letterSpaceItem);
    // 文本最大行数
    ArkUI_NumberValue maxLinesVal = {.i32 = VALUE_1};
    ArkUI_AttributeItem maxLinesItem = {&maxLinesVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_LETTER_SPACING, &maxLinesItem);

    // 最小显示字号
    ArkUI_NumberValue minFontSizeVal = {.i32 = ARKUI_COPY_OPTIONS_NONE};
    ArkUI_AttributeItem minFontSizeItem = {&minFontSizeVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_COPY_OPTION, &minFontSizeItem);

    // 文本溢出：跑马灯（ARKUI_TEXT_OVERFLOW_MARQUEE）
    ArkUI_NumberValue overflowVal = {.i32 = ARKUI_TEXT_OVERFLOW_MARQUEE};
    ArkUI_AttributeItem overflowItem = {&overflowVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_OVERFLOW, &overflowItem);

    int32_t ret = OH_ArkUI_RegisterSystemFontStyleChangeEvent(text2, text2, &onFontStyleChange);
    if (ret == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "字体变更回调");
    }
}

void setText3(ArkUI_NodeHandle &text3)
{
    const char *textContent =
        "this is text 3 this is text 3 this is text 3!!!!this is text 3 this is text 3 this is text 3!!!! ";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CONTENT, &contentItem);

    // 自适应高度：MaxLines优先（ARKUI_TEXT_HEIGHT_ADAPTIVE_POLICY_MAX_LINES_FIRST）
    ArkUI_NumberValue adaptPolicyVal = {.i32 = ARKUI_TEXT_HEIGHT_ADAPTIVE_POLICY_MAX_LINES_FIRST};
    ArkUI_AttributeItem adaptPolicyItem = {&adaptPolicyVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_HEIGHT_ADAPTIVE_POLICY, &adaptPolicyItem);

    // 水平对齐：首部对齐（ARKUI_TEXT_ALIGNMENT_START）
    ArkUI_NumberValue hAlignVal = {.i32 = ARKUI_TEXT_ALIGNMENT_START};
    ArkUI_AttributeItem hAlignItem = {&hAlignVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_ALIGN, &hAlignItem);

    // 首行缩进
    ArkUI_NumberValue indentVal = {.f32 = VALUE_30};
    ArkUI_AttributeItem indentItem = {&indentVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_INDENT, &indentItem);

    // 省略位置：行首省略（ARKUI_ELLIPSIS_MODE_START）
    ArkUI_NumberValue ellipsisVal = {.i32 = ARKUI_ELLIPSIS_MODE_START};
    ArkUI_AttributeItem ellipsisItem = {&ellipsisVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_ELLIPSIS_MODE, &ellipsisItem);

    // 复制粘贴：不支持复制（ARKUI_COPY_OPTIONS_NONE / ARKUI_TEXT_COPY_OPTIONS_NONE）
    ArkUI_NumberValue copyOptVal = {.i32 = ARKUI_COPY_OPTIONS_NONE};
    ArkUI_AttributeItem copyOptItem = {&copyOptVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_COPY_OPTION, &copyOptItem);

    // 断行规则：CJK任意断行（ARKUI_WORD_BREAK_NORMAL）
    ArkUI_NumberValue wordBreakVal = {.i32 = ARKUI_WORD_BREAK_NORMAL};
    ArkUI_AttributeItem wordBreakItem = {&wordBreakVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_WORD_BREAK, &wordBreakItem);

    // 文本行间距
    ArkUI_NumberValue lineSpaceVal = {.f32 = VALUE_10};
    ArkUI_AttributeItem lineSpaceItem = {&lineSpaceVal, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_LINE_SPACING, &lineSpaceItem);
    // 设置文本装饰
    ArkUI_NumberValue textDecoration[] = {
        {.i32 = ARKUI_TEXT_DECORATION_TYPE_UNDERLINE}, {.u32 = 0xFFFF0000}, {.i32 = ARKUI_TEXT_DECORATION_STYLE_SOLID}};
    ArkUI_AttributeItem textDecorationItem = {.value = textDecoration, .size = VALUE_3};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_DECORATION, &textDecorationItem);

    // 设置text样式
    ArkUI_NumberValue textFont[] = {
        {.f32 = VALUE_5}, {.i32 = ARKUI_FONT_WEIGHT_W600}, {.i32 = ARKUI_FONT_STYLE_NORMAL}};
    ArkUI_AttributeItem textFontItem = {textFont, VALUE_3};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_WORD_BREAK, &textFontItem);
    // 文本大小写属性
    ArkUI_NumberValue textCase = {.i32 = ARKUI_TEXT_CASE_UPPER};
    ArkUI_AttributeItem textCaseItem = {&textCase, VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CASE, &textCaseItem);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_TEXT_LINE_COUNT :%{public}d",
                 Manager::nodeAPI_->getAttribute(text3, NODE_TEXT_LINE_COUNT)->value[VALUE_0].i32);
    // 设置文本识别
    ArkUI_NumberValue enableDataDetector = {.i32 = true};
    ArkUI_AttributeItem enableDataDetectorItem = {.value = &enableDataDetector, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_ENABLE_DATA_DETECTOR, &enableDataDetectorItem);
    ArkUI_NumberValue detectorConfig = {.i32 = ARKUI_TEXT_DATA_DETECTOR_TYPE_PHONE_NUMBER};
    ArkUI_AttributeItem detectorConfigItem = {.value = &detectorConfig, .size = VALUE_2};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_ENABLE_DATA_DETECTOR_CONFIG, &detectorConfigItem);
    // 文本设置TextDataDetectorConfig且识别成功时，触发onDetectResultUpdate回调
    Manager::nodeAPI_->registerNodeEvent(text3, NODE_TEXT_ON_DETECT_RESULT_UPDATE, EVENT_TEXT_DETECT_RESULT_UPDATE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
}

void setText4(ArkUI_NodeHandle &text4)
{
    const char *textContent = "这里是第四个文本";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(text4, NODE_TEXT_CONTENT, &contentItem);

    // 设置文本行高
    ArkUI_NumberValue lineHeight = {.f32 = VALUE_50};
    ArkUI_AttributeItem lineHeightItem = {&lineHeight, VALUE_1};
    Manager::nodeAPI_->setAttribute(text4, NODE_TEXT_LINE_HEIGHT, &lineHeightItem);

    // 文本基线的偏移量属性
    ArkUI_NumberValue baselineOffset = {.f32 = VALUE_50};
    ArkUI_AttributeItem baselineOffsetItem = {&baselineOffset, VALUE_1};
    Manager::nodeAPI_->setAttribute(text4, NODE_TEXT_BASELINE_OFFSET, &baselineOffsetItem);

    // 文字阴影效果属性
    ArkUI_NumberValue textShadow[] = {
        {.f32 = VALUE_5}, {.i32 = ARKUI_SHADOW_TYPE_BLUR}, {.u32 = 0xFFFF0000}, {.f32 = VALUE_5}, {.f32 = VALUE_5}};
    ArkUI_AttributeItem textShadowItem = {textShadow, VALUE_5};
    Manager::nodeAPI_->setAttribute(text4, NODE_TEXT_TEXT_SHADOW, &textShadowItem);

    // Text最大显示字号
    ArkUI_NumberValue maxFontSize = {.f32 = VALUE_10};
    ArkUI_AttributeItem maxFontSizeItem = {&maxFontSize, VALUE_1};
    Manager::nodeAPI_->setAttribute(text4, NODE_TEXT_MAX_FONT_SIZE, &maxFontSizeItem);

    // 设置NODE_FONT_FEATURE
    ArkUI_AttributeItem fontFeatureItem = {.string = "ss01"};
    Manager::nodeAPI_->setAttribute(text4, NODE_FONT_FEATURE, &fontFeatureItem);

    // Text最大显示字号ARKUI_FONT_WEIGHT_W500
    ArkUI_NumberValue fontWeight = {.i32 = ARKUI_FONT_WEIGHT_W500};
    ArkUI_AttributeItem fontWeightItem = {&fontWeight, VALUE_1};
    Manager::nodeAPI_->setAttribute(text4, NODE_IMMUTABLE_FONT_WEIGHT, &fontWeightItem);
    ArkUI_AttributeItem fontfamily = {.string = "字体"};
    Manager::nodeAPI_->setAttribute(text4, NODE_FONT_FAMILY, &fontfamily);
}

void setText5(ArkUI_NodeHandle &text5)
{
    const char *textContent = "this is text 5";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(text5, NODE_TEXT_CONTENT, &contentItem);
    // 渐变
    ArkUI_NumberValue linearGradient[] = {{.f32 = ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM},
                                          {.i32 = ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM},
                                          {.i32 = VALUE_0}};
    ArkUI_AttributeItem linearGradientItem = {linearGradient, VALUE_3};
    Manager::nodeAPI_->setAttribute(text5, NODE_TEXT_LINEAR_GRADIENT, &linearGradientItem);
    ArkUI_NumberValue radialGradient[] = {{.f32 = ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM},
                                          {.i32 = ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM},
                                          {.i32 = VALUE_0}};
    ArkUI_AttributeItem radialGradientItem = {radialGradient, VALUE_3};
    Manager::nodeAPI_->setAttribute(text5, NODE_TEXT_RADIAL_GRADIENT, &radialGradientItem);
}

void setTextArea3(ArkUI_NodeHandle &textArea3)
{
    // 多行文本输入框的默认提示文本内容属性
    const char *textAreaText = "触发回调测试";
    ArkUI_AttributeItem textAreaTextItem = {.string = textAreaText};
    Manager::nodeAPI_->setAttribute(textArea3, NODE_TEXT_AREA_PLACEHOLDER, &textAreaTextItem);
    // 长按输入框内部区域弹出剪贴板后，点击剪切板粘贴按钮，触发该回调
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_PASTE, EVENT_TEXT_AREA_PASTE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 文本选择的位置发生变化时，触发该回调
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_TEXT_SELECTION_CHANGE,
                                         EVENT_TEXT_AREA_SELECTION_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 文本内容滚动时，触发该回调。触发该事件的条件：文本内容滚动时
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_CONTENT_SCROLL, EVENT_TEXT_AREA_CONTENT_SCROLL,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 输入状态变化时，触发该回调
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_EDIT_CHANGE, EVENT_TEXT_AREA_EDIT_CHANGE,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // TextArea按下输入法回车键触发该事件
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_SUBMIT, EVENT_TEXT_AREA_SUBMIT, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // TextArea输入内容发生变化时触发该事件
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_CONTENT_SIZE_CHANGE,
                                         EVENT_TEXT_AREA_CONTENT_SIZE_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 定义在输入完成时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_DID_INSERT, EVENT_TEXT_AREA_DID_INSERT, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 定义在删除完成时，触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_DID_DELETE, EVENT_TEXT_AREA_DID_DELETE, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 定义TextArea组件在内容改变时（包含预上屏内容），触发回调的枚举值
    Manager::nodeAPI_->registerNodeEvent(textArea3, NODE_TEXT_AREA_ON_CHANGE_WITH_PREVIEW_TEXT,
                                         EVENT_TEXT_AREA_CHANGE_PREVIEW, nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver(&OnEventReceive);
    // 设置支持滚动时节点的最大行数
    ArkUI_NumberValue maxLinesWithScroll = {.i32 = VALUE_10};
    ArkUI_AttributeItem maxLinesWithScrollItem = {&maxLinesWithScroll, VALUE_1};
    Manager::nodeAPI_->setAttribute(textArea3, NODE_TEXT_AREA_MAX_LINES_WITH_SCROLL, &maxLinesWithScrollItem);
}

void setAccessibility(ArkUI_NodeHandle &accessibilityText)
{
    ArkUI_AccessibilityValue *accessibilityLabelVal = OH_ArkUI_AccessibilityValue_Create();
    OH_ArkUI_AccessibilityValue_SetText(accessibilityLabelVal, "这里设置了一段无障碍文本");
    const char *a11yItemVal = OH_ArkUI_AccessibilityValue_GetText(accessibilityLabelVal);
    ArkUI_AttributeItem a11yItem = {.string = a11yItemVal};
    Manager::nodeAPI_->setAttribute(accessibilityText, NODE_TEXT_CONTENT, &a11yItem);
}

void setCustom(ArkUI_NodeHandle &customSpan)
{
    Manager::nodeAPI_->registerNodeCustomEvent(customSpan, ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE, VALUE_1, nullptr);
    Manager::nodeAPI_->registerNodeCustomEvent(customSpan, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW, VALUE_1, nullptr);
    Manager::nodeAPI_->registerNodeCustomEventReceiver([](ArkUI_NodeCustomEvent *event) {
        auto eventId = OH_ArkUI_NodeCustomEvent_GetEventTargetId(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "EventID:%{public}d", eventId);
        if (eventId == VALUE_0) {
            ArkUI_CustomSpanMeasureInfo *measureInfo = OH_ArkUI_CustomSpanMeasureInfo_Create();
            OH_ArkUI_NodeCustomEvent_GetCustomSpanMeasureInfo(event, measureInfo);
            OH_ArkUI_CustomSpanMeasureInfo_Dispose(measureInfo);
            ArkUI_CustomSpanMetrics *customSpanMetrics = OH_ArkUI_CustomSpanMetrics_Create();
            OH_ArkUI_CustomSpanMetrics_SetHeight(customSpanMetrics, 120.0f);
            OH_ArkUI_CustomSpanMetrics_SetWidth(customSpanMetrics, 80.0f);
            OH_ArkUI_NodeCustomEvent_SetCustomSpanMetrics(event, customSpanMetrics);
            OH_ArkUI_CustomSpanMetrics_Dispose(customSpanMetrics);
        }
        if (eventId == VALUE_1) {
            auto *layoutConstraint = OH_ArkUI_NodeCustomEvent_GetLayoutConstraintInMeasure(event);
            auto *drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
            auto *drawingHandle = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
            auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
            ArkUI_CustomSpanDrawInfo *customSpanDrawInfo = OH_ArkUI_CustomSpanDrawInfo_Create();
            OH_ArkUI_NodeCustomEvent_GetCustomSpanDrawInfo(event, customSpanDrawInfo);
            float optionsX = OH_ArkUI_CustomSpanDrawInfo_GetXOffset(customSpanDrawInfo);
            float optionsLineTop = OH_ArkUI_CustomSpanDrawInfo_GetLineTop(customSpanDrawInfo);
            float optionsLineBottom = OH_ArkUI_CustomSpanDrawInfo_GetLineBottom(customSpanDrawInfo);
            float optionsBaseLine = OH_ArkUI_CustomSpanDrawInfo_GetBaseline(customSpanDrawInfo);
            OH_ArkUI_CustomSpanDrawInfo_Dispose(customSpanDrawInfo);
        }
    });
}

void setText6(ArkUI_NodeHandle &text6)
{
    // ImageSpan
    ArkUI_NodeHandle imageSpan = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE_SPAN);
    ArkUI_AttributeItem spanUrl = {.string = "/resources/base/media/background.png"};
    ArkUI_NumberValue widthVal[VALUE_1]{};
    widthVal[VALUE_0].f32 = 100.f;
    ArkUI_AttributeItem width = {.value = widthVal, .size = VALUE_1};
    ArkUI_NumberValue heightVal[VALUE_1]{};
    heightVal[VALUE_0].f32 = 100.f;
    ArkUI_AttributeItem height = {.value = heightVal, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_WIDTH, &width);
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_HEIGHT, &height);
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_SRC, &spanUrl);
    // 设置 NODE_IMAGE_SPAN_VERTICAL_ALIGNMENT
    ArkUI_NumberValue verticalAlignment = {.i32 = ARKUI_IMAGE_SPAN_ALIGNMENT_BOTTOM};
    ArkUI_AttributeItem verticalAlignmentItem = {&verticalAlignment, VALUE_1};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_VERTICAL_ALIGNMENT, &verticalAlignmentItem);
    // imageSpan组件占位图地址属性
    ArkUI_AttributeItem spanAlt = {.string = "/resources/base/media/startIcon.png"};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_ALT, &spanAlt);
    // 设置imageSpan组件的基线偏移量属性
    ArkUI_NumberValue baselineOffset = {.f32 = VALUE_10};
    ArkUI_AttributeItem baselineOffsetItem = {&baselineOffset, VALUE_1};
    Manager::nodeAPI_->setAttribute(imageSpan, NODE_IMAGE_SPAN_BASELINE_OFFSET, &baselineOffsetItem);
    Manager::nodeAPI_->addChild(text6, imageSpan);
}

void setText7(ArkUI_NodeHandle &text7)
{
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = VALUE_300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = VALUE_30}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = VALUE_1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_BORDER_WIDTH, &borderWidthItem);
    // OH_Drawing_开头的API是字体引擎提供的，typographyStyle表示段落样式。
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, OH_Drawing_TextAlign::TEXT_ALIGN_CENTER);
    OH_Drawing_SetTypographyTextMaxLines(typographyStyle, VALUE_10);
    // 创建 ArkUI_StyledString。
    ArkUI_StyledString *styledString = OH_ArkUI_StyledString_Create(typographyStyle, OH_Drawing_CreateFontCollection());
    // 创建文本样式，设置字体和颜色。
    OH_Drawing_TextStyle *textStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(textStyle, VALUE_28);
    OH_Drawing_SetTextStyleColor(textStyle, OH_Drawing_ColorSetArgb(0xFF, 0x70, 0x70, 0x70));
    // 文本样式的设置顺序push -> add -> pop.
    OH_ArkUI_StyledString_PushTextStyle(styledString, textStyle);
    OH_ArkUI_StyledString_AddText(styledString, "Hello");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    // 添加占位，此区域内不会绘制文字，可以在此位置挂载Image组件实现图文混排。
    OH_Drawing_PlaceholderSpan placeHolder{.width = VALUE_20, .height = VALUE_20};
    OH_ArkUI_StyledString_AddPlaceholder(styledString, &placeHolder);
    // 设置不同样式的文字
    OH_Drawing_TextStyle *worldTextStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(worldTextStyle, VALUE_28);
    OH_Drawing_SetTextStyleColor(worldTextStyle, OH_Drawing_ColorSetArgb(0xFF, 0x27, 0x87, 0xD9));
    OH_ArkUI_StyledString_PushTextStyle(styledString, worldTextStyle);
    OH_ArkUI_StyledString_AddText(styledString, "World!");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    // 依赖StyledString对象创建字体引擎的Typography，此时它已经包含了设置的文本及其样式。
    OH_Drawing_Typography *typography = OH_ArkUI_StyledString_CreateTypography(styledString);
    // 字体引擎布局方法，需传入一个宽度，此宽度需与Text组件宽度匹配。
    // 布局宽度 = Text组件宽度 - (左padding + 右padding)
    OH_Drawing_TypographyLayout(typography, VALUE_300);
    ArkUI_AttributeItem styledStringItem = {.object = styledString};
    // 布局完成后，通过NODE_TEXT_CONTENT_WITH_STYLED_STRING设置给Text组件。
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT_WITH_STYLED_STRING, &styledStringItem);
    OH_ArkUI_StyledString_Destroy(styledString);
    Manager::nodeAPI_->addChild(text7, text);
}

static void MyTaskCallback(void *userData)
{
    if (!userData) {
        return;
    }
    // 将在这里完成自定义数据的处理。。。
    //进入text页面会打印信息
    ArkUI_NodeHandle textNode = static_cast<ArkUI_NodeHandle>(userData);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "修改数据成功");
}

void RunTaskInUIContext(ArkUI_NodeHandle targetNode)
{
    if (!targetNode || !Manager::nodeAPI_) {
        return;
    }
    ArkUI_ContextHandle uiCtx = OH_ArkUI_GetContextByNode(targetNode);
    int32_t ret = OH_ArkUI_RunTaskInScope(uiCtx, targetNode, MyTaskCallback);
}

static uint32_t MyInvertColor(uint32_t color)
{
    // color是0xARGB格式，比如0xFFFF0000（红）→ 反色0xFF00FFFF（青）
    uint32_t alpha = (color & 0xFF000000); // 保留透明度
    uint32_t rgb = color & 0x00FFFFFF;     // 提取RGB部分
    return alpha | (~rgb & 0x00FFFFFF);    // RGB反色，保留透明度
}

void SetComponentForceDark(ArkUI_NodeHandle &text5)
{
    //进入text页面会打印信息
    ArkUI_ContextHandle uiCtx = OH_ArkUI_GetContextByNode(text5);
    // 直接调用接口：上下文+开启反色+所有组件生效+自定义算法
    int32_t ret = OH_ArkUI_SetForceDarkConfig(uiCtx,                // UI上下文
                                              true,                 // 开启反色
                                              ARKUI_NODE_UNDEFINED, // 所有组件生效
                                              MyInvertColor);
    if (ret == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "反色设置成功");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "反色设置失败");
    }
}

void measuredInfo(ArkUI_NodeHandle &component)
{
    // 设置组件宽高
    //进入text页面会打印信息
    int32_t setMeasured = Manager::nodeAPI_->setMeasuredSize(component, VALUE_100, VALUE_100);
    if (setMeasured == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "manager", "设置尺寸成功");
    }
    // 创建约束尺寸
    ArkUI_LayoutConstraint *Constraint = OH_ArkUI_LayoutConstraint_Create();
    // 设置最大高度
    OH_ArkUI_LayoutConstraint_SetMaxHeight(Constraint, VALUE_100);
    // 获取组件宽高
    ArkUI_IntSize getMeasured = Manager::nodeAPI_->getMeasuredSize(component);
}

void setUIVal(ArkUI_NodeHandle &textContainer)
{
    ArkUI_NodeHandle text1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle text3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle text4 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle text5 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle textInput1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_INPUT);
    ArkUI_NodeHandle textInput2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_INPUT);
    ArkUI_NodeHandle textInput3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_INPUT);
    ArkUI_NodeHandle textArea1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_AREA);
    ArkUI_NodeHandle textArea2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_AREA);
    ArkUI_NodeHandle textArea3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT_AREA);
    ArkUI_NodeHandle accessibilityLabel = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle customSpan = Manager::nodeAPI_->createNode(ARKUI_NODE_CUSTOM_SPAN);
    ArkUI_NodeHandle text6 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle text7 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    measuredInfo(text4);
    setText1(text1);
    setText2(text2);
    setText3(text3);
    setText4(text4);
    setText5(text5);
    setText6(text6);
    setTextInput1(textInput1);
    setTextInput2(textInput2);
    setTextInput3(textInput3);
    setTextArea1(textArea1);
    setTextArea2(textArea2);
    setTextArea3(textArea3);
    setAccessibility(accessibilityLabel);
    setText7(text7);
    RunTaskInUIContext(text5);
    SetComponentForceDark(text5);
    Manager::nodeAPI_->addChild(textContainer, text1);
    Manager::nodeAPI_->addChild(textContainer, text2);
    Manager::nodeAPI_->addChild(textContainer, text3);
    Manager::nodeAPI_->addChild(textContainer, text4);
    Manager::nodeAPI_->addChild(textContainer, text5);
    Manager::nodeAPI_->addChild(textContainer, textInput1);
    Manager::nodeAPI_->addChild(textContainer, textInput2);
    Manager::nodeAPI_->addChild(textContainer, textInput3);
    Manager::nodeAPI_->addChild(textContainer, textArea1);
    Manager::nodeAPI_->addChild(textContainer, textArea2);
    Manager::nodeAPI_->addChild(textContainer, textArea3);
    Manager::nodeAPI_->addChild(textContainer, accessibilityLabel);
    Manager::nodeAPI_->addChild(textContainer, customSpan);
    Manager::nodeAPI_->addChild(textContainer, text6);
    Manager::nodeAPI_->addChild(textContainer, text7);
}

ArkUI_NodeHandle TextMaker::CreateNativeNode()
{
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    ArkUI_NodeHandle textContainer = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = VALUE_400}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = VALUE_1};
    Manager::nodeAPI_->setAttribute(textContainer, NODE_WIDTH, &widthItem);
    setUIVal(textContainer);
    Manager::nodeAPI_->addChild(scroll, textContainer);
    return scroll;
}