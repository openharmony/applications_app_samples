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

// [Start oh_jsvm_create_arraybuffer_from_external_memory]
#define JSVM_EXPERIMENTAL  // 必须在include jsvm.h之前定义，否则无法调用实验接口
#include "napi/native_api.h"
#include "ark_runtime/jsvm.h"
#include "hilog/log.h"
#include <cstdlib>
#include <cstring>
// [StartExclude oh_jsvm_create_arraybuffer_from_external_memory]
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
// [EndExclude oh_jsvm_create_arraybuffer_from_external_memory]

// 模拟从外部模块获取图像像素数据（RGBA，4像素）
static void *LoadPixelData(size_t *outSize)
{
    *outSize = 16;  // 4pixels×4bytes(RGBA)
    uint8_t *data = static_cast<uint8_t *>(malloc(*outSize));
    if (data == nullptr) {
        return nullptr;
    }
    // 填充示例像素：红、绿、蓝、白
    uint8_t pixels[] = {
        255, 0, 0, 255,     // 红
        0, 255, 0, 255,     // 绿
        0, 0, 255, 255,     // 蓝
        255, 255, 255, 255  // 白
    };
    memcpy(data, pixels, *outSize);
    return data;
}

// finalize回调：利用copied参数判断是否需要释放外部内存
static void PixelDataFinalize(JSVM_Env env, void *data, void *hint, bool copied)
{
    if (!copied) {
        // 零拷贝模式：引擎释放了对外部内存的引用，开发者负责释放
        free(data);
    } else {
        // 拷贝模式：引擎已拷贝数据，原始内存应已在API返回后被释放
        // data指针可能已失效，不要使用
    }
}

// OH_JSVM_CreateArrayBufferFromExternalMemory的样例方法
static JSVM_Value CreateArrayBufferFromExternal(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_Value undef = nullptr;
    OH_JSVM_GetUndefined(env, &undef);
    // 1. 从外部模块获取数据（malloc分配，满足8字节对齐要求）
    size_t dataSize = 0;
    void *pixelData = LoadPixelData(&dataSize);
    if (pixelData == nullptr) {
        OH_LOG_ERROR(LOG_APP, "JSVM: failed to load pixel data");
        return undef;
    }

    JSVM_HandleScope scope = nullptr;
    OH_JSVM_OpenHandleScope(env, &scope);

    // 2. 创建ArrayBuffer
    JSVM_Value arrayBuffer = nullptr;
    bool copied = false;
    JSVM_Status status = OH_JSVM_CreateArrayBufferFromExternalMemory(
        env, pixelData, dataSize, PixelDataFinalize, nullptr, &copied, &arrayBuffer);
    if (status != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "JSVM CreateArrayBufferFromExternalMemory: failed");
        free(pixelData);  // 创建失败时需手动释放
        return undef;
    }

    // 3. 根据copied参数管理原始内存
    if (copied) {
        // 引擎拷贝了数据，原始外部内存不再被引擎使用，可立即释放
        free(pixelData);
    }
    // copied==false时：引擎直接使用了外部内存，finalizeCb会在GC时负责释放

    // 4. 通过OH_JSVM_GetArraybufferInfo获取ArrayBuffer的数据指针来访问数据。
    //    不要直接使用pixelData指针，因为在拷贝模式下ArrayBuffer内部使用的
    //    是拷贝后的数据，pixelData指向的是原始外部内存。
    void *abData = nullptr;
    size_t abLen = 0;
    OH_JSVM_GetArraybufferInfo(env, arrayBuffer, &abData, &abLen);
    OH_LOG_INFO(LOG_APP, "JSVM CreateArrayBufferFromExternalMemory: success, "
                "byteLength=%{public}zu", abLen);

    OH_JSVM_CloseHandleScope(env, scope);

    // 触发GC回收External ArrayBuffer
    OH_JSVM_MemoryPressureNotification(env, JSVM_MEMORY_PRESSURE_LEVEL_CRITICAL);
    return undef;
}

// CreateArrayBufferFromExternal注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = CreateArrayBufferFromExternal},
};
static JSVM_CallbackStruct *method = param;
// CreateArrayBufferFromExternal方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"createArrayBufferFromExternal", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};
// 样例测试js
const char *SRC_CALL_NATIVE = R"JS(
createArrayBufferFromExternal();
)JS";
// [End oh_jsvm_create_arraybuffer_from_external_memory]

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
    CHECK(OH_JSVM_OpenVMScope(vm, &vmScope));
    CHECK(OH_JSVM_CreateEnv(vm, sizeof(descriptor) / sizeof(descriptor[0]), descriptor, &env));
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
    CHECK(OH_JSVM_DestroyEnv(env));
    CHECK(OH_JSVM_CloseVMScope(vm, vmScope));
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
    .nm_modname = "createarraybufferfromexternalmemory",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }