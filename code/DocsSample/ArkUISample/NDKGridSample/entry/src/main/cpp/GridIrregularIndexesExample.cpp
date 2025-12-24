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

#include "GridIrregularIndexesExample.h"

#include "ArkUIColumnNode.h"
#include "ArkUIGridItemNode.h"
#include "ArkUIGridLayoutOptions.h"
#include "ArkUIGridNode.h"
#include "ArkUINodeAdapter.h"
#include "ArkUITextNode.h"

namespace NativeModule {
namespace {
constexpr float K_ITEM_HEIGHT = 80.0f;
constexpr float K_ITEM_WIDTH_PERCENT = 1.0f;
constexpr float K_NODE_FONT_SIZE = 16.0f;
constexpr uint32_t K_ITEM_BG_COLOR = 0xFFF9CF93U;
constexpr int32_t ITEM_COUNT = 8;
} // namespace

template <typename T> inline std::vector<std::shared_ptr<T>> &GetKeepAliveContainer()
{
    static std::vector<std::shared_ptr<T>> keepAliveContainer;
    return keepAliveContainer;
}

static void ConfigureGrid(const std::shared_ptr<ArkUIGridNode> &grid)
{
    // [Start grid_columns]
    grid->SetColumnsTemplate("1fr 1fr 1fr");
    grid->SetColumnsGap(10.0f);
    grid->SetRowsGap(10.0f);
    grid->SetScrollBar(ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF);
    // [End grid_columns]
    grid->SetPercentWidth(0.9f);
    grid->SetPercentHeight(1.0f);
    grid->SetBackgroundColor(0xFFFAEEE0);
}


static std::vector<std::string> BuildData()
{
    std::vector<std::string> data;
    for (size_t i = 0; i < ITEM_COUNT; i++) {
        for (size_t j = 0; j < ITEM_COUNT; j++) {
            data.emplace_back(std::to_string(j));
        }
    }
    return data;
}

static void GridBindItem(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index,
                         const std::shared_ptr<std::vector<std::string>> &data)
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
    const char *s = (index >= 0 && index < n) ? (*data)[static_cast<size_t>(index)].c_str() : "<invalid>";
    SetTextContent(api, text, s);
}

static ArkUI_NodeHandle GridCreateItem(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_GRID_ITEM);
    api->addChild(item, text);
    return item;
}

static std::shared_ptr<ArkUINodeAdapter> MakeGridAdapter(const std::shared_ptr<std::vector<std::string>> &data)
{
    auto adapter = std::make_shared<ArkUINodeAdapter>();
    adapter->EnsurePlaceholderTypeOr(static_cast<int32_t>(ARKUI_NODE_GRID_ITEM));

    ArkUINodeAdapter::Callbacks cb{};
    cb.getTotalCount = [data]() -> int32_t { return static_cast<int32_t>(data->size()); };
    cb.getStableId = [data](int32_t i) -> uint64_t {
        const int32_t n = static_cast<int32_t>(data->size());
        if (i >= 0 && i < n) {
            return static_cast<uint64_t>(std::hash<std::string>{}((*data)[static_cast<size_t>(i)]));
        }
        return static_cast<uint64_t>(i);
    };
    cb.onCreate = [](ArkUI_NativeNodeAPI_1 *api, int32_t /*index*/) -> ArkUI_NodeHandle { return GridCreateItem(api); };
    cb.onBind = [data](ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index) {
        GridBindItem(api, item, index, data);
    };

    adapter->SetCallbacks(cb);
    return adapter;
}

static std::shared_ptr<ArkUIGridNode> BuildGrid()
{
    auto grid = std::make_shared<ArkUIGridNode>();
    ConfigureGrid(grid);
    auto data = std::make_shared<std::vector<std::string>>(BuildData());
    auto adapter = MakeGridAdapter(data);
    grid->SetLazyAdapter(adapter);
    adapter->ReloadAllItems();

    // [Start grid_group_indexes]
    auto layoutOptions = std::make_shared<ArkuiGridLayoutOptions>();
    uint32_t irregularIndexes[] = {0, 6, 8, 15};
    OH_ArkUI_GridLayoutOptions_SetIrregularIndexes(layoutOptions->GetLayoutOptions(), irregularIndexes,
                                                   sizeof(irregularIndexes) / sizeof(irregularIndexes[0]));
    grid->SetLayoutOptions(layoutOptions->GetLayoutOptions());
    // [End grid_group_indexes]
    GetKeepAliveContainer<ArkUIGridNode>().emplace_back(grid);
    return grid;
}

std::shared_ptr<ArkUIBaseNode> GridIrregularIndexesExample::CreateNativeNode()
{
    auto page = std::make_shared<ArkUIColumnNode>();
    page->SetPercentWidth(1.0f);
    page->SetPercentHeight(1.0f);
    if (page == nullptr || page->GetHandle() == nullptr) {
        return nullptr;
    }

    std::shared_ptr<ArkUIGridNode> grid = BuildGrid();
    if (grid && grid->GetHandle() != nullptr) {
        page->AddChild(grid);
    }

    GetKeepAliveContainer<ArkUIColumnNode>().emplace_back(page);
    return page;
}
} // namespace NativeModule
