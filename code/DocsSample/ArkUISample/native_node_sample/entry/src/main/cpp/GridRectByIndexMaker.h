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

#ifndef SCROLLABLENDK_GRID_RECT_BY_INDEX_NODE_H
#define SCROLLABLENDK_GRID_RECT_BY_INDEX_NODE_H

#include <arkui/native_node.h>

#include "ArkUINodeAdapter.h"
#include "GridLayoutOptions.h"
#include "ScrollableEvent.h"
#include "ScrollableNode.h"
#include "ScrollableUtils.h"

class GridRectByIndexMaker : public BaseNode {
public:
    static ArkUI_NodeHandle CreateNativeNode();

    GridRectByIndexMaker()
        : BaseNode(NodeApiInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_GRID)),
          nodeApi_(NodeApiInstance::GetInstance()->GetNativeNodeAPI())
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }

        nodeApi_->addNodeEventReceiver(GetHandle(), StaticEventReceiver);
        scrollEventGuard_.Bind(nodeApi_, GetHandle(), this, SCROLL_EVT_ALL);
        layoutOptions_ = std::make_shared<GridLayoutOptions>();
    }

    ~GridRectByIndexMaker() override
    {
        scrollEventGuard_.Release();
        nodeAdapter_.reset();
        layoutOptions_ = nullptr;
    }

    // ========================================
    // 模板和间距设置
    // ========================================
    void SetRowsTemplate(const char* rowsTemplate)
    {
        SetAttributeString(nodeApi_, GetHandle(), NODE_GRID_ROW_TEMPLATE, rowsTemplate);
    }

    void SetColumnsTemplate(const char* columnsTemplate)
    {
        SetAttributeString(nodeApi_, GetHandle(), NODE_GRID_COLUMN_TEMPLATE, columnsTemplate);
    }

    void SetColumnsGap(float gap)
    {
        SetAttributeFloat32(nodeApi_, GetHandle(), NODE_GRID_COLUMN_GAP, gap);
    }

    void SetRowsGap(float gap)
    {
        SetAttributeFloat32(nodeApi_, GetHandle(), NODE_GRID_ROW_GAP, gap);
    }

    // ========================================
    // 适配器设置
    // ========================================
    void SetLazyAdapter(const std::shared_ptr<ArkUINodeAdapter>& adapter)
    {
        if (!IsNotNull(adapter)) {
            return;
        }
        ArkUI_AttributeItem item { nullptr, 0, nullptr, adapter->GetAdapter() };
        nodeApi_->setAttribute(GetHandle(), NODE_GRID_NODE_ADAPTER, &item);
        nodeAdapter_ = adapter;
    }

    // ========================================
    // 设置属性
    // ========================================
    void SetLayoutOptions(ArkUI_GridLayoutOptions* layoutOptions)
    {
        if (layoutOptions == nullptr) {
            return;
        }

        ArkUI_AttributeItem item = { .object = layoutOptions };
        nodeApi_->setAttribute(GetHandle(), NODE_GRID_LAYOUT_OPTIONS, &item);
    }

protected:
    void OnNodeEvent(ArkUI_NodeEvent* event) override
    {
        BaseNode::OnNodeEvent(event);
    }

private:
    static std::shared_ptr<GridRectByIndexMaker> BuildGridRectByIndex();
    ArkUI_NativeNodeAPI_1* nodeApi_ = nullptr;
    std::shared_ptr<ArkUINodeAdapter> nodeAdapter_;
    ScrollEventGuard scrollEventGuard_;
    static std::shared_ptr<GridLayoutOptions> layoutOptions_;
};

#endif // SCROLLABLENDK_GRID_RECT_BY_INDEX_NODE_H
