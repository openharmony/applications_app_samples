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

// [Start native_module_start]
// NativeModule.h
#ifndef MYAPPLICATION_NATIVEMODULE_H
#define MYAPPLICATION_NATIVEMODULE_H

#include <arkui/native_node.h>
#include <arkui/native_interface.h>
#include <cassert>

namespace NativeModule {
// [StartExclude native_module_start]
namespace {
void MultiThreadNodeApiExample()
{
// [Start multi_thread_node_api_start]
ArkUI_NativeNodeAPI_1 *multiThreadNodeAPI = nullptr;
// 获取多线程NDK接口集合。
OH_ArkUI_GetModuleInterface(ARKUI_MULTI_THREAD_NATIVE_NODE, ArkUI_NativeNodeAPI_1, multiThreadNodeAPI);

if (!multiThreadNodeAPI) {
  return;
}
// 调用集合中支持多线程的createNode接口创建UI组件。
auto node = multiThreadNodeAPI->createNode(ARKUI_NODE_COLUMN);
// [StartExclude multi_thread_node_api_start]
if (node) {
    multiThreadNodeAPI->disposeNode(node);
}
// [EndExclude multi_thread_node_api_start]
// [End multi_thread_node_api_start]
}
} // namespace
// [EndExclude native_module_start]

class NativeModuleInstance {
public:
    static NativeModuleInstance *GetInstance() {
        static NativeModuleInstance instance;
        return &instance;
    }

    NativeModuleInstance() {
        // 获取多线程NDK接口的函数指针结构体对象，用于后续操作。
        OH_ArkUI_GetModuleInterface(ARKUI_MULTI_THREAD_NATIVE_NODE, ArkUI_NativeNodeAPI_1, arkUINativeNodeApi_);
        assert(arkUINativeNodeApi_);
    }
    // 暴露给其他模块使用。
    ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI() { return arkUINativeNodeApi_; }

private:
    ArkUI_NativeNodeAPI_1 *arkUINativeNodeApi_ = nullptr;
};
} // namespace NativeModule

#endif // MYAPPLICATION_NATIVEMODULE_H
// [End native_module_start]
