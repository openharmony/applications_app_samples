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
#include "hilog/log.h"

// [Start napi_create_bigint_int64]
// napi_create_bigint_int64
static napi_value CreateBigintInt64t(napi_env env, napi_callback_info info)
{
    // 声明int64_t的变量value
    int64_t value = -5555555555555555555;
    // 将value转化为napi_value类型返回
    napi_value returnValue = nullptr;
    napi_create_bigint_int64(env, value, &returnValue);
    return returnValue;
}
// [End napi_create_bigint_int64]

// [Start napi_create_bigint_uint64]
// napi_create_bigint_uint64
static napi_value CreateBigintUint64t(napi_env env, napi_callback_info info)
{
    // 声明uint64_t的变量value
    uint64_t value = 5555555555555555555;
    // 将value转化为napi_value类型返回
    napi_value returnValue = nullptr;
    napi_create_bigint_uint64(env, value, &returnValue);
    return returnValue;
}
// [End napi_create_bigint_uint64]

// [Start napi_create_bigint_words]
// napi_create_bigint_words
static napi_value CreateBigintWords(napi_env env, napi_callback_info info)
{
    // 使用napi_create_bigint_words接口创建一个BigInt对象
    int signBit = 0;
    size_t wordCount = 3;
    uint64_t words[] = {12ULL, 34ULL, 56ULL};
    napi_value returnValue = nullptr;
    napi_status status = napi_create_bigint_words(env, signBit, wordCount, words, &returnValue);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_create_bigint_words fail");
        return nullptr;
    }
    return returnValue;
}
// [End napi_create_bigint_words]

// [Start napi_get_value_bigint_int64]
// napi_get_value_bigint_int64
static napi_value GetValueBigintInt64t(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 从传入的参数中提取64位整数的BigInt数据
    int64_t value = 0;
    bool lossLess = false;
    napi_status status = napi_get_value_bigint_int64(env, args[0], &value, &lossLess);
    // 判断从ArkTS侧获取bigint是否为无损转换，如果不是抛出异常
    if (!lossLess) {
        napi_throw_error(env, nullptr, "BigInt values have not been lossless converted");
        return nullptr;
    }
    // 如果接口调用成功正常调用则返回true给ArkTS侧
    napi_value returnValue = nullptr;
    if (status == napi_ok) {
        napi_get_boolean(env, true, &returnValue);
        return returnValue;
    } else {
        napi_throw_error(env, nullptr, "napi_get_value_bigint_int64 failed");
        return nullptr;
    }
}
// [End napi_get_value_bigint_int64]

// [Start napi_get_value_bigint_uint64]
// napi_get_value_bigint_uint64
static napi_value GetValueBigintUint64t(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 从参数值中获取BigInt的数值
    uint64_t value = 0;
    bool lossLess = false;
    napi_status status = napi_get_value_bigint_uint64(env, args[0], &value, &lossLess);
    // 判断从ArkTS侧获取bigint是否为无损转换，如果不是抛出异常
    if (!lossLess) {
        napi_throw_error(env, nullptr, "BigInt values have no lossless converted");
        return nullptr;
    }
    // 如果接口调用成功正常调用则返回true给ArkTS侧
    napi_value returnValue = nullptr;
    napi_get_boolean(env, status == napi_ok, &returnValue);
    return returnValue;
}
// [End napi_get_value_bigint_uint64]

// [Start napi_get_value_bigint_words]
// napi_get_value_bigint_words
static napi_value GetValueBigintWords(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int signBit = 0;
    size_t wordCount = 0;
    // 调用napi_get_value_bigint_words接口获取wordCount
    napi_status status = napi_get_value_bigint_words(env, args[0], nullptr, &wordCount, nullptr);
    OH_LOG_INFO(LOG_APP, "Node-API , wordCount:%{public}d.", wordCount);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Node-API , get wordCount fail, status:%{public}d.", status);
        napi_throw_error(env, nullptr, "napi_get_value_bigint_words call failed");
        return nullptr;
    }
    if (wordCount == 0) {
        OH_LOG_ERROR(LOG_APP, "Node-API , wordCount is 0, invalid BigInt or empty value.");
        napi_throw_error(env, nullptr, "napi_get_value_bigint_words returned wordCount 0");
        return nullptr;
    }
    
    const size_t MAX_ALLOWED_WORDS = 1024; // 限制wordCount上限（业务防护，根据实际场景调整）示例：最多允许1024个uint64_t（8KB）
    if (wordCount > MAX_ALLOWED_WORDS) {
        OH_LOG_ERROR(LOG_APP, "Node-API , wordCount(%{public}zu) exceeds max limit(%{public}zu)",
            wordCount, MAX_ALLOWED_WORDS);
        napi_throw_error(env, nullptr, "wordCount is too large");
        return nullptr;
    }
    // 分配足够空间存储所有word
    uint64_t* words = new uint64_t[wordCount];
    // 调用napi_get_value_bigint_words接口获取传入bigInt相关信息，如：signBit传入bigInt正负信息
    status = napi_get_value_bigint_words(env, args[0], &signBit, &wordCount, words);
    OH_LOG_INFO(LOG_APP, "Node-API , signBit: %{public}d.", signBit);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Node-API , reason:%{public}d.", status);
        delete[] words;
        napi_throw_error(env, nullptr, "napi_get_value_bigint_words fail");
        return nullptr;
    }
    // 可在此处处理words数组内容，如日志输出等
    // ...
    // 将符号位转化为int类型传出去
    napi_value returnValue = nullptr;
    napi_create_int32(env, signBit, &returnValue);
    delete[] words;
    return returnValue;
}
// [End napi_get_value_bigint_words]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createBigintInt64t", nullptr, CreateBigintInt64t, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createBigintUint64t", nullptr, CreateBigintUint64t, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createBigintWords", nullptr, CreateBigintWords, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueBigintInt64t", nullptr, GetValueBigintInt64t, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueBigintUint64t", nullptr, GetValueBigintUint64t, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueBigintWords", nullptr, GetValueBigintWords, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
