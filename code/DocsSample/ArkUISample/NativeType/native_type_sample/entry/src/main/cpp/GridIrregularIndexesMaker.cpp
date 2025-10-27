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

#include "GridIrregularIndexesMaker.h"

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
constexpr char K_COLUMNS_TEMPLATE[] = "1fr 1fr 1fr 1fr 1fr";
constexpr float K_WIDTH_PERCENT = 0.9f;
constexpr float K_COLUMNS_GAP = 10.0f;
constexpr float K_ROWS_GAP = 10.0f;
constexpr float K_HEIGHT = 300.0f;
constexpr float K_TEXT_SIZE = 16.0f;
constexpr float K_ITEM_HEIGHT = 80.0f;
constexpr float K_ITEM_WIDTH_PERCENT = 1.0f;
constexpr float K_NODE_FONT_SIZE = 16.0f;
constexpr uint32_t K_ITEM_BG_COLOR = 0xFFF9CF93U;
constexpr uint32_t K_BG_COLOR = 0xFFFAEEE0;
constexpr uint32_t K_TEXT_COLOR = 0xFFCCCCCC;
constexpr uint32_t NUMBER_0 = 0;
constexpr uint32_t NUMBER_2 = 2;
constexpr uint32_t NUMBER_5 = 5;
const std::string CONTENT = "scroll";
} // namespace
std::shared_ptr<GridLayoutOptions> GridIrregularIndexesMaker::layoutOptions1_;
std::shared_ptr<GridLayoutOptions> GridIrregularIndexesMaker::layoutOptions2_;
// ---------- 配置 Grid 外观/交互 ----------
static void ConfigureGrid(const std::shared_ptr<GridIrregularIndexesMaker>& grid)
{
    grid->SetColumnsTemplate(K_COLUMNS_TEMPLATE);
    grid->SetColumnsGap(K_COLUMNS_GAP);
    grid->SetRowsGap(K_ROWS_GAP);
    grid->SetScrollBar(ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF);
    grid->SetWidthPercent(K_WIDTH_PERCENT);
    grid->SetHeight(K_HEIGHT);
    grid->SetBackgroundColor(K_BG_COLOR);
}

static std::vector<std::string> BuildData()
{
    std::vector<std::string> data;
    for (size_t i = NUMBER_0; i < NUMBER_5; i++) {
        for (size_t j = NUMBER_0; j < NUMBER_5; j++) {
            data.emplace_back(std::to_string(j));
        }
    }
    return data;
}

// ---------- 适配器回调（创建/绑定） ----------
static ArkUI_NodeHandle GridCreateItem(ArkUI_NativeNodeAPI_1* api)
{
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_GRID_ITEM);
    api->addChild(item, text);
    return item;
}

static void GridBindItem(ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle item, int32_t index,
    const std::shared_ptr<std::vector<std::string>>& data)
{
    SetAttributeFloat32(api, item, NODE_FONT_SIZE, K_NODE_FONT_SIZE);
    SetAttributeUInt32(api, item, NODE_BACKGROUND_COLOR, K_ITEM_BG_COLOR);
    SetAttributeFloat32(api, item, NODE_HEIGHT, K_ITEM_HEIGHT);
    SetAttributeUInt32(api, item, NODE_TEXT_ALIGN, ARKUI_TEXT_ALIGNMENT_CENTER);
    SetAttributeFloat32(api, item, NODE_WIDTH_PERCENT, K_ITEM_WIDTH_PERCENT);

    ArkUI_NodeHandle text = api->getFirstChild(item);
    if (!text) {
        return;
    }

    const int32_t n = static_cast<int32_t>(data->size());
    const char* s = (index >= 0 && index < n) ? (*data)[static_cast<size_t>(index)].c_str() : "<invalid>";
    SetTextContent(api, text, s);
}

