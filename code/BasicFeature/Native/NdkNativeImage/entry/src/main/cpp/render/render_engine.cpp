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

#include "render_engine.h"
#include <hilog/log.h>
#include <common/common.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <mutex>
#include <condition_variable>
#include <unistd.h>

namespace {
    constexpr int FRAME_RATE = 60;  // 目标帧率
    constexpr int NANOSECONDS_IN_A_SECOND = 1000000000;  // 一秒中的纳秒数
}

RenderEngine::RenderEngine(std::shared_ptr<ImageRender> imageRender, uint64_t width, uint64_t height, void *window)
    : imageRender_(std::move(imageRender)), width_(width), height_(height), window_(window)
{
    Start();
}

RenderEngine::~RenderEngine()
{
    Stop();
}

void RenderEngine::Start()
{
    if (running_) {
        return;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "start.");
    running_ = true;

    thread_ = std::thread([this]() {
        if (!imageRender_->InitEGL(reinterpret_cast<EGLNativeWindowType>(window_), width_, height_)) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to initialize EGL");
            return;
        }
        if (!InitNativeVsync()) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to initialize VSync");
            return;
        }
        if (!CreateNativeImage()) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to create Native Image");
            return;
        }
        if (!StartNativeRenderThread()) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to start NativeRender thread");
            return;
        }
        MainLoop();
        CleanupResources();
    });
}

void RenderEngine::CleanupResources()
{
    StopNativeRenderThread();
    DestroyNativeImage();
    DestroyNativeVsync();
    imageRender_->Cleanup();
}

void RenderEngine::Stop()
{
    if (!running_) {
        return;
    }

    running_ = false;

    if (thread_.joinable()) {
        thread_.join();
    }

    CleanupResources();
}

void RenderEngine::UpdateNativeWindow(uint64_t width, uint64_t height)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "UpdateNativeWindow.");
    PostTask([this, width, height](std::shared_ptr<ImageRender> imageRender) {
        imageRender->UpdateWindowInfo(width, height);
        imageRender->UpdateViewport();
    });
}

void RenderEngine::MainLoop()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "MainLoop start.");

    threadId_ = std::this_thread::get_id();

    while (running_) {
        WaitForNewFrame();
        if (!isPaused_) {
            ExecuteRenderTasks();
            UpdateSurfaceImage();
        }
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "MainLoop end.");
}

void RenderEngine::WaitForNewFrame()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Waiting for new frame.");
    std::unique_lock<std::mutex> lock(frameMutex_);
    frameCond_.wait(lock, [this] { return availableFrameCnt_ > 0 || !running_; });
}

void RenderEngine::WaitForVsync()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Waiting for vsync.");
    std::unique_lock<std::mutex> lock(wakeUpMutex_);
    wakeUpCond_.wait(lock, [this]() { return wakeUp_ || vSyncCnt_ > 0; });
    wakeUp_ = false;
    if (vSyncCnt_ > 0) {
        vSyncCnt_--;
        (void)OH_NativeVSync_RequestFrame(nativeVsync_, &RenderEngine::OnVsync, this);
    }
}

void RenderEngine::OnVsync(long long timestamp, void *data)
{
    OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_PRINT_DOMAIN, "RenderEngine", "OnVsync %{public}lld.", timestamp);
    auto renderEngine = reinterpret_cast<RenderEngine *>(data);
    if (renderEngine == nullptr) {
        return;
    }

    renderEngine->vSyncCnt_++;
    renderEngine->wakeUpCond_.notify_one();
}

bool RenderEngine::InitNativeVsync()
{
    const char* demoName = "NativeImageSample";
    nativeVsync_ = OH_NativeVSync_Create(demoName, strlen(demoName));
    if (nativeVsync_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Create NativeVSync failed.");
        return false;
    }
    (void)OH_NativeVSync_RequestFrame(nativeVsync_, &RenderEngine::OnVsync, this);
    return true;
}

void RenderEngine::DestroyNativeVsync()
{
    if (nativeVsync_ != nullptr) {
        OH_NativeVSync_Destroy(nativeVsync_);
        nativeVsync_ = nullptr;
    }
}

void RenderEngine::ExecuteRenderTasks()
{
    std::vector<RenderTask> tasks;
    {
        std::lock_guard<std::mutex> lock(taskMutex_);
        tasks.swap(tasks_);
    }
    for (const auto &task : tasks) {
        task(imageRender_);
    }
}

void RenderEngine::UpdateSurfaceImage()
{
    if (availableFrameCnt_ <= 0) {
        return;
    }

    if (!nativeImage_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Native Image is null");
        return;
    }

    int32_t ret = OH_NativeImage_UpdateSurfaceImage(nativeImage_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "OH_NativeImage_UpdateSurfaceImage failed, ret: %{public}d, texId: %{public}u",
                     ret, nativeImageTexId_);
        return;
    }

    UpdateTextureMatrix();
    if (imageRender_) {
        imageRender_->Render();
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "ImageRender is null");
    }
    availableFrameCnt_--;
}

