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
#include "NodeManager.h"
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>
#include <string>
#include <hilog/log.h>

constexpr int32_t NUM_2 = 2;
constexpr int32_t NUM_3 = 3;
constexpr int32_t NUM_4 = 4;
constexpr int32_t NUM_5 = 5;

static napi_value CreateProgress(napi_env env, napi_callback_info info)
{
    NodeManager::GetInstance().CreateProgress();
    return nullptr;
}

static napi_value CreateTextPickerWithCustomContent(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t type;
    napi_get_value_int32(env, argv[0], &type);
    NodeManager::GetInstance().CreateTextPickerWithCustomContent(type);
    return nullptr;
}

static napi_value SetProgressLinearStyleOption(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_4;
    napi_value argv[NUM_4];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    bool scanEffect;
    napi_get_value_bool(env, argv[0], &scanEffect);
    bool smoothEffect;
    napi_get_value_bool(env, argv[1], &smoothEffect);
    int32_t strokeWidth;
    napi_get_value_int32(env, argv[NUM_2], &strokeWidth);
    int32_t strokeRadius;
    napi_get_value_int32(env, argv[NUM_3], &strokeRadius);
    NodeManager::GetInstance().SetProgressLinearStyleOption(scanEffect, smoothEffect, strokeWidth, strokeRadius);
    return nullptr;
}

static napi_value CreateImageAnimatorFromString(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_5;
    napi_value argv[NUM_5];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t width;
    napi_get_value_int32(env, argv[0], &width);
    int32_t height;
    napi_get_value_int32(env, argv[1], &height);
    int32_t top;
    napi_get_value_int32(env, argv[NUM_2], &top);
    int32_t left;
    napi_get_value_int32(env, argv[NUM_3], &left);
    int32_t duration;
    napi_get_value_int32(env, argv[NUM_4], &duration);
    NodeManager::GetInstance().CreateImageAnimatorFromString(width, height, top, left, duration);
    return nullptr;
}

static napi_value CreateImageAnimatorFromDrawableDescriptor(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_5;
    napi_value argv[NUM_5];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t width;
    napi_get_value_int32(env, argv[0], &width);
    int32_t height;
    napi_get_value_int32(env, argv[1], &height);
    int32_t top;
    napi_get_value_int32(env, argv[NUM_2], &top);
    int32_t left;
    napi_get_value_int32(env, argv[NUM_3], &left);
    int32_t duration;
    napi_get_value_int32(env, argv[NUM_4], &duration);
    NodeManager::GetInstance().CreateImageAnimatorFromDrawableDescriptor(width, height, top, left, duration);
    return nullptr;
}

static napi_value GetProgressLinearStyleOptionAndDestroy(napi_env env, napi_callback_info info)
{
    napi_value result;
    auto styleOption = NodeManager::GetInstance().GetProgressLinearStyleOptionAndDestroy();
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "CustomDialogTest", "napiResult = %{public}s", styleOption.c_str());
    napi_create_string_utf8(env, styleOption.c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

static napi_value GetImageAnimatorFrameInfo(napi_env env, napi_callback_info info)
{
    napi_value result;
    auto styleOption = NodeManager::GetInstance().GetImageAnimatorFrameInfo();
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "CustomDialogTest", "napiResult = %{public}s", styleOption.c_str());
    napi_create_string_utf8(env, styleOption.c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

static napi_value SetProgressType(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t type;
    napi_get_value_int32(env, argv[0], &type);
    NodeManager::GetInstance().SetProgressType(type);
    return nullptr;
}

static napi_value SetProgressValue(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t value;
    napi_get_value_int32(env, argv[0], &value);
    NodeManager::GetInstance().SetProgressValue(value);
    return nullptr;
}

static napi_value CreateDatePicker(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t type;
    napi_get_value_int32(env, argv[0], &type);
    NodeManager::GetInstance().CreateDatePicker(type);
    return nullptr;
}

static napi_value CreateCalendarPicker(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t type;
    napi_get_value_int32(env, argv[0], &type);
    NodeManager::GetInstance().CreateCalendarPicker(type);
    return nullptr;
}

static napi_value CreateImageSize(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_2;
    napi_value argv[NUM_2];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t fit;
    napi_get_value_int32(env, argv[0], &fit);
    int32_t size;
    napi_get_value_int32(env, argv[1], &size);
    NodeManager::GetInstance().CreateImageSize(fit, size);
    return nullptr;
}

static napi_value SetImageProperties(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_3;
    napi_value argv[NUM_3];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    int32_t repeat;
    napi_get_value_int32(env, argv[0], &repeat);
    int32_t interpolation;
    napi_get_value_int32(env, argv[1], &interpolation);
    int32_t mode;
    napi_get_value_int32(env, argv[NUM_2], &mode);
    NodeManager::GetInstance().SetImageProperties(repeat, interpolation, mode);
    return nullptr;
}

static napi_value SetContentHandle(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "nativeTypeSample", "CreateNativeNode napi_get_cb_info failed");
        return nullptr;
    }
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NodeManager::GetInstance().SetContentHandle(contentHandle);
    return nullptr;
}

