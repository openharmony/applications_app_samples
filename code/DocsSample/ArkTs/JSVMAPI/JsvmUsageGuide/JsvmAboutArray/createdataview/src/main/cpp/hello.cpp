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

// [Start oh_jsvm_create_dataview]
#include "napi/native_api.h"
#include "ark_runtime/jsvm.h"
#include "hilog/log.h"

// [StartExclude oh_jsvm_create_dataview]
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

static int g_diffValueFour = 4;
static int g_diffValueTwelve = 12;
// [EndExclude oh_jsvm_create_dataview]

// OH_JSVM_CreateDataview的样例方法
static JSVM_Value CreateDataView(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 获取js侧传入的两个参数
    size_t argc = 2;
    JSVM_Value args[2] = {nullptr};
    JSVM_Value arrayBuffer = nullptr;
    JSVM_Value result = nullptr;
    // DataView的字节长度
    size_t byteLength = g_diffValueFour;
    // 字节偏移量
    size_t byteOffset = g_diffValueTwelve;
    // 获取回调函数的参数信息
    OH_JSVM_GetCbInfo(env, info, &argc, args, nullptr, nullptr);
    // 将参数转换为对象类型
    OH_JSVM_CoerceToObject(env, args[0], &arrayBuffer);
    // 创建一个数据视图对象，并指定字节长度和字节偏移量
    JSVM_Status status = OH_JSVM_CreateDataview(env, byteLength, arrayBuffer, byteOffset, &result);
    // 获取DataView的指针和长度信息
    uint8_t *data = nullptr;
    size_t length = 0;
    // 为DataView赋值
    for (size_t i = 0; i < length; i++) {
        data[i] = static_cast<uint8_t>(i + 1);
    }
    int32_t infoType;
    OH_JSVM_GetValueInt32(env, args[1], &infoType);
    size_t returnLength;
    JSVM_Value returnArrayBuffer = nullptr;
    size_t returnOffset;
    enum InfoType { BYTE_LENGTHE, ARRAY_BUFFERE, BYTE_OFFSET };
    // 获取dataview信息
    OH_JSVM_GetDataviewInfo(env, result, &returnLength, (void **)&data, &returnArrayBuffer, &returnOffset);
    JSVM_Value returnResult = nullptr;
    switch (infoType) {
        case BYTE_LENGTHE:
            JSVM_Value len;
            OH_JSVM_CreateInt32(env, returnLength, &len);
            returnResult = len;
            if (status != JSVM_OK) {
                OH_LOG_ERROR(LOG_APP, "JSVM CreateDataView fail");
            } else {
                OH_LOG_INFO(LOG_APP, "JSVM CreateDataView success, returnLength: %{public}d", returnLength);
            }
            break;
        case ARRAY_BUFFERE:
            bool isArraybuffer;
            OH_JSVM_IsArraybuffer(env, returnArrayBuffer, &isArraybuffer);
            JSVM_Value isArray;
            OH_JSVM_GetBoolean(env, isArraybuffer, &isArray);
            returnResult = isArray;
            if (status != JSVM_OK) {
                OH_LOG_ERROR(LOG_APP, "JSVM CreateDataView fail");
            } else {
                OH_LOG_INFO(LOG_APP, "JSVM CreateDataView success, isArraybuffer: %{public}d", isArraybuffer);
            }
            break;
        case BYTE_OFFSET:
            JSVM_Value offset;
            OH_JSVM_CreateInt32(env, returnOffset, &offset);
            returnResult = offset;
            if (status != JSVM_OK) {
                OH_LOG_ERROR(LOG_APP, "JSVM CreateDataView fail");
            } else {
                OH_LOG_INFO(LOG_APP, "JSVM CreateDataView success, returnOffset: %{public}d", returnOffset);
            }
            break;
        default:
            break;
    }
    return returnResult;
}
// CreateDataView注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = CreateDataView},
};
static JSVM_CallbackStruct *method = param;
// CreateDataView方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"createDataView", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};
// 样例测试js
const char *SRC_CALL_NATIVE = R"JS(
 let BYTE_LENGTH = 0;
 createDataView(new ArrayBuffer(16), BYTE_LENGTH);
 let IS_ARRAYBUFFER = 1;
 createDataView(new ArrayBuffer(16), IS_ARRAYBUFFER);
 let BYTE_OFFSET = 2;
 createDataView(new ArrayBuffer(16), BYTE_OFFSET);
)JS";
// [End oh_jsvm_create_dataview]

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
    .nm_modname = "createdataview",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
