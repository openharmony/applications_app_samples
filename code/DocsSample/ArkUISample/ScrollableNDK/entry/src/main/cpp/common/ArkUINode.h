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

#ifndef SCROLLABLENDK_COMMON_ARKUINODE_H
#define SCROLLABLENDK_COMMON_ARKUINODE_H

#include <functional>
#include <list>
#include <memory>

#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>

#include "ArkUIUtils.h"

namespace ScrollableNDK {

/**
 * @brief ArkUI_NativeNodeAPI_1 单例访问器
 */
class NodeApiInstance {
public:
    static NodeApiInstance *GetInstance()
    {
        static NodeApiInstance instance;
        return &instance;
    }

    ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI() const { return nodeApi_; }

private:
    NodeApiInstance() { OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeApi_); }

    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
};

/**
 * @brief Node 基础封装：通用属性设置、子节点管理、基础事件处理
 * @note 该类只包含纯粹的UI属性和通用功能，不包含任何业务逻辑
 */
class BaseNode : public std::enable_shared_from_this<BaseNode> {
public:
    explicit BaseNode(ArkUI_NodeHandle handle)
        : nodeApi_(NodeApiInstance::GetInstance()->GetNativeNodeAPI()), nodeHandle_(handle)
    {
        if (!Utils::IsNotNull(nodeApi_) || !Utils::IsNotNull(nodeHandle_)) {
            return;
        }
        RegisterClickEvent();
    }

    virtual ~BaseNode()
    {
        UnregisterClickEvent();
        ClearChildren();
        nodeHandle_ = nullptr;
    }

    ArkUI_NodeHandle GetHandle() const { return nodeHandle_; }

    void AddChild(const std::shared_ptr<BaseNode> &child)
    {
        if (!Utils::IsNotNull(child)) {
            return;
        }
        children_.push_back(child);
        nodeApi_->addChild(nodeHandle_, child->GetHandle());
    }

    void RemoveChild(const std::shared_ptr<BaseNode> &child)
    {
        if (!Utils::IsNotNull(child)) {
            return;
        }
        auto it = std::find(children_.begin(), children_.end(), child);
        if (it != children_.end()) {
            nodeApi_->removeChild(nodeHandle_, child->GetHandle());
            children_.erase(it);
        }
    }

    // ========================================
    // 通用属性设置接口
    // ========================================

    void SetWidth(float width) { Utils::SetAttributeFloat32(nodeApi_, nodeHandle_, NODE_WIDTH, width); }

    void SetHeight(float height) { Utils::SetAttributeFloat32(nodeApi_, nodeHandle_, NODE_HEIGHT, height); }

    void SetWidthPercent(float percent)
    {
        Utils::SetAttributeFloat32(nodeApi_, nodeHandle_, NODE_WIDTH_PERCENT, percent);
    }

    void SetHeightPercent(float percent)
    {
        Utils::SetAttributeFloat32(nodeApi_, nodeHandle_, NODE_HEIGHT_PERCENT, percent);
    }

    void SetSize(float width, float height) { Utils::SetSize(nodeApi_, nodeHandle_, width, height); }

    void SetSizePercent(float widthPercent, float heightPercent)
    {
        Utils::SetSizePercent(nodeApi_, nodeHandle_, widthPercent, heightPercent);
    }

    void SetFullSize() { Utils::SetFullSize(nodeApi_, nodeHandle_); }

    void SetBackgroundColor(uint32_t color) { Utils::SetBackgroundColor(nodeApi_, nodeHandle_, color); }

    void SetTransparentBackground() { Utils::SetTransparentBackground(nodeApi_, nodeHandle_); }

    void SetOpacity(float opacity)
    {
        if (!Utils::ValidateApiAndNode(nodeApi_, nodeHandle_, "BaseNode::SetOpacity")) {
            return;
        }
        Utils::SetAttributeFloat32(nodeApi_, nodeHandle_, NODE_OPACITY, opacity);
    }

    // ========================================
    // 事件处理接口
    // ========================================

    void RegisterOnClick(const std::function<void(ArkUI_NodeEvent *)> &callback) { onClickCallback_ = callback; }

protected:
    virtual void OnNodeEvent(ArkUI_NodeEvent *event)
    {
        if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_CLICK && onClickCallback_) {
            onClickCallback_(event);
        }
    }

    static void StaticEventReceiver(ArkUI_NodeEvent *event)
    {
        auto *self = reinterpret_cast<BaseNode *>(OH_ArkUI_NodeEvent_GetUserData(event));
        if (Utils::IsNotNull(self)) {
            self->OnNodeEvent(event);
        }
    }

private:
    void RegisterClickEvent()
    {
        if (Utils::IsNotNull(nodeApi_) && Utils::IsNotNull(nodeHandle_)) {
            nodeApi_->registerNodeEvent(nodeHandle_, NODE_ON_CLICK, 0, this);
            hasClickEventRegistered_ = true;
        }
    }

    void UnregisterClickEvent()
    {
        if (Utils::IsNotNull(nodeApi_) && Utils::IsNotNull(nodeHandle_) && hasClickEventRegistered_) {
            nodeApi_->unregisterNodeEvent(nodeHandle_, NODE_ON_CLICK);
            hasClickEventRegistered_ = false;
        }
    }

    void ClearChildren() { children_.clear(); }

protected:
    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
    ArkUI_NodeHandle nodeHandle_ = nullptr;
    std::list<std::shared_ptr<BaseNode>> children_;
    std::function<void(ArkUI_NodeEvent *)> onClickCallback_;
    bool hasClickEventRegistered_ = false;
};

// ========================================
// 保活容器模板 - 用于管理共享指针的生命周期
// ========================================
template <typename T> inline std::vector<std::shared_ptr<T>> &GetKeepAliveContainer()
{
    static std::vector<std::shared_ptr<T>> keepAliveContainer;
    return keepAliveContainer;
}

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_COMMON_ARKUINODE_H
