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
#include "ArkUIColumnNode.h"
#include "ArkUITextNode.h"
#include "NativeEntry.h"
#include <map>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_path.h>
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
float g_contentHeight = 600;
float g_numBigSize = 1000;
float g_num20 = 20;
float g_num100 = 100;
float g_num150 = 150;
float g_num200 = 200;
float g_num300 = 300;
float g_num600 = 600;

std::shared_ptr<ArkUIBaseNode> CreateRenderNodeTreeExample(ArkUI_NativeNodeAPI_1 *nodeAPI)
{
    auto rootNode = std::make_shared<ArkUIColumnNode>();
    rootNode->SetWidth(g_num300);
    rootNode->SetHeight(g_num600);

    auto column = std::make_shared<ArkUIColumnNode>();
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent("查看日志打印，确认renderNode上树情况");
    auto Custom = std::make_shared<ArkUICustomNode>();

    // 节点操作类测试
    // 测试挂载创建 result = 0
    auto rsNodeRoot = std::make_shared<ArkUIRenderNode>();
    auto rsNodeFirstChild = std::make_shared<ArkUIRenderNode>();
    auto rsNodeSecondChild = std::make_shared<ArkUIRenderNode>();
    auto rsNodeThirdChild = std::make_shared<ArkUIRenderNode>();

    // 测试挂载非custom节点 result = 401
    auto result = column->AddRenderNode(rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test001 result=%{public}d", result);

    // 测试挂载正常挂载 result = 0
    result = Custom->AddRenderNode(rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test002 result=%{public}d", result);

    // 测试挂载根节点重复挂载 result = 401
    result = Custom->AddRenderNode(rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test003 result=%{public}d", result);

    // 测试移除根节点 result = 0
    result = Custom->RemoveRenderNode(rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_RemoveRenderNode test001 result=%{public}d", result);

    // 测试再次挂载 result = 0
    result = Custom->AddRenderNode(rsNodeRoot);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_NodeUtils_AddRenderNode test004 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 0
    int32_t count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test001 count=%{public}d", count);

    // 测试挂载RenderNode result = 0
    result = rsNodeRoot->AddChild(rsNodeFirstChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test002 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 1
    count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test002 count=%{public}d", count);

    // 测试挂载RenderNode result = 0
    result = rsNodeRoot->AddChild(rsNodeSecondChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test003 result=%{public}d", result);

    // 测试挂载RenderNode result = 0, count = 2
    count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetChildrenCount test003 count=%{public}d", count);

    // 测试移除RenderNode result = 0
    result = rsNodeRoot->RemoveChild(rsNodeSecondChild);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_RemoveChild test001 result=%{public}d", result);

    // 测试移除RenderNode result = 0, count = 1
    count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_RemoveChild test002 count=%{public}d", count);

    // 测试标脏CustomNode result = 0, count = 1 pass
    result = Custom->Invalidate();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_Invalidate test002 except-result=0 - %{public}d", result);

    // 初始异常值测试
    result = rsNodeRoot->SetSize(-1, 1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "error test001 count=106405-%{public}d", result);

    // 测试getChild getFirstChild getNextSlibing getPreviewSlibging insertAfterChild
    // 通过不同尺寸大小判断获取的子节点下标。
    rsNodeRoot->SetSize(300, 300); // 设置根节点为300的尺寸。
    rsNodeRoot->SetBackgroundColor(0xFFFFFFFF);
    rsNodeFirstChild->SetSize(g_num100, g_num100); // 设置第一个子节点为100的尺寸。
    rsNodeSecondChild->SetSize(200, 200);          // 设置第二个子节点为200的尺寸。
    rsNodeThirdChild->SetSize(250, 250);           // 设置第三个子节点为250的尺寸。

    rsNodeRoot->AddChild(rsNodeThirdChild);
    count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_AddChild test004 count=2-%{public}d", count);

    result = rsNodeRoot->InsertChildAfter(rsNodeSecondChild, rsNodeFirstChild);
    count = rsNodeRoot->GetChildrenCount();
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_InsertChildAfter test001 count=3-%{public}d", count);

    Custom->SetWidth(g_num300);
    Custom->SetHeight(g_num600);
    column->AddChild(text);
    column->AddChild(Custom);
    rootNode->AddChild(column);
    return rootNode;
}

void SetBaseProperty(const std::shared_ptr<ArkUIBaseNode>& column, const std::shared_ptr<ArkUIRenderNode>& renderNode,
                     std::string textContent)
{
    auto Custom = std::make_shared<ArkUICustomNode>();
    Custom->SetWidth(g_num100);
    Custom->SetHeight(g_num100);
    renderNode->SetSize(g_num150, g_num150);
    renderNode->SetBackgroundColor(0xFFFF00FF);
    auto result = Custom->AddRenderNode(renderNode);
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent(textContent);
    column->AddChild(text);
    column->AddChild(Custom);
}

std::shared_ptr<ArkUIBaseNode> testRenderNodeProperty(ArkUI_NativeNodeAPI_1 *nodeAPI)
{
    auto scroll = std::make_shared<ArkUIScrollNode>();
    scroll->SetWidth(g_contentWidth);
    scroll->SetHeight(g_contentHeight);
    scroll->SetBackgroundColor(0xff00F100);

    auto column = std::make_shared<ArkUIColumnNode>();

    auto text = std::make_shared<ArkUITextNode>();
    text->SetWidth(g_num100);
    text->SetHeight(g_num100);
    text->SetTextContent("RenderNode 属性设置表现");
    column->AddChild(text);
    scroll->AddChild(column);

    // 属性设置类测试
    // 测试颜色属性获取 result = 0, clipTo = 0
    auto rsNode0 = std::make_shared<ArkUIRenderNode>();
    int32_t clipToFrameResult = true;
    SetBaseProperty(column, rsNode0, "测试clipToFrame");
    auto result = rsNode0->SetClipToFrame(true);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetClipToFrame result=%{public}d", result);

    // 测试颜色属性获取 result = 0, clipTo = 1
    result = rsNode0->GetClipToFrame(&clipToFrameResult);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetClipToFrame test002 result=%{public}d, clipToFrame=%{public}d", result,
                 clipToFrameResult);
    uint32_t backgroundColor = 0;
    auto rsNode1 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode1, "测试backGroundColor");
    result = rsNode1->SetBackgroundColor(0xFF0000FF);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBackgroundColor result=%{public}d", result);

    result = rsNode1->GetBackgroundColor(&backgroundColor);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetBackgroundColor result=%{public}d, backgroundColor=%{public}d", result,
                 backgroundColor);

    // position
    int32_t positionX = 0;
    int32_t positionY = 0;
    auto rsNode2 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode2, "测试position");
    result = rsNode2->SetPosition(g_num200, g_num200);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetPosition result=%{public}d", result);
    result = rsNode2->GetPosition(&positionX, &positionY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPosition result=%{public}d, x=%{public}d , y=%{public}d", result,
                 positionX, positionY);

    // clipToBounds
    int32_t clipToBounds = 0;
    auto rsNode3 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode3, "测试clipToBounds");
    result = rsNode3->SetClipToBounds(true);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetClipToBounds result=%{public}d", clipToBounds);

    result = rsNode3->GetClipToBounds(&clipToBounds);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetClipToBounds result=%{public}d, clipToBounds=%{public}d", result,
                 clipToBounds);

    float opacity = 0;
    auto rsNode4 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode4, "测试opacity");
    result = rsNode4->SetOpacity(1);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetOpacity result=%{public}d", result);

    result = rsNode4->GetOpacity(&opacity);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetOpacity result=%{public}d, opacity=%{public}f", result, opacity);

    // size
    int32_t sizeWidth = 0;
    int32_t sizeHeight = 0;
    auto rsNode5 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode5, "测试size");
    result = rsNode5->SetSize(g_num200, g_num200);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OH_ArkUI_RenderNodeUtils_SetSize result=%{public}d",
                 result);
    result = rsNode5->GetSize(&sizeWidth, &sizeHeight);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetSize result=%{public}d, width=%{public}d, height=%{public}d", result,
                 sizeWidth, sizeHeight);

    // Pivot
    float pivotX = 0;
    float pivotY = 0;
    auto rsNode6 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode6, "测试pivot");
    result = rsNode6->GetPivot(&pivotX, &pivotY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPivot1 result=%{public}d, x=%{public}f , y=%{public}f", result, pivotX,
                 pivotY);
    result = rsNode6->SetPivot(g_num200, g_num100);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetPivot2 result=%{public}d", result);
    result = rsNode6->GetPivot(&pivotX, &pivotY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetPivot3 result=%{public}d, x=%{public}f , y=%{public}f", result, pivotX,
                 pivotY);

    // scale
    float scaleX = 0;
    float scaleY = 0;
    auto rsNode7 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode7, "测试scale");
    result = rsNode7->SetScale(1.5, 1.5); // xy轴各缩放1.5倍。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OH_ArkUI_RenderNodeUtils_SetScale result=%{public}d",
                 result);
    result = rsNode7->GetScale(&scaleX, &scaleY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetScale result=%{public}d, x=%{public}f , y=%{public}f", result, scaleX,
                 scaleY);

    // translation
    float translationX = 0;
    float translationY = 0;
    auto rsNode8 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode8, "测试translation");
    result = rsNode8->SetTranslation(30, 60); // 设置x=30，y=60的位移。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetTranslation result=%{public}d", result);
    result = rsNode8->GetTranslation(&translationX, &translationY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetTranslation result=%{public}d, x=%{public}f , y=%{public}f", result,
                 translationX, translationY);

    // rotation
    float rotationX = 0;
    float rotationY = 0;
    float rotationZ = 0;
    auto rsNode9 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode9, "测试rotation");
    result = rsNode9->SetRotation(60, 150, 30); // 设置x=60，y=150，z=30的旋转度数。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetRotation result=%{public}d", result);
    result = rsNode9->GetRotation(&rotationX, &rotationY, &rotationZ);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetRotation result=%{public}d, x=%{public}f , y=%{public}f , z=%{public}f",
                 result, rotationX, rotationY, rotationZ);

    // transform
    auto rsNode10 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode10, "测试transform");
    float matrix[] = {0.866, 0.433, -0.25, 0, 0, 0.866, 0.5, 0, 0.5, -0.25, 0.866, 0, // x y 旋转各30度
                      30,    30,    0,     1};                                        // 往x 平移30 y 平移 30
    result = rsNode10->SetTransform(matrix);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetTransform result=%{public}d", result);

    // shadow
    auto rsNode11 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode11, "测试shadow");
    uint32_t shadowColor = 0;
    result = rsNode11->SetShadowColor(0x80000000); // 设置50%的透明度
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowColor result=%{public}d", result);
    result = rsNode11->GetShadowColor(&shadowColor);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowColor result=%{public}d, shadowColor=%{public}d", result,
                 shadowColor);
    int32_t shadowOffsetX = 0;
    int32_t shadowOffsetY = 0;
    result = rsNode11->SetShadowOffset(15, 25); // 设置15,25的偏移。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowOffset result=%{public}d", result);

    result = rsNode11->GetShadowOffset(&shadowOffsetX, &shadowOffsetY);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowOffset result=%{public}d, shadowOffsetX=%{public}d, "
                 "shadowOffsetY=%{public}d",
                 result, shadowOffsetX, shadowOffsetY);

    float alpha = 0;
    result = rsNode11->GetShadowAlpha(&alpha);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowAlpha result=%{public}d, alpha=%{public}f", result, alpha);

    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowAlpha result=%{public}d", result);

    result = rsNode11->GetShadowAlpha(&alpha);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowAlpha result=%{public}d, alpha=%{public}f", result, alpha);

    float elevation = 0;

    result = rsNode11->GetShadowElevation(&elevation);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowElevation result=%{public}d, elevation=%{public}f", result,
                 elevation);

    result = rsNode11->SetShadowElevation(0.5); // 设置0.5的阴影高度。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowElevation result=%{public}d", result);

    result = rsNode11->GetShadowElevation(&elevation);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowElevation result=%{public}d, elevation=%{public}f", result,
                 elevation);

    float radius = 0;
    result = rsNode11->SetShadowRadius(15); // 设置15px的应用弧度。
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetShadowRadius result=%{public}d", result);

    result = rsNode11->GetShadowRadius(&radius);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_GetShadowRadius result=%{public}d, clipTo=%{public}f", result, radius);

    // BorderStyle
    auto rsNode12 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode7, "测试pivot");
    result = rsNode12->SetBorderStyle(
        ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID, ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID,
        ArkUI_BorderStyle::ARKUI_BORDER_STYLE_SOLID, ArkUI_BorderStyle::ARKUI_BORDER_STYLE_DOTTED);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderStyle result=%{public}d", result);

    // BorderWidth
    result = rsNode12->SetBorderWidth(0, g_num20, g_num20, g_num20);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderWidth result=%{public}d", result);

    // BorderColor
    result = rsNode12->SetBorderColor(0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderColor result=%{public}d", result);

    // BorderRadius
    result = rsNode12->SetBorderRadius(g_num20, g_num20, g_num20, g_num20);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetBorderStyle result=%{public}d", result);

    // markNodeGroup
    auto rsNode13 = std::make_shared<ArkUIRenderNode>();
    SetBaseProperty(column, rsNode13, "测试markNodeGroup");
    rsNode13->SetOpacity(0.5); // 设置0.5透明度。

    auto rsNode14 = std::make_shared<ArkUIRenderNode>();
    rsNode14->SetSize(g_num150, g_num150);
    rsNode14->SetPosition(75, 75); // 设置大小一半，75的偏移，便于确认效果。
    rsNode14->SetBackgroundColor(0xFFFFFFFF);
    rsNode14->SetOpacity(1);
    rsNode13->AddChild(rsNode14);

    // 切换markNodeGroup为node14，修改绘制顺序
    rsNode13->SetMarkNodeGroup(true);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager",
                 "OH_ArkUI_RenderNodeUtils_SetDrawRegion result=%{public}d", result);
    return scroll;
}


