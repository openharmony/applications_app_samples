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

#ifndef CAPI0805_2_RELATIVELAYOUTCHAINEXAMPLE_REFACTORED_H
#define CAPI0805_2_RELATIVELAYOUTCHAINEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

std::vector<std::shared_ptr<ArkUIRowNode>> CreateRowNodes()
{
    std::vector<std::shared_ptr<ArkUIRowNode>> rows(Sizes::ROW_COUNT);
    
    for (int i = 0; i < Sizes::ROW_COUNT; i++) {
        rows[i] = std::make_shared<ArkUIRowNode>();
        rows[i]->SetWidth(Sizes::LARGE);
        rows[i]->SetHeight(Sizes::LARGE);
        rows[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::STANDARD_COLORS, i));
        
        std::string id = Utils::GenerateId(IDs::ROW_PREFIX, i + 1);
        rows[i]->SetId(id.c_str());
        
        auto text = std::make_shared<ArkUITextNode>();
        text->SetTextContent(id);
        rows[i]->AddChild(text);
        rows[i]->setJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
    }
    
    return rows;
}

void SetupTopRowChain(std::vector<std::shared_ptr<ArkUIRowNode>>& rows,
                      std::shared_ptr<ArkUIRelativeContainerNode> container)
{
    // 设置第0个Row节点的对齐规则和链模式
    auto alignRules0 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules0, "__container__",
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules0, rows[Indices::ONE]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules0, "__container__",
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::ZERO]->SetAlignRules(alignRules0);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules0);
    rows[Indices::ZERO]->SetChainMode(ArkUI_Axis::ARKUI_AXIS_HORIZONTAL,
                                      ArkUI_RelativeLayoutChainStyle::ARKUI_RELATIVE_LAYOUT_CHAIN_STYLE_SPREAD);

    // 设置第1个Row节点的对齐规则
    auto alignRules1 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules1, rows[Indices::ZERO]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules1, rows[Indices::TWO]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules1, rows[Indices::ZERO]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::ONE]->SetAlignRules(alignRules1);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules1);

    // 设置第2个Row节点的对齐规则
    auto alignRules2 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules2, rows[Indices::ONE]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules2, container->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules2, rows[Indices::ZERO]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::TWO]->SetAlignRules(alignRules2);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules2);
}

void SetupMiddleRowChain(std::vector<std::shared_ptr<ArkUIRowNode>>& rows,
                         std::shared_ptr<ArkUIRelativeContainerNode> container)
{
    // 设置第3个Row节点的对齐规则和链模式
    auto alignRules3 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules3, container->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules3, rows[Indices::FOUR]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetCenterVertical(alignRules3, container->GetId(),
                                                   ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_CENTER);
    rows[Indices::THREE]->SetAlignRules(alignRules3);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules3);
    rows[Indices::THREE]->SetChainMode(ArkUI_Axis::ARKUI_AXIS_HORIZONTAL,
                                       ArkUI_RelativeLayoutChainStyle::ARKUI_RELATIVE_LAYOUT_CHAIN_STYLE_SPREAD_INSIDE);

    // 设置第4个Row节点的对齐规则
    auto alignRules4 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules4, rows[Indices::THREE]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules4, rows[Indices::FIVE]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules4, rows[Indices::THREE]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::FOUR]->SetAlignRules(alignRules4);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules4);

    // 设置第5个Row节点的对齐规则
    auto alignRules5 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules5, rows[Indices::FOUR]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules5, container->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules5, rows[Indices::THREE]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::FIVE]->SetAlignRules(alignRules5);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules5);
}

void SetupBottomRowChain(std::vector<std::shared_ptr<ArkUIRowNode>>& rows,
                         std::shared_ptr<ArkUIRelativeContainerNode> container)
{
    // 设置第6个Row节点的对齐规则和链模式
    auto alignRules6 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules6, "__container__",
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules6, rows[Indices::SEVEN]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetBottom(alignRules6, "__container__",
                                           ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_BOTTOM);
    rows[Indices::SIX]->SetAlignRules(alignRules6);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules6);
    rows[Indices::SIX]->SetChainMode(ArkUI_Axis::ARKUI_AXIS_HORIZONTAL,
                                     ArkUI_RelativeLayoutChainStyle::ARKUI_RELATIVE_LAYOUT_CHAIN_STYLE_PACKED);

    // 设置第7个Row节点的对齐规则
    auto alignRules7 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules7, rows[Indices::SIX]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules7, rows[Indices::EIGHT]->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules7, rows[Indices::SIX]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::SEVEN]->SetAlignRules(alignRules7);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules7);

    // 设置第8个Row节点的对齐规则
    auto alignRules8 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules8, rows[Indices::SEVEN]->GetId(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignRules8, container->GetId(),
                                        ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules8, rows[Indices::SIX]->GetId(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    rows[Indices::EIGHT]->SetAlignRules(alignRules8);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules8);
}

void ConfigureContainer(std::shared_ptr<ArkUIRelativeContainerNode> container)
{
    container->SetWidth(Sizes::GIANT);
    container->SetHeight(Sizes::GIANT);
    container->SetMargin(0, 0, 0, Sizes::MEDIUM);
    container->SetBorderWidth(Sizes::BORDER_WIDTH);
    container->SetBorderColor(Colors::BLUE);
    container->SetBorderStyle(ARKUI_BORDER_STYLE_SOLID, ARKUI_BORDER_STYLE_DASHED,
                              ARKUI_BORDER_STYLE_DOTTED, ARKUI_BORDER_STYLE_SOLID);
}

std::shared_ptr<ArkUIBaseNode> RelativeLayoutChainExample()
{
    // 创建容器
    auto relativeContainer = std::make_shared<ArkUIRelativeContainerNode>();
    relativeContainer->SetId("__container__");
    
    // 创建行节点
    auto rows = CreateRowNodes();
    
    // 将行节点添加到容器
    for (auto& row : rows) {
        relativeContainer->AddChild(row);
    }
    
    // 设置各行链的对齐规则
    SetupTopRowChain(rows, relativeContainer);
    SetupMiddleRowChain(rows, relativeContainer);
    SetupBottomRowChain(rows, relativeContainer);
    
    // 配置容器属性
    ConfigureContainer(relativeContainer);
    
    return relativeContainer;
}

} // namespace NativeModule

#endif // CAPI0805_2_RELATIVELAYOUTCHAINEXAMPLE_REFACTORED_H