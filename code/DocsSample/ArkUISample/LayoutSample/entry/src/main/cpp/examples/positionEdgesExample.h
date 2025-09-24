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

#ifndef CAPI_0922_POSITIONEDGESEXAMPLE_REFACTORED_H
#define CAPI_0922_POSITIONEDGESEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include <string>
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIBaseNode> CreatePositionEdgesExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto positionEdgesTitle = std::make_shared<ArkUITextNode>();
    positionEdgesTitle->SetTextContent("position use edges");
    column->AddChild(positionEdgesTitle);

    // 创建行容器作为位置边缘的父组件
    auto positionEdgesRow = std::make_shared<ArkUIRowNode>();
    positionEdgesRow->SetPercentWidth(Percentages::NINETY_PERCENT);
    positionEdgesRow->SetHeight(Sizes::EXTRA_LARGE);
    positionEdgesRow->SetBorderWidth(Sizes::BORDER_WIDTH_THIN);
    positionEdgesRow->SetBorderStyle(ARKUI_BORDER_STYLE_DASHED);
    column->AddChild(positionEdgesRow);
    
    std::vector<std::string> contents = {"bottom:0, right:0", "top:0, left:0", "top:50, left:100", "bottom:0, left:30"};
    std::vector<std::shared_ptr<ArkUITextNode>> positionEdgesTexts(Counts::TEXT_NODES_LARGE);
    for (int i = 0; i < Counts::TEXT_NODES_LARGE; i++) {
        positionEdgesTexts[i] = std::make_shared<ArkUITextNode>();
        positionEdgesTexts[i]->SetTextAlign(ArkUI_TextAlignment::ARKUI_TEXT_ALIGNMENT_CENTER);
        positionEdgesTexts[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::ITEM_COLORS, i));
        positionEdgesTexts[i]->SetTextContent(contents[i]);
        positionEdgesTexts[i]->SetBorderWidth(Sizes::BORDER_WIDTH_THIN);
        positionEdgesRow->AddChild(positionEdgesTexts[i]);
    }

    // 设置各个文本节点的位置边缘
    positionEdgesTexts[Indices::ZERO]->SetPositionEdgesExample(-1, -1, 0, 0);  // 右下角
    positionEdgesTexts[Indices::ONE]->SetPositionEdgesExample(0, 0, -1, -1); // 左上角
    positionEdgesTexts[Indices::TWO]->SetPositionEdgesExample(Sizes::MEDIUM, Sizes::EXTRA_LARGE, -1, -1);
    auto value =
        positionEdgesTexts[Indices::THREE]->SetPositionEdgesExample(-1, Sizes::SMALL, 0, -1); // 距离底部0，左侧30

    // 创建显示位置边缘配置信息的文本节点
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent(value);
    column->AddChild(text);

    return column;
}

} // namespace NativeModule

#endif // CAPI_0922_POSITIONEDGESEXAMPLE_REFACTORED_H