void RenderEngine::UpdateTextureMatrix()
{
    float matrix[16];
    int32_t ret = OH_NativeImage_GetTransformMatrixV2(nativeImage_, matrix);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "OH_NativeImage_GetTransformMatrix failed, ret: %{public}d", ret);
        return;
    }
    imageRender_->SetTransformMatrix(matrix);
}

bool RenderEngine::CreateNativeImage()
{
    if (!GenerateTexture() || !CreateNativeImageObject() || !AttachContextAndGetSurfaceId()) {
        return false;
    }

    if (!SetFrameAvailableListener()) {
        return false;
    }

    imageRender_->SetTexture(nativeImageTexId_, GL_TEXTURE_EXTERNAL_OES);

    return true;
}

bool RenderEngine::GenerateTexture()
{
    glGenTextures(1, &nativeImageTexId_);
    glBindTexture(GL_TEXTURE_EXTERNAL_OES, nativeImageTexId_);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    return true;
}

bool RenderEngine::CreateNativeImageObject()
{
    nativeImage_ = OH_NativeImage_Create(nativeImageTexId_, GL_TEXTURE_EXTERNAL_OES);
    if (nativeImage_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to create Native Image");
        return false;
    }
    return true;
}

bool RenderEngine::AttachContextAndGetSurfaceId()
{
    int ret = OH_NativeImage_AttachContext(nativeImage_, nativeImageTexId_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "AttachContext failed for textureId: %{public}u, ret: %{public}d", nativeImageTexId_, ret);
        return false;
    }

    std::lock_guard<std::mutex> lock(nativeImageSurfaceIdMutex_);
    ret = OH_NativeImage_GetSurfaceId(nativeImage_, &nativeImageSurfaceId_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "OH_NativeImage_GetSurfaceId failed, ret: %{public}d", ret);
        return false;
    }
    return true;
}

bool RenderEngine::SetFrameAvailableListener()
{
    nativeImageFrameAvailableListener_.context = this;
    nativeImageFrameAvailableListener_.onFrameAvailable = &RenderEngine::OnNativeImageFrameAvailable;
    int ret = OH_NativeImage_SetOnFrameAvailableListener(nativeImage_, nativeImageFrameAvailableListener_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "OH_NativeImage_SetOnFrameAvailableListener failed, ret: %{public}d", ret);
        return false;
    }
    return true;
}

void RenderEngine::PostTask(const RenderTask &task)
{
    if (!running_) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_PRINT_DOMAIN, "RenderEngine",
            "PostTask failed: RenderEngine is not running");
        return;
    }

    {
        std::lock_guard<std::mutex> lock(taskMutex_);
        tasks_.push_back(task);
    }

    frameCond_.notify_one();
}

void RenderEngine::OnNativeImageFrameAvailable(void *data)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "OnNativeImageFrameAvailable.");
    auto renderEngine = reinterpret_cast<RenderEngine *>(data);
    if (renderEngine == nullptr) {
        return;
    }
    {
        std::lock_guard<std::mutex> lock(renderEngine->frameMutex_);
        renderEngine->availableFrameCnt_++;
    }
    renderEngine->frameCond_.notify_one();
}

void RenderEngine::DestroyNativeImage()
{
    if (nativeImageTexId_ != 0U) {
        glDeleteTextures(1, &nativeImageTexId_);
        nativeImageTexId_ = 0U;
    }

    if (nativeImage_ != nullptr) {
        (void)OH_NativeImage_UnsetOnFrameAvailableListener(nativeImage_);
        OH_NativeImage_Destroy(&nativeImage_);
        nativeImage_ = nullptr;
    }
}

bool RenderEngine::StartNativeRenderThread()
{
    if (!nativeRender_) {
        nativeRender_ = std::make_shared<OHNativeRender>();
    }

    {
        std::lock_guard<std::mutex> lock(nativeImageSurfaceIdMutex_);
        if (nativeImageSurfaceId_ == 0) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Invalid nativeImageSurfaceId_");
            return false;
        }

        if (!nativeRender_->SetSurfaceId(nativeImageSurfaceId_, width_, height_)) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                "RenderEngine", "Failed to set SurfaceId for NativeRender");
            return false;
        }
    }

    nativeRenderThread_ = std::thread([this]() {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Native Render Thread started");
        while (running_) {
            // 等待 VSync 信号
            WaitForVsync();
            if (!isPaused_ && nativeRender_) {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Rendering Frame");
                nativeRender_->RenderFrame();
            }
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Native Render Thread ended");
    });

    return true;
}

void RenderEngine::StopNativeRenderThread()
{
    if (nativeRenderThread_.joinable()) {
        nativeRenderThread_.join();
    }
}

void RenderEngine::OnSurfaceChanged(uint64_t width, uint64_t height)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine",
                 "Surface changed to %{public}llu x %{public}lu", width, height);

    UpdateNativeWindow(width, height);
}

void RenderEngine::OnAppResume()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "App resumed");
    isPaused_ = false;
}

void RenderEngine::OnAppPause()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "App paused");
    isPaused_ = true;
}
