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

// [Start ndk_implement_napi_init]
// napi_init.cpp
#include "napi/native_api.h"
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <string>
#include "window_manager/oh_window_pip.h"
#include "hilog/log.h"
#include "js_native_api.h"
#include "napi/native_api.h"
#include <cstdio>
#include "rawfile/raw_file_manager.h"

#define LOG_MSG_TAG "PiPMain"
#define LOG(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
napi_ref jsCallback;
napi_env env_;

napi_ref jsLifecycleCallback;
napi_env lifeEnv_;
int32_t g_minValue = 0;
int32_t g_maxValue = 255;

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, int32_t& value)
{
    return napi_get_value_int32(env, jsValue, &value) == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, uint32_t& value)
{
    return napi_get_value_uint32(env, jsValue, &value) == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, int64_t& value)
{
    return napi_get_value_int64(env, jsValue, &value) == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, uint64_t& value)
{
    int64_t num;
    auto res = napi_get_value_int64(env, jsValue, &num);
    if (res == napi_ok) {
        value = static_cast<uint64_t>(num);
    }
    return res == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, double& value)
{
    return napi_get_value_double(env, jsValue, &value) == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, bool& value)
{
    return napi_get_value_bool(env, jsValue, &value) == napi_ok;
}

inline bool ConvertFromJsNumber(napi_env env, napi_value jsValue, unsigned char& value)
{
    int32_t num;
    if (napi_get_value_int32(env, jsValue, &num) != napi_ok) {
        return false;
    }
    if (num < g_minValue || num > g_maxValue) {
        return false; // 越界无效
    }
    value = static_cast<unsigned char>(num);
    return true;
}

template<class T>
bool ConvertFromJsValue(napi_env env, napi_value jsValue, T& value)
{
    if (jsValue == nullptr) {
        return false;
    }
    using ValueType = std::remove_cv_t<std::remove_reference_t<T>>;
    if constexpr (std::is_same_v<ValueType, bool>) {
        return napi_get_value_bool(env, jsValue, &value) == napi_ok;
    } else if constexpr (std::is_arithmetic_v<ValueType>) {
        return ConvertFromJsNumber(env, jsValue, value);
    } else if constexpr (std::is_same_v<ValueType, std::string>) {
        size_t len = 0;
        if (napi_get_value_string_utf8(env, jsValue, nullptr, 0, &len) != napi_ok) {
            return false;
        }
        auto buffer = std::make_unique<char[]>(len + 1);
        size_t strLength = 0;
        if (napi_get_value_string_utf8(env, jsValue, buffer.get(), len + 1, &strLength) == napi_ok) {
            value = buffer.get();
            return true;
        }
        return false;
    } else if constexpr (std::is_enum_v<ValueType>) {
        std::make_signed_t<ValueType> numberValue = 0;
        if (!ConvertFromJsNumber(env, jsValue, numberValue)) {
            return false;
        }
        value = static_cast<ValueType>(numberValue);
        return true;
    }
    return false;
}

void PipStartPipCallback(uint32_t controllerId, uint8_t requestId, uint64_t surfaceId)
{
    if (jsCallback) {
        napi_value global = nullptr;
        napi_get_global(env_, &global);
        size_t argc = 1;
        std::string tStr = std::to_string(surfaceId);
        const char* cStr = tStr.c_str();
        size_t length = strlen(cStr);
        napi_value str;
        napi_status status = napi_create_string_utf8(env_, cStr, length, &str);
        napi_value argv[1] = {str};
        napi_value jsCallbackValue;
        
        napi_value result = nullptr;
        if (!jsCallback) {
            LOG("js callback is invalid");
        }
        napi_get_reference_value(env_, jsCallback, &jsCallbackValue);
        napi_call_function(env_, global, jsCallbackValue, argc, argv, &result);
    }
}

void LifecycleCallback(uint32_t controllerId, PictureInPicture_PipState state, int32_t errcode)
{
    if (jsLifecycleCallback) {
        napi_value global = nullptr;
        napi_get_global(lifeEnv_, &global);
        size_t argc = 1;
        napi_value pipState = nullptr;
        napi_create_int32(lifeEnv_, static_cast<int32_t> (state), &pipState);
        napi_value argv[1] = {pipState};
        napi_value jsCallbackValue;
        
        napi_value result = nullptr;
        if (!jsCallback) {
            LOG("js callback is invalid");
        }
        napi_get_reference_value(lifeEnv_, jsLifecycleCallback, &jsCallbackValue);
        napi_call_function(lifeEnv_, global, jsCallbackValue, argc, argv, &result);
    }
}

class PiPManager {
public:
    static napi_value CreatePip(napi_env env, napi_callback_info info);
    static napi_value StartPip(napi_env env, napi_callback_info info);
    static napi_value RegisterStartPip(napi_env env, napi_callback_info info);
    static napi_value DeletePip(napi_env env, napi_callback_info info);
    static napi_value StopPip(napi_env env, napi_callback_info info);
    static napi_value RegisterLifecycleListener(napi_env env, napi_callback_info info);
    static void getElement(napi_env &env, uint32_t size, napi_value &controlGroupValue,
                PictureInPicture_PipControlGroup controlGroup[]);
};

