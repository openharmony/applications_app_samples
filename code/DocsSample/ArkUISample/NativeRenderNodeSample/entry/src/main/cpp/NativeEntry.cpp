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
#include <arkui/native_animate.h>
#include <arkui/native_node_napi.h>
#include <ArkUICustomNode.h>
#include <arkui/native_render.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include <CreateNode.h>
#include "NativeEntry.h"
#include <map>
#include <native_drawing/drawing_pen.h>
#include <thread>

namespace NativeModule {

#define FRAMEWORK_NODE_TREE_NUMBER 4 // 在框架线程创建组件树的数量。
#define USER_NODE_TREE_NUMBER 3      // 在开发者线程创建组件树的数量。
struct AsyncData {
    napi_env env;
    std::shared_ptr<ArkUINode> parent = nullptr;
    std::shared_ptr<ArkUINode> child = nullptr;
    std::string label = "";
};

// 保存ArkTs侧NodeContent指针与Native侧节点树根节点的对应关系。
std::map<ArkUI_NodeContentHandle, std::shared_ptr<ArkUIBaseNode>> g_nodeMap;
ArkUI_ContextHandle g_contextHandle = nullptr;
float g_contentWidth = 400;
float g_contentHeight = 800;
float g_numBigSize = 1000;
float g_num100 = 100;
float g_num150 = 150;
float g_num200 = 200;
float g_num300 = 300;
float g_num600 = 600;

ArkUI_NodeHandle CreateRenderNodeTreeExample(ArkUI_NativeNodeAPI_1 *nodeAPI)
{
    ArkUI_NodeHandle rootNode = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue valueWidth[] = {g_num300};
    ArkUI_AttributeItem itemWidth = {valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(rootNode, NODE_WIDTH, &itemWidth);
    ArkUI_NumberValue valueHeight[] = {g_num600};
    ArkUI_AttributeItem itemHeight = {valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(rootNode, NODE_HEIGHT, &itemHeight);

    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem content = {.string = "查看日志打印，确认renderNode上树情况"};
    nodeAPI->setAttribute(text, NODE_TEXT_CONTENT, &content);

    ArkUI_NodeHandle Custom = nodeAPI->createNode(ARKUI_NODE_CUSTOM);

    // 节点操作类测试
    // 测试挂载创建 result = 0
    auto rsNodeRoot = OH_ArkUI_RenderNodeUtils_CreateNode();
    auto rsNodeFirstChild = OH_ArkUI_RenderNodeUtils_CreateNode();
    auto rsNodeSecondChild = OH_ArkUI_RenderNodeUtils_CreateNode();
    auto rsNodeThirdChild = OH_ArkUI_RenderNodeUtils_CreateNode();

    // 测试挂载非custom节点 result = 401
    auto result = OH_ArkUI_RenderNodeUtils_AddRenderNode(column, rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test001 result=%{public}d", result);

    // 测试挂载正常挂载 result = 0
    result = OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom, rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test002 result=%{public}d", result);

    // 测试挂载根节点重复挂载 result = 401
    result = OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom, rsNodeFirstChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test003 result=%{public}d", result);

    // 测试移除根节点 result = 0
    result = OH_ArkUI_RenderNodeUtils_RemoveRenderNode(Custom, rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_RemoveRenderNode test001 result=%{public}d", result);

    // 测试再次挂载 result = 0
    result = OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom, rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test004 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 0
    int32_t count = -1;
    result = OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test001 result=%{public}d, count=%{public}d", result,
                 count);

    // 测试挂载RenderNode result = 0
    result = OH_ArkUI_RenderNodeUtils_AddChild(rsNodeRoot, rsNodeFirstChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test002 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 1
    result = OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test002 result=%{public}d, count=%{public}d", result,
                 count);

    // 测试挂载RenderNode result = 0
    result = OH_ArkUI_RenderNodeUtils_AddChild(rsNodeRoot, rsNodeSecondChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test003 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 2
    result = OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test003 result=%{public}d, count=%{public}d", result,
                 count);

    // 测试移除RenderNode result = 0
    result = OH_ArkUI_RenderNodeUtils_RemoveChild(rsNodeRoot, rsNodeSecondChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_RemoveChild test001 result=%{public}d", result);

    // 测试移除RenderNode result = 0, count = 1
    result = OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_RemoveChild test002 result=%{public}d, count=%{public}d", result, count);

    auto nodeForDispose = OH_ArkUI_RenderNodeUtils_CreateNode();
    result = OH_ArkUI_RenderNodeUtils_DisposeNode(nodeForDispose);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_DisposeNode test001 result=0-%{public}d", result);
    nodeForDispose = nullptr; // Dispose后需手动将指针置为空。
    result = OH_ArkUI_RenderNodeUtils_AddChild(rsNodeRoot, nodeForDispose);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_DisposeNode test002 result=401-%{public}d", result);

    // 测试标脏CustomNode result = 0, count = 1 pass
    result = OH_ArkUI_RenderNodeUtils_Invalidate(Custom);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_Invalidate test002 except-result=0 - %{public}d", result);

    // 初始异常值测试
    result = OH_ArkUI_RenderNodeUtils_SetSize(rsNodeRoot, -1, 1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "error test001 count=106405-%{public}d", result);

    ArkUI_RenderNodeHandle n1;
    result = OH_ArkUI_RenderNodeUtils_GetChild(rsNodeRoot, -1, &n1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "error test002 count=106405-%{public}d", result);

    ArkUI_RenderNodeHandle *nodeList222;
    result = OH_ArkUI_RenderNodeUtils_GetChildren(rsNodeRoot, &nodeList222, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "error test003 count=0-%{public}d", result);

    OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionRadius(nullptr, 0);

    uint32_t c = 0;
    OH_ArkUI_RenderNodeUtils_GetColorPropertyValue(nullptr, &c);

    // 测试getChild getFirstChild getNextSlibing getPreviewSlibging insertAfterChild 通过不同尺寸大小判断获取的子节点下标。
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeRoot, 300, 300); //设置根节点为300的尺寸。
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNodeRoot, 0xFFFFFFFF);
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeFirstChild, g_num100, g_num100); //设置第一个子节点为100的尺寸。
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeSecondChild, 200, 200); //设置第二个子节点为200的尺寸。
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeThirdChild, 250, 250); //设置第三个子节点为250的尺寸。

