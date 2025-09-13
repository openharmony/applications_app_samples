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

#include "common/NativeNodeUtils.h"
#include "components/grid/GridItemAdapter.h"
#include "components/grid/GridNode.h"

namespace ScrollableNDK::Examples {

// ===== 常量 =====
namespace {
constexpr float K_GRID_HEIGHT = 200.0f;
constexpr char K_ROWS_TEMPLATE[] = "1fr 1fr"; // 仅设行模板 → 横向可滚
constexpr float K_COLUMNS_GAP = 10.0f;
constexpr float K_ROWS_GAP = 15.0f;
constexpr float K_ITEM_WIDTH_PERCENT = 0.25f; // 每项 25% 宽
constexpr uint32_t K_ITEM_BG_COLOR = 0xFFF1F3F5U;

constexpr const char *K_SERVICES[] = {"Live Streaming", "Imported", "Categories", "Recharge", "Membership",
                                      "Claim Coupon",   "Lottery",  "Favorites",  "Points",   "More"};
constexpr size_t K_SERVICES_COUNT = sizeof(K_SERVICES) / sizeof(K_SERVICES[0]);
} // namespace

/** 生成示例数据 */
static std::vector<std::string> MakeServicesData()
{
    std::vector<std::string> out;
    out.reserve(K_SERVICES_COUNT);
    for (size_t i = 0; i < K_SERVICES_COUNT; ++i) {
        out.emplace_back(K_SERVICES[i]);
    }
    return out;
}

/** 构建 Grid 适配器回调 */
static GridItemAdapterCallbacks MakeGridCallbacks(const std::shared_ptr<GridItemAdapter> &adapter)
{
    GridItemAdapterCallbacks cb{};

    cb.getTotalCount = [adapter]() -> int32_t { return static_cast<int32_t>(adapter->GetData().size()); };

    cb.getStableId = [adapter](int32_t i) -> uint64_t {
        return static_cast<uint64_t>(std::hash<std::string>{}(adapter->GetData()[i]));
    };

    cb.onCreate = [](ArkUI_NativeNodeAPI_1 *api, int32_t /*index*/) -> ArkUI_NodeHandle {
        ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
        ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_GRID_ITEM);
        api->addChild(item, text);
        return item;
    };

    cb.onBind = [adapter](ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index) {
        SetAttrF32(api, item, NODE_WIDTH_PERCENT, K_ITEM_WIDTH_PERCENT);
        SetAttrU32(api, item, NODE_BACKGROUND_COLOR, K_ITEM_BG_COLOR);

        ArkUI_NodeHandle text = api->getFirstChild(item);
        if (text) {
            const std::string &s = adapter->GetData()[index];
            SetTextContent(api, text, s.c_str());
        }
    };

    return cb;
}

// ===== NAPI 入口 =====
napi_value ScrollableGridImpl::NAPI(napi_env env, napi_callback_info info)
{
    ArkUI_NodeContentHandle content = ScrollableNDK::GetContentFromArg(env, info);
    if (!content) {
        return nullptr;
    }

    auto gridNode = std::make_shared<ScrollableNDK::ArkUIGridNode>();
    gridNode->SetWidthPercent(1.0f);
    gridNode->SetHeight(K_GRID_HEIGHT);
    gridNode->SetRowsTemplate(K_ROWS_TEMPLATE);
    gridNode->SetColumnsGap(K_COLUMNS_GAP);
    gridNode->SetRowsGap(K_ROWS_GAP);

    auto adapter = std::make_shared<ScrollableNDK::GridItemAdapter>();
    adapter->SetData(MakeServicesData());
    adapter->SetCallbacks(MakeGridCallbacks(adapter));
    gridNode->SetLazyAdapter(adapter);

    ScrollableNDK::AddNodeToContent(content, gridNode->Get());
    ScrollableNDK::KeepAliveVec<ScrollableNDK::ArkUIGridNode>().emplace_back(gridNode);
    return nullptr;
}

} // namespace ScrollableNDK::Examples
