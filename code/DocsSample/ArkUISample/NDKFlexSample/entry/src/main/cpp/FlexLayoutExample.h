/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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
// [Start flex_layout_example_full]
#ifndef NDKFLEXSAMPLE_FLEXLAYOUTEXAMPLE_H
#define NDKFLEXSAMPLE_FLEXLAYOUTEXAMPLE_H

#include <array>
#include <string>

#include "ArkUIBaseNode.h"
#include "ArkUIColumnNode.h"
#include "ArkUIFlexNode.h"
#include "ArkUIRowNode.h"
#include "ArkUITextNode.h"

namespace NativeModule {
constexpr float FULL_SIZE = 1.0F;
constexpr float TITLE_HEIGHT = 26.0F;
constexpr float ITEM_HEIGHT = 38.0F;
constexpr float PAGE_HEADER_HEIGHT = 32.0F;
constexpr float PAGE_HEADER_FONT_SIZE = 20.0F;
constexpr float SECTION_HEIGHT_SMALL = 60.0F;
constexpr float SECTION_HEIGHT_MEDIUM = 115.0F;
constexpr float SECTION_HEIGHT_LARGE = 120.0F;
constexpr float FIXED_ITEM_WIDTH = 84.0F;
constexpr float FLEX_BASIS = 52.0F;
constexpr float COLUMN_ITEM_WIDTH = 0.72F;
constexpr float ALIGN_SELF_ITEM_HEIGHT = 56.0F;
constexpr float DISPLAY_PRIORITY_ROW_WIDTH = 220.0F;
constexpr float DEFAULT_FLEX_GROW = 1.0F;
constexpr float EMPHASIZED_FLEX_GROW = 2.0F;
constexpr float EMPHASIZED_FLEX_SHRINK = 2.0F;
constexpr uint32_t PAGE_BACKGROUND_COLOR = 0xFFFFFFFF;
constexpr uint32_t SECTION_BACKGROUND_COLOR = 0xFFF4F7FB;
constexpr uint32_t HEADER_TEXT_COLOR = 0xFF0F1720;
constexpr uint32_t SECTION_TITLE_COLOR = 0xFF182431;
constexpr uint32_t ITEM_TEXT_COLOR = 0xFF10212B;
constexpr uint32_t ROW_ITEM_BLUE = 0xFFADD8E6;
constexpr uint32_t ROW_ITEM_GREEN = 0xFF90EE90;
constexpr uint32_t ROW_ITEM_ORANGE = 0xFFFFD6A5;
constexpr uint32_t COLUMN_ITEM_BLUE = 0xFFD6ECFF;
constexpr uint32_t COLUMN_ITEM_GREEN = 0xFFDDF5D4;
constexpr uint32_t COLUMN_ITEM_PINK = 0xFFFFE3EC;
constexpr uint32_t FLEX_ITEM_BLUE = 0xFFB8E1FF;
constexpr uint32_t FLEX_ITEM_GREEN = 0xFFC9F2D3;
constexpr uint32_t FLEX_ITEM_ORANGE = 0xFFFFDFB8;
constexpr uint32_t FLEX_ITEM_PINK = 0xFFFFC9D8;
constexpr uint32_t FLEX_ITEM_PURPLE = 0xFFE1D2FF;
constexpr uint32_t FLEX_ITEM_TEAL = 0xFFCFE8E8;
constexpr size_t FLEX_ITEM_COUNT = 6;
constexpr int32_t ALIGN_SELF_ITEM_INDEX = 2;
constexpr uint32_t DEFAULT_LAYOUT_WEIGHT = 1;
constexpr uint32_t EMPHASIZED_LAYOUT_WEIGHT = 2;
constexpr uint32_t LOW_DISPLAY_PRIORITY = 1;
constexpr uint32_t MEDIUM_DISPLAY_PRIORITY = 2;
constexpr uint32_t HIGH_DISPLAY_PRIORITY = 3;

// [Start flex_align_self_helper]
inline void SetAlignSelf(const std::shared_ptr<ArkUIBaseNode> &node, ArkUI_ItemAlignment align)
{
    ArkUI_NumberValue value[] = {{.i32 = align}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(node->GetHandle(), NODE_ALIGN_SELF, &item);
}
// [End flex_align_self_helper]

// [Start flex_grow_helper]
inline void SetFlexGrow(const std::shared_ptr<ArkUIBaseNode> &node, float grow)
{
    ArkUI_NumberValue value[] = {{.f32 = grow}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(node->GetHandle(), NODE_FLEX_GROW, &item);
}

inline void SetFlexShrink(const std::shared_ptr<ArkUIBaseNode> &node, float shrink)
{
    ArkUI_NumberValue value[] = {{.f32 = shrink}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(
        node->GetHandle(), NODE_FLEX_SHRINK, &item);
}

inline void SetFlexBasis(const std::shared_ptr<ArkUIBaseNode> &node, float basis)
{
    ArkUI_NumberValue value[] = {{.f32 = basis}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(node->GetHandle(), NODE_FLEX_BASIS, &item);
}
// [End flex_grow_helper]

// [Start flex_layout_weight_helper]
inline void SetLayoutWeight(const std::shared_ptr<ArkUIBaseNode> &node, uint32_t weight)
{
    ArkUI_NumberValue value[] = {{.u32 = weight}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(
        node->GetHandle(), NODE_LAYOUT_WEIGHT, &item);
}
// [End flex_layout_weight_helper]

// [Start flex_display_priority_helper]
inline void SetDisplayPriority(const std::shared_ptr<ArkUIBaseNode> &node, uint32_t priority)
{
    ArkUI_NumberValue value[] = {{.u32 = priority}};
    ArkUI_AttributeItem item = {value, 1};
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(
        node->GetHandle(), NODE_DISPLAY_PRIORITY, &item);
}
// [End flex_display_priority_helper]

inline std::shared_ptr<ArkUITextNode> CreateSectionTitle(const std::string &text)
{
    auto title = std::make_shared<ArkUITextNode>();
    title->SetPercentWidth(FULL_SIZE);
    title->SetHeight(TITLE_HEIGHT);
    title->SetTextContent(text);
    title->SetFontSize(16.0F);
    title->SetFontColor(SECTION_TITLE_COLOR);
    title->SetTextAlign(ARKUI_TEXT_ALIGNMENT_START);
    return title;
}

inline std::shared_ptr<ArkUITextNode> CreateFixedItem(const std::string &text, uint32_t bgColor)
{
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetWidth(FIXED_ITEM_WIDTH);
    textNode->SetHeight(ITEM_HEIGHT);
    textNode->SetBackgroundColor(bgColor);
    textNode->SetTextContent(text);
    textNode->SetFontSize(14.0F);
    textNode->SetFontColor(ITEM_TEXT_COLOR);
    textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    return textNode;
}

inline std::shared_ptr<ArkUITextNode> CreateFlexibleItem(const std::string &text, uint32_t bgColor)
{
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetHeight(ITEM_HEIGHT);
    textNode->SetBackgroundColor(bgColor);
    textNode->SetTextContent(text);
    textNode->SetFontSize(14.0F);
    textNode->SetFontColor(ITEM_TEXT_COLOR);
    textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    return textNode;
}

inline std::shared_ptr<ArkUITextNode> CreatePageHeader()
{
    auto header = std::make_shared<ArkUITextNode>();
    header->SetPercentWidth(FULL_SIZE);
    header->SetHeight(PAGE_HEADER_HEIGHT);
    header->SetTextContent("Flex / Row / Column");
    header->SetFontSize(PAGE_HEADER_FONT_SIZE);
    header->SetFontColor(HEADER_TEXT_COLOR);
    header->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    return header;
}

inline std::shared_ptr<ArkUIColumnNode> CreatePageRoot()
{
    auto root = std::make_shared<ArkUIColumnNode>();
    root->SetPercentWidth(FULL_SIZE);
    root->SetBackgroundColor(PAGE_BACKGROUND_COLOR);
    root->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    root->SetAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    root->AddChild(CreatePageHeader());
    return root;
}

inline void AddExampleSection(const std::shared_ptr<ArkUIColumnNode> &root, const std::string &title,
    const std::shared_ptr<ArkUIBaseNode> &content)
{
    root->AddChild(CreateSectionTitle(title));
    root->AddChild(content);
}

// [Start flex_row_container_helper]
inline std::shared_ptr<ArkUIRowNode> CreateRowContainer()
{
    auto row = std::make_shared<ArkUIRowNode>();
    row->SetPercentWidth(FULL_SIZE);
    row->SetHeight(SECTION_HEIGHT_SMALL);
    row->SetBackgroundColor(SECTION_BACKGROUND_COLOR);
    row->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
    row->SetAlignItems(ARKUI_VERTICAL_ALIGNMENT_CENTER);
    return row;
}
// [End flex_row_container_helper]

// [Start flex_column_container_helper]
inline std::shared_ptr<ArkUIColumnNode> CreateColumnContainer()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetPercentWidth(FULL_SIZE);
    column->SetHeight(SECTION_HEIGHT_MEDIUM);
    column->SetBackgroundColor(SECTION_BACKGROUND_COLOR);
    column->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
    column->SetAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    return column;
}
// [End flex_column_container_helper]

// [Start flex_container_helper]
inline std::shared_ptr<ArkUIFlexNode> CreateFlexContainer()
{
    auto flex = std::make_shared<ArkUIFlexNode>();
    flex->SetPercentWidth(FULL_SIZE);
    flex->SetHeight(SECTION_HEIGHT_LARGE);
    flex->SetBackgroundColor(SECTION_BACKGROUND_COLOR);
    flex->SetFlexOption(ARKUI_FLEX_DIRECTION_ROW, ARKUI_FLEX_WRAP_WRAP, ARKUI_FLEX_ALIGNMENT_START,
        ARKUI_ITEM_ALIGNMENT_CENTER, ARKUI_FLEX_ALIGNMENT_START);
    return flex;
}
// [End flex_container_helper]

// [Start flex_row_example]
inline std::shared_ptr<ArkUIRowNode> CreateRowExample()
{
    auto row = CreateRowContainer();
    row->AddChild(CreateFixedItem("Row 1", ROW_ITEM_BLUE));
    row->AddChild(CreateFixedItem("Row 2", ROW_ITEM_GREEN));
    row->AddChild(CreateFixedItem("Row 3", ROW_ITEM_ORANGE));
    return row;
}
// [End flex_row_example]

// [Start flex_column_example]
inline std::shared_ptr<ArkUITextNode> CreatePercentWidthColumnItem(const std::string &text, uint32_t bgColor)
{
    auto item = CreateFlexibleItem(text, bgColor);
    item->SetPercentWidth(COLUMN_ITEM_WIDTH);
    return item;
}

inline std::shared_ptr<ArkUIColumnNode> CreateColumnExample()
{
    auto column = CreateColumnContainer();
    column->AddChild(CreatePercentWidthColumnItem("Column 1", COLUMN_ITEM_BLUE));
    column->AddChild(CreatePercentWidthColumnItem("Column 2", COLUMN_ITEM_GREEN));
    column->AddChild(CreatePercentWidthColumnItem("Column 3", COLUMN_ITEM_PINK));
    return column;
}
// [End flex_column_example]

// [Start flex_align_self_example]
inline std::shared_ptr<ArkUITextNode> CreateFlexExampleItem(int32_t index, uint32_t bgColor)
{
    auto item = CreateFixedItem("Flex " + std::to_string(index + 1), bgColor);
    if (index == ALIGN_SELF_ITEM_INDEX) { item->SetHeight(ALIGN_SELF_ITEM_HEIGHT); }
    if (index == ALIGN_SELF_ITEM_INDEX) { SetAlignSelf(item, ARKUI_ITEM_ALIGNMENT_END); }
    return item;
}
// [End flex_align_self_example]

// [Start flex_container_example]
inline std::array<uint32_t, FLEX_ITEM_COUNT> CreateFlexColorSet()
{
    return {FLEX_ITEM_BLUE, FLEX_ITEM_GREEN, FLEX_ITEM_ORANGE, FLEX_ITEM_PINK, FLEX_ITEM_PURPLE, FLEX_ITEM_TEAL};
}

inline std::shared_ptr<ArkUIFlexNode> CreateFlexWrapExample()
{
    auto flex = CreateFlexContainer();
    const auto flexColors = CreateFlexColorSet();
    for (int32_t index = 0; index < static_cast<int32_t>(flexColors.size()); ++index) {
        flex->AddChild(CreateFlexExampleItem(index, flexColors[index]));
    }
    return flex;
}
// [End flex_container_example]

// [Start flex_grow_example]
inline std::shared_ptr<ArkUITextNode> CreateGrowItem(
    const std::string &text, uint32_t bgColor, float grow, float shrink = 0.0F)
{
    auto item = CreateFlexibleItem(text, bgColor);
    SetFlexBasis(item, FLEX_BASIS);
    SetFlexGrow(item, grow);
    SetFlexShrink(item, shrink);
    return item;
}

inline std::shared_ptr<ArkUIRowNode> CreateFlexGrowExample()
{
    auto growRow = CreateRowContainer();
    growRow->AddChild(CreateGrowItem("1", COLUMN_ITEM_BLUE, DEFAULT_FLEX_GROW));
    growRow->AddChild(CreateGrowItem("2", COLUMN_ITEM_GREEN, EMPHASIZED_FLEX_GROW, EMPHASIZED_FLEX_SHRINK));
    growRow->AddChild(CreateGrowItem("1", COLUMN_ITEM_PINK, DEFAULT_FLEX_GROW));
    return growRow;
}
// [End flex_grow_example]

// [Start flex_layout_weight_example]
inline std::shared_ptr<ArkUITextNode> CreateWeightedItem(const std::string &text, uint32_t bgColor, uint32_t weight)
{
    auto item = CreateFlexibleItem(text, bgColor);
    SetLayoutWeight(item, weight);
    return item;
}

inline std::shared_ptr<ArkUIRowNode> CreateLayoutWeightExample()
{
    auto weightRow = CreateRowContainer();
    weightRow->AddChild(CreateWeightedItem("Weight 1", COLUMN_ITEM_BLUE, DEFAULT_LAYOUT_WEIGHT));
    weightRow->AddChild(CreateWeightedItem("Weight 2", COLUMN_ITEM_GREEN, EMPHASIZED_LAYOUT_WEIGHT));
    weightRow->AddChild(CreateWeightedItem("Weight 1", COLUMN_ITEM_PINK, DEFAULT_LAYOUT_WEIGHT));
    return weightRow;
}
// [End flex_layout_weight_example]

// [Start flex_display_priority_example]
inline std::shared_ptr<ArkUITextNode> CreatePriorityItem(
    const std::string &text, uint32_t bgColor, uint32_t priority)
{
    auto item = CreateFixedItem(text, bgColor);
    SetDisplayPriority(item, priority);
    return item;
}

inline std::shared_ptr<ArkUIRowNode> CreateDisplayPriorityExample()
{
    auto priorityRow = CreateRowContainer();
    priorityRow->SetWidth(DISPLAY_PRIORITY_ROW_WIDTH);
    priorityRow->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    priorityRow->AddChild(CreatePriorityItem("High", COLUMN_ITEM_BLUE, HIGH_DISPLAY_PRIORITY));
    priorityRow->AddChild(CreatePriorityItem("Mid", COLUMN_ITEM_GREEN, MEDIUM_DISPLAY_PRIORITY));
    priorityRow->AddChild(CreatePriorityItem("Low", COLUMN_ITEM_PINK, LOW_DISPLAY_PRIORITY));
    return priorityRow;
}
// [End flex_display_priority_example]

inline void AppendFlexSections(const std::shared_ptr<ArkUIColumnNode> &root)
{
    AddExampleSection(root, "Row: 水平主轴对齐与间距", CreateRowExample());
    AddExampleSection(root, "Column: 垂直主轴排列", CreateColumnExample());
    AddExampleSection(root, "Flex: 换行与 alignSelf", CreateFlexWrapExample());
    AddExampleSection(root, "flexGrow / flexBasis", CreateFlexGrowExample());
    AddExampleSection(root, "layoutWeight", CreateLayoutWeightExample());
    AddExampleSection(root, "displayPriority", CreateDisplayPriorityExample());
}

inline std::shared_ptr<ArkUIBaseNode> CreateFlexLayoutExample()
{
    auto root = CreatePageRoot();
    AppendFlexSections(root);
    return root;
}
} // namespace NativeModule

#endif // NDKFLEXSAMPLE_FLEXLAYOUTEXAMPLE_H
// [End flex_layout_example_full]