    result = OH_ArkUI_RenderNodeUtils_AddChild(rsNodeRoot, rsNodeThirdChild);
    OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test004 count=2-%{public}d", count);

    result = OH_ArkUI_RenderNodeUtils_InsertChildAfter(rsNodeRoot, rsNodeSecondChild, rsNodeFirstChild);
    OH_ArkUI_RenderNodeUtils_GetChildrenCount(rsNodeRoot, &count);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_InsertChildAfter test001 result=0-%{public}d count=3-%{public}d", result,
                 count);

    int w = 0;

    ArkUI_RenderNodeHandle nodeTemp;

    result = OH_ArkUI_RenderNodeUtils_GetFirstChild(rsNodeRoot, &nodeTemp);
    OH_ArkUI_RenderNodeUtils_GetSize(nodeTemp, &w, &w);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChild test001 result=0-%{public}d w=100-%{public}d", result, w);

    result = OH_ArkUI_RenderNodeUtils_GetChild(rsNodeRoot, 1, &nodeTemp);
    OH_ArkUI_RenderNodeUtils_GetSize(nodeTemp, &w, &w);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChild test002 result=0-%{public}d w=200-%{public}d", result, w);

    result = OH_ArkUI_RenderNodeUtils_GetNextSibling(rsNodeSecondChild, &nodeTemp);
    OH_ArkUI_RenderNodeUtils_GetSize(nodeTemp, &w, &w);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetNextSibling test001 result=0-%{public}d w=250-%{public}d", result, w);

    result = OH_ArkUI_RenderNodeUtils_GetPreviousSibling(rsNodeSecondChild, &nodeTemp);
    OH_ArkUI_RenderNodeUtils_GetSize(nodeTemp, &w, &w);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPreviousSibling test001 result=0-%{public}d w=100-%{public}d", result,
                 w);

    ArkUI_RenderNodeHandle *nodeList;
    result = OH_ArkUI_RenderNodeUtils_GetChildren(rsNodeRoot, &nodeList, &count);
    OH_ArkUI_RenderNodeUtils_GetSize(nodeList[0], &w, &w);
    OH_LOG_Print(
        LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
        "OH_ArkUI_RenderNodeUtils_GetChildren test001 result=0-%{public}d w=100-%{public}d, count=3-%{public}d",
        result, w, count);

    nodeAPI->setAttribute(Custom, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom, NODE_HEIGHT, &itemHeight);

    nodeAPI->addChild(column, text);
    nodeAPI->addChild(column, Custom);
    nodeAPI->addChild(rootNode, column);
    return rootNode;
}

