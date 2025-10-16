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
#include "customdialogexample.h"
#include <arkui/native_dialog.h>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <js_native_api_types.h>
#include <mutex>

namespace ArkUICapiTest {
static ArkUI_CustomDialogOptions *g_dialogOption = nullptr;
static ArkUI_NativeDialogHandle globalCustomDialog = nullptr;
static ArkUI_NativeDialogAPI_3* g_dialogAPI3 = nullptr;
static int32_t g_dialogIdState = 0;
static std::mutex g_dialogIdMutex; // 全局互斥锁，保护 g_dialogIdState
CallBackData CustomDialogTest::callBackData;
static bool g_isEventState = false;
static bool g_isOpenDialog = false;
static bool g_isOpenController = false;
napi_env CustomDialogTest::g_env = nullptr;
std::vector<napi_ref> CustomDialogTest::g_callback_refs{};

enum CustomDialogSettingType {
    BACKGROUND_COLOR = 1,           // 背景颜色
    CORNER_RADIUS,                  // 圆角半径
    BORDER_COLORS,                  // 边框颜色
    BORDER_STYLE,                   // 边框样式
    BACKBOARD_SHADOW,               // 背板
    BACKBOARD_CUSTOM_SHADOW,        // 自定义背板阴影
    BACKGROUND_BLUR_STYLE,          // 背板模糊材质
    ALIGN_MODE,                     // 对齐模式
    MODAL_MODE,                     // 自定义弹窗是否开启模态样式的弹窗
    AUTO_CANCEL,                    // 自定义弹窗是否允许点击遮罩层退出
    SUBWINDOW_MODE,                 // 弹窗是否在子窗口显示此弹窗
    MASK,                           // 自定义弹窗遮罩属性
    KEYBOARD_AVOID_MODE,            // 弹窗的键盘避让模式
    HOVER_MODE_ENABLED,             // 弹窗是否响应悬停态
    HOVER_MODE_AREA,                // 悬停态下弹窗默认展示区域
    BACKGROUND_BLUR_STYLE_OPTIONS,  // 背景模糊效果
    BACKGROUND_EFFECT,              // 设置弹窗的背景效果参数
    LEVEL_MODE,                     // 设置弹窗的显示层级
    LEVEL_UNIQUE_ID,                // 设置弹窗显示层级页面下的节点id
    IMMERSIVE_MODE,                 // 设置嵌入式弹窗蒙层的显示区域
    SHOULD_BLOCK_DISMISS,           // 设置是否需要屏蔽系统关闭弹窗行为，true表示屏蔽系统行为不关闭弹窗，false表示不屏蔽
};

enum ControllerAttributeType {
    NATIVE_BACKGROUND_COLOR = 1,           // 背景颜色
    NATIVE_CORNER_RADIUS,                  // 圆角半径
    NATIVE_BORDER_COLORS,                  // 边框颜色
    NATIVE_BORDER_STYLE,                   // 边框样式
    NATIVE_BACKBOARD_SHADOW,               // 背板阴影
    NATIVE_BACKBOARD_CUSTOM_SHADOW,        // 自定义背板阴影
    NATIVE_BACKGROUND_BLUR_STYLE,          // 背板模糊材质
    NATIVE_HOVER_MODE_ENABLED,             // 是否响应悬停态
    NATIVE_HOVER_MODE_AREA,                // 悬停态下弹窗默认展示区域
    NATIVE_FOCUSABLE,                      // 是否获取焦点
    NATIVE_BACKGROUND_BLUR_STYLE_OPTIONS,  // 背景模糊效果
    NATIVE_BACKGROUND_EFFECT,              // 弹窗的背景效果参数
    NATIVE_CONTENT_ALIGNMENT,              // 设置自定义弹窗对齐方式。
    NATIVE_RESET_CONTENT_ALIGNMENT,        // 重置setContentAlignment方法设置的属性，使用系统默认的对齐方式。
    NATIVE_MODAL_MODE,                     // 设置自定义弹窗是否开启模态样式的弹窗
    NATIVE_AUTO_CANCEL,                    // 设置自定义弹窗是否允许通过点击遮罩层退出
    NATIVE_MASK,                           // 设置自定义弹窗遮罩属性
    NATIVE_COLUMN_COUNT,                   // 设置弹窗宽度占栅格宽度的个数
    NATIVE_CUSTOM_STYLE,                   // 弹窗容器样式是否可以自定义
    NATIVE_CUSTOM_ANIMATION,               // 弹窗容器是否使用自定义弹窗动画
    NATIVE_KEYBOARD_AVOID_MODE,            // 设置自定义弹窗避让键盘模式
    NATIVE_LEVEL_MODE,                     // 设置弹窗的显示层级
    NATIVE_LEVEL_UNIQUE_ID,                // 设置弹窗显示层级页面下的节点id
    NATIVE_IMMERSIVE_MODE,                 // 设置嵌入式弹窗蒙层的显示区域
    NATIVE_LEVEL_ORDER,                    // 设置自定义弹窗显示的顺序
    NATIVE_REGISTER_ON_WILL_DISMISS,       // 当触发系统定义的返回操作、键盘ESC关闭交互操作时，如果注册了该回调函数，弹窗不会立即关闭，而是由用户决定是否关闭。
    NATIVE_REGISTER_ON_WILL_DISMISS_WITH_USER_DATA, // 注册系统关闭自定义弹窗的监听事件
};

static void OnWillDismiss(ArkUI_DialogDismissEvent *event)
{
    ArkUI_AttributeItem id_item = {};
    id_item.string = "willDismiss";
    CustomDialogTest::callBackData.willDismiss = id_item.string;

    OH_ArkUI_DialogDismissEvent_SetShouldBlockDismiss(event, g_isEventState);
    OH_ArkUI_DialogDismissEvent_GetUserData(event);
    OH_ArkUI_DialogDismissEvent_GetDismissReason(event);
}

void CallCallbackMethodWithString(napi_env env, const char *methodName, const std::string &value)
{
    if (CustomDialogTest::g_callback_refs.empty()) {
        return;
    }
    for (auto &ref : CustomDialogTest::g_callback_refs) {
        if (ref == nullptr) {
            continue;
        }
        napi_value cbObj = nullptr;
        if (napi_get_reference_value(env, ref, &cbObj) != napi_ok || cbObj == nullptr) {
            continue;
        }
        napi_value method = nullptr;
        if (napi_get_named_property(env, cbObj, methodName, &method) != napi_ok) {
            continue;
        }
        napi_valuetype methodType;
        if (napi_typeof(env, method, &methodType) != napi_ok || methodType != napi_function) {
            continue;
        }
        napi_value argv[1];
        napi_create_string_utf8(env, value.c_str(), NAPI_AUTO_LENGTH, &argv[0]);
        napi_value result;
        napi_call_function(env, cbObj, method, 1, argv, &result);
    }
}

void ShowDialogState(ArkUI_DialogState state)
{
    std::string resultStr;
    switch (state) {
        case DIALOG_UNINITIALIZED:
            resultStr = "DIALOG_UNINITIALIZED";
            break;
        case DIALOG_INITIALIZED:
            resultStr = "DIALOG_INITIALIZED";
            break;
        case DIALOG_APPEARING:
            resultStr = "DIALOG_APPEARING";
            break;
        case DIALOG_APPEARED:
            resultStr = "DIALOG_APPEARED";
            break;
        case DIALOG_DISAPPEARING:
            resultStr = "DIALOG_DISAPPEARING";
            break;
        case DIALOG_DISAPPEARED:
            resultStr = "DIALOG_DISAPPEARED";
            break;
        default:
            break;
    }
    CallCallbackMethodWithString(CustomDialogTest::g_env, "fromNapiCallWithStringParam", resultStr);
}

static void OnWillAppear(void *userData)
{
    ArkUI_AttributeItem id_item = {};
    id_item.string = "willAppear";
    CustomDialogTest::callBackData.willAppear = id_item.string;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "OnWillAppear");
}

