/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include <cstdint>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <string>
#include <vector>
#include "napi/native_api.h"
#include "rawfile/raw_file_manager.h"
#include "rawfile/raw_file.h"
#include "rawfile/raw_dir.h"
#include "hilog/log.h"

const int GLOBAL_RESMGR = 0xFF00;
const char *TAG = "[Sample_rawfile]";
static napi_value GetFileList(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetFileList Begin");
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    RawDir *rawDir = OH_ResourceManager_OpenRawDir(mNativeResMgr, filename.c_str());
    int count = OH_ResourceManager_GetRawFileCount(rawDir);
    std::vector<std::string> tempArray;
    for (int i = 0; i < count; i++) {
        std::string filename = OH_ResourceManager_GetRawFileName(rawDir, i);
        tempArray.emplace_back(filename);
    }

    napi_value fileList;
    napi_create_array(env, &fileList);
    for (size_t i = 0; i < tempArray.size(); i++) {
        napi_value jsString;
        napi_create_string_utf8(env, tempArray[i].c_str(), NAPI_AUTO_LENGTH, &jsString);
        napi_set_element(env, fileList, i, jsString);
    }
    OH_ResourceManager_CloseRawDir(rawDir);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return fileList;
}

namespace {
    napi_value CreateJsArrayValue(napi_env env, std::unique_ptr<uint8_t[]> &data, long length)
    {
        napi_value buffer;
        napi_status status = napi_create_external_arraybuffer(
            env, data.get(), length,
            [](napi_env env, void *data, void *hint) {
                delete[] static_cast<char *>(data);
            },
            nullptr, &buffer);
        if (status != napi_ok) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create external array buffer");
            return nullptr;
        }
        napi_value result = nullptr;
        status = napi_create_typedarray(env, napi_uint8_array, length, buffer, 0, &result);
        if (status != napi_ok) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create media typed array");
            return nullptr;
        }
        data.release();
        return result;
    }
}


static napi_value GetRawFileContent(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetFileContent Begin");
    size_t argc = 4;
    napi_value argv[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    int64_t offset = 0;
    int64_t length = 0;
    napi_get_value_int64(env, argv[2], &offset);
    napi_get_value_int64(env, argv[3], &length);
    
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile success");
    }
    long fileSize = OH_ResourceManager_GetRawFileSize(rawFile);
    long readLen = fileSize;
    if (offset + length <= fileSize) {
        OH_ResourceManager_SeekRawFile(rawFile, offset, 0);
        if (length != 0) {
            readLen = length;
        }
        long currentOffset = OH_ResourceManager_GetRawFileOffset(rawFile);
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetFileContent, current rawfile offset = %{public}ld",
            currentOffset);
    }
    std::unique_ptr<uint8_t[]> data = std::make_unique<uint8_t[]>(readLen);
    int res = OH_ResourceManager_ReadRawFile(rawFile, data.get(), readLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetFileContent, read size = %{public}d", res);
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return CreateJsArrayValue(env, data, fileSize);
}

static napi_value GetRawFileContent64(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetRawFileContent64 Begin");
    size_t argc = 4;
    napi_value argv[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    int64_t offset = 0;
    int64_t length = 0;
    napi_get_value_int64(env, argv[2], &offset);
    napi_get_value_int64(env, argv[3], &length);
    
    RawFile64 *rawFile = OH_ResourceManager_OpenRawFile64(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile64 success");
    }
    long fileSize = OH_ResourceManager_GetRawFileSize64(rawFile);
    long readLen = fileSize;
    if (offset + length <= fileSize) {
        OH_ResourceManager_SeekRawFile64(rawFile, offset, 0);
        if (length != 0) {
            readLen = length;
        }
        long currentOffset = OH_ResourceManager_GetRawFileOffset64(rawFile);
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetRawFileContent64, current rawfile offset = %{public}ld",
            currentOffset);
    }
    std::unique_ptr<uint8_t[]> data = std::make_unique<uint8_t[]>(readLen);
    int res = OH_ResourceManager_ReadRawFile64(rawFile, data.get(), readLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetRawFileContent64, read size = %{public}d", res);
    OH_ResourceManager_CloseRawFile64(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return CreateJsArrayValue(env, data, fileSize);
}

namespace {
    napi_value createJsFileDescriptor(napi_env env, int navtieFd, int64_t nativeOffset, int64_t nativeLength)
    {
        napi_value result;
        napi_status status = napi_create_object(env, &result);
        if (status != napi_ok) {
            return result;
        }

        napi_value fd;
        status = napi_create_int32(env, navtieFd, &fd);
        if (status != napi_ok) {
            return result;
        }
        status = napi_set_named_property(env, result, "fd", fd);
        if (status != napi_ok) {
            return result;
        }

        napi_value offset;
        status = napi_create_int64(env, nativeOffset, &offset);
        if (status != napi_ok) {
            return result;
        }
        status = napi_set_named_property(env, result, "offset", offset);
        if (status != napi_ok) {
            return result;
        }

        napi_value length;
        status = napi_create_int64(env, nativeLength, &length);
        if (status != napi_ok) {
            return result;
        }
        status = napi_set_named_property(env, result, "length", length);
        if (status != napi_ok) {
            return result;
        }
        return result;
    }
}

static napi_value GetRawFileDescriptor(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetRawFileDescriptor Begin");
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile success");
    }
    RawFileDescriptor descriptor;
    OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);

    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return createJsFileDescriptor(env, descriptor.fd, descriptor.start, descriptor.length);
}

