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
#include <cstring>
#include <filemanagement/file_uri/oh_file_uri.h>
#include <hilog/log.h>

#undef LOG_TAG
#define LOG_TAG "Sample_fileUri"

static napi_value NAPI_Global_OH_FileUri_GetUriFromPathExample(napi_env env, napi_callback_info info)
{
    // 参数个数为1
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取字符串的长度，初始化字符串长度为0
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // 为 char* uri 分配内存
    char *path = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    napi_get_value_string_utf8(env, args[0], path, strLength + 1, &strLength);

    unsigned int length = strlen(path);
    // 输出传入路径字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", path);
    char *uriResult = nullptr;
    FileManagement_ErrCode ret = OH_FileUri_GetUriFromPath(path, length, &uriResult);
    // 输出结果uri字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uriResult);
    napi_value result;
    if (ret == 0 && uriResult != nullptr) {
        // 将C字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, uriResult, NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            free(uriResult);
            return nullptr;
        }
        free(uriResult); // 释放临时字符串
    } else {
        // 将C字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, "Hello World", NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            return nullptr;
        }
    }
    return result;
}
static napi_value NAPI_Global_OH_FileUri_GetPathFromUriExample(napi_env env, napi_callback_info info)
{
    // 参数个数为1
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取字符串的长度，初始化字符串长度为0
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // 为 char* uri 分配内存
    char *uri = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    napi_get_value_string_utf8(env, args[0], uri, strLength + 1, &strLength);

    unsigned int length = strlen(uri);
    // 输出传入uri符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uri);
    char *pathResult = nullptr;
    FileManagement_ErrCode ret = OH_FileUri_GetPathFromUri(uri, length, &pathResult);
    // 输出获取路径结果符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", pathResult);
    napi_value result;
    if (ret == 0 && pathResult != nullptr) {
        // 将C字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, pathResult, NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            free(pathResult);
            return nullptr;
        }
        free(pathResult); // 释放临时字符串
    } else {
        // 将空字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, "", NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            return nullptr;
        }
    }
    return result;
}
static napi_value NAPI_Global_OH_FileUri_GetFullDirectoryUriExample(napi_env env, napi_callback_info info)
{
    // 参数个数为1
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取字符串的长度，初始化字符串长度为0
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // 为 char* uri 分配内存
    char *uri = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    napi_get_value_string_utf8(env, args[0], uri, strLength + 1, &strLength);

    unsigned int length = strlen(uri);
    // 输出传入uri字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uri);
    char *uriResult = nullptr;
    FileManagement_ErrCode ret = OH_FileUri_GetFullDirectoryUri(uri, length, &uriResult);
    // 输出所在路径uri字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uriResult);
    napi_value result = nullptr;
    if (ret == 0 && uriResult != nullptr) {
        // 使用napi接口创建一个字符串类型的napi_value来返回正确结果
        napi_create_string_utf8(env, uriResult, NAPI_AUTO_LENGTH, &result);
    } else {
        // 使用napi接口创建一个表示null值的napi_value来返回错误或空值情况
        napi_get_null(env, &result);
    }
    if (uriResult != nullptr) {
        free(uriResult);
    }
    return result;
}
static napi_value NAPI_Global_OH_FileUri_IsValidUriExample(napi_env env, napi_callback_info info)
{
    // 参数个数为1
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取字符串的长度，初始化字符串长度为0
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // 为 char* uri 分配内存
    char *uri = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    napi_get_value_string_utf8(env, args[0], uri, strLength + 1, &strLength);

    unsigned int length = strlen(uri);
    // 输出传入uri字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uri);
    bool flags = OH_FileUri_IsValidUri(uri, length);
    napi_value result;
    // 将bool值转换为napi_value
    napi_status status = napi_get_boolean(env, flags, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to convert boolean to napi_value");
        return nullptr;
    }
    return result;
}
static napi_value NAPI_Global_OH_FileUri_GetFileNameExample(napi_env env, napi_callback_info info)
{
    // 参数个数为1
    size_t argc = 1;
    napi_value args[1] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取字符串的长度，初始化字符串长度为0
    size_t strLength = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLength);
    // 为 char* uri 分配内存
    char *uri = new char[strLength + 1]; // +1 for null terminator
    // 将 JavaScript 字符串复制到 uri
    napi_get_value_string_utf8(env, args[0], uri, strLength + 1, &strLength);

    unsigned int length = strlen(uri);
    // 输出传入uri字符串
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uri);
    char *uriResult = nullptr;
    FileManagement_ErrCode ret = OH_FileUri_GetFileName(uri, length, &uriResult);
    // 输出获取到的文件名称
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger: %{public}s", uriResult);
    napi_value result;
    if (ret == 0 && uriResult != nullptr) {
        // 将C字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, uriResult, NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            free(uriResult);
            return NULL;
        }
        free(uriResult); // 释放临时字符串
    } else {
        // 将空字符串转换为napi_value
        napi_status status = napi_create_string_utf8(env, "", NAPI_AUTO_LENGTH, &result);
        if (status != napi_ok) {
            return nullptr;
        }
    }
    return result;
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"OH_FileUri_GetUriFromPathExample", nullptr, NAPI_Global_OH_FileUri_GetUriFromPathExample, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"OH_FileUri_GetPathFromUriExample", nullptr, NAPI_Global_OH_FileUri_GetPathFromUriExample, nullptr, nullptr,
         nullptr, napi_default, nullptr},
        {"OH_FileUri_GetFullDirectoryUriExample", nullptr, NAPI_Global_OH_FileUri_GetFullDirectoryUriExample, nullptr,
         nullptr, nullptr, napi_default, nullptr},
        {"OH_FileUri_IsValidUriExample", nullptr, NAPI_Global_OH_FileUri_IsValidUriExample, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"OH_FileUri_GetFileNameExample", nullptr, NAPI_Global_OH_FileUri_GetFileNameExample, nullptr, nullptr, nullptr,
         napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1, // 模块版本号，设置为1遵循当前的 N-API 版本规范
    .nm_flags = 0, // 模块标志，设置为0，表示没有特殊标志
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0}, // 保留字段，通常初始化为0
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
