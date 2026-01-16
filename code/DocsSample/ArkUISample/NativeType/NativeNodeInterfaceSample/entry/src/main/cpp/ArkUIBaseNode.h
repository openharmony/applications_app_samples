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
// ArkUIBaseNode.h
// 提供组件树操作的基类。
#ifndef MYAPPLICATION_ARKUIBASENODE_H
#define MYAPPLICATION_ARKUIBASENODE_H

#include <arkui/native_type.h>
#include <list>
#include <memory>
#include <hilog/log.h>

#include "NativeModule.h"

namespace NativeModule {

    class ArkUIBaseNode {
    public:
        explicit ArkUIBaseNode(ArkUI_NodeHandle handle)
            : handle_(handle), nativeModule_(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()) {}

        virtual ~ArkUIBaseNode()
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

        void AddChild(const std::shared_ptr<ArkUIBaseNode> &child)
        {
            children_.emplace_back(child);
            OnAddChild(child);
        }

        void RemoveChild(const std::shared_ptr<ArkUIBaseNode> &child)
        {
            children_.remove(child);
            OnRemoveChild(child);
        }

        void InsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index)
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

        void InsertChildBefore(const std::shared_ptr<ArkUIBaseNode> &child,
            const std::shared_ptr<ArkUIBaseNode> &slibing)
        {
            auto it = std::find(children_.begin(), children_.end(), slibing);
            if (it != children_.end()) {
                children_.insert(it, child);
            }
            OnInsertChildBefore(child, slibing);
        }

        void InsertChildAfter(const std::shared_ptr<ArkUIBaseNode> &child,
            const std::shared_ptr<ArkUIBaseNode> &slibing)
        {
            auto it = std::find(children_.begin(), children_.end(), slibing);
            if (it != children_.end()) {
                children_.insert(std::next(it), child);
            }
            OnInsertChildAfter(child, slibing);
        }

        ArkUI_NodeHandle GetHandle() const { return handle_; }

    protected:
        // 针对父容器子类需要重载下面的函数，实现组件挂载和卸载。
        virtual void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) {}
        virtual void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) {}
        virtual void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) {}
        virtual void OnInsertChildBefore(const std::shared_ptr<ArkUIBaseNode> &child,
                                         const std::shared_ptr<ArkUIBaseNode> &slibing) {}
        virtual void OnInsertChildAfter(const std::shared_ptr<ArkUIBaseNode> &child,
                                        const std::shared_ptr<ArkUIBaseNode> &slibing) {}

        ArkUI_NodeHandle handle_;
        ArkUI_NativeNodeAPI_1 *nativeModule_ = nullptr;

    private:
        std::list<std::shared_ptr<ArkUIBaseNode>> children_;
    };
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIBASENODE_H