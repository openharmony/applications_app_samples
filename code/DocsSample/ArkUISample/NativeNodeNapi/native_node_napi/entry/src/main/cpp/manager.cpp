/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "manager.h"
#include "ArkUIAnimationNode.h"
#include "ArkUIVisualEffectsNode.h"
#include "NavigationContext.h"
#include "AccessibilityMaker.h"
#include "EmbeddedComponentMaker.h"
#include "napi/native_api.h"
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

napi_value Manager::CreateNativeNaviNode(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode BEGIN");
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;

    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "OH_ArkUI_GetBasicNodeAPI after");
    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            auto columnNode = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, columnNode);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager",
                         "******************NavigationInfoTest******************");
            NavigationContext::NavigationInfoTest1(columnNode);
            NavigationContext::NavigationInfoTest2(columnNode);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager",
                         "******************RouterPageInfoTest******************");
            NavigationContext::RouterPageInfoTest(columnNode);
        }
    }
    return nullptr;
}

napi_value Manager::CreateNativeAccessibilityNode(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode BEGIN");
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;

    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "OH_ArkUI_GetBasicNodeAPI after");
    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            ArkUI_NodeHandle testNode = AccessibilityMaker::CreateNativeNode();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, testNode);
        }
    }
    return nullptr;
}

napi_value Manager::CreateNativeEmbeddedComponentNode(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode BEGIN");
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;

    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "OH_ArkUI_GetBasicNodeAPI after");
    if (nodeAPI_ != nullptr) {
        if (nodeAPI_->createNode != nullptr && nodeAPI_->addChild != nullptr) {
            ArkUI_NodeHandle testNode = EmbeddedComponentMaker::CreateNativeNode();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, testNode);
        }
    }
}

napi_value createAnimationCenter(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateAnimationCenter();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createAnimationOpacity(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateAnimationOpacity();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createAnimationTranslate(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateAnimationTranslate();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createAnimationFit(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateAnimationFit();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createAnimationGeometry(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateAnimationGeometry();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsScale(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsScale();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsBlur(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsBlur();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsShape(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsShape();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsShadow(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsShadow();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsSepia(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsSepia();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsMask(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsMask();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsCont(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsCont();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsAngle(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsAngle();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsStyle(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsStyle();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value createVisualEffectsGroup(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    Manager::GetInstance()->SetContentHandle(contentHandle);
    
    auto column = NativeModule::CreateVisualEffectsGroup();
    Manager::GetInstance()->SetRootNode(column);
    return nullptr;
}

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
{
    Manager::GetInstance()->DisposeRootNode();
    return nullptr;
}