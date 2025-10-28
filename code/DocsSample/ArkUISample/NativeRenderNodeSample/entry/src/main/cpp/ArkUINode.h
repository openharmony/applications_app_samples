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
// ArkUINode.h
// 提供通用属性和事件的封装。
#ifndef MYAPPLICATION_ARKUINODE_H
#define MYAPPLICATION_ARKUINODE_H

#include "ArkUIBaseNode.h"
#include "NativeModule.h"
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <hilog/log.h>
#include <string>

namespace NativeModule {

void CallBack(uint64_t nanoTimeLeft, uint32_t frameCount, void *userData)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "PostCallback",
                 "***StartCallBack*** nanoTimeLeft = %{public}lu , frameCount = %{public}d",
                 nanoTimeLeft, frameCount);
    if (userData) {
        int *myData = (int *)userData;
    }
    // 执行业务相关逻辑。
}

class ArkUINode : public ArkUIBaseNode {
public:
    explicit ArkUINode(ArkUI_NodeHandle handle) : ArkUIBaseNode(handle)
    {
        nativeModule_ = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
        // 事件触发时需要通过函数获取对应的事件对象，这边通过设置节点自定义数据将封装类指针保持在组件上，方便后续事件分发。
        nativeModule_->setUserData(handle_, this);
        // 注册节点监听事件接受器。
        nativeModule_->addNodeEventReceiver(handle_, ArkUINode::NodeEventReceiver);
    }

    ~ArkUINode() override
    {
        if (onClick_) {
            nativeModule_->unregisterNodeEvent(handle_, NODE_ON_CLICK_EVENT);
        }
        if (onTouch_) {
            nativeModule_->unregisterNodeEvent(handle_, NODE_TOUCH_EVENT);
        }
        if (onDisappear_) {
            nativeModule_->unregisterNodeEvent(handle_, NODE_EVENT_ON_DISAPPEAR);
        }
        if (onAppear_) {
            nativeModule_->unregisterNodeEvent(handle_, NODE_EVENT_ON_APPEAR);
        }
        nativeModule_->removeNodeEventReceiver(handle_, ArkUINode::NodeEventReceiver);
    }

    // 通用属性调用封装
    void SetWidth(float width)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_WIDTH, &item);
        CheckErrorCode(result);
    }
    float GetWidth()
    {
        return nativeModule_->getAttribute(handle_, NODE_WIDTH)->value[0].f32;
    }
    void SetPercentWidth(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_WIDTH_PERCENT, &item);
        CheckErrorCode(result);
    }
    void SetHeight(float height)
    {
        ArkUI_NumberValue value[] = {{.f32 = height}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_HEIGHT, &item);
        CheckErrorCode(result);
    }
    float GetHeight()
    {
        return nativeModule_->getAttribute(handle_, NODE_HEIGHT)->value[0].f32;
    }
    void SetSize(float width, float height)
    {
        ArkUI_NumberValue valueWidth[] = {{.f32 = width}};
        ArkUI_AttributeItem itemWidth = {valueWidth, 1};
        nativeModule_->setAttribute(handle_, NODE_WIDTH, &itemWidth);
        ArkUI_NumberValue valueHeight[] = {{.f32 = height}};
        ArkUI_AttributeItem itemHeight = {valueHeight, 1};
        nativeModule_->setAttribute(handle_, NODE_HEIGHT, &itemHeight);
    }
    void SetPercentHeight(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_HEIGHT_PERCENT, &item);
        CheckErrorCode(result);
    }
    void SetBackgroundColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_BACKGROUND_COLOR, &item);
        CheckErrorCode(result);
    }
    void SetId(const std::string &id)
    {
        ArkUI_AttributeItem item = {.string = id.c_str() };
        auto result = nativeModule_->setAttribute(handle_, NODE_ID, &item);
        CheckErrorCode(result);
    }
    void ResetId() { nativeModule_->resetAttribute(handle_, NODE_ID); }
    void CheckErrorCode(int32_t errorCode)
    {
        if (errorCode == ARKUI_ERROR_CODE_NO_ERROR) {
            return;
        }
        int32_t uniqueId = -1;
        OH_ArkUI_NodeUtils_GetNodeUniqueId(handle_, &uniqueId);
        auto nodeType = OH_ArkUI_NodeUtils_GetNodeType(handle_);
        auto isNDKNode = OH_ArkUI_NodeUtils_IsCreatedByNDK(handle_);
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "Manager",
                     "ErrorCode:%{public}d, uniqueId:%{public}d, nodeType:%{public}d, isCreateByNdk:%{public}d",
                     errorCode, uniqueId, nodeType, isNDKNode);
    }

    void SetCrossLanguage(bool isCross)
    {
        auto option = OH_ArkUI_CrossLanguageOption_Create();
        OH_ArkUI_CrossLanguageOption_SetAttributeSettingStatus(option, isCross);
        OH_ArkUI_NodeUtils_SetCrossLanguageOption(handle_, option);
        OH_ArkUI_CrossLanguageOption_Destroy(option);
    }

    bool GetCrossLanguage()
    {
        auto option = OH_ArkUI_CrossLanguageOption_Create();
        OH_ArkUI_NodeUtils_GetCrossLanguageOption(handle_, option);
        bool isCross = OH_ArkUI_CrossLanguageOption_GetAttributeSettingStatus(option);
        int32_t uniqueId = -1;
        OH_ArkUI_NodeUtils_GetNodeUniqueId(handle_, &uniqueId);
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "Manager",
                     "uniqueId:%{public}d, isCrossLanguage:%{public}d", uniqueId, isCross);
        OH_ArkUI_CrossLanguageOption_Destroy(option);
    }

    ArkUI_IntOffset GetLayoutPositionInWindow()
    {
        ArkUI_IntOffset globalOffset;
        auto result = OH_ArkUI_NodeUtils_GetLayoutPositionInWindow(handle_, &globalOffset);
        if (result == ARKUI_ERROR_CODE_NO_ERROR) {
            return globalOffset;
        } else {
            return {0, 0};
        }
    }

    ArkUI_IntOffset GetPositionWithTranslateInWindow()
    {
        ArkUI_IntOffset translateOffset;
        auto result = OH_ArkUI_NodeUtils_GetPositionWithTranslateInWindow(handle_, &translateOffset);
        if (result == ARKUI_ERROR_CODE_NO_ERROR) {
            return translateOffset;
        } else {
            return {0, 0};
        }
    }

    // 处理通用事件。
    void RegisterOnClick(const std::function<void(ArkUI_NodeEvent *event)> &onClick, void* userData)
    {
        onClick_ = onClick;
        // 注册点击事件。
        nativeModule_->registerNodeEvent(handle_, NODE_ON_CLICK_EVENT, 0, userData);
    }

    void RegisterOnTouch(const std::function<void(int32_t type, float x, float y)> &onTouch)
    {
        onTouch_ = onTouch;
        // 注册触碰事件。
        nativeModule_->registerNodeEvent(handle_, NODE_TOUCH_EVENT, 0, nullptr);
    }

    void RegisterOnDisappear(const std::function<void()> &onDisappear)
    {
        onDisappear_ = onDisappear;
        // 注册卸载事件。
        nativeModule_->registerNodeEvent(handle_, NODE_EVENT_ON_DISAPPEAR, 0, nullptr);
    }

    void RegisterOnAppear(const std::function<void()> &onAppear)
    {
        onAppear_ = onAppear;
        // 注册挂载事件。
        nativeModule_->registerNodeEvent(handle_, NODE_EVENT_ON_APPEAR, 0, nullptr);
    }

    // 抛出任务在下一帧渲染时执行，用于执行一些需等待其他任务完成时的业务逻辑。
    void PostFrameCallback(void *data)
    {
        auto context = OH_ArkUI_GetContextByNode(handle_);
        OH_ArkUI_PostFrameCallback(context, &data, CallBack);
    }

    // 抛出任务在下一帧渲染结束后且vsync信号来临还有大于1ms时执行，若剩余时间小于1ms，则顺延至下一帧并自动请求vysnc。
    void PostIdleCallback(void *data)
    {
        auto context = OH_ArkUI_GetContextByNode(handle_);
        OH_ArkUI_PostIdleCallback(context, &data, CallBack);
    }

