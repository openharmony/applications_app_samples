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

#include "SwiperMaker.h"
#include "baseUtils.h"
#include <arkui/native_node.h>
#include <cstdint>

namespace ConstIde {
    const float TEXT_WIDTH_VP = 500.0f;        // 宽度
    const float TEXT_HEIGHT_VP = 200.0f;       // 高度
    const uint32_t TEXT_BG_COLOR = 0xFFAFEEEE; // 淡蓝色
    const int32_t TEXT_ALIGN_CENTER = 1;       // 居中
    const float TEXT_FONT_SIZE_VP = 30.0f;     // 字体大小
    
    const uint32_t SHOW_BACKGROUND_ENABLED = 1;
    const uint32_t SHOW_SIDEBAR_MIDDLE_ENABLED = 1;
    const float ARROW_BACKGROUND_SIZE = 50.0;
    const uint32_t ARROW_BACKGROUND_COLOR = 0xffffffff; // 白色
    const float ARROW_SIZE = 37.5;
    const uint32_t ARROW_COLOR = 0xa9a9a9; // 浅灰色
    
    const float INDICATOR_START_DISTANCE_VP = 10.0; // 距左侧
    const float INDICATOR_END_DISTANCE_VP = 0.0;    // 距右侧
    const float INDICATOR_TOP_DISTANCE_VP = 10.0;   // 距顶部
    const float INDICATOR_BOTTOM_DISTANCE_VP = 0.0; // 距底部
    const float ITEM_WIDTH_VP = 12.0;
    const float ITEM_HEIGHT_VP = 6.0;
    const float SELECTED_ITEM_WIDTH_VP = 20.0;
    const float SELECTED_ITEM_HEIGHT_VP = 10.0;
    const uint32_t IGNORE_BOTTOM_SIZE_DISABLED = 0;       // 不忽略 SetBottomPosition
    const uint32_t MASK_ENABLED = 1;                      // 显示蒙版
    const uint32_t INDICATOR_COLOR_DEFAULT = 0xA9A9A9A9;  // 灰色
    const uint32_t INDICATOR_COLOR_SELECTED = 0xFFFF0000; // 红色
    const uint32_t MAX_DISPLAY_COUNT = 6;                 // 有效范围 [6,9]
    
    const float DIGIT_INDICATOR_START_DISTANCE_VP = 10.0;  // 距左侧
    const float DIGIT_INDICATOR_END_DISTANCE_VP = 0.0;     // 距右侧
    const float DIGIT_INDICATOR_TOP_DISTANCE_VP = 10.0;    // 距顶部
    const float DIGIT_INDICATOR_BOTTOM_DISTANCE_VP = 0.0;  // 距底部
    const uint32_t DIGIT_FONT_COLOR_DEFAULT = 0xA9A9A9A9;  // 淡灰色
    const uint32_t DIGIT_FONT_COLOR_SELECTED = 0xFFFF0000; // 红色
    const float DIGIT_FONT_SIZE_DEFAULT = 30.0;            // 默认字体大小
    const float DIGIT_FONT_SIZE_SELECTED = 50.0;           // 选中字体大小
    
    const uint32_t NUMBER_0 = 0;
    const uint32_t NUMBER_1 = 1;
    const uint32_t NUMBER_2 = 2;
    const uint32_t NUMBER_10 = 10;
    const uint32_t MARGIN_NUMBER_30 = 30;
    const float NUMBER_5_F = 5.0;
    const float NUMBER_400_F = 400.0;
    const float NUMBER_3000_MS = 3000.0;
    const uint32_t BACKGROUND_COLOR = 0x2AA1A6B1;
    const uint32_t DURATION = 1000;
} // namespace ConstIde

