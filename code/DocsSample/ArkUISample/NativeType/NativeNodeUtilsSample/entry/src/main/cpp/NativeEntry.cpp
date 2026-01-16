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

// NativeEntry.cpp

#include <ArkUITextNode.h>
#include <ArkUITextInputNode.h>
#include <ArkUIListItemAdapter.h>
#include <ArkUIListNode.h>
#include <ArkUIListItemNode.h>
#include <CreateNode.h>
#include <hilog/log.h>
#include "Drawing.h"
#include <map>
#include <thread>
// [Start arkUICustomNodeCpp_start]
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <js_native_api.h>

#include "NativeEntry.h"
#include "ArkUICustomContainerNode.h"
#include "ArkUICustomNode.h"

// 全局环境变量声明
static napi_env g_env = nullptr;
// [StartExclude arkUICustomNodeCpp_start]
// [Start Interface_entrance_mounting_file]
#include "NativeEntry.h"
#include "LazyTextListExample.h"
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <js_native_api.h>
#include <uv.h>
// [Start normalTextListExample_start]
// [EndExclude arkUICustomNodeCpp_start]
namespace NativeModule {
// [StartExclude Interface_entrance_mounting_file]
// [StartExclude normalTextListExample_start]
// [StartExclude arkUICustomNodeCpp_start]
#define FRAMEWORK_NODE_TREE_NUMBER 4 // 在框架线程创建组件树的数量。
#define USER_NODE_TREE_NUMBER 3      // 在开发者线程创建组件树的数量。
// [EndExclude arkUICustomNodeCpp_start]
#define SIZE_150 150
// [StartExclude arkUICustomNodeCpp_start]
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
void CreateNodeTree(void *asyncUITaskData)
{
    auto asyncData = static_cast<AsyncData *>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    // 创建组件树根节点。
    auto rowNode = std::make_shared<ArkUIRowNode>();
    asyncData->child = rowNode;

    // 创建button组件。
    auto buttonNode1 = std::make_shared<ArkUIButtonNode>();
    ArkUI_AttributeItem label_item = {.string = asyncData->label.c_str()};
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
    int32_t size = 150;
    // 设置button组件的width属性。
    buttonNode1->SetWidth(size);

    // 创建button组件。
    auto buttonNode2 = std::make_shared<ArkUIButtonNode>();
    ArkUI_AttributeItem label_item2 = {.string = asyncData->label.c_str()};
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
    buttonNode2->SetWidth(size);

    // 把组件挂载到组件树上。
    rowNode->AddChild(buttonNode1);
    rowNode->AddChild(buttonNode2);
}

// 把组件树挂载到UI组件主树上。
void MountNodeTree(void *asyncUITaskData)
{
    auto asyncData = static_cast<AsyncData *>(asyncUITaskData);
    if (!asyncData) {
        return;
    }
    auto parent = asyncData->parent;
    auto child = asyncData->child;
    // 把组件树挂载到UI组件主树上。
    parent->AddChild(child);
    delete asyncData;
}

void CreateNodeOnFrameworkThread(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent)
{
    for (int i = 0; i < FRAMEWORK_NODE_TREE_NUMBER; i++) {
        // UI线程创建子树根节点，保证scroll的子节点顺序。
        auto columnItem = std::make_shared<ArkUIColumnNode>();
        parent->AddChild(columnItem);
        AsyncData *asyncData = new AsyncData();
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

void CreateNodeOnUserThread(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent)
{
    auto columnItem = std::make_shared<ArkUIColumnNode>();
    parent->AddChild(columnItem);
    // 在开发者创建的非UI线程上创建组件树。
    std::thread userThread([columnItem, contextHandle]() {
        for (int i = 0; i < USER_NODE_TREE_NUMBER; i++) {
            AsyncData *asyncData = new AsyncData();
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

void CreateNodeOnUserThreadAndWait(ArkUI_ContextHandle contextHandle, std::shared_ptr<ArkUIColumnNode> parent)
{
    auto columnItem = std::make_shared<ArkUIColumnNode>();
    parent->AddChild(columnItem);
    // 在开发者创建的非UI线程上创建组件树。
    std::thread userThread([columnItem, contextHandle]() {
        for (int i = 0; i < USER_NODE_TREE_NUMBER; i++) {
            AsyncData *asyncData = new AsyncData();
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

napi_value CreateNodeTreeOnMultiThread(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    OH_LOG_ERROR(LOG_APP, "kkk OH_ArkUI_GetNodeContentFromNapiValue Failed %{public}d");
    // 获取ArkTS侧组件挂载点。
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
    CreateNodeOnFrameworkThread(g_contextHandle, columnNode);
    // 在开发者创建的非UI线程中创建组件。
    CreateNodeOnUserThread(g_contextHandle, columnNode);
    CreateNodeOnUserThreadAndWait(g_contextHandle, columnNode);
    return nullptr;
}

struct NodeAndContent {
    std::shared_ptr<ArkUIBaseNode> node;
};

std::shared_ptr<ArkUIBaseNode> CreateCustomPropertyExample()
{
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    float textW = 200;
    float testH = 50;
    
    auto textSave = std::make_shared<ArkUITextNode>();
    textSave->SetSize(textW, testH);
    textSave->SetTextContent("保存自定义属性");
    auto textRead = std::make_shared<ArkUITextNode>();
    textRead->SetSize(textW, testH);
    textRead->SetTextContent("读取并打印自定义属性");
    
    NodeAndContent* input = new NodeAndContent{ .node = columnNode };
    textSave->RegisterOnClick([](ArkUI_NodeEvent *event) {
        auto input = (NodeAndContent *)OH_ArkUI_NodeEvent_GetUserData(event);
        input->node->AddCustomProperty("testKey", "testValue");
        }, input);
    textRead->RegisterOnClick([](ArkUI_NodeEvent *event) {
        auto input = (NodeAndContent *)OH_ArkUI_NodeEvent_GetUserData(event);
        auto value = input->node->GetCustomProperty("testKey");
        }, input);

    auto textRoot = std::make_shared<ArkUITextNode>();
    textRoot->SetSize(textW, testH);
    textRoot->SetTextContent("打印根节点信息");
    textRoot->RegisterOnClick(
        [](ArkUI_NodeEvent *event) {
            auto input = (NodeAndContent *)OH_ArkUI_NodeEvent_GetUserData(event);
            input->node->GetCurrentPageRootNode();
        }, nullptr);

    auto textSearch = std::make_shared<ArkUITextNode>();
    textSearch->SetSize(textW, testH);
    textSearch->SetTextContent("打印Column的第一个子节点信息");
    textSearch->RegisterOnClick(
        [](ArkUI_NodeEvent *event) {
            auto input = (NodeAndContent *)OH_ArkUI_NodeEvent_GetUserData(event);
            input->node->GetActiveChildrenByIndex(0);
        }, nullptr);

    columnNode->AddChild(textSave);
    columnNode->AddChild(textRead);
    return columnNode;
}

// 自定义属性Demo
napi_value CreateCustomPropertyDemo(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTS侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }

    // 创建Native侧组件树根节点。
    auto scrollNode = std::make_shared<ArkUIScrollNode>();
    // 将Native侧组件树根节点挂载到UI主树上。
    result = OH_ArkUI_NodeContent_AddNode(contentHandle, scrollNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }
    // 保存Native侧组件树。
    g_nodeMap[contentHandle] = scrollNode;
    
    auto columnNode = CreateCustomPropertyExample();

    scrollNode->AddChild(columnNode);
    return nullptr;
}

std::shared_ptr<ArkUIBaseNode> CreateLazyTextListExample(napi_env env)
{
    // 创建组件并挂载
    // 1：创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    // 2：创建ListItem懒加载组件并挂载到List上。
    auto adapter = std::make_shared<ArkUIListItemAdapter>();
    list->SetLazyAdapter(adapter);
    return list;
}

// 懒加载列表示例
napi_value CreateNodeAdapterDemo(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    // 创建懒加载文本列表
    auto node = CreateLazyTextListExample(env);

    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(node);
    return nullptr;
}

napi_value DisposeNodeTree(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取ArkTS侧组件挂载点。
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
// [EndExclude normalTextListExample_start]
std::shared_ptr<ArkUIBaseNode> CreateTextListExample()
{
    // 创建组件并挂载
    // 1：使用智能指针创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    list->SetScrollBarState(true);
    // 2：创建ListItem子组件并挂载到List上。
    for (int32_t i = 0; i < 30; ++i) { // 创建30个子项目。
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        int32_t fontSize = 16;
        textNode->SetFontSize(fontSize);
        textNode->SetFontColor(0xFFff00ff);
        textNode->SetPercentWidth(1);
        int32_t width = 300;
        int32_t height = 100;
        textNode->SetWidth(width);
        textNode->SetHeight(height);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        // 在当前节点注册布局回调
        textNode->SetLayoutCallBack(i);
        // 在当前节点注册绘制送显回调
        textNode->SetDrawCallBack(i);
        listItem->InsertChild(textNode, i);
        list->AddChild(listItem);
    }
    return list;
}
// [StartExclude normalTextListExample_start]
napi_value GetContext(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_ContextHandle context = nullptr;
    // result 判断是否获取成功
    auto result = OH_ArkUI_GetContextFromNapiValue(env, args[0], &context);
    if (result == ARKUI_ERROR_CODE_NO_ERROR) {
        NativeEntry::GetInstance()->SetContextHandle(context);
    }
    return nullptr;
}

// 通过接口传递TS侧节点信息。
napi_value GetNodeHandle(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    ArkUI_NodeHandle handle = nullptr;
    // result 判断是否获取成功
    auto result = OH_ArkUI_GetNodeHandleFromNapiValue(env, args[0], &handle);
    if (result == ARKUI_ERROR_CODE_NO_ERROR) {
        NativeEntry::GetInstance()->SetNodeHandle(handle);
    }
    return nullptr;
}

// 通过key查询节点
napi_value GetNodeHandleById(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t maxValueLen = 1024;
    char ids[maxValueLen];
    size_t length = 0;
    napi_get_value_string_utf8(env, args[0], ids, maxValueLen, &length);
    ArkUI_NodeHandle handle = nullptr;
    // result 判断是否获取成功
    auto result = OH_ArkUI_NodeUtils_GetAttachedNodeHandleById(ids, &handle);
    // 节点获取成功，实现业务功能。
    if (result == ARKUI_ERROR_CODE_NO_ERROR) {}
    return nullptr;
}

// 通过id查询节点
napi_value GetNodeHandleByUniqueId(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    int32_t id = 0;
    napi_get_value_int32(env, args[0], &id);
    ArkUI_NodeHandle handle = nullptr;
    // result 判断是否获取成功
    auto result = OH_ArkUI_NodeUtils_GetNodeHandleByUniqueId(id, &handle);
    if (result == ARKUI_ERROR_CODE_NO_ERROR) {
        // 节点获取成功，实现业务功能。
    }
}

napi_value CreateDrawNode(napi_env env, napi_callback_info info)
{
    size_t argCnt = 1;
    int32_t ret;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "CreateNativeNode napi_get_cb_info failed");
    }
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    ArkUI_NodeHandle rootNode = test_draw(nodeAPI);
    if (rootNode == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "test_draw_rootNode", "转换NodeContent失败");
        return nullptr;
    }
    ret = OH_ArkUI_NodeContent_AddNode(nodeContentHandle, rootNode);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OH_ArkUI_NodeContent_AddNode_ret", "转换NodeContent失败");
        return nullptr;
    }
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        napi_throw_type_error(env, NULL, "napi_create_object failed");
        return nullptr;
    }
    return exports;
}

napi_value DisposeNodeTreeOnMultiThread(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取ArkTS侧组件挂载点。
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

// 获取窗口名称
void NativeEntry::GetWindowName()
{
    ArkUI_HostWindowInfo* windowInfo;
    // 给windowInfo结构体赋值。
    auto result = OH_ArkUI_NodeUtils_GetWindowInfo(nodeHandle_, &windowInfo);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return;
    }
    // 保存窗口名称到全局参数。
    windowName_ = OH_ArkUI_HostWindowInfo_GetName(windowInfo);
    // 结构体使用完成后，释放对应内存。
    OH_ArkUI_HostWindowInfo_Destroy(windowInfo);
}

// 注册事件总线，多次注册会覆盖前置注册的总线，可通过对组件addNodeEventReceiver实现同样效果。
void NativeEntry::RegisterNodeEventReceiver()
{
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        // 从组件事件中获取基础事件对象
        auto *inputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        // 从组件事件获取事件类型
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "eventInfo", "inputEvent = %{public}p", inputEvent);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "eventInfo", "eventType = %{public}d", eventType);
        auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        // 获取组件事件中的数字类型数据
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "eventInfo", "componentEvent = %{public}p", componentEvent);
        // 获取触发该事件的组件对象
        auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "eventInfo", "nodeHandle = %{public}p", nodeHandle);
        // 根据eventType来区分事件类型，进行差异化处理，其他获取事件信息的接口也可类似方式来进行差异化的处理
        switch (eventType) {
            case NODE_ON_CLICK_EVENT:{
                // 实现具体业务
                break;
            }
            default:{
                break;
            }
        }
    });
}

