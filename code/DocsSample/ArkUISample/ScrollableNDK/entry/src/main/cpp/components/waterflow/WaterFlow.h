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

#ifndef MYAPPLICATION_WATERFLOW_H
#define MYAPPLICATION_WATERFLOW_H

#include "components/waterflow/FlowItemAdapter.h"
#include "components/waterflow/WaterFlowSection.h"

namespace ScrollableNDK {

class ArkUIWaterFlowNode {
public:
    ArkUIWaterFlowNode()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeApi_);
        waterFlow_ = nodeApi_->createNode(ARKUI_NODE_WATER_FLOW);
    }

    ~ArkUIWaterFlowNode()
    {
        // 不主动销毁 UI 树上的节点
        adapter_.reset();
        section_.reset();
        waterFlow_ = nullptr;
    }

    void SetWidth(float width)
    {
        ArkUI_NumberValue v{};
        v.f32 = width;
        ArkUI_AttributeItem item{&v, 1};
        nodeApi_->setAttribute(waterFlow_, NODE_WIDTH, &item);
    }

    void SetHeight(float height)
    {
        ArkUI_NumberValue v{};
        v.f32 = height;
        ArkUI_AttributeItem item{&v, 1};
        nodeApi_->setAttribute(waterFlow_, NODE_HEIGHT, &item);
    }

    void SetLazyAdapter(const std::shared_ptr<FlowItemAdapter> &adapter)
    {
        if (!adapter) {
            return;
        }
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        nodeApi_->setAttribute(waterFlow_, NODE_WATER_FLOW_NODE_ADAPTER, &item);
        adapter_ = adapter;
    }

    void SetSection(const std::shared_ptr<WaterFlowSection> &section)
    {
        if (!section) {
            return;
        }
        auto *opts = section->GetSectionOptions();
        if (!opts) {
            return;
        }

        ArkUI_NumberValue start[] = {{.i32 = 0}};
        ArkUI_AttributeItem optionsItem{start, 1, nullptr, opts};
        nodeApi_->setAttribute(waterFlow_, NODE_WATER_FLOW_SECTION_OPTION, &optionsItem);
        section_ = section;
    }

    ArkUI_NodeHandle GetWaterFlow() { return waterFlow_; }
    std::shared_ptr<WaterFlowSection> GetWaterFlowSection() { return section_; }

private:
    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
    ArkUI_NodeHandle waterFlow_ = nullptr;
    std::shared_ptr<WaterFlowSection> section_ = nullptr;
    std::shared_ptr<FlowItemAdapter> adapter_;
};

} // namespace ScrollableNDK

#endif // MYAPPLICATION_WATERFLOW_H