void SwiperMaker::createSwiperNode(ArkUI_NodeHandle &swiper)
{
    const int size = 11;
    // 设置swiper内容为0,1,2……
    const char *arr[size] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};

    for (int j = ConstIde::NUMBER_0; j < size; j++) {
        ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_AttributeItem content = {.string = arr[j]};
        Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &content);

        ArkUI_NumberValue value[] = {0};
        ArkUI_AttributeItem item = {.value = value, .size = 1};
        value[ConstIde::NUMBER_0].f32 = ConstIde::TEXT_WIDTH_VP;
        Manager::nodeAPI_->setAttribute(textNode, NODE_WIDTH, &item);
        value[ConstIde::NUMBER_0].f32 = ConstIde::TEXT_HEIGHT_VP;
        Manager::nodeAPI_->setAttribute(textNode, NODE_HEIGHT, &item);
        value[ConstIde::NUMBER_0].u32 = ConstIde::TEXT_BG_COLOR;
        Manager::nodeAPI_->setAttribute(textNode, NODE_BACKGROUND_COLOR, &item);
        value[ConstIde::NUMBER_0].i32 = ConstIde::TEXT_ALIGN_CENTER;
        Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_ALIGN, &item);
        value[ConstIde::NUMBER_0].f32 = ConstIde::TEXT_FONT_SIZE_VP;
        Manager::nodeAPI_->setAttribute(textNode, NODE_FONT_SIZE, &item);

        ArkUI_AttributeItem textId = {.string = "SwiperAutoPlayText"};
        Manager::nodeAPI_->setAttribute(textNode, NODE_ID, &textId);
        Manager::nodeAPI_->addChild(swiper, textNode);
    }
    BaseUtils::SetNodeMargin(swiper, ConstIde::MARGIN_NUMBER_30); // 设置边距宽度为30vp
}

void SwiperMaker::SetSwiperArrowStyle(ArkUI_NodeHandle &swiper)
{
    ArkUI_SwiperArrowStyle *arrowStyle = OH_ArkUI_SwiperArrowStyle_Create();
    OH_ArkUI_SwiperArrowStyle_SetShowBackground(arrowStyle, ConstIde::SHOW_BACKGROUND_ENABLED);
    OH_ArkUI_SwiperArrowStyle_SetShowSidebarMiddle(arrowStyle, ConstIde::SHOW_SIDEBAR_MIDDLE_ENABLED);
    OH_ArkUI_SwiperArrowStyle_SetBackgroundSize(arrowStyle, ConstIde::ARROW_BACKGROUND_SIZE);
    OH_ArkUI_SwiperArrowStyle_SetBackgroundColor(arrowStyle, ConstIde::ARROW_BACKGROUND_COLOR);
    OH_ArkUI_SwiperArrowStyle_SetArrowSize(arrowStyle, ConstIde::ARROW_SIZE);
    OH_ArkUI_SwiperArrowStyle_SetArrowColor(arrowStyle, ConstIde::ARROW_COLOR);

    ArkUI_NumberValue value[ConstIde::NUMBER_1];
    ArkUI_AttributeItem item = {.value = value, .size = ConstIde::NUMBER_1, .object = arrowStyle};
    value[ConstIde::NUMBER_0].i32 = ARKUI_SWIPER_ARROW_SHOW; // default ARKUI_SWIPER_ARROW_HIDE
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_SHOW_DISPLAY_ARROW, &item);
    OH_ArkUI_SwiperArrowStyle_Destroy(arrowStyle);
}