static napi_value GetRawFileDescriptor64(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "GetRawFileDescriptor64 Begin");
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    RawFile64 *rawFile = OH_ResourceManager_OpenRawFile64(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile64 success");
    }
    RawFileDescriptor64 descriptor;
    OH_ResourceManager_GetRawFileDescriptor64(rawFile, &descriptor);

    OH_ResourceManager_CloseRawFile64(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return createJsFileDescriptor(env, descriptor.fd, descriptor.start, descriptor.length);
}

namespace {
    napi_valuetype GetValueType(napi_env env, napi_value value)
    {
        napi_valuetype valueType = napi_valuetype::napi_undefined;
        napi_typeof(env, value, &valueType);
        return valueType;
    }

    void GetRawFileDescritorObject(napi_env env, napi_value value, int &nativeFd, int64_t &nativeOffset,
        int64_t &nativeLength)
    {
        napi_value fd;
        napi_status status = napi_get_named_property(env, value, "fd", &fd);
        if (status == napi_ok && fd != nullptr && GetValueType(env, fd) == napi_number) {
            napi_get_value_int32(env, fd, &nativeFd);
        }

        napi_value offset;
        status = napi_get_named_property(env, value, "offset", &offset);
        if (status == napi_ok && offset != nullptr && GetValueType(env, offset) == napi_number) {
            napi_get_value_int64(env, offset, &nativeOffset);
        }

        napi_value length;
        status = napi_get_named_property(env, value, "length", &length);
        if (status == napi_ok && length != nullptr && GetValueType(env, length) == napi_number) {
            napi_get_value_int64(env, length, &nativeLength);
        }
    }
}

static napi_value ReleaseRawFileDescriptor(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "ReleaseRawFileDescriptor Begin");
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    bool succeed = false;
    if (GetValueType(env, argv[1]) == napi_object) {
        RawFileDescriptor descriptor;
        int64_t offset = 0;
        int64_t length = 0;
        GetRawFileDescritorObject(env, argv[1], descriptor.fd, offset, length);
        descriptor.start = static_cast<long>(offset);
        descriptor.length = static_cast<long>(length);
        succeed = OH_ResourceManager_ReleaseRawFileDescriptor(descriptor);
    }
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    napi_value result;
    napi_get_boolean(env, succeed, &result);
    return result;
}

static napi_value ReleaseRawFileDescriptor64(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "ReleaseRawFileDescriptor64 Begin");
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    
    bool succeed = false;
    if (GetValueType(env, argv[1]) == napi_object) {
        RawFileDescriptor64 descriptor;
        GetRawFileDescritorObject(env, argv[1], descriptor.fd, descriptor.start, descriptor.length);
        succeed = OH_ResourceManager_ReleaseRawFileDescriptor64(&descriptor);
    }
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    napi_value result;
    napi_get_boolean(env, succeed, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getFileList", nullptr, GetFileList, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRawFileContent", nullptr, GetRawFileContent, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRawFileContent64", nullptr, GetRawFileContent64, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRawFileDescriptor", nullptr, GetRawFileDescriptor, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRawFileDescriptor64", nullptr, GetRawFileDescriptor64, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseRawFileDescriptor", nullptr, ReleaseRawFileDescriptor, nullptr, nullptr, nullptr, napi_default,
            nullptr},
        {"releaseRawFileDescriptor64", nullptr, ReleaseRawFileDescriptor64, nullptr, nullptr, nullptr, napi_default,
            nullptr},
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
