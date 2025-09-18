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

#ifndef CAPI0805_2_ROWEXAMPLE_REFACTORED_H
#define CAPI0805_2_ROWEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRowNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIStackNode.h"
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIColumnNode> CreateMainColumn() { return std::make_shared<ArkUIColumnNode>(); }

void CreateBottomAlignExample(std::shared_ptr<ArkUIColumnNode> column)
{
    auto bottomAlign = std::make_shared<ArkUITextNode>();
    bottomAlign->SetTextContent(Texts::TITLE_BOTTOM_ALIGNMENT);
    column->AddChild(bottomAlign);
    
    auto row = std::make_shared<ArkUIRowNode>();
    std::vector<std::shared_ptr<ArkUITextNode>> text(Counts::TEXT_NODES_MEDIUM);

    // 创建文本节点
    for (int i = 0; i < Counts::TEXT_NODES_MEDIUM; i++) {
        text[i] = std::make_shared<ArkUITextNode>();
        text[i]->SetWidth(Sizes::MEDIUM);
        text[i]->SetHeight(Utils::CalculateIncrementalSize(Sizes::MEDIUM, i, Sizes::MEDIUM));
        text[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        row->AddChild(text[i]);
    }

    // 设置行属性
    row->SetRowAlignItems(ARKUI_VERTICAL_ALIGNMENT_BOTTOM);
    row->SetMargin(Sizes::MARGIN_MEDIUM);
    column->AddChild(row);
}

void CreateDirectionExample(std::shared_ptr<ArkUIColumnNode> column)
{
    auto directionText = std::make_shared<ArkUITextNode>();
    directionText->SetTextContent(Texts::TITLE_DIRECTION);
    column->AddChild(directionText);

    auto directionRow = std::make_shared<ArkUIRowNode>();
    directionRow->SetDirection(ARKUI_DIRECTION_RTL);

    // 创建方向文本节点
    std::vector<std::shared_ptr<ArkUITextNode>> directText(Counts::TEXT_NODES_MEDIUM);
    for (int i = 0; i < Counts::TEXT_NODES_MEDIUM; i++) {
        directText[i] = std::make_shared<ArkUITextNode>();
        std::string id = Utils::GenerateId(IDs::DIRECTION_PREFIX, i);
        directText[i]->SetTextContent(id.c_str());
        directText[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        directText[i]->SetMargin(Sizes::MARGIN_MEDIUM);
        directionRow->AddChild(directText[i]);
    }

    // 设置方向行属性
    directionRow->SetPercentWidth(Percentages::NINETY_PERCENT);
    directionRow->SetHeight(Sizes::EXTRA_LARGE);
    directionRow->SetBorderWidth(Sizes::BORDER_WIDTH);
    directionRow->SetMargin(Sizes::MARGIN_MEDIUM);
    column->AddChild(directionRow);
}

void CreateAlignmentExample(std::shared_ptr<ArkUIColumnNode> column)
{
    auto alignTitle = std::make_shared<ArkUITextNode>();
    alignTitle->SetTextContent(Texts::TITLE_ALIGNMENT);
    column->AddChild(alignTitle);

    auto alignRow = std::make_shared<ArkUIRowNode>();
    std::vector<std::shared_ptr<ArkUITextNode>> alignText(Counts::TEXT_NODES_MEDIUM);
    alignRow->SetAlignment(ARKUI_ALIGNMENT_TOP_START);

    // 创建对齐文本节点
    for (int i = 0; i < Counts::TEXT_NODES_MEDIUM; i++) {
        alignText[i] = std::make_shared<ArkUITextNode>();
        alignText[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        std::string id = Utils::GenerateId(IDs::ALIGNMENT_PREFIX, i);
        alignText[i]->SetTextContent(id.c_str());
        alignText[i]->SetHeight(Utils::CalculateIncrementalSize(Sizes::HEIGHT_SMALL, i, Sizes::HEIGHT_SMALL));
        alignText[i]->SetAlignment(ARKUI_ALIGNMENT_TOP_START);
        alignRow->AddChild(alignText[i]);
    }

    // 设置对齐行属性
    alignRow->SetPercentWidth(Percentages::NINETY_PERCENT);
    alignRow->SetHeight(Sizes::EXTRA_LARGE);
    alignRow->SetBorderWidth(Sizes::BORDER_WIDTH);
    alignRow->SetMargin(Sizes::MARGIN_MEDIUM);
    column->AddChild(alignRow);
}

void CreateAspectRatioExample(std::shared_ptr<ArkUIColumnNode> column)
{
    // 添加标题
    auto aspectRatioTitle = std::make_shared<ArkUITextNode>();
    aspectRatioTitle->SetTextContent(Texts::TITLE_ASPECT_RATIO);
    column->AddChild(aspectRatioTitle);

    // 创建宽高比行容器
    auto aspRatioRow = std::make_shared<ArkUIRowNode>();
    auto aspRatioText = std::make_shared<ArkUITextNode>();
    aspRatioText->SetTextContent(Texts::CONTENT_RATIO);
    aspRatioText->SetAspectRatio(Flex::ASPECT_RATIO_WIDE);
    aspRatioText->SetWidth(Sizes::EXTRA_LARGE);
    aspRatioText->SetBackgroundColor(Colors::YELLOW);
    aspRatioRow->AddChild(aspRatioText);

    // 设置宽高比行属性
    aspRatioRow->SetPercentWidth(Percentages::NINETY_PERCENT);
    aspRatioRow->SetHeight(Sizes::EXTRA_LARGE);
    aspRatioRow->SetBorderWidth(Sizes::BORDER_WIDTH);
    aspRatioRow->SetMargin(Sizes::MARGIN_MEDIUM);
    column->AddChild(aspRatioRow);
}

std::shared_ptr<ArkUIBaseNode> CreateRowExample()
{
    auto column = CreateMainColumn();

    // 创建各种示例
    CreateBottomAlignExample(column);
    CreateDirectionExample(column);
    CreateAlignmentExample(column);
    CreateAspectRatioExample(column);

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_ROWEXAMPLE_REFACTORED_H