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

#ifndef CAPI0805_2_LAYOUTPOSITIONEXAMPLE_REFACTORED_H
#define CAPI0805_2_LAYOUTPOSITIONEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIButtonNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUICustomColumnNode.h"
#include "nodes/ArkUIRowNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIStackNode.h"
#include <vector>
#include <functional>

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIButtonNode> CreateStyledButton(const std::string& text, std::function<void()> onClickCallback)
{
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetTextContent(text);
    button->SetBackgroundColor(Colors::BUTTON_BACKGROUND_COLOR);
    button->SetWidth(Sizes::BUTTON_WIDTH); // 特定按钮宽度
    button->SetHeight(Sizes::BUTTON_HEIGHT);
    button->SetMargin(Sizes::MARGIN_SMALL);
    button->SetOnClick(onClickCallback);
    return button;
}

std::shared_ptr<ArkUITextNode> CreateStyledTextNode(const std::string& text, uint32_t color)
{
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent(text);
    textNode->SetBackgroundColor(color);
    textNode->SetWidth(Sizes::EXTRA_LARGE);
    textNode->SetHeight(Sizes::MEDIUM);
    textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    return textNode;
}

std::shared_ptr<ArkUITextNode> CreateIdTextNode(const std::string& id, uint32_t color)
{
    auto textNode = CreateStyledTextNode(id, color);
    textNode->SetId(id.c_str());
    return textNode;
}

std::shared_ptr<ArkUITextNode> CreateTitleNode(const std::string& title)
{
    auto titleNode = std::make_shared<ArkUITextNode>();
    titleNode->SetTextContent(title);
    return titleNode;
}

std::pair<std::shared_ptr<ArkUICustomColumnNode>, std::vector<std::shared_ptr<ArkUITextNode>>>CreateCustomColumn()
{
    auto layoutPosColumn = std::make_shared<ArkUICustomColumnNode>();
    std::vector<std::shared_ptr<ArkUITextNode>> layPosText;

    // 创建带颜色的文本节点
    for (size_t i = 0; i < Colors::STANDARD_COLORS.size(); i++) {
        std::string id = Utils::GenerateId(IDs::TEXT_PREFIX, i);
        auto textNode = CreateIdTextNode(id, Colors::STANDARD_COLORS[i]);
        layPosText.push_back(textNode);
        layoutPosColumn->AddChild(textNode);
    }

    // 设置布局列属性
    layoutPosColumn->SetMargin(Sizes::MARGIN_MEDIUM);
    layoutPosColumn->SetBorderWidth(Sizes::BORDER_WIDTH);
    layoutPosColumn->SetLayoutWeight(1);
    layoutPosColumn->SetHeight(Sizes::EXTRA_LARGE);

    return std::make_pair(layoutPosColumn, layPosText);
}

void AddLayoutControlButtons(std::shared_ptr<ArkUIColumnNode> column,
                             std::shared_ptr<ArkUICustomColumnNode> layoutPosColumn,
                             const std::vector<std::shared_ptr<ArkUITextNode>>& layPosText)
{
    // 布局按钮
    column->AddChild(CreateStyledButton(
        "layout", [layoutPosColumn]() { layoutPosColumn->SetOffsetCustom(Sizes::EXTRA_LARGE, Sizes::EXTRA_LARGE); }));

    // 获取布局大小按钮
    column->AddChild(CreateStyledButton("layoutSize", [layPosText]() {
        auto value = layPosText[Indices::TWO]->GetLayoutSize();
        OH_LOG_INFO(LOG_APP, "%{public}s", value.c_str());
    }));

    // 获取布局位置按钮
    column->AddChild(CreateStyledButton("GetLayoutPositionOH", [layPosText]() {
        auto value = layPosText[Indices::TWO]->GetLayoutPositionOH();
        OH_LOG_INFO(LOG_APP, "%{public}s", value.c_str());
    }));

    // 获取布局位置按钮
    column->AddChild(CreateStyledButton("GetLayoutPosition", [layPosText]() {
        auto value = layPosText[Indices::TWO]->GetLayoutPosition();
        OH_LOG_INFO(LOG_APP, "%{public}s", value.c_str());
    }));
}

