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

#ifndef SCROLLABLENDK_GRID_NODE_H
#define SCROLLABLENDK_GRID_NODE_H

#include <memory>

#include <arkui/native_interface.h>
#include <arkui/native_node.h>

#include "components/grid/GridItemAdapter.h"

namespace ScrollableNDK {

/** ArkUI Grid 节点轻封装 */
class ArkUIGridNode {
public:
    ArkUIGridNode()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        grid_ = api_->createNode(ARKUI_NODE_GRID);
    }

    ~ArkUIGridNode()
    {
        grid_ = nullptr;
        adapter_.reset();
    }

    void SetWidth(float w)
    {
        ArkUI_NumberValue v{};
        v.f32 = w;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(grid_, NODE_WIDTH, &item);
    }

    void SetWidthPercent(float pct)
    {
        ArkUI_NumberValue v{};
        v.f32 = pct;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(grid_, NODE_WIDTH_PERCENT, &item);
    }

    void SetHeight(float h)
    {
        ArkUI_NumberValue v{};
        v.f32 = h;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(grid_, NODE_HEIGHT, &item);
    }

    /** 仅设 rowsTemplate：超出宽度时可水平滚动 */
    void SetRowsTemplate(const char *rows)
    {
        ArkUI_AttributeItem item{nullptr, 0, rows};
        api_->setAttribute(grid_, NODE_GRID_ROW_TEMPLATE, &item);
    }

    void SetColumnsGap(float gap)
    {
        ArkUI_NumberValue v{};
        v.f32 = gap;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(grid_, NODE_GRID_COLUMN_GAP, &item);
    }

    void SetRowsGap(float gap)
    {
        ArkUI_NumberValue v{};
        v.f32 = gap;
        ArkUI_AttributeItem item{&v, 1};
        api_->setAttribute(grid_, NODE_GRID_ROW_GAP, &item);
    }

    /** 绑定懒加载适配器（持有 shared_ptr 保证生命周期） */
    void SetLazyAdapter(const std::shared_ptr<GridItemAdapter> &adapter)
    {
        if (!adapter) {
            return;
        }
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        api_->setAttribute(grid_, NODE_GRID_NODE_ADAPTER, &item);
        adapter_ = adapter;
    }

    ArkUI_NodeHandle Get() const { return grid_; }

private:
    ArkUI_NativeNodeAPI_1 *api_ = nullptr;
    ArkUI_NodeHandle grid_ = nullptr;
    std::shared_ptr<GridItemAdapter> adapter_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_GRID_NODE_H
