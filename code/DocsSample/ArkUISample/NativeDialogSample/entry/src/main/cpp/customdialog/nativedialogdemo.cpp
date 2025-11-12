/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "nativedialogdemo.h"
#include "../common/ArkUITextNode.h"
#include <napi/native_api.h>
#include <arkui/native_dialog.h>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include <js_native_api_types.h>

namespace Dialog_Demo {
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

namespace Dialog_Controller_Demo {
ArkUI_NodeHandle CreateDialogContent();
void ShowDialog();
void CloseDialog();
void OnButtonClicked(ArkUI_NodeEvent *event);
void MainViewMethod(ArkUI_NodeContentHandle handle);

// [Start dialog_create]
ArkUI_NativeDialogHandle g_dialogController = nullptr;
// [StartExclude dialog_create]
// [Start show_dialog]
void ShowDialog()
{
    // [EndExclude dialog_create]
    ArkUI_NativeDialogAPI_1 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_1"));
    if (!g_dialogController) {
        g_dialogController = dialogAPI->create();
    }
    // [End dialog_create]
    auto contentNode = CreateDialogContent();
    dialogAPI->setContent(g_dialogController, contentNode);
    dialogAPI->setContentAlignment(g_dialogController, static_cast<int32_t>(ARKUI_ALIGNMENT_BOTTOM), 0, 0);
    dialogAPI->setBackgroundColor(g_dialogController, 0xffffffff);
    dialogAPI->setCornerRadius(g_dialogController, 6.0f, 6.0f, 6.0f, 6.0f);
    dialogAPI->setModalMode(g_dialogController, false);
    dialogAPI->setAutoCancel(g_dialogController, true);
    dialogAPI->show(g_dialogController, false);
}
// [End show_dialog]

// 创建可交互界面，点击Button后弹窗
// [Start main_view]
constexpr int32_t BUTTON_CLICK_ID = 1;
ArkUI_NodeHandle g_buttonNode = nullptr;

void MainViewMethod(ArkUI_NodeContentHandle handle)
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue widthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = widthValue, .size = sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem heightItem = {.value = heightValue, .size = sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &heightItem);
    
