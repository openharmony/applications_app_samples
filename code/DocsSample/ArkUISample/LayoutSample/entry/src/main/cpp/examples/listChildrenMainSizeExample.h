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

#ifndef CAPI0805_2_LISTCHILDRENMAINSIZEEXAMPLE_REFACTORED_H
#define CAPI0805_2_LISTCHILDRENMAINSIZEEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIRowNode.h"
#include "nodes/ArkUIListNode.h"

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIListItemNode> CreateListItem(int index)
{
    auto child = std::make_shared<ArkUIListItemNode>();
    auto text = std::make_shared<ArkUITextNode>();

    // 设置文本内容和样式
    text->SetTextContent("item-" + std::to_string(index));
    text->SetHeight(Sizes::MEDIUM);
    text->SetPercentWidth(Percentages::NINETY_PERCENT);
    text->SetFontSize(Sizes::FONT_SIZE_SMALL); // 特定字体大小
    text->SetBorderRadius(Sizes::MARGIN_MEDIUM);
    text->SetBackgroundColor(Colors::LIGHT_GRAY);
    text->SetTextAlignment(ARKUI_TEXT_ALIGNMENT_CENTER);

    // 设置列表项样式
    child->AddChild(text);
    child->SetMargin(Sizes::MARGIN_MEDIUM);

    return child;
}

std::shared_ptr<ArkUIListNode> CreateConfiguredList()
{
    auto list = std::make_shared<ArkUIListNode>();

    // 创建50个列表项
    for (int i = 0; i < Counts::TEXT_NODES_MAX * 5; i++) { // 50个项目
        auto listItem = CreateListItem(i);
        list->AddChild(listItem);
    }

    return list;
}

void ConfigureListProperties(std::shared_ptr<ArkUIListNode> list)
{
    // 设置列表基本属性
    list->SetLayoutWeight(1);
    list->SetScrollBar(ARKUI_SCROLL_BAR_DISPLAY_MODE_AUTO);

    // 设置列表项对齐方式
    list->SetListItemAlign(ARKUI_LIST_ITEM_ALIGNMENT_CENTER);
}

std::shared_ptr<ArkUITextNode> CreateInfoTextNode(const std::string& info)
{
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent(info);
    return text;
}

std::shared_ptr<ArkUIBaseNode> CreateListChildrenMainSizExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto list = CreateConfiguredList();
    ConfigureListProperties(list);

    // 设置子元素主尺寸示例
    auto value = list->SetChildrenMainSizeExample();
    column->AddChild(list);
    auto infoText = CreateInfoTextNode(value);
    column->AddChild(infoText);
    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_LISTCHILDRENMAINSIZEEXAMPLE_REFACTORED_H