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

#ifndef CAPI0805_2_COLUMNEXAMPLE_REFACTORED_H
#define CAPI0805_2_COLUMNEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRowNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIStackNode.h"
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUITextNode> CreateTitleText(const std::string& titleText)
{
    auto title = std::make_shared<ArkUITextNode>();
    title->SetTextContent(titleText);
    return title;
}

std::shared_ptr<ArkUIColumnNode> CreateBaseContainer()
{
    auto container = std::make_shared<ArkUIColumnNode>();
    container->SetPercentWidth(Percentages::NINETY_PERCENT);
    container->SetBorderWidth(Sizes::BORDER_WIDTH);
    container->SetMargin(Sizes::MARGIN_MEDIUM);
    return container;
}

std::shared_ptr<ArkUIColumnNode> CreatePositionSection()
{
    auto positionColumn = CreateBaseContainer();

    auto positionText = std::make_shared<ArkUITextNode>();
    positionText->SetBackgroundColor(Colors::YELLOW);
    positionText->SetTextContent(Texts::CONTENT_POSITION);
    positionText->SetPosition(Sizes::SMALL, Sizes::SMALL);

    positionColumn->AddChild(positionText);
    positionColumn->SetHeight(Sizes::EXTRA_LARGE);

    return positionColumn;
}

std::shared_ptr<ArkUIColumnNode> CreateOffsetSection()
{
    auto offsetColumn = CreateBaseContainer();

    auto offsetText = std::make_shared<ArkUITextNode>();
    offsetText->SetTextContent(Texts::CONTENT_OFFSET);
    offsetText->SetOffset(Sizes::OFFSET_MEDIUM, Sizes::OFFSET_MEDIUM); // 特定偏移值
    offsetText->SetBackgroundColor(Colors::GREEN);

    offsetColumn->AddChild(offsetText);
    offsetColumn->SetHeight(Sizes::EXTRA_LARGE);

    return offsetColumn;
}

std::shared_ptr<ArkUIColumnNode> CreateSizeSection()
{
    auto sizeColumn = CreateBaseContainer();

    auto sizeText = std::make_shared<ArkUITextNode>();
    sizeText->SetTextContent(Texts::CONTENT_SIZE);
    sizeText->SetBackgroundColor(Colors::YELLOW);
    sizeText->SetSize(Sizes::EXTRA_LARGE, Sizes::EXTRA_LARGE);

    sizeColumn->AddChild(sizeText);

    return sizeColumn;
}

std::shared_ptr<ArkUIColumnNode> CreateJustifyContentSection()
{
    auto justifyColumn = CreateBaseContainer();
    std::vector<std::shared_ptr<ArkUITextNode>> justifyText(Counts::TEXT_NODES_MEDIUM);

    for (int i = 0; i < Counts::TEXT_NODES_MEDIUM; i++) {
        justifyText[i] = std::make_shared<ArkUITextNode>();
        std::string id = Utils::GenerateId(IDs::TEXT_PREFIX, i);
        justifyText[i]->SetTextContent(id);
        justifyText[i]->SetWidth(Utils::CalculateIncrementalSize(Sizes::MEDIUM, i, Sizes::MEDIUM));
        justifyText[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        justifyColumn->AddChild(justifyText[i]);
    }

    justifyColumn->SetColumnJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    justifyColumn->SetColumnAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_END);
    justifyColumn->SetHeight(Sizes::EXTRA_LARGE);

    return justifyColumn;
}

std::shared_ptr<ArkUIBaseNode> CreateColumnExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();

    // 第一部分：位置设置
    column->AddChild(CreateTitleText(Texts::TITLE_SET_POSITION));
    column->AddChild(CreatePositionSection());

    // 第二部分：偏移量设置
    column->AddChild(CreateTitleText(Texts::TITLE_SET_OFFSET));
    column->AddChild(CreateOffsetSection());

    // 第三部分：尺寸调整
    column->AddChild(CreateTitleText(Texts::TITLE_SET_SIZE));
    column->AddChild(CreateSizeSection());

    // 第四部分：内容对齐
    column->AddChild(CreateTitleText(Texts::TITLE_JUSTIFY_CONTENT));
    column->AddChild(CreateJustifyContentSection());

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_COLUMNEXAMPLE_REFACTORED_H