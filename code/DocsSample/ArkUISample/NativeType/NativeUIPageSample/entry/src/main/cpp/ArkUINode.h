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
// [Start Cpp_ArkUINode_h]
// ArkUINode.h
// 提供通用属性和事件的封装。
#ifndef NATIVEUIPAGESAMPLE_ARKUINODE_H
#define NATIVEUIPAGESAMPLE_ARKUINODE_H

#include "ArkUIBaseNode.h"
#include "NativeModule.h"
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <hilog/log.h>
#include <string>
#include <functional>

namespace NativeModule {
void CallBack(uint64_t nanoTimeLeft, uint32_t frameCount, void *userData);

class ArkUINode : public ArkUIBaseNode {
public:
    explicit ArkUINode(ArkUI_NodeHandle handle);

    ~ArkUINode() override;

    // 通用属性调用封装
    void SetWidth(float width);

    float GetWidth();

    void SetPercentWidth(float percent);

    void SetHeight(float height);

    float GetHeight();

    void SetSize(float width, float height);

    void SetPercentHeight(float percent);

    void SetBackgroundColor(uint32_t color);

    void SetId(const std::string &id);

    void ResetId();

    void CheckErrorCode(int32_t errorCode);

    void SetCrossLanguage(bool isCross);

    bool GetCrossLanguage();

    ArkUI_IntOffset GetLayoutPositionInWindow();

    ArkUI_IntOffset GetPositionWithTranslateInWindow();

    // 处理通用事件。
    void RegisterOnClick(const std::function<void(ArkUI_NodeEvent *event)> &onClick, void* userData);

    void RegisterOnTouch(const std::function<void(int32_t type, float x, float y)> &onTouch);

    void RegisterOnDisappear(const std::function<void()> &onDisappear);

    void RegisterOnAppear(const std::function<void()> &onAppear);

    // 抛出任务在下一帧渲染时执行，用于执行一些需等待其他任务完成时的业务逻辑。
    void PostFrameCallback(void *data);

    // 抛出任务在下一帧渲染结束后且vsync信号来临还有大于1ms时执行，若剩余时间小于1ms，则顺延至下一帧并自动请求vysnc。
    void PostIdleCallback(void *data);

protected:
    // 组件树操作的实现类对接。
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override;
    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override;
    void OnRemoveAllChild() override;
    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override;
    void OnInsertChildBefore(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing) override;
    void OnInsertChildAfter(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing) override;

    // 事件监听器函数指针。
    static void NodeEventReceiver(ArkUI_NodeEvent *event);

    void ProcessNodeEvent(ArkUI_NodeEvent *event);

    virtual void OnNodeEvent(ArkUI_NodeEvent *event) {}

private:
    std::function<void(ArkUI_NodeEvent *event)> onClick_;
    std::function<void()> onDisappear_;
    std::function<void()> onAppear_;
    std::function<void(int32_t type, float x, float y)> onTouch_;
};

} // namespace NativeModule

#endif // NATIVEUIPAGESAMPLE_ARKUINODE_H
// [End Cpp_ArkUINode_h]
