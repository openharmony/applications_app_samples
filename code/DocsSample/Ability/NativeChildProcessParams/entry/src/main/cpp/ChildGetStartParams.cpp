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

// [Start child_get_start_params_main]
// [Start child_get_start_params_header]
#include <AbilityKit/native_child_process.h>
// [End child_get_start_params_header]
#include <thread>

extern "C" {
void ThreadFunc()
{
    // 获取子进程的启动参数
    NativeChildProcess_Args *args = OH_Ability_GetCurrentChildProcessArgs();
    // 获取启动参数失败时返回nullptr
    if (args == nullptr) {
        return;
    }
    // 获取启动参数中的entryPrams
    char *entryParams = args->entryParams;
    // 获取fd列表
    NativeChildProcess_Fd *current = args->fdList.head;
    while (current != nullptr) {
        char *fdName = current->fdName;
        int32_t fd = current->fd;
        current = current->next;
        // 业务逻辑..
    }
}

/**
 * 子进程的入口函数，实现子进程的业务逻辑
 * args是子进程的启动参数
 */
void Main(NativeChildProcess_Args args)
{
    // 业务逻辑..

    // 创建线程
    std::thread tObj(ThreadFunc);
}

} // extern "C"
// [End child_get_start_params_main]