    g_buttonNode = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue buttonWidthValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem buttonWidthItem = {.value = buttonWidthValue,
                                           .size = sizeof(buttonWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_WIDTH, &buttonWidthItem);
    ArkUI_NumberValue buttonHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem buttonHeightItem = {.value = buttonHeightValue,
                                            .size = sizeof(buttonHeightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_HEIGHT, &buttonHeightItem);
    ArkUI_AttributeItem labelItem = {.string = "Click Dialog Box"};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
    ArkUI_NumberValue buttonTypeValue[] = {{.i32 = static_cast<int32_t>(ARKUI_BUTTON_TYPE_NORMAL)}};
    ArkUI_AttributeItem buttonTypeItem = {.value = buttonTypeValue,
                                          .size = sizeof(buttonTypeValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_TYPE, &buttonTypeItem);
    nodeAPI->registerNodeEvent(g_buttonNode, NODE_ON_CLICK, BUTTON_CLICK_ID, nullptr);
    nodeAPI->addNodeEventReceiver(g_buttonNode, OnButtonClicked);
    nodeAPI->addChild(column, g_buttonNode);
    OH_ArkUI_NodeContent_AddNode(handle, column);
}
// [End main_view]

// [Start create_content]
ArkUI_NodeHandle CreateDialogContent()
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidthValue,
                                         .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeightValue,
                                          .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NodeHandle span = nodeAPI->createNode(ARKUI_NODE_SPAN);
    ArkUI_AttributeItem spanItem = {.string = "This is a dialog box"};
    nodeAPI->setAttribute(span, NODE_SPAN_CONTENT, &spanItem);
    ArkUI_NodeHandle imageSpan = nodeAPI->createNode(ARKUI_NODE_IMAGE_SPAN);
    // 图片src/main/ets/pages/common/sky.jpg需要替换为开发者所需的资源文件
    ArkUI_AttributeItem imageSpanItem = {.string = "/pages/common/sky.jpg"};
    nodeAPI->setAttribute(imageSpan, NODE_IMAGE_SPAN_SRC, &imageSpanItem);
    ArkUI_NumberValue imageSpanWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem imageSpanWidthItem = {.value = imageSpanWidthValue,
                                              .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_WIDTH, &imageSpanWidthItem);
    ArkUI_NumberValue imageSpanHeightValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem imageSpanHeightItem = {.value = imageSpanHeightValue,
                                               .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_HEIGHT, &imageSpanHeightItem);
    nodeAPI->addChild(text, span);
    nodeAPI->addChild(text, imageSpan);
    return text;
}
// [End create_content]

// [Start close_controller]
void CloseDialog()
{
    ArkUI_NativeDialogAPI_1 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_1"));
    dialogAPI->close(g_dialogController);
}
// [End close_controller]


// 触发controller弹窗
// [Start controller_click]
bool g_isShown = false;

void OnButtonClicked(ArkUI_NodeEvent *event)
{
    if (!event || !g_buttonNode) {
        return;
    }
    auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == BUTTON_CLICK_ID) {
        ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
        if (g_isShown) {
            g_isShown = false;
            ArkUI_AttributeItem labelItem = {.string = "Show Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            CloseDialog();
        } else {
            g_isShown = true;
            ArkUI_AttributeItem labelItem = {.string = "Close Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            ShowDialog();
        }
    }
}
// [End controller_click]

// 退出时删除dialogController
napi_value Dispose(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void

    if (g_dialogController) {
        // [Start dialog_dispose]
        ArkUI_NativeDialogAPI_1 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_1"));
        dialogAPI->dispose(g_dialogController);
        g_dialogController = nullptr;
        // [End dialog_dispose]
    }
    return result;
}

napi_value BuildDemoPage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args;
    napi_get_cb_info(env, info, &argc, &args, nullptr, nullptr);
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void
    
    ArkUI_NodeContentHandle contentHandle;
    // 将napi_value转为NodeContentHandle
    OH_ArkUI_GetNodeContentFromNapiValue(env, args, &contentHandle);
    MainViewMethod(contentHandle);
    return result;
}

} // namespace Dialog_Controller_Demo

namespace Dialog_Option_Demo {

ArkUI_NodeHandle CreateDialogContent();
void OpenCustomDialog();
void CloseCustomDialog();
void MainViewMethod(ArkUI_NodeContentHandle handle);
void OpenDialogCallBack(int32_t dialogId);
void OnButtonClicked(ArkUI_NodeEvent *event);

constexpr int32_t BUTTON_CLICK_ID = 1;
bool g_isShown = false;

ArkUI_NodeHandle CreateDialogContent()
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));

    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidthValue,
                                         .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeightValue,
                                          .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NodeHandle span = nodeAPI->createNode(ARKUI_NODE_SPAN);
    ArkUI_AttributeItem spanItem = {.string = "This is a dialog box"};
    nodeAPI->setAttribute(span, NODE_SPAN_CONTENT, &spanItem);
    ArkUI_NodeHandle imageSpan = nodeAPI->createNode(ARKUI_NODE_IMAGE_SPAN);
    // 图片src/main/ets/pages/common/sky.jpg需要替换为开发者所需的资源文件
    ArkUI_AttributeItem imageSpanItem = {.string = "/pages/common/sky.jpg"};
    nodeAPI->setAttribute(imageSpan, NODE_IMAGE_SPAN_SRC, &imageSpanItem);
    ArkUI_NumberValue imageSpanWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem imageSpanWidthItem = {.value = imageSpanWidthValue,
                                              .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_WIDTH, &imageSpanWidthItem);
    ArkUI_NumberValue imageSpanHeightValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem imageSpanHeightItem = {.value = imageSpanHeightValue,
                                               .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_HEIGHT, &imageSpanHeightItem);

    nodeAPI->addChild(text, span);
    nodeAPI->addChild(text, imageSpan);
    return text;
}

