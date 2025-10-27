/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */

#include "GridRectByIndexMaker.h"

#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <cstdio> // snprintf
#include <functional>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>

#include "ArkUINodeAdapter.h"
#include "ScrollableNode.h"

namespace {
// ===== 布局与样式常量 =====
constexpr char K_ROWS_TEMPLATE[] = "1fr 1fr 1fr 1fr 1fr";
constexpr char K_COLUMNS_TEMPLATE[] = "1fr 1fr 1fr 1fr 1fr";
constexpr char K_ROWS_TEMPLATE_RECT_BY_INDEX[] = "1fr 1fr 1fr 1fr 1fr 1fr";
constexpr char K_COLUMNS_TEMPLATE_RECT_BY_INDEX[] = "1fr 1fr 1fr 1fr 1fr 1fr";
constexpr float K_WIDTH_PERCENT = 0.9f;
constexpr float K_COLUMNS_GAP = 10.0f;
constexpr float K_ROWS_GAP = 10.0f;
constexpr float K_HEIGHT = 300.0f;
constexpr uint32_t K_ITEM_BG_COLOR = 0xFFF9CF93U;
constexpr uint32_t K_BG_COLOR = 0xFFFAEEE0;
constexpr uint32_t K_TEXT_COLOR = 0xFFCCCCCC;
constexpr float K_TEXT_SIZE = 16.0f;
constexpr float K_ITEM_HEIGHT_PERCENT = 1.0f;
constexpr float K_ITEM_WIDTH_PERCENT = 1.0f;
constexpr float K_NODE_FONT_SIZE = 16.0f;
constexpr unsigned int K_LOG_PRINT_DOMAIN = 0xFF00;
constexpr int K_GRID_INDEX_WIDTH = 2;
constexpr uint32_t NUMBER_0 = 0;
constexpr uint32_t NUMBER_1 = 1;
constexpr uint32_t NUMBER_2 = 2;
constexpr uint32_t NUMBER_3 = 3;
constexpr uint32_t NUMBER_4 = 4;
constexpr uint32_t NUMBER_5 = 5;
constexpr uint32_t NUMBER_6 = 6;
const std::vector<std::string> NUMBERS_1 = { "0", "1", "2", "3", "4" };
const std::vector<std::string> NUMBERS_2 = { "0", "1", "2", "3", "4", "5" };
const std::string CONTENT = "GridLayoutOptions的使用：onGetRectByIndex。";

} // namespace
std::shared_ptr<GridLayoutOptions> GridRectByIndexMaker::layoutOptions_;

static std::shared_ptr<ArkUI_NodeHandle> CreateGridItem(ArkUI_NativeNodeAPI_1* api, const std::string& content)
{
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_GRID_ITEM);
    SetAttributeUInt32(api, text, NODE_TEXT_ALIGN, ARKUI_TEXT_ALIGNMENT_CENTER);
    SetAttributeUInt32(api, text, NODE_BACKGROUND_COLOR, K_ITEM_BG_COLOR);
    SetAttributeFloat32(api, text, NODE_HEIGHT_PERCENT, K_ITEM_HEIGHT_PERCENT);
    SetAttributeFloat32(api, text, NODE_WIDTH_PERCENT, K_ITEM_WIDTH_PERCENT);
    SetAttributeFloat32(api, text, NODE_FONT_SIZE, K_NODE_FONT_SIZE);
    SetTextContent(api, text, content.c_str());
    api->addChild(item, text);
    return std::make_shared<ArkUI_NodeHandle>(item);
}

// ---------- 整体构建普通Grid ----------
static std::shared_ptr<GridRectByIndexMaker> BuildGrid()
{
    ArkUI_NativeNodeAPI_1* nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);

    auto grid = std::make_shared<GridRectByIndexMaker>();
    grid->SetWidthPercent(K_WIDTH_PERCENT);
    grid->SetHeight(K_HEIGHT);
    grid->SetColumnsTemplate(K_COLUMNS_TEMPLATE);
    grid->SetRowsTemplate(K_ROWS_TEMPLATE);
    grid->SetColumnsGap(K_COLUMNS_GAP);
    grid->SetRowsGap(K_ROWS_GAP);
    grid->SetBackgroundColor(K_BG_COLOR);

    for (auto i = 0; i < NUMBERS_1.size(); i++) {
        for (auto j = 0; j < NUMBERS_1.size(); j++) {
            auto gridItem = CreateGridItem(nodeAPI, std::to_string(i));
            nodeAPI->addChild(grid->GetHandle(), *gridItem);
        }
    }

    GetKeepAliveContainer<GridRectByIndexMaker>().emplace_back(grid);
    return grid;
}

