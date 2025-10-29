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
// [Start arkUITestNode_start]
// ArkUITextNode.h
// 实现文本组件的封装类。
#ifndef MYAPPLICATION_ARKUITEXTNODE_H
#define MYAPPLICATION_ARKUITEXTNODE_H

#include <arkui/native_type.h>
#include <arkui/native_node.h>
#include "ArkUINode.h"
#include <string>
#include "NativeEntry.h"
// [StartExclude arkUITestNode_start]
#include <hilog/log.h>
// [EndExclude arkUITestNode_start]
namespace NativeModule {

// 布局完成的回调方法
void OnLayoutCompleted(void *userData)
{
    ArkUI_NodeHandle node = (ArkUI_NodeHandle)userData;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "the text_node is layout completed");
    ArkUI_NativeNodeAPI_1 *nativeModule = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
    ArkUI_AttributeItem item = {nullptr, 0, "layout callback"};
    nativeModule->setAttribute(node, NODE_TEXT_CONTENT, &item);
}
// 绘制送显完成的回调方法
void OnDrawCompleted(void *userData)
{
    ArkUI_NodeHandle node = (ArkUI_NodeHandle)userData;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "the text_node is draw completed");
    ArkUI_NativeNodeAPI_1 *nativeModule = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
    ArkUI_AttributeItem item = {nullptr, 0, "draw callback"};
    nativeModule->setAttribute(node, NODE_TEXT_CONTENT, &item);
}

void ColorChangeCallback(ArkUI_SystemColorMode colorMode, void *userData)
{
    if (userData) {
        auto handle = (ArkUI_NodeHandle)userData;
        // 执行业务相关逻辑，如更换字体颜色，实际所需内容可以根据userData自行修改。
        bool isDark = (colorMode == ARKUI_SYSTEM_COLOR_MODE_DARK);
        ArkUI_NumberValue value[] = {{.u32 = isDark ? 0xFFFFFFFF : 0xFF000000}}; // 深色模式字体白色，浅色模式字体黑色。
        ArkUI_AttributeItem item = {value, 1};
        NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->setAttribute(handle, NODE_FONT_COLOR, &item);
    }
}

class ArkUITextNode : public ArkUINode {
public:
    ArkUITextNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_TEXT)) {}
    // 文本属性接口封装。
    void SetFontSize(float fontSize)
    {
        ArkUI_NumberValue value[] = {{.f32 = fontSize}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_FONT_SIZE, &item);
    }
    void SetFontColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_FONT_COLOR, &item);
    }
    void SetTextContent(const std::string &content)
    {
        ArkUI_AttributeItem item = {nullptr, 0, content.c_str()};
        nativeModule_->setAttribute(handle_, NODE_TEXT_CONTENT, &item);
    }
    void SetTextAlign(ArkUI_TextAlignment align)
    {
        ArkUI_NumberValue value[] = {{.i32 = align}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_TEXT_ALIGN, &item);
    }
    void SetLayoutCallBack(int32_t nodeId)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "set layout callback");
        // 注册布局完成的回调方法
        OH_ArkUI_RegisterLayoutCallbackOnNodeHandle(handle_, this, OnLayoutCompleted);
    }
    void ResetLayoutCallBack()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "reset layout callback");
        // 取消注册布局完成的回调方法
        OH_ArkUI_UnregisterLayoutCallbackOnNodeHandle(handle_);
    }
    void SetDrawCallBack(int32_t nodeId)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "set draw callback");
        // 注册绘制送显完成的回调方法
        OH_ArkUI_RegisterDrawCallbackOnNodeHandle(handle_, this, OnDrawCompleted);
    }
    void ResetDrawCallBack()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "reset draw callback");
        // 取消注册绘制送显完成的回调方法
        OH_ArkUI_UnregisterDrawCallbackOnNodeHandle(handle_);
    }
    void SetInspectorId(std::string inspectorId)
    {
        ArkUI_AttributeItem item = {nullptr, 0, inspectorId.c_str()};
        nativeModule_->setAttribute(handle_, NODE_ID, &item);
    }
    void RegistSystemColorModeChange()
    {
        OH_ArkUI_RegisterSystemColorModeChangeEvent(handle_, handle_, ColorChangeCallback);
    }

    void UnregistSystemColorModeChange()
    {
        OH_ArkUI_UnregisterSystemColorModeChangeEvent(handle_);
    }
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUITEXTNODE_H
// [End arkUITestNode_start]