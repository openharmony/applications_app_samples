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

#ifndef SCROLLABLENDK_GRID_ITEM_ADAPTER_H
#define SCROLLABLENDK_GRID_ITEM_ADAPTER_H

#include <functional>
#include <stack>
#include <string>
#include <vector>

#include <arkui/native_interface.h>
#include <arkui/native_node.h>

namespace ScrollableNDK {

constexpr int K_DEFAULT_ITEM_COUNT = 10; // 默认占位条数

/** Grid 懒加载/复用回调 */
struct GridItemAdapterCallbacks {
    std::function<int32_t()> getTotalCount;                                         // 必填：总数
    std::function<uint64_t(int32_t)> getStableId;                                   // 可选：稳定复用ID
    std::function<ArkUI_NodeHandle(ArkUI_NativeNodeAPI_1 *, int32_t)> onCreate;     // 必填：创建节点
    std::function<void(ArkUI_NativeNodeAPI_1 *, ArkUI_NodeHandle, int32_t)> onBind; // 必填：绑定数据
    std::function<void(ArkUI_NativeNodeAPI_1 *, ArkUI_NodeHandle)> onRecycle;       // 可选：回收处理
};

/** ArkUI Grid 的 NodeAdapter 轻封装 */
class GridItemAdapter {
public:
    GridItemAdapter()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        adapter_ = OH_ArkUI_NodeAdapter_Create();
        OH_ArkUI_NodeAdapter_RegisterEventReceiver(adapter_, this, OnStaticEvent);

        data_.reserve(K_DEFAULT_ITEM_COUNT);
        for (int i = 0; i < K_DEFAULT_ITEM_COUNT; ++i) {
            data_.emplace_back(std::to_string(i));
        }
        SyncCountToArkUI();
    }

    ~GridItemAdapter()
    {
        while (!cache_.empty()) {
            cache_.pop();
        }
        OH_ArkUI_NodeAdapter_UnregisterEventReceiver(adapter_);
        OH_ArkUI_NodeAdapter_Dispose(adapter_);
        adapter_ = nullptr;
    }

    ArkUI_NodeAdapterHandle GetAdapter() const { return adapter_; }

    void SetCallbacks(const GridItemAdapterCallbacks &cb)
    {
        cb_ = cb;
        SyncCountToArkUI();
    }

    void SetData(std::vector<std::string> data)
    {
        data_ = std::move(data);
        SyncCountToArkUI();
        OH_ArkUI_NodeAdapter_ReloadAllItems(adapter_);
    }

    const std::vector<std::string> &GetData() const { return data_; }

private:
    int32_t Count() const
    {
        if (cb_.getTotalCount) {
            return cb_.getTotalCount();
        }
        return static_cast<int32_t>(data_.size());
    }

    void SyncCountToArkUI() { OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter_, static_cast<uint32_t>(Count())); }

    static void OnStaticEvent(ArkUI_NodeAdapterEvent *ev)
    {
        auto *self = reinterpret_cast<GridItemAdapter *>(OH_ArkUI_NodeAdapterEvent_GetUserData(ev));
        if (self) {
            self->OnEvent(ev);
        }
    }

    void OnEvent(ArkUI_NodeAdapterEvent *ev)
    {
        switch (OH_ArkUI_NodeAdapterEvent_GetType(ev)) {
            case NODE_ADAPTER_EVENT_ON_GET_NODE_ID: {
                int32_t index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(ev);
                uint64_t id = cb_.getStableId ? cb_.getStableId(index) : static_cast<uint64_t>(index);
                OH_ArkUI_NodeAdapterEvent_SetNodeId(ev, id);
                break;
            }
            case NODE_ADAPTER_EVENT_ON_ADD_NODE_TO_ADAPTER: {
                int32_t index = OH_ArkUI_NodeAdapterEvent_GetItemIndex(ev);
                ArkUI_NodeHandle item = nullptr;

                if (!cache_.empty()) {
                    item = cache_.top();
                    cache_.pop();
                    if (cb_.onBind) {
                        cb_.onBind(api_, item, index);
                    }
                } else {
                    if (cb_.onCreate) {
                        item = cb_.onCreate(api_, index);
                    }
                    if (!item) {
                        item = api_->createNode(ARKUI_NODE_GRID_ITEM);
                    }
                    if (cb_.onBind) {
                        cb_.onBind(api_, item, index);
                    }
                }
                OH_ArkUI_NodeAdapterEvent_SetItem(ev, item);
                break;
            }
            case NODE_ADAPTER_EVENT_ON_REMOVE_NODE_FROM_ADAPTER: {
                ArkUI_NodeHandle node = OH_ArkUI_NodeAdapterEvent_GetRemovedNode(ev);
                if (!node) {
                    break;
                }
                if (cb_.onRecycle) {
                    cb_.onRecycle(api_, node);
                }
                cache_.push(node);
                break;
            }
            default: {
                break;
            }
        }
    }

private:
    ArkUI_NativeNodeAPI_1 *api_ = nullptr;
    ArkUI_NodeAdapterHandle adapter_ = nullptr;
    GridItemAdapterCallbacks cb_{};
    std::vector<std::string> data_;
    std::stack<ArkUI_NodeHandle> cache_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_GRID_ITEM_ADAPTER_H