void SwiperMaker::GetSwiperArrowStyle(ArkUI_NodeHandle swiper)
{
    auto nodeSwiperShowDisplayArrow = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_SHOW_DISPLAY_ARROW);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow NODE_SWIPER_SHOW_DISPLAY_ARROW %{public}d",
                 nodeSwiperShowDisplayArrow->value[ConstIde::NUMBER_0].i32);
    auto arrowStyleObject = static_cast<ArkUI_SwiperArrowStyle*>(nodeSwiperShowDisplayArrow->object);
    auto iRet = OH_ArkUI_SwiperArrowStyle_GetShowBackground(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetShowBackground %{public}d", iRet);
    iRet = OH_ArkUI_SwiperArrowStyle_GetShowSidebarMiddle(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetShowSidebarMiddle %{public}d", iRet);
    auto fRet = OH_ArkUI_SwiperArrowStyle_GetBackgroundSize(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetBackgroundSize %{public}f", fRet);
    auto uRet = OH_ArkUI_SwiperArrowStyle_GetBackgroundColor(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetBackgroundColor %{public}x", uRet);
    fRet = OH_ArkUI_SwiperArrowStyle_GetArrowSize(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetArrowSize %{public}f", fRet);
    uRet = OH_ArkUI_SwiperArrowStyle_GetArrowColor(arrowStyleObject);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Arrow GetArrowColor %{public}x", uRet);
}

void SwiperMaker::SetSwiperIndicatorTypeDot(ArkUI_NodeHandle &swiper)
{
    ArkUI_SwiperIndicator *swiperIndicatorStyle = OH_ArkUI_SwiperIndicator_Create(ARKUI_SWIPER_INDICATOR_TYPE_DOT);
    OH_ArkUI_SwiperIndicator_SetStartPosition(swiperIndicatorStyle, ConstIde::INDICATOR_START_DISTANCE_VP);
    OH_ArkUI_SwiperIndicator_SetEndPosition(swiperIndicatorStyle, ConstIde::INDICATOR_END_DISTANCE_VP);
    OH_ArkUI_SwiperIndicator_SetTopPosition(swiperIndicatorStyle, ConstIde::INDICATOR_TOP_DISTANCE_VP);
    OH_ArkUI_SwiperIndicator_SetBottomPosition(swiperIndicatorStyle, ConstIde::INDICATOR_BOTTOM_DISTANCE_VP);
    OH_ArkUI_SwiperIndicator_SetIgnoreSizeOfBottom(swiperIndicatorStyle, ConstIde::IGNORE_BOTTOM_SIZE_DISABLED);
    OH_ArkUI_SwiperIndicator_SetItemWidth(swiperIndicatorStyle, ConstIde::ITEM_WIDTH_VP);
    OH_ArkUI_SwiperIndicator_SetItemHeight(swiperIndicatorStyle, ConstIde::ITEM_HEIGHT_VP);
    OH_ArkUI_SwiperIndicator_SetSelectedItemWidth(swiperIndicatorStyle, ConstIde::SELECTED_ITEM_WIDTH_VP);
    OH_ArkUI_SwiperIndicator_SetSelectedItemHeight(swiperIndicatorStyle, ConstIde::SELECTED_ITEM_HEIGHT_VP);
    OH_ArkUI_SwiperIndicator_SetMask(swiperIndicatorStyle, ConstIde::MASK_ENABLED);
    OH_ArkUI_SwiperIndicator_SetColor(swiperIndicatorStyle, ConstIde::INDICATOR_COLOR_DEFAULT);
    OH_ArkUI_SwiperIndicator_SetSelectedColor(swiperIndicatorStyle, ConstIde::INDICATOR_COLOR_SELECTED);
    OH_ArkUI_SwiperIndicator_SetMaxDisplayCount(swiperIndicatorStyle, ConstIde::MAX_DISPLAY_COUNT);

    ArkUI_NumberValue value[ConstIde::NUMBER_1];
    ArkUI_AttributeItem item = {.value = value, .size = ConstIde::NUMBER_1, .object = swiperIndicatorStyle};
    value[ConstIde::NUMBER_0].i32 = ARKUI_SWIPER_INDICATOR_TYPE_DOT; // Different enum use different objects
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_INDICATOR, &item);

    OH_ArkUI_SwiperIndicator_Dispose(swiperIndicatorStyle);
}

void SwiperMaker::GetSwiperIndicatorTypeDot(ArkUI_NodeHandle swiper)
{
    auto nodeSwiperIndicator = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_INDICATOR);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "NODE_SWIPER_INDICATOR %{public}d",
                 nodeSwiperIndicator->value[ConstIde::NUMBER_0].i32);
    auto swiperIndicatorStyleObject = static_cast<ArkUI_SwiperIndicator*>(nodeSwiperIndicator->object);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "StartPosition: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetStartPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "EndPosition: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetEndPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "TopPosition: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetTopPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "BottomPosition: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetBottomPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IgnoreSizeOfBottom: %{public}d",
                 OH_ArkUI_SwiperIndicator_GetIgnoreSizeOfBottom(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "ItemWidth: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetItemWidth(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "ItemHeight: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetItemHeight(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "ItemHeight: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetSelectedItemWidth(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "ItemHeight: %{public}f",
                 OH_ArkUI_SwiperIndicator_GetSelectedItemHeight(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Mask: %{public}d",
                 OH_ArkUI_SwiperIndicator_GetMask(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "Color: %{public}x",
                 OH_ArkUI_SwiperIndicator_GetColor(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "SelectedColor: %{public}x",
                 OH_ArkUI_SwiperIndicator_GetSelectedColor(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "MaxDisplayCount: %{public}d",
                 OH_ArkUI_SwiperIndicator_GetMaxDisplayCount(swiperIndicatorStyleObject));
}

void SwiperMaker::SetSwiperIndicatorTypeDigit(ArkUI_NodeHandle &swiper)
{
    ArkUI_SwiperDigitIndicator *swiperIndicatorStyle = OH_ArkUI_SwiperDigitIndicator_Create();
    OH_ArkUI_SwiperDigitIndicator_SetStartPosition(swiperIndicatorStyle, ConstIde::DIGIT_INDICATOR_START_DISTANCE_VP);
    OH_ArkUI_SwiperDigitIndicator_SetEndPosition(swiperIndicatorStyle, ConstIde::DIGIT_INDICATOR_END_DISTANCE_VP);
    OH_ArkUI_SwiperDigitIndicator_SetTopPosition(swiperIndicatorStyle, ConstIde::DIGIT_INDICATOR_TOP_DISTANCE_VP);
    OH_ArkUI_SwiperDigitIndicator_SetBottomPosition(swiperIndicatorStyle, ConstIde::DIGIT_INDICATOR_BOTTOM_DISTANCE_VP);
    OH_ArkUI_SwiperDigitIndicator_SetFontColor(swiperIndicatorStyle, ConstIde::DIGIT_FONT_COLOR_DEFAULT);
    OH_ArkUI_SwiperDigitIndicator_SetSelectedFontColor(swiperIndicatorStyle, ConstIde::DIGIT_FONT_COLOR_SELECTED);
    OH_ArkUI_SwiperDigitIndicator_SetFontSize(swiperIndicatorStyle, ConstIde::DIGIT_FONT_SIZE_DEFAULT);
    OH_ArkUI_SwiperDigitIndicator_SetSelectedFontSize(swiperIndicatorStyle, ConstIde::DIGIT_FONT_SIZE_SELECTED);
    OH_ArkUI_SwiperDigitIndicator_SetFontWeight(swiperIndicatorStyle, ARKUI_FONT_WEIGHT_W200);
    OH_ArkUI_SwiperDigitIndicator_SetSelectedFontWeight(swiperIndicatorStyle, ARKUI_FONT_WEIGHT_W700);

    ArkUI_NumberValue value[ConstIde::NUMBER_1];
    ArkUI_AttributeItem item = {.value = value, .size = ConstIde::NUMBER_1, .object = swiperIndicatorStyle};
    value[ConstIde::NUMBER_0].i32 = ARKUI_SWIPER_INDICATOR_TYPE_DIGIT; // Different enum use different objects
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_INDICATOR, &item);

    OH_ArkUI_SwiperDigitIndicator_Destroy(swiperIndicatorStyle);
}

void SwiperMaker::GetSwiperIndicatorTypeDigit(ArkUI_NodeHandle swiper)
{
    auto nodeSwiperIndicator = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_INDICATOR);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "NODE_SWIPER_INDICATOR  %{public}d",
                 nodeSwiperIndicator->value[ConstIde::NUMBER_0].i32);
    auto swiperIndicatorStyleObject = static_cast<ArkUI_SwiperDigitIndicator*>(nodeSwiperIndicator->object);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "StartPosition: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetStartPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "EndPosition: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetEndPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "TopPosition: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetBottomPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "BottomPosition: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetTopPosition(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "FontColor: %{public}x",
                 OH_ArkUI_SwiperDigitIndicator_GetFontColor(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "SelectedFontColor: %{public}x",
                 OH_ArkUI_SwiperDigitIndicator_GetSelectedFontColor(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "FontSize: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetFontSize(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "SelectedFontColor: %{public}f",
                 OH_ArkUI_SwiperDigitIndicator_GetSelectedFontSize(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "FontWeight: %{public}d",
                 OH_ArkUI_SwiperDigitIndicator_GetFontWeight(swiperIndicatorStyleObject));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "SelectedFontWeight: %{public}d",
                 OH_ArkUI_SwiperDigitIndicator_GetSelectedFontWeight(swiperIndicatorStyleObject));
}

void SwiperMaker::SetSwiperAttributeLoop(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value=value, .size=1};
    value[0].i32 = 1;        // default 1
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_LOOP, &item);
    
    auto nodeSwiperLoop = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_LOOP);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_LOOP %{public}d", nodeSwiperLoop->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeAutoPlay(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value=value, .size=2};
    value[0].i32 = 1;           // default 0
    value[1].i32 = 0;           // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_AUTO_PLAY, &item);
    
    auto nodeSwiperAutoPlay = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_AUTO_PLAY);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_AUTO_PLAY_0 %{public}d",
                 nodeSwiperAutoPlay->value[0].i32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_AUTO_PLAY_1 %{public}d",
                 nodeSwiperAutoPlay->value[1].i32);
}

