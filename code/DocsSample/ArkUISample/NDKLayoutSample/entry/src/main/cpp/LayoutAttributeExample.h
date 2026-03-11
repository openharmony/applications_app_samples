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
#ifndef NDKLAYOUTSAMPLE_LAYOUTATTRIBUTEEXAMPLE_H
#define NDKLAYOUTSAMPLE_LAYOUTATTRIBUTEEXAMPLE_H

#include <memory>
#include <string>

#include "ArkUIColumnNode.h"
#include "ArkUIRowNode.h"
#include "ArkUIStackNode.h"
#include "ArkUITextNode.h"

namespace NativeModule {
namespace LayoutAttributeExampleInternal {
// [Start layout_example_full]
constexpr float FULL_SIZE = 1.0F;
constexpr float PAGE_PADDING = 10.0F;
constexpr float CARD_MARGIN_BOTTOM = 8.0F;
constexpr float CARD_TITLE_HEIGHT = 18.0F;
constexpr float SMALL_LABEL_HEIGHT = 16.0F;
constexpr float SAMPLE_ITEM_HEIGHT = 40.0F;
constexpr float SIZE_DEMO_ROW_HEIGHT = 72.0F;
constexpr float SPACING_PADDING_HOST_HEIGHT = 80.0F;
constexpr float SPACING_MARGIN_ROW_HEIGHT = 52.0F;
constexpr float BORDER_ROW_HEIGHT = 68.0F;
constexpr float POSITION_STACK_HEIGHT = 128.0F;
constexpr float WEIGHT_ROW_HEIGHT = 52.0F;
constexpr float WEIGHT_ROW_PADDING = 6.0F;
constexpr float STACK_PADDING = 10.0F;
constexpr float SECTION_BOTTOM_PADDING = 6.0F;
constexpr float SAMPLE_GAP = 12.0F;
constexpr float SMALL_ITEM_WIDTH = 64.0F;
constexpr float MEDIUM_ITEM_WIDTH = 92.0F;
constexpr float LARGE_ITEM_WIDTH = 120.0F;
constexpr float FIXED_ITEM_WIDTH = 112.0F;
constexpr float FIXED_ITEM_HEIGHT = 68.0F;
constexpr float RATIO_ITEM_HEIGHT = 64.0F;
constexpr float RATIO_VALUE = 2.0F;
constexpr float PERCENT_WIDTH_VALUE = 0.3F;
constexpr float PADDING_TOP = 16.0F;
constexpr float PADDING_RIGHT = 20.0F;
constexpr float POSITION_X = 20.0F;
constexpr float POSITION_Y = 18.0F;
constexpr float OFFSET_X = 110.0F;
constexpr float OFFSET_MARGIN_TOP = 62.0F;
constexpr float DEFAULT_BORDER_RADIUS = 18.0F;
constexpr float ALT_BORDER_RADIUS_SMALL = 12.0F;
constexpr float ALT_BORDER_RADIUS_LARGE = 24.0F;
constexpr float SOLID_BORDER_WIDTH = 2.0F;
constexpr float DECORATED_BORDER_WIDTH = 3.0F;
constexpr uint32_t PAGE_BACKGROUND_COLOR = 0xFFFFFFFF;
constexpr uint32_t SURFACE_BACKGROUND_COLOR = 0xFFF6F6F6;
constexpr uint32_t DIVIDER_COLOR = 0xFFD8DDE3;
constexpr uint32_t TRANSPARENT_COLOR = 0x00000000;
constexpr uint32_t TITLE_TEXT_COLOR = 0xFF152230;
constexpr uint32_t LABEL_TEXT_COLOR = 0xFF5B6878;
constexpr uint32_t ITEM_TEXT_COLOR = 0xFF0F1E2E;
constexpr uint32_t SIZE_ITEM_BLUE = 0xFFDDEBFF;
constexpr uint32_t SIZE_ITEM_GREEN = 0xFFD8F4E0;
constexpr uint32_t SIZE_ITEM_ORANGE = 0xFFFFE8C6;
constexpr uint32_t PADDING_ITEM_BLUE = 0xFFBEE3F8;
constexpr uint32_t BORDER_BLUE = 0xFF3B82F6;
constexpr uint32_t BORDER_GREEN = 0xFF10B981;
constexpr uint32_t BORDER_ORANGE = 0xFFF97316;
constexpr uint32_t POSITION_BASE_COLOR = 0xFFE2E8F0;
constexpr uint32_t POSITION_ITEM_ORANGE = 0xFFFFEDD5;
constexpr uint32_t POSITION_ITEM_BLUE = 0xFFDBEAFE;
constexpr uint32_t DEFAULT_LAYOUT_WEIGHT = 1;
constexpr uint32_t EMPHASIZED_LAYOUT_WEIGHT = 2;

inline std::shared_ptr<ArkUITextNode> CreateText(
    const std::string &text, float fontSize, uint32_t color, ArkUI_TextAlignment align = ARKUI_TEXT_ALIGNMENT_START)
{
    auto node = std::make_shared<ArkUITextNode>();
    node->SetTextContent(text);
    node->SetFontSize(fontSize);
    node->SetFontColor(color);
    node->SetTextAlign(align);
    return node;
}

inline std::shared_ptr<ArkUITextNode> CreateLabel(const std::string &text)
{
    auto label = CreateText(text, 11.0F, LABEL_TEXT_COLOR);
    label->SetPercentWidth(FULL_SIZE);
    label->SetHeight(SMALL_LABEL_HEIGHT);
    return label;
}

inline std::shared_ptr<ArkUITextNode> CreateDemoItem(
    const std::string &text, uint32_t backgroundColor, uint32_t fontColor = ITEM_TEXT_COLOR)
{
    auto item = CreateText(text, 12.0F, fontColor, ARKUI_TEXT_ALIGNMENT_CENTER);
    item->SetHeight(SAMPLE_ITEM_HEIGHT);
    item->SetBackgroundColor(backgroundColor);
    return item;
}

inline void ConfigureSectionCard(const std::shared_ptr<ArkUIColumnNode> &card)
{
    card->SetPercentWidth(FULL_SIZE);
    card->SetPadding(0.0F, 0.0F, SECTION_BOTTOM_PADDING, 0.0F);
    card->SetMargin(0.0F, 0.0F, CARD_MARGIN_BOTTOM, 0.0F);
    card->SetBorderWidth(0.0F, 0.0F, 1.0F, 0.0F);
    card->SetBorderColor(TRANSPARENT_COLOR, TRANSPARENT_COLOR, DIVIDER_COLOR, TRANSPARENT_COLOR);
    card->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    card->SetAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_START);
}

inline std::shared_ptr<ArkUITextNode> CreateSectionTitleNode(const std::string &title)
{
    auto titleNode = CreateText(title, 14.0F, TITLE_TEXT_COLOR);
    titleNode->SetPercentWidth(FULL_SIZE);
    titleNode->SetHeight(CARD_TITLE_HEIGHT);
    return titleNode;
}

inline std::shared_ptr<ArkUIColumnNode> CreateSectionCard(const std::string &title)
{
    auto card = std::make_shared<ArkUIColumnNode>();
    ConfigureSectionCard(card);
    card->AddChild(CreateSectionTitleNode(title));
    return card;
}

inline std::shared_ptr<ArkUIRowNode> CreateDemoRow(float height)
{
    auto row = std::make_shared<ArkUIRowNode>();
    row->SetPercentWidth(FULL_SIZE);
    row->SetHeight(height);
    row->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    row->SetAlignItems(ARKUI_VERTICAL_ALIGNMENT_CENTER);
    return row;
}

inline std::shared_ptr<ArkUIStackNode> CreateDemoStack(float height)
{
    auto stack = std::make_shared<ArkUIStackNode>();
    stack->SetPercentWidth(FULL_SIZE);
    stack->SetHeight(height);
    stack->SetBackgroundColor(SURFACE_BACKGROUND_COLOR);
    stack->SetPadding(STACK_PADDING);
    stack->SetStackAlignContent(ARKUI_ALIGNMENT_TOP_START);
    return stack;
}

// [Start layout_size_section]
inline std::shared_ptr<ArkUITextNode> CreateFixedSizeItem()
{
    auto fixedItem = CreateDemoItem("NODE_SIZE\n112 x 68vp", SIZE_ITEM_BLUE);
    fixedItem->SetSize(FIXED_ITEM_WIDTH, FIXED_ITEM_HEIGHT);
    fixedItem->SetMargin(0.0F, SAMPLE_GAP, 0.0F, 0.0F);
    return fixedItem;
}

inline std::shared_ptr<ArkUITextNode> CreateAspectRatioItem()
{
    auto ratioItem = CreateDemoItem("height=64\naspectRatio=2.0", SIZE_ITEM_GREEN);
    ratioItem->SetHeight(RATIO_ITEM_HEIGHT);
    ratioItem->SetAspectRatio(RATIO_VALUE);
    ratioItem->SetMargin(0.0F, SAMPLE_GAP, 0.0F, 0.0F);
    return ratioItem;
}

inline std::shared_ptr<ArkUITextNode> CreatePercentWidthItem()
{
    auto percentItem = CreateDemoItem("width=30%", SIZE_ITEM_ORANGE);
    percentItem->SetPercentWidth(PERCENT_WIDTH_VALUE);
    percentItem->SetHeight(RATIO_ITEM_HEIGHT);
    return percentItem;
}
// [End layout_size_section]

inline std::shared_ptr<ArkUIRowNode> CreateSizeDemoRow()
{
    auto demoRow = CreateDemoRow(SIZE_DEMO_ROW_HEIGHT);
    demoRow->AddChild(CreateFixedSizeItem());
    demoRow->AddChild(CreateAspectRatioItem());
    demoRow->AddChild(CreatePercentWidthItem());
    return demoRow;
}

inline std::shared_ptr<ArkUIColumnNode> CreateSizeSection()
{
    auto section = CreateSectionCard("尺寸与宽高比");
    section->AddChild(CreateSizeDemoRow());
    return section;
}

// [Start layout_spacing_section]
inline std::shared_ptr<ArkUITextNode> CreatePercentWidthPaddingItem()
{
    auto inner = CreateDemoItem("内容区", PADDING_ITEM_BLUE);
    inner->SetPercentWidth(FULL_SIZE);
    return inner;
}

inline std::shared_ptr<ArkUIColumnNode> CreatePaddingHost()
{
    auto paddingHost = std::make_shared<ArkUIColumnNode>();
    paddingHost->SetPercentWidth(FULL_SIZE);
    paddingHost->SetHeight(SPACING_PADDING_HOST_HEIGHT);
    paddingHost->SetBackgroundColor(SURFACE_BACKGROUND_COLOR);
    paddingHost->SetPadding(PADDING_TOP, PADDING_RIGHT, PADDING_TOP, PADDING_RIGHT);
    paddingHost->SetMargin(0.0F, 0.0F, CARD_MARGIN_BOTTOM, 0.0F);
    paddingHost->AddChild(CreatePercentWidthPaddingItem());
    return paddingHost;
}

inline std::shared_ptr<ArkUITextNode> CreateMarginItem(const std::string &text, uint32_t color, bool addSpacing = false)
{
    auto item = CreateDemoItem(text, color);
    item->SetWidth(SMALL_ITEM_WIDTH);
    if (addSpacing) { item->SetMargin(0.0F, SAMPLE_GAP, 0.0F, 0.0F); }
    return item;
}
// [End layout_spacing_section]

inline std::shared_ptr<ArkUIRowNode> CreateMarginRow()
{
    auto marginRow = CreateDemoRow(SPACING_MARGIN_ROW_HEIGHT);
    marginRow->AddChild(CreateMarginItem("A", SIZE_ITEM_BLUE, true));
    marginRow->AddChild(CreateMarginItem("B", SIZE_ITEM_GREEN, true));
    marginRow->AddChild(CreateMarginItem("C", SIZE_ITEM_ORANGE));
    return marginRow;
}

inline std::shared_ptr<ArkUIColumnNode> CreateSpacingSection()
{
    auto section = CreateSectionCard("内边距与外边距");
    section->AddChild(CreateLabel("padding"));
    section->AddChild(CreatePaddingHost());
    section->AddChild(CreateLabel("margin"));
    section->AddChild(CreateMarginRow());
    return section;
}

// [Start layout_border_section]
inline std::shared_ptr<ArkUITextNode> CreateSolidBorderItem()
{
    auto solid = CreateDemoItem("Solid", PAGE_BACKGROUND_COLOR);
    solid->SetWidth(MEDIUM_ITEM_WIDTH);
    solid->SetBorderWidth(SOLID_BORDER_WIDTH);
    solid->SetBorderColor(BORDER_BLUE);
    solid->SetBorderRadius(DEFAULT_BORDER_RADIUS);
    solid->SetMargin(0.0F, SAMPLE_GAP, 0.0F, 0.0F);
    return solid;
}

inline std::shared_ptr<ArkUITextNode> CreateDashedBorderItem()
{
    auto dashed = CreateDemoItem("Dashed", PAGE_BACKGROUND_COLOR);
    dashed->SetWidth(MEDIUM_ITEM_WIDTH);
    dashed->SetBorderWidth(DECORATED_BORDER_WIDTH);
    dashed->SetBorderColor(BORDER_GREEN);
    dashed->SetBorderStyle(ARKUI_BORDER_STYLE_DASHED);
    dashed->SetBorderRadius(DEFAULT_BORDER_RADIUS);
    dashed->SetMargin(0.0F, SAMPLE_GAP, 0.0F, 0.0F);
    return dashed;
}

inline std::shared_ptr<ArkUITextNode> CreateDottedBorderItem()
{
    auto dotted = CreateDemoItem("Dotted", PAGE_BACKGROUND_COLOR);
    dotted->SetWidth(MEDIUM_ITEM_WIDTH); dotted->SetBorderWidth(
        DECORATED_BORDER_WIDTH, DECORATED_BORDER_WIDTH, DECORATED_BORDER_WIDTH, DECORATED_BORDER_WIDTH);
    dotted->SetBorderColor(BORDER_ORANGE, BORDER_ORANGE, BORDER_ORANGE, BORDER_ORANGE); dotted->SetBorderStyle(
        ARKUI_BORDER_STYLE_DOTTED, ARKUI_BORDER_STYLE_DOTTED, ARKUI_BORDER_STYLE_DOTTED, ARKUI_BORDER_STYLE_DOTTED);
    dotted->SetBorderRadius(ALT_BORDER_RADIUS_SMALL, ALT_BORDER_RADIUS_LARGE,
        ALT_BORDER_RADIUS_SMALL, ALT_BORDER_RADIUS_LARGE);
    return dotted;
}
// [End layout_border_section]

inline std::shared_ptr<ArkUIRowNode> CreateBorderRow()
{
    auto borderRow = CreateDemoRow(BORDER_ROW_HEIGHT);
    borderRow->AddChild(CreateSolidBorderItem());
    borderRow->AddChild(CreateDashedBorderItem());
    borderRow->AddChild(CreateDottedBorderItem());
    return borderRow;
}

inline std::shared_ptr<ArkUIColumnNode> CreateBorderSection()
{
    auto section = CreateSectionCard("边框属性");
    section->AddChild(CreateBorderRow());
    return section;
}

// [Start layout_position_section]
inline std::shared_ptr<ArkUITextNode> CreatePositionedItem()
{
    auto positioned = CreateDemoItem("position(20, 18)", POSITION_ITEM_ORANGE);
    positioned->SetWidth(LARGE_ITEM_WIDTH);
    positioned->SetPosition(POSITION_X, POSITION_Y);
    return positioned;
}

inline std::shared_ptr<ArkUITextNode> CreateOffsetItem()
{
    auto offset = CreateDemoItem("offset(110, 80)", POSITION_ITEM_BLUE);
    offset->SetWidth(LARGE_ITEM_WIDTH);
    offset->SetMargin(OFFSET_MARGIN_TOP, 0.0F, 0.0F, 0.0F);
    offset->SetOffset(OFFSET_X, POSITION_Y);
    return offset;
}
// [End layout_position_section]

inline std::shared_ptr<ArkUITextNode> CreateBasePositionItem()
{
    auto base = CreateDemoItem("默认布局", POSITION_BASE_COLOR);
    base->SetWidth(MEDIUM_ITEM_WIDTH);
    return base;
}

inline std::shared_ptr<ArkUIStackNode> CreatePositionStack()
{
    auto stack = CreateDemoStack(POSITION_STACK_HEIGHT);
    stack->AddChild(CreateBasePositionItem());
    stack->AddChild(CreatePositionedItem());
    stack->AddChild(CreateOffsetItem());
    return stack;
}

inline std::shared_ptr<ArkUIColumnNode> CreatePositionSection()
{
    auto section = CreateSectionCard("位置与偏移");
    section->AddChild(CreatePositionStack());
    return section;
}

// [Start layout_weight_section]
inline std::shared_ptr<ArkUITextNode> CreateWeightedItem(
    const std::string &text, uint32_t color, uint32_t weight, bool addSpacing = false)
{
    auto item = CreateDemoItem(text, color);
    item->SetLayoutWeight(weight);
    if (addSpacing) { item->SetMargin(0.0F, CARD_MARGIN_BOTTOM, 0.0F, 0.0F); }
    return item;
}
// [End layout_weight_section]

inline std::shared_ptr<ArkUIRowNode> CreateWeightRow()
{
    auto row = CreateDemoRow(WEIGHT_ROW_HEIGHT);
    row->SetBackgroundColor(SURFACE_BACKGROUND_COLOR);
    row->SetPadding(WEIGHT_ROW_PADDING);
    row->AddChild(CreateWeightedItem("1", SIZE_ITEM_BLUE, DEFAULT_LAYOUT_WEIGHT, true));
    row->AddChild(CreateWeightedItem("2", SIZE_ITEM_GREEN, EMPHASIZED_LAYOUT_WEIGHT, true));
    row->AddChild(CreateWeightedItem("1", SIZE_ITEM_ORANGE, DEFAULT_LAYOUT_WEIGHT));
    return row;
}

inline std::shared_ptr<ArkUIColumnNode> CreateWeightSection()
{
    auto section = CreateSectionCard("layoutWeight");
    section->AddChild(CreateWeightRow());
    return section;
}

inline std::shared_ptr<ArkUIColumnNode> CreatePageContentNode()
{
    auto content = std::make_shared<ArkUIColumnNode>();
    content->SetPercentWidth(FULL_SIZE);
    content->SetPadding(PAGE_PADDING);
    content->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    content->SetAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_START);
    return content;
}

