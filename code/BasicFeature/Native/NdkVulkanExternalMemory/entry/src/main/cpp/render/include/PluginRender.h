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

#ifndef VULKAN_PLUGINRENDER_H
#define VULKAN_PLUGINRENDER_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <js_native_api.h>
#include <unordered_map>
#include "VulkanRenderThread.h"

namespace NativeXComponentSample {
class PluginRender {
public:
    explicit PluginRender(std::string &id);
    ~PluginRender() { Release(id_); }
    
    static PluginRender *GetInstance(std::string &id);
    static void Release(std::string &id);
    static napi_value StartPlayer(napi_env env, napi_callback_info info);
    static napi_value StopPlayer(napi_env env, napi_callback_info info);
    
    void OnSurfaceChanged(OH_NativeXComponent *component, void *window);
    void OnTouchEvent(OH_NativeXComponent *component, void *window);
    void OnFocusEvent(OH_NativeXComponent *component, void *window);
    void OnBlurEvent(OH_NativeXComponent *conponent, void *window);
    void RegisterCallback(OH_NativeXComponent *nativeXComponent);
    OHNativeWindow *nativeWindow;
public:
    static std::unordered_map<std::string, PluginRender *> instance_;
    std::string id_;
    static int32_t hasDraw_;
    static int32_t hasChangeColor_;
    std::unique_ptr<VulkanRenderThread> vulkanRenderThread_;

private:
    static PluginRender *GetPluginRender(napi_env env, napi_callback_info info);
    OH_NativeXComponent_Callback renderCallback_;
};
} // namespace NativeXComponentSample
#endif // VULKAN_PLUGINRENDER_H
