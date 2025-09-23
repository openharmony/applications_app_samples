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

#pragma once

#include <chrono>
#include <cstdint>
#include <functional>
#include <initializer_list>
#include <thread>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

#include "common/ArkUINode.h"

namespace ScrollableNDK::Extra {

// ==============================
// 常量（统一魔法值）
// ==============================
inline constexpr float kPercentFull = 1.0f;
inline constexpr uint32_t kColorTransparent = 0x00000000U;

// ==============================
// 判空 / 索引
// ==============================
inline bool Nonnull(const void *p) { return p != nullptr; }

inline bool InRange(int32_t idx, int32_t n) { return (idx >= 0) && (idx < n); }

// ==============================
// 延迟小工具
// ==============================
inline void PostUiDelayed(int ms, std::function<void()> fn)
{
    std::thread([ms, fn = std::move(fn)]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(ms));
        if (fn) {
            fn();
        }
    }).detach();
}

// ==============================
// 常用属性封装
// ==============================
inline void SetWidthPercent(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle h, float pct)
{
    SetAttrF32(api, h, NODE_WIDTH_PERCENT, pct);
}

inline void SetHeightPercent(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle h, float pct)
{
    SetAttrF32(api, h, NODE_HEIGHT_PERCENT, pct);
}

inline void SetTransparentBg(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle h)
{
    SetAttrU32(api, h, NODE_BACKGROUND_COLOR, kColorTransparent);
}

// ==============================
// 文本节点工厂
// ==============================
inline ArkUI_NodeHandle MakeTextNode(ArkUI_NativeNodeAPI_1 *api, const char *s)
{
    ArkUI_NodeHandle t = api->createNode(ARKUI_NODE_TEXT);
    SetTextContent(api, t, s);
    return t;
}

inline void StyleTextNode(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle t, float fontSize, float height,
                          int32_t align /* ARKUI_TEXT_ALIGNMENT_* */, uint32_t fontColor, uint32_t bgColor)
{
    SetAttrF32(api, t, NODE_FONT_SIZE, fontSize);
    SetAttrF32(api, t, NODE_WIDTH_PERCENT, kPercentFull);
    SetAttrF32(api, t, NODE_HEIGHT, height);
    SetAttrF32(api, t, NODE_TEXT_LINE_HEIGHT, height);
    SetAttrI32(api, t, NODE_TEXT_ALIGN, align);
    if (fontColor != 0U) {
        SetAttrU32(api, t, NODE_FONT_COLOR, fontColor);
    }
    SetAttrU32(api, t, NODE_BACKGROUND_COLOR, bgColor);
}

// ==============================
// 节点事件注册
// ==============================
class NodeEventRegistrar {
public:
    NodeEventRegistrar(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle node) : api_(api), node_(node) {}

    ~NodeEventRegistrar()
    {
        if (!api_ || !node_) {
            return;
        }
        for (ArkUI_NodeEventType tp : types_) {
            api_->unregisterNodeEvent(node_, tp);
        }
    }

    void Add(ArkUI_NodeEventType type, void *userData)
    {
        if (!api_ || !node_) {
            return;
        }
        api_->registerNodeEvent(node_, type, 0, userData);
        types_.push_back(type);
    }

    void AddMany(std::initializer_list<ArkUI_NodeEventType> list, void *userData)
    {
        for (ArkUI_NodeEventType tp : list) {
            Add(tp, userData);
        }
    }

private:
    ArkUI_NativeNodeAPI_1 *api_{nullptr};
    ArkUI_NodeHandle node_{nullptr};
    std::vector<ArkUI_NodeEventType> types_{};
};

// ==============================
// Adapter 事件接收器
// ==============================
class AdapterEventRegistrar {
public:
    AdapterEventRegistrar(ArkUI_NodeAdapterHandle adapter, void *userData, void (*cb)(ArkUI_NodeAdapterEvent *))
        : adapter_(adapter)
    {
        if (adapter_) {
            OH_ArkUI_NodeAdapter_RegisterEventReceiver(adapter_, userData, cb);
        }
    }

    ~AdapterEventRegistrar()
    {
        if (adapter_) {
            OH_ArkUI_NodeAdapter_UnregisterEventReceiver(adapter_);
        }
    }

private:
    ArkUI_NodeAdapterHandle adapter_{nullptr};
};

} // namespace ScrollableNDK::Extra