void SwiperMaker::SetSwiperAttributeShowIndicator(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = 0; // default 1
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_SHOW_INDICATOR, &item);

    auto nodeSwiperShowIndicator = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_SHOW_INDICATOR);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_SHOW_INDICATOR %{public}d",
                 nodeSwiperShowIndicator->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeInterval(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].f32 = ConstIde::NUMBER_3000_MS;
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_INTERVAL, &item);

    auto nodeSwiperInterval = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_INTERVAL);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_INTERVAL %{public}f",
                 nodeSwiperInterval->value[0].f32);
}

void SwiperMaker::SetSwiperAttributeVertical(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = 0; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_VERTICAL, &item);

    auto nodeSwiperVertical = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_VERTICAL);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_VERTICAL %{public}d",
                 nodeSwiperVertical->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeDuration(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].f32 = ConstIde::DURATION; // default 400
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_DURATION, &item);

    auto nodeSwiperDuration = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_DURATION);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_DURATION %{public}f",
                 nodeSwiperDuration->value[0].f32);
}

void SwiperMaker::SetSwiperAttributeCurve(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = ARKUI_CURVE_LINEAR; // default ARKUI_CURVE_LINEAR
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_CURVE, &item);

    auto nodeSwiperCurve = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_CURVE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_CURVE %{public}d", nodeSwiperCurve->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeItemSpace(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].f32 = ConstIde::NUMBER_5_F;
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_ITEM_SPACE, &item);

    auto nodeSwiperItemSpace = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_ITEM_SPACE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_ITEM_SPACE %{public}f",
                 nodeSwiperItemSpace->value[0].f32);
}

