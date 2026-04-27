/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
#include "madvise/madvise_utils.h"
#include "madvise/vma_utils.h"

#include <cstring>
#include <string>
#include <vector>

static napi_value madviseFiles(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype;
    napi_typeof(env, args[0], &valuetype);

    bool success = false;

    if (valuetype == napi_string) {
        size_t strLen = 0;
        napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLen);

        if (strLen > 0) {
            char* libName = new char[strLen + 1];
            napi_get_value_string_utf8(env, args[0], libName, strLen + 1, &strLen);
            success = madviseUtil::MadviseSingleLibraryOptimized(libName);
            delete[] libName;
        }
    }

    napi_value result;
    napi_get_boolean(env, success, &result);
    return result;
}

/**
 * @brief 批量处理多个文件的 madvise
 */
static bool ProcessMultipleFiles(const std::string& fileStr)
{
    std::vector<std::string> filenames;
    size_t start = 0;
    size_t end = 0;

    while ((end = fileStr.find('/', start)) != std::string::npos) {
        if (end > start) {
            filenames.push_back(fileStr.substr(start, end - start));
        }
        start = end + 1;
    }
    if (start < fileStr.length()) {
        filenames.push_back(fileStr.substr(start));
    }

    if (filenames.empty()) {
        return false;
    }

    vmaUtil::SetTargetFiles(filenames);

    int resultCount = 0;
    for (const auto& file : filenames) {
        if (madviseUtil::MadviseGeneralFile(file.c_str())) {
            resultCount++;
        }
    }
    return (resultCount > 0);
}

/**
 * @brief 通用 madvise 接口（支持 .hap、.so 等所有文件）
 *
 * @param filename 文件名（string）
 * @return boolean 是否成功
 */
static napi_value madviseGeneralFiles(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype;
    napi_typeof(env, args[0], &valuetype);

    bool success = false;

    if (valuetype == napi_string) {
        size_t strLen = 0;
        napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLen);

        if (strLen > 0) {
            char* filename = new char[strLen + 1];
            napi_get_value_string_utf8(env, args[0], filename, strLen + 1, &strLen);

            std::string fileStr(filename);
            if (fileStr.find('/') != std::string::npos) {
                success = ProcessMultipleFiles(fileStr);
            } else {
                vmaUtil::SetTargetFiles({filename});
                success = madviseUtil::MadviseGeneralFile(filename);
            }
            delete[] filename;
        }
    }

    napi_value result;
    napi_get_boolean(env, success, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "madviseFiles", nullptr, madviseFiles, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "madviseGeneralFiles", nullptr, madviseGeneralFiles, nullptr, nullptr, nullptr, napi_default, nullptr }
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
