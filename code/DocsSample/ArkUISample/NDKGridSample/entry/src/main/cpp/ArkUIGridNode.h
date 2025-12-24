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

// [Start grid_define]
#ifndef MYAPPLICATION_ARKUIGRIDNODE_H
#define MYAPPLICATION_ARKUIGRIDNODE_H

#include "ArkUINode.h"
#include "ArkUINodeAdapter.h"

namespace NativeModule {
class ArkUIGridNode : public ArkUINode {
public:
    ArkUIGridNode() : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_GRID))
    {
    }

    ~ArkUIGridNode() override {}

    void SetColumnsTemplate(const std::string &str)
    {
        ArkUI_AttributeItem item = {.string = str.c_str()};
        nativeModule_->setAttribute(handle_, NODE_GRID_COLUMN_TEMPLATE, &item);
    }

    void SetRowsTemplate(const std::string &str)
    {
        ArkUI_AttributeItem item = {.string = str.c_str()};
        nativeModule_->setAttribute(handle_, NODE_GRID_ROW_TEMPLATE, &item);
    }

    void SetColumnsGap(float val)
    {
        ArkUI_NumberValue value[] = {{.f32 = val}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_GRID_COLUMN_GAP, &item);
    }

    void SetRowsGap(float val)
    {
        ArkUI_NumberValue value[] = {{.f32 = val}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_GRID_ROW_GAP, &item);
    }

    void SetLayoutOptions(ArkUI_GridLayoutOptions *option)
    {
        if (option == nullptr) {
            return;
        }
        ArkUI_AttributeItem item = {.object = option};
        nativeModule_->setAttribute(handle_, NODE_GRID_LAYOUT_OPTIONS, &item);
    }

    void SetScrollBar(int32_t barState)
    {
        ArkUI_NumberValue value[] = {{.i32 = barState}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_SCROLL_BAR_DISPLAY_MODE, &item);
    }

    void SetLazyAdapter(const std::shared_ptr<ArkUINodeAdapter> &adapter)
    {
        if (!IsNotNull(adapter)) {
            return;
        }
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        nativeModule_->setAttribute(handle_, NODE_GRID_NODE_ADAPTER, &item);
        _adapter = adapter;
    }

    void ReleaseAdapter() { return _adapter.reset(); }

private:
    std::shared_ptr<ArkUINodeAdapter> _adapter;
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIGRIDNODE_H

// [End grid_define]