ArkUI_NodeHandle testRenderNodeProperty(ArkUI_NativeNodeAPI_1 *nodeAPI)
{
    ArkUI_NodeHandle scroll = nodeAPI->createNode(ARKUI_NODE_SCROLL);
    ArkUI_NumberValue valueWidth[] = {g_contentWidth};
    ArkUI_AttributeItem itemWidth = {valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_WIDTH, &itemWidth);
    ArkUI_NumberValue valueHeight[] = {g_contentHeight};
    ArkUI_AttributeItem itemHeight = {valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_HEIGHT, &itemHeight);
    valueHeight[0].u32 = 0xff00F100;
    nodeAPI->setAttribute(scroll, NODE_BACKGROUND_COLOR, &itemHeight);

    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    nodeAPI->setAttribute(column, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(column, NODE_HEIGHT, &itemHeight);
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem content = {.string = "RenderNode 属性设置表现"};
    nodeAPI->setAttribute(text, NODE_TEXT_CONTENT, &content);

    ArkUI_NodeHandle Custom = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    valueWidth[0].f32 = g_num100;

    nodeAPI->setAttribute(Custom, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, text);
    nodeAPI->addChild(column, Custom);

    nodeAPI->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        int32_t targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        ArkUI_NodeHandle node = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        ArkUI_NodeHandle custom = (ArkUI_NodeHandle)OH_ArkUI_NodeEvent_GetUserData(event);
        if (targetId == 1) {
            auto *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
                OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
            ArkUI_NumberValue valueWidth[] = {481};
            ArkUI_AttributeItem itemWidth = {valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue)};
            nodeAPI->setAttribute(custom, NODE_WIDTH, &itemWidth);
        }
    });

    auto rsNodeRoot = OH_ArkUI_RenderNodeUtils_CreateNode();
    auto result = OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom, rsNodeRoot);
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeRoot, g_num150, g_num150);

    // 属性设置类测试
    // 测试颜色属性获取 result = 0, clipTo = 0
    int32_t clipToFrameResult = true;
    result = OH_ArkUI_RenderNodeUtils_SetClipToFrame(rsNodeRoot, true);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetClipToFrame result=%{public}d", result);
    // 测试颜色属性获取 result = 0, clipTo = 1
    result = OH_ArkUI_RenderNodeUtils_GetClipToFrame(rsNodeRoot, &clipToFrameResult);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetClipToFrame test002 result=%{public}d, clipToFrame=%{public}d",
                 result, clipToFrameResult);
    uint32_t backgroundColor = 0;
    ArkUI_NodeHandle Custom1 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom1, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom1, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom1);
    auto rsNode1 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode1, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode1, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom1, rsNode1);
    result = OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode1, 0xFF0000FF);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBackgroundColor result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetBackgroundColor(rsNode1, &backgroundColor);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetBackgroundColor result=%{public}d, backgroundColor=%{public}d",
                 result, backgroundColor);

    // position
    int32_t positionX = 0;
    int32_t positionY = 0;
    ArkUI_NodeHandle Custom2 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom2, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom2, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom2);
    auto rsNode2 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode2, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode2, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom2, rsNode2);
    result = OH_ArkUI_RenderNodeUtils_SetPosition(rsNode2, g_num200, g_num200);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetPosition result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetPosition(rsNode2, &positionX, &positionY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPosition result=%{public}d, x=%{public}d , y=%{public}d", result,
                 positionX, positionY);

    // clipToBounds
    int32_t clipToBounds = 0;
    ArkUI_NodeHandle Custom3 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom3, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom3, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom3);
    auto rsNode3 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode3, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode3, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom3, rsNode3);
    result = OH_ArkUI_RenderNodeUtils_SetClipToBounds(rsNode3, true);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetClipToBounds result=%{public}d", clipToBounds);

    result = OH_ArkUI_RenderNodeUtils_GetClipToBounds(rsNode3, &clipToBounds);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetClipToBounds result=%{public}d, clipToBounds=%{public}d", result,
                 clipToBounds);

    float opacity = 0;
    ArkUI_NodeHandle Custom4 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom4, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom4, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom4);
    auto rsNode4 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode4, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode4, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom4, rsNode4);
    result = OH_ArkUI_RenderNodeUtils_SetOpacity(rsNode4, 1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetOpacity result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetOpacity(rsNode4, &opacity);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetOpacity result=%{public}d, opacity=%{public}f", result, opacity);

    // size
    int32_t sizeWidth = 0;
    int32_t sizeHeight = 0;
    ArkUI_NodeHandle Custom5 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom5, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom5, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom5);
    auto rsNode5 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode5, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode5, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom5, rsNode5);
    result = OH_ArkUI_RenderNodeUtils_SetSize(rsNode5, g_num200, g_num200);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetSize result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetSize(rsNode5, &sizeWidth, &sizeHeight);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetSize result=%{public}d, width=%{public}d, height=%{public}d",
                 result, sizeWidth, sizeHeight);

    // Pivot
    float pivotX = 0;
    float pivotY = 0;
    ArkUI_NodeHandle Custom6 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom6, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom6, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom6);
    auto rsNode6 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode6, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode6, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom6, rsNode6);
    result = OH_ArkUI_RenderNodeUtils_GetPivot(rsNode6, &pivotX, &pivotY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPivot1 result=%{public}d, x=%{public}f , y=%{public}f", result,
                 pivotX, pivotY);
    result = OH_ArkUI_RenderNodeUtils_SetPivot(rsNode6, g_num200, g_num100);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetPivot2 result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetPivot(rsNode6, &pivotX, &pivotY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPivot3 result=%{public}d, x=%{public}f , y=%{public}f", result,
                 pivotX, pivotY);

    // scale
    float scaleX = 0;
    float scaleY = 0;
    ArkUI_NodeHandle Custom7 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom7, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom7, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom7);
    auto rsNode7 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode7, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode7, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom7, rsNode7);
    result = OH_ArkUI_RenderNodeUtils_SetScale(rsNode7, 1.5, 1.5); //xy轴各缩放1.5倍。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetScale result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetScale(rsNode7, &scaleX, &scaleY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetScale result=%{public}d, x=%{public}f , y=%{public}f", result,
                 scaleX, scaleY);

    // translation
    float translationX = 0;
    float translationY = 0;
    ArkUI_NodeHandle Custom8 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom8, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom8, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom5);
    auto rsNode8 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode8, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode8, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom8, rsNode8);
    result = OH_ArkUI_RenderNodeUtils_SetTranslation(rsNode8, 30, 60); //设置x=30，y=60的位移。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetTranslation result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetTranslation(rsNode8, &translationX, &translationY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetTranslation result=%{public}d, x=%{public}f , y=%{public}f",
                 result, translationX, translationY);

    // rotation
    float rotationX = 0;
    float rotationY = 0;
    float rotationZ = 0;
    ArkUI_NodeHandle Custom9 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom9, NODE_WIDTH, &itemWidth);

    nodeAPI->setAttribute(Custom9, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom9);
    auto rsNode9 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode9, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode9, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom9, rsNode9);
    result = OH_ArkUI_RenderNodeUtils_SetRotation(rsNode9, 60, 150, 30); //设置x=60，y=150，z=30的旋转度数。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetRotation result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetRotation(rsNode9, &rotationX, &rotationY, &rotationZ);
    OH_LOG_Print(
        LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
        "OH_ArkUI_RenderNodeUtils_GetRotation result=%{public}d, x=%{public}f , y=%{public}f , z=%{public}f",
        result, rotationX, rotationY, rotationZ);

    // transform
    ArkUI_NodeHandle Custom10 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom10, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom10, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom10);
    auto rsNode10 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode10, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode10, 0xFF1f10FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom10, rsNode10);
    float matrix[] = {0.866, 0.433, -0.25, 0, 0, 0.866, 0.5, 0, 0.5, -0.25, 0.866, 0, // x y 旋转各30度
                      30,    30,    0,     1};                                        // 往x 平移30 y 平移 30
    result = OH_ArkUI_RenderNodeUtils_SetTransform(rsNode10, matrix);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetTransform result=%{public}d", result);

    // shadow
    ArkUI_NodeHandle Custom11 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom11, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom11, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom11);
    auto rsNode11 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode11, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode11, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom11, rsNode11);
    uint32_t shadowColor = 0;
    result = OH_ArkUI_RenderNodeUtils_SetShadowColor(rsNode11, 0x80000000); // 设置50%的透明度
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowColor result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetShadowColor(rsNode11, &shadowColor);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowColor result=%{public}d, shadowColor=%{public}d", result,
                 shadowColor);
    int32_t shadowOffsetX = 0;
    int32_t shadowOffsetY = 0;
    result = OH_ArkUI_RenderNodeUtils_SetShadowOffset(rsNode11, 15, 25); // 设置15,25的偏移。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowOffset result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetShadowOffset(rsNode11, &shadowOffsetX, &shadowOffsetY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowOffset result=%{public}d, shadowOffsetX=%{public}d, "
                 "shadowOffsetY=%{public}d",
                 result, shadowOffsetX, shadowOffsetY);

    float alpha = 0;
    result = OH_ArkUI_RenderNodeUtils_GetShadowAlpha(rsNode11, &alpha);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowAlpha result=%{public}d, alpha=%{public}f", result, alpha);

    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowAlpha result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetShadowAlpha(rsNode11, &alpha);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowAlpha result=%{public}d, alpha=%{public}f", result, alpha);

    float elevation = 0;

    result = OH_ArkUI_RenderNodeUtils_GetShadowElevation(rsNode11, &elevation);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowElevation result=%{public}d, elevation=%{public}f", result,
                 elevation);

    result = OH_ArkUI_RenderNodeUtils_SetShadowElevation(rsNode11, 0.5); //设置0.5的阴影高度。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowElevation result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetShadowElevation(rsNode11, &elevation);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowElevation result=%{public}d, elevation=%{public}f", result,
                 elevation);

    float radius = 0;
    result = OH_ArkUI_RenderNodeUtils_SetShadowRadius(rsNode11, 15); //设置15px的应用弧度。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowRadius result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetShadowRadius(rsNode11, &radius);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowRadius result=%{public}d, clipTo=%{public}f", result,
                 radius);

    // BorderStyle
    ArkUI_NodeHandle Custom12 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom12, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom12, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom12);
    auto rsNode12 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode12, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode12, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom12, rsNode12);
    auto styleOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderStyleOption();
    OH_ArkUI_RenderNodeUtils_GetBorderStyle(rsNode12, &styleOption);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption,
        ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption,
        ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption,
        ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(
        styleOption, ArkUI_BorderStyle::ARKUI_BORDER_STYLE_DOTTED, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
    result = OH_ArkUI_RenderNodeUtils_SetBorderStyle(rsNode12, styleOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderStyle result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetBorderStyle(rsNode12, &styleOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetBorderStyle result=%{public}d", result);
    OH_ArkUI_RenderNodeUtils_DisposeNodeBorderStyleOption(styleOption);

    // BorderWidth
    auto widthOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderWidthOption();
    float borderW = 20;
    OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, 0,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, borderW,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, borderW,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, borderW,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
    result = OH_ArkUI_RenderNodeUtils_SetBorderWidth(rsNode12, widthOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderWidth result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetBorderWidth(rsNode12, &widthOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetBorderWidth result=%{public}d", result);
    OH_ArkUI_RenderNodeUtils_DisposeNodeBorderWidthOption(widthOption);

    // BorderColor
    auto colorOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderColorOption();
    OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, 0xFFFFFFFF,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, 0xFFFFFFFF,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, 0xFFFFFFFF,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, 0xFFFFFFFF,
                                                               ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
    result = OH_ArkUI_RenderNodeUtils_SetBorderColor(rsNode12, colorOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderColor result=%{public}d", result);

    auto colorOption2 = OH_ArkUI_RenderNodeUtils_CreateNodeBorderColorOption();
    result = OH_ArkUI_RenderNodeUtils_GetBorderColor(rsNode12, &colorOption2);
    OH_ArkUI_RenderNodeUtils_DisposeNodeBorderColorOption(colorOption);
    OH_ArkUI_RenderNodeUtils_DisposeNodeBorderColorOption(colorOption2);

    // BorderRadius
    auto radiusOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderRadiusOption();
    int32_t rad = 30;
    OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
        radiusOption, rad, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_TOP_RIGHT);
    OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
        radiusOption, rad, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_BOTTOM_LEFT);
    result = OH_ArkUI_RenderNodeUtils_SetBorderRadius(rsNode12, radiusOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderStyle result=%{public}d", result);

    result = OH_ArkUI_RenderNodeUtils_GetBorderRadius(rsNode12, &radiusOption);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetBorderStyle result=%{public}d", result);
    OH_ArkUI_RenderNodeUtils_DisposeNodeBorderRadiusOption(radiusOption);

    // drawRegion
    ArkUI_NodeHandle Custom13 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom13, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom13, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom13);
    auto rsNode13 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode13, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode13, 0xFFFF00FF);
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom13, rsNode13);

    auto rsNodeDR = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNodeDR, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetPosition(rsNodeDR, 75, 75); // 设置大小一半，75的偏移，便于确认效果。
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNodeDR, 0xFF0000FF);
    OH_ArkUI_RenderNodeUtils_AddChild(rsNode13, rsNodeDR);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetDrawRegion result=%{public}d", result);

    // markNodeGroup
    ArkUI_NodeHandle Custom14 = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    nodeAPI->setAttribute(Custom14, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom14, NODE_HEIGHT, &itemWidth);
    nodeAPI->addChild(column, Custom14);
    auto rsNode14 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode14, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode14, 0xFFFF00FF);
    result = OH_ArkUI_RenderNodeUtils_SetOpacity(rsNode14, 0.5); // 设置0.5透明度。
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom14, rsNode14);

    auto rsNode15 = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_SetSize(rsNode15, g_num150, g_num150);
    OH_ArkUI_RenderNodeUtils_SetPosition(rsNode15, 75, 75); // 设置大小一半，75的偏移，便于确认效果。
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(rsNode15, 0xFFFFFFFF);
    result = OH_ArkUI_RenderNodeUtils_SetOpacity(rsNode15, 1);
    OH_ArkUI_RenderNodeUtils_AddChild(rsNode14, rsNode15);

    OH_ArkUI_RenderNodeUtils_SetMarkNodeGroup(rsNode14, 1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetDrawRegion result=%{public}d", result);

    nodeAPI->addChild(scroll, column);
    return scroll;
}

