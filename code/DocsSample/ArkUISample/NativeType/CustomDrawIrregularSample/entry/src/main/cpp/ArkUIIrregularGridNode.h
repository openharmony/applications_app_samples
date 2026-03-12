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
// [Start irregular-grid]
// ArkUIIrregularGridNode.h
// 不规则网格布局容器示例

#ifndef MYAPPLICATION_ARKUIIRREGULARGRIDNODE_H
#define MYAPPLICATION_ARKUIIRREGULARGRIDNODE_H

#include "ArkUINode.h"
#include <vector>
#include <map>

namespace NativeModule {

// 网格单元配置
struct GridItemConfig {
    int32_t rowSpan = 1;    // 占据的行数
    int32_t columnSpan = 1; // 占据的列数
};

class ArkUIIrregularGridNode : public ArkUINode {
public:
    // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件
    ArkUIIrregularGridNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_CUSTOM))
    {
        // 注册自定义事件监听器
        nativeModule_->addNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 声明自定义事件并传递自身作为自定义数据
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE, 0, this);
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT, 0, this);
    }

    ~ArkUIIrregularGridNode() override
    {
        // 反注册自定义事件监听器
        nativeModule_->removeNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 取消声明自定义事件。
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE);
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT);
    }

    // 设置列数
    void SetColumnCount(int32_t count)
    {
        columnCount_ = count;
        nativeModule_->markDirty(handle_, NODE_NEED_MEASURE);
    }

    // 设置网格间距
    void SetGap(int32_t gap)
    {
        gap_ = gap;
        nativeModule_->markDirty(handle_, NODE_NEED_MEASURE);
    }

    // 设置子组件的网格配置
    void SetItemConfig(ArkUI_NodeHandle child, int32_t rowSpan, int32_t columnSpan)
    {
        GridItemConfig config;
        config.rowSpan = rowSpan;
        config.columnSpan = columnSpan;
        itemConfigs_[child] = config;
        nativeModule_->markDirty(handle_, NODE_NEED_MEASURE);
    }

private:
    static void OnStaticCustomEvent(ArkUI_NodeCustomEvent *event)
    {
        // 获取组件实例对象，调用相关实例方法。
        auto customNode = reinterpret_cast<ArkUIIrregularGridNode *>(OH_ArkUI_NodeCustomEvent_GetUserData(event));
        auto type = OH_ArkUI_NodeCustomEvent_GetEventType(event);
        switch (type) {
            case ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE:
                customNode->OnMeasure(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT:
                customNode->OnLayout(event);
                break;
            default:
                break;
        }
    }

    // 测算单个子组件并更新列高信息
    void MeasureChild(ArkUI_NodeHandle child, int32_t cellWidth,
        ArkUI_LayoutConstraint *childConstraint, std::vector<int32_t> &columnHeights)
    {
        GridItemConfig config = {1, 1};
        auto it = itemConfigs_.find(child);
        if (it != itemConfigs_.end()) {
            config = it->second;
        }
        if (config.columnSpan > columnCount_) {
            config.columnSpan = columnCount_;
        }

        int32_t startColumn = FindLowestColumn(columnHeights, config.columnSpan);
        int32_t startY = 0;
        for (int32_t col = startColumn; col < startColumn + config.columnSpan && col < columnCount_; col++) {
            if (columnHeights[col] > startY) {
                startY = columnHeights[col];
            }
        }

        int32_t itemWidth = cellWidth * config.columnSpan + gap_ * (config.columnSpan - 1);
        OH_ArkUI_LayoutConstraint_SetMaxWidth(childConstraint, itemWidth);
        OH_ArkUI_LayoutConstraint_SetMinWidth(childConstraint, itemWidth);
        nativeModule_->measureNode(child, childConstraint);
        auto size = nativeModule_->getMeasuredSize(child);

        LayoutItemInfo info;
        info.x = startColumn * (cellWidth + gap_);
        info.y = startY;
        info.width = size.width;
        info.height = size.height;
        layoutInfo_.push_back(info);

        int32_t newHeight = startY + size.height + gap_;
        for (int32_t col = startColumn; col < startColumn + config.columnSpan && col < columnCount_; col++) {
            columnHeights[col] = newHeight;
        }
    }

    // 自定义测算逻辑：不规则网格布局
    void OnMeasure(ArkUI_NodeCustomEvent *event)
    {
        auto layoutConstrain = OH_ArkUI_NodeCustomEvent_GetLayoutConstraintInMeasure(event);
        int32_t maxWidth = OH_ArkUI_LayoutConstraint_GetMaxWidth(layoutConstrain);

        int32_t totalGap = gap_ * (columnCount_ - 1);
        int32_t cellWidth = (maxWidth - totalGap) / columnCount_;

        auto childConstraint = OH_ArkUI_LayoutConstraint_Copy(layoutConstrain);
        std::vector<int32_t> columnHeights(columnCount_, 0);
        layoutInfo_.clear();

        auto totalSize = nativeModule_->getTotalChildCount(handle_);
        for (uint32_t i = 0; i < totalSize; i++) {
            auto child = nativeModule_->getChildAt(handle_, i);
            MeasureChild(child, cellWidth, childConstraint, columnHeights);
        }

        int32_t maxHeight = 0;
        for (int32_t height : columnHeights) {
            if (height > maxHeight) {
                maxHeight = height;
            }
        }
        if (maxHeight > gap_) {
            maxHeight -= gap_;
        }

        nativeModule_->setMeasuredSize(handle_, maxWidth, maxHeight);
        OH_ArkUI_LayoutConstraint_Dispose(childConstraint);
    }

    void OnLayout(ArkUI_NodeCustomEvent *event)
    {
        // 获取父组件期望位置并设置
        auto position = OH_ArkUI_NodeCustomEvent_GetPositionInLayout(event);
        nativeModule_->setLayoutPosition(handle_, position.x, position.y);

        // 布局子组件
        auto totalSize = nativeModule_->getTotalChildCount(handle_);
        for (uint32_t i = 0; i < totalSize && i < layoutInfo_.size(); i++) {
            auto child = nativeModule_->getChildAt(handle_, i);
            nativeModule_->layoutNode(child, layoutInfo_[i].x, layoutInfo_[i].y);
        }
    }

    // 找到最矮的列，确保可以放下指定列跨度的项
    int32_t FindLowestColumn(const std::vector<int32_t>& columnHeights, int32_t columnSpan)
    {
        int32_t lowestColumn = 0;
        int32_t lowestHeight = INT32_MAX;

        // 遍历所有可能的起始列
        for (int32_t col = 0; col <= columnCount_ - columnSpan; col++) {
            // 找到这个范围内最高的列
            int32_t maxHeightInRange = 0;
            for (int32_t i = col; i < col + columnSpan; i++) {
                if (columnHeights[i] > maxHeightInRange) {
                    maxHeightInRange = columnHeights[i];
                }
            }

            // 如果这个范围的最高点比当前最低点还低，更新最低列
            if (maxHeightInRange < lowestHeight) {
                lowestHeight = maxHeightInRange;
                lowestColumn = col;
            }
        }

        return lowestColumn;
    }

    struct LayoutItemInfo {
        int32_t x;
        int32_t y;
        int32_t width;
        int32_t height;
    };

    int32_t columnCount_ = 3;
    int32_t gap_ = 10;
    std::map<ArkUI_NodeHandle, GridItemConfig> itemConfigs_;
    std::vector<LayoutItemInfo> layoutInfo_;
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIIRREGULARGRIDNODE_H
// [End irregular-grid]