// 触发dialogOptions弹窗
ArkUI_CustomDialogOptions* g_dialogOptions = nullptr;
// [Start open_dialogOption]
int32_t g_id = 0;
void OpenDialogCallBack(int32_t dialogId)
{
    g_id = dialogId;
}

void OpenCustomDialog()
{
    auto contentNode = CreateDialogContent();
    if (!g_dialogOptions) {
        g_dialogOptions = OH_ArkUI_CustomDialog_CreateOptions(contentNode);
    }
    OH_ArkUI_CustomDialog_SetAlignment(g_dialogOptions, static_cast<int32_t>(ARKUI_ALIGNMENT_BOTTOM), 0, 0);
    OH_ArkUI_CustomDialog_SetBackgroundColor(g_dialogOptions, 0xffffffff);
    OH_ArkUI_CustomDialog_SetCornerRadius(g_dialogOptions, 6.0f, 6.0f, 6.0f, 6.0f);
    OH_ArkUI_CustomDialog_SetModalMode(g_dialogOptions, false);
    OH_ArkUI_CustomDialog_SetAutoCancel(g_dialogOptions, true);
    OH_ArkUI_CustomDialog_SetBorderStyle(g_dialogOptions, ARKUI_BORDER_STYLE_SOLID,
                                         ARKUI_BORDER_STYLE_SOLID, ARKUI_BORDER_STYLE_SOLID, ARKUI_BORDER_STYLE_SOLID);
    OH_ArkUI_CustomDialog_OpenDialog(g_dialogOptions, OpenDialogCallBack);
}
// [End open_dialogOption]

// [Start close_option]
void CloseCustomDialog()
{
    OH_ArkUI_CustomDialog_CloseDialog(g_id);
}
// [End close_option]