ArkUI_NodeHandle testRenderNodeCustom(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_ContextHandle context)
{
    ArkUI_NodeHandle scroll = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue valueWidth[] = {g_contentWidth};
    ArkUI_AttributeItem itemWidth = {valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_WIDTH, &itemWidth);
    ArkUI_NumberValue valueHeight[] = {g_contentHeight};
    ArkUI_AttributeItem itemHeight = {valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_HEIGHT, &itemHeight);
    valueHeight[0].u32 = 0xff00F100;
    nodeAPI->setAttribute(scroll, NODE_BACKGROUND_COLOR, &itemHeight);

    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem content = {.string = "RenderNode 自定义绘制示例"};

    nodeAPI->setAttribute(text, NODE_TEXT_CONTENT, &content);

    ArkUI_NodeHandle Custom = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    // createRenderNode
    auto renderNode = OH_ArkUI_RenderNodeUtils_CreateNode();
    OH_ArkUI_RenderNodeUtils_AddRenderNode(Custom, renderNode);
    OH_ArkUI_RenderNodeUtils_SetSize(renderNode, g_num300, g_num300);
    OH_ArkUI_RenderNodeUtils_SetBackgroundColor(renderNode, 0xFFFFFFFF);
    // 标记实际动画可能会执行的脏区，确保包含实际绘制范围。
    OH_ArkUI_RenderNodeUtils_SetDrawRegion(renderNode, 0, 0, g_numBigSize, g_numBigSize);

    // Property的作用是触发set更新，同步更新modifier的Draw方法
    struct AnimatableUserData {
        ArkUI_FloatAnimatablePropertyHandle width;
        ArkUI_FloatAnimatablePropertyHandle height;
        ArkUI_Vector2AnimatablePropertyHandle v2;
        ArkUI_ColorAnimatablePropertyHandle color;
    };

    // 设置基础值
    AnimatableUserData *userData1 = new AnimatableUserData;
    auto widthAnimProperty = OH_ArkUI_RenderNodeUtils_CreateFloatAnimatableProperty(g_numBigSize);
    userData1->width = widthAnimProperty;
    auto heightAnimProperty = OH_ArkUI_RenderNodeUtils_CreateFloatAnimatableProperty(g_numBigSize);
    userData1->height = heightAnimProperty;
    auto vectorAnimP = OH_ArkUI_RenderNodeUtils_CreateVector2AnimatableProperty(g_numBigSize, g_numBigSize);
    userData1->v2 = vectorAnimP;
    auto colorAnimP = OH_ArkUI_RenderNodeUtils_CreateColorAnimatableProperty(0xFFFF11FF);
    userData1->color = colorAnimP;

    // 关联组件和多个modifier
    auto animModifier = OH_ArkUI_RenderNodeUtils_CreateContentModifier();
    OH_ArkUI_RenderNodeUtils_AttachContentModifier(renderNode, animModifier);
    // 关联modifier和property

    OH_ArkUI_RenderNodeUtils_AttachFloatAnimatableProperty(animModifier, widthAnimProperty);
    OH_ArkUI_RenderNodeUtils_AttachFloatAnimatableProperty(animModifier, heightAnimProperty);
    OH_ArkUI_RenderNodeUtils_AttachVector2AnimatableProperty(animModifier, vectorAnimP);
    OH_ArkUI_RenderNodeUtils_AttachColorAnimatableProperty(animModifier, colorAnimP);
    // setDrawFunc
    OH_ArkUI_RenderNodeUtils_SetContentModifierOnDraw(
        animModifier, userData1, [](ArkUI_DrawContext *context, void *userData) {
            AnimatableUserData *data = (AnimatableUserData *)userData;
            float width = 0;
            float height = 0;
            uint32_t color = 0;
            int32_t NUM_3 = 3;
            int32_t NUM_4 = 4;
            ArkUI_Vector2AnimatablePropertyHandle v2 = data->v2;
            OH_ArkUI_RenderNodeUtils_GetVector2AnimatablePropertyValue(
                v2, &width, &height); // property主要为传值用，这里用x,y来替代width，确认传值成功即可
            ArkUI_ColorAnimatablePropertyHandle cp = data->color;
            OH_ArkUI_RenderNodeUtils_GetColorAnimatablePropertyValue(cp, &color);
            auto *canvas1 = OH_ArkUI_DrawContext_GetCanvas(context);
            OH_Drawing_Canvas *canvas = reinterpret_cast<OH_Drawing_Canvas *>(canvas1);
            auto path = OH_Drawing_PathCreate();
            auto path = OH_Drawing_PathCreate();
            OH_Drawing_PathMoveTo(path, size.width / NUM_4, size.height / NUM_4);
            OH_Drawing_PathLineTo(path, size.width * NUM_3 / NUM_4, size.height / NUM_4);
            OH_Drawing_PathLineTo(path, size.width * NUM_3 / NUM_4, size.height * NUM_3 / NUM_4);
            OH_Drawing_PathLineTo(path, size.width / NUM_4, size.height * NUM_3 / NUM_4);
            OH_Drawing_PathLineTo(path, size.width / NUM_4, size.height / NUM_4);
            OH_Drawing_PathClose(path);

            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager",
                         "argb print w=%{public}f ARGB: 0x%{public}08X (A:0x%{public}02X R:0x%{public}02X "
                         "G:0x%{public}02X B:0x%{public}02X)\n",
                         width, color,
                         (color >> 24) & 0xFF, // 24-31代表Alpha位数。
                         (color >> 16) & 0xFF, // 16-23代表Red位数。
                         (color >> 8) & 0xFF,  // 8-15代表Green位数。
                         color & 0xFF);        // 0-7代表Blue位数;
            auto pen = OH_Drawing_PenCreate();
            OH_Drawing_PenSetWidth(pen, 10); // 设置10px的画笔粗细。
            OH_Drawing_PenSetColor(pen, color);
            OH_Drawing_CanvasAttachPen(canvas, pen);
            OH_Drawing_CanvasDrawPath(canvas, path);
        });

    // 用户自定义参数
    ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
    update->userData = userData1;
    update->callback = [](void *user) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "animateTo");
        AnimatableUserData *data = (AnimatableUserData *)user;
        OH_ArkUI_RenderNodeUtils_SetFloatAnimatablePropertyValue(data->width, g_num100);
        OH_ArkUI_RenderNodeUtils_SetFloatAnimatablePropertyValue(data->height, g_num100);
        OH_ArkUI_RenderNodeUtils_SetVector2AnimatablePropertyValue(data->v2, g_num100, g_num100);
        OH_ArkUI_RenderNodeUtils_SetColorAnimatablePropertyValue(data->color, 0xFF0011FF);
    };
    // 执行对应的动画
    ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);

    ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
    completeCallback->userData = userData1;
    completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
    completeCallback->callback = [](void *userData) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "complete onFinishCallback");
        AnimatableUserData *data = (AnimatableUserData *)userData;
        OH_ArkUI_RenderNodeUtils_SetFloatAnimatablePropertyValue(data->width, g_numBigSize);
        OH_ArkUI_RenderNodeUtils_SetFloatAnimatablePropertyValue(data->height, g_numBigSize);
        OH_ArkUI_RenderNodeUtils_SetVector2AnimatablePropertyValue(data->v2, g_numBigSize, g_numBigSize);
        OH_ArkUI_RenderNodeUtils_SetColorAnimatablePropertyValue(data->color, 0xFF0011FF);
    };

    ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
    OH_ArkUI_AnimateOption_SetDuration(option, 2000); // 设置2000ms的动画播放时长。
    OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
    OH_ArkUI_AnimateOption_SetIterations(option, 1);
    OH_ArkUI_AnimateOption_SetPlayMode(option, ARKUI_ANIMATION_PLAY_MODE_REVERSE);
    animateApi->animateTo(context, option, update, completeCallback);

    nodeAPI->setAttribute(Custom, NODE_WIDTH, &itemWidth);
    nodeAPI->setAttribute(Custom, NODE_HEIGHT, &itemHeight);

    nodeAPI->addChild(column, text);
    nodeAPI->addChild(column, Custom);
    nodeAPI->addChild(scroll, column);
    return scroll;
}

