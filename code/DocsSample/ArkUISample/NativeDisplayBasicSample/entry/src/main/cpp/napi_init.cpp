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

#include "napi/native_api.h"
// [Start import_display_header]
#include <window_manager/oh_display_info.h>
#include <window_manager/oh_display_manager.h>
#include <hilog/log.h>
// [End import_display_header]

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

// [Start get_rotation]
static napi_value GetDefaultDisplayRotation(napi_env env, napi_callback_info info)
{
    NativeDisplayManager_Rotation displayRotation;
    NativeDisplayManager_ErrorCode errCode = OH_NativeDisplayManager_GetDefaultDisplayRotation(&displayRotation);
    if (errCode == NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        napi_value rotation;
        napi_create_int32(env, displayRotation, &rotation);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "rotation=%{public}d", displayRotation);
        return rotation;
    } else {
        napi_value errorCode;
        napi_create_int32(env, errCode, &errorCode);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
            "GetDefaultDisplayRotation errCode=%{public}d", errCode);
        return errorCode;
    }
}
// [End get_rotation]

// [Start get_cutout_info]
static napi_value CreateDefaultDisplayCutoutInfo(napi_env env, napi_callback_info info)
{
    NativeDisplayManager_CutoutInfo *cutOutInfo = NULL;
    NativeDisplayManager_ErrorCode errCode = OH_NativeDisplayManager_CreateDefaultDisplayCutoutInfo(&cutOutInfo);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "GetDefaultCutoutInfo errCode=%{public}d", errCode);
    if (errCode == NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        if (cutOutInfo != NULL && cutOutInfo->boundingRectsLength != 0) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                "GetDefaultCutoutInfo cutOutInfo length=%{public}d", cutOutInfo->boundingRectsLength);
            for (int i = 0; i < cutOutInfo->boundingRectsLength; i++) {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                    "cutOutInfo[%{public}d]=[%{public}d %{public}d %{public}d %{public}d]",
                    i, cutOutInfo->boundingRects[i].left, cutOutInfo->boundingRects[i].top,
                    cutOutInfo->boundingRects[i].width, cutOutInfo->boundingRects[i].height);
            }
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                "cutOutInfo waterfall left rect=[%{public}d %{public}d %{public}d %{public}d]",
                cutOutInfo->waterfallDisplayAreaRects.left.left, cutOutInfo->waterfallDisplayAreaRects.left.top,
                cutOutInfo->waterfallDisplayAreaRects.left.width, cutOutInfo->waterfallDisplayAreaRects.left.height);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                "cutOutInfo waterfall top rect=[%{public}d %{public}d %{public}d %{public}d]",
                cutOutInfo->waterfallDisplayAreaRects.top.left, cutOutInfo->waterfallDisplayAreaRects.top.top,
                cutOutInfo->waterfallDisplayAreaRects.top.width, cutOutInfo->waterfallDisplayAreaRects.top.height);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                "cutOutInfo waterfall right rect=[%{public}d %{public}d %{public}d %{public}d]",
                cutOutInfo->waterfallDisplayAreaRects.right.left, cutOutInfo->waterfallDisplayAreaRects.right.top,
                cutOutInfo->waterfallDisplayAreaRects.right.width, cutOutInfo->waterfallDisplayAreaRects.right.height);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
                "cutOutInfo waterfall bottom rect=[%{public}d %{public}d %{public}d %{public}d]",
                cutOutInfo->waterfallDisplayAreaRects.bottom.left,
                cutOutInfo->waterfallDisplayAreaRects.bottom.top,
                cutOutInfo->waterfallDisplayAreaRects.bottom.width,
                cutOutInfo->waterfallDisplayAreaRects.bottom.height);
        }
        napi_value boundingRectsLength;
        napi_create_int32(env, cutOutInfo->boundingRectsLength, &boundingRectsLength);
        OH_NativeDisplayManager_DestroyDefaultDisplayCutoutInfo(cutOutInfo);
        return boundingRectsLength;
    } else {
        napi_value errorCode;
        napi_create_int32(env, errCode, &errorCode);
        return errorCode;
    }
}
// [End get_cutout_info]

