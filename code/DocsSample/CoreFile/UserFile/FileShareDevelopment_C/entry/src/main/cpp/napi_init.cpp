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
#include <filemanagement/fileshare/oh_file_share.h>
#include <iostream>

static napi_value NAPI_OH_FileShare_PersistPermission(napi_env env, napi_callback_info info)
{
    // [Start persist_permission_example]
    static const uint32_t policyNum = 2;
    char strTestPath1[] = "file://com.example.fileshare/data/storage/el2/base/files/test1.txt";
    char strTestPath2[] = "file://com.example.fileshare/data/storage/el2/base/files/test2.txt";
    FileShare_PolicyInfo policy[policyNum] = {
        {strTestPath1, static_cast<unsigned int>(strlen(strTestPath1)), FileShare_OperationMode::READ_MODE},
        {strTestPath2, static_cast<unsigned int>(strlen(strTestPath2)), FileShare_OperationMode::WRITE_MODE}};
    FileShare_PolicyErrorResult* result = nullptr;
    uint32_t resultNum = 0;
    napi_value napiResult;
    std::string resultStr;
    auto ret = OH_FileShare_PersistPermission(policy, policyNum, &result, &resultNum);
    if (ret != ERR_OK) {
        if (ret == ERR_EPERM && result != nullptr) {
            for (uint32_t i = 0; i < resultNum; i++) {
                std::cout << "error uri: " <<  result[i].uri << std::endl;
                std::cout << "error code: " <<  result[i].code << std::endl;
                std::cout << "error message: " << result[i].message << std::endl;
                // [StartExclude persist_permission_example]
                resultStr += "error uri: ";
                resultStr += result[i].uri;
                resultStr += "\n";
                resultStr += "error code: ";
                resultStr += result[i].code;
                resultStr += "\n";
                resultStr += "error message: ";
                resultStr += result[i].message;
                resultStr += "\n";
                // [EndExclude persist_permission_example]
            }
        }
    }
    OH_FileShare_ReleasePolicyErrorResult(result, resultNum);
    // [End persist_permission_example]
    napi_status status = napi_create_string_utf8(env, resultStr.c_str(), NAPI_AUTO_LENGTH, &napiResult);
    if (status != napi_ok) {
        return nullptr;
    }
    return napiResult;
}

static napi_value NAPI_OH_FileShare_ActivatePermission(napi_env env, napi_callback_info info)
{
    static const uint32_t policyNum = 2;
    char strTestPath1[] = "file://com.example.fileshare/data/storage/el2/base/files/test1.txt";
    char strTestPath2[] = "file://com.example.fileshare/data/storage/el2/base/files/test2.txt";
    FileShare_PolicyInfo policy[policyNum] = {
        {strTestPath1, static_cast<unsigned int>(strlen(strTestPath1)), FileShare_OperationMode::READ_MODE},
        {strTestPath2, static_cast<unsigned int>(strlen(strTestPath2)), FileShare_OperationMode::WRITE_MODE}};
    FileShare_PolicyErrorResult* result = nullptr;
    uint32_t resultNum = 0;
    napi_value napiResult;
    std::string resultStr;
    // [Start activate_permission_example]
    auto ret = OH_FileShare_ActivatePermission(policy, policyNum, &result, &resultNum);
    if (ret != ERR_OK) {
        if (ret == ERR_EPERM && result != nullptr) {
            for (uint32_t i = 0; i < resultNum; i++) {
                std::cout << "error uri: " <<  result[i].uri << std::endl;
                std::cout << "error code: " <<  result[i].code << std::endl;
                std::cout << "error message: " << result[i].message << std::endl;
                // [StartExclude activate_permission_example]
                resultStr += "error uri: ";
                resultStr += result[i].uri;
                resultStr += "\n";
                resultStr += "error code: ";
                resultStr += result[i].code;
                resultStr += "\n";
                resultStr += "error message: ";
                resultStr += result[i].message;
                resultStr += "\n";
                // [EndExclude activate_permission_example]
            }
        }
    }
    OH_FileShare_ReleasePolicyErrorResult(result, resultNum);
    // [End activate_permission_example]
    napi_status status = napi_create_string_utf8(env, resultStr.c_str(), NAPI_AUTO_LENGTH, &napiResult);
    if (status != napi_ok) {
        return nullptr;
    }
    return napiResult;
}

static napi_value NAPI_OH_FileShare_DeactivatePermission(napi_env env, napi_callback_info info)
{
    static const uint32_t policyNum = 2;
    char strTestPath1[] = "file://com.example.fileshare/data/storage/el2/base/files/test1.txt";
    char strTestPath2[] = "file://com.example.fileshare/data/storage/el2/base/files/test2.txt";
    FileShare_PolicyInfo policy[policyNum] = {
        {strTestPath1, static_cast<unsigned int>(strlen(strTestPath1)), FileShare_OperationMode::READ_MODE},
        {strTestPath2, static_cast<unsigned int>(strlen(strTestPath2)), FileShare_OperationMode::WRITE_MODE}};
    FileShare_PolicyErrorResult* result = nullptr;
    uint32_t resultNum = 0;
    napi_value napiResult;
    std::string resultStr;
    // [Start deactivate_permission_example]
    auto ret = OH_FileShare_DeactivatePermission(policy, policyNum, &result, &resultNum);
    if (ret != ERR_OK) {
        if (ret == ERR_EPERM && result != nullptr) {
            for (uint32_t i = 0; i < resultNum; i++) {
                std::cout << "error uri: " <<  result[i].uri << std::endl;
                std::cout << "error code: " <<  result[i].code << std::endl;
                std::cout << "error message: " << result[i].message << std::endl;
                // [StartExclude deactivate_permission_example]
                resultStr += "error uri: ";
                resultStr += result[i].uri;
                resultStr += "\n";
                resultStr += "error code: ";
                resultStr += result[i].code;
                resultStr += "\n";
                resultStr += "error message: ";
                resultStr += result[i].message;
                resultStr += "\n";
                // [EndExclude deactivate_permission_example]
            }
        }
    }
    OH_FileShare_ReleasePolicyErrorResult(result, resultNum);
    // [End deactivate_permission_example]
    napi_status status = napi_create_string_utf8(env, resultStr.c_str(), NAPI_AUTO_LENGTH, &napiResult);
    if (status != napi_ok) {
        return nullptr;
    }
    return napiResult;
}

