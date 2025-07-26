/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "CardCreator.h"
#include "node/TypedArkUINode.h"

namespace NativeModule {
namespace {
constexpr double STACK1_PERCENT_HEIGHT = 0.8;
constexpr double STACK1_PERCENT_WIDTH = 0.3;
constexpr uint32_t STACK1_BACKGROUND_COLOR = 0xffeeeeee;
constexpr int32_t STACK1_MARGIN = 8;
constexpr int32_t STACK1_BORDER_RADIUS = 10;

constexpr double IMAGE1_PERCENT_HEIGHT = 1;
constexpr double IMAGE1_PERCENT_WIDTH = 1;
constexpr uint32_t IMAGE1_BACKGROUND_COLOR = 0xffff0000;
constexpr int32_t IMAGE1_BORDER_RADIUS = 10;

constexpr double COLUMN1_PERCENT_HEIGHT = 1;
constexpr double COLUMN1_PERCENT_WIDTH = 1;
constexpr int32_t COLUMN1_BORDER_RADIUS = 10;

constexpr double COLUMN2_PERCENT_HEIGHT = 0.4;
constexpr double COLUMN2_PERCENT_WIDTH = 1;
constexpr uint32_t COLUMN2_BACKGROUND_COLOR = 0xffeeeeee;

constexpr double TEXT1_HEIGHT = 20;
constexpr double TEXT1_WIDTH = 100;
constexpr double TEXT1_FONT_SIZE = 11;

constexpr double ROW1_HEIGHT = 20;
constexpr double ROW1_WIDTH = 60;
constexpr double ROW1_POSITION = 20;

constexpr double STACK2_PERCENT_HEIGHT = 0.8;
constexpr double STACK2_PERCENT_WIDTH = 0.3;
constexpr uint32_t STACK2_BACKGROUND_COLOR = 0xffeeeeee;
constexpr int32_t STACK2_BORDER_RADIUS = 5;

constexpr double TEXT2_HEIGHT = 20;
constexpr double TEXT2_WIDTH = 70;
constexpr double TEXT2_FONT_SIZE = 10;

constexpr double APP_ITEM_COLUMN_PERCENT_HEIGHT = 1;
constexpr double APP_ITEM_COLUMN_PERCENT_WIDTH = 1;
constexpr uint32_t APP_ITEM_COLUMN_BACKGROUND_COLOR = 0xffffffff;
constexpr int32_t APP_ITEM_COLUMN_PADDING = 5;

constexpr double STACK3_PERCENT_HEIGHT = 0.8;
constexpr double STACK3_PERCENT_WIDTH = 0.7;
constexpr uint32_t STACK3_BACKGROUND_COLOR = 0xffeeeeee;
constexpr int32_t STACK3_BORDER_RADIUS = 10;

constexpr double IMAGE2_PERCENT_HEIGHT = 1;
constexpr double IMAGE2_PERCENT_WIDTH = 1;
constexpr int32_t IMAGE2_BORDER_RADIUS = 5;

constexpr double APP_NAME_TEXT_PERCENT_HEIGHT = 0.2;
constexpr double APP_NAME_TEXT_PERCENT_WIDTH = 0.8;
constexpr int32_t APP_NAME_TEXT_FONT_SIZE = 10;

constexpr double COLUMN3_PERCENT_HEIGHT = 0.4;
constexpr double COLUMN3_PERCENT_WIDTH = 0.95;
constexpr uint32_t COLUMN3_BACKGROUND_COLOR = 0xffffffff;
constexpr int32_t COLUMN3_BORDER_RADIUS = 10;
constexpr int32_t COLUMN3_PADDING = 5;

constexpr double TITLE_TEXT_PERCENT_HEIGHT = 0.1;
constexpr double TITLE_TEXT_PERCENT_WIDTH = 0.9;
constexpr int32_t TITLE_TEXT_FONT_SIZE = 16;

constexpr double HOME_GRID_PERCENT_HEIGHT = 0.9;
constexpr double HOME_GRID_PERCENT_WIDTH = 1;
constexpr double HOME_GRID_COLUMN_GAP = 3.0;

constexpr double APP_ITEM_PERCENT_HEIGHT = 0.24;
constexpr double APP_ITEM_PERCENT_WIDTH = 0.2;

constexpr double COLUMN4_PERCENT_HEIGHT = 0.2;
constexpr double COLUMN4_PERCENT_WIDTH = 0.95;
constexpr uint32_t COLUMN4_BACKGROUND_COLOR = 0xffffffff;
constexpr int32_t COLUMN4_BORDER_RADIUS = 10;
constexpr int32_t COLUMN4_PADDING = 5;

constexpr double SCROLL_PERCENT_HEIGHT = 0.9;
constexpr double SCROLL_PERCENT_WIDTH = 1;
}

std::shared_ptr<ArkUINode> CreateServiceItem(ServiceItemInfo& info)
{
    auto stackNode = std::make_shared<ArkUIStackNode>();
    stackNode->SetPercentHeight(STACK1_PERCENT_HEIGHT);
    stackNode->SetPercentWidth(STACK1_PERCENT_WIDTH);
    stackNode->SetBackgroundColor(STACK1_BACKGROUND_COLOR);
    stackNode->SetClip(true);
    stackNode->SetMargin(0, STACK1_MARGIN, STACK1_MARGIN, 0);
    stackNode->SetAlignment(ARKUI_ALIGNMENT_BOTTOM);
    stackNode->SetBorderRadius(STACK1_BORDER_RADIUS);

    auto imageNode = std::make_shared<ArkUIImageNode>();
    imageNode->SetPercentHeight(IMAGE1_PERCENT_HEIGHT);
    imageNode->SetPercentWidth(IMAGE1_PERCENT_WIDTH);
    imageNode->SetSrc(info.backgroundImageSrc.c_str());
    imageNode->SetBackgroundColor(IMAGE1_BACKGROUND_COLOR);
    imageNode->SetBorderRadius(IMAGE1_BORDER_RADIUS);
    stackNode->AddChild(imageNode);
    
    auto colorNode = std::make_shared<ArkUIColumnNode>();
    colorNode->SetPercentHeight(COLUMN1_PERCENT_HEIGHT);
    colorNode->SetPercentWidth(COLUMN1_PERCENT_WIDTH);
    colorNode->SetBackgroundColor(info.iconColor);
    colorNode->SetBorderRadius(COLUMN1_BORDER_RADIUS);
    stackNode->AddChild(colorNode);
    
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    columnNode->SetPercentHeight(COLUMN2_PERCENT_HEIGHT);
    columnNode->SetPercentWidth(COLUMN2_PERCENT_WIDTH);
    columnNode->SetBackgroundColor(COLUMN2_BACKGROUND_COLOR);
    stackNode->AddChild(columnNode);
    
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetHeight(TEXT1_HEIGHT);
    textNode->SetWidth(TEXT1_WIDTH);
    textNode->SetContent(info.describeInfo.c_str());
    textNode->SetFontSize(TEXT1_FONT_SIZE);
    columnNode->AddChild(textNode);
    
    auto rowNode = std::make_shared<ArkUIRowNode>();
    rowNode->SetHeight(ROW1_HEIGHT);
    rowNode->SetWidth(ROW1_WIDTH);
    rowNode->SetPosition(ROW1_POSITION, ROW1_POSITION);
    columnNode->AddChild(rowNode);
    
    auto stackNode2 = std::make_shared<ArkUIStackNode>();
    stackNode2->SetPercentHeight(STACK2_PERCENT_HEIGHT);
    stackNode2->SetPercentWidth(STACK2_PERCENT_WIDTH);
    stackNode2->SetBackgroundColor(STACK2_BACKGROUND_COLOR);
    stackNode2->SetClip(true);
    stackNode2->SetBorderRadius(STACK2_BORDER_RADIUS);
    rowNode->AddChild(stackNode2);
    
    auto image2Node = std::make_shared<ArkUIImageNode>();
    image2Node->SetPercentHeight(1);
    image2Node->SetPercentWidth(1);
    image2Node->SetSrc(info.iconSrc.c_str());
    stackNode2->AddChild(image2Node);
    
    auto colorNode2 = std::make_shared<ArkUIColumnNode>();
    colorNode2->SetPercentHeight(1);
    colorNode2->SetPercentWidth(1);
    colorNode2->SetBackgroundColor(info.iconColor);
    stackNode2->AddChild(colorNode2);
    
    auto text2Node = std::make_shared<ArkUITextNode>();
    text2Node->SetHeight(TEXT2_HEIGHT);
    text2Node->SetWidth(TEXT2_WIDTH);
    text2Node->SetFontSize(TEXT2_FONT_SIZE);
    text2Node->SetContent(info.name.c_str());
    rowNode->AddChild(text2Node);
    
    return stackNode;
}

std::shared_ptr<ArkUINode> CreateAppItem(AppItemInfo& info)
{
    auto appItemColumnNode = std::make_shared<ArkUIColumnNode>();
    appItemColumnNode->SetPercentHeight(APP_ITEM_COLUMN_PERCENT_HEIGHT);
    appItemColumnNode->SetPercentWidth(APP_ITEM_COLUMN_PERCENT_WIDTH);
    appItemColumnNode->SetPadding(
        APP_ITEM_COLUMN_PADDING, APP_ITEM_COLUMN_PADDING, APP_ITEM_COLUMN_PADDING, APP_ITEM_COLUMN_PADDING);
    appItemColumnNode->SetBackgroundColor(APP_ITEM_COLUMN_BACKGROUND_COLOR);
    
    auto stackNode = std::make_shared<ArkUIStackNode>();
    stackNode->SetPercentHeight(STACK3_PERCENT_HEIGHT);
    stackNode->SetPercentWidth(STACK3_PERCENT_WIDTH);
    stackNode->SetBackgroundColor(STACK3_BACKGROUND_COLOR);
    stackNode->SetClip(true);
    stackNode->SetBorderRadius(STACK3_BORDER_RADIUS);
    appItemColumnNode->AddChild(stackNode);
    
    auto appIconNode = std::make_shared<ArkUIImageNode>();
    appIconNode->SetPercentHeight(IMAGE2_PERCENT_HEIGHT);
    appIconNode->SetPercentWidth(IMAGE2_PERCENT_WIDTH);
    appIconNode->SetSrc(info.iconSrc.c_str());
    appIconNode->SetAutoResize(true);
    appIconNode->SetBorderRadius(IMAGE2_BORDER_RADIUS);
    stackNode->AddChild(appIconNode);
    
    auto colorNode = std::make_shared<ArkUIColumnNode>();
    colorNode->SetPercentHeight(1);
    colorNode->SetPercentWidth(1);
    colorNode->SetBackgroundColor(info.iconColor);
    colorNode->SetBorderRadius(COLUMN1_BORDER_RADIUS);
    stackNode->AddChild(colorNode);
    
    auto appNameNode = std::make_shared<ArkUITextNode>();
    appNameNode->SetPercentHeight(APP_NAME_TEXT_PERCENT_HEIGHT);
    appNameNode->SetPercentWidth(APP_NAME_TEXT_PERCENT_WIDTH);
    appNameNode->SetFontSize(APP_NAME_TEXT_FONT_SIZE);
    appNameNode->SetContent(info.name.c_str());
    appItemColumnNode->AddChild(appNameNode);
    
    return appItemColumnNode;
}

std::shared_ptr<ArkUINode> CreateAppCard(AppCardInfo& info)
{
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    columnNode->SetPercentHeight(COLUMN3_PERCENT_HEIGHT);
    columnNode->SetPercentWidth(COLUMN3_PERCENT_WIDTH);
    columnNode->SetBackgroundColor(COLUMN3_BACKGROUND_COLOR);
    columnNode->SetBorderRadius(COLUMN3_BORDER_RADIUS);
    columnNode->SetPadding(COLUMN3_PADDING, COLUMN3_PADDING, COLUMN3_PADDING, COLUMN3_PADDING);
    
    auto titleTextNode = std::make_shared<ArkUITextNode>();
    titleTextNode->SetPercentWidth(TITLE_TEXT_PERCENT_WIDTH);
    titleTextNode->SetPercentHeight(TITLE_TEXT_PERCENT_HEIGHT);
    titleTextNode->SetFontSize(TITLE_TEXT_FONT_SIZE);
    titleTextNode->SetContent(info.name.c_str());
    columnNode->AddChild(titleTextNode);
    
    auto homeGridNode = std::make_shared<ArkUIGridNode>();
    homeGridNode->SetPercentHeight(HOME_GRID_PERCENT_HEIGHT);
    homeGridNode->SetPercentWidth(HOME_GRID_PERCENT_WIDTH);
    homeGridNode->SetColumnTemplate("1fr 1fr 1fr 1fr 1fr");
    homeGridNode->SetColumnGap(HOME_GRID_COLUMN_GAP);
    homeGridNode->SetRowGap(0);
    columnNode->AddChild(homeGridNode);
    
    for (int32_t i = 0; i < info.items.size(); i++) {
        auto appItemNode = std::make_shared<ArkUIGridItemNode>();
        appItemNode->SetPercentHeight(APP_ITEM_PERCENT_HEIGHT);
        appItemNode->SetPercentWidth(APP_ITEM_PERCENT_WIDTH);
        homeGridNode->AddChild(appItemNode);
        appItemNode->AddChild(CreateAppItem(info.items[i]));
    }
    
    return columnNode;
}

std::shared_ptr<ArkUINode> CreateServiceCard(ServiceCardInfo& info)
{
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    columnNode->SetPercentHeight(COLUMN4_PERCENT_HEIGHT);
    columnNode->SetPercentWidth(COLUMN4_PERCENT_WIDTH);
    columnNode->SetBackgroundColor(COLUMN4_BACKGROUND_COLOR);
    columnNode->SetBorderRadius(COLUMN4_BORDER_RADIUS);
    columnNode->SetPadding(COLUMN4_PADDING, COLUMN4_PADDING, COLUMN4_PADDING, COLUMN4_PADDING);
    
    auto titleTextNode = std::make_shared<ArkUITextNode>();
    titleTextNode->SetPercentWidth(TITLE_TEXT_PERCENT_WIDTH);
    titleTextNode->SetPercentHeight(TITLE_TEXT_PERCENT_HEIGHT);
    titleTextNode->SetFontSize(TITLE_TEXT_FONT_SIZE);
    titleTextNode->SetContent(info.name.c_str());
    columnNode->AddChild(titleTextNode);
    
    auto scrollNode = std::make_shared<ArkUIScrollNode>();
    scrollNode->SetPercentWidth(SCROLL_PERCENT_WIDTH);
    scrollNode->SetPercentHeight(SCROLL_PERCENT_HEIGHT);
    scrollNode->SetScrollDirection(ARKUI_AXIS_HORIZONTAL);
    scrollNode->SetScrollBarDisplayMode(ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF);
    columnNode->AddChild(scrollNode);
    
    auto rowNode = std::make_shared<ArkUIRowNode>();
    scrollNode->AddChild(rowNode);
    
    for (int32_t i = 0; i < info.items.size(); i++) {
        rowNode->AddChild(CreateServiceItem(info.items[i]));
    }
    return columnNode;
}
} // namespace NativeModule