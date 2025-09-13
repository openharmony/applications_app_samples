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

#include <algorithm>
#include <string>
#include <vector>

#include "common/NativeNodeUtils.h"
#include "components/waterflow/FlowItemAdapter.h"
#include "components/waterflow/WaterFlowNode.h"
#include "components/waterflow/WaterFlowSection.h"
#include "components/waterflow/examples/WaterFlowInfiniteScrollingEarly.h"

namespace ScrollableNDK::Examples {

// ===== 常量 =====
namespace {
constexpr float K_MAIN_SIZE_A = 120.0f;
constexpr float K_MAIN_SIZE_B = 160.0f;
constexpr float K_MAIN_SIZE_C = 100.0f;
constexpr float K_FONT_SIZE = 16.0f;

constexpr float K_WATER_FLOW_W = 400.0f;
constexpr float K_WATER_FLOW_H = 600.0f;

constexpr int K_INIT_RESERVE_ITEMS = 200;
constexpr int K_INIT_SEED_ITEMS = 100;

constexpr int32_t K_CROSS_COUNT = 2;
constexpr float K_COLUMNS_GAP = 10.0f;
constexpr float K_ROWS_GAP = 10.0f;
constexpr int32_t K_MARGIN_TOP = 12;
constexpr int32_t K_MARGIN_RIGHT = 12;
constexpr int32_t K_MARGIN_BOTTOM = 12;
constexpr int32_t K_MARGIN_LEFT = 12;

constexpr float K_MAIN_SIZE_SEQ[] = {K_MAIN_SIZE_A, K_MAIN_SIZE_B, K_MAIN_SIZE_C};
constexpr size_t K_MAIN_SIZE_SEQ_COUNT = sizeof(K_MAIN_SIZE_SEQ) / sizeof(K_MAIN_SIZE_SEQ[0]);

constexpr uint32_t K_PALETTE[] = {0xFF6A5ACD, 0xFF00FFFF, 0xFF00FF7F, 0xFFDA70D6, 0xFFFFC0CB};
constexpr size_t K_PALETTE_COUNT = sizeof(K_PALETTE) / sizeof(K_PALETTE[0]);

constexpr int K_AUTO_THRESHOLD = 20;
constexpr int K_AUTO_BATCH = 100;
constexpr int K_AUTO_MAX_ITEMS = 100000;
} // namespace

// ===== 状态 =====
static std::shared_ptr<ArkUIWaterFlowNode> g_node;
static std::shared_ptr<FlowItemAdapter> g_adapter;
static std::shared_ptr<WaterFlowSection> g_section;
static std::vector<std::string> g_items;

static struct AutoAppendConfig {
    bool enabled = true;
    int threshold = K_AUTO_THRESHOLD;
    int batch = K_AUTO_BATCH;
    int maxItems = K_AUTO_MAX_ITEMS;
    bool appending = false;
    int lastSizeTriggered = -1;
} g_auto;

// ===== 工具 =====
static inline float MainSizeByIndex(int32_t idx)
{
    if (K_MAIN_SIZE_SEQ_COUNT == 0) {
        return K_MAIN_SIZE_C;
    }
    size_t i = static_cast<size_t>(idx) % K_MAIN_SIZE_SEQ_COUNT;
    return K_MAIN_SIZE_SEQ[i];
}

static inline uint32_t ColorByIndex(int index)
{
    if (K_PALETTE_COUNT == 0) {
        return 0xFFFFFFFFU;
    }
    size_t i = static_cast<size_t>(index) % K_PALETTE_COUNT;
    return K_PALETTE[i];
}

static inline void BindText(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle flowItem, int32_t index)
{
    ArkUI_NodeHandle text = api->getFirstChild(flowItem);
    if (!text) {
        return;
    }
    SetTextContent(api, text, g_items[index].c_str());
    SetFontSize(api, text, K_FONT_SIZE);
}

static void AppendBatchInternal(int addCount)
{
    if (!g_adapter || !g_section || !g_node) {
        return;
    }
    if (addCount <= 0) {
        return;
    }

    int32_t start = static_cast<int32_t>(g_items.size());
    g_items.reserve(g_items.size() + static_cast<size_t>(addCount));
    for (int i = 0; i < addCount; ++i) {
        g_items.emplace_back("FlowItem " + std::to_string(start + i));
    }

    g_adapter->InsertRange(start, addCount);
    OH_ArkUI_WaterFlowSectionOption_SetItemCount(g_section->GetSectionOptions(), 0,
                                                 static_cast<int32_t>(g_items.size()));
    g_node->SetSection(g_section);

    g_auto.lastSizeTriggered = static_cast<int>(g_items.size());
}

static inline bool ShouldAppendOnTailBoundaryMet(int total)
{
    return (total >= g_auto.maxItems) || (total == g_auto.lastSizeTriggered);
}

static inline bool ShouldAppendOnTail(int32_t index, int total)
{
    if (!g_auto.enabled || g_auto.appending) {
        return false;
    }
    if (ShouldAppendOnTailBoundaryMet(total)) {
        return false;
    }
    if (index < (total - g_auto.threshold)) {
        return false;
    }
    return true;
}

static inline void MaybeAppendOnTail(int32_t index)
{
    int total = static_cast<int>(g_items.size());
    if (!ShouldAppendOnTail(index, total)) {
        return;
    }

    g_auto.appending = true;
    int remain = g_auto.maxItems - total;
    int toAdd = (remain > 0) ? std::min(g_auto.batch, remain) : 0;
    AppendBatchInternal(toAdd);
    g_auto.appending = false;
}

// ===== 适配器回调 =====
static int32_t AdapterGetTotalCount() { return static_cast<int32_t>(g_items.size()); }

static uint64_t AdapterGetStableId(int32_t i) { return static_cast<uint64_t>(std::hash<std::string>{}(g_items[i])); }

static ArkUI_NodeHandle AdapterOnCreate(ArkUI_NativeNodeAPI_1 *api, int32_t /*index*/)
{
    if (api == nullptr) {
        return nullptr;
    }
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_FLOW_ITEM);
    api->addChild(item, text);
    return item;
}

