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

#include "node/NodeCreator.h"

#include <cstdint>
#include <map>
#include <napi/native_api.h>
#include <arkui/native_node_napi.h>
#include "TypedArkUINode.h"
#include "card/CardCreator.h"
#include "data/MockData.h"

namespace NativeModule {
#define CHILD_NODE_TREE_NUMBER 200 //多线程创建组件树的数量
struct AsyncData {
    napi_env env;
    std::shared_ptr<ArkUINode> parent = nullptr;
    std::shared_ptr<ArkUINode> child = nullptr;
    CardInfo cardInfo;
};
namespace {
constexpr int32_t NODE_MARGIN = 8;
}

// 保存ArkTs侧NodeContent指针与Native侧节点树根节点的对应关系。
std::map<ArkUI_NodeContentHandle, std::shared_ptr<ArkUIBaseNode>> g_nodeMap;

void CreateCardNodeTree(void *asyncUITaskData)
{
    auto asyncData = static_cast<AsyncData*>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    
    if (asyncData->cardInfo.type == "App") {
        AppCardInfo info = asyncData->cardInfo.appCardInfo;
        asyncData->child = CreateAppCard(info);
    } else if (asyncData->cardInfo.type == "Service") {
        ServiceCardInfo info = asyncData->cardInfo.serviceCardInfo;
        asyncData->child = CreateServiceCard(info);
    }
}

// 组件多线程创建完成后，回到主线程挂载到UI树上
void MountNodeTree(void *asyncUITaskData)
{
    auto asyncData = static_cast<AsyncData*>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    auto parent = asyncData->parent;
    auto child = asyncData->child;
    parent->AddChild(child);
    delete asyncData;
}

napi_value CreateNodeTreeOnMultiThread(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = { nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetNodeContentFromNapiValue Failed %{public}d", result);
        return nullptr;
    }
    ArkUI_ContextHandle contextHandle;
    result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &contextHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetContextFromNapiValue Failed %{public}d", result);
        delete contextHandle;
        return nullptr;
    }
    
    auto scrollNode = std::make_shared<ArkUIScrollNode>();
    scrollNode->SetScrollBarDisplayMode(ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF);
    result = OH_ArkUI_NodeContent_AddNode(contentHandle, scrollNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        delete contextHandle;
        return nullptr;
    }
    g_nodeMap[contentHandle] = scrollNode;
    
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    scrollNode->AddChild(columnNode);
    
    for (int32_t i = 0; i < g_cardTypeInfos.size(); i++) {
        //UI线程创建子树根节点，保证scroll的子节点顺序
        auto columnItem = std::make_shared<ArkUIColumnNode>();
        columnItem->SetMargin(NODE_MARGIN, 0, NODE_MARGIN, 0);
        columnNode->AddChild(columnItem);
        AsyncData* asyncData = new AsyncData();
        asyncData->parent = columnItem;
        asyncData->cardInfo = g_cardTypeInfos[i];
        // 在非UI线程创建组件树，创建完成后回到主线程挂载到主树上
        result = OH_ArkUI_PostAsyncUITask(contextHandle, asyncData, CreateCardNodeTree, MountNodeTree);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "OH_ArkUI_PostAsyncUITask Failed %{public}d", result);
            delete asyncData;
        }
    }
    delete contextHandle;
    return nullptr;
}

napi_value CreateNodeTreeOnUIThread(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = { nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetNodeContentFromNapiValue Failed %{public}d", result);
        return nullptr;
    }
    ArkUI_ContextHandle contextHandle;
    result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &contextHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetContextFromNapiValue Failed %{public}d", result);
        delete contextHandle;
        return nullptr;
    }
    
    auto scrollNode = std::make_shared<ArkUIScrollNode>();
    scrollNode->SetScrollBarDisplayMode(ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF);
    result = OH_ArkUI_NodeContent_AddNode(contentHandle, scrollNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        delete contextHandle;
        return nullptr;
    }
    g_nodeMap[contentHandle] = scrollNode;
    
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    scrollNode->AddChild(columnNode);
    
    for (int32_t i = 0; i < g_cardTypeInfos.size(); i++) {
        auto columnItem = std::make_shared<ArkUIColumnNode>();
        columnItem->SetMargin(NODE_MARGIN, 0, NODE_MARGIN, 0);
        columnNode->AddChild(columnItem);
        AsyncData* asyncData = new AsyncData();
        asyncData->parent = columnItem;
        asyncData->cardInfo = g_cardTypeInfos[i];
        // 在UI线程创建组件树
        CreateCardNodeTree(asyncData);
        MountNodeTree(asyncData);
    }
    delete contextHandle;
    return nullptr;
}

napi_value DisposeNodeTree(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetNodeContentFromNapiValue Failed %{public}d", result);
        return nullptr;
    }
    
    auto it = g_nodeMap.find(contentHandle);
    if (it == g_nodeMap.end()) {
        return nullptr;
    }
    auto rootNode = it->second;
    result = OH_ArkUI_NodeContent_RemoveNode(contentHandle, rootNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_RemoveNode Failed %{public}d", result);
        return nullptr;
    }
    g_nodeMap.erase(contentHandle);
    return nullptr;
}
} // namespace NativeModule