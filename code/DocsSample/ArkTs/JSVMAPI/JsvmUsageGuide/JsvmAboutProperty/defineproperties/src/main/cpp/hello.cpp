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
#include "ark_runtime/jsvm.h"
#include <cstdlib>
#include <string>

#define LOG_DOMAIN 0x3200
#define LOG_TAG "APP"
#define MAX_MALLOC_SIZE 0x800000

static int g_aa = 0;

#define CHECK_RET(theCall)                                                                                             \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if ((cond) != JSVM_OK) {                                                                                       \
            const JSVM_ExtendedErrorInfo *info;                                                                        \
            OH_JSVM_GetLastErrorInfo(env, &info);                                                                      \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s", \
                         __FILE__, __LINE__, cond, info != nullptr ? info->errorMessage : "");                         \
            return -1;                                                                                                 \
        }                                                                                                              \
    } while (0)

#define CHECK(theCall)                                                                                                 \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if ((cond) != JSVM_OK) {                                                                                       \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d", __FILE__, __LINE__,  \
                         cond);                                                                                        \
            return -1;                                                                                                 \
        }                                                                                                              \
    } while (0)

// 用于调用theCall并检查其返回值是否为JSVM_OK。
// 如果不是，则调用OH_JSVM_GetLastErrorInfo处理错误并返回retVal。
#define JSVM_CALL_BASE(env, theCall, retVal)                                                                           \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if (cond != JSVM_OK) {                                                                                         \
            const JSVM_ExtendedErrorInfo *info;                                                                        \
            OH_JSVM_GetLastErrorInfo(env, &info);                                                                      \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s", \
                         __FILE__, __LINE__, cond, info != nullptr ? info->errorMessage : "");                         \
            return retVal;                                                                                             \
        }                                                                                                              \
    } while (0)

// JSVM_CALL_BASE的简化版本，返回nullptr
#define JSVM_CALL(theCall) JSVM_CALL_BASE(env, theCall, nullptr)

// [Start oh_jsvm_define_properties]
// 属性描述符列表中defineMethodPropertiesExample属性的回调函数
static JSVM_Value DefineMethodPropertiesExample(JSVM_Env env, JSVM_CallbackInfo info)
{
    int32_t propValue = 26;
    JSVM_Value returnValue;
    OH_JSVM_CreateInt32(env, propValue, &returnValue);
    return returnValue;
}
// 属性描述符列表中getterCallback属性的回调函数
static JSVM_Value GetterCallback(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_Value result;
    const char *str = "Hello world!";
    size_t length = strlen(str);
    // 创建属性的值
    OH_JSVM_CreateStringUtf8(env, str, length, &result);
    return result;
}

// 执行JavaScript字符串的函数
static JSVM_Value RunScriptAndLogResult(JSVM_Env env, const std::string &srcCode)
{
    JSVM_Value sourceCodeValue;
    OH_JSVM_CreateStringUtf8(env, srcCode.c_str(), srcCode.size(), &sourceCodeValue);
    JSVM_Script script;
    // 编译JavaScript代码字符串并返回编译后的脚本
    OH_JSVM_CompileScript(env, sourceCodeValue, nullptr, 0, true, nullptr, &script);
    JSVM_Value jsVmResult;
    // 执行JavaScript代码字符串
    OH_JSVM_RunScript(env, script, &jsVmResult);
    return jsVmResult;
}

