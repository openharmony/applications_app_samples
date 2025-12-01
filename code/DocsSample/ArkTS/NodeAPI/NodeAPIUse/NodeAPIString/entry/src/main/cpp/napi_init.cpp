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

// [Start napi_get_value_string_utf8]
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
// [End napi_get_value_string_utf8]

// [Start napi_create_string_utf8]
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
// [End napi_create_string_utf8]

// [Start napi_get_value_string_utf16]
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
// [End napi_get_value_string_utf16]

// [Start napi_create_string_utf16]
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
// [End napi_create_string_utf16]

// [Start napi_get_value_string_latin1]
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
// [End napi_get_value_string_latin1]

// [Start napi_create_string_latin1]
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
// [End napi_create_string_latin1]

// [Start napi_create_external_string_utf16]
// 定义字符串的析构回调函数，如果需要释放外部资源，可以在该函数中实现
// hint参数可以传递一些额外的信息，如引用计数等，也可以忽略此参数，直接传入nullptr
static void StringFinalizerUTF16(void* data, void* hint)
{
    // 释放外部资源
    delete[] static_cast<char16_t*>(data);
}

static napi_value CreateExternalStringUtf16(napi_env env, napi_callback_info info)
{
    const char16_t source[] = u"你好, World!, successes to create UTF-16 string! 111";
    napi_value result = nullptr;
    int char16tLength = sizeof(source) / sizeof(char16_t);
    // 在堆上动态分配内存，并复制字符串内容
    char16_t* str = new char16_t[char16tLength];
    std::copy(source, source + char16tLength, str);
    // 当创建出来的字符串在ArkTS侧生命周期结束被GC回收时，会调用StringFinalizerUTF16函数，调用方式为StringFinalizerUTF16(str, finalize_hint);
    // 如果finalize_callback传入nullptr，则不会调用任何回调函数。开发者需要自行管理外部资源str的生命周期。
    napi_status status = napi_create_external_string_utf16(
        env,
        str,                    // 外部字符串缓冲区
        NAPI_AUTO_LENGTH,       // 字符串长度，如果传入NAPI_AUTO_LENGTH，则字符串需要以'\0'结尾
        StringFinalizerUTF16,   // 字符串的析构回调函数
        nullptr,                // 传递给析构回调函数的hint参数，本例不需要
        &result                 // 接受创建的ArkTS字符串值
    );
    if (status != napi_ok) {
        // 处理错误
        delete[] str;
        napi_throw_error(env, nullptr, "Failed to create utf16 string");
        return nullptr;
    }
    return result;
}
// [End napi_create_external_string_utf16]

// [Start napi_create_external_string_ascii]
// 定义字符串的析构回调函数，如果需要释放外部资源，可以在该函数中实现
// hint参数可以传递一些额外的信息，如引用计数等，也可以忽略此参数，直接传入nullptr
static void StringFinalizerASCII(void* data, void* hint)
{
    // 释放外部资源
    delete[] static_cast<char*>(data);
}

static napi_value CreateExternalStringAscii(napi_env env, napi_callback_info info)
{
    const char source[] = "hello, World!, successes to create ASCII string! 111";
    napi_value result = nullptr;
    int charLength = sizeof(source) / sizeof(char);
    // 在堆上动态分配内存，并复制字符串内容
    char* str = new char[charLength];
    std::copy(source, source + charLength, str);
    // 当创建出来的字符串在ArkTS侧生命周期结束被GC回收时，会调用StringFinalizerASCII函数，调用方式为StringFinalizerASCII(str, finalize_hint);
    // 如果finalize_callback传入nullptr，则不会调用任何回调函数。开发者需要自行管理外部资源str的生命周期。
    // napi_create_external_string_ascii 接口要求传入的字符串在指定的长度范围内不得包含'\0'字符，否则可能导致异常行为。
    napi_status status = napi_create_external_string_ascii(
        env,
        str,                    // 外部字符串缓冲区
        NAPI_AUTO_LENGTH,       // 字符串长度，如果传入NAPI_AUTO_LENGTH，则字符串需要以'\0'结尾
        StringFinalizerASCII,   // 字符串的析构回调函数
        nullptr,                // 传递给析构回调函数的hint参数，本例不需要
        &result                 // 接受创建的ArkTS字符串值
    );
    if (status != napi_ok) {
        // 处理错误
        delete[] str;
        napi_throw_error(env, nullptr, "Failed to create ascii string");
        return nullptr;
    }
    return result;
}
// [End napi_create_external_string_ascii]

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
        {"CreateExternalStringUtf16", nullptr, CreateExternalStringUtf16,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateExternalStringAscii", nullptr, CreateExternalStringAscii,
            nullptr, nullptr, nullptr, napi_default, nullptr}
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
