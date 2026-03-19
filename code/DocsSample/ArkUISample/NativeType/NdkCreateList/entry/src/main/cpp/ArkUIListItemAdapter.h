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
// [Start Lazy_loading_of_text_list]
// [Start Item_adapter]
// [Start Remove_Item]
// ArkUIListItemAdapter.h
// [StartExclude Item_adapter]
// [StartExclude Remove_Item]
// 用于文本列表懒加载功能代码。

#ifndef MYAPPLICATION_ARKUILISTITEMADAPTER_H
#define MYAPPLICATION_ARKUILISTITEMADAPTER_H

#include <algorithm>
#include <arkui/native_node.h>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <memory>
#include <stack>
#include <string>
#include <unordered_map>
#include <vector>

#include "ArkUIListItemNode.h"
#include "ArkUITextNode.h"
#include "NativeModule.h"

namespace NativeModule {

class IArkUIListItemAdapter {
public:
    virtual ~IArkUIListItemAdapter() = default;
    virtual ArkUI_NodeAdapterHandle GetHandle() const = 0;
};
// [EndExclude Item_adapter]
// [EndExclude Remove_Item]
template <typename ItemType> class ArkUIListItemAdapterT : public IArkUIListItemAdapter {
    // [StartExclude Item_adapter]
    // [StartExclude Remove_Item]
public:
    // 创建列表项节点的回调类型。
    using CreateChildCallback = std::function<std::shared_ptr<ArkUIListItemNode>(const ItemType &item, int32_t index)>;
    // 复用列表项节点时更新内容的回调类型。
    using ReuseListItemCallback =
        std::function<void(const std::shared_ptr<ArkUIListItemNode> &listItem, const ItemType &item, int32_t index)>;
    // 生成节点唯一标识的回调类型。
    using NodeIdCallback = std::function<int64_t(const ItemType &item, int32_t index)>;

    // 创建NodeAdapter并初始化数据及各类回调。
    explicit ArkUIListItemAdapterT(std::vector<ItemType> data, CreateChildCallback createChildCallback,
                                   ReuseListItemCallback reuseListItemCallback, NodeIdCallback nodeIdCallback = nullptr)
        : handle_(OH_ArkUI_NodeAdapter_Create()), data_(std::move(data)),
          createChildCallback_(std::move(createChildCallback)),
          reuseListItemCallback_(std::move(reuseListItemCallback)), nodeIdCallback_(std::move(nodeIdCallback)) {
        // 设置懒加载数据。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(handle_, data_.size());
        // 设置懒加载回调事件。
        OH_ArkUI_NodeAdapter_RegisterEventReceiver(handle_, this, OnStaticAdapterEvent);
    }

    ~ArkUIListItemAdapterT() override
    {
        // 释放创建的组件。
        while (!cachedItems_.empty()) {
            cachedItems_.pop();
        }
        items_.clear();
        // 释放Adapter相关资源。
        OH_ArkUI_NodeAdapter_UnregisterEventReceiver(handle_);
        OH_ArkUI_NodeAdapter_Dispose(handle_);
    }

    ArkUI_NodeAdapterHandle GetHandle() const override { return handle_; }

    const std::vector<ItemType> &GetData() const { return data_; }

    void SetData(std::vector<ItemType> data)
    {
        data_ = std::move(data);
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(handle_, data_.size());
        OH_ArkUI_NodeAdapter_ReloadAllItems(handle_);
    }

    void SetNodeIdCallback(NodeIdCallback callback) { nodeIdCallback_ = std::move(callback); }

    // [EndExclude Remove_Item]
    void RemoveItem(size_t index)
    {
        // 删除第index个数据。
        if (index >= data_.size()) {
            return;
        }
        data_.erase(data_.begin() + static_cast<std::ptrdiff_t>(index));
        // 如果index会导致可视区域元素发生可见性变化，则会回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER事件删除元素，
        // 根据是否有新增元素回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件。
        OH_ArkUI_NodeAdapter_RemoveItem(handle_, index, 1);
        // 更新新的数量。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(handle_, data_.size());
    }

    // [StartExclude Remove_Item]
    void InsertItem(int32_t index, const ItemType &value)
    {
        int32_t safeIndex = std::max(0, std::min(index, static_cast<int32_t>(data_.size())));
        data_.insert(data_.begin() + safeIndex, value);
        // 如果index会导致可视区域元素发生可见性变化，则会回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件，
        // 根据是否有删除元素回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER事件。
        OH_ArkUI_NodeAdapter_InsertItem(handle_, safeIndex, 1);
        // 更新新的数量。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(handle_, data_.size());
    }

    void MoveItem(int32_t oldIndex, int32_t newIndex)
    {
        if (!IsValidIndex(oldIndex) || !IsValidIndex(newIndex) || oldIndex == newIndex) {
            return;
        }
        auto temp = data_[oldIndex];
        data_.insert(data_.begin() + newIndex, temp);
        int32_t removeIndex = oldIndex;
        if (newIndex < oldIndex) {
            removeIndex += 1;
        }
        data_.erase(data_.begin() + removeIndex);
        // 移到位置如果未发生可视区域内元素的可见性变化，则不回调事件，反之根据新增和删除场景回调对应的事件。
        OH_ArkUI_NodeAdapter_MoveItem(handle_, oldIndex, newIndex);
    }

    void ReloadItem(int32_t index, const ItemType &value)
    {
        if (!IsValidIndex(index)) {
            return;
        }
        data_[index] = value;
        // 如果index位于可视区域内，先回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER删除老元素，
        // 再回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件。
        OH_ArkUI_NodeAdapter_ReloadItem(handle_, index, 1);
    }

    void ReloadAllItem()
    {
        // 全部重新加载场景下，会回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID接口获取新的组件ID，
        // 根据新的组件ID进行对比，ID不发生变化的进行复用，
        // 针对新增ID的元素，调用NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件创建新的组件，
        // 然后判断老数据中遗留的未使用ID，调用NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER删除老元素。
        OH_ArkUI_NodeAdapter_ReloadAllItems(handle_);
    }

private:
    struct ItemEntry {
        std::shared_ptr<ArkUIListItemNode> listItem = nullptr;
    };

    static void OnStaticAdapterEvent(ArkUI_NodeAdapterEvent *event)
    {
        // 获取实例对象，回调实例事件。
        auto *itemAdapter = reinterpret_cast<ArkUIListItemAdapterT *>(OH_ArkUI_NodeAdapterEvent_GetUserData(event));
        if (itemAdapter != nullptr) {
            itemAdapter->OnAdapterEvent(event);
        }
    }

    void OnAdapterEvent(ArkUI_NodeAdapterEvent *event)
    {
        // 获取事件类型
        auto type = OH_ArkUI_NodeAdapterEvent_GetType(event);
        switch (type) {
            // Adapter需要添加新元素时获取新元素的唯一标识符
            case NODE_ADAPTER_EVENT_ON_GET_NODE_ID:
                OnNewItemIdCreated(event);
                break;
            // Adapter需要添加新元素时获取新元素的内容
            case NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER:
                OnNewItemAttached(event);
                break;
            // Adapter将元素移除
            case NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER:
                OnItemDetached(event);
                break;
            default:
                break;
        }
    }

    // 分配ID给需要显示的Item，用于ReloadAllItems场景的元素diff。
    void OnNewItemIdCreated(ArkUI_NodeAdapterEvent *event)
    {
        auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(event);
        if (!IsValidIndex(index)) {
            return;
        }
        int64_t id = nodeIdCallback_ ? nodeIdCallback_(data_[index], index) : static_cast<int64_t>(index);
        OH_ArkUI_NodeAdapterEvent_SetNodeId(event, id);
    }

    // [EndExclude Item_adapter]
    // 需要新的Item显示在可见区域。
    void OnNewItemAttached(ArkUI_NodeAdapterEvent *event)
    {
        auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(event);
        if (!IsValidIndex(index)) {
            return;
        }

        ItemEntry itemEntry;
        if (!cachedItems_.empty()) {
            // 使用并更新回收复用的缓存。
            itemEntry = cachedItems_.top();
            // 释放缓存池的引用。
            cachedItems_.pop();
            reuseListItemCallback_(itemEntry.listItem, data_[index], index);
        } else {
            // 创建新的元素。
            itemEntry.listItem = createChildCallback_(data_[index], index);
        }
        if (itemEntry.listItem == nullptr) {
            itemEntry.listItem = std::make_shared<ArkUIListItemNode>();
        }

        auto handle = itemEntry.listItem->GetHandle();
        items_[handle] = itemEntry;
        // 设置需要展示的元素。
        OH_ArkUI_NodeAdapterEvent_SetItem(event, handle);
    }
    // [StartExclude Item_adapter]
    // Item从可见区域移除。
    void OnItemDetached(ArkUI_NodeAdapterEvent *event)
    {
        auto item = OH_ArkUI_NodeAdapterEvent_GetRemovedNode(event);
        auto iter = items_.find(item);
        if (iter != items_.end()) {
            // 放置到缓存池中进行回收复用。
            cachedItems_.push(iter->second);
            items_.erase(iter);
        }
    }

    bool IsValidIndex(int32_t index) const { return index >= 0 && index < static_cast<int32_t>(data_.size()); }

    // NodeAdapter实例句柄。
    ArkUI_NodeAdapterHandle handle_ = nullptr;
    // 列表数据源。
    std::vector<ItemType> data_;
    // 创建列表项节点回调。
    CreateChildCallback createChildCallback_ = nullptr;
    // 复用列表项节点回调。
    ReuseListItemCallback reuseListItemCallback_ = nullptr;
    // 节点ID生成回调。
    NodeIdCallback nodeIdCallback_ = nullptr;
    // 管理NodeAdapter生成的元素。
    std::unordered_map<ArkUI_NodeHandle, ItemEntry> items_;

    // 管理回收复用组件池。
    std::stack<ItemEntry> cachedItems_;
    // [EndExclude Item_adapter]
    // [EndExclude Remove_Item]
};
// [End Item_adapter]
// [End Remove_Item]
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUILISTITEMADAPTER_H
// [End Lazy_loading_of_text_list]
