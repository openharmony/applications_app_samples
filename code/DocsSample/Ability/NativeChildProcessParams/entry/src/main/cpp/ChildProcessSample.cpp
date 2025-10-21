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

// [Start child_process_necessary_export_impl]
// [Start create_native_child_param_header]
#include <AbilityKit/native_child_process.h>
// [End create_native_child_param_header]
extern "C" {

/**
 * 子进程的入口函数，实现子进程的业务逻辑
 * 函数名称可以自定义，在主进程调用OH_Ability_StartNativeChildProcess方法时指定，此示例中为Main
 * 函数返回后子进程退出
 */
void Main(NativeChildProcess_Args args)
{
    // 获取传入的entryPrams
    char *entryParams = args.entryParams;
    // 获取传入的fd列表
    NativeChildProcess_Fd *current = args.fdList.head;
    while (current != nullptr) {
        char *fdName = current->fdName;
        int32_t fd = current->fd;
        current = current->next;
        // 业务逻辑..
    }
}
} // extern "C"
// [End child_process_necessary_export_impl]