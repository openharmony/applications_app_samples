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

#ifndef CAPI0805_2_BARRIEROPTIONEXAMPLE_H
#define CAPI0805_2_BARRIEROPTIONEXAMPLE_H

#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIRowNode.h"
#include "LayoutConstants.h"

namespace NativeModule {

std::shared_ptr<ArkUIRowNode> CreateBasicRowNode(int rowIndex, uint32_t backgroundColor)
{
    auto row = std::make_shared<ArkUIRowNode>();
    auto text = std::make_shared<ArkUITextNode>();

    text->SetTextContent(LayoutConstants::Utils::GenerateText(LayoutConstants::IDs::ROW_PREFIX, rowIndex));
    row->AddChild(text);
    row->SetWidth(LayoutConstants::Sizes::EXTRA_LARGE);
    row->SetHeight(LayoutConstants::Sizes::EXTRA_LARGE);
    row->SetBackgroundColor(backgroundColor);
    row->setJustifyContent(ArkUI_FlexAlignment::ARKUI_FLEX_ALIGNMENT_CENTER);
    row->SetId(LayoutConstants::Utils::GenerateId(LayoutConstants::IDs::ROW_PREFIX, rowIndex).c_str());

    return row;
}

std::shared_ptr<ArkUIRowNode> CreateRowWithAlignment(int rowIndex, uint32_t backgroundColor, const char *anchorId)
{
    auto row = CreateBasicRowNode(rowIndex, backgroundColor);

    // 设置对齐规则
    auto alignRules = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetCenterHorizontal(alignRules, anchorId,
                                                     ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules, anchorId, ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_BOTTOM);
    row->SetAlignRules(alignRules);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules);

    return row;
}

// 在 CreateAndConfigureBarrier 函数中
std::string CreateAndConfigureBarrier(std::shared_ptr<ArkUIRelativeContainerNode> container,
                                      std::shared_ptr<ArkUIRowNode> row1, std::shared_ptr<ArkUIRowNode> row2)
{
    // 设置屏障
    auto barrier = OH_ArkUI_BarrierOption_Create(LayoutConstants::Counts::TEXT_NODES_SMALL);
    std::string barrierId =
        LayoutConstants::Utils::GenerateId(LayoutConstants::IDs::BARRIER_PREFIX, LayoutConstants::Indices::ONE);
    OH_ArkUI_BarrierOption_SetId(barrier, barrierId.c_str(), LayoutConstants::Indices::ZERO);
    barrierId =
        LayoutConstants::Utils::GenerateId(LayoutConstants::IDs::BARRIER_PREFIX, LayoutConstants::Indices::TWO);
    OH_ArkUI_BarrierOption_SetId(barrier,
                                 barrierId.c_str(),
                                 LayoutConstants::Indices::ONE);
    OH_ArkUI_BarrierOption_SetReferencedId(barrier, row1->GetId(), LayoutConstants::Indices::ZERO);
    OH_ArkUI_BarrierOption_SetReferencedId(barrier, row2->GetId(), LayoutConstants::Indices::ZERO);
    OH_ArkUI_BarrierOption_SetReferencedId(barrier, row1->GetId(), LayoutConstants::Indices::ONE);
    OH_ArkUI_BarrierOption_SetReferencedId(barrier, row2->GetId(), LayoutConstants::Indices::ONE);
    OH_ArkUI_BarrierOption_SetDirection(barrier, ArkUI_BarrierDirection::ARKUI_BARRIER_DIRECTION_END,
                                        LayoutConstants::Indices::ZERO);
    OH_ArkUI_BarrierOption_SetDirection(barrier, ArkUI_BarrierDirection::ARKUI_BARRIER_DIRECTION_BOTTOM,
                                        LayoutConstants::Indices::ONE);

    // 获取障碍物配置信息用于显示
    int barrierIndexTest = LayoutConstants::Indices::BARRIER_TEST_INDEX;
    int refIdTest = LayoutConstants::Indices::REFERENCE_TEST_INDEX;
    std::string barrierStyle = "Id: " + std::string(OH_ArkUI_BarrierOption_GetId(barrier, barrierIndexTest));
    barrierStyle += "\n";
    barrierStyle += "Direction: " + std::to_string(OH_ArkUI_BarrierOption_GetDirection(barrier, barrierIndexTest));
    barrierStyle += "\n";
    barrierStyle +=
        "ReferencedId: " + std::string(OH_ArkUI_BarrierOption_GetReferencedId(barrier, barrierIndexTest, refIdTest));
    barrierStyle += "\n";
    barrierStyle +=
        "ReferencedIdSize: " + std::to_string(OH_ArkUI_BarrierOption_GetReferencedIdSize(barrier, barrierIndexTest));

    container->SetBarrier(barrier);
    OH_ArkUI_BarrierOption_Dispose(barrier);

    return barrierStyle;
}

