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

// [Start HiLog_CPP_Callback]
#include "napi/native_api.h"
static constexpr OHOS::HiviewDFX::HiLogLabel LABEL = {LOG_CORE, 0xD003200, "MY_TAG"};
// [StartExclude HiLog_CPP_Callback]
// [Start HiLog_CPP_Header]
#include "hilog/log.h"
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200  // 全局domain宏，标识业务领域
#define LOG_TAG "MY_TAG"   // 全局tag宏，标识模块日志tag
// [End HiLog_CPP_Header]
// [EndExclude HiLog_CPP_Callback]

void MyHiLog(const LogType type, const LogLevel level, const unsigned int domain, const char *tag, const char *msg)
{
    // user-defined to handle your log, such as redirect/filter
    // 注意: 回调函数里面不允许再调用hilog接口打印日志，不然会死循环
}

static napi_value HiLogTest(napi_env env, napi_callback_info info)
{
    OH_LOG_SetCallback(MyHiLog);
    HiLog::Info(LABEL, "hello world");
// [StartExclude HiLog_CPP_Callback]
// [Start HiLog_CPP_Log_Error]
    OH_LOG_ERROR(LOG_APP, "Failed to test");
// [End HiLog_CPP_Log_Error]
// [EndExclude HiLog_CPP_Callback]
}
// [End HiLog_CPP_Callback]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "HiLogTest", nullptr, HiLogTest, nullptr, nullptr, nullptr, napi_default, nullptr }
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