inline std::shared_ptr<ArkUIColumnNode> CreatePageContent()
{
    auto content = CreatePageContentNode();
    content->AddChild(CreateSizeSection());
    content->AddChild(CreateSpacingSection());
    content->AddChild(CreateBorderSection());
    content->AddChild(CreatePositionSection());
    content->AddChild(CreateWeightSection());
    return content;
}

// [Start layout_safe_area_section]
inline std::shared_ptr<ArkUIColumnNode> CreatePageRoot()
{
    auto root = std::make_shared<ArkUIColumnNode>();
    root->SetPercentWidth(FULL_SIZE);
    root->SetPercentHeight(FULL_SIZE);
    root->SetBackgroundColor(PAGE_BACKGROUND_COLOR);
    root->SetExpandSafeArea(ARKUI_SAFE_AREA_TYPE_SYSTEM | ARKUI_SAFE_AREA_TYPE_CUTOUT,
        ARKUI_SAFE_AREA_EDGE_TOP | ARKUI_SAFE_AREA_EDGE_BOTTOM);
    root->SetJustifyContent(ARKUI_FLEX_ALIGNMENT_START);
    root->SetAlignItems(ARKUI_HORIZONTAL_ALIGNMENT_START);
    return root;
}
// [End layout_safe_area_section]
} // namespace LayoutAttributeExampleInternal

inline std::shared_ptr<ArkUIBaseNode> CreateLayoutAttributeExample()
{
    auto root = LayoutAttributeExampleInternal::CreatePageRoot();
    root->AddChild(LayoutAttributeExampleInternal::CreatePageContent());
    return root;
}
// [End layout_example_full]
} // namespace NativeModule

#endif // NDKLAYOUTSAMPLE_LAYOUTATTRIBUTEEXAMPLE_H