void SwiperMaker::SetSwiperAttributeIndex(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].i32 = 1;
    value[1].i32 = ARKUI_SWIPER_NO_ANIMATION;
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_INDEX, &item);

    auto nodeSwiperIndex = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_INDEX);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_INDEX %{public}d", nodeSwiperIndex->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeDisplayCount(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].i32 = ConstIde::NUMBER_2;
    value[1].i32 = 0; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_DISPLAY_COUNT, &item);

    auto nodeSwiperDisplayCount = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_DISPLAY_COUNT);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_DISPLAY_COUNT_0 %{public}d",
                 nodeSwiperDisplayCount->value[0].i32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_DISPLAY_COUNT_1 %{public}i",
                 nodeSwiperDisplayCount->value[1].i32);
}

void SwiperMaker::SetSwiperAttributeDisableSwipe(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = 0; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_DISABLE_SWIPE, &item);

    auto nodeSwiperDisableSwipe = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_DISABLE_SWIPE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_DISABLE_SWIPE %{public}d",
                 nodeSwiperDisableSwipe->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeEdgeEffectMode(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = ARKUI_EDGE_EFFECT_SPRING; // default ARKUI_EDGE_EFFECT_SPRING
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_EDGE_EFFECT_MODE, &item);

    auto nodeSwiperEdgeEffectMode = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_EDGE_EFFECT_MODE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_EDGE_EFFECT_MODE %{public}d",
                 nodeSwiperEdgeEffectMode->value[0].i32);
}

ArkUI_NodeAdapterHandle SwiperMaker::creatNodeAdapter()
{
    ArkUI_NodeAdapterHandle adapter = OH_ArkUI_NodeAdapter_Create();
    OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter, ConstIde::NUMBER_10);

    UserCallback *adapterCallback = new UserCallback();
    adapterCallback->callback = [](void *event) {
        auto *adapterEvent = reinterpret_cast<ArkUI_NodeAdapterEvent *>(event);
        auto type = OH_ArkUI_NodeAdapterEvent_GetType(adapterEvent);
        switch (type) {
            case NODE_ADAPTER_EVENT_WILL_ATTACH_TO_NODE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "Adapter attach to node.");
                break;
            }
            case NODE_ADAPTER_EVENT_WILL_DETACH_FROM_NODE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "Adapter detach from node.");
                break;
            }
            case NODE_ADAPTER_EVENT_ON_GET_NODE_ID: {
                auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(adapterEvent);
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "On get node id. %{public}d", index);
                // ......
                break;
            }
            case NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER: {
                auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(adapterEvent);
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "On add node to adapter. %{public}d", index);
                // ......
                break;
            }
            case NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER: {
                auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(adapterEvent);
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "On remove node from adapter. %{public}d", index);
                // ......
                break;
            }
        }
    };
    OH_ArkUI_NodeAdapter_RegisterEventReceiver(adapter, adapterCallback, [](ArkUI_NodeAdapterEvent *event) {
        auto *userData = reinterpret_cast<UserCallback *>(OH_ArkUI_NodeAdapterEvent_GetUserData(event));
        userData->callback(event);
    });
    return adapter;
}