std::shared_ptr<ArkUIRowNode> CreateRow3WithBarrierAlignment(const char *anchorRowId)
{
    auto row3 = std::make_shared<ArkUIRowNode>();
    auto text3 = std::make_shared<ArkUITextNode>();
    std::string content =
        LayoutConstants::Utils::GenerateText(LayoutConstants::IDs::ROW_PREFIX, LayoutConstants::Indices::THREE);
    text3->SetTextContent(content);
    row3->AddChild(text3);
    row3->setJustifyContent(ArkUI_FlexAlignment::ARKUI_FLEX_ALIGNMENT_CENTER);
    row3->SetWidth(LayoutConstants::Sizes::EXTRA_LARGE);
    row3->SetHeight(LayoutConstants::Sizes::EXTRA_LARGE);
    row3->SetBackgroundColor(LayoutConstants::Colors::TAN);

    // 设置row3的对齐规则
    auto alignRules3 = OH_ArkUI_AlignmentRuleOption_Create();
    std::string barrierId =
        LayoutConstants::Utils::GenerateId(LayoutConstants::IDs::BARRIER_PREFIX, LayoutConstants::Indices::ONE);
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules3, barrierId.c_str(),
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules3, anchorRowId,
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_TOP);
    row3->SetAlignRules(alignRules3);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules3);

    return row3;
}

std::shared_ptr<ArkUIRowNode> CreateRow4WithBarrierAlignment(const char *anchorRowId)
{
    auto row4 = std::make_shared<ArkUIRowNode>();
    auto text4 = std::make_shared<ArkUITextNode>();
    std::string content =
        LayoutConstants::Utils::GenerateText(LayoutConstants::IDs::ROW_PREFIX, LayoutConstants::Indices::FOUR);
    text4->SetTextContent(content);
    row4->AddChild(text4);
    row4->SetWidth(LayoutConstants::Sizes::MEDIUM);
    row4->SetHeight(LayoutConstants::Sizes::MEDIUM);
    row4->SetBackgroundColor(LayoutConstants::Colors::BLUE);

    // 设置row4的对齐规则
    auto alignRules4 = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetStart(alignRules4, anchorRowId,
                                          ArkUI_HorizontalAlignment::ARKUI_HORIZONTAL_ALIGNMENT_START);
    std::string barrierId =
        LayoutConstants::Utils::GenerateId(LayoutConstants::IDs::BARRIER_PREFIX, LayoutConstants::Indices::TWO);
    OH_ArkUI_AlignmentRuleOption_SetTop(alignRules4,
                                        barrierId.c_str(),
                                        ArkUI_VerticalAlignment::ARKUI_VERTICAL_ALIGNMENT_BOTTOM);
    row4->SetAlignRules(alignRules4);
    OH_ArkUI_AlignmentRuleOption_Dispose(alignRules4);

    return row4;
}

void ConfigureRelativeContainerStyle(std::shared_ptr<ArkUIRelativeContainerNode> container)
{
    container->SetWidth(LayoutConstants::Sizes::GIANT);
    container->SetHeight(LayoutConstants::Sizes::GIANT);
    container->SetMargin(LayoutConstants::Sizes::ZERO, LayoutConstants::Sizes::ZERO,
                        LayoutConstants::Sizes::ZERO, LayoutConstants::Sizes::MEDIUM);
    container->SetBorderColor(LayoutConstants::Colors::BLUE); // 这个颜色在LayoutConstants中没有定义，保持原样
    container->SetBorderWidth(LayoutConstants::Sizes::BORDER_WIDTH);
}

std::shared_ptr<ArkUIBaseNode> CreateBarrierOptionExample()
{
    // 创建主列容器
    auto column = std::make_shared<ArkUIColumnNode>();

    // 创建相对布局容器并设置ID
    auto relativeContainer = std::make_shared<ArkUIRelativeContainerNode>();
    relativeContainer->SetId(LayoutConstants::IDs::FATHER.c_str());

    // 创建row1和row2
    auto row1 = CreateBasicRowNode(LayoutConstants::Indices::ONE, LayoutConstants::Colors::GREEN);
    auto row2 = CreateRowWithAlignment(LayoutConstants::Indices::TWO, LayoutConstants::Colors::TEAL, row1->GetId());

    relativeContainer->AddChild(row1);
    relativeContainer->AddChild(row2);

    // 创建并配置障碍物
    std::string barrierStyle = CreateAndConfigureBarrier(relativeContainer, row1, row2);

    // 创建row3和row4
    auto row3 = CreateRow3WithBarrierAlignment(row1->GetId());
    auto row4 = CreateRow4WithBarrierAlignment(row1->GetId());

    // 创建显示障碍物配置信息的文本节点
    auto text5 = std::make_shared<ArkUITextNode>();
    text5->SetTextContent(barrierStyle);

    relativeContainer->AddChild(row3);
    relativeContainer->AddChild(row4);

    // 配置容器样式
    ConfigureRelativeContainerStyle(relativeContainer);

    column->AddChild(relativeContainer);
    column->AddChild(text5);

    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_BARRIEROPTIONEXAMPLE_H