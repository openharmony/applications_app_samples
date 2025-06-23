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

// [Start oh_jsvm_check_object_type_tag]
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"
#define NUMBERINT_FOUR
// [StartExclude oh_jsvm_check_object_type_tag]
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
// [EndExclude oh_jsvm_check_object_type_tag]

// 定义一个静态常量JSVM_TypeTag数组存储类型标签
static const JSVM_TypeTag TagsData[NUMBERINT_FOUR] = {
    {0x9e4b2449547061b3, 0x33999f8a6516c499},
    {0x1d55a794c53a726d, 0x43633f509f9c944e},
    {0, 0}, // 用于表示无标签或默认标签
    {0x6a971439f5b2e5d7, 0x531dc28a7e5317c0},
};
// OH_JSVM_TypeTagObject的样例方法
static JSVM_Value SetTypeTagToObject(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 获取两个JavaScript侧传入的参数
    size_t argc = 2;
    JSVM_Value args[2] = {nullptr};
    OH_JSVM_GetCbInfo(env, info, &argc, args, nullptr, nullptr);
    // 获取索引数字转换为JSVM_Value
    int32_t index = 0;
    OH_JSVM_GetValueInt32(env, args[1], &index);
    // 给参数（对象）设置类型标签
    JSVM_Status status = OH_JSVM_TypeTagObject(env, args[0], &TagsData[index]);
    // 将bool结果转换为JSVM_Value并返回
    JSVM_Value result = nullptr;
    if (status != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "JSVM SetTypeTagToObject fail");
        OH_JSVM_GetBoolean(env, false, &result);
    } else {
        OH_LOG_INFO(LOG_APP, "JSVM SetTypeTagToObject success");
        OH_JSVM_GetBoolean(env, true, &result);
    }
    return result;
}
// OH_JSVM_CheckObjectTypeTag的样例方法
static JSVM_Value CheckObjectTypeTag(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 获取两个JavaScript侧传入的参数
    size_t argc = 2;
    JSVM_Value args[2] = {nullptr};
    OH_JSVM_GetCbInfo(env, info, &argc, args, nullptr, nullptr);
    // 获取索引数字转换为JSVM_Value
    int32_t index = 0;
    OH_JSVM_GetValueInt32(env, args[1], &index);
    // 检查对象的类型标签
    bool checkResult = false;
    JSVM_Status status = OH_JSVM_CheckObjectTypeTag(env, args[0], &TagsData[index], &checkResult);
    if (status != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "JSVM SetTypeTagToObject fail");
    } else {
        OH_LOG_INFO(LOG_APP, "JSVM SetTypeTagToObject:%{public}d", checkResult);
    }
    // 将bool结果转换为JSVM_Value并返回
    JSVM_Value checked = nullptr;
    OH_JSVM_GetBoolean(env, checkResult, &checked);
    return checked;
}
// SetTypeTagToObject，CheckObjectTypeTag注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = SetTypeTagToObject},
    {.data = nullptr, .callback = CheckObjectTypeTag},
};
static JSVM_CallbackStruct *method = param;
// SetTypeTagToObject，CheckObjectTypeTag方法别名，TS侧调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"setTypeTagToObject", nullptr, method, nullptr, nullptr, nullptr, JSVM_DEFAULT},
    {"checkObjectTypeTag", nullptr, method+1, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};
// 样例测试js
const char* SRC_CALL_NATIVE = R"JS(
         class Obj {
           data;
           message;
         }
         let obj= { data: 0, message: "hello world"};
         setTypeTagToObject(obj, 0);
         checkObjectTypeTag(obj, 0);)JS";
// [End oh_jsvm_check_object_type_tag]

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
    .nm_modname = "checkobjecttypetag",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