void SwiperMaker::SetSwiperAttributeNodeAdapter(ArkUI_NodeHandle &swiper)
{
    ArkUI_NodeAdapterHandle adapter = creatNodeAdapter();
    ArkUI_AttributeItem item = {.object = adapter};
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_NODE_ADAPTER, &item);
    
    auto elementSize = OH_ArkUI_NodeAdapter_GetTotalNodeCount(adapter);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NodeAdapter_SetTotalNodeCount %{public}d", elementSize);
}

void SwiperMaker::SetSwiperAttributeCachedCount(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].i32 = ConstIde::NUMBER_2;
    value[1].i32 = 0; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_CACHED_COUNT, &item);

    auto nodeSwiperCachedCount = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_CACHED_COUNT);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_CACHED_COUNT_0 %{public}d",
                 nodeSwiperCachedCount->value[0].i32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_CACHED_COUNT_1 %{public}d",
                 nodeSwiperCachedCount->value[1].i32);
}

void SwiperMaker::SetSwiperAttributePrevMargin(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].f32 = ConstIde::NUMBER_5_F;
    value[1].i32 = 1; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_PREV_MARGIN, &item);

    auto nodeSwiperPrevMargin = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_PREV_MARGIN);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_PREV_MARGIN_0 %{public}f",
                 nodeSwiperPrevMargin->value[0].f32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_PREV_MARGIN_1 %{public}d",
                 nodeSwiperPrevMargin->value[1].i32);
}

void SwiperMaker::SetSwiperAttributeNextMargin(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].f32 = ConstIde::NUMBER_5_F;
    value[1].i32 = 1; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_NEXT_MARGIN, &item);

    auto nodeSwiperNextMargin = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_NEXT_MARGIN);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_NEXT_MARGIN_0 %{public}f",
                 nodeSwiperNextMargin->value[0].f32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_NEXT_MARGIN_1 %{public}d",
                 nodeSwiperNextMargin->value[1].i32);
}

void SwiperMaker::SetSwiperAttributeNestedScroll(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = ARKUI_SWIPER_NESTED_SRCOLL_SELF_ONLY; // default ARKUI_SWIPER_NESTED_SRCOLL_SELF_ONLY
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_NESTED_SCROLL, &item);

    auto nodeSwiperNestedScroll = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_NESTED_SCROLL);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_NESTED_SCROLL %{public}d",
                 nodeSwiperNestedScroll->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeSwipeToIndex(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].i32 = 1;
    value[1].i32 = 1; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_SWIPE_TO_INDEX, &item);
}

void SwiperMaker::SetSwiperAttributeIndicatorInteractive(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = 1; // default 1
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_INDICATOR_INTERACTIVE, &item);

    auto nodeSwiperIndicatorInteractive = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_INDICATOR_INTERACTIVE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_INDICATOR_INTERACTIVE %{public}d",
                 nodeSwiperIndicatorInteractive->value[0].i32);
}

void SwiperMaker::SetSwiperAttributePageFlipMode(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = ARKUI_PAGE_FLIP_MODE_SINGLE; // ARKUI_PAGE_FLIP_MODE_CONTINUOUS or ARKUI_PAGE_FLIP_MODE_SINGLE
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_PAGE_FLIP_MODE, &item);

    auto nodeSwiperPageFlipMode = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_PAGE_FLIP_MODE);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_PAGE_FLIP_MODE %{public}d",
                 nodeSwiperPageFlipMode->value[0].i32);
}

void SwiperMaker::SetSwiperAttributeAutoFill(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[2];
    ArkUI_AttributeItem item = {.value = value, .size = 2};
    value[0].f32 = ConstIde::NUMBER_400_F;
    value[1].i32 = 1; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_AUTO_FILL, &item);

    auto nodeSwiperAutoFill = Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_AUTO_FILL);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_AUTO_FILL_0 %{public}f",
                 nodeSwiperAutoFill->value[0].f32);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_AUTO_FILL_1 %{public}d",
                 nodeSwiperAutoFill->value[1].i32);
}

