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
// [Start Cpp_NativeModule]
// NativeModule.cpp
// 提供获取ArkUI在Native侧模块的封装接口

#include "NativeModule.h"

namespace NativeModule {
    NativeModuleInstance::NativeModuleInstance()
    {
        // 获取接口的函数指针结构体对象，用于后续接口调用。
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, arkUINativeNodeApi_);
        // 上下两种获取方式相同，均为获取接口的函数指针结构体对象，用于后续接口调用。
        arkUINativeNodeApi_ = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    }

    ArkUI_NativeNodeAPI_1 *NativeModuleInstance::GetNativeNodeAPI()
    {
        return arkUINativeNodeApi_;
    }

} // namespace NativeModule
// [End Cpp_NativeModule]