std::shared_ptr<ArkUIRenderNode> saveRender = nullptr;

std::shared_ptr<ArkUIBaseNode> testRenderNodeCustom(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_ContextHandle context)
{
    auto scroll = std::make_shared<ArkUIScrollNode>();
    scroll->SetWidth(g_contentWidth);
    scroll->SetHeight(g_contentHeight);
    scroll->SetBackgroundColor(0xff00F100);

    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(g_contentWidth);
    column->SetHeight(g_contentHeight);
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent("RenderNode 自定义绘制示例");
    text->SetWidth(g_num100);
    text->SetHeight(g_num100);

    auto Custom = std::make_shared<ArkUICustomNode>();
    Custom->SetWidth(g_num100);
    Custom->SetHeight(g_num100);
    column->AddChild(text);
    column->AddChild(Custom);
    scroll->AddChild(column);
    // createRenderNode
    auto renderNode = std::make_shared<ArkUIRenderNode>();
    // 用于保存sharePtr不被销毁。
    saveRender = renderNode;
    Custom->AddRenderNode(renderNode);
    renderNode->SetSize(g_num300, g_num300);
    renderNode->SetBackgroundColor(0xFFFFFFFF);
    // 标记实际动画可能会执行的脏区，确保包含实际绘制范围。
    renderNode->SetDrawRegion(0, 0, g_numBigSize, g_numBigSize);

    // 创建modifier
    renderNode->CreateContentModifier();
    // 关联modifier和property
    renderNode->CreateOrSetFloatAnimatableProperty(g_numBigSize);
    renderNode->CreateOrSetVector2AnimatableProperty(g_numBigSize, g_numBigSize);
    renderNode->CreateOrSetColorAnimatableProperty(0xFFFF11FF);
    // setDrawFunc
    renderNode->SetContentModifierOnDraw(renderNode.get(), [](ArkUI_DrawContext *context, void *userData) {
        ArkUIRenderNode *renderNode = (ArkUIRenderNode *)userData;
        float width = 0;
        float height = 0;
        uint32_t color = 0;
        int32_t NUM_3 = 3;
        int32_t NUM_4 = 4;
        renderNode->GetVector2AnimatableProperty(&width, &height);
        renderNode->GetColorAnimatableProperty(&color);
        auto *canvas1 = OH_ArkUI_DrawContext_GetCanvas(context);
        // 下面使用drawing接口进行自定义绘制。
        OH_Drawing_Canvas *canvas = reinterpret_cast<OH_Drawing_Canvas *>(canvas1);
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, width / NUM_4, height / NUM_4);
        OH_Drawing_PathLineTo(path, width * NUM_3 / NUM_4, height / NUM_4);
        OH_Drawing_PathLineTo(path, width * NUM_3 / NUM_4, height * NUM_3 / NUM_4);
        OH_Drawing_PathLineTo(path, width / NUM_4, height * NUM_3 / NUM_4);
        OH_Drawing_PathLineTo(path, width / NUM_4, height / NUM_4);
        OH_Drawing_PathClose(path);

        auto pen = OH_Drawing_PenCreate();
        OH_Drawing_PenSetWidth(pen, 10); // 设置10px的画笔粗细。
        OH_Drawing_PenSetColor(pen, color);
        OH_Drawing_CanvasAttachPen(canvas, pen);
        OH_Drawing_CanvasDrawPath(canvas, path);
    });

    // 用户自定义参数
    ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
    update->userData = renderNode.get();
    update->callback = [](void *user) {
        ArkUIRenderNode *renderNode = (ArkUIRenderNode *)user;
        renderNode->CreateOrSetFloatAnimatableProperty(g_num100);
        renderNode->CreateOrSetVector2AnimatableProperty(g_num100, g_num100);
        renderNode->CreateOrSetColorAnimatableProperty(0xFF0011FF);
    };
    // 执行对应的动画
    ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);

    ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
    completeCallback->userData = renderNode.get();
    completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
    completeCallback->callback = [](void *userData) {
        ArkUIRenderNode *renderNode = (ArkUIRenderNode *)userData;
        renderNode->CreateOrSetFloatAnimatableProperty(g_numBigSize);
        renderNode->CreateOrSetVector2AnimatableProperty(g_numBigSize, g_numBigSize);
        renderNode->CreateOrSetColorAnimatableProperty(0xFF0011FF);
    };

    ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
    OH_ArkUI_AnimateOption_SetDuration(option, 2000); // 设置2000ms的动画播放时长。
    OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
    OH_ArkUI_AnimateOption_SetIterations(option, 1);
    OH_ArkUI_AnimateOption_SetPlayMode(option, ARKUI_ANIMATION_PLAY_MODE_REVERSE);
    animateApi->animateTo(context, option, update, completeCallback);

    scroll->AddChild(column);
    return scroll;
}