static napi_value SetUpTextCrossLanguage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    bool isCross;
    napi_get_value_bool(env, argv[0], &isCross);
    NodeManager::GetInstance().SetUpTextCrossLanguage(isCross);
    return nullptr;
}

static napi_value ClearNodes(napi_env env, napi_callback_info info)
{
    NodeManager::GetInstance().ClearNodes();
    return nullptr;
}
EXTERN_C_START
napi_property_descriptor desc[] = {
    {"createNativeSwiperNode", nullptr, Manager::CreateNativeSwiperNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createNativeTextNode", nullptr, Manager::CreateNativeTextNode, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createNativeAccessibilityNode", nullptr, Manager::CreateNativeAccessibilityNode, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"createNativeEmbeddedComponentNode", nullptr, Manager::CreateNativeEmbeddedComponentNode, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"createAnimationCenter", nullptr, createAnimationCenter, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createAnimationOpacity", nullptr, createAnimationOpacity, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createAnimationTranslate", nullptr, createAnimationTranslate, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createAnimationFit", nullptr, createAnimationFit, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createAnimationGeometry", nullptr, createAnimationGeometry, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createVisualEffectsScale", nullptr, createVisualEffectsScale, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createVisualEffectsBlur", nullptr, createVisualEffectsBlur, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createVisualEffectsShape", nullptr, createVisualEffectsShape, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"destroyNativeRoot", nullptr, DestroyNativeRoot, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createNativeNodexc", nullptr, Manager::createNativeXComponentNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createWaterFlowNativeNode", nullptr, Manager::CreateWaterFlowNativeNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createGridNativeNode", nullptr, Manager::CreateGridNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createGridNativeNodeOnGetRectByIndex", nullptr, Manager::CreateGridNativeNodeOnGetRectByIndex, nullptr,
        nullptr, nullptr, napi_default, nullptr },
    {"createGridNativeNodeIrregularIndexes", nullptr, Manager::CreateGridNativeNodeIrregularIndexes, nullptr,
        nullptr, nullptr, napi_default, nullptr },
    {"createScrollNativeNode", nullptr, Manager::CreateScrollNativeNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createRefreshNativeNode", nullptr, Manager::CreateRefreshNativeNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createListNativeNode", nullptr, Manager::CreateListNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createNativeButtonNode", nullptr, Manager::CreateNativeButtonNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createNativeSliderNode", nullptr, Manager::CreateNativeSliderNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createNativeCheckboxShapePage", nullptr, Manager::CreateNativeCheckboxShapePage, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"createHoverModeAreaTypePage", nullptr, Manager::CreateHoverModeAreaTypePage, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"createPublicNativeNode", nullptr, Manager::createPublicNativeNode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"createProgress", nullptr, CreateProgress, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createTextPickerWithCustomContent", nullptr, CreateTextPickerWithCustomContent, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"setProgressType", nullptr, SetProgressType, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"setProgressValue", nullptr, SetProgressValue, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"setImageProperties", nullptr, SetImageProperties, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createDatePicker", nullptr, CreateDatePicker, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createCalendarPicker", nullptr, CreateCalendarPicker, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createImageSize", nullptr, CreateImageSize, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"setProgressLinearStyleOption", nullptr, SetProgressLinearStyleOption, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"getProgressLinearStyleOptionAndDestroy", nullptr, GetProgressLinearStyleOptionAndDestroy,
     nullptr, nullptr, nullptr, napi_default, nullptr},
    {"getImageAnimatorFrameInfo", nullptr, GetImageAnimatorFrameInfo, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"setContentHandle", nullptr, SetContentHandle, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"setUpTextCrossLanguage", nullptr, SetUpTextCrossLanguage, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"clearNodes", nullptr, ClearNodes, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createImageAnimatorFromDrawableDescriptor", nullptr, CreateImageAnimatorFromDrawableDescriptor,
     nullptr, nullptr, nullptr, napi_default, nullptr},
    {"createImageAnimatorFromString", nullptr, CreateImageAnimatorFromString, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"createContainerNativeNode", nullptr, Manager::createContainerNativeNode, nullptr,
        nullptr, nullptr, napi_default, nullptr },
};
static napi_value Init(napi_env env, napi_value exports) {
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "Init begins");
    if ((env == nullptr) || (exports == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "env or exports is null");
        return nullptr;
    }

    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "napi_define_properties failed");
        return nullptr;
    }
    return exports;
}
EXTERN_C_END
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }