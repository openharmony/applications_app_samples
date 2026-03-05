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

// [Start irregular-grid-entrance]
#include "NativeEntry.h"

#include "ArkUIIrregularGridNode.h"
#include "ArkUINode.h"

#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <js_native_api.h>
#include <utility>
#include <vector>

namespace NativeModule {
namespace {
napi_env g_env = nullptr;

constexpr uint32_t GRID_BACKGROUND_COLOR = 0xFFF5F5F5;
constexpr int32_t GRID_COLUMN_COUNT = 4;
constexpr int32_t GRID_GAP = 8;
constexpr float GRID_ITEM_RADIUS = 8.0f;
constexpr float GRID_ITEM_BORDER_WIDTH = 1.0f;
constexpr uint32_t GRID_ITEM_BORDER_COLOR = 0xFFCCCCCC;
constexpr float GRID_ITEM_BASE_HEIGHT = 60.0f;
constexpr float GRID_ITEM_HEIGHT_STEP = 40.0f;

using GridItemSize = std::pair<int32_t, int32_t>;

const std::vector<GridItemSize>& GetGridItemSizes()
{
    static const std::vector<GridItemSize> itemSizes = {
        {1, 1}, // 小方块
        {2, 1}, // 竖长条
        {1, 3}, // 横长条
        {2, 2}, // 大方块
        {1, 1}, // 小方块
        {1, 2}, // 横条
        {3, 1}, // 很长的竖条
    };
    return itemSizes;
}

const std::vector<uint32_t>& GetGridItemColors()
{
    static const std::vector<uint32_t> colors = {
        0xFF64B5F6, // 蓝色
        0xFFE57373, // 红色
        0xFF81C784, // 绿色
        0xFFFFB74D, // 橙色
        0xFF9575CD, // 紫色
        0xFF4DB6AC, // 青色
        0xFFFFD54F, // 黄色
        0xFFF06292, // 粉色
        0xFF7986CB, // 靛蓝
        0xFFA1887F, // 棕色
    };
    return colors;
}

void SetNodeColorAttribute(ArkUI_NativeNodeAPI_1* nodeAPI, ArkUI_NodeHandle node, uint32_t color)
{
    ArkUI_NumberValue bgColor[] = {{.u32 = color}};
    ArkUI_AttributeItem bgColorItem = {bgColor, 1};
    nodeAPI->setAttribute(node, NODE_BACKGROUND_COLOR, &bgColorItem);
}

void SetNodeBorderRadiusAttribute(ArkUI_NativeNodeAPI_1* nodeAPI, ArkUI_NodeHandle node, float radius)
{
    ArkUI_NumberValue radiusValue[] = {{.f32 = radius}};
    ArkUI_AttributeItem radiusItem = {radiusValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_RADIUS, &radiusItem);
}

void SetNodeBorderStyle(ArkUI_NativeNodeAPI_1* nodeAPI, ArkUI_NodeHandle node)
{
    ArkUI_NumberValue borderWidth[] = {{.f32 = GRID_ITEM_BORDER_WIDTH}};
    ArkUI_AttributeItem borderWidthItem = {borderWidth, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_WIDTH, &borderWidthItem);

    ArkUI_NumberValue borderColor[] = {{.u32 = GRID_ITEM_BORDER_COLOR}};
    ArkUI_AttributeItem borderColorItem = {borderColor, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_COLOR, &borderColorItem);
}

void SetNodeHeightByRowSpan(ArkUI_NativeNodeAPI_1* nodeAPI, ArkUI_NodeHandle node, int32_t rowSpan)
{
    float minHeight = GRID_ITEM_BASE_HEIGHT + (rowSpan - 1) * GRID_ITEM_HEIGHT_STEP;
    ArkUI_NumberValue minHeightValue[] = {{.f32 = minHeight}};
    ArkUI_AttributeItem minHeightItem = {minHeightValue, 1};
    nodeAPI->setAttribute(node, NODE_HEIGHT, &minHeightItem);
}

void AddGridItems(
    ArkUI_NativeNodeAPI_1* nodeAPI,
    const std::shared_ptr<ArkUIIrregularGridNode>& gridNode,
    const std::vector<GridItemSize>& itemSizes,
    const std::vector<uint32_t>& colors)
{
    for (size_t i = 0; i < itemSizes.size(); ++i) {
        auto itemNode = nodeAPI->createNode(ARKUI_NODE_STACK);
        SetNodeColorAttribute(nodeAPI, itemNode, colors[i % colors.size()]);
        SetNodeBorderRadiusAttribute(nodeAPI, itemNode, GRID_ITEM_RADIUS);
        SetNodeBorderStyle(nodeAPI, itemNode);
        SetNodeHeightByRowSpan(nodeAPI, itemNode, itemSizes[i].first);
        gridNode->SetItemConfig(itemNode, itemSizes[i].first, itemSizes[i].second);
        nodeAPI->addChild(gridNode->GetHandle(), itemNode);
    }
}
} // namespace

napi_value CreateNativeRoot(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    auto gridNode = std::make_shared<ArkUIIrregularGridNode>();
    gridNode->SetBackgroundColor(GRID_BACKGROUND_COLOR);
    gridNode->SetColumnCount(GRID_COLUMN_COUNT);
    gridNode->SetGap(GRID_GAP);

    auto* nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
    AddGridItems(nodeAPI, gridNode, GetGridItemSizes(), GetGridItemColors());

    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(gridNode);
    g_env = env;
    return nullptr;
}

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
{
    // 从管理类中释放Native侧对象。
    NativeEntry::GetInstance()->DisposeRootNode();
    return nullptr;
}

} // namespace NativeModule
// [End irregular-grid-entrance]