// OH_JSVM_DefineProperties的样例方法
static JSVM_Value DefineProperties(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 接受一个JavaScript侧传入的空object
    size_t argc = 1;
    JSVM_Value argv[1] = {nullptr};
    OH_JSVM_GetCbInfo(env, info, &argc, argv, nullptr, nullptr);
    // 创建一个string类型的属性值
    JSVM_Value stringValue;
    OH_JSVM_CreateStringUtf8(env, "Hello!", JSVM_AUTO_LENGTH, &stringValue);
    // 创建属性描述符对应的回调函数列表
    JSVM_CallbackStruct param[] = {
        {.data = nullptr, .callback = DefineMethodPropertiesExample},
        {.data = nullptr, .callback = GetterCallback},

    };
    // 创建属性描述符列表，不同类型属性值添加位置参考JSVM_PropertyDescriptor定义
    JSVM_PropertyDescriptor descriptor[] = {
        // 定义method类型的属性值
        {"defineMethodPropertiesExample", nullptr, &param[0], nullptr, nullptr, nullptr, JSVM_DEFAULT},
        // 定义string类型的属性值
        {"defineStringPropertiesExample", nullptr, nullptr, nullptr, nullptr, stringValue, JSVM_DEFAULT},
        // 定义getter类型的属性值
        {"getterCallback", nullptr, nullptr, &param[1], nullptr, nullptr, JSVM_DEFAULT}};
    // 根据属性描述符列表为obj对象创建属性
    JSVM_Status statusProperty = OH_JSVM_DefineProperties(env,
                                                          *argv,
                                                          sizeof(descriptor) / sizeof(descriptor[0]),
                                                          descriptor);
    if (statusProperty != JSVM_OK) {
        OH_JSVM_ThrowError(env, nullptr, "JSVM DefineProperties fail");
        return nullptr;
    }
    // 调用obj对象中添加的属性
    // 运行obj.defineMethodPropertiesExample()并将结果返回给JavaScript
    std::string srcMethod = R"JS(obj.defineMethodPropertiesExample();)JS";
    JSVM_Value jsVmResult = RunScriptAndLogResult(env, srcMethod);
    if (jsVmResult != nullptr) {
        int32_t number;
        OH_JSVM_GetValueInt32(env, jsVmResult, &number);
        OH_LOG_INFO(LOG_APP, "JSVM DefineMethodPropertiesExample success:%{public}d", number);
    }
    // 运行obj.defineStringPropertiesExample()并将结果返回给JavaScript
    static std::string srcString = R"JS(obj.defineStringPropertiesExample;)JS";
    JSVM_Value jsVmResult1 = RunScriptAndLogResult(env, srcString);
    if (jsVmResult1 != nullptr) {
        size_t length = 0;
        OH_JSVM_GetValueStringUtf8(env, jsVmResult1, nullptr, 0, &length);
        if (length == 0 || length > MAX_MALLOC_SIZE) {
            OH_LOG_ERROR(LOG_APP, "Invalid string length: %{public}zu", length);
            return jsVmResult;
        }
        char *buf = (char *)malloc(length + 1);
        OH_JSVM_GetValueStringUtf8(env, jsVmResult1, buf, length + 1, &length);
        OH_LOG_INFO(LOG_APP, "JSVM defineStringPropertiesExample success:%{public}s", buf);
        free(buf);
    }
    // 调用obj的getterCallback()并将结果字符串返回给JavaScript
    static std::string srcGetter = R"JS(obj.getterCallback;)JS";
    JSVM_Value jsVmResult2 = RunScriptAndLogResult(env, srcGetter);
    if (jsVmResult2 != nullptr) {
        size_t length = 0;
        OH_JSVM_GetValueStringUtf8(env, jsVmResult2, nullptr, 0, &length);
        OH_JSVM_GetValueStringUtf8(env, jsVmResult1, nullptr, 0, &length);
        if (length == 0 || length > MAX_MALLOC_SIZE) {
            OH_LOG_ERROR(LOG_APP, "Invalid string length: %{public}zu", length);
            return jsVmResult;
        }
        char *buf = (char *)malloc(length + 1);
        OH_JSVM_GetValueStringUtf8(env, jsVmResult2, buf, length + 1, &length);
        OH_LOG_INFO(LOG_APP, "JSVM getterCallback success:%{public}s", buf);
        free(buf);
    }
    return jsVmResult;
}

// DefineProperties注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = DefineProperties},
};
static JSVM_CallbackStruct *method = param;
// DefineProperties方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"defineProperties", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

// 样例测试js
const char *SRC_CALL_NATIVE = R"JS(
    let obj = {};
    defineProperties(obj)
)JS";
// [End oh_jsvm_define_properties]

static int32_t TestJSVM()
{
    JSVM_InitOptions initOptions = {0};
    JSVM_VM vm;
    JSVM_Env env = nullptr;
    JSVM_VMScope vmScope;
    JSVM_EnvScope envScope;
    JSVM_HandleScope handleScope;
    JSVM_Value result;
    // 初始化JavaScript引擎实例
    if (g_aa == 0) {
        g_aa++;
        CHECK(OH_JSVM_Init(&initOptions));
    }
    // 创建JSVM环境
    CHECK(OH_JSVM_CreateVM(nullptr, &vm));
    CHECK(OH_JSVM_CreateEnv(vm, sizeof(descriptor) / sizeof(descriptor[0]), descriptor, &env));
    CHECK(OH_JSVM_OpenVMScope(vm, &vmScope));
    CHECK_RET(OH_JSVM_OpenEnvScope(env, &envScope));
    CHECK_RET(OH_JSVM_OpenHandleScope(env, &handleScope));

    // 通过script调用测试函数
    JSVM_Script script;
    JSVM_Value jsSrc;
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE, JSVM_AUTO_LENGTH, &jsSrc));
    CHECK_RET(OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script));
    CHECK_RET(OH_JSVM_RunScript(env, script, &result));

    // 销毁JSVM环境
    CHECK_RET(OH_JSVM_CloseHandleScope(env, handleScope));
    CHECK_RET(OH_JSVM_CloseEnvScope(env, envScope));
    CHECK(OH_JSVM_CloseVMScope(vm, vmScope));
    CHECK(OH_JSVM_DestroyEnv(env));
    CHECK(OH_JSVM_DestroyVM(vm));
    return 0;
}

static napi_value RunTest(napi_env env, napi_callback_info info)
{
    TestJSVM();
    return nullptr;
}

// 模块注册信息，供arkts侧调用
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {{"runTest", nullptr, RunTest, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "defineproperties",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
