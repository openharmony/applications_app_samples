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
#include <future>

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
        imageRender_->Update(width_, height_, reinterpret_cast<EGLNativeWindowType>(window_));
        MainLoop();
        // 确保资源在渲染线程中销毁
        DestroyNativeImage();
        UpdateNativeWindow(0, 0, nullptr);
        DestroyNativeVsync();
        imageRender_->Cleanup();
    });
}

void RenderEngine::Stop()
{
    if (!running_) {
        return;
    }

    // 停止渲染线程
    running_ = false;

    // 唤醒主渲染线程以便它能退出
    {
        std::lock_guard<std::mutex> lock(wakeUpMutex_);
        wakeUp_ = true;
    }
    wakeUpCond_.notify_one();

    // 等待主渲染线程结束
    if (thread_.joinable()) {
        thread_.join();
    }

    // 等待 nativeRenderThread_ 渲染线程结束
    if (nativeRenderThread_.joinable()) {
        nativeRenderThread_.join();
    }

    // 解绑 EGLImage 和 textureId
    OH_NativeImage_DetachContext(nativeImage_);
    
    // 销毁资源
    DestroyNativeImage();
    UpdateNativeWindow(0, 0, nullptr);
    DestroyNativeVsync();
    imageRender_->Cleanup();
}


void RenderEngine::UpdateNativeWindow(uint64_t width, uint64_t height, void *window)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "UpdateNativeWindow.");
    PostTask([this, window, width, height](std::shared_ptr<ImageRender> imageRender) {
        (void)OH_NativeWindow_NativeWindowHandleOpt(reinterpret_cast<OHNativeWindow*>(window), SET_BUFFER_GEOMETRY,
            static_cast<int>(width), static_cast<int>(height));
        imageRender->Update(width, height, reinterpret_cast<EGLNativeWindowType>(window));
        imageRender->InitEGL();
    });
}

void RenderEngine::MainLoop()
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "MainLoop start.");

    threadId_ = std::this_thread::get_id();
    if (!imageRender_->InitEGL()) {
        return;
    }
    if (!InitNativeVsync()) {
        return;
    }
    if (!CreateNativeImage()) {
        return;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "MainLoop ready.");
    while (running_) {
        {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Waiting for vsync.");
            std::unique_lock<std::mutex> lock(wakeUpMutex_);
            wakeUpCond_.wait(lock, [this]() { return wakeUp_ || vSyncCnt_ > 0 || availableFrameCnt_ > 0; });
            wakeUp_ = false;
            if (vSyncCnt_ > 0) {
                vSyncCnt_--;
                // 请求下一帧 VSync
                (void)OH_NativeVSync_RequestFrame(nativeVsync_, &RenderEngine::OnVsync, this);
            }
        }

        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "Executing tasks.");
        std::vector<RenderTask> tasks;
        {
            std::lock_guard<std::mutex> lock(taskMutex_);
            tasks.swap(tasks_);
        }
        for (const auto &task : tasks) {
            task(imageRender_);
        }

        int32_t ret;
        if (availableFrameCnt_ <= 0) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "No available frame.");
            continue;
        }

        ret = OH_NativeImage_UpdateSurfaceImage(nativeImage_);
        if (ret != 0) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                        "OH_NativeImage_UpdateSurfaceImage failed, ret: %{public}d, texId: %{public}u",
                        ret, nativeImageTexId_);
            continue;
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine",
                    "OH_NativeImage_UpdateSurfaceImage succeed.");

        // 如果需要更新纹理矩阵，可以在这里获取并传递给 ImageRender
        float matrix[16];
        ret = OH_NativeImage_GetTransformMatrixV2(nativeImage_, matrix);
        if (ret != 0) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                        "OH_NativeImage_GetTransformMatrix failed, ret: %d", ret);
            continue;
        }
        // 如果需要，将矩阵传递给 ImageRender
        // imageRender_->SetTransformMatrix(matrix);

        imageRender_->Render();
        availableFrameCnt_--;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "MainLoop end.");
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

    {
        std::lock_guard<std::mutex> lock(wakeUpMutex_);
        wakeUp_ = true;
    }
    wakeUpCond_.notify_one();
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
    const char* DEMO_NAME = "RenderEngineDemo";
    nativeVsync_ = OH_NativeVSync_Create(DEMO_NAME, strlen(DEMO_NAME));
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

void RenderEngine::OnNativeImageFrameAvailable(void *data)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "RenderEngine", "OnNativeImageFrameAvailable.");
    auto renderEngine = reinterpret_cast<RenderEngine *>(data);
    if (renderEngine == nullptr) {
        return;
    }
    renderEngine->availableFrameCnt_++;
    renderEngine->wakeUpCond_.notify_one();
}

bool RenderEngine::CreateNativeImage()
{
    glGenTextures(1, &nativeImageTexId_);
    glBindTexture(GL_TEXTURE_EXTERNAL_OES, nativeImageTexId_);
    // 设置纹理参数
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_EXTERNAL_OES, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    nativeImage_ = OH_NativeImage_Create(nativeImageTexId_, GL_TEXTURE_EXTERNAL_OES);
    if (nativeImage_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "OH_NativeImage_Create failed.");
        return false;
    }
    // 调用 AttachContext 绑定 textureId 到 EGL 图像
    int ret = OH_NativeImage_AttachContext(nativeImage_, nativeImageTexId_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "AttachContext failed for textureId: %{public}d", nativeImageTexId_);
        return false;
    }
    {
        std::lock_guard<std::mutex> lock(nativeImageSurfaceIdMutex_);
        ret = OH_NativeImage_GetSurfaceId(nativeImage_, &nativeImageSurfaceId_);
    }
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
            "OH_NativeImage_GetSurfaceId failed, ret is %{public}d.", ret);
        return false;
    }

    // 设置帧可用监听器
    nativeImageFrameAvailableListener_.context = this;
    nativeImageFrameAvailableListener_.onFrameAvailable = &RenderEngine::OnNativeImageFrameAvailable;
    ret = OH_NativeImage_SetOnFrameAvailableListener(nativeImage_, nativeImageFrameAvailableListener_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
                     "OH_NativeImage_SetOnFrameAvailableListener failed, ret is %{public}d.", ret);
        return false;
    }

    // 在 RenderEngine::CreateNativeImage() 中，获取 SurfaceId
    uint64_t surfaceId = 0;
    ret = OH_NativeImage_GetSurfaceId(nativeImage_, &surfaceId);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine",
            "OH_NativeImage_GetSurfaceId failed, ret is %{public}d.", ret);
        return false;
    }

    // 在 RenderEngine::CreateNativeImage() 中，创建 OHNativeRender 实例
    nativeRender_ = std::make_shared<OHNativeRender>();
    if (!nativeRender_->SetSurfaceId(surfaceId, width_, height_)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RenderEngine", "Failed to set SurfaceId for NativeRender.");
        return false;
    }

    // 将纹理 ID 和目标传递给 ImageRender
    imageRender_->SetTexture(nativeImageTexId_, GL_TEXTURE_EXTERNAL_OES);
    // 在 RenderEngine::CreateNativeImage() 中，启动生产者渲染
    nativeRenderThread_ = std::thread([this]() {
        while (running_) {
            nativeRender_->RenderFrame();
            // 控制渲染帧率，避免过高的 CPU 占用
            std::this_thread::sleep_for(std::chrono::nanoseconds(1000000000 / 120)); // 每帧约 8.33 毫秒
            
            // 如果 `running_` 被设置为 false，则线程应退出
            if (!running_) {
                break;
            }
        }
    });
    
    return true;
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
