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

#include "EmbeddedComponentMaker.h"
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <AbilityKit/ability_base/want.h>
#include <hilog/log.h>

constexpr float TEXT_WIDTH_PX = 300.0f;
constexpr float TEXT_HEIGHT_PX = 100.0f;
constexpr int EMBEDDED_COMPONENT_WIDTH = 480;
constexpr int WANT_STR_BUF_LEN = 10;
constexpr int WANT_STR_COPY_LEN = 5;
constexpr int WANT_URI_BUF_LEN = 10;
constexpr int WANT_URI_COPY_LEN = 5;
constexpr float COL_WIDTH_PX = 300.0f;
static ArkUI_EmbeddedComponentOption* embeddedComponentOption_;

ArkUI_NodeHandle EmbeddedComponentMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return nullptr;
    }
    // 创建一个Column容器组件
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);

    // 创建一个EmbeddedComponent组件节点
    ArkUI_NodeHandle embeddedNode = BuildEmbeddedComponentSection(nodeApi);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "嵌入式组件:");
    nodeApi->addChild(column, text2);

    // 将嵌入式组件添加到列容器
    nodeApi->addChild(column, embeddedNode);
    // Column作为XComponent子组件
    return column;
}

ArkUI_NodeHandle EmbeddedComponentMaker::BuildColumnNode(ArkUI_NativeNodeAPI_1* nodeApi)
{
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = COL_WIDTH_PX}};
    ArkUI_AttributeItem widthItem = { colWidth, sizeof(colWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    return column;
}

ArkUI_NodeHandle EmbeddedComponentMaker::BuildTextNode(ArkUI_NativeNodeAPI_1* nodeApi, const char* content)
{
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = TEXT_WIDTH_PX}};
    ArkUI_AttributeItem textWidthItem = { textWidth, sizeof(textWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = TEXT_HEIGHT_PX}};
    ArkUI_AttributeItem textHeightItem = { textHeight, sizeof(textHeight) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_AttributeItem valueItem = {.string = content};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT, &valueItem);
    return text;
}

EmbeddedComponentMaker::~EmbeddedComponentMaker()
{
    DisposeEmbeddedComponentOption();
}

ArkUI_NodeHandle EmbeddedComponentMaker::BuildEmbeddedComponentSection(ArkUI_NativeNodeAPI_1* nodeApi)
{
    // 创建嵌入式组件选项
    CreateEmbeddedComponentOption();
    // 设置错误回调
    SetEmbeddedComponentOnError();
    // 设置终止回调
    SetEmbeddedComponentOnTerminated();
    // 创建嵌入式组件节点
    ArkUI_NodeHandle embeddedNode = nodeApi->createNode(ARKUI_NODE_EMBEDDED_COMPONENT);
    // 设置嵌入式组件的want
    SetEmbeddedComponentWant(nodeApi, embeddedNode);
    // 将嵌入式组件选项设置给嵌入式组件
    ArkUI_AttributeItem embeddedComponentOptionItem = { .object = embeddedComponentOption_ };
    nodeApi->setAttribute(embeddedNode, NODE_EMBEDDED_COMPONENT_OPTION, &embeddedComponentOptionItem);
    ArkUI_NumberValue value[] = { EMBEDDED_COMPONENT_WIDTH };
    ArkUI_AttributeItem embeddedWidthItem = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(embeddedNode, NODE_WIDTH, &embeddedWidthItem);
    nodeApi->setAttribute(embeddedNode, NODE_HEIGHT, &embeddedWidthItem);
    return embeddedNode;
}

void EmbeddedComponentMaker::CreateEmbeddedComponentOption()
{
    if (!embeddedComponentOption_) {
        embeddedComponentOption_ = OH_ArkUI_EmbeddedComponentOption_Create();
    }
}

void EmbeddedComponentMaker::DisposeEmbeddedComponentOption()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_Dispose(embeddedComponentOption_);
        embeddedComponentOption_ = nullptr;
    }
}

void EmbeddedComponentMaker::SetEmbeddedComponentOnError()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_SetOnError(embeddedComponentOption_, OnErrorCallback);
    }
}

void EmbeddedComponentMaker::SetEmbeddedComponentOnTerminated()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_SetOnTerminated(embeddedComponentOption_, OnTerminatedCallback);
    }
}

void EmbeddedComponentMaker::SetEmbeddedComponentWant(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        // 创建一个Want对象并设置相关属性
        AbilityBase_Element element = {
            .bundleName = "com.example.native_node_napi",
            .abilityName = "SampleEmbeddedAbility",
            .moduleName = ""
        };
        AbilityBase_Want* want = OH_AbilityBase_CreateWant(element);
        ArkUI_AttributeItem itemObjWant = {.object = want};
        nodeApi->setAttribute(node, NODE_EMBEDDED_COMPONENT_WANT, &itemObjWant);
    }
}

void EmbeddedComponentMaker::OnErrorCallback(int32_t code, const char* name, const char* msg)
{
    // 用户自定义的错误处理逻辑
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnErrorCallback:\
        code=%{public}d, name=%{public}s, message=%{public}s", code, name, msg);
}

void EmbeddedComponentMaker::OnTerminatedCallback(int32_t code, AbilityBase_Want* want)
{
    // 用户自定义的终止处理逻辑
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: code=%{public}d", code);
    if (want == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: want is nullptr");
        return;
    }

    AbilityBase_Element element;
    auto error = OH_AbilityBase_GetWantElement(want, &element);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: bundleName=%{public}s,\
        abilityName=%{public}s, moduleName=%{public}s", element.bundleName, element.abilityName, element.moduleName);
    int wantInt = 0;
    error = OH_AbilityBase_GetWantInt32Param(want, "int", &wantInt);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantInt=%{public}d", wantInt);
    bool wantBool = false;
    error = OH_AbilityBase_GetWantBoolParam(want, "bool2", &wantBool);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantBool=%{public}d",
        wantBool);
    char wantString[WANT_STR_BUF_LEN];
    error = OH_AbilityBase_GetWantCharParam(want, "string", wantString, WANT_STR_COPY_LEN);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantString=%{public}s",
        wantString);
    char wantUri[WANT_URI_BUF_LEN];
    error = OH_AbilityBase_GetWantUri(want, wantUri, WANT_URI_COPY_LEN);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantUri=%{public}s", wantUri);
    int wantFd = 0;
    error = OH_AbilityBase_GetWantFd(want, "keyFd2", &wantFd);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantFd=%{public}d", wantFd);
}