napi_value CreateRenderNodeExample(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTs侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }

    // 获取上下文对象指针。
    if (!g_contextHandle) {
        result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &g_contextHandle);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
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
    auto columnNode = CreateRenderNodeTreeExample(NativeModuleInstance::GetInstance()->GetNativeNodeAPI());

    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->addChild(scrollNode->GetHandle(), columnNode);
    return nullptr;
}

napi_value CreateRenderNodePropertyExample(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTs侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }

    // 获取上下文对象指针。
    if (!g_contextHandle) {
        result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &g_contextHandle);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
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
    auto columnNode = testRenderNodeProperty(NativeModuleInstance::GetInstance()->GetNativeNodeAPI());

    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->addChild(scrollNode->GetHandle(), columnNode);
    return nullptr;
}

napi_value CreateRenderNodeCustomDrawExample(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTs侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }

    // 获取上下文对象指针。
    if (!g_contextHandle) {
        result = OH_ArkUI_GetContextFromNapiValue(env, args[1], &g_contextHandle);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
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
    auto columnNode = testRenderNodeCustom(NativeModuleInstance::GetInstance()->GetNativeNodeAPI(), g_contextHandle);

    NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->addChild(scrollNode->GetHandle(), columnNode);
    return nullptr;
}

napi_value DisposeNodeTree(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
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

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
{
    // 从管理类中释放Native侧对象。
    NativeEntry::GetInstance()->DisposeRootNode();
    NativeEntry::GetInstance()->ClearNode();
    return nullptr;
}

} // namespace NativeModule
    