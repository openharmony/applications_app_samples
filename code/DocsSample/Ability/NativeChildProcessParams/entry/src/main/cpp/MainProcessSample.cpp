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

// [Start main_process_launch_native_child]
#include <AbilityKit/native_child_process.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
// [StartExclude main_process_launch_native_child]
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>

int32_t result = -1;
// [EndExclide main_process_launch_native_child]

void startNativeChildProcess()
{
    // ...
    NativeChildProcess_Args args;
    // 设置entryParams，支持传输的最大数据量为150KB
    args.entryParams = (char*)malloc(sizeof(char) * 10);
    (void)strcpy(args.entryParams, "testParam");

    // 插入节点到链表头节点中
    args.fdList.head = (NativeChildProcess_Fd*)malloc(sizeof(NativeChildProcess_Fd));
    // fd关键字，最多不超过20个字符
    args.fdList.head->fdName = (char*)malloc(sizeof(char) * 4);
    (void)strcpy(args.fdList.head->fdName, "fd1");
    // 获取fd逻辑
    int32_t fd = open("/data/storage/el2/base/haps/entry/files/test.txt", O_RDWR | O_CREAT, 0644);
    args.fdList.head->fd = fd;
    // 此处只插入一个fd记录，根据需求可以插入更多fd记录到链表中，最多不超过16个
    args.fdList.head->next = NULL;
    NativeChildProcess_Options options = {
        .isolationMode = NCP_ISOLATION_MODE_ISOLATED
    };

    // 第一个参数"libchildprocesssample.so:Main"为实现了子进程Main方法的动态库文件名称和入口方法名
    int32_t pid = -1;
    Ability_NativeChildProcess_ErrCode ret = OH_Ability_StartNativeChildProcess(
        "libchildprocesssample.so:Main", args, options, &pid);
    if (ret != NCP_NO_ERROR) {
        // 释放NativeChildProcess_Args中的内存空间防止内存泄漏
        // 子进程未能正常启动时的异常处理
        // ...
    }

    // 其他逻辑
// [StartExclude main_process_launch_native_child]
    result = ret;
// [EndExclide main_process_launch_native_child]

    // 释放NativeChildProcess_Args中的内存空间防止内存泄漏
}
// [End main_process_launch_native_child]

static napi_value TestChildProcess(napi_env env, napi_callback_info info)
{
    startNativeChildProcess();
    napi_value napiRet;
    napi_create_int32(env, result, &napiRet);
    return napiRet;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"TestChildProcess", nullptr, TestChildProcess, nullptr, nullptr, nullptr, napi_default, nullptr}
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
    .nm_modname = "mainprocesssample",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
