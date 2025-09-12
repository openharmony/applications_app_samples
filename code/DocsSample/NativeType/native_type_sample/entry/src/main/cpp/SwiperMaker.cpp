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
    const uint32_t MARGIN_NUMBER_30 = 30;
    
    const uint32_t BACKGROUND_COLOR = 0x2AA1A6B1;
} // namespace ConstIde

void SwiperMaker::createSwiperNode(ArkUI_NodeHandle &swiper)
{
    const int size = 14;
    // 设置swiper内容为0,1,2……
    const char *arr[size] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"};

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

ArkUI_NodeHandle SwiperMaker::createSwiperPage()
{
    static ArkUI_NodeHandle swiper1 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    static ArkUI_NodeHandle swiper2 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
    static ArkUI_NodeHandle swiper3 = Manager::nodeAPI_->createNode(ARKUI_NODE_SWIPER);
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
    Manager::nodeAPI_->addChild(column, swiper1);
    Manager::nodeAPI_->addChild(column, swiper2);
    Manager::nodeAPI_->addChild(column, swiper3);
    Manager::nodeAPI_->addChild(scroll, column);
    return scroll;
}