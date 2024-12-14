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
#include <string>

static const int MAX_BUFFER_SIZE = 128;

static napi_value GetValueStringUtf8(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取字符串的长度
    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    // 传入一个非字符串 napi_get_value_string_utf8接口会返回napi_string_expected
    if (status != napi_ok) {
        return nullptr;
    }
    char *buf = new char[length + 1];
    std::memset(buf, 0, length + 1);
    napi_get_value_string_utf8(env, args[0], buf, length + 1, &length);
    napi_value result = nullptr;
    status = napi_create_string_utf8(env, buf, length, &result);
    delete buf;
    if (status != napi_ok) {
        return nullptr;
    };
    return result;
}

static napi_value CreateStringUtf8(napi_env env, napi_callback_info info)
{
    const char *str = u8"你好, World!, successes to create UTF-8 string! 111";
    size_t length = strlen(str);
    napi_value result = nullptr;
    napi_status status = napi_create_string_utf8(env, str, length, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create UTF-8 string");
        return nullptr;
    }
    return result;
}

static napi_value GetValueStringUtf16(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value result = nullptr;
    // 字符串的缓冲区
    char16_t buffer[MAX_BUFFER_SIZE];
    // 字符串的缓冲区大小
    size_t bufferSize = MAX_BUFFER_SIZE;
    // 字符串的长度
    size_t stringLen;
    // 获取字符串的数据和长度
    napi_get_value_string_utf16(env, args[0], buffer, bufferSize, &stringLen);
    // 获取字符串返回结果
    napi_create_string_utf16(env, buffer, stringLen, &result);
    // 返回结果
    return result;
}

static napi_value CreateStringUtf16(napi_env env, napi_callback_info info)
{
    const char16_t *str = u"你好, World!, successes to create UTF-16 string! 111";
    size_t length = NAPI_AUTO_LENGTH;
    napi_value result = nullptr;
    napi_status status = napi_create_string_utf16(env, str, length, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create UTF-16 string");
        return nullptr;
    }
    return result;
}

static napi_value GetValueStringLatin1(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char buf[MAX_BUFFER_SIZE];
    size_t length = 0;
    napi_value napi_Res = nullptr;
    napi_status status = napi_get_value_string_latin1(env, args[0], buf, MAX_BUFFER_SIZE, &length);
    // 当输入的值不是字符串时，接口会返回napi_string_expected
    if (status == napi_string_expected) {
        return nullptr;
    }
    napi_create_string_latin1(env, buf, length, &napi_Res);
    return napi_Res;
}

static napi_value CreateStringLatin1(napi_env env, napi_callback_info info)
{
    const char *str = "Hello, World! éçñ, successes to create Latin1 string! 111";
    size_t length = NAPI_AUTO_LENGTH;
    napi_value result = nullptr;
    napi_status status = napi_create_string_latin1(env, str, length, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to create Latin1 string");
        return nullptr;
    }
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getValueStringUtf8", nullptr, GetValueStringUtf8, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createStringUtf8", nullptr, CreateStringUtf8, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueStringUtf16", nullptr, GetValueStringUtf16, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createStringUtf16", nullptr, CreateStringUtf16, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueStringLatin1", nullptr, GetValueStringLatin1, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createStringLatin1", nullptr, CreateStringLatin1, nullptr, nullptr, nullptr, napi_default, nullptr},
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
