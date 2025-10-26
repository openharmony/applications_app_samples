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
// [Start arkui_mixed_refresh]
// ArkUIMixedRefresh.h
// Refresh混合模式在Native侧的封装对象。

#ifndef MYAPPLICATION_ARKUIMIXEDREFRESH_H
#define MYAPPLICATION_ARKUIMIXEDREFRESH_H

#include "ArkUIMixedNode.h"
#include "ArkUIBaseNode.h"

#include <optional>

#include <arkui/native_node_napi.h>
#include <js_native_api_types.h>

namespace NativeModule {

// 定义Native侧和ArkTS侧的交互数据结构。
struct NativeRefreshAttribute {
    std::optional<bool> isRefreshing;
    std::optional<float> width;
    std::optional<float> height;
    std::optional<uint32_t> backgroundColor;
    std::optional<float> refreshOffset;
    std::optional<bool> pullToRefresh;
    std::function<void()> onRefreshing;
    std::function<void(float)> onOffsetChange;
};

class ArkUIMixedRefresh : public ArkUIMixedNode {
public:
    // 调用ArkTS的方法创建Refresh组件。
    static const std::shared_ptr<ArkUIMixedRefresh> Create(const NativeRefreshAttribute &attribute);

    ArkUIMixedRefresh(ArkUI_NodeHandle handle, ArkUI_NodeContentHandle contentHandle, napi_env env,
                      napi_ref componentContent, napi_ref nodeContent)
        : ArkUIMixedNode(handle, env, componentContent), contentHandle_(contentHandle), nodeContent_(nodeContent) {}

    ArkUIMixedRefresh() : ArkUIMixedNode(nullptr, nullptr, nullptr) {}

    ~ArkUIMixedRefresh() override { napi_delete_reference(env_, nodeContent_); } // 释放子节点占位组件插槽对象。

    void SetWidth(float width) { attribute_.width = width; }

    void SetHeight(float height) { attribute_.height = height; }

    void SetBackgroundColor(uint32_t color) { attribute_.backgroundColor = color; }

    void SetRefreshState(bool isRefreshing) { attribute_.isRefreshing = isRefreshing; }

    void SetPullToRefresh(bool pullToRefresh) { attribute_.pullToRefresh = pullToRefresh; }

    void SetRefreshOffset(float offset) { attribute_.refreshOffset = offset; }

    void SetRefreshCallback(const std::function<void()> &callback) { attribute_.onRefreshing = callback; }

    void SetOnOffsetChange(const std::function<void(float)> &callback) { attribute_.onOffsetChange = callback; }

    // 避免频繁跨语言，在Native侧缓存属性事件，批量通知。
    void FlushMixedModeCmd();

    static napi_value RegisterCreateRefresh(napi_env env, napi_callback_info info);
    static napi_value RegisterUpdateRefresh(napi_env env, napi_callback_info info);

protected:
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        // 使用NodeContent挂载组件（可以使用ArkTS在Native侧通过ComponentContent的转化对象，也可以是纯Native组件）到ArkTS组件下面。
        OH_ArkUI_NodeContent_AddNode(contentHandle_, child->GetHandle());
    }

    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        // 使用NodeContent卸载组件。
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, child->GetHandle());
    }

    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override
    {
        // 使用NodeContent插入组件。
        OH_ArkUI_NodeContent_InsertNode(contentHandle_, child->GetHandle(), index);
    }

private:
    // 使用napi接口创建ArkTS侧的数据结构。
    static napi_value CreateRefreshAttribute(const NativeRefreshAttribute &attribute, void *userData);
    
    static void Attribute2Descriptor(const NativeRefreshAttribute &attribute, napi_property_descriptor *desc);

    ArkUI_NodeContentHandle contentHandle_;
    napi_ref nodeContent_;
    NativeRefreshAttribute attribute_;
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIMIXEDREFRESH_H
// [End arkui_mixed_refresh]