ArkUI_NodeHandle g_buttonNode = nullptr;
// [Start option_click]
void OnButtonClicked(ArkUI_NodeEvent *event)
{
    if (!event || !g_buttonNode) {
        return;
    }
    auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == BUTTON_CLICK_ID) {
        ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
        if (g_isShown) {
            g_isShown = false;
            ArkUI_AttributeItem labelItem = {.string = "Show Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            CloseCustomDialog();
        } else {
            g_isShown = true;
            ArkUI_AttributeItem labelItem = {.string = "Close Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            OpenCustomDialog();
        }
    }
}
// [End option_click]

// 创建可交互界面，点击Button后弹窗
void MainViewMethod(ArkUI_NodeContentHandle handle)
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue widthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = widthValue, .size = sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem heightItem = {.value = heightValue, .size = sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &heightItem);
    
    g_buttonNode = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue buttonWidthValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem buttonWidthItem = {.value = buttonWidthValue,
                                           .size = sizeof(buttonWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_WIDTH, &buttonWidthItem);
    ArkUI_NumberValue buttonHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem buttonHeightItem = {.value = buttonHeightValue,
                                            .size = sizeof(buttonHeightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_HEIGHT, &buttonHeightItem);
    ArkUI_AttributeItem labelItem = {.string = "Click Dialog Box"};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
    ArkUI_NumberValue buttonTypeValue[] = {{.i32 = static_cast<int32_t>(ARKUI_BUTTON_TYPE_NORMAL)}};
    ArkUI_AttributeItem buttonTypeItem = {.value = buttonTypeValue,
                                          .size = sizeof(buttonTypeValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_TYPE, &buttonTypeItem);
    nodeAPI->registerNodeEvent(g_buttonNode, NODE_ON_CLICK, BUTTON_CLICK_ID, nullptr);
    nodeAPI->addNodeEventReceiver(g_buttonNode, OnButtonClicked);
    nodeAPI->addChild(column, g_buttonNode);
    OH_ArkUI_NodeContent_AddNode(handle, column);
}

// 退出时删除dialogController
napi_value Dispose(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void

    if (g_dialogOptions) {
        OH_ArkUI_CustomDialog_DisposeOptions(g_dialogOptions);
        g_dialogOptions = nullptr;
    }
    return result;
}

napi_value BuildDemoPage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args;
    napi_get_cb_info(env, info, &argc, &args, nullptr, nullptr);
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void
    
    ArkUI_NodeContentHandle contentHandle;
    // 将napi_value转为NodeContentHandle
    OH_ArkUI_GetNodeContentFromNapiValue(env, args, &contentHandle);
    MainViewMethod(contentHandle);
    return result;
}

} // namespace Dialog_Option_Demo

namespace Dialog_OptionText_Demo {

void CloseCustomDialog();
void MainViewMethod(ArkUI_NodeContentHandle handle);
void OpenDialogCallBack(int32_t dialogId);
void OnButtonClicked(ArkUI_NodeEvent *event);

ArkUI_NodeHandle g_buttonNode = nullptr;
constexpr int32_t BUTTON_CLICK_ID = 1;
bool g_isShown = false;

// 触发dialogOptions弹窗
int32_t g_id = 0;
void OpenDialogCallBack(int32_t dialogId)
{
    g_id = dialogId;
}

// [Start dialog_createOption]
ArkUI_CustomDialogOptions* g_dialogOptions = nullptr;
// [StartExclude dialog_createOption]
void OpenTextDialog()
{
    // [EndExclude dialog_createOption]
    auto textNode = std::make_shared<NativeModule::ArkUITextNode>();
    if (!g_dialogOptions) {
        g_dialogOptions = OH_ArkUI_CustomDialog_CreateOptions(textNode->GetHandle());
    }
    // [End dialog_createOption]
    textNode->SetTextContent("this is a demo");
    OH_ArkUI_CustomDialog_SetAlignment(g_dialogOptions, static_cast<int32_t>(ARKUI_ALIGNMENT_BOTTOM), 0, 0);
    OH_ArkUI_CustomDialog_SetBackgroundColor(g_dialogOptions, 0xffffffff);
    OH_ArkUI_CustomDialog_SetModalMode(g_dialogOptions, false);
    OH_ArkUI_CustomDialog_SetAutoCancel(g_dialogOptions, true);
    OH_ArkUI_CustomDialog_SetBorderStyle(g_dialogOptions, ARKUI_BORDER_STYLE_SOLID,
                                         ARKUI_BORDER_STYLE_SOLID, ARKUI_BORDER_STYLE_SOLID, ARKUI_BORDER_STYLE_SOLID);
    OH_ArkUI_CustomDialog_OpenDialog(g_dialogOptions, OpenDialogCallBack);
}

void CloseCustomDialog()
{
    OH_ArkUI_CustomDialog_CloseDialog(g_id);
}

// 创建可交互界面，点击Button后弹窗
void MainViewMethod(ArkUI_NodeContentHandle handle)
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue widthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = widthValue, .size = sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem heightItem = {.value = heightValue, .size = sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &heightItem);
    
    g_buttonNode = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue buttonWidthValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem buttonWidthItem = {.value = buttonWidthValue,
                                           .size = sizeof(buttonWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_WIDTH, &buttonWidthItem);
    ArkUI_NumberValue buttonHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem buttonHeightItem = {.value = buttonHeightValue,
                                            .size = sizeof(buttonHeightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_HEIGHT, &buttonHeightItem);
    ArkUI_AttributeItem labelItem = {.string = "Click Dialog Box"};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
    ArkUI_NumberValue buttonTypeValue[] = {{.i32 = static_cast<int32_t>(ARKUI_BUTTON_TYPE_NORMAL)}};
    ArkUI_AttributeItem buttonTypeItem = {.value = buttonTypeValue,
                                          .size = sizeof(buttonTypeValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_TYPE, &buttonTypeItem);
    nodeAPI->registerNodeEvent(g_buttonNode, NODE_ON_CLICK, BUTTON_CLICK_ID, nullptr);
    nodeAPI->addNodeEventReceiver(g_buttonNode, OnButtonClicked);
    nodeAPI->addChild(column, g_buttonNode);
    OH_ArkUI_NodeContent_AddNode(handle, column);
}

void OnButtonClicked(ArkUI_NodeEvent *event)
{
    if (!event || !g_buttonNode) {
        return;
    }
    auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == BUTTON_CLICK_ID) {
        ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
        if (g_isShown) {
            g_isShown = false;
            ArkUI_AttributeItem labelItem = {.string = "Show Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            CloseCustomDialog();
        } else {
            g_isShown = true;
            ArkUI_AttributeItem labelItem = {.string = "Close Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            OpenTextDialog();
        }
    }
}

// 退出时删除g_dialogOptions
napi_value Dispose(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void

    if (g_dialogOptions) {
        // [Start dialog_disposeOption]
        OH_ArkUI_CustomDialog_DisposeOptions(g_dialogOptions);
        // [End dialog_disposeOption]
        g_dialogOptions = nullptr;
    }
    return result;
}

napi_value BuildDemoPage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args;
    napi_get_cb_info(env, info, &argc, &args, nullptr, nullptr);
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void
    
    ArkUI_NodeContentHandle contentHandle;
    // 将napi_value转为NodeContentHandle
    OH_ArkUI_GetNodeContentFromNapiValue(env, args, &contentHandle);
    MainViewMethod(contentHandle);
    return result;
}

}

// 弹窗的生命周期
namespace Dialog_LifeCycle_Demo {

ArkUI_NodeHandle CreateDialogContent();
void ShowDialog();
void CloseDialog();
void OnButtonClicked(ArkUI_NodeEvent *event);
void OnWillAppearCallBack(void* userdata);
void OnDidAppearCallBack(void* userdata);
void OnWillDisappearCallBack(void* userdata);
void OnDidDisappearCallBack(void* userdata);
void MainViewMethod(ArkUI_NodeContentHandle handle);

ArkUI_NativeDialogHandle g_dialogController = nullptr;
ArkUI_NodeHandle g_buttonNode = nullptr;
constexpr int32_t BUTTON_CLICK_ID = 1;
bool g_isShown = false;

// [Start dialog_lifecycle]
ArkUI_NodeHandle CreateDialogContent()
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidthValue,
                                         .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeightValue,
                                          .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NodeHandle span = nodeAPI->createNode(ARKUI_NODE_SPAN);
    ArkUI_AttributeItem spanItem = {.string = "This is a dialog box"};
    nodeAPI->setAttribute(span, NODE_SPAN_CONTENT, &spanItem);
    ArkUI_NodeHandle imageSpan = nodeAPI->createNode(ARKUI_NODE_IMAGE_SPAN);
    // 图片src/main/ets/pages/common/sky.jpg需要替换为开发者所需的资源文件
    ArkUI_AttributeItem imageSpanItem = {.string = "/pages/common/sky.jpg"};
    nodeAPI->setAttribute(imageSpan, NODE_IMAGE_SPAN_SRC, &imageSpanItem);
    ArkUI_NumberValue imageSpanWidthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem imageSpanWidthItem = {.value = imageSpanWidthValue,
                                              .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_WIDTH, &imageSpanWidthItem);
    ArkUI_NumberValue imageSpanHeightValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem imageSpanHeightItem = {.value = imageSpanHeightValue,
                                               .size = sizeof(textWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(imageSpan, NODE_HEIGHT, &imageSpanHeightItem);
    nodeAPI->addChild(text, span);
    nodeAPI->addChild(text, imageSpan);
    return text;
}

void OnWillAppearCallBack(void* userdata)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogContentTest", "OnWillAppearCallBack");
}

void OnDidAppearCallBack(void* userdata)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogContentTest", "OnDidAppearCallBack");
}

void OnWillDisappearCallBack(void* userdata)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogContentTest", "OnWillDisappearCallBack");
}

void OnDidDisappearCallBack(void* userdata)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogContentTest", "OnDidDisappearCallBack");
}

void ShowDialog()
{
    ArkUI_NativeDialogAPI_3 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_3 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_3"));
    if (!g_dialogController) {
        g_dialogController = dialogAPI->nativeDialogAPI1.create();
    }
    auto contentNode = CreateDialogContent();
    dialogAPI->nativeDialogAPI1.setContent(g_dialogController, contentNode);
    dialogAPI->nativeDialogAPI1.setAutoCancel(g_dialogController, true);
    dialogAPI->registerOnWillAppear(g_dialogController, nullptr, OnWillAppearCallBack);
    dialogAPI->registerOnDidAppear(g_dialogController, nullptr, OnDidAppearCallBack);
    dialogAPI->registerOnWillDisappear(g_dialogController, nullptr, OnWillDisappearCallBack);
    dialogAPI->registerOnDidDisappear(g_dialogController, nullptr, OnDidDisappearCallBack);
    dialogAPI->nativeDialogAPI1.show(g_dialogController, false);
}
// [End dialog_lifecycle]

// 关闭Controller方式dialog
void CloseDialog()
{
    ArkUI_NativeDialogAPI_1 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_1"));
    
    dialogAPI->close(g_dialogController);
}

// 触发controller弹窗
void OnButtonClicked(ArkUI_NodeEvent *event)
{
    if (!event || !g_buttonNode) {
        return;
    }
    auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == BUTTON_CLICK_ID) {
        ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
        if (g_isShown) {
            g_isShown = false;
            ArkUI_AttributeItem labelItem = {.string = "Show Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            CloseDialog();
        } else {
            g_isShown = true;
            ArkUI_AttributeItem labelItem = {.string = "Close Dialog Box"};
            nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
            ShowDialog();
        }
    }
}

// 创建可交互界面，点击Button后弹窗
void MainViewMethod(ArkUI_NodeContentHandle handle)
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue widthValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = widthValue, .size = sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {{.f32 = 300}};
    ArkUI_AttributeItem heightItem = {.value = heightValue, .size = sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &heightItem);
    
    g_buttonNode = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue buttonWidthValue[] = {{.f32 = 200}};
    ArkUI_AttributeItem buttonWidthItem = {.value = buttonWidthValue,
                                           .size = sizeof(buttonWidthValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_WIDTH, &buttonWidthItem);
    ArkUI_NumberValue buttonHeightValue[] = {{.f32 = 50}};
    ArkUI_AttributeItem buttonHeightItem = {.value = buttonHeightValue,
                                            .size = sizeof(buttonHeightValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_HEIGHT, &buttonHeightItem);
    ArkUI_AttributeItem labelItem = {.string = "Click Dialog Box"};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_LABEL, &labelItem);
    ArkUI_NumberValue buttonTypeValue[] = {{.i32 = static_cast<int32_t>(ARKUI_BUTTON_TYPE_NORMAL)}};
    ArkUI_AttributeItem buttonTypeItem = {.value = buttonTypeValue,
                                          .size = sizeof(buttonTypeValue) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(g_buttonNode, NODE_BUTTON_TYPE, &buttonTypeItem);
    nodeAPI->registerNodeEvent(g_buttonNode, NODE_ON_CLICK, BUTTON_CLICK_ID, nullptr);
    nodeAPI->addNodeEventReceiver(g_buttonNode, OnButtonClicked);
    nodeAPI->addChild(column, g_buttonNode);
    OH_ArkUI_NodeContent_AddNode(handle, column);
}

// 退出时删除dialogController
napi_value Dispose(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void

    if (g_dialogController) {
        ArkUI_NativeDialogAPI_1 *dialogAPI = reinterpret_cast<ArkUI_NativeDialogAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_1"));
        dialogAPI->dispose(g_dialogController);
        g_dialogController = nullptr;
    }
    return result;
}

napi_value BuildDemoPage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args;
    napi_get_cb_info(env, info, &argc, &args, nullptr, nullptr);
    napi_value result;
    napi_get_undefined(env, &result); // 返回undefined表示void
    
    ArkUI_NodeContentHandle contentHandle;
    // 将napi_value转为NodeContentHandle
    OH_ArkUI_GetNodeContentFromNapiValue(env, args, &contentHandle);
    MainViewMethod(contentHandle);
    return result;
}

} // Dialog_LifeCycle_Demo
} // Dialog_Demo