// [Start register_display_change]
void DisplayChangeCallback(uint64_t displayId)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
        "DisplayChangeCallback displayId=%{public}lu.", displayId);
}

static napi_value RegisterDisplayChangeListener(napi_env env, napi_callback_info info)
{
    uint32_t listenerIndex;
    NativeDisplayManager_ErrorCode errCode = OH_NativeDisplayManager_RegisterDisplayChangeListener(
        DisplayChangeCallback, &listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
        "RegisterDisplayChangeListener listenerIndex =%{public}d errCode=%{public}d.", listenerIndex, errCode);
    if (errCode == NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        napi_value registerIndex;
        napi_create_int32(env, listenerIndex, &registerIndex);
        return registerIndex;
    } else {
        napi_value errorCode;
        napi_create_int32(env, errCode, &errorCode);
        return errorCode;
    }
}

static napi_value UnregisterDisplayChangeListener(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    uint32_t listenerIndex;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_uint32(env, args[0], &listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
        "UnregisterDisplayChangeListener listenerIndex =%{public}d.", listenerIndex);
    NativeDisplayManager_ErrorCode errCode = OH_NativeDisplayManager_UnregisterDisplayChangeListener(listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest",
        "UnregisterDisplayChangeListener errCode=%{public}d.", errCode);
    napi_value errorCode;
    napi_create_int32(env, errCode, &errorCode);
    return errorCode;
}
// [End register_display_change]

// [Start get_foldable]
static napi_value IsFoldable(napi_env env, napi_callback_info info)
{
    bool isFoldDevice = OH_NativeDisplayManager_IsFoldable();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "IsFoldable isFoldDevice =%{public}d.", isFoldDevice);
    napi_value isFold;
    napi_get_boolean(env, isFoldDevice, &isFold);
    return isFold;
}
// [End get_foldable]

// [Start register_displayMode]
void FoldDisplayModeChangeCallback(NativeDisplayManager_FoldDisplayMode displayMode)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "displayMode=%{public}d.", displayMode);
}

static napi_value RegisterFoldDisplayModeChangeListener(napi_env env, napi_callback_info info)
{
    uint32_t listenerIndex = 0;
    NativeDisplayManager_ErrorCode errCode = OH_NativeDisplayManager_RegisterFoldDisplayModeChangeListener(
        FoldDisplayModeChangeCallback, &listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "listenerIndex =%{public}d errCode=%{public}d.",
        listenerIndex, errCode);
    if (errCode == NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        napi_value registerIndex;
        napi_create_int32(env, listenerIndex, &registerIndex);
        return registerIndex;
    } else {
        napi_value errorCode;
        napi_create_int32(env, errCode, &errorCode);
        return errorCode;
    }
}

static napi_value UnregisterFoldDisplayModeChangeListener(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    uint32_t listenerIndex;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_uint32(env, args[0], &listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "listenerIndex =%{public}d.", listenerIndex);
    NativeDisplayManager_ErrorCode errCode =
        OH_NativeDisplayManager_UnregisterFoldDisplayModeChangeListener(listenerIndex);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "DMSTest", "errorCode=%{public}d", errCode);
    napi_value errorCode;
    napi_create_int32(env, errCode, &errorCode);
    return errorCode;
}
// [End register_displayMode]

// [Start register_napi_display_function]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getDisplayRotation", nullptr, GetDefaultDisplayRotation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCutoutInfo", nullptr, CreateDefaultDisplayCutoutInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerDisplayChange", nullptr, RegisterDisplayChangeListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unregisterDisplayChange", nullptr, UnregisterDisplayChangeListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"checkIsFoldDevice", nullptr, IsFoldable, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerFoldDisplayModeChange", nullptr, RegisterFoldDisplayModeChangeListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unregisterFoldDisplayModeChange", nullptr, UnregisterFoldDisplayModeChangeListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End register_napi_display_function]

// [Start register_display_module]
static napi_module displayModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativedisplay",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&displayModule);
}
// [End register_display_module]