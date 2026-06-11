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

// [Start create_node_cpp_start]
// CreateNode.cpp
#include "CreateNode.h"

#include <cstdint>
#include <hilog/log.h>
#include <map>
#include <string>
#include <thread>
#include <napi/native_api.h>
#include <arkui/native_node_napi.h>

namespace NativeModule {
#define FRAMEWORK_NODE_TREE_NUMBER 4 // 在框架线程创建组件树的数量。
#define USER_NODE_TREE_NUMBER 3 // 在开发者线程创建组件树的数量。
struct AsyncData {
    napi_env env;
    std::shared_ptr<ArkUINode> parent = nullptr;
    std::shared_ptr<ArkUINode> child = nullptr;
    std::string label = "";
};

// 保存ArkTs侧NodeContent指针与Native侧节点树根节点的对应关系。
std::map<ArkUI_NodeContentHandle, std::shared_ptr<ArkUIBaseNode>> g_nodeMap;
ArkUI_ContextHandle g_contextHandle = nullptr;

// 创建组件树。
void CreateNodeTree(void *asyncUITaskData) {
    auto asyncData = static_cast<AsyncData*>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    // 创建组件树根节点。
    auto rowNode = std::make_shared<ArkUIRowNode>();
    asyncData->child = rowNode;

    // 创建button组件。
    auto buttonNode1 = std::make_shared<ArkUIButtonNode>();
    ArkUI_AttributeItem label_item = { .string = asyncData->label.c_str() };
    // 设置button组件的label属性。
    int32_t result = buttonNode1->SetLabel(label_item);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "Button SetLabel Failed %{public}d", result);
    }
    ArkUI_NumberValue value[] = {{.f32 = 5}, {.f32 = 5}, {.f32 = 5}, {.f32 = 5}};
    ArkUI_AttributeItem item = {value, 4};
    // 设置button组件的margin属性。
    result = buttonNode1->SetMargin(item);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "Button SetMargin Failed %{public}d", result);
    }
    // 设置button组件的width属性。
    buttonNode1->SetWidth(150);

   // 创建button组件。
    auto buttonNode2 = std::make_shared<ArkUIButtonNode>();
    ArkUI_AttributeItem label_item2 = { .string = asyncData->label.c_str() };
    // 设置button组件的label属性。
    result = buttonNode2->SetLabel(label_item2);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "Button SetLabel Failed %{public}d", result);
    }
    ArkUI_NumberValue value2[] = {{.f32 = 5}, {.f32 = 5}, {.f32 = 5}, {.f32 = 5}};
    ArkUI_AttributeItem item2 = {value2, 4};
    // 设置button组件的margin属性。
    result = buttonNode1->SetMargin(item2);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "Button SetMargin Failed %{public}d", result);
    }
    // 设置button组件的width属性。
    buttonNode2->SetWidth(150);

    // 把组件挂载到组件树上。
    rowNode->AddChild(buttonNode1);
    rowNode->AddChild(buttonNode2);
}

// 把组件树挂载到UI组件主树上。
void MountNodeTree(void *asyncUITaskData) {
    auto asyncData = static_cast<AsyncData*>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    auto parent = asyncData->parent;
    auto child = asyncData->child;
    // 把组件树挂载到UI组件主树上。
    parent->AddChild(child);
    delete asyncData;
}

void CreateNodeOnFrameworkThread(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent) {
    for (int i = 0; i < FRAMEWORK_NODE_TREE_NUMBER; i++) {
        // UI线程创建子树根节点，保证scroll的子节点顺序。
        auto columnItem = std::make_shared<ArkUIColumnNode>();
        parent->AddChild(columnItem);
        AsyncData* asyncData = new AsyncData();
        asyncData->parent = columnItem;
        asyncData->label = "OnFwkThread";
        // 使用框架提供的非UI线程创建组件树，创建完成后回到UI线程挂载到主树上。
        int32_t result = OH_ArkUI_PostAsyncUITask(contextHandle, asyncData, CreateNodeTree, MountNodeTree);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "OH_ArkUI_PostAsyncUITask Failed %{public}d", result);
            delete asyncData;
        }
    }
}