static void AdapterOnBind(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index)
{
    SetAttrF32(api, item, NODE_HEIGHT, MainSizeByIndex(index));
    SetAttrF32(api, item, NODE_WIDTH_PERCENT, 1.0f);
    SetAttrU32(api, item, NODE_BACKGROUND_COLOR, ColorByIndex(index));
    BindText(api, item, index);
    MaybeAppendOnTail(index);
}

static FlowItemAdapterCallbacks MakeCallbacks()
{
    FlowItemAdapterCallbacks cb{};
    cb.getTotalCount = &AdapterGetTotalCount;
    cb.getStableId = &AdapterGetStableId;
    cb.onCreate = &AdapterOnCreate;
    cb.onBind = &AdapterOnBind;
    cb.onRecycle = nullptr;
    return cb;
}

// ===== 组装 UI =====
static inline void SetupSection()
{
    g_section = std::make_shared<WaterFlowSection>();

    SectionOption opt{};
    opt.itemsCount = static_cast<int32_t>(g_items.size());
    opt.crossCount = K_CROSS_COUNT;
    opt.columnsGap = K_COLUMNS_GAP;
    opt.rowsGap = K_ROWS_GAP;
    opt.margin = {K_MARGIN_TOP, K_MARGIN_RIGHT, K_MARGIN_BOTTOM, K_MARGIN_LEFT};
    opt.onGetItemMainSizeByIndex = [](int32_t idx) { return MainSizeByIndex(idx); };

    g_section->SetSection(g_section->GetSectionOptions(), 0, opt);
    g_node->SetSection(g_section);
}

static inline void SetupNodeAndAdapter()
{
    g_node = std::make_shared<ArkUIWaterFlowNode>();
    g_node->SetHeight(K_WATER_FLOW_H);
    g_node->SetWidth(K_WATER_FLOW_W);

    g_adapter = std::make_shared<FlowItemAdapter>();
    g_adapter->SetCallbacks(MakeCallbacks());
    g_node->SetLazyAdapter(g_adapter);
}

static inline void InitData()
{
    g_items.clear();
    g_items.reserve(K_INIT_RESERVE_ITEMS);
    for (int i = 0; i < K_INIT_SEED_ITEMS; ++i) {
        g_items.emplace_back("FlowItem " + std::to_string(i));
    }
}

static std::shared_ptr<ArkUIWaterFlowNode> Build()
{
    InitData();
    SetupNodeAndAdapter();
    SetupSection();
    return g_node;
}

// ===== NAPI 入口 =====
napi_value WaterFlowInfiniteScrollingEarlyImpl::NAPI(napi_env env, napi_callback_info info)
{
    ArkUI_NodeContentHandle content = GetContentFromArg(env, info);
    if (!content) {
        return nullptr;
    }
    std::shared_ptr<ArkUIWaterFlowNode> node = Build();
    AddNodeToContent(content, node->GetWaterFlow());
    KeepAliveVec<ArkUIWaterFlowNode>().emplace_back(node);
    return nullptr;
}

} // namespace ScrollableNDK::Examples
