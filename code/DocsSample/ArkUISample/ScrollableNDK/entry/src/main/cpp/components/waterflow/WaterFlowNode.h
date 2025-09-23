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

#ifndef SCROLLABLENDK_WATERFLOW_NODE_H
#define SCROLLABLENDK_WATERFLOW_NODE_H

#include <memory>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <hilog/log.h>

#include "common/ArkUINodeAdapter.h"
#include "components/waterflow/WaterFlowSection.h"
#include "common/ArkUINode.h"
#include "common/ArkUIConstants.h"
#include "common/ArkUIUtils.h"
#include "common/ArkUIScrollEvent.h"

#ifndef LOG_TAG
#define LOG_TAG "WaterFlowNode"
#endif

namespace ScrollableNDK {

class ArkUIWaterFlowNode {
public:
    ArkUIWaterFlowNode()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        waterFlow_ = api_->createNode(ARKUI_NODE_WATER_FLOW);
        api_->addNodeEventReceiver(waterFlow_, StaticEvent);

        scrollGuard_.Bind(api_, waterFlow_, this, SCROLL_EVT_ALL);

        OH_LOG_Print(LOG_APP, LOG_INFO, Constants::K_LOG_DOMAIN, LOG_TAG, "WaterFlowNode created");
    }

    ~ArkUIWaterFlowNode()
    {
        scrollGuard_.Release();

        adapter_.reset();
        section_.reset();
        waterFlow_ = nullptr;
    }

    // ---- Size ----
    void SetWidth(float width) { Utils::SetAttributeFloat32(api_, waterFlow_, NODE_WIDTH, width); }
    void SetHeight(float height) { Utils::SetAttributeFloat32(api_, waterFlow_, NODE_HEIGHT, height); }