// ---------- 构建 Adapter ----------
static std::shared_ptr<ArkUINodeAdapter> MakeGridAdapter(const std::shared_ptr<std::vector<std::string>>& data)
{
    auto adapter = std::make_shared<ArkUINodeAdapter>();
    adapter->EnsurePlaceholderTypeOr(static_cast<int32_t>(ARKUI_NODE_GRID_ITEM));

    ArkUINodeAdapter::Callbacks cb {};
    cb.getTotalCount = [data]() -> int32_t { return static_cast<int32_t>(data->size()); };
    cb.getStableId = [data](int32_t i) -> uint64_t {
        const int32_t n = static_cast<int32_t>(data->size());
        if (i >= 0 && i < n) {
            return static_cast<uint64_t>(std::hash<std::string> {}((*data)[static_cast<size_t>(i)]));
        }
        return static_cast<uint64_t>(i);
    };
    cb.onCreate = [](ArkUI_NativeNodeAPI_1* api, int32_t /*index*/) -> ArkUI_NodeHandle { return GridCreateItem(api); };
    cb.onBind = [data](ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle item, int32_t index) {
        GridBindItem(api, item, index, data);
    };

    adapter->SetCallbacks(cb);
    return adapter;
}

std::shared_ptr<GridIrregularIndexesMaker> GridIrregularIndexesMaker::BuildGrid1()
{
    auto grid = std::make_shared<GridIrregularIndexesMaker>();
    ConfigureGrid(grid);
    auto data = std::make_shared<std::vector<std::string>>(BuildData());
    auto adapter = MakeGridAdapter(data);
    grid->SetLazyAdapter(adapter);
    adapter->ReloadAllItems();

    uint32_t irregularIndexes[] = { 0, 6 };
    OH_ArkUI_GridLayoutOptions_SetIrregularIndexes(layoutOptions1_->GetLayoutOptions(), irregularIndexes, NUMBER_2);
    grid->SetLayoutOptions(layoutOptions1_->GetLayoutOptions());
    GetKeepAliveContainer<GridIrregularIndexesMaker>().emplace_back(grid);
    return grid;
}

// ---------- 构建指定GridItemRect Grid ----------
std::shared_ptr<GridIrregularIndexesMaker> GridIrregularIndexesMaker::BuildGrid2()
{
    auto grid = std::make_shared<GridIrregularIndexesMaker>();
    ConfigureGrid(grid);

    auto data = std::make_shared<std::vector<std::string>>(BuildData());
    auto adapter = MakeGridAdapter(data);
    grid->SetLazyAdapter(adapter);
    adapter->ReloadAllItems();

    uint32_t irregularIndexes[] = { 0, 7 };
    OH_ArkUI_GridLayoutOptions_SetIrregularIndexes(layoutOptions2_->GetLayoutOptions(), irregularIndexes, NUMBER_2);
    OH_ArkUI_GridLayoutOptions_RegisterGetIrregularSizeByIndexCallback(
        layoutOptions2_->GetLayoutOptions(), nullptr, [](int32_t itemIndex, void* userData) -> ArkUI_GridItemSize {
            if (itemIndex == 0) {
                return { 1, 5 };
            }
            return { 1, static_cast<uint32_t>(itemIndex % 6 + 1) };
        });
    grid->SetLayoutOptions(layoutOptions2_->GetLayoutOptions());
    GetKeepAliveContainer<GridIrregularIndexesMaker>().emplace_back(grid);
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

ArkUI_NodeHandle GridIrregularIndexesMaker::CreateNativeNode()
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
    std::shared_ptr<GridIrregularIndexesMaker> grid = BuildGrid1();
    if (grid && grid->GetHandle() != nullptr) {
        api->addChild(page, grid->GetHandle());
    }

    // 构建Text
    std::shared_ptr<ArkUI_NodeHandle> text = BuildText(api, CONTENT, K_TEXT_COLOR, K_TEXT_SIZE);
    if (text) {
        api->addChild(page, *text);
    }

    // 构建不规则Grid
    std::shared_ptr<GridIrregularIndexesMaker> grid2 = BuildGrid2();
    if (grid2 && grid2->GetHandle() != nullptr) {
        api->addChild(page, grid2->GetHandle());
    }
    return page;
}