protected:
    // 组件树操作的实现类对接。
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->addChild(handle_, child->GetHandle());
    }
    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->removeChild(handle_, child->GetHandle());
    }
    void OnRemoveAllChild() override
    {
        nativeModule_->removeAllChildren(handle_);
    }
    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override
    {
        nativeModule_->insertChildAt(handle_, child->GetHandle(), index);
    }
    void OnInsertChildBefore(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing) override
    {
        nativeModule_->insertChildBefore(handle_, child->GetHandle(), slibing->GetHandle());
    }
    void OnInsertChildAfter(const std::shared_ptr<ArkUIBaseNode> &child,
        const std::shared_ptr<ArkUIBaseNode> &slibing) override
    {
        nativeModule_->insertChildAfter(handle_, child->GetHandle(), slibing->GetHandle());
    }

    // 事件监听器函数指针。
    static void NodeEventReceiver(ArkUI_NodeEvent *event)
    {
        // 获取事件发生的UI组件对象。
        auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        // 获取保持在UI组件对象中的自定义数据，返回封装类指针。
        auto *node = reinterpret_cast<ArkUINode *>(
            NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->getUserData(nodeHandle));
        // 基于封装类实例对象处理事件。
        node->ProcessNodeEvent(event);
    }
    void ProcessNodeEvent(ArkUI_NodeEvent *event)
    {
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        switch (eventType) {
            case NODE_ON_CLICK_EVENT: {
                if (onClick_) {
                    onClick_(event);
                }
                break;
            }
            case NODE_TOUCH_EVENT: {
                if (onTouch_) {
                    auto *uiInputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
                    float x = OH_ArkUI_PointerEvent_GetX(uiInputEvent);
                    float y = OH_ArkUI_PointerEvent_GetY(uiInputEvent);
                    auto type = OH_ArkUI_UIInputEvent_GetAction(uiInputEvent);
                    onTouch_(type, x, y);
                }
            }
            case NODE_EVENT_ON_DISAPPEAR: {
                if (onDisappear_) {
                    onDisappear_();
                }
                break;
            }
            case NODE_EVENT_ON_APPEAR: {
                if (onAppear_) {
                    onAppear_();
                }
                break;
            }
            default: {
                // 组件特有事件交给子类处理
                OnNodeEvent(event);
            }
        }
    }

    virtual void OnNodeEvent(ArkUI_NodeEvent *event) {}

private:
    std::function<void(ArkUI_NodeEvent *event)> onClick_;
    std::function<void()> onDisappear_;
    std::function<void()> onAppear_;
    std::function<void(int32_t type, float x, float y)> onTouch_;
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUINODE_H