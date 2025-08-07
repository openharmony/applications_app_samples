/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef NATIVEXCOMPONENT_PLUGIN_MANAGER_H
#define NATIVEXCOMPONENT_PLUGIN_MANAGER_H

#include "render/EGLRender.h"
#include <unordered_map>
#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <arkui/native_node.h>
#include <ace/xcomponent/native_interface_xcomponent.h>

namespace NativeXComponentSample {
constexpr const int FIRST_ARG = 1;
constexpr const int SECOND_ARG = 2;
constexpr const int THIRD_ARG = 3;
constexpr const int FRAME_COUNT = 50;
class PluginManager {
public:
    ~PluginManager();
    static napi_value BindNode(napi_env env, napi_callback_info info);
    static napi_value UnbindNode(napi_env env, napi_callback_info info);
    static napi_value SetFrameRate(napi_env env, napi_callback_info info);
    static napi_value SetNeedSoftKeyboard(napi_env env, napi_callback_info info);
    static napi_value Initialize(napi_env env, napi_callback_info info);
    static napi_value Finalize(napi_env env, napi_callback_info info);
    static napi_value DrawStar(napi_env env, napi_callback_info info);

public:
    static std::unordered_map<std::string, ArkUI_NodeHandle> nodeHandleMap_;
    static std::unordered_map<void *, OH_ArkUI_SurfaceCallback *> callbackMap_;
    static std::unordered_map<void *, OH_ArkUI_SurfaceHolder *> surfaceHolderMap_;
    static ArkUI_AccessibilityProvider *provider_;
};
} // namespace NativeXComponentSample
#endif // NATIVEXCOMPONENT_PLUGIN_MANAGER_H