static napi_value NAPI_OH_FileShare_RevokePermission(napi_env env, napi_callback_info info)
{
    static const uint32_t policyNum = 2;
    char strTestPath1[] = "file://com.example.fileshare/data/storage/el2/base/files/test1.txt";
    char strTestPath2[] = "file://com.example.fileshare/data/storage/el2/base/files/test2.txt";
    FileShare_PolicyInfo policy[policyNum] = {
        {strTestPath1, static_cast<unsigned int>(strlen(strTestPath1)), FileShare_OperationMode::READ_MODE},
        {strTestPath2, static_cast<unsigned int>(strlen(strTestPath2)), FileShare_OperationMode::WRITE_MODE}};
    FileShare_PolicyErrorResult* result = nullptr;
    uint32_t resultNum = 0;
    napi_value napiResult;
    std::string resultStr;
    // [Start revoke_permission_example]
    auto ret = OH_FileShare_RevokePermission(policy, policyNum, &result, &resultNum);
    if (ret != ERR_OK) {
        if (ret == ERR_EPERM && result != nullptr) {
            for (uint32_t i = 0; i < resultNum; i++) {
                std::cout << "error uri: " <<  result[i].uri << std::endl;
                std::cout << "error code: " <<  result[i].code << std::endl;
                std::cout << "error message: " << result[i].message << std::endl;
                // [StartExclude revoke_permission_example]
                resultStr += "error uri: ";
                resultStr += result[i].uri;
                resultStr += "\n";
                resultStr += "error code: ";
                resultStr += result[i].code;
                resultStr += "\n";
                resultStr += "error message: ";
                resultStr += result[i].message;
                resultStr += "\n";
                // [EndExclude revoke_permission_example]
            }
        }
    }
    OH_FileShare_ReleasePolicyErrorResult(result, resultNum);
    // [End revoke_permission_example]
    napi_status status = napi_create_string_utf8(env, resultStr.c_str(), NAPI_AUTO_LENGTH, &napiResult);
    if (status != napi_ok) {
        return nullptr;
    }
    return napiResult;
}

static napi_value NAPI_OH_FileShare_CheckPersistentPermission(napi_env env, napi_callback_info info)
{
    static const uint32_t policyNum = 2;
    char strTestPath1[] = "file://com.example.fileshare/data/storage/el2/base/files/test1.txt";
    char strTestPath2[] = "file://com.example.fileshare/data/storage/el2/base/files/test2.txt";
    FileShare_PolicyInfo policy[policyNum] = {
        {strTestPath1, static_cast<unsigned int>(strlen(strTestPath1)), FileShare_OperationMode::READ_MODE},
        {strTestPath2, static_cast<unsigned int>(strlen(strTestPath2)), FileShare_OperationMode::WRITE_MODE}};
    uint32_t resultNum = 0;
    napi_value napiResult;
    std::string resultStr;
    // [Start check_persistent_permission_example]
    bool *result = nullptr;
    auto ret = OH_FileShare_CheckPersistentPermission(policy, policyNum, &result, &resultNum);
    if (ret != ERR_OK) {
        if (ret == ERR_EPERM && result != nullptr) {
            for (uint32_t i = 0; i < resultNum && resultNum <= policyNum; i++) {
                std::cout << "uri: " <<  policy[i].uri << std::endl;
                std::cout << "result: " <<  result[i] << std::endl;
                // [StartExclude check_persistent_permission_example]
                resultStr += "uri: ";
                resultStr += policy[i].uri;
                resultStr += "\n";
                resultStr += "result: ";
                resultStr += result[i];
                resultStr += "\n";
                // [EndExclude check_persistent_permission_example]
            }
        }
    }
    std::cout << "retCode: " <<  ret << std::endl;
    free(result);
    // [End check_persistent_permission_example]
    napi_status status = napi_create_string_utf8(env, resultStr.c_str(), NAPI_AUTO_LENGTH, &napiResult);
    if (status != napi_ok) {
        return nullptr;
    }
    return napiResult;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "OH_FileShare_PersistPermission", nullptr, NAPI_OH_FileShare_PersistPermission, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "OH_FileShare_ActivatePermission", nullptr, NAPI_OH_FileShare_ActivatePermission, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "OH_FileShare_DeactivatePermission", nullptr, NAPI_OH_FileShare_DeactivatePermission, nullptr, nullptr,
            nullptr, napi_default, nullptr },
        { "OH_FileShare_RevokePermission", nullptr, NAPI_OH_FileShare_RevokePermission, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "OH_FileShare_CheckPersistentPermission", nullptr, NAPI_OH_FileShare_CheckPersistentPermission, nullptr,
            nullptr, nullptr, napi_default, nullptr }
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
