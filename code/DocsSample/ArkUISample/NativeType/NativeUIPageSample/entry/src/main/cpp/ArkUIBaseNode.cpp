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
// [Start Cpp_ArkUIBaseNode]
// ArkUIBaseNode.cpp
// 提供组件树操作的基类。
#include "ArkUIBaseNode.h"
#include "ArkUINode.h"

namespace NativeModule {
    ArkUIBaseNode::~ArkUIBaseNode()
    {
        // 封装析构函数，实现子节点移除功能。
        if (!children_.empty()) {
            for (const auto &child : children_) {
                nativeModule_->removeChild(handle_, child->GetHandle());
            }
            children_.clear();
        }
        // 封装析构函数，统一回收节点资源。
        nativeModule_->disposeNode(handle_);
    }

    void ArkUIBaseNode::AddChild(const std::shared_ptr<ArkUIBaseNode> &child)
    {
        children_.emplace_back(child);
        OnAddChild(child);
    }

    void ArkUIBaseNode::RemoveChild(const std::shared_ptr<ArkUIBaseNode> &child)
    {
        children_.remove(child);
        OnRemoveChild(child);
    }

    void ArkUIBaseNode::InsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index)
    {
        if (index >= children_.size()) {
            AddChild(child);
        } else {
            auto iter = children_.begin();
            std::advance(iter, index);
            children_.insert(iter, child);
            OnInsertChild(child, index);
        }
    }

    void ArkUIBaseNode::InsertChildBefore(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing)
    {
        auto it = std::find(children_.begin(), children_.end(), slibing);
        if (it != children_.end()) {
            children_.insert(it, child);
        }
        OnInsertChildBefore(child, slibing);
    }

    void ArkUIBaseNode::InsertChildAfter(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing)
    {
        auto it = std::find(children_.begin(), children_.end(), slibing);
        if (it != children_.end()) {
            children_.insert(std::next(it), child);
        }
        OnInsertChildAfter(child, slibing);
    }

    void ArkUIBaseNode::RemoveAllChild()
    {
        for (auto it = children_.begin(); it != children_.end();) {
            RemoveChild(*it);
        }
        OnRemoveAllChild();
    }

} // namespace NativeModule
// [End Cpp_ArkUIBaseNode]