void CreateNodeOnUserThread(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent) {
    auto columnItem = std::make_shared<ArkUIColumnNode>();
    parent->AddChild(columnItem);
    // 在开发者创建的非UI线程上创建组件树。
    std::thread userThread([columnItem, contextHandle]() {
        for (int i = 0; i < USER_NODE_TREE_NUMBER; i++) {
            AsyncData* asyncData = new AsyncData();
            asyncData->parent = columnItem;
            asyncData->label = "OnUserThread1";
            CreateNodeTree(asyncData);
            // 组件树创建完成后回到UI线程挂载到主树上。
            int32_t result = OH_ArkUI_PostUITask(contextHandle, asyncData, MountNodeTree);
            if (result != ARKUI_ERROR_CODE_NO_ERROR) {
                OH_LOG_ERROR(LOG_APP, "OH_ArkUI_PostUITask Failed %{public}d", result);
                delete asyncData;
            }
        }
    });
    userThread.detach();
}

void CreateNodeOnUserThreadAndWait(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent) {
    auto columnItem = std::make_shared<ArkUIColumnNode>();
    parent->AddChild(columnItem);
    // 在开发者创建的非UI线程上创建组件树。
    std::thread userThread([columnItem, contextHandle]() {
        for (int i = 0; i < USER_NODE_TREE_NUMBER; i++) {
            AsyncData* asyncData = new AsyncData();
            asyncData->parent = columnItem;
            asyncData->label = "OnUserThread2";
            CreateNodeTree(asyncData);
            // 组件树创建完成后回到UI线程挂载到主树上，等待挂载完成后继续创建剩余组件。
            int32_t result = OH_ArkUI_PostUITaskAndWait(contextHandle, asyncData, MountNodeTree);
            if (result != ARKUI_ERROR_CODE_NO_ERROR) {
                OH_LOG_ERROR(LOG_APP, "OH_ArkUI_PostUITask Failed %{public}d", result);
                delete asyncData;
            }
        }
    });
    userThread.detach();
}

napi_value CreateNodeTreeOnMultiThread(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = { nullptr, nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取ArkTs侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetNodeContentFromNapiValue Failed %{public}d", result);
        return nullptr;
    }

    // 获取上下文对象指针。
    if (!g_contextHandle) {
        result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &g_contextHandle);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "OH_ArkUI_GetContextFromNapiValue Failed %{public}d", result);
            delete g_contextHandle;
            g_contextHandle = nullptr;
            return nullptr;
        }
    }

    // 创建Native侧组件树根节点。
    auto scrollNode = std::make_shared<ArkUIScrollNode>();
    // 将Native侧组件树根节点挂载到UI主树上。
    result = OH_ArkUI_NodeContent_AddNode(contentHandle, scrollNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        return nullptr;
    }
    // 保存Native侧组件树。
    g_nodeMap[contentHandle] = scrollNode;

    auto columnNode = std::make_shared<ArkUIColumnNode>();
    scrollNode->AddChild(columnNode);
    // 在框架提供的线程池中创建组件。
    CreateNodeOnFrameworkThread(g_contextHandle,columnNode);
    // 在开发者创建的非UI线程中创建组件。
    CreateNodeOnUserThread(g_contextHandle,columnNode);
    CreateNodeOnUserThreadAndWait(g_contextHandle,columnNode);
    return nullptr;
}

napi_value DisposeNodeTreeOnMultiThread(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取ArkTs侧组件挂载点。
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
    // 将Native侧组件树根节点从UI主树上卸载。
    result = OH_ArkUI_NodeContent_RemoveNode(contentHandle, rootNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_RemoveNode Failed %{public}d", result);
        return nullptr;
    }
    // 释放Native侧组件树。
    g_nodeMap.erase(contentHandle);
    return nullptr;
}
} // namespace NativeModule
// [End create_node_cpp_start]
#endif

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