napi_value CreateRenderNodeExample(napi_env env, napi_callback_info info)
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
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        return nullptr;
    }
    // 保存Native侧组件树。
    g_nodeMap[contentHandle] = scrollNode;
    auto columnNode = CreateRenderNodeTreeExample(NativeModuleInstance::GetInstance()->GetNativeNodeAPI());

    scrollNode->AddChild(columnNode);
    return nullptr;
}


napi_value CreateRenderNodePropertyExample(napi_env env, napi_callback_info info)
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
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        return nullptr;
    }
    // 保存Native侧组件树。
    g_nodeMap[contentHandle] = scrollNode;
    auto columnNode = testRenderNodeProperty(NativeModuleInstance::GetInstance()->GetNativeNodeAPI());

    scrollNode->AddChild(columnNode);
    return nullptr;
}

napi_value CreateRenderNodeCustomDrawExample(napi_env env, napi_callback_info info)
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
    scrollNode->AddChild(columnNode);
    return nullptr;
}

// [Start Create_RootNode]

std::shared_ptr<ArkUIBaseNode> custom_ = nullptr;
std::shared_ptr<ArkUIRenderNode> render_ = nullptr;

std::shared_ptr<ArkUIBaseNode> testGetRenderNodeDemo()
{
    auto scroll = std::make_shared<ArkUIScrollNode>();
    scroll->SetWidth(g_contentWidth);
    scroll->SetHeight(g_contentHeight);
    scroll->SetBackgroundColor(0xff00F100);

    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(g_contentWidth);
    column->SetHeight(g_contentHeight);
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent("挂载从frameNode获取的renderNode示例，点击下方挂载按钮");
    text->SetWidth(g_num300);
    text->SetHeight(g_num100);

    auto Custom = std::make_shared<ArkUICustomNode>();
    Custom->SetWidth(g_contentWidth);
    Custom->SetHeight(g_num100);
    column->AddChild(text);
    column->AddChild(Custom);
    custom_ = Custom;
    
    // 布置可挂载环境，将renderNode作为Custom的根节点挂载。
    auto renderNode = std::make_shared<ArkUIRenderNode>();
    Custom->AddRenderNode(renderNode);
    renderNode->SetSize(g_num300, g_num300);
    Custom->AddRenderNode(renderNode);
    render_ = renderNode;

    scroll->AddChild(column);
    return scroll;
}

