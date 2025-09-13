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

#ifndef SCROLLABLENDK_FLOW_ITEM_ADAPTER_H
#define SCROLLABLENDK_FLOW_ITEM_ADAPTER_H

#include <functional>
#include <stack>
#include <string>
#include <vector>

#include <arkui/native_interface.h>
#include <arkui/native_node.h>

#include "common/NativeNodeUtils.h"

namespace ScrollableNDK {

/** 适配器回调：外部定义创建/绑定/回收 */
struct FlowItemAdapterCallbacks {
    std::function<int32_t()> getTotalCount;                                         // 必填：总数
    std::function<uint64_t(int32_t)> getStableId;                                   // 可选：稳定复用ID
    std::function<ArkUI_NodeHandle(ArkUI_NativeNodeAPI_1 *, int32_t)> onCreate;     // 必填：创建
    std::function<void(ArkUI_NativeNodeAPI_1 *, ArkUI_NodeHandle, int32_t)> onBind; // 必填：绑定
    std::function<void(ArkUI_NativeNodeAPI_1 *, ArkUI_NodeHandle)> onRecycle;       // 可选：回收
};

/** ArkUI NodeAdapter 轻封装，带默认字符串数据源 */
class FlowItemAdapter {
public:
    FlowItemAdapter()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        adapter_ = OH_ArkUI_NodeAdapter_Create();
        OH_ArkUI_NodeAdapter_RegisterEventReceiver(adapter_, this, OnStaticEvent);
        SetCallbacks(BuildDefaultCallbacks()); // 默认回调示例
        SyncCount();
    }

    ~FlowItemAdapter()
    {
        while (!cache_.empty()) {
            cache_.pop();
        }
        OH_ArkUI_NodeAdapter_UnregisterEventReceiver(adapter_);
        OH_ArkUI_NodeAdapter_Dispose(adapter_);
        adapter_ = nullptr;
    }

    ArkUI_NodeAdapterHandle GetAdapter() const { return adapter_; }

    void SetCallbacks(const FlowItemAdapterCallbacks &cb)
    {
        cb_ = cb;
        SyncCount();
    }

    void SetData(std::vector<std::string> data)
    {
        data_ = std::move(data);
        SyncCount();
        OH_ArkUI_NodeAdapter_ReloadAllItems(adapter_);
    }

    const std::vector<std::string> &GetData() const { return data_; }

    // —— 数据通知 —— //
    void InsertRange(int32_t index, int32_t count)
    {
        if (index < 0) {
            index = 0;
        }
        if (index > Count()) {
            index = Count();
        }
        if (count <= 0) {
            return;
        }
        OH_ArkUI_NodeAdapter_InsertItem(adapter_, index, count);
        SyncCount();
    }

    void ReloadAllItems() { OH_ArkUI_NodeAdapter_ReloadAllItems(adapter_); }

private:
    // —— 默认常量（避免魔法数） —— //
    static constexpr int K_INIT_RESERVE = 100;
    static constexpr int K_INIT_SEED = 100;
    static constexpr float K_FONT_SIZE = 16.0f;
    static constexpr float K_ITEM_H = 100.0f;
    static constexpr float K_ITEM_W_PCT = 1.0f;
    static constexpr uint32_t K_ITEM_BG = 0xFFFF0000U;

    static inline void SetFlowItemBase(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item)
    {
        SetAttrF32(api, item, NODE_HEIGHT, K_ITEM_H);
        SetAttrF32(api, item, NODE_WIDTH_PERCENT, K_ITEM_W_PCT);
        SetAttrU32(api, item, NODE_BACKGROUND_COLOR, K_ITEM_BG);
    }

    int32_t Count() const
    {
        if (cb_.getTotalCount) {
            return cb_.getTotalCount();
        }
        return static_cast<int32_t>(data_.size());
    }

    void SyncCount() { OH_ArkUI_NodeAdapter_SetTotalNodeCount(adapter_, static_cast<uint32_t>(Count())); }

    static void OnStaticEvent(ArkUI_NodeAdapterEvent *ev)
    {
        auto *self = reinterpret_cast<FlowItemAdapter *>(OH_ArkUI_NodeAdapterEvent_GetUserData(ev));
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
                        item = api_->createNode(ARKUI_NODE_FLOW_ITEM);
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

    /** 默认回调：红底/100高/100%宽/字号16，文本=索引 */
    FlowItemAdapterCallbacks BuildDefaultCallbacks()
    {
        FlowItemAdapterCallbacks cb{};

        data_.clear();
        data_.reserve(static_cast<size_t>(K_INIT_RESERVE));
        for (int32_t i = 0; i < K_INIT_SEED; ++i) {
            data_.emplace_back(std::to_string(i));
        }

        cb.getTotalCount = [this]() -> int32_t { return static_cast<int32_t>(data_.size()); };

        cb.getStableId = [this](int32_t i) -> uint64_t {
            return static_cast<uint64_t>(std::hash<std::string>{}(data_[static_cast<size_t>(i)]));
        };

        cb.onCreate = [this](ArkUI_NativeNodeAPI_1 *api, int32_t index) -> ArkUI_NodeHandle {
            ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
            SetTextContent(api, text, data_[static_cast<size_t>(index)].c_str());
            SetFontSize(api, text, K_FONT_SIZE);

            ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_FLOW_ITEM);
            api->addChild(item, text);
            return item;
        };

        cb.onBind = [this](ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index) {
            SetFlowItemBase(api, item);
            ArkUI_NodeHandle text = api->getFirstChild(item);
            SetTextContent(api, text, data_[static_cast<size_t>(index)].c_str());
            SetFontSize(api, text, K_FONT_SIZE);
        };

        cb.onRecycle = nullptr;
        return cb;
    }

private:
    ArkUI_NativeNodeAPI_1 *api_ = nullptr;
    ArkUI_NodeAdapterHandle adapter_ = nullptr;

    FlowItemAdapterCallbacks cb_{};
    std::vector<std::string> data_;
    std::stack<ArkUI_NodeHandle> cache_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_FLOW_ITEM_ADAPTER_H
