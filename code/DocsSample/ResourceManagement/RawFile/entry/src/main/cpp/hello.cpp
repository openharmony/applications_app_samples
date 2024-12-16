/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <js_native_api.h>
#include <js_native_api_types.h>
#include <string>
#include <vector>
#include <iostream>
#include <cstdlib>
#include "napi/native_api.h"
#include "rawfile/raw_file_manager.h"
#include "rawfile/raw_file.h"
#include "rawfile/raw_dir.h"
#include "hilog/log.h"

const int GLOBAL_RESMGR = 0xFF00;
const char *TAG = "[Sample_rawfile]";

// 示例一：获取rawfile文件列表 GetFileList
static napi_value GetFileList(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "NDKTest Begin");
    size_t requireArgc = 3;
    size_t argc = 2;
    napi_value argv[2] = { nullptr };
    // 获取参数信息
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // argv[0]即为函数第一个参数Js资源对象，OH_ResourceManager_InitNativeResourceManager转为Native对象
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);

    // 获取函数argv[1]，此为rawfile相对路径
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string dirName(strBuf, strSize);

    // 获取对应的rawDir指针对象
    RawDir* rawDir = OH_ResourceManager_OpenRawDir(mNativeResMgr, dirName.c_str());

    // 获取rawDir下文件及文件夹数量
    int count = OH_ResourceManager_GetRawFileCount(rawDir);

    // 遍历获取文件名称，并保存
    std::vector<std::string> tempArray;
    for (int i = 0; i < count; i++) {
        std::string filename = OH_ResourceManager_GetRawFileName(rawDir, i);
        tempArray.emplace_back(filename);
    }

    // 转为js数组
    napi_value fileList;
    napi_create_array(env, &fileList);
    for (size_t i = 0; i < tempArray.size(); i++) {
        napi_value jsString;
        napi_create_string_utf8(env, tempArray[i].c_str(), NAPI_AUTO_LENGTH, &jsString);
        napi_set_element(env, fileList, i, jsString);
    }

    // 关闭打开的指针对象
    OH_ResourceManager_CloseRawDir(rawDir);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return fileList;
}

// 示例二：获取rawfile文件内容 GetRawFileContent
napi_value CreateJsArrayValue(napi_env env, std::unique_ptr<uint8_t[]> &data, long length)
{
    // 创建js外部ArrayBuffer
    napi_value buffer;
    napi_status status = napi_create_external_arraybuffer(env, data.get(), length,
        [](napi_env env, void *data, void *hint) {
            delete[] static_cast<char*>(data);
        }, nullptr, &buffer);
    // 检测ArrayBuffer是否创建成功
    if (status != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create external array buffer");
        return nullptr;
    }
    // 创建js TypedArray  将ArrayBuffer绑定到TypedArray
    napi_value result = nullptr;
    status = napi_create_typedarray(env, napi_uint8_array, length, buffer, 0, &result);
    if (status != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create media typed array");
        return nullptr;
    }
    data.release();
    return result;
}

static napi_value GetRawFileContent(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "GetFileContent Begin");
    size_t requireArgc = 3;
    size_t argc = 2;
    napi_value argv[2] = { nullptr };
    // 获取参数信息
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // argv[0]即为函数第一个参数Js资源对象，OH_ResourceManager_InitNativeResourceManager转为Native对象
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);

    // 获取rawfile指针对象
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile success");
    }
    // 获取rawfile大小并申请内存
    long len = OH_ResourceManager_GetRawFileSize(rawFile);
    std::unique_ptr<uint8_t[]> data = std::make_unique<uint8_t[]>(len);

    // 一次性读取rawfile全部内容
    int res = OH_ResourceManager_ReadRawFile(rawFile, data.get(), len);

    // 关闭打开的指针对象
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    // 转为js对象
    return CreateJsArrayValue(env, data, len);
}

// 示例三：获取rawfile文件描述符 GetRawFileDescriptor
// 定义一个函数，将RawFileDescriptor转为js对象
napi_value createJsFileDescriptor(napi_env env, RawFileDescriptor& descriptor)
{
    // 创建js对象
    napi_value result;
    napi_status status = napi_create_object(env, &result);
    if (status != napi_ok) {
        return result;
    }

    // 将文件描述符df存入到result对象中
    napi_value fd;
    status = napi_create_int32(env, descriptor.fd, &fd);
    if (status != napi_ok) {
        return result;
    }
    status = napi_set_named_property(env, result, "fd", fd);
    if (status != napi_ok) {
        return result;
    }

    // 将文件偏移量offset存入到result对象中
    napi_value offset;
    status = napi_create_int64(env, descriptor.start, &offset);
    if (status != napi_ok) {
        return result;
    }
    status = napi_set_named_property(env, result, "offset", offset);
    if (status != napi_ok) {
        return result;
    }

    // 将文件长度length存入到result对象中
    napi_value length;
    status = napi_create_int64(env, descriptor.length, &length);
    if (status != napi_ok) {
        return result;
    }
    status = napi_set_named_property(env, result, "length", length);
    if (status != napi_ok) {
        return result;
    }
    return result;
}

static napi_value GetRawFileDescriptor(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "NDKTest GetRawFileDescriptor Begin");
    size_t requireArgc = 3;
    size_t argc = 2;
    napi_value argv[2] = { nullptr };
    // 获取参数信息
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    
    napi_valuetype valueType;
    napi_typeof(env, argv[0], &valueType);
    // 获取native的resourceManager对象
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    // 获取rawfile指针对象
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "OH_ResourceManager_OpenRawFile success");
    }
    // 获取rawfile的描述符RawFileDescriptor {fd, offset, length}
    RawFileDescriptor descriptor;
    OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    // 关闭打开的指针对象
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    // 转为js对象
    return createJsFileDescriptor(env, descriptor);
}

napi_value CreateJsBool(napi_env env, bool &bValue)
{
    napi_value jsValue = nullptr;
    if (napi_get_boolean(env, bValue, &jsValue) != napi_ok) {
        return nullptr;
    }
    return jsValue;
}

static napi_value IsRawDir(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "NDKTest IsRawDir Begin");
    size_t requireArgc = 3;
    size_t argc = 2;
    napi_value argv[2] = { nullptr };
    // 获取参数信息
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    napi_valuetype valueType;
    napi_typeof(env, argv[0], &valueType);
    // 获取native的resourceManager对象
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);

    napi_valuetype valueType1;
    napi_typeof(env, argv[1], &valueType);
    if (valueType1 == napi_undefined || valueType1 == napi_null) {
        bool temp = false;
        return CreateJsBool(env, temp);
    }
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    // 获取rawfile指针对象
    bool result = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return CreateJsBool(env, result);
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "getFileList", nullptr, GetFileList, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getRawFileContent", nullptr, GetRawFileContent, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getRawFileDescriptor", nullptr, GetRawFileDescriptor, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isRawDir", nullptr, IsRawDir, nullptr, nullptr, nullptr, napi_default, nullptr }
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

