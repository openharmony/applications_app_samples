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

#ifndef CAPI0805_2_FLEXEXAMPLE_REFACTORED_H
#define CAPI0805_2_FLEXEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIRowNode.h"

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUITextNode> CreateFlexTitle(const std::string &titleText)
{
    auto title = std::make_shared<ArkUITextNode>();
    title->SetTextContent(titleText);
    return title;
}

std::shared_ptr<ArkUIRowNode> CreateBasicFlexRow(int index, float width, float height)
{
    auto row = std::make_shared<ArkUIRowNode>();
    row->SetWidth(width);
    row->SetHeight(height);
    row->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, index));

    std::string id = Utils::GenerateId(IDs::ROW_PREFIX, index + 1);
    row->SetId(id.c_str());

    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent(id);
    row->AddChild(text);
    row->setJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);

    return row;
}

void ConfigureRowRadius(std::vector<std::shared_ptr<ArkUIRowNode>>& rows)
{
    // 设置圆角
    rows[Indices::ONE]->SetBorderRadiusPercent(Percentages::RADIUS_SMALL);
    rows[Indices::TWO]->SetBorderRadiusPercent(Percentages::RADIUS_SMALL, Percentages::RADIUS_MEDIUM,
                                               Percentages::RADIUS_LARGE, Percentages::RADIUS_EXTRA_LARGE);
}

void ConfigureRowAlignSelf(std::vector<std::shared_ptr<ArkUIRowNode>>& rows)
{
    rows[Indices::ZERO]->SetAlignSelf(ArkUI_ItemAlignment::ARKUI_ITEM_ALIGNMENT_STRETCH);
    rows[Indices::ONE]->SetAlignSelf(ArkUI_ItemAlignment::ARKUI_ITEM_ALIGNMENT_CENTER);
    rows[Indices::ZERO]->SetFlexShrink(Percentages::FLEX_SHRINK_SMALL);
}

std::shared_ptr<ArkUIFlexNode> CreateBorderAlignSelfSection()
{
    auto flex = std::make_shared<ArkUIFlexNode>();
    flex->SetId(Utils::GenerateId(IDs::ROW_PREFIX, Indices::ZERO).c_str());
    flex->SetBorderWidthPercent(Percentages::BORDER_THIN,
                                Percentages::BORDER_THIN, Percentages::BORDER_THIN, Percentages::BORDER_THIN);
    std::vector<std::shared_ptr<ArkUIRowNode>> rows(Counts::TEXT_NODES_EXTRA_LARGE);

    for (int i = 0; i < Counts::TEXT_NODES_LARGE; i++) {
        float width = Utils::CalculateIncrementalSize(Sizes::LARGE, i);
        float height = Utils::CalculateIncrementalSize(Sizes::LARGE, i);
        rows[i] = CreateBasicFlexRow(i, width, height);
        flex->AddChild(rows[i]);
    }

    ConfigureRowRadius(rows);
    ConfigureRowAlignSelf(rows);

    return flex;
}

std::shared_ptr<ArkUIFlexNode> CreateFlexGrowSection()
{
    auto flex = std::make_shared<ArkUIFlexNode>();
    flex->SetBorderWidthPercent(Percentages::BORDER_THIN);
    std::vector<std::shared_ptr<ArkUIRowNode>> rowGrow(Counts::TEXT_NODES_SMALL);
    for (int i = 0; i < Counts::TEXT_NODES_SMALL; i++) {
        rowGrow[i] = std::make_shared<ArkUIRowNode>();
        rowGrow[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        rowGrow[i]->SetHeight(Sizes::EXTRA_LARGE);
        rowGrow[i]->setJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
        flex->AddChild(rowGrow[i]);
    }

    // 设置Flex增长
    rowGrow[Indices::ZERO]->SetFlexGrow(Flex::GROW_FACTOR_HIGH);
    rowGrow[Indices::ONE]->SetFlexGrow(Flex::GROW_FACTOR_LOW);

    auto textGrow0 = std::make_shared<ArkUITextNode>();
    textGrow0->SetTextContent(Texts::CONTENT_FLEX_GROW_2);
    rowGrow[Indices::ZERO]->AddChild(textGrow0);

    auto textGrow1 = std::make_shared<ArkUITextNode>();
    textGrow1->SetTextContent(Texts::CONTENT_FLEX_GROW_1);
    rowGrow[Indices::ONE]->AddChild(textGrow1);

    flex->SetBackgroundColor(Colors::RED);
    return flex;
}

std::shared_ptr<ArkUIFlexNode> CreateFlexBasisSection()
{
    auto flex = std::make_shared<ArkUIFlexNode>();

    auto text0 = std::make_shared<ArkUITextNode>();
    text0->SetTextContent(Texts::CONTENT_FLEX_BASIS_100);
    text0->SetBackgroundColor(Colors::BEIGE);
    text0->SetTextAlignment(ArkUI_TextAlignment::ARKUI_TEXT_ALIGNMENT_CENTER);
    text0->SetHeight(Sizes::EXTRA_LARGE);
    text0->SetFlexBasis(Flex::BASIS_FIXED);
    flex->AddChild(text0);

    auto text1 = std::make_shared<ArkUITextNode>();
    text1->SetTextContent(Texts::CONTENT_FLEX_BASIS_AUTO);
    text1->SetHeight(Sizes::EXTRA_LARGE);
    text1->SetPercentWidth(Percentages::SIXTY_PERCENT);
    text1->SetBackgroundColor(Colors::TAN);
    text1->SetTextAlignment(ArkUI_TextAlignment::ARKUI_TEXT_ALIGNMENT_CENTER);
    flex->AddChild(text1);

    return flex;
}

std::shared_ptr<ArkUIFlexNode> CreateDisplayPrioritySection()
{
    auto flex = std::make_shared<ArkUIFlexNode>();
    std::vector<std::shared_ptr<ArkUIRowNode>> priorityRows(Counts::TEXT_NODES_SMALL);

    for (int i = 0; i < Counts::TEXT_NODES_SMALL; i++) {
        priorityRows[i] = std::make_shared<ArkUIRowNode>();
        priorityRows[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        priorityRows[i]->SetHeight(Sizes::EXTRA_LARGE);
        priorityRows[i]->setJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);

        auto priorityText = std::make_shared<ArkUITextNode>();
        int priority = (i == 0) ? DisplayPriority::HIGH : DisplayPriority::LOW;
        priorityText->SetTextContent(Utils::GenerateText("priority", priority));
        priorityRows[i]->AddChild(priorityText);

        priorityRows[i]->SetDisplayPriority(priority);
        flex->AddChild(priorityRows[i]);
    }

    return flex;
}

std::shared_ptr<ArkUIBaseNode> CreateFlexExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();

    // 第一部分：边框和自对齐
    column->AddChild(CreateFlexTitle(Texts::TITLE_BORDER_ALIGNSELF));
    column->AddChild(CreateBorderAlignSelfSection());

    // 第二部分：Flex增长因子
    column->AddChild(CreateFlexTitle(Texts::TITLE_FLEX_GROW));
    column->AddChild(CreateFlexGrowSection());

    // 第三部分：Flex基础尺寸
    column->AddChild(CreateFlexTitle(Texts::TITLE_FLEX_BASIS));
    column->AddChild(CreateFlexBasisSection());

    // 第四部分：显示优先级
    column->AddChild(CreateFlexTitle(Texts::TITLE_DISPLAY_PRIORITY));
    column->AddChild(CreateDisplayPrioritySection());

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_FLEXEXAMPLE_REFACTORED_H