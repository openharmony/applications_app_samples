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

#include "napi/native_api.h"
#include <filemanagement/fileio/oh_fileio.h>
#include "hilog/log.h"
#include <cstring>

#undef LOG_TAG
#define LOG_TAG "Sample_NDKAppFileAccess"

// [Start get_file_location]
static napi_value GetFileLocation(napi_env env, napi_callback_info info) {
    // [StartExclude get_file_location]
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 确保传入了一个参数
    if (argc < 1) {
        napi_throw_error(env, nullptr, "Expected one argument");
        return nullptr;
    }
    // 确保传入的是字符串
    napi_valuetype valuetype;
    napi_typeof(env, args[0], &valuetype);
    if (valuetype != napi_string) {
        napi_throw_error(env, nullptr, "Argument should be a string");
        return nullptr;
    }
    // 获取字符串的长度
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // [EndExclude get_file_location]
    // 为 char* uri 分配内存
    char *uri = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    // [StartExclude get_file_location]
    napi_get_value_string_utf8(env, args[0], uri, strLength + 1, &strLength);
    // 输出 uri 字符串（用于调试）
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uri);
    // [EndExclude get_file_location]
    FileIO_FileLocation location;
    FileManagement_ErrCode ret = OH_FileIO_GetFileLocation(uri, strlen(uri), &location);
    if (ret == 0) {
        if (location == FileIO_FileLocation::LOCAL) {
            OH_LOG_INFO(LogType::LOG_APP, "This file is on local.");
        } else if (location == FileIO_FileLocation::CLOUD) {
            OH_LOG_INFO(LogType::LOG_APP, "This file is on cloud.");
        } else if (location == FileIO_FileLocation::LOCAL_AND_CLOUD) {
            OH_LOG_INFO(LogType::LOG_APP, "This file is both on local and cloud.");
        }
    } else {
        OH_LOG_INFO(LogType::LOG_APP, "GetFileLocation failed, error code is %{public}d", ret);
    }
    // [StartExclude get_file_location]
    // 如果需要返回值，可以创建一个 JavaScript 字符串返回
    napi_value result;
    napi_create_string_utf8(env, uri, strLength, &result);
    return result;
    // [EndExclude get_file_location]
}
// [End get_file_location]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"getFileLocation", nullptr, GetFileLocation, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
