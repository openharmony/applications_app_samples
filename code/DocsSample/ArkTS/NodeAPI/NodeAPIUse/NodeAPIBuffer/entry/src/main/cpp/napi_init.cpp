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

#include <string>
#include "hilog/log.h"
#include "napi/native_api.h"

static constexpr int INT_ARG_5 = 5; // 入参索引

// [Start napi_create_buffer]
// napi_create_buffer
static napi_value CreateBuffer(napi_env env, napi_callback_info info)
{
    std::string str("CreateBuffer");
    void *bufferPtr = nullptr;
    size_t bufferSize = str.size();
    napi_value buffer = nullptr;
    // 调用napi_create_buffer接口创建并获取一个指定大小的ArkTS Buffer
    napi_status status = napi_create_buffer(env, bufferSize + 1, &bufferPtr, &buffer);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_buffer failed");
        return nullptr;
    }
    // 将字符串str的值复制到buffer的内存中
    strcpy((char *)bufferPtr, str.data());
    return buffer;
}
// [End napi_create_buffer]

// [Start napi_create_buffer_copy]
// napi_create_buffer_copy
static napi_value CreateBufferCopy(napi_env env, napi_callback_info info)
{
    // 要copy的内容
    char str[] = "CreateBufferCopy";
    napi_value buffer = nullptr;
    // 调用napi_create_buffer_copy接口创建buffer并将str的内容copy到buffer
    void* resultData = nullptr;
    napi_status status = napi_create_buffer_copy(env, sizeof(str), str, &resultData, &buffer);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_buffer_copy failed");
        return nullptr;
    }
    if (resultData != nullptr) {
        OH_LOG_INFO(LOG_APP, "Node-API resultData is : %{public}s.", reinterpret_cast <const char*>(resultData));
    } else {
        OH_LOG_INFO(LOG_APP, "Node-API resultData is nullptr.");
    }
    return buffer;
}
// [End napi_create_buffer_copy]

// [Start napi_create_external_buffer]
// 回调函数，用于释放内存
void FinalizeCallback(napi_env env, void *data, void *hint)
{
    if (data == nullptr) {
        return;
    }
    free(data);
    data = nullptr;
}

// napi_create_external_buffer
static napi_value CreateExternalBuffer(napi_env env, napi_callback_info info)
{
    // 创建一个字符串
    std::string str("CreateExternalBuffer");
    // 在堆上分配内存，大小为字符串的长度
    void* data = malloc(str.size() + 1);
    if (data == nullptr) {
        OH_LOG_ERROR(LOG_APP, "malloc failed");
        return nullptr;
    }
    memset(data, 0, str.size() + 1);
    // 将字符串复制到分配的内存中
    strcpy(static_cast<char *>(data), str.data());
    // 使用napi_create_external_buffer接口创建并获取一个指定大小buffer
    napi_value buffer = nullptr;
    napi_status status = napi_create_external_buffer(env, str.size(), data, FinalizeCallback, nullptr, &buffer);
    if (status != napi_ok) {
        free(data);
        OH_LOG_ERROR(LOG_APP, "napi_create_external_buffer failed");
        return nullptr;
    }
    return buffer;
}
// [End napi_create_external_buffer]

// [Start napi_get_buffer_info]
// napi_get_buffer_info
static napi_value GetBufferInfo(napi_env env, napi_callback_info info)
{
    // 创建一个字符串
    std::string str("GetBufferInfo");
    napi_value buffer = nullptr;
    void *bufferPtr = nullptr;
    size_t bufferSize = str.size();
    napi_status status = napi_create_buffer(env, bufferSize + 1, &bufferPtr, &buffer);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_buffer failed");
        return nullptr;
    }
    strcpy((char *)bufferPtr, str.data());

    // 获取Buffer的信息
    void *tmpBufferPtr = nullptr;
    size_t bufferLength = 0;
    napi_get_buffer_info(env, buffer, &tmpBufferPtr, &bufferLength);

    // 创建一个新的ArkTS字符串来保存Buffer的内容并返出去
    if (bufferLength == 0 || ((char*)tmpBufferPtr)[bufferLength - 1] != '\0') {
        OH_LOG_ERROR(LOG_APP, "Buffer is not null-terminated");
        return nullptr;
    }
    napi_value returnValue = nullptr;
    napi_create_string_utf8(env, (char*)tmpBufferPtr, bufferLength, &returnValue);
    return returnValue;
}
// [End napi_get_buffer_info]

// [Start napi_is_buffer]
// napi_is_buffer
static napi_value IsBuffer(napi_env env, napi_callback_info info)
{
    // 创建一个Buffer对象
    std::string str = "buffer";
    napi_value buffer = nullptr;
    void *bufferPtr = nullptr;
    napi_create_buffer(env, str.size(), &bufferPtr, &buffer);

    // 调用napi_is_buffer接口判断创建的对象是否为buffer
    bool result = false;
    napi_is_buffer(env, buffer, &result);
    // 将结果返回出去
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);
    return returnValue;
}
// [End napi_is_buffer]

// [Start napi_create_external_arraybuffer]
typedef struct {
    uint8_t *data;
    size_t length;
} BufferData;

void FinalizeCallback1(napi_env env, void *finalizeData, void *finalizeHint)
{
    // 获取终结时的数据
    BufferData *bufferData = static_cast<BufferData *>(finalizeData);

    // 执行清理操作，比如释放资源
    delete[] bufferData->data;
    delete bufferData;
}

// napi_create_external_arraybuffer
napi_value CreateExternalArraybuffer(napi_env env, napi_callback_info info)
{
    // 创建一个有五个元素的C++数组
    uint8_t *dataArray = new uint8_t[5]{1, 2, 3, 4, 5};
    napi_value externalBuffer = nullptr;
    BufferData *bufferData = new BufferData{dataArray, 5};

    // 使用napi_create_external_arraybuffer创建一个外部Array Buffer对象，并指定终结回调函数
    napi_status status =
        napi_create_external_arraybuffer(env, dataArray, 5, FinalizeCallback1, bufferData, &externalBuffer);
    if (status != napi_ok) {
        // 处理错误
        delete[] dataArray;
        delete bufferData;
        napi_throw_error(env, nullptr, "Node-API napi_create_external_arraybuffer fail");
        return nullptr;
    }
    napi_value outputArray;
    // 使用napi_create_typedarray创建一个Array对象，并将externalBuffer对象作为参数传入
    status = napi_create_typedarray(env, napi_int8_array, INT_ARG_5, externalBuffer, 0, &outputArray);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Node-API napi_create_typedarray fail");
        return nullptr;
    }
    return outputArray;
}
// [End napi_create_external_arraybuffer]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createBuffer", nullptr, CreateBuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createBufferCopy", nullptr, CreateBufferCopy, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createExternalBuffer", nullptr, CreateExternalBuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getBufferInfo", nullptr, GetBufferInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isBuffer", nullptr, IsBuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createExternalArraybuffer", nullptr, CreateExternalArraybuffer, nullptr, nullptr, nullptr, napi_default,
         nullptr}};
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
