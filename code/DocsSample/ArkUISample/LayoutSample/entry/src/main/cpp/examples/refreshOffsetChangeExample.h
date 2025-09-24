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

#ifndef CAPI0805_2_VISIBLEAREACHANGE_REFACTORED_H
#define CAPI0805_2_VISIBLEAREACHANGE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIListNode.h"
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

// 常量定义
namespace RefreshConstants {
constexpr int LIST_ITEM_COUNT = 50;
constexpr int BUTTON_WIDTH = 200;
constexpr int TEXT_FONT_SIZE = 16;
constexpr uint32_t LIST_BACKGROUND_COLOR = 0xFF808080;
constexpr float VISIBLE_AREA_RATIO = 0.5f;
constexpr float OFFSET_INCREMENT = 10.0f;
} // namespace RefreshConstants

std::shared_ptr<ArkUITextNode> CreateRefreshListItemText(int index)
{
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent("item-" + std::to_string(index));
    text->SetHeight(Sizes::EXTRA_LARGE);
    text->SetPercentWidth(Percentages::NINETY_PERCENT);
    text->SetFontSize(RefreshConstants::TEXT_FONT_SIZE);
    text->SetBorderRadius(Sizes::MARGIN_MEDIUM);
    text->SetBackgroundColor(Colors::LIGHT_GRAY);
    text->SetTextAlignment(ARKUI_TEXT_ALIGNMENT_CENTER);

    // 注册事件
    text->SetRegisterRefreshEvent();
    text->SetVisibleAreaChangeRatio(RefreshConstants::VISIBLE_AREA_RATIO);
    text->SetRegisterVisibleAreaChangeEvent();

    return text;
}

std::shared_ptr<ArkUIListItemNode> CreateRefreshListItem(std::shared_ptr<ArkUITextNode> text)
{
    auto child = std::make_shared<ArkUIListItemNode>();
    child->AddChild(text);
    child->SetMargin(Sizes::MARGIN_MEDIUM);
    return child;
}

struct ListWithTexts {
    std::shared_ptr<ArkUIListNode> list;
    std::vector<std::shared_ptr<ArkUITextNode>> texts;
};

ListWithTexts CreateRefreshPopulatedList()
{
    auto list = std::make_shared<ArkUIListNode>();
    std::vector<std::shared_ptr<ArkUITextNode>> texts;

    // 创建列表项
    for (int i = 0; i < RefreshConstants::LIST_ITEM_COUNT; ++i) {
        auto text = CreateRefreshListItemText(i);
        auto listItem = CreateRefreshListItem(text);
        list->AddChild(listItem);
        texts.push_back(text);
    }

    return {list, texts};
}

void ConfigureRefreshListProperties(std::shared_ptr<ArkUIListNode> list)
{
    list->SetBackgroundColor(RefreshConstants::LIST_BACKGROUND_COLOR);
    list->SetLayoutWeight(1);
    list->SetScrollBar(ARKUI_SCROLL_BAR_DISPLAY_MODE_AUTO);
    list->SetListItemAlign(ARKUI_LIST_ITEM_ALIGNMENT_CENTER);
}

std::shared_ptr<ArkUITextNode> CreateRefreshOffsetButton(const std::vector<std::shared_ptr<ArkUITextNode>>& texts)
{
    auto btn = std::make_shared<ArkUITextNode>();
    btn->SetTextContent("refreshOffset+50");
    btn->SetWidth(RefreshConstants::BUTTON_WIDTH);
    btn->SetHeight(Sizes::MEDIUM);
    btn->SetBackgroundColor(Colors::YELLOW);

    // 使用shared_ptr管理偏移量
    auto offset = std::make_shared<float>(Sizes::MEDIUM);
    btn->SetOnClick([offset, texts]() {
        texts[Indices::ZERO]->SetRefreshOffset(*offset);
        *offset += RefreshConstants::OFFSET_INCREMENT;
    });

    return btn;
}

std::shared_ptr<ArkUIBaseNode> CreateRefreshOffsetEventExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();

    // 创建并配置列表 - 使用结构体避免C++17结构化绑定
    ListWithTexts listData = CreateRefreshPopulatedList();
    ConfigureRefreshListProperties(listData.list);
    column->AddChild(listData.list);

    // 创建按钮
    auto button = CreateRefreshOffsetButton(listData.texts);
    column->AddChild(button);

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_VISIBLEAREACHANGE_REFACTORED_H