void SwiperMaker::SetSwiperAttributeMaintainVisibleContentPosition(ArkUI_NodeHandle &swiper)
{
    ArkUI_NumberValue value[1];
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].i32 = 1; // default 0
    Manager::nodeAPI_->setAttribute(swiper, NODE_SWIPER_MAINTAIN_VISIBLE_CONTENT_POSITION, &item);

    auto MaintainVisibleContentPosition =
        Manager::nodeAPI_->getAttribute(swiper, NODE_SWIPER_MAINTAIN_VISIBLE_CONTENT_POSITION);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "NODE_SWIPER_MAINTAIN_VISIBLE_CONTENT_POSITION %{public}d",
                 MaintainVisibleContentPosition->value[0].i32);
}

void SwiperMaker::SetSwiperEvent(ArkUI_NodeHandle &swiper)
{
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_CHANGE, ON_CHANGE, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_ANIMATION_START, ON_ANIMATION_START, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_ANIMATION_END, ON_ANIMATION_END, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_GESTURE_SWIPE, ON_GESTURE_SWIPE, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_CONTENT_DID_SCROLL, ON_CONTENT_DID_SCROLL,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_SELECTED, ON_SELECTED, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_UNSELECTED, ON_UNSELECTED, nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_CONTENT_WILL_SCROLL, ON_CONTENT_WILL_SCROLL,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_SCROLL_STATE_CHANGED, ON_SCROLL_STATE_CHANGED,
                                         nullptr);
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "eventID is %{public}d", eventId);
        if (eventId == ON_CHANGE) {
            EventOnChange(event);
        } else if (eventId == ON_ANIMATION_START) {
            EventOnAnimationStart(event);
        } else if (eventId == ON_ANIMATION_END) {
            EventOnAnimationEnd(event);
        } else if (eventId == ON_GESTURE_SWIPE) {
            EventOnGestureSwipe(event);
        } else if (eventId == ON_CONTENT_DID_SCROLL) {
            EventOnContentDidScroll(event);
        } else if (eventId == ON_SELECTED) {
            EventOnSelected(event);
        } else if (eventId == ON_UNSELECTED) {
            EventOnUnselected(event);
        } else if (eventId == ON_CONTENT_WILL_SCROLL) {
            EventOnContentWillScroll(event);
        } else if (eventId == ON_SCROLL_STATE_CHANGED) {
            EventOnScrollStateChanged(event);
        }
    });
}

void SwiperMaker::EventOnChange(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto index = componentEvent->data[0].i32;
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "index is %{public}d", index);
    }
}

void SwiperMaker::EventOnAnimationStart(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto currIdx = componentEvent->data[0].i32;      // index of the currently-displayed item
        auto targetIdx = componentEvent->data[1].i32;    // index of the item the animation is moving to
        auto currOffset = componentEvent->data[2].f32;   // current item's displacement from Swiper start
        auto targetOffset = componentEvent->data[3].f32; // target item's displacement from Swiper start
        auto velocity = componentEvent->data[4].f32;     // velocity when finger lifts (px/s)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currIdx is %{public}d", currIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "targetIdx is %{public}d", targetIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currOffset is %{public}f", currOffset);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "targetOffset is %{public}f", targetOffset);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "velocity is %{public}f", velocity);
    }
}

void SwiperMaker::EventOnAnimationEnd(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto currentIndex = componentEvent->data[0].i32;  // index of the currently-displayed item
        auto currentOffset = componentEvent->data[1].f32; // current item's displacement from Swiper start
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currentIndex is %{public}d", currentIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currentOffset is %{public}f", currentOffset);
    }
}

void SwiperMaker::EventOnGestureSwipe(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto currentIndex = componentEvent->data[0].i32;  // index of the currently-displayed item
        auto currentOffset = componentEvent->data[1].f32; // current item's displacement from Swiper start
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currentIndex is %{public}d", currentIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currentOffset is %{public}f", currentOffset);
    }
}

void SwiperMaker::EventOnContentDidScroll(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto selectedIdx = componentEvent->data[0].i32; // Swiper selected index (matches onChange index)
        auto pageIdx = componentEvent->data[1].i32;     // index of a page visible in viewport
        auto offsetRatio = componentEvent->data[2].f32; // page shift ratio vs. selected-page start (0 = aligned)
        auto pageSize = componentEvent->data[3].f32;    // page length along Swiper main axis
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "selectedIdx is %{public}d", selectedIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "pageIdx is %{public}d", pageIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "offsetRatio is %{public}f", offsetRatio);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "pageSize is %{public}f", pageSize);
    }
}

