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

#ifndef VIDEO_RENDER_VULKANRENDERTHREAD_H
#define VIDEO_RENDER_VULKANRENDERTHREAD_H

#include "VulkanRender.h"
#include <thread>
#include <vector>
#include <native_image/native_image.h>
#include <native_window/external_window.h>
#include <native_vsync/native_vsync.h>
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_ohos.h>

namespace NativeXComponentSample {
using VulkanRenderTask = std::function<void(VulkanRender &renderContext)>;
class VulkanRenderThread {
public:
    VulkanRenderThread();
    ~VulkanRenderThread() noexcept;

    // @param window - NativeWindow created by XComponent
    // @param width - NativeWindow width.
    // @param height - NativeWindow height.
    void UpdateNativeWindow(void *window, uint64_t width, uint64_t height);

    // disallow copy and move
    VulkanRenderThread(const VulkanRenderThread &other) = delete;
    void operator=(const VulkanRenderThread &other) = delete;
    VulkanRenderThread(VulkanRenderThread &&other) = delete;
    void operator=(VulkanRenderThread &&other) = delete;

    void PostTask(const VulkanRenderTask &task);
    OHNativeWindow* GetNativeImageWindow();

private:
    void Start();
    void ThreadMainLoop();
    
    std::atomic<bool> running_{false};
    std::thread thread_;
    std::thread::id threadId_;

    // Receive the Vsync signal sent by the system to control the track dyeing rhythm
    bool InitNativeVsync();
    void DestroyNativeVsync();
    OH_NativeVSync *nativeVsync_ = nullptr;
    static void OnVsync(long long timestamp, void *data);
    std::atomic<int> vSyncCnt_{0};
    mutable std::mutex wakeUpMutex_;
    std::condition_variable wakeUpCond_;
    bool wakeup_ = false;
    mutable std::mutex taskMutex_;
    std::vector<VulkanRenderTask> tasks_ ;

    // RenderContext initialization and cleaning
    bool InitRenderContext();
    std::unique_ptr<VulkanRender> vulkanRenderContext_;
    
    OHNativeWindow *nativeWindow_ = nullptr;
    
    bool CreateNativeImage();
    void DestroyNativeImage();
    void DrawImage();
    static void OnNativeImageFrameAvailable(void *data);
    OH_OnFrameAvailableListener nativeImageFrameAvailableListener_{};
    OH_NativeImage *nativeImage_ = nullptr;
    mutable std::mutex nativeImageSurfaceIdMutex_;
    std::condition_variable nativeImageSurfaceIdCond_;
    uint64_t nativeImageSurfaceId_ = 0;
    OHNativeWindow *nativeImageWindow_ = nullptr;
    std::atomic<int> availableFrameCnt_{0};

    float matrix_[16]; // 16 means 4 x 4
    OHNativeWindowBuffer *lastInBuffer_ = nullptr;
};
} // namespace NativeXComponentSample

#endif //VIDEO_RENDER_VULKANRENDERTHREAD_H