// ---------- 构建指定GridItemRect Grid ----------
std::shared_ptr<GridRectByIndexMaker> GridRectByIndexMaker::BuildGridRectByIndex()
{
    ArkUI_NativeNodeAPI_1* nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    auto grid = std::make_shared<GridRectByIndexMaker>();
    grid->SetWidthPercent(K_WIDTH_PERCENT);
    grid->SetHeight(K_HEIGHT);
    grid->SetColumnsTemplate(K_COLUMNS_TEMPLATE_RECT_BY_INDEX);
    grid->SetRowsTemplate(K_ROWS_TEMPLATE_RECT_BY_INDEX);
    grid->SetColumnsGap(K_COLUMNS_GAP);
    grid->SetRowsGap(K_ROWS_GAP);

    for (auto i = 0; i < NUMBERS_2.size(); i++) {
        auto gridItem = CreateGridItem(nodeAPI, std::to_string(i));
        nodeAPI->addChild(grid->GetHandle(), *gridItem);
    }

    OH_ArkUI_GridLayoutOptions_RegisterGetRectByIndexCallback(
        layoutOptions_->GetLayoutOptions(), nullptr, [](int32_t itemIndex, void* userData) -> ArkUI_GridItemRect {
            if (itemIndex == NUMBER_0) {
                return ArkUI_GridItemRect { 0, 0, 1, 1 };
            } else if (itemIndex == NUMBER_1) {
                return ArkUI_GridItemRect { 0, 1, 2, 2 };
            } else if (itemIndex == NUMBER_2) {
                return ArkUI_GridItemRect { 0, 3, 3, 3 };
            } else if (itemIndex == NUMBER_3) {
                return ArkUI_GridItemRect { 3, 0, 3, 3 };
            } else if (itemIndex == NUMBER_4) {
                return ArkUI_GridItemRect { 4, 3, 2, 2 };
            } else {
                return ArkUI_GridItemRect { 5, 5, 1, 1 };
            }
        });
    grid->SetLayoutOptions(layoutOptions_->GetLayoutOptions());
    GetKeepAliveContainer<GridRectByIndexMaker>().emplace_back(grid);
    return grid;
}

// ---------- 构建 Text ----------
static std::shared_ptr<ArkUI_NodeHandle> BuildText(
    ArkUI_NativeNodeAPI_1* api, const std::string& content, uint32_t fontColor, float fontSize)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    SetTextContent(api, textNode, content.c_str());
    SetAttributeFloat32(api, textNode, NODE_FONT_SIZE, fontSize);
    SetAttributeUInt32(api, textNode, NODE_FONT_COLOR, fontColor);
    return std::make_shared<ArkUI_NodeHandle>(textNode);
}

ArkUI_NodeHandle GridRectByIndexMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1* api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }

    // 根容器全屏
    ArkUI_NodeHandle page = api->createNode(ARKUI_NODE_COLUMN);
    if (page == nullptr) {
        return nullptr;
    }
    SetAttributeFloat32(api, page, NODE_WIDTH_PERCENT, 1.0f);
    SetAttributeFloat32(api, page, NODE_HEIGHT_PERCENT, 1.0f);

    // 构建 Grid
    std::shared_ptr<GridRectByIndexMaker> grid = BuildGrid();
    if (grid && grid->GetHandle() != nullptr) {
        api->addChild(page, grid->GetHandle());
    }

    // 构建Text
    std::shared_ptr<ArkUI_NodeHandle> text = BuildText(api, CONTENT, K_TEXT_COLOR, K_TEXT_SIZE);
    if (text) {
        api->addChild(page, *text);
    }

    // 构建不规则Grid
    std::shared_ptr<GridRectByIndexMaker> grid2 = BuildGridRectByIndex();
    if (grid2 && grid2->GetHandle() != nullptr) {
        api->addChild(page, grid2->GetHandle());
    }
    return page;
}