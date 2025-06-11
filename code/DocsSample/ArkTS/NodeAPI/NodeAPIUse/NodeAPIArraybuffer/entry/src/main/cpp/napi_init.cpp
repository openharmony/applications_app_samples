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

// [Start napi_is_arraybuffer]
// napi_is_arraybuffer
static napi_value IsArrayBuffer(napi_env env, napi_callback_info info)
{
    // 接受一个入参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用napi_is_arraybuffer接口判断给定入参是否为ArrayBuffer数据
    bool result = false;
    napi_status status = napi_is_arraybuffer(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_is_arraybuffer fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);
    return returnValue;
}
// [End napi_is_arraybuffer]

// [Start napi_get_arraybuffer_info]
// napi_get_arraybuffer_info
static napi_value GetArraybufferInfo(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 检查参数是否为ArrayBuffer
    bool isArraybuffer = false;
    napi_is_arraybuffer(env, args[0], &isArraybuffer);
    if (!isArraybuffer) {
        napi_throw_type_error(env, nullptr, "Argument must be an ArrayBuffer");
        return nullptr;
    }

    void *data = nullptr;
    size_t byteLength = 0;
    // 获取ArrayBuffer的底层数据缓冲区和长度
    napi_status status = napi_get_arraybuffer_info(env, args[0], &data, &byteLength);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to get ArrayBuffer info");
        return nullptr;
    }
    // 创建结果对象
    napi_value result = nullptr;
    napi_create_object(env, &result);
    // 创建数据缓冲区的字节长度属性
    napi_value byteLengthValue = nullptr;
    napi_create_uint32(env, byteLength, &byteLengthValue);
    napi_set_named_property(env, result, "byteLength", byteLengthValue);
    napi_value bufferData;
    napi_create_arraybuffer(env, byteLength, &data, &bufferData);
    napi_set_named_property(env, result, "buffer", bufferData);
    return result;
}
// [End napi_get_arraybuffer_info]

// [Start napi_detach_arraybuffer]
// napi_detach_arraybuffer
static napi_value DetachedArraybuffer(napi_env env, napi_callback_info info)
{
    // 调用napi_detach_arraybuffer接口分离给定ArrayBuffer的底层数据
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value arrayBuffer = args[0];
    napi_detach_arraybuffer(env, arrayBuffer);
    // 将分离后的arraybuffer传出去
    return arrayBuffer;
}

// napi_is_detach_arraybuffer
static napi_value IsDetachedArraybuffer(napi_env env, napi_callback_info info)
{
    // 调用napi_is_detached_arraybuffer判断给定的arraybuffer是否已被分离
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value arrayBuffer = args[0];
    bool result = false;
    napi_is_detached_arraybuffer(env, arrayBuffer, &result);
    // 将返回值通过napi_get_boolean接口转成napi_value传出去做打印
    napi_value returnValue;
    napi_get_boolean(env, result, &returnValue);
    return returnValue;
}
// [End napi_detach_arraybuffer]

// [Start napi_create_arraybuffer]
// napi_create_arraybuffer
static napi_value CreateArraybuffer(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value result = nullptr;
    // 解析传递的参数
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    int32_t value;
    size_t length;
    // 将ArkTS侧传递的参数转换为size_t类型，作为napi_create_arraybuffer的参数
    napi_get_value_int32(env, argv[0], &value);
    length = size_t(value);
    void *data;
    // 创建一个新的ArrayBuffer
    napi_create_arraybuffer(env, length, &data, &result);
    if (data != nullptr) {
        // 确保安全后才能使用data进行操作
    }
    // 返回ArrayBuffer
    return result;
}
// [End napi_create_arraybuffer]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"isArrayBuffer", nullptr, IsArrayBuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getArraybufferInfo", nullptr, GetArraybufferInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"detachedArraybuffer", nullptr, DetachedArraybuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isDetachedArraybuffer", nullptr, IsDetachedArraybuffer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createArraybuffer", nullptr, CreateArraybuffer, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