napi_value CreateRenderNodeGetNodeExample(napi_env env, napi_callback_info info)
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
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        return nullptr;
    }
    // 保存Native侧组件树。
    g_nodeMap[contentHandle] = scrollNode;
    auto rootNode = testGetRenderNodeDemo();
    scrollNode->AddChild(rootNode);
    return nullptr;
}

// [End Create_RootNode]

ArkUI_NodeHandle nodeHandle_ = nullptr;
ArkUI_RenderNodeHandle renderHandle_ = nullptr;

// [Start Adopt_Node]

napi_value Adopt(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTS侧组件挂载点。
    int32_t result = OH_ArkUI_GetNodeHandleFromNapiValue(env, args[0], &nodeHandle_);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }
    result = OH_ArkUI_NativeModule_AdoptChild(custom_->GetHandle(), nodeHandle_);
    OH_ArkUI_RenderNodeUtils_GetRenderNode(nodeHandle_, &renderHandle_);
    OH_ArkUI_RenderNodeUtils_AddChild(render_->GetHandle(), renderHandle_);
    return nullptr;
}

// [End Adopt_Node]


// [Start Remove_Adopt_Node]

napi_value RemoveAdopt(napi_env env, napi_callback_info info)
{
    OH_ArkUI_NativeModule_RemoveAdoptedChild(custom_->GetHandle(), nodeHandle_);
    // 解除节点的接纳状态后，需要额外调用OH_ArkUI_RenderNodeUtils_DisposeNode释放对应的渲染节点，否则会导致内存泄漏
    OH_ArkUI_RenderNodeUtils_DisposeNode(renderHandle_);
    nodeHandle_ = nullptr;
    renderHandle_ = nullptr;
    return nullptr;
}

// [End Remove_Adopt_Node]

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
    saveRender = nullptr;
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