    // ---- Adapter ----
    void SetLazyAdapter(const std::shared_ptr<ArkUINodeAdapter> &adapter)
    {
        if (adapter == nullptr) {
            return;
        }
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_NODE_ADAPTER, &item);
        adapter_ = adapter;
    }

    // ---- Section ----
    void SetSection(const std::shared_ptr<WaterFlowSection> &section)
    {
        if (section == nullptr) {
            return;
        }
        auto *opts = section->GetSectionOptions();
        if (opts == nullptr) {
            return;
        }
        ArkUI_NumberValue start[] = {{.i32 = 0}};
        ArkUI_AttributeItem item{start, 1, nullptr, opts};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_SECTION_OPTION, &item);
        section_ = section;
    }

    // ---- Layout / template / gap ----
    void SetLayoutDirection(int32_t direction)
    {
        ArkUI_NumberValue v[] = {{.i32 = direction}};
        ArkUI_AttributeItem item{v, 1};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_LAYOUT_DIRECTION, &item);
    }

    void SetColumnTemplate(const char *tpl)
    {
        ArkUI_AttributeItem item{nullptr, 0, tpl, nullptr};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_COLUMN_TEMPLATE, &item);
    }
    void SetRowTemplate(const char *tpl)
    {
        ArkUI_AttributeItem item{nullptr, 0, tpl, nullptr};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_ROW_TEMPLATE, &item);
    }

    void SetGaps(float colGap, float rowGap)
    {
        Utils::SetAttributeFloat32(api_, waterFlow_, NODE_WATER_FLOW_COLUMN_GAP, colGap);
        Utils::SetAttributeFloat32(api_, waterFlow_, NODE_WATER_FLOW_ROW_GAP, rowGap);
    }

    // ---- Cache / scroll / mode ----
    void SetCachedCount(int32_t count)
    {
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_WATER_FLOW_CACHED_COUNT, count);
    }

    void SetFooter(ArkUI_NodeHandle footer)
    {
        ArkUI_AttributeItem item{nullptr, 0, nullptr, footer};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_FOOTER, &item);
    }

    void ScrollToIndex(int32_t index, int32_t align)
    {
        ArkUI_NumberValue v[] = {{.i32 = index}, {.i32 = align}};
        ArkUI_AttributeItem item{v, 2};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_SCROLL_TO_INDEX, &item);
    }

    void SetItemConstraintSize(float mainMin, float mainMax)
    {
        ArkUI_NumberValue v[] = {{.f32 = mainMin}, {.f32 = mainMax}};
        ArkUI_AttributeItem item{v, 2};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_ITEM_CONSTRAINT_SIZE, &item);
    }

    void SetLayoutMode(int32_t mode) { Utils::SetAttributeInt32(api_, waterFlow_, NODE_WATER_FLOW_LAYOUT_MODE, mode); }
    void SetSyncLoad(bool enabled)
    {
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_WATER_FLOW_SYNC_LOAD, enabled ? 1 : 0);
    }

    void SetScrollCommon()
    {
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_SCROLL_BAR_DISPLAY_MODE,
                                 static_cast<int>(ARKUI_SCROLL_BAR_DISPLAY_MODE_AUTO));
        Utils::SetAttributeFloat32(api_, waterFlow_, NODE_SCROLL_BAR_WIDTH, Constants::K_DEFAULT_SCROLL_BAR_WIDTH);
        Utils::SetAttributeUInt32(api_, waterFlow_, NODE_SCROLL_BAR_COLOR, Constants::K_DEFAULT_SCROLL_BAR_COLOR);
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_SCROLL_EDGE_EFFECT, static_cast<int>(ARKUI_EDGE_EFFECT_SPRING));
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_SCROLL_ENABLE_SCROLL_INTERACTION, 1);
        Utils::SetAttributeFloat32(api_, waterFlow_, NODE_SCROLL_FRICTION, Constants::K_DEFAULT_SCROLL_FRICTION);
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_SCROLL_NESTED_SCROLL,
                                 static_cast<int>(ARKUI_SCROLL_NESTED_MODE_SELF_FIRST));
        Utils::SetAttributeInt32(api_, waterFlow_, NODE_SCROLL_FADING_EDGE, Constants::K_DEFAULT_FADING_EDGE);
    }

    ArkUI_NodeHandle GetWaterFlow() const { return waterFlow_; }
    std::shared_ptr<WaterFlowSection> GetWaterFlowSection() const { return section_; }

    void SetSingleSection(int32_t itemCount, int32_t crossCount, float colGap, float rowGap, ArkUI_Margin margin,
                          float (*getMainSizeByIndex)(int32_t), void *userData = nullptr,
                          float (*getMainSizeByIndexWithUserData)(int32_t, void *) = nullptr)
    {
        if (section_ == nullptr) {
            section_ = std::make_shared<WaterFlowSection>();
        }
        section_->Resize(1);

        SectionOption opt{};
        opt.itemsCount = itemCount;
        opt.crossCount = crossCount;
        opt.columnsGap = colGap;
        opt.rowsGap = rowGap;
        opt.margin = margin;
        opt.onGetItemMainSizeByIndex = getMainSizeByIndex;
        opt.userData = userData;

        section_->SetSection(section_->GetSectionOptions(), 0, opt);

        if (userData != nullptr && getMainSizeByIndexWithUserData != nullptr) {
            OH_ArkUI_WaterFlowSectionOption_RegisterGetItemMainSizeCallbackByIndexWithUserData(
                section_->GetSectionOptions(), 0, userData, getMainSizeByIndexWithUserData);
        }

        SetSection(section_);
    }

private:
    static void StaticEvent(ArkUI_NodeEvent *ev) { (void)ev; }

private:
    ArkUI_NativeNodeAPI_1 *api_ = nullptr;
    ArkUI_NodeHandle waterFlow_ = nullptr;
    std::shared_ptr<WaterFlowSection> section_ = nullptr;
    std::shared_ptr<ArkUINodeAdapter> adapter_;

    ScrollEventGuard scrollGuard_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_WATERFLOW_NODE_H
