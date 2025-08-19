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

#include "hilog/log.h"
#include "napi/native_api.h"

#include <dlfcn.h>
#include <filesystem>
#include <iostream>

namespace fs = std::__fs::filesystem;

static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

static void DeleteDirectoryRecursivelyImpl(const std::string& path)
{
    try {
        // 检查路径是否存在
        if (!fs::exists(path)) {
            OH_LOG_ERROR(LOG_APP, "Directory does not exist: %{public}s", path.c_str());
            return;
        }
        // 递归删除目录及其内容
        fs::remove_all(path);
        OH_LOG_INFO(LOG_APP, "Successfully deleted directory: %{public}s", path.c_str());
    } catch (const fs::filesystem_error& e) {
        OH_LOG_ERROR(LOG_APP, "Filesystem error: %{public}s", e.what());
    } catch (const std::exception& e) {
        OH_LOG_ERROR(LOG_APP, "Error: %{public}s", e.what());
    }
}


static void DeleteWebCacheImpl()
{
    DeleteDirectoryRecursivelyImpl("/data/storage/el2/base/cache/web");
}

static napi_value DeleteWebCache(napi_env env, napi_callback_info info)
{
    DeleteWebCacheImpl();
    return nullptr;
}

static void SetWebVersionImpl(int version)
{
    void* handle = dlopen("libohweb.so", RTLD_LAZY);
    if (!handle) {
        OH_LOG_ERROR(LOG_APP, "Failed to load library: libohweb.so");
        return;
    }
    
    typedef void (*FuncPtr)(int a);
    FuncPtr func = (FuncPtr)dlsym(handle, "OH_NativeArkWeb_SetActiveWebEngineVersion");
    if (!func) {
        OH_LOG_ERROR(LOG_APP, "Failed to find symbol: OH_NativeArkWeb_SetActiveWebEngineVersion");
        dlclose(handle);
        return;
    }
    
    func(version); // 调用目标函数
    dlclose(handle);
}


static napi_value SetWebVersion(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t value0;
    napi_get_value_int32(env, args[0], &value0);
    
    SetWebVersionImpl(value0);

    /**
     * 若应用已适配SDK 20，可通过以下接口调用。需包含头文件 "web/native_interface_arkweb.h"
     * OH_NativeArkWeb_SetActiveWebEngineVersion(static_cast<ArkWebEngineVersion>(value0));
     */

    return nullptr;
}

static int GetWebVersionImpl()
{
    void* handle = dlopen("libohweb.so", RTLD_LAZY);
    if (!handle) {
        OH_LOG_INFO(LOG_APP, "Failed to open libohweb.so");
        return 0;
    }
    
    typedef int (*FuncPtr)(void);
    FuncPtr func = (FuncPtr)dlsym(handle, "OH_NativeArkWeb_GetActiveWebEngineVersion");
    if (!func) {
        OH_LOG_ERROR(LOG_APP, "Failed to find symbol: OH_NativeArkWeb_GetActiveWebEngineVersion");
        dlclose(handle);
        return 0;
    }
    
    int ret = func(); // 调用目标函数
    dlclose(handle);
    return ret;
}

static napi_value GetWebVersion(napi_env env, napi_callback_info info)
{
    int version = GetWebVersionImpl();

    /**
     * 若应用已适配SDK 20，可通过以下接口调用。需包含头文件 "web/native_interface_arkweb.h"
     * int version = static_cast<int>(OH_NativeArkWeb_GetActiveWebEngineVersion());
     */
    
    napi_value ret;
    napi_create_int32(env, version, &ret);
    return ret;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "deleteWebCache", nullptr, DeleteWebCache, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setWebVersion", nullptr, SetWebVersion, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getWebVersion", nullptr, GetWebVersion, nullptr, nullptr, nullptr, napi_default, nullptr }
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