napi_value PiPManager::CreatePip(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    napi_value config = argv[0];

    napi_value mainWindowIdValue = nullptr;
    napi_value pipTemplateTypeValue = nullptr;
    napi_value widthValue = nullptr;
    napi_value heightValue = nullptr;
    napi_value controlGroupValue = nullptr;
    napi_value pipControllerIdValue = nullptr;
    
    uint32_t controllerId = -1;
    uint32_t mainWindowId = -1;
    PictureInPicture_PipTemplateType pipTemplateType = PictureInPicture_PipTemplateType::VIDEO_PLAY;
    uint32_t width = -1;
    uint32_t height = -1;
    
    napi_get_named_property(env, config, "mainWindowId", &mainWindowIdValue);
    napi_get_named_property(env, config, "pipTemplateType", &pipTemplateTypeValue);
    napi_get_named_property(env, config, "width", &widthValue);
    napi_get_named_property(env, config, "height", &heightValue);
    napi_get_named_property(env, config, "controlGroup", &controlGroupValue);
    napi_get_named_property(env, config, "pipControllerId", &pipControllerIdValue);
    
    ConvertFromJsValue(env, mainWindowIdValue, mainWindowId);
    ConvertFromJsValue(env, pipTemplateTypeValue, pipTemplateType);
    ConvertFromJsValue(env, widthValue, width);
    ConvertFromJsValue(env, heightValue, height);
    ConvertFromJsValue(env, pipControllerIdValue, controllerId);
    
    uint32_t size = 0;
    napi_get_array_length(env, controlGroupValue, &size);
    PictureInPicture_PipControlGroup controlGroup[size];

    PiPManager::getElement(env, size, controlGroupValue, controlGroup);
    
    napi_value result = nullptr;
    PictureInPicture_PipConfig pipConfig;
    OH_PictureInPicture_CreatePipConfig(&pipConfig);
    OH_PictureInPicture_SetPipMainWindowId(pipConfig, mainWindowId);
    OH_PictureInPicture_SetPipTemplateType(pipConfig, pipTemplateType);
    OH_PictureInPicture_SetPipRect(pipConfig, width, height);
    OH_PictureInPicture_SetPipControlGroup(pipConfig, controlGroup, size);
    OH_PictureInPicture_SetPipNapiEnv(pipConfig, env);
    int32_t res = OH_PictureInPicture_CreatePip(pipConfig, &controllerId);
    OH_PictureInPicture_DestroyPipConfig(&pipConfig);
    napi_create_uint32(env, controllerId, &result);
    return result;
}

void PiPManager::getElement(napi_env &env, uint32_t size, napi_value &controlGroupValue,
    PictureInPicture_PipControlGroup controlGroup[])
{
    for (uint32_t i = 0; i < size; i++) {
        napi_value getElementValue = nullptr;
        napi_get_element(env, controlGroupValue, i, &getElementValue);
        PictureInPicture_PipControlGroup controlType;
        if (ConvertFromJsValue(env, getElementValue, controlType)) {
            controlGroup[i] = controlType;
        }
        LOG("controlType: %{public}d", controlType);
    }
}

napi_value PiPManager::StartPip(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    napi_value controlIdValue = argv[0];
    uint32_t controlId = -1;
    ConvertFromJsValue(env, controlIdValue, controlId);
    napi_value resultValue = nullptr;
    int32_t result = OH_PictureInPicture_StartPip(controlId);
    napi_create_uint32(env, result, &resultValue);
    return resultValue;
}

napi_value PiPManager::RegisterStartPip(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    napi_value controllerIdValue = argv[0];
    uint32_t controlId = -1;
    napi_status status = napi_create_reference(env, argv[1], 1, &jsCallback);
    env_ = env;
    ConvertFromJsValue(env, controllerIdValue, controlId);
    napi_value resultValue = nullptr;
    int32_t result = OH_PictureInPicture_RegisterStartPipCallback(controlId, PipStartPipCallback);
    napi_create_uint32(env, result, &resultValue);
    return resultValue;
}

napi_value PiPManager::DeletePip(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    uint32_t controlId = -1;
    ConvertFromJsValue(env, argv[0], controlId);
    napi_value resultValue = nullptr;
    int32_t result = OH_PictureInPicture_DeletePip(controlId);
    napi_create_uint32(env, result, &resultValue);
    return resultValue;
}

napi_value PiPManager::StopPip(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    uint32_t controlId = -1;
    napi_value resultValue = nullptr;

    ConvertFromJsValue(env, argv[0], controlId);
    uint32_t result = OH_PictureInPicture_StopPip(controlId);
    napi_create_uint32(env, result, &resultValue);
    return resultValue;
}

napi_value PiPManager::RegisterLifecycleListener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    uint32_t controlId = -1;
    napi_status status = napi_create_reference(env, argv[1], 1, &jsLifecycleCallback);
    lifeEnv_ = env;
    if (status != napi_ok) {
        LOG("register failed %{public}d", status);
    }
    ConvertFromJsValue(env, argv[0], controlId);
    
    napi_value resultValue = nullptr;
    int32_t result = OH_PictureInPicture_RegisterLifecycleListener(controlId, LifecycleCallback);
    napi_create_uint32(env, result, &resultValue);
    return resultValue;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createPip", nullptr, PiPManager::CreatePip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startPip", nullptr, PiPManager::StartPip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerStartPip", nullptr, PiPManager::RegisterStartPip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deletePip", nullptr, PiPManager::DeletePip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopPip", nullptr, PiPManager::StopPip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerLifecycleListener", nullptr, PiPManager::RegisterLifecycleListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};
extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End ndk_implement_napi_init]