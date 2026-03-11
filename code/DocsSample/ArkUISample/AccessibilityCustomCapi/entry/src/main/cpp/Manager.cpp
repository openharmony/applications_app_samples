/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#include "Manager.h"
#include "AccessibilityMaker.h"
#include "napi/native_api.h"
#include "AccessibilityDialogSubWindow.h"
#include "AccessibilityDialog.h"
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <cstring>
#include <hilog/log.h>
#include <arkui/native_node_napi.h>
#include <js_native_api.h>


Manager Manager::manager_;
ArkUI_NativeNodeAPI_1 *Manager::nodeAPI_ = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
// dialog
ArkUI_NativeDialogAPI_1 *Manager::nodeDialogAPI_ = reinterpret_cast<ArkUI_NativeDialogAPI_1*>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));

napi_value Manager::CreateNativeAccessibilityNode(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    // 从 napi 参数中解析出 NodeContentHandle，用于承载后续创建的原生节点
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    // 如果 nodeAPI 可用，则调用 AccessibilityMaker 构建原生节点并添加到 NodeContent 中
    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            // 构建完整的可访问性示例原生节点并交给框架渲染
            ArkUI_NodeHandle testNode = AccessibilityMaker::CreateNativeNode();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, testNode);
        }
    }
    return nullptr;
}

napi_value Manager::CreateNativeAccessibilityNodeMultiple(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;

    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);
    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            ArkUI_NodeHandle testNode = AccessibilityMaker::CreateNativeNode_multiple();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, testNode);
        }
    }
    return nullptr;
}

napi_value Manager::CreateNativeAccessibilityNodeDialog(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    if (nodeAPI_ != nullptr && nodeAPI_->addChild != nullptr) {
        ArkUI_NodeHandle node = nodeAPI_->createNode(ARKUI_NODE_TEXT);
        AccessibilityDialogSubWindow::MainViewMethod(nodeContentHandle);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "AccessibilityMaker::CreateNativeNode() aaa");
        OH_ArkUI_NodeContent_AddNode(nodeContentHandle, node);
    }
    return nullptr;
}

napi_value Manager::CreateNativeAccessibilityNodeDialogSubWindow(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;

    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    if (nodeAPI_ != nullptr && nodeAPI_->addChild != nullptr) {
        ArkUI_NodeHandle node = nodeAPI_->createNode(ARKUI_NODE_TEXT);
        AccessibilityDialog::MainViewMethod(nodeContentHandle);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "AccessibilityMaker::CreateNativeNode() aaa");
        OH_ArkUI_NodeContent_AddNode(nodeContentHandle, node);
    }
    return nullptr;
}

napi_value Manager::CreateNativeAccessibilityNoCustom(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    // 解析 NodeContent 并使用不包含 custom provider 的制造器创建原生节点
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            ArkUI_NodeHandle testNode = AccessibilityMaker::CreateNativeNoCustom();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, testNode);
        }
    }
    return nullptr;
}