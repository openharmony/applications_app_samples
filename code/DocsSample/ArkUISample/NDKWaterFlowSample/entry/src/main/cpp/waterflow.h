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
// [Start waterflow_define]
// waterflow.h
#ifndef MYAPPLICATION_WATERFLOW_H
#define MYAPPLICATION_WATERFLOW_H
  
#include "FlowItemAdapter.h"
#include "WaterflowSection.h"
#include "ArkUINode.h"
  
namespace NativeModule {
  
class ArkUIWaterflowNode : public ArkUINode {
public:
    ArkUIWaterflowNode()
        : ArkUINode(CreateWaterflowNode()) {}
  
    ~ArkUIWaterflowNode() override
    {
        // 先卸载 adapter
        if (adapter_ && nativeModule_) {
            nativeModule_->resetAttribute(handle_, NODE_WATER_FLOW_NODE_ADAPTER);
            adapter_.reset();
        }
        // 销毁分段
        section_.reset();
        // 基类会自动 dispose handle_
    }

    void SetLazyAdapter(const std::shared_ptr<FlowItemAdapter> &adapter)
    {
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        nativeModule_->setAttribute(handle_, NODE_WATER_FLOW_NODE_ADAPTER, &item);
        adapter_ = adapter;
    }
  
    void SetSection(const std::shared_ptr<WaterflowSection> &section)
    {
        if (!section->GetSectionOptions()) {
            return;
        }
        ArkUI_NumberValue start[] = {{.i32 = 0}};
        ArkUI_AttributeItem optionsItem = {start, 1, nullptr, section->GetSectionOptions()};
        nativeModule_->setAttribute(handle_, NODE_WATER_FLOW_SECTION_OPTION, &optionsItem);
        section_ = section;
    }
  
    std::shared_ptr<WaterflowSection> GetWaterflowSection() { return section_; }
  
private:
    static ArkUI_NodeHandle CreateWaterflowNode()
    {
        ArkUI_NativeNodeAPI_1* api = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
        if (!api) {
            return nullptr;
        }
        return api->createNode(ARKUI_NODE_WATER_FLOW);
    }
  
    std::shared_ptr<WaterflowSection> section_ = nullptr;
    std::shared_ptr<FlowItemAdapter> adapter_;
};
  
} // namespace NativeModule
  
#endif // MYAPPLICATION_WATERFLOW_H
// [End waterflow_define]