static void OnDidAppear(void *userData)
{
    ArkUI_AttributeItem id_item = {};
    id_item.string = "didAppear";
    CustomDialogTest::callBackData.didAppear = id_item.string;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "OnDidAppear");
    ArkUI_DialogState state = DIALOG_UNINITIALIZED;
    int32_t result = OH_ArkUI_CustomDialog_GetState(reinterpret_cast<ArkUI_NativeDialogHandle>(g_dialogOption), &state);
    CallCallbackMethodWithString(CustomDialogTest::g_env, "fromNapiCallWithStringParam", "DIALOG_APPEARED");
}

static void OnWillDisappear(void *userData)
{
    ArkUI_AttributeItem id_item = {};
    id_item.string = "willDisappear";
    CustomDialogTest::callBackData.willDisappear = id_item.string;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "OnWillDisappear");
}

static void OnDidDisappear(void *userData)
{
    ArkUI_AttributeItem id_item = {};
    id_item.string = "didDisappear";
    CustomDialogTest::callBackData.didDisappear = id_item.string;
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "OnDidDisappear");
    ArkUI_DialogState state = DIALOG_UNINITIALIZED;
    int32_t result = OH_ArkUI_CustomDialog_GetState(reinterpret_cast<ArkUI_NativeDialogHandle>(g_dialogOption), &state);
    CallCallbackMethodWithString(CustomDialogTest::g_env, "fromNapiCallWithStringParam", "DIALOG_DISAPPEARED");
}

void MyCustomCallback(int32_t dialogId)
{
    std::lock_guard<std::mutex> lock(g_dialogIdMutex);
    g_dialogIdState = dialogId;
}

void MyCustomCallback2(int32_t dialogId)
{
    std::lock_guard<std::mutex> lock(g_dialogIdMutex);
    g_dialogIdState = dialogId;
}

void MyOnClose(ArkUI_NodeEvent *event)
{
    if (g_dialogOption) {
        std::lock_guard<std::mutex> lock(g_dialogIdMutex);
        OH_ArkUI_CustomDialog_CloseDialog(g_dialogIdState);
    }
}

ArkUI_NodeHandle CreateStyledButton(ArkUI_NativeNodeAPI_1 *nodeAPI,
    ArkUI_NodeHandle parent,
    const char *text,
    void (*eventReceiver)(ArkUI_NodeEvent *callback),
    int32_t eventId = 0)
{
    if (!nodeAPI) {
        return nullptr;
    }

    const char *id = text;
    auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    button = CustomDialogUtils::SetButton(nodeAPI, button, id, text);
    int32_t ret = 0;
    ret = nodeAPI->registerNodeEvent(button, NODE_ON_CLICK, eventId, nullptr);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "CreateStyledButton registerNodeEvent failed, ret = %{public}d ", ret);
    }
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "CreateStyledButton registerNodeEvent failed, ret = %{public}d ", ret);
    }
    ret = nodeAPI->addNodeEventReceiver(button, eventReceiver);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "CreateStyledButton addNodeEventReceiver failed, ret = %{public}d ", ret);
    }
    nodeAPI->addChild(parent, button);
    return button;
}

