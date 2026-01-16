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
// NativeEntry.h
#ifndef MYAPPLICATION_NATIVEENTRY_H
#define MYAPPLICATION_NATIVEENTRY_H

#include <ArkUIBaseNode.h>
#include <arkui/native_type.h>
#include <js_native_api_types.h>

namespace NativeModule {
    napi_value CreateNodeExample(napi_env env, napi_callback_info info);
    napi_value DisposeNodeTree(napi_env env, napi_callback_info info);

    const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
    // 管理Native组件的生命周期和内存。
    class NativeEntry {
    public:
        static NativeEntry *GetInstance()
        {
            static NativeEntry nativeEntry;
            return &nativeEntry;
        }

    private:
        // 管理生成的元素，通过map来查找nodeHandle和对应的BaseNode。
        std::unordered_map<ArkUI_NodeHandle, std::shared_ptr<ArkUIBaseNode>> nodes_;
    };

} // namespace NativeModule

#endif // MYAPPLICATION_NATIVEENTRY_H