void SwiperMaker::EventOnSelected(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto selectedIndex = componentEvent->data[0].i32; // index of the currently selected item
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "selectedIndex is %{public}d", selectedIndex);
    }
}

void SwiperMaker::EventOnUnselected(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto unselectedIndex = componentEvent->data[0].i32; // index of the currently unselected item
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "unselectedIndex is %{public}d", unselectedIndex);
    }
}

void SwiperMaker::EventOnContentWillScroll(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto currIdx = componentEvent->data[0].i32;   // index of currently-displayed element
        auto targetIdx = componentEvent->data[1].i32; // index of element being animated to
        auto frameDx =
            componentEvent->data[2].f32; // per-frame slide offset: + = backward (e.g. 1→0), − = forward (e.g. 0→1)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "currIdx is %{public}d", currIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "targetIdx is %{public}d", targetIdx);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "frameDx is %{public}f", frameDx);
    }
}

void SwiperMaker::EventOnScrollStateChanged(ArkUI_NodeEvent *event)
{
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent) {
        auto scrollState = componentEvent->data[0].i32; // Current scroll status
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager", "scrollState is %{public}d", scrollState);
    }
}

void SwiperMaker::SetSwiperAttribute(ArkUI_NodeHandle &swiper)
{
    SetSwiperAttributeLoop(swiper);
    SetSwiperAttributeAutoPlay(swiper);
    SetSwiperAttributeShowIndicator(swiper);
    SetSwiperAttributeInterval(swiper);
    SetSwiperAttributeVertical(swiper);
    SetSwiperAttributeDuration(swiper);
    SetSwiperAttributeCurve(swiper);
    SetSwiperAttributeItemSpace(swiper);
    SetSwiperAttributeIndex(swiper);
    SetSwiperAttributeDisplayCount(swiper);
    SetSwiperAttributeDisableSwipe(swiper);
    SetSwiperAttributeEdgeEffectMode(swiper);
    SetSwiperAttributeNodeAdapter(swiper);
    SetSwiperAttributeCachedCount(swiper);
    SetSwiperAttributePrevMargin(swiper);
    SetSwiperAttributeNextMargin(swiper);
    SetSwiperAttributeNestedScroll(swiper);
    SetSwiperAttributeSwipeToIndex(swiper);
    SetSwiperAttributeIndicatorInteractive(swiper);
    SetSwiperAttributePageFlipMode(swiper);
    SetSwiperAttributeAutoFill(swiper);
    SetSwiperAttributeMaintainVisibleContentPosition(swiper);
    SetSwiperEvent(swiper);
}

ArkUI_NodeHandle SwiperMaker::CreateNativeNode()
{
    static ArkUI_NodeHandle swiper1 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    static ArkUI_NodeHandle swiper2 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    static ArkUI_NodeHandle swiper3 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    static ArkUI_NodeHandle swiper4 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    BaseUtils::SetNodeBackGroundColor(scroll, ConstIde::BACKGROUND_COLOR); // 设置节点背景颜色为淡灰色
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    SwiperMaker::createSwiperNode(swiper1);
    SwiperMaker::SetSwiperArrowStyle(swiper1);
    SwiperMaker::GetSwiperArrowStyle(swiper1);
    SwiperMaker::createSwiperNode(swiper2);
    SwiperMaker::SetSwiperIndicatorTypeDot(swiper2);
    SwiperMaker::GetSwiperIndicatorTypeDot(swiper2);
    SwiperMaker::createSwiperNode(swiper3);
    SwiperMaker::SetSwiperIndicatorTypeDigit(swiper3);
    SwiperMaker::GetSwiperIndicatorTypeDigit(swiper3);
    SwiperMaker::createSwiperNode(swiper4);
    SwiperMaker::SetSwiperAttribute(swiper4);
    Manager::nodeAPI_->addChild(column, swiper1);
    Manager::nodeAPI_->addChild(column, swiper2);
    Manager::nodeAPI_->addChild(column, swiper3);
    Manager::nodeAPI_->addChild(column, swiper4);
    Manager::nodeAPI_->addChild(scroll, column);
    return scroll;
}