int32_t SetDialogBackgroundColor(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    ret = OH_ArkUI_CustomDialog_SetBackgroundColor(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBackgroundColor failed, ret = %{public}d", ret);
    }
    ret = OH_ArkUI_CustomDialog_UpdateDialog(g_dialogOption, MyCustomCallback2);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_UpdateDialog failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetDialogBackboardShadow()
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    ret = OH_ArkUI_CustomDialog_SetShadow(g_dialogOption, ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetShadow failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogBackboardCustomShadow()
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置自定义阴影
    ArkUI_NumberValue custom_shadow_value[] = {
        {.f32 = 50}, {.i32 = {}}, {.f32 = {}}, {.f32 = {}},
        {.i32 = {}}, {.u32 = COLOR_RED}, {.u32 = PARAM_200}
    };
    ArkUI_AttributeItem custom_shadow_item = {
        custom_shadow_value, sizeof(custom_shadow_value) / sizeof(ArkUI_NumberValue)
    };
    ret = OH_ArkUI_CustomDialog_SetCustomShadow(g_dialogOption, &custom_shadow_item);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetCustomShadow failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogBorderColors(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 始终设置全部四个边框
    ret = OH_ArkUI_CustomDialog_SetBorderColor(g_dialogOption, nodeValue, nodeValue, nodeValue, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBorderColor failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogBorderStyle(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    int32_t borderStyle = nodeValue;
    ret = OH_ArkUI_CustomDialog_SetBorderStyle(g_dialogOption, borderStyle, borderStyle, borderStyle, borderStyle);
    // 设置边框颜色
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBorderStyle failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogCornerRadius(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置圆角半径
    ret = OH_ArkUI_CustomDialog_SetCornerRadius(g_dialogOption, nodeValue, nodeValue, nodeValue, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetCornerRadius failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetDialogBackgroundBlurStyle(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置背板模糊材质
    ret = OH_ArkUI_CustomDialog_SetBackgroundBlurStyle(g_dialogOption, (ArkUI_BlurStyle)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBackgroundBlurStyle failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogAlignment(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗的对齐模式
    ret = OH_ArkUI_CustomDialog_SetAlignment(g_dialogOption, static_cast<ArkUI_Alignment>(nodeValue), 0, PARAM_200);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetAlignment failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetDialogModalMode(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置自定义弹窗是否开启模态样式的弹窗
    ret = OH_ArkUI_CustomDialog_SetModalMode(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetModalMode failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogAutoCancel(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置自定义弹窗是否允许点击遮罩层退出
    ret = OH_ArkUI_CustomDialog_SetAutoCancel(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetAutoCancel failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogSubwindowMode(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗是否在子窗口显示此弹窗
    ret = OH_ArkUI_CustomDialog_SetSubwindowMode(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetSubwindowMode failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetDialogMask()
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    ArkUI_Rect maskRect = {PARAM_0, PARAM_0, PARAM_500, PARAM_500};
    // 设置自定义弹窗遮罩属性
    ret = OH_ArkUI_CustomDialog_SetMask(g_dialogOption, COLOR_RED, &maskRect);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetMask failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogKeyboardAvoidMode(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗避让键盘的模式
    ret = OH_ArkUI_CustomDialog_SetKeyboardAvoidMode(g_dialogOption, (ArkUI_KeyboardAvoidMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetKeyboardAvoidMode failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogHoverModeEnabled(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗是否响应悬停态。
    ret = OH_ArkUI_CustomDialog_SetHoverModeEnabled(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetHoverModeEnabled failed, ret = %{public}d", ret);
    }
    // 设置悬停态下弹窗默认展示区域
    ret = OH_ArkUI_CustomDialog_SetHoverModeArea(g_dialogOption, ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetHoverModeArea failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogHoverModeArea(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗是否响应悬停态。
    ret = OH_ArkUI_CustomDialog_SetHoverModeEnabled(g_dialogOption, true);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetHoverModeEnabled failed, ret = %{public}d", ret);
    }
    // 设置悬停态下弹窗默认展示区域
    ret = OH_ArkUI_CustomDialog_SetHoverModeArea(g_dialogOption, (ArkUI_HoverModeAreaType)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetHoverModeArea failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogBackgroundBlurStyleOptions()
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 模糊效果
    ArkUI_NumberValue blurValues[] = {
        {.i32 = ARKUI_COLOR_MODE_LIGHT},
        {.i32 = ARKUI_ADAPTIVE_COLOR_AVERAGE},
        {.f32 = PARAM_1},
        {.u32 = PARAM_20},
        {.u32 = PARAM_20},
        {.i32 = ARKUI_BLUR_STYLE_ACTIVE_POLICY_ALWAYS_ACTIVE},
        {.u32 = COLOR_RED}
    };
    ArkUI_AttributeItem blurItem = {
        blurValues,
        sizeof(blurValues) / sizeof(ArkUI_NumberValue)
    };
    // 设置弹窗的背景模糊效果
    int32_t ret = OH_ArkUI_CustomDialog_SetBackgroundBlurStyleOptions(g_dialogOption, &blurItem);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBackgroundBlurStyleOptions failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogBackgroundEffect()
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 背景效果
    ArkUI_NumberValue effectValues[] = {
        {.f32 = 0}, {.f32 = 0}, {.f32 = 0.0001},
        {.u32 = 0x66FFFFFF}, {.i32 = 0}, {.u32 = PARAM_300},
        {.u32 = PARAM_300}, {.i32 = 1}, {.u32 = 0x00FF0000}
    };
    ArkUI_AttributeItem effectItem = {
        effectValues,
        sizeof(effectValues) / sizeof(ArkUI_NumberValue)
    };
    // 设置弹窗的背景效果参数
    int32_t ret = OH_ArkUI_CustomDialog_SetBackgroundEffect(g_dialogOption, &effectItem);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBackgroundEffect failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogLevelMode(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "SetDialogLevelMode");
    int32_t ret = 0;
    // 设置弹窗的显示层级
    ret = OH_ArkUI_CustomDialog_SetLevelMode(g_dialogOption, (ArkUI_LevelMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetLevelMode failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogLevelUniqueId(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置层级唯一ID
    ret = OH_ArkUI_CustomDialog_SetLevelUniqueId(g_dialogOption, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetLevelUniqueId failed, ret = %{public}d", ret);
    }
    return ret;
}


int32_t SetDialogImmersiveMode(uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置嵌入式弹窗蒙层的显示区域
    ret = OH_ArkUI_CustomDialog_SetImmersiveMode(g_dialogOption, (ArkUI_ImmersiveMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetImmersiveMode failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetDialogShouldBlockDismiss(ArkUI_NodeHandle contentNode, uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    g_isEventState = nodeValue;
    int32_t ret = 0;
    // 注册关闭回调
    ret = OH_ArkUI_CustomDialog_RegisterOnWillDismissCallback(g_dialogOption, contentNode, OnWillDismiss);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_RegisterOnWillDismissCallback failed, ret = %{public}d", ret);
    }
    return ret;
}

int32_t SetCustomDialogProperties2(ArkUI_NodeHandle contentNode, int32_t nodeType, uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    CustomDialogSettingType settingType = static_cast<CustomDialogSettingType>(nodeType);
    switch (settingType) {
        case CustomDialogSettingType::MASK: // 设置弹窗是否在子窗口显示此弹窗
            ret = SetDialogMask();
            break;
        case CustomDialogSettingType::KEYBOARD_AVOID_MODE: // 弹窗的键盘避让模式
            ret = SetDialogKeyboardAvoidMode(nodeValue);
            break;
        case CustomDialogSettingType::HOVER_MODE_ENABLED: // 弹窗是否响应悬停态
            ret = SetDialogHoverModeEnabled(nodeValue);
            break;
        case CustomDialogSettingType::HOVER_MODE_AREA: // 悬停态下弹窗默认展示区域
            ret = SetDialogHoverModeArea(nodeValue);
            break;
        case CustomDialogSettingType::BACKGROUND_BLUR_STYLE_OPTIONS: // 背景模糊效果
            ret = SetDialogBackgroundBlurStyleOptions();
            break;
        case CustomDialogSettingType::BACKGROUND_EFFECT: // 设置弹窗的背景效果参数
            ret = SetDialogBackgroundEffect();
            break;
        case CustomDialogSettingType::LEVEL_MODE: // 设置弹窗的显示层级
            ret = SetDialogLevelMode(nodeValue);
            break;
        case CustomDialogSettingType::LEVEL_UNIQUE_ID: // 设置弹窗显示层级页面下的节点id
            ret = SetDialogLevelUniqueId(nodeValue);
            break;
        case CustomDialogSettingType::IMMERSIVE_MODE: // 设置嵌入式弹窗蒙层的显示区域
            ret = SetDialogImmersiveMode(nodeValue);
            break;
        case CustomDialogSettingType::
            SHOULD_BLOCK_DISMISS: // 设置是否需要屏蔽系统关闭弹窗行为，true表示屏蔽系统行为不关闭弹窗，false表示不屏
            ret = SetDialogShouldBlockDismiss(contentNode, nodeValue);
            break;
        default:
            return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    return ret;
}

int32_t SetCustomDialogProperties(ArkUI_NodeHandle contentNode, int32_t nodeType, uint32_t nodeValue)
{
    if (!g_dialogOption) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    CustomDialogSettingType settingType = static_cast<CustomDialogSettingType>(nodeType);
    switch (settingType) {
        case CustomDialogSettingType::BACKGROUND_COLOR : // 设置背景颜色
            ret = SetDialogBackgroundColor(nodeValue);
            break;
        case CustomDialogSettingType::CORNER_RADIUS : // 设置圆角半径
            ret = SetDialogCornerRadius(nodeValue);
            break;
        case CustomDialogSettingType::BORDER_COLORS : // 设置边框颜色
            ret = SetDialogBorderColors(nodeValue);
            break;
        case CustomDialogSettingType::BORDER_STYLE: // 设置边框样式
            ret = SetDialogBorderStyle(nodeValue);
            break;
        case CustomDialogSettingType::BACKBOARD_SHADOW: // 设置背板阴影
            ret = SetDialogBackboardShadow();
            break;
        case CustomDialogSettingType::BACKBOARD_CUSTOM_SHADOW: // 设置自定义背板阴影
            ret = SetDialogBackboardCustomShadow();
            break;
        case CustomDialogSettingType::BACKGROUND_BLUR_STYLE: // 设置背板模糊材质
            ret = SetDialogBackgroundBlurStyle(nodeValue);
            break;
        case CustomDialogSettingType::ALIGN_MODE: // 设置弹窗的对齐模式
            ret = SetDialogAlignment(nodeValue);
            break;
        case CustomDialogSettingType::MODAL_MODE: // 设置自定义弹窗是否开启模态样式的弹窗
            ret = SetDialogModalMode(nodeValue);
            break;
        case CustomDialogSettingType::AUTO_CANCEL: // 设置自定义弹窗是否允许点击遮罩层退出
            ret = SetDialogAutoCancel(nodeValue);
            break;
        case CustomDialogSettingType::SUBWINDOW_MODE: // 设置弹窗是否在子窗口显示此弹窗
            ret = SetDialogSubwindowMode(nodeValue);
            break;
        default:
            ret = SetCustomDialogProperties2(contentNode, nodeType, nodeValue);
            break;
    }
    return ret;
}

void SetDialogBasicStyle(ArkUI_CustomDialogOptions* controller)
{
    if (!controller) {
        return;
    }
    int32_t ret = 0;
    // 设置边框宽度
    ret = OH_ArkUI_CustomDialog_SetBorderWidth(controller, PARAM_2, PARAM_2, PARAM_2, PARAM_2,
        ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetBorderWidth failed, ret = %{public}d", ret);
    }

     // 设置宽度
    ret = OH_ArkUI_CustomDialog_SetWidth(controller, PARAM_300, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetWidth failed, ret = %{public}d", ret);
    }
    // 设置高度
    ret = OH_ArkUI_CustomDialog_SetHeight(controller, PARAM_200, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_SetHeight failed, ret = %{public}d", ret);
    }
}

// 注册对话框回调事件
void RegisterDialogCallbacks(ArkUI_CustomDialogOptions* controller, ArkUI_NodeHandle contentNode)
{
    if (!controller) {
        return;
    }
    int32_t ret = 0;
    // 注册显示前回调
    ret = OH_ArkUI_CustomDialog_RegisterOnWillAppearCallback(controller, contentNode, OnWillAppear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_RegisterOnWillAppearCallback failed, ret = %{public}d", ret);
    }

    // 注册显示后回调
    ret = OH_ArkUI_CustomDialog_RegisterOnDidAppearCallback(controller, contentNode, OnDidAppear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_RegisterOnDidAppearCallback failed, ret = %{public}d", ret);
    }

    // 注册消失前回调
    ret = OH_ArkUI_CustomDialog_RegisterOnWillDisappearCallback(controller, contentNode, OnWillDisappear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_RegisterOnWillDisappearCallback failed, ret = %{public}d", ret);
    }

    // 注册消失后回调
    ret = OH_ArkUI_CustomDialog_RegisterOnDidDisappearCallback(controller, contentNode, OnDidDisappear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "OH_ArkUI_CustomDialog_RegisterOnDidDisappearCallback failed, ret = %{public}d", ret);
    }
}

// 主初始化函数
void InitDialogOptions(ArkUI_CustomDialogOptions* controller, ArkUI_NodeHandle contentNode)
{
    if (!controller) {
        return;
    }
    SetDialogBasicStyle(controller);
    RegisterDialogCallbacks(controller, contentNode);
}

bool CreateCustomDialog()
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
        if (!nodeAPI) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Error", "nodeAPI is null");
            return false;
        }
        // 创建对话框内容
        auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
        if (!column) {
            return false;
        }
        // 创建对话框控制器
        auto dialogController = OH_ArkUI_CustomDialog_CreateOptions(column);
        if (!dialogController) {
            return false;
        }
        g_dialogOption = dialogController;
        ArkUI_DialogState state = DIALOG_UNINITIALIZED;
        OH_ArkUI_CustomDialog_GetState(reinterpret_cast<ArkUI_NativeDialogHandle>(g_dialogOption), &state);
        ShowDialogState(state);
        InitDialogOptions(g_dialogOption, column);
        CreateStyledButton(nodeAPI, column, "close", MyOnClose);
        g_isOpenDialog = true;
        return true;
}

int32_t CustomDialogTest::SetCustomDialogDialogAttribute(int32_t nodeType, uint32_t nodeValue)
{
    ArkUI_DialogState state = DIALOG_UNINITIALIZED;
    int32_t result = OH_ArkUI_CustomDialog_GetState(reinterpret_cast<ArkUI_NativeDialogHandle>(g_dialogOption), &state);
    ShowDialogState(state);
    ArkUI_NodeHandle column;
    if (!g_isOpenDialog && !g_dialogOption) {
        bool ret = CreateCustomDialog();
        if (!ret) {
            return ARKUI_ERROR_CODE_PARAM_INVALID;
        }
    }
    result = SetCustomDialogProperties(column, nodeType, nodeValue);
    return result;
}

static void CloseApplication()
{
    std::lock_guard<std::mutex> lock(g_dialogIdMutex);
    OH_ArkUI_CustomDialog_DisposeOptions(g_dialogOption);
}

napi_value CustomDialogTest::SetCustomDialog(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "customDialogAttrsTest");

    // 1. 获取参数
    size_t argc = 2;
    napi_value argv[2];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 2. 检查参数数量
    if (argc < 2) {
        napi_throw_error(env, nullptr, "Expected 2 arguments: nodeType (string) and nodeValue (number)");
        return nullptr;
    }

    // 3. 提取第一个参数（nodeType，字符串）
    int32_t nodeType;
    int status = napi_get_value_int32(env, argv[0], &nodeType);
    if (status != napi_ok) {
        napi_throw_type_error(env, nullptr, "nodeValue must be a number");
        return nullptr;
    }
     // 4. 提取第二个参数（nodeValue，数字）
    uint32_t nodeValue;
    status = napi_get_value_uint32(env, argv[1], &nodeValue);
    if (status != napi_ok) {
        napi_throw_type_error(env, nullptr, "nodeValue must be a number");
        return nullptr;
    }
    g_env = env;
    int32_t result = SetCustomDialogDialogAttribute(nodeType, nodeValue);

    // 返回 int 给 JavaScript
    napi_value jsResult;
    napi_create_int32(env, result, &jsResult);
    return jsResult;
}

napi_value CustomDialogTest::CloseDialog(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "CloseDialog");
    CloseApplication();
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        return nullptr;
    }
    return exports;
}

napi_value CustomDialogTest::CloseCustomDialog(napi_env env, napi_callback_info info)
{
    if (g_dialogOption) {
        std::lock_guard<std::mutex> lock(g_dialogIdMutex);
        OH_ArkUI_CustomDialog_CloseDialog(g_dialogIdState);
        g_dialogOption = nullptr;
        ArkUI_DialogState state = DIALOG_UNINITIALIZED;
        OH_ArkUI_CustomDialog_GetState(reinterpret_cast<ArkUI_NativeDialogHandle>(g_dialogOption), &state);
        ShowDialogState(state);
        g_isOpenDialog = false;
    }
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        return nullptr;
    }
    return exports;
}

napi_value CustomDialogTest::OpenCustomDialog(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest", "CloseDialog");
    if (!g_isOpenDialog && !g_dialogOption) {
        bool ret = CreateCustomDialog();
        if (!ret) {
            return nullptr;
        }
    }
    if (g_dialogOption) {
        OH_ArkUI_CustomDialog_OpenDialog(g_dialogOption, MyCustomCallback);
    }
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        return nullptr;
    }
    return exports;
}

napi_value CustomDialogTest::NAPI_Global_setNapiCallback(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < 1 || args[0] == nullptr) {
        napi_value undefinedRet;
        napi_get_undefined(env, &undefinedRet);
        return undefinedRet;
    }

    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    if (valueType != napi_object) {
        napi_value undefinedRet;
        napi_get_undefined(env, &undefinedRet);
        return undefinedRet;
    }

    // 保存回调对象引用，允许多次注册
    napi_ref ref = nullptr;
    napi_create_reference(env, args[0], 1, &ref);
    if (ref != nullptr) {
        CustomDialogTest::g_callback_refs.clear();
        CustomDialogTest::g_callback_refs.push_back(ref);
    }

    napi_value undefinedRet;
    napi_get_undefined(env, &undefinedRet);
    return undefinedRet;
}

// 注册对话框回调事件
void RegisterDialogControllerCallbacks()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return;
    }
    int32_t ret = 0;
    // 注册显示前回调
    ret = g_dialogAPI3->registerOnWillAppear(globalCustomDialog, nullptr, OnWillAppear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "registerOnWillAppear failed, ret = %{public}d", ret);
    }

    // 注册显示后回调
    ret = g_dialogAPI3->registerOnDidAppear(globalCustomDialog, nullptr, OnDidAppear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "registerOnDidAppear failed, ret = %{public}d", ret);
    }

    // 注册消失前回调
    ret = g_dialogAPI3->registerOnWillDisappear(globalCustomDialog, nullptr, OnWillDisappear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "registerOnWillDisappear failed, ret = %{public}d", ret);
    }

    // 注册消失后回调
    ret = g_dialogAPI3->registerOnDidDisappear(globalCustomDialog, nullptr, OnDidDisappear);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "registerOnDidDisappear failed, ret = %{public}d", ret);
    }
}

// 设置对话框样式属性
static void SetDialogStyles()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return;
    }
    int32_t ret = 0;

    ret = g_dialogAPI3->setBorderWidth(globalCustomDialog, PARAM_2, PARAM_2, PARAM_2, PARAM_2,
        ARKUI_LENGTH_METRIC_UNIT_PX);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "SetDialogStyles setBorderWidth failed, ret = %{public}d ", ret);
    }

    // 设置尺寸
    ret = g_dialogAPI3->setWidth(globalCustomDialog, PARAM_300, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "SetDialogStyles setWidth failed, ret = %{public}d ", ret);
    }

    ret = g_dialogAPI3->setHeight(globalCustomDialog, PARAM_200, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "SetDialogStyles setHeight failed, ret = %{public}d ", ret);
    }
    RegisterDialogControllerCallbacks();
}

int32_t SetNativeDialogBackgroundColor(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置背景颜色
    ret = g_dialogAPI3->nativeDialogAPI1.setBackgroundColor(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBackgroundColor failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogCornerRadius(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置圆角
    ret = g_dialogAPI3->nativeDialogAPI1.setCornerRadius(globalCustomDialog, nodeValue, nodeValue,
        nodeValue, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setCornerRadius failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogBorderColor(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置边框
    ret = g_dialogAPI3->setBorderColor(globalCustomDialog, nodeValue, nodeValue, nodeValue, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBorderColor failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogBorderStyle(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置边框样式
    ret = g_dialogAPI3->setBorderStyle(globalCustomDialog, nodeValue, nodeValue, nodeValue, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBorderStyle failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogShadow()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = g_dialogAPI3->setShadow(globalCustomDialog, ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setShadow failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogCustomShadow()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置自定义阴影
    ArkUI_NumberValue custom_shadow_value[] = {
        {.f32 = 50}, {.i32 = {}}, {.f32 = {}}, {.f32 = {}},
        {.i32 = {}}, {.u32 = COLOR_RED}, {.u32 = PARAM_200}
    };
    ArkUI_AttributeItem custom_shadow_item = {
        custom_shadow_value, sizeof(custom_shadow_value) / sizeof(ArkUI_NumberValue)
    };
    int32_t ret = g_dialogAPI3->setCustomShadow(globalCustomDialog, &custom_shadow_item);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setCustomShadow failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogBackgroundBlurStyle()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = g_dialogAPI3->setBackgroundBlurStyle(globalCustomDialog, ARKUI_BLUR_STYLE_COMPONENT_ULTRA_THICK);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBackgroundBlurStyle failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogEnableHoverMode(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置弹窗是否响应悬停态。
    ret = g_dialogAPI3->enableHoverMode(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "enableHoverMode failed, ret = %{public}d ", ret);
    }
    ret = g_dialogAPI3->setHoverModeArea(globalCustomDialog, ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setHoverModeArea failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogFocusable(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    // 设置自定义弹窗是否获取焦点。
    ret = g_dialogAPI3->setFocusable(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setFocusable failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogHoverModeArea(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置弹窗是否响应悬停态
    int32_t ret = g_dialogAPI3->enableHoverMode(globalCustomDialog, true);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "enableHoverMode failed, ret = %{public}d ", ret);
    }
    ret = g_dialogAPI3->setHoverModeArea(globalCustomDialog, static_cast<ArkUI_HoverModeAreaType>(nodeValue));
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setHoverModeArea failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogBackgroundBlurStyleOptions()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置背景效果选项
    ArkUI_NumberValue custom_BlurStyleOptions_value[] = {
        {.i32 = ARKUI_COLOR_MODE_LIGHT}, {.i32 = ARKUI_ADAPTIVE_COLOR_AVERAGE},
        {.f32 = 1}, {.u32 = PARAM_20}, {.u32 = PARAM_20},
        {.i32 = ARKUI_BLUR_STYLE_ACTIVE_POLICY_ALWAYS_ACTIVE}, {.u32 = COLOR_RED}
    };
    ArkUI_AttributeItem custom_BlurStyleOptions_item = {
        custom_BlurStyleOptions_value, sizeof(custom_BlurStyleOptions_value) / sizeof(ArkUI_NumberValue)
    };
    int32_t ret = g_dialogAPI3->setBackgroundBlurStyleOptions(globalCustomDialog, &custom_BlurStyleOptions_item);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBackgroundBlurStyleOptions failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogSetupBackgroundEffect()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 背景效果
    ArkUI_NumberValue effectValues[] = {
        {.f32 = 0}, {.f32 = 0}, {.f32 = 0.0001},
        {.u32 = 0x66FFFFFF}, {.i32 = 0}, {.u32 = PARAM_300},
        {.u32 = PARAM_300}, {.i32 = 1}, {.u32 = 0x00FF0000}
    };
    ArkUI_AttributeItem effectItem = {
        effectValues,
        sizeof(effectValues) / sizeof(ArkUI_NumberValue)
    };
    // 设置弹窗的背景效果参数
    int32_t ret = g_dialogAPI3->setBackgroundEffect(globalCustomDialog,  &effectItem);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setBackgroundEffect failed, ret = %{public}d ", ret);
    }
    return ret;
}

napi_value CustomDialogTest::SetDialogController(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest", "customDialogAttrsTest");

    // 1. 获取参数
    size_t argc = 2;
    napi_value argv[2];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 2. 检查参数数量
    if (argc < 2) {
        napi_throw_error(env, nullptr, "Expected 2 arguments: nodeType (string) and nodeValue (number)");
        return nullptr;
    }

    // 3. 提取第一个参数（nodeType，字符串）
    int32_t nodeType;
    int status = napi_get_value_int32(env, argv[0], &nodeType);
    if (status != napi_ok) {
        napi_throw_type_error(env, nullptr, "nodeValue must be a number");
        return nullptr;
    }
     // 4. 提取第二个参数（nodeValue，数字）
    uint32_t nodeValue;
    status = napi_get_value_uint32(env, argv[1], &nodeValue);
    if (status != napi_ok) {
        napi_throw_type_error(env, nullptr, "nodeValue must be a number");
        return nullptr;
    }
    g_env = env;
    int32_t result = OnEventReceiveTestAPI(nodeType, nodeValue);

    // 返回 int 给 JavaScript
    napi_value jsResult;
    napi_create_int32(env, result, &jsResult);
    return jsResult;
}

int32_t CustomDialogTest::SetDialogControllerAttribute(int32_t nodeType, uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    auto type = static_cast<ControllerAttributeType>(nodeType);
    switch (type) {
        case ControllerAttributeType::NATIVE_BACKGROUND_COLOR : // 设置背景颜色
            ret = SetNativeDialogBackgroundColor(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_CORNER_RADIUS : // 设置圆角半径
            ret = SetNativeDialogCornerRadius(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_BORDER_COLORS: // 设置边框颜色
            ret = SetNativeDialogBorderColor(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_BORDER_STYLE: // 设置边框样式
            ret = SetNativeDialogBorderStyle(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_BACKBOARD_SHADOW: // 设置背板阴影
            ret = SetNativeDialogShadow();
            break;
        case ControllerAttributeType::NATIVE_BACKBOARD_CUSTOM_SHADOW: // 设置自定义背板阴影
            ret = SetNativeDialogCustomShadow();
            break;
        case ControllerAttributeType::NATIVE_BACKGROUND_BLUR_STYLE: // 设置背板模糊材质
            ret = SetNativeDialogBackgroundBlurStyle();
            break;
        case ControllerAttributeType::NATIVE_HOVER_MODE_ENABLED: // 设置是否响应悬停态
            ret = SetNativeDialogEnableHoverMode(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_HOVER_MODE_AREA: // 设置悬停态下自定义弹窗默认展示区域
            ret = SetNativeDialogHoverModeArea(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_FOCUSABLE: // 设置自定义弹窗是否获取焦点
            ret = SetNativeDialogFocusable(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_BACKGROUND_BLUR_STYLE_OPTIONS: // 设置弹窗的背景模糊效果
            ret = SetNativeDialogBackgroundBlurStyleOptions();
            break;
        case ControllerAttributeType::NATIVE_BACKGROUND_EFFECT: // 设置弹窗的背景效果参数
            ret = SetNativeDialogSetupBackgroundEffect();
            break;
        default:
            ret = -1;
            break;
    }
    return ret;
}

int32_t SetNativeDialogContenAlignment()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置自定义弹窗对齐方式
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setContentAlignment(globalCustomDialog, ARKUI_ALIGNMENT_TOP, 0, 0);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setContentAlignment failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogResetContentAlignment()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 重置setContentAlignment方法设置的属性，使用系统默认的对齐方式
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.resetContentAlignment(globalCustomDialog);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "resetContentAlignment failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogModalMode(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置模态
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setModalMode(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setModalMode failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogAutoCancel(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置自定义弹窗遮罩属性
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setAutoCancel(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setAutoCancel failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogMask()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置遮罩
    ArkUI_Rect maskRect = {PARAM_0, PARAM_0, PARAM_500, PARAM_500};
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setMask(globalCustomDialog, COLOR_RED, &maskRect);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest", "setMask failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogCornerRadius()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置圆角
    float topLeft = PARAM_15;
    float topRight = PARAM_15;
    float bottomLeft = PARAM_15;
    float bottomRight = PARAM_15;
    int32_t ret =
        g_dialogAPI3->nativeDialogAPI1.setCornerRadius(globalCustomDialog, topLeft, topRight, bottomLeft, bottomRight);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setCornerRadius failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogGridColumnCount(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置栅格和样式
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setGridColumnCount(globalCustomDialog, (int32_t)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setGridColumnCount failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogCustomStyle(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 弹窗容器样式是否可以自定义
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.enableCustomStyle(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "enableCustomStyle failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogCustomAnimation(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 弹窗容器样式是否可以自定义
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.enableCustomAnimation(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "enableCustomAnimation failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogKeyboardAvoidMode(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 弹窗避让键盘模式
    int32_t ret = g_dialogAPI3->setKeyboardAvoidMode(globalCustomDialog, (ArkUI_KeyboardAvoidMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setKeyboardAvoidMode failed, ret = %{public}d ", ret);
    }
    if (nodeValue == 0) {
        ret = g_dialogAPI3->nativeDialogAPI2.setKeyboardAvoidDistance(globalCustomDialog, PARAM_100,
            ARKUI_LENGTH_METRIC_UNIT_VP);
        if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
                "setKeyboardAvoidDistance failed, ret = %{public}d ", ret);
        }
    }
    return ret;
}
int32_t SetNativeDialogLevelMode(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置弹窗的显示层级
    int32_t ret = g_dialogAPI3->nativeDialogAPI2.setLevelMode(globalCustomDialog, (ArkUI_LevelMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setLevelMode failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogLevelUniqueId()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置弹窗显示层级页面下的节点id
    int32_t ret = g_dialogAPI3->nativeDialogAPI2.setLevelUniqueId(globalCustomDialog, 0);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setLevelUniqueId failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogImmersiveMode(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置嵌入式弹窗蒙层的显示区域
    int32_t ret = g_dialogAPI3->nativeDialogAPI2.setImmersiveMode(globalCustomDialog, (ArkUI_ImmersiveMode)nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setImmersiveMode failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetNativeDialogLevelOrder(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // 设置自定义弹窗显示的顺序
    int32_t ret = g_dialogAPI3->setLevelOrder(globalCustomDialog, nodeValue);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "setLevelOrder failed, ret = %{public}d ", ret);
    }
    return ret;
}

static bool CloseNativeDialogEventCallback(int32_t reason)
{
    if (reason == DIALOG_DISMISS_BACK_PRESS) {
        ArkUI_NativeDialogAPI_1 *dialogAPI = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_DIALOG, ArkUI_NativeDialogAPI_1, dialogAPI);
        if (globalCustomDialog) {
            dialogAPI->close(globalCustomDialog);
        }
        return true;
    } else if (reason == DIALOG_DISMISS_TOUCH_OUTSIDE) {
        ArkUI_NativeDialogAPI_1 *dialogAPI = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_DIALOG, ArkUI_NativeDialogAPI_1, dialogAPI);
        if (globalCustomDialog) {
            dialogAPI->close(globalCustomDialog);
        }
        return true;
    } else if (reason == DIALOG_DISMISS_CLOSE_BUTTON) {
        ArkUI_NativeDialogAPI_1 *dialogAPI = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_DIALOG, ArkUI_NativeDialogAPI_1, dialogAPI);
        if (globalCustomDialog) {
            dialogAPI->close(globalCustomDialog);
        }
        return true;
    } else if (reason == DIALOG_DISMISS_SLIDE_DOWN) {
        ArkUI_NativeDialogAPI_1 *dialogAPI = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_DIALOG, ArkUI_NativeDialogAPI_1, dialogAPI);
        if (globalCustomDialog) {
            dialogAPI->close(globalCustomDialog);
        }
        return true;
    }
    return true;
}

int32_t SetNativeDialogRegisterOnWillDismiss(uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    if (nodeValue) {
        // 当触发系统定义的返回操作、键盘ESC关闭交互操作时，如果注册了该回调函数，弹窗不会立即关闭，而是由用户决定是否关闭。
        ret = g_dialogAPI3->nativeDialogAPI1.registerOnWillDismiss(globalCustomDialog, &CloseNativeDialogEventCallback);
        if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
                "registerOnWillDismiss failed, ret = %{public}d ", ret);
        }
    }
    return ret;
}

int32_t SetNativeDialogRegisterOnWillDismissWithUserData()
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    g_isEventState = true;
    // 注册系统关闭自定义弹窗的监听事件
    ret = g_dialogAPI3->nativeDialogAPI1.registerOnWillDismissWithUserData(globalCustomDialog, globalCustomDialog,
        OnWillDismiss);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
            "registerOnWillDismissWithUserData failed, ret = %{public}d ", ret);
    }
    return ret;
}

int32_t SetDialogControllerAttribute3(int32_t nodeType, uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    ControllerAttributeType type = static_cast<ControllerAttributeType>(nodeType);
    switch (type) {
        case ControllerAttributeType::NATIVE_LEVEL_MODE: // 设置弹窗的显示层级
            ret = SetNativeDialogLevelMode(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_LEVEL_UNIQUE_ID: // 设置弹窗显示层级页面下的节点id
            ret = SetNativeDialogLevelUniqueId();
            break;
        case ControllerAttributeType::NATIVE_IMMERSIVE_MODE: // 设置嵌入式弹窗蒙层的显示区域
            ret = SetNativeDialogImmersiveMode(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_LEVEL_ORDER: // 设置自定义弹窗显示的顺序
            ret = SetNativeDialogLevelOrder(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_REGISTER_ON_WILL_DISMISS:
            ret = SetNativeDialogRegisterOnWillDismiss(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_REGISTER_ON_WILL_DISMISS_WITH_USER_DATA: // 注册系统关闭自定义弹窗的监听事件
            ret = SetNativeDialogRegisterOnWillDismissWithUserData();
            break;
        default:
            return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    return ret;
}

int32_t SetDialogControllerAttribute2(int32_t nodeType, uint32_t nodeValue)
{
    if (!g_dialogAPI3 || !globalCustomDialog) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    int32_t ret = 0;
    ControllerAttributeType type = static_cast<ControllerAttributeType>(nodeType);
    switch (type) {
        case ControllerAttributeType::NATIVE_CONTENT_ALIGNMENT: // 设置自定义弹窗对齐方式
            ret = SetNativeDialogContenAlignment();
            break;
        case ControllerAttributeType::
            NATIVE_RESET_CONTENT_ALIGNMENT: // 重置setContentAlignment方法设置的属性，使用系统默认的对齐方式。
            ret = SetNativeDialogResetContentAlignment();
            break;
        case ControllerAttributeType::NATIVE_MODAL_MODE: // 设置自定义弹窗是否开启模态样式的弹窗
            ret = SetNativeDialogModalMode(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_AUTO_CANCEL: // 设置自定义弹窗是否允许通过点击遮罩层退出
            ret = SetNativeDialogAutoCancel(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_MASK: // 设置自定义弹窗遮罩属性
            ret = SetNativeDialogMask();
            break;
        case ControllerAttributeType::NATIVE_CORNER_RADIUS : // 设置弹窗背板圆角半径
            ret = SetNativeDialogCornerRadius();
            break;
        case ControllerAttributeType::NATIVE_COLUMN_COUNT: // 设置弹窗宽度占栅格宽度的个数
            ret = SetNativeDialogGridColumnCount(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_CUSTOM_STYLE: // 弹窗容器样式是否可以自定义
            ret = SetNativeDialogCustomStyle(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_CUSTOM_ANIMATION: // 弹窗容器是否使用自定义弹窗动画
            ret = SetNativeDialogCustomAnimation(nodeValue);
            break;
        case ControllerAttributeType::NATIVE_KEYBOARD_AVOID_MODE: // 设置自定义弹窗避让键盘模式
            ret = SetNativeDialogKeyboardAvoidMode(nodeValue);
            break;
        default:
            ret = SetDialogControllerAttribute3(nodeType, nodeValue);
            break;
    }
    return ret;
}

static void HandleDialogCloseEvent()
{
    if (globalCustomDialog || g_dialogAPI3) {
        // 移除内容并关闭对话框
        int32_t ret = g_dialogAPI3->nativeDialogAPI1.removeContent(globalCustomDialog);
        if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
                "HandleDialogCloseEvent removeContent failed, ret = %{public}d ", ret);
        }

        ret = g_dialogAPI3->nativeDialogAPI1.close(globalCustomDialog);
        if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest",
                "HandleDialogCloseEvent close failed, ret = %{public}d ", ret);
        }
        g_dialogAPI3->nativeDialogAPI1.dispose(globalCustomDialog);
        globalCustomDialog = nullptr;
        g_dialogAPI3 = nullptr;
        g_isOpenController = false;
    }
}

static void NodeEventReceiver(ArkUI_NodeEvent* event)
{
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == ON_CLICK_EVENT_ID4) {
        HandleDialogCloseEvent();
        return;
    }
}

static ArkUI_NodeHandle CreateButtonNode(ArkUI_NativeNodeAPI_1* nodeAPI)
{
    auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);

    // 设置按钮标签
    ArkUI_AttributeItem closeText = {.string = "Close Dialog"};
    nodeAPI->setAttribute(button, NODE_BUTTON_LABEL, &closeText);

    // 设置按钮ID
    ArkUI_AttributeItem id_item = {};
    id_item.string = "button";
    nodeAPI->setAttribute(button, NODE_ID, &id_item);

    // 注册点击事件
    int32_t ret = nodeAPI->registerNodeEvent(button, NODE_ON_CLICK, ON_CLICK_EVENT_ID4, nullptr);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "CreateButtonNode registerNodeEvent failed, ret = %{public}d ", ret);
    }

    // 添加事件接收器
    ret = nodeAPI->addNodeEventReceiver(button, NodeEventReceiver);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "CustomDialogTest",
            "CreateButtonNode addNodeEventReceiver failed, ret = %{public}d ", ret);
    }

    return button;
}

bool CreateDialogController()
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    g_dialogAPI3 = reinterpret_cast<ArkUI_NativeDialogAPI_3 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_DIALOG, "ArkUI_NativeDialogAPI_3"));
    if (!g_dialogAPI3 || !nodeAPI) {
        return false;
    }
    // 创建对话框内容
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    if (!column) {
        return false;
    }
    auto button = CreateButtonNode(nodeAPI);
    if (!button) {
        return false;
    }
    nodeAPI->addChild(column, button);
    // 创建对话框
    auto customDialog = g_dialogAPI3->nativeDialogAPI1.create();
    if (!customDialog) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Error", "customDialog is null");
        return false;
    }
    int32_t ret = g_dialogAPI3->nativeDialogAPI1.setContent(customDialog, column);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest", "setContent failed, ret = %{public}d ",
            ret);
    }
    globalCustomDialog = customDialog;
    ArkUI_DialogState state = DIALOG_UNINITIALIZED;
    auto result = OH_ArkUI_CustomDialog_GetState(globalCustomDialog, &state);
    ShowDialogState(state);
    SetDialogStyles();
    g_isOpenController = true;
    return true;
}

int32_t CustomDialogTest::OnEventReceiveTestAPI(int32_t nodeType, uint32_t nodeValue)
{
    ArkUI_DialogState state = DIALOG_UNINITIALIZED;
    int32_t result = OH_ArkUI_CustomDialog_GetState(globalCustomDialog, &state);
    ShowDialogState(state);
    if (!g_isOpenController || !g_dialogAPI3) {
        bool ret = CreateDialogController();
        if (!ret) {
            return ARKUI_ERROR_CODE_PARAM_INVALID;
        }
    }
    result = SetDialogControllerAttribute(nodeType, nodeValue);
    if (result != -1) {
        return result;
    }
    result = SetDialogControllerAttribute2(nodeType, nodeValue);
    return result;
}

napi_value CustomDialogTest::OpenNativeDialog(napi_env env, napi_callback_info info)
{
    if (!g_isOpenController || !g_dialogAPI3) {
        bool ret = CreateDialogController();
        if (!ret) {
            return nullptr;
        }
    }

    if (globalCustomDialog && g_dialogAPI3) {
        int32_t ret = g_dialogAPI3->nativeDialogAPI1.show(globalCustomDialog, true);
        if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ControllerTest", "show failed, ret = %{public}d ",
                         ret);
        }
    }
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        return nullptr;
    }
    return exports;
}

napi_value CustomDialogTest::ResetDialogController(napi_env env, napi_callback_info info)
{
    if (globalCustomDialog || g_dialogAPI3) {
        g_dialogAPI3->nativeDialogAPI1.removeContent(globalCustomDialog);
        g_dialogAPI3->nativeDialogAPI1.close(globalCustomDialog);
        g_dialogAPI3->nativeDialogAPI1.dispose(globalCustomDialog);
        globalCustomDialog = nullptr;
        g_dialogAPI3 = nullptr;
        g_isOpenController = false;
        ArkUI_DialogState state = DIALOG_UNINITIALIZED;
        int32_t result =
            OH_ArkUI_CustomDialog_GetState(globalCustomDialog, &state);
        ShowDialogState(state);
    }
    napi_value exports;
    if (napi_create_object(env, &exports) != napi_ok) {
        return nullptr;
    }
    return exports;
}
} // namespace ArkUICapiTest
