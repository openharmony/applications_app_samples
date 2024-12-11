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

#ifndef RENDER_ENGINE_H
#define RENDER_ENGINE_H

#include <atomic>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>
#include <functional>
#include <condition_variable>

#include <GLES2/gl2.h>
#include <native_image/native_image.h>
#include <native_window/external_window.h>
#include <native_vsync/native_vsync.h>
#include "image_render.h"
#include "native_render.h"

class RenderEngine {
public:
    using RenderTask = std::function<void(std::shared_ptr<ImageRender> render)>;

    RenderEngine(std::shared_ptr<ImageRender> imageRender, uint64_t width, uint64_t height, void *window);
    ~RenderEngine();

    // 禁用拷贝和移动
    RenderEngine(const RenderEngine &other) = delete;
    RenderEngine &operator=(const RenderEngine &other) = delete;
    RenderEngine(RenderEngine &&other) = delete;
    RenderEngine &operator=(RenderEngine &&other) = delete;

    // 启动渲染引擎
    void Start();

    // 停止渲染引擎
    void Stop();

    // 发布任务到渲染线程
    void PostTask(const RenderTask &task);

    // 更新 NativeWindow
    void UpdateNativeWindow(uint64_t width, uint64_t height);
    void OnSurfaceChanged(uint64_t width, uint64_t height);
    void OnAppResume();
    void OnAppPause();
private:
    static void OnNativeImageFrameAvailable(void *data);
    // Vsync 相关
    bool InitNativeVsync();
    void DestroyNativeVsync();
    static void OnVsync(long long timestamp, void *data);
    
    // 主循环
    void MainLoop();

    // 渲染线程初始化
    void InitializeRendering();
    void CleanupResources();

    // 渲染流程任务
    void WaitForNewFrame();
    void WaitForVsync();
    void ExecuteRenderTasks();
    void UpdateSurfaceImage();
    void UpdateTextureMatrix();

    // 创建与销毁 NativeImage
    bool CreateNativeImage();
    bool StartNativeRenderThread();
    void StopNativeRenderThread();
    void DestroyNativeImage();

    bool GenerateTexture();
    bool CreateNativeImageObject();
    bool AttachContextAndGetSurfaceId();
    bool SetFrameAvailableListener();

    // NativeRender 相关
    std::shared_ptr<OHNativeRender> nativeRender_;
    std::thread nativeRenderThread_;

    // NativeImage 相关
    OH_OnFrameAvailableListener nativeImageFrameAvailableListener_{};
    OH_NativeImage *nativeImage_ = nullptr;
    GLuint nativeImageTexId_ = 0U;
    std::mutex nativeImageSurfaceIdMutex_;
    uint64_t nativeImageSurfaceId_ = 0;
    std::atomic<int> availableFrameCnt_{0};
    std::condition_variable frameCond_;
    std::mutex frameMutex_;

    // 渲染引擎运行状态
    std::atomic<bool> running_{false};
    std::thread thread_;
    std::thread::id threadId_;

    // 同步和任务队列
    std::mutex taskMutex_;
    std::vector<RenderTask> tasks_;
    mutable std::mutex wakeUpMutex_;
    std::condition_variable wakeUpCond_;
    bool wakeUp_ = false;
    std::atomic<int> vSyncCnt_{0};
    OH_NativeVSync *nativeVsync_ = nullptr;

    // 关联的 ImageRender 实例
    std::shared_ptr<ImageRender> imageRender_;
    void *window_ = nullptr;
    uint64_t width_ = 0;
    uint64_t height_ = 0;

    // 其他状态变量
    std::atomic<bool> isPaused_{false};
};

#endif // RENDER_ENGINE_H
