/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start Cpp_NativeNodule_H]
// NativeModule.h
// 提供获取ArkUI在Native侧模块的封装接口
#ifndef NATIVEUIPAGESAMPLE_NATIVEMODULE_H
#define NATIVEUIPAGESAMPLE_NATIVEMODULE_H

#include "napi/native_api.h"
#include <arkui/native_node.h>
#include <cassert>

#include <arkui/native_interface.h>

namespace NativeModule {
    class NativeModuleInstance {
    public:
        static NativeModuleInstance *GetInstance()
        {
            static NativeModuleInstance instance;
            return &instance;
        }

        NativeModuleInstance();
        // 暴露给其他模块使用。
        ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI();

    private:
        ArkUI_NativeNodeAPI_1 *arkUINativeNodeApi_ = nullptr;
    };

} // namespace NativeModule

#endif // NATIVEUIPAGESAMPLE_NATIVEMODULE_H
// [End Cpp_NativeNodule_H]
