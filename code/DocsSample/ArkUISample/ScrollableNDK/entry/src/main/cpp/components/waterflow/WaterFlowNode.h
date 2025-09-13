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

#include "components/waterflow/FlowItemAdapter.h"
#include "components/waterflow/WaterFlowSection.h"

namespace ScrollableNDK {

/** ArkUI WaterFlow 节点轻封装 */
class ArkUIWaterFlowNode {
public:
    ArkUIWaterFlowNode()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        waterFlow_ = api_->createNode(ARKUI_NODE_WATER_FLOW);
    }

    ~ArkUIWaterFlowNode()
    {
        adapter_.reset();
        section_.reset();
        waterFlow_ = nullptr;
    }

    void SetWidth(float w)
    {
        ArkUI_NumberValue v{};
        v.f32 = w;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(waterFlow_, NODE_WIDTH, &item);
    }

    void SetHeight(float h)
    {
        ArkUI_NumberValue v{};
        v.f32 = h;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(waterFlow_, NODE_HEIGHT, &item);
    }

    void SetLazyAdapter(const std::shared_ptr<FlowItemAdapter> &adapter)
    {
        if (!adapter) {
            return;
        }
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_NODE_ADAPTER, &item);
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
        ArkUI_AttributeItem item{start, 1, nullptr, opts};
        api_->setAttribute(waterFlow_, NODE_WATER_FLOW_SECTION_OPTION, &item);
        section_ = section;
    }

    ArkUI_NodeHandle GetWaterFlow() const { return waterFlow_; }

private:
    ArkUI_NativeNodeAPI_1 *api_ = nullptr;
    ArkUI_NodeHandle waterFlow_ = nullptr;
    std::shared_ptr<WaterFlowSection> section_ = nullptr;
    std::shared_ptr<FlowItemAdapter> adapter_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_WATERFLOW_NODE_H
