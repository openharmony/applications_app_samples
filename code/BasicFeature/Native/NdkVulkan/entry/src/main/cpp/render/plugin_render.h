/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#ifndef PLUGIN_RENDER_H
#define PLUGIN_RENDER_H

#include <string>
#include <unordered_map>
#include <napi/native_api.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include "vulkan_example.h"
#include <thread>
#include <condition_variable>

class PluginRender {
  public:
    explicit PluginRender(std::string &id);
    ~PluginRender();
    static PluginRender *GetInstance(std::string &id);
    static OH_NativeXComponent_Callback *GetNXComponentCallback();
    void SetNativeXComponent(OH_NativeXComponent *component);
    napi_value Export(napi_env env, napi_value exports);
    static napi_value NapiStopMovingOrRestart(napi_env env, napi_callback_info info);
    // Callback, called by ACE XComponent
    void OnSurfaceCreated(OH_NativeXComponent *component, void *window);
    void OnSurfaceChanged(OH_NativeXComponent *component, void *window);
    void OnSurfaceDestroyed(OH_NativeXComponent *component, void *window);
    void DispatchTouchEvent(OH_NativeXComponent *component, void *window);

private:
    void RenderThread();
    static std::unordered_map<std::string, PluginRender *> instance_;
    static OH_NativeXComponent_Callback callback_;
    static bool isTriangleRotational_;
    static std::mutex mutex_;
    static std::condition_variable con_;
    std::unique_ptr<vkExample::VulkanExample> vulkanExample_ = nullptr;

    std::string id_;
    OH_NativeXComponent *component_;
    OH_NativeXComponent_TouchEvent touchEvent_;
    uint64_t width_;
    uint64_t height_;
    std::thread renderThread_;
};

#endif // PLUGIN_RENDER_H
