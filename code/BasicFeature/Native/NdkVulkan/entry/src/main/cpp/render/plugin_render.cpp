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

#include "plugin_render.h"
#include "logger_common.h"
#include <string>

std::unordered_map<std::string, PluginRender *> PluginRender::instance_;
OH_NativeXComponent_Callback PluginRender::callback_;
bool PluginRender::isTriangleRotational_ = true;
std::mutex PluginRender::mutex_;
std::condition_variable PluginRender::con_;

static std::string GetXComponentId(OH_NativeXComponent *component)
{
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    int32_t ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return std::string();
    }
    return std::string(idStr);
}

// Called when surface is created. CB means callback.
void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    std::string id = GetXComponentId(component);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceCreated(component, window);
}

// Called when surface is changed. CB means callback.
void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
    std::string id = GetXComponentId(component);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceChanged(component, window);
}

// Called when surface is destroyed. CB means callback.
void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    std::string id = GetXComponentId(component);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceDestroyed(component, window);
}

// Called when touch event is triggered. CB means callback.
void DispatchTouchEventCB(OH_NativeXComponent *component, void *window)
{
    std::string id = GetXComponentId(component);
    auto render = PluginRender::GetInstance(id);
    render->DispatchTouchEvent(component, window);
}

/* ------------------------------------------------------------------------------ */

PluginRender::PluginRender(std::string &id) : id_(id), component_(nullptr)
{
    auto renderCallback = PluginRender::GetNXComponentCallback();
    renderCallback->OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback->OnSurfaceChanged = OnSurfaceChangedCB;
    renderCallback->OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    renderCallback->DispatchTouchEvent = DispatchTouchEventCB;
}

PluginRender::~PluginRender()
{
    delete instance_[id_];
    instance_.erase(id_);
}

PluginRender *PluginRender::GetInstance(std::string &id)
{
    if (instance_.find(id) == instance_.end()) {
        PluginRender *instance = new PluginRender(id);
        instance_[id] = instance;
    }
    return instance_[id];
}

void PluginRender::SetNativeXComponent(OH_NativeXComponent *component)
{
    component_ = component;
    OH_NativeXComponent_RegisterCallback(component_, &PluginRender::callback_);
}

// Change the status of the triangle (rotational or still).
napi_value PluginRender::NapiStopMovingOrRestart(napi_env env, napi_callback_info info)
{
    LOGI("Call NapiStopMovingOrRestart!");
    std::unique_lock<std::mutex> locker(mutex_);
    isTriangleRotational_ = !isTriangleRotational_;
    con_.notify_all();
    return nullptr;
}

// export nativeFuc "stopOrStart" to js/ts
napi_value PluginRender::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "stopOrStart", nullptr, PluginRender::NapiStopMovingOrRestart, nullptr, nullptr, nullptr,
            napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}

OH_NativeXComponent_Callback *PluginRender::GetNXComponentCallback()
{
    return &PluginRender::callback_;
}

void PluginRender::RenderThread()
{
    while (vulkanExample_ != nullptr && vulkanExample_->IsInited()) {
        std::unique_lock<std::mutex> locker(mutex_);
        if (isTriangleRotational_) {
            vulkanExample_->RenderLoop();
        } else {
            con_.wait(locker);
        }
    }
}

// Init Vulkan backend when surface is created.
void PluginRender::OnSurfaceCreated(OH_NativeXComponent *component, void *window)
{
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (vulkanExample_ == nullptr) {
        vulkanExample_ = std::make_unique<vkExample::VulkanExample>();
        vulkanExample_->SetupWindow(static_cast<OHNativeWindow *>(window));
        if (!vulkanExample_->InitVulkan()) {
            LOGE("PluginRender::OnSurfaceCreated vulkanExample initVulkan failed!");
            return;
        }
        vulkanExample_->SetUp();
        renderThread_ = std::thread(std::bind(&PluginRender::RenderThread, this));
    }
}

void PluginRender::OnSurfaceChanged(OH_NativeXComponent *component, void *window)
{
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (vulkanExample_ == nullptr) {
        OnSurfaceCreated(component, window);
    } else {
        vulkanExample_->SetRecreateSwapChain();
    }
    LOGD("PluginRender::OnSurfaceChanged ret is %{public}d, w:%{public}lu, d:%{public}lu", ret, width_, height_);
}

void PluginRender::OnSurfaceDestroyed(OH_NativeXComponent *component, void *window)
{
    LOGD("PluginRender::OnSurfaceDestroyed is called!");
}

void PluginRender::DispatchTouchEvent(OH_NativeXComponent *component, void *window)
{
    int32_t ret = OH_NativeXComponent_GetTouchEvent(component, window, &touchEvent_);
    LOGD("PluginRender::DispatchTouchEvent is called!");
}
