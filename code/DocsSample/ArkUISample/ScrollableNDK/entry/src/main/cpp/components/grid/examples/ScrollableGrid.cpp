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

#include "components/grid/examples/ScrollableGrid.h"

#include <functional>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

#include "common/ArkUINode.h"
#include "common/ArkUINodeAdapter.h"
#include "components/grid/GridNode.h"

namespace ScrollableNDK::Examples {

// ===== 常量 =====
namespace {
constexpr float K_GRID_HEIGHT = 200.0f;
constexpr char K_ROWS_TEMPLATE[] = "1fr 1fr";
constexpr char K_COLUMNS_TEMPLATE[] = "1fr 1fr 1fr 1fr";
constexpr float K_COLUMNS_GAP = 10.0f;
constexpr float K_ROWS_GAP = 15.0f;
constexpr float K_ITEM_WIDTH_PERCENT = 0.25f;
constexpr uint32_t K_ITEM_BG_COLOR = 0xFFF1F3F5U;

constexpr uint32_t K_GRID_CACHED_COUNT = 16;
constexpr bool K_GRID_SYNC_LOAD = true;
constexpr ArkUI_FocusWrapMode K_FOCUS_WRAP_MODE = ARKUI_FOCUS_WRAP_MODE_DEFAULT;

constexpr const char *K_SERVICES[] = {"Live Streaming", "Imported", "Categories", "Recharge", "Membership",
                                      "Claim Coupon",   "Lottery",  "Favorites",  "Points",   "More",
                                      "Orders",         "Cart",     "Address",    "Customer", "Settings",
                                      "Help Center",    "Feedback", "History",    "Messages", "Notifications",
                                      "Downloads",      "Uploads",  "Ranking",    "Search"};
constexpr size_t K_SERVICES_COUNT = sizeof(K_SERVICES) / sizeof(K_SERVICES[0]);
} // namespace

/**
 * 创建服务数据
 * @return 服务字符串向量
 */
static std::vector<std::string> MakeServicesData()
{
    std::vector<std::string> out;
    out.reserve(K_SERVICES_COUNT);
    for (size_t i = 0; i < K_SERVICES_COUNT; ++i) {
        out.emplace_back(K_SERVICES[i]);
    }
    return out;
}

// ---------- 配置 Grid 外观/交互 ----------
static void ConfigureGrid(const std::shared_ptr<GridNode> &grid)
{
    grid->SetWidthPercent(1.0f);
    grid->SetHeight(K_GRID_HEIGHT);
    grid->SetDefaultScrollStyle(); // 统一滚动视觉/交互
    grid->SetRowsTemplate(K_ROWS_TEMPLATE);
    grid->SetCachedCount(K_GRID_CACHED_COUNT);
    grid->SetFocusWrapMode(K_FOCUS_WRAP_MODE);
    grid->SetSyncLoad(K_GRID_SYNC_LOAD);
    grid->SetColumnsGap(K_COLUMNS_GAP);
    grid->SetRowsGap(K_ROWS_GAP);
}

// ---------- 适配器回调（创建/绑定） ----------
static ArkUI_NodeHandle GridCreateItem(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_GRID_ITEM);
    api->addChild(item, text);
    return item;
}

static void GridBindItem(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index,
                         const std::shared_ptr<std::vector<std::string>> &data)
{
    Utils::SetAttributeFloat32(api, item, NODE_WIDTH_PERCENT, K_ITEM_WIDTH_PERCENT);
    Utils::SetAttributeUInt32(api, item, NODE_BACKGROUND_COLOR, K_ITEM_BG_COLOR);

    ArkUI_NodeHandle text = api->getFirstChild(item);
    if (!text) {
        return;
    }

    const int32_t n = static_cast<int32_t>(data->size());
    const char *s = (index >= 0 && index < n) ? (*data)[static_cast<size_t>(index)].c_str() : "<invalid>";
    Utils::SetTextContent(api, text, s);
}

// ---------- 构建 Adapter ----------
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
        return static_cast<uint64_t>(i); // 越界兜底
    };
    cb.onCreate = [](ArkUI_NativeNodeAPI_1 *api, int32_t /*index*/) -> ArkUI_NodeHandle { return GridCreateItem(api); };
    cb.onBind = [data](ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index) {
        GridBindItem(api, item, index, data);
    };

    adapter->SetCallbacks(cb);
    return adapter;
}

// ---------- 整体构建 GridNode ----------
static std::shared_ptr<GridNode> BuildGrid()
{
    auto grid = std::make_shared<GridNode>();
    ConfigureGrid(grid);

    auto data = std::make_shared<std::vector<std::string>>(MakeServicesData());
    auto adapter = MakeGridAdapter(data);
    grid->SetLazyAdapter(adapter);

    // keep alive（与原逻辑一致）
    GetKeepAliveContainer<GridNode>().emplace_back(grid);
    return grid;
}

/**
 * NAPI入口函数
 * @param env NAPI环境
 * @param info 回调信息
 * @return NAPI值
 */
napi_value ScrollableGridImpl::NAPI(napi_env env, napi_callback_info info)
{
    ArkUI_NodeContentHandle content = Utils::GetNodeContentFromNapi(env, info);
    if (content == nullptr) {
        return nullptr;
    }

    auto gridNode = BuildGrid();
    Utils::AddNodeToContent(content, gridNode->GetHandle());
    return nullptr;
}

} // namespace ScrollableNDK::Examples