void AddScreenPositionButtons(std::shared_ptr<ArkUIColumnNode> column,
                              const std::vector<std::shared_ptr<ArkUITextNode>>& layPosText)
{
    // 获取屏幕布局位置按钮
    column->AddChild(CreateStyledButton("GetLayPosInScr", [layPosText]() {
        auto value = layPosText[Indices::TWO]->GetLayoutPositionInScreen();
        OH_LOG_INFO(LOG_APP, "%{public}s", value.c_str());
    }));

    // GetPositionWithTranslateInScreen
    column->AddChild(CreateStyledButton("GetPosWthTrInScr", [layPosText]() {
        auto value = layPosText[Indices::TWO]->GetPositionWithTranslateInScreen();
        OH_LOG_INFO(LOG_APP, "%{public}s", value.c_str());
    }));

    // GetPosToParent
    column->AddChild(
        CreateStyledButton("GetPosToParent", [layPosText]() { layPosText[Indices::TWO]->GetPositionToParent(); }));
}

void AddCallbackButtons(std::shared_ptr<ArkUIColumnNode> column,
                        std::shared_ptr<ArkUICustomColumnNode> layoutPosColumn)
{
    // OH_ArkUI_RegisterLayoutCallbackOnNodeHandle()
    column->AddChild(
        CreateStyledButton("registerCallback", [layoutPosColumn]() { layoutPosColumn->SetRegisterLayoutCallback(); }));

    column->AddChild(CreateStyledButton("UnregisterCallback",
                                        [layoutPosColumn]() { layoutPosColumn->SetUnregisterLayoutCallback(); }));
}

std::shared_ptr<ArkUIColumnNode> CreateLayoutRectSection()
{
    auto layRectColumn = std::make_shared<ArkUIColumnNode>();
    auto layRectText = std::make_shared<ArkUITextNode>();

    layRectText->SetTextContent("position(30, 30) rect(900, 200) px");
    layRectText->SetBackgroundColor(Colors::YELLOW);
    layRectText->SetLayoutRect(Sizes::POSITION_X, Sizes::POSITION_Y,
                               Sizes::LAYOUT_RECT_WIDTH, Sizes::LAYOUT_RECT_HEIGHT);
    layRectColumn->AddChild(layRectText);

    // 设置布局矩形列属性
    layRectColumn->SetPercentWidth(Percentages::NINETY_PERCENT);
    layRectColumn->SetHeight(Sizes::EXTRA_LARGE);
    layRectColumn->SetBorderWidth(Sizes::BORDER_WIDTH);
    layRectColumn->SetMargin(Sizes::MARGIN_MEDIUM);

    return layRectColumn;
}

std::shared_ptr<ArkUIBaseNode> CreateLayoutPositionExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();

    // 添加标题
    auto layPosTitle = CreateTitleNode(Texts::TITLE_LAYOUT_POSITION);
    column->AddChild(layPosTitle);

    // 创建布局位置列和文本节点
    auto [layoutPosColumn, layPosText] = CreateCustomColumn();
    column->AddChild(layoutPosColumn);

    // 添加各种按钮
    AddLayoutControlButtons(column, layoutPosColumn, layPosText);
    AddScreenPositionButtons(column, layPosText);
    AddCallbackButtons(column, layoutPosColumn);

    // 添加布局矩形区域
    auto layRectTitle = CreateTitleNode("layout rect");
    column->AddChild(layRectTitle);

    auto layRectColumn = CreateLayoutRectSection();
    column->AddChild(layRectColumn);

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_LAYOUTPOSITIONEXAMPLE_REFACTORED_H