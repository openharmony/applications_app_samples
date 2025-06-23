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
// [Start oh_jsvm_defineclass]
#include <string>
// [StartExclude oh_jsvm_defineclass]
#define LOG_DOMAIN 0x3200
#define LOG_TAG "APP"

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
// [EndExclude oh_jsvm_defineclass]

JSVM_Value CreateInstance(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_Value newTarget;
    // 获取构造函数的new.target值
    JSVM_CALL(OH_JSVM_GetNewTarget(env, info, &newTarget));
    OH_LOG_INFO(LOG_APP, "Create Instance");
    OH_LOG_INFO(LOG_APP,
                "NAPI MyObject::New %{public}s",
                newTarget != nullptr ? "newTarget != nullptr" : "newTarget == nullptr");
    JSVM_Value jsObject = nullptr;
    JSVM_CALL(OH_JSVM_CreateObject(env, &jsObject));
    JSVM_Value jsName = nullptr;
    JSVM_CALL(OH_JSVM_CreateStringUtf8(env, "name", JSVM_AUTO_LENGTH, &jsName));
    JSVM_Value jsValue = nullptr;
    JSVM_CALL(OH_JSVM_CreateStringUtf8(env, "lilei", JSVM_AUTO_LENGTH, &jsValue));
    JSVM_CALL(OH_JSVM_SetProperty(env, jsObject, jsName, jsValue));
    return jsObject;
}

std::string ToString(JSVM_Env env, JSVM_Value val)
{
    JSVM_Value jsonString;
    JSVM_CALL(OH_JSVM_JsonStringify(env, val, &jsonString));
    size_t totalLen = 0;
    JSVM_CALL(OH_JSVM_GetValueStringUtf8(env, jsonString, nullptr, 0, &totalLen));
    size_t needLen = totalLen + 1;
    char* buff = new char[needLen];
    std::memset(buff, 0, needLen);
    JSVM_CALL(OH_JSVM_GetValueStringUtf8(env, jsonString, buff, needLen, &totalLen));
    std::string str(buff);
    delete[] buff;
    return str;
}

// 封装c++中的自定义数据结构
JSVM_Value DefineClass(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_CallbackStruct param;
    param.data = nullptr;
    param.callback = CreateInstance;
    JSVM_Value cons;
    // 用于在JavaScript中定义一个类
    JSVM_CALL(OH_JSVM_DefineClass(env, "MyObject", JSVM_AUTO_LENGTH, &param, 0, nullptr, &cons));
    JSVM_Value instanceValue = nullptr;
    // 作为class的构造函数调用
    JSVM_CALL(OH_JSVM_NewInstance(env, cons, 0, nullptr, &instanceValue));
    std::string str = ToString(env, instanceValue);
    OH_LOG_INFO(LOG_APP, "NewInstance:%{public}s", str.c_str());

    // 作为普通的函数调用
    JSVM_Value global;
    JSVM_CALL(OH_JSVM_GetGlobal(env, &global));
    JSVM_Value key;
    JSVM_CALL(OH_JSVM_CreateStringUtf8(env, "Constructor", JSVM_AUTO_LENGTH, &key));
    JSVM_CALL(OH_JSVM_SetProperty(env, global, key, cons));
    JSVM_Value result;
    JSVM_CALL(OH_JSVM_CallFunction(env, global, cons, 0, nullptr, &result));
    std::string buf = ToString(env, result);
    OH_LOG_INFO(LOG_APP, "NewInstance:%{public}s", buf.c_str());
    return nullptr;
}

// 注册DefineClass的方法
JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = DefineClass},
};

static JSVM_CallbackStruct *method = param;

// DefineClass方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"defineClass", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};
// [End oh_jsvm_defineclass]

const char *SRC_CALL_NATIVE = R"JS( defineClass(); )JS";

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
    .nm_modname = "defineclass",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