void NativeEntry::UnregisterNodeEventReceiver()
{
    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->unregisterNodeEventReceiver();
}
napi_value CreateNativeRoots(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent。
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    // 创建自定义容器和自定义绘制组件。
    auto node = std::make_shared<ArkUICustomContainerNode>();
    // 浅灰色。
    node->SetBackgroundColor(0xFFD5D5D5);
    auto customNode = std::make_shared<ArkUICustomNode>();
    // 深灰色。
    customNode->SetBackgroundColor(0xFF707070);
    customNode->SetWidth(SIZE_150);
    customNode->SetHeight(SIZE_150);
    node->AddChild(customNode);
    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);
    g_env = env;
    // 创建文本列表。
    auto list = CreateTextListExample();
    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(list);
    return nullptr;
}
// [EndExclude arkUICustomNodeCpp_start]
// [EndExclude Interface_entrance_mounting_file]
napi_value CreateNativeRoot(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent。
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    // 创建自定义容器和自定义绘制组件。
    auto node = std::make_shared<ArkUICustomContainerNode>();
    node->SetBackgroundColor(0xFFD5D5D5); // 浅灰色。
    auto customNode = std::make_shared<ArkUICustomNode>();
    customNode->SetBackgroundColor(0xFF707070); // 深灰色。
    customNode->SetWidth(SIZE_150);
    customNode->SetHeight(SIZE_150);
    node->AddChild(customNode);

    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(node);
    g_env = env;
    return nullptr;
}

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
{
    // 从管理类中释放Native侧对象。
    NativeEntry::GetInstance()->DisposeRootNode();
    return nullptr;
}
// [EndExclude normalTextListExample_start]
} // namespace NativeModule
// [End normalTextListExample_start]
// [End arkUICustomNodeCpp_start]
// [End Interface_entrance_mounting_file]