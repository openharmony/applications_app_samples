/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

#include "napi/native_api.h"
#include <cstdio>
#include <sstream>
#include <dlfcn.h>

// C API return codes.
static constexpr int32_t RESULT_SUCCESS = 0;
static constexpr int32_t RESULT_ERROR_INVALID_PARAM = 6800101;
static constexpr int32_t RESULT_ERROR_ILLEGAL_STATE = 6800103;
static constexpr int32_t RESULT_ERROR_SYSTEM = 6800301;

// Function pointer types for OHAudio Debug Manager C API.
typedef int32_t (*GetDebugManagerFunc)(void **);
typedef int32_t (*PrintAppInfoFunc)(void *, int32_t);
typedef int32_t (*PrintLoopbackInfoFunc)(void *, void *, int32_t);

static void *g_handle = nullptr;
static GetDebugManagerFunc g_getDebugManager = nullptr;
static PrintAppInfoFunc g_printAppInfo = nullptr;
static PrintLoopbackInfoFunc g_printLoopbackInfo = nullptr;

static bool LoadFunctions()
{
    if (g_handle != nullptr) {
        return true;
    }
    g_handle = dlopen("libohaudio.so", RTLD_NOW);
    if (g_handle == nullptr) {
        return false;
    }

    g_getDebugManager = (GetDebugManagerFunc)dlsym(g_handle, "OH_AudioManager_GetAudioDebugManager");
    g_printAppInfo = (PrintAppInfoFunc)dlsym(g_handle, "OH_AudioDebugManager_PrintAppInfo");
    g_printLoopbackInfo = (PrintLoopbackInfoFunc)dlsym(g_handle, "OH_AudioDebugManager_PrintLoopbackInfo");
    return g_getDebugManager && g_printAppInfo && g_printLoopbackInfo;
}

// Verify OH_AudioDebugManager_PrintLoopbackInfo C API.
// Receives JS AudioLoopback object and fd, unwraps to get native pointer, calls C API.
napi_value VerifyLoopbackCApi(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    std::stringstream ss;
    if (!LoadFunctions()) {
        ss << "Failed to load libohaudio.so";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    int32_t fd = -1;
    napi_get_value_int32(env, args[1], &fd);

    // Unwrap JS AudioLoopback object to get native pointer.
    // NapiAudioLoopback::loopback_ (shared_ptr<AudioLoopback>) is the first data member.
    // shared_ptr stores raw pointer as its first field.
    void *nativePtr = nullptr;
    napi_status status = napi_unwrap(env, args[0], &nativePtr);
    if (status != napi_ok || nativePtr == nullptr) {
        ss << "Failed to unwrap AudioLoopback object";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    void *rawLoopback = *reinterpret_cast<void **>(nativePtr);

    void *debugManager = nullptr;
    int32_t ret = g_getDebugManager(&debugManager);
    if (ret != RESULT_SUCCESS) {
        ss << "GetAudioDebugManager failed: " << ret;
    } else {
        ret = g_printLoopbackInfo(debugManager, rawLoopback, fd);
        if (ret == RESULT_SUCCESS) {
            ss << "PrintLoopbackInfo succeeded";
        } else {
            ss << "PrintLoopbackInfo failed: " << ret;
        }
    }

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// Test OH_AudioDebugManager_PrintAppInfo C API.
// Does not require AudioLoopback instance.
napi_value TestPrintAppInfo(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    std::stringstream ss;
    if (!LoadFunctions()) {
        ss << "Failed to load libohaudio.so";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    int32_t fd = -1;
    napi_get_value_int32(env, args[0], &fd);

    void *debugManager = nullptr;
    int32_t ret = g_getDebugManager(&debugManager);
    if (ret != RESULT_SUCCESS) {
        ss << "GetAudioDebugManager failed: " << ret;
    } else {
        ret = g_printAppInfo(debugManager, fd);
        if (ret == RESULT_SUCCESS) {
            ss << "PrintAppInfo succeeded (fd=" << fd << ")";
        } else {
            ss << "PrintAppInfo failed: " << ret;
        }
    }

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"VerifyLoopbackCApi", nullptr, VerifyLoopbackCApi, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"TestPrintAppInfo", nullptr, TestPrintAppInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
