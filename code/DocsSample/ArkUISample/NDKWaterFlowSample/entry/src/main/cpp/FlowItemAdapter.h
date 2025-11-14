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
// [Start flow_item_adapter]
// FlowItemAdapter.h
// 懒加载功能代码。

#ifndef MYAPPLICATION_FLOWITEMADAPTER_H
#define MYAPPLICATION_FLOWITEMADAPTER_H

#include <arkui/native_node.h>
#include <stack>
#include <string>
#include <unordered_set>
#include <arkui/native_interface.h>

namespace NativeModule {
const int NUM = 100;
class FlowItemAdapter {
public:
    FlowItemAdapter()
    {
        // 初始化函数指针结构体
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeApi_);
        // 创建Adapter对象
        adapter_ = OH_ArkUI_NodeAdapter_Create();
        
        // 初始化懒加载数据。
        for (int32_t i = 0; i < NUM; i++) {
            data_.emplace_back(std::to_string(i));
        }
        // 设置懒加载数据。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter_, data_.size());
        // 设置事件监听器。
        OH_ArkUI_NodeAdapter_RegisterEventReceiver(adapter_, this, OnStaticAdapterEvent);
    }

    ~FlowItemAdapter()
    {
        // 释放创建的组件。
        while (!cachedItems_.empty()) {
            cachedItems_.pop();
        }
        // 释放Adapter相关资源。
        OH_ArkUI_NodeAdapter_UnregisterEventReceiver(adapter_);
        OH_ArkUI_NodeAdapter_Dispose(adapter_);
    }

    ArkUI_NodeAdapterHandle GetAdapter() const { return adapter_; }

    void RemoveItem(int32_t index)
    {
        // 删除第index个数据。
        data_.erase(data_.begin() + index);
        // 如果index会导致可视区域元素发生可见性变化，则会回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER事件删除元素，
        // 根据是否有新增元素回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件。
        OH_ArkUI_NodeAdapter_RemoveItem(adapter_, index, 1);
        // 更新新的数量。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter_, data_.size());
    }

    void InsertItem(int32_t index, const std::string &value)
    {
        data_.insert(data_.begin() + index, value);
        // 如果index会导致可视区域元素发生可见性变化，则会回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件，
        // 根据是否有删除元素回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER事件。
        OH_ArkUI_NodeAdapter_InsertItem(adapter_, index, 1);
        // 更新新的数量。
        OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter_, data_.size());
    }

    void MoveItem(int32_t oldIndex, int32_t newIndex)
    {
        auto temp = data_[oldIndex];
        data_.insert(data_.begin() + newIndex, temp);
        data_.erase(data_.begin() + oldIndex);
        // 移到位置如果未发生可视区域内元素的可见性变化，则不回调事件，反之根据新增和删除场景回调对应的事件。
        OH_ArkUI_NodeAdapter_MoveItem(adapter_, oldIndex, newIndex);
    }

    void ReloadItem(int32_t index, const std::string &value)
    {
        data_[index] = value;
        // 如果index位于可视区域内，先回调NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER删除老元素，
        // 再回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID和NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件。
        OH_ArkUI_NodeAdapter_ReloadItem(adapter_, index, 1);
    }

    void ReloadAllItem()
    {
        std::reverse(data_.begin(), data_.end());
        // 全部重新加载场景下，会回调NODE_ADAPTER_EVENT_ON_GET_NODE_ID接口获取新的组件ID，
        // 根据新的组件ID进行对比，ID不发生变化的进行复用，
        // 针对新增ID的元素，调用NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER事件创建新的组件，
        // 然后判断老数据中遗留的未使用ID，调用NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER删除老元素。
        OH_ArkUI_NodeAdapter_ReloadAllItems(adapter_);
    }

private:
    static void OnStaticAdapterEvent(ArkUI_NodeAdapterEvent *event)
    {
        // 获取实例对象，回调实例事件。
        auto itemAdapter = reinterpret_cast<FlowItemAdapter *>(OH_ArkUI_NodeAdapterEvent_GetUserData(event));
        itemAdapter->OnAdapterEvent(event);
    }

    void OnAdapterEvent(ArkUI_NodeAdapterEvent *event)
    {
        auto type = OH_ArkUI_NodeAdapterEvent_GetType(event);
        switch (type) {
            case NODE_ADAPTER_EVENT_ON_GET_NODE_ID:
                OnGetChildId(event);
                break;
            case NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER:
                OnCreateNewChild(event);
                break;
            case NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER:
                OnDisposeChild(event);
                break;
            default:
                break;
        }
    }
    
    void OnGetChildId(ArkUI_NodeAdapterEvent *event)
    {
        auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(event);
        // 设置生成组件的唯一标识符。
        auto hash = std::hash<std::string>();
        OH_ArkUI_NodeAdapterEvent_SetNodeId(event, hash(data_[index]));
    }
    
    void OnCreateNewChild(ArkUI_NodeAdapterEvent *event)
    {
        auto index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(event);
        ArkUI_NodeHandle flowItem = nullptr;
        if (!cachedItems_.empty()) {
            // 复用缓存
            flowItem = cachedItems_.top();
            cachedItems_.pop();
            // 更新数据
            auto *text = nodeApi_->getFirstChild(flowItem);
            ArkUI_AttributeItem item{nullptr, 0, data_[index].c_str()};
            nodeApi_->setAttribute(text, NODE_TEXT_CONTENT, &item);
        } else {
            // 重新创建。
            auto *text = nodeApi_->createNode(ARKUI_NODE_TEXT);
            ArkUI_AttributeItem item{nullptr, 0, data_[index].c_str()};
            nodeApi_->setAttribute(text, NODE_TEXT_CONTENT, &item);
            flowItem = nodeApi_->createNode(ARKUI_NODE_FLOW_ITEM);
            ArkUI_NumberValue value[] = {100};
            ArkUI_AttributeItem height{value, 1};
            nodeApi_->setAttribute(flowItem, NODE_HEIGHT, &height);
            value[0] = {1};
            ArkUI_AttributeItem width{value, 1};
            nodeApi_->setAttribute(flowItem, NODE_WIDTH_PERCENT, &width);
            value[0] = {.u32 = 0xFFD3D3D3};
            ArkUI_AttributeItem backgroundColor{value, 1};

            nodeApi_->setAttribute(flowItem, NODE_BACKGROUND_COLOR, &backgroundColor);
            nodeApi_->addChild(flowItem, text);
        }
        OH_ArkUI_NodeAdapterEvent_SetItem(event, flowItem);
    }
    
    void OnDisposeChild(ArkUI_NodeAdapterEvent *event)
    {
        auto *node = OH_ArkUI_NodeAdapterEvent_GetRemovedNode(event);
        // 缓存节点
        cachedItems_.emplace(node);
    }

    std::vector<std::string> data_;
    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
    ArkUI_NodeAdapterHandle adapter_ = nullptr;

    // 管理回收复用组件池。
    std::stack<ArkUI_NodeHandle> cachedItems_;
};

} // namespace NativeModule

#endif //MYAPPLICATION_FLOWITEMADAPTER_H
// [End flow_item_adapter]