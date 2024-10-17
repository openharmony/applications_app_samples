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

    // 主循环
    void MainLoop();

    // 发布任务到渲染线程
    void PostTask(const RenderTask &task);

    // 更新 NativeWindow
    // @param width - NativeWindow width.
    // @param height - NativeWindow height.
    // @param window - NativeWindow created by XComponent
    void UpdateNativeWindow(uint64_t width, uint64_t height, void *window);

private:
    // 渲染引擎运行状态
    std::atomic<bool> running_{false};
    std::thread thread_;
    std::thread::id threadId_;

    // NativeImage 相关
    static void OnNativeImageFrameAvailable(void *data);
    OH_OnFrameAvailableListener nativeImageFrameAvailableListener_{};
    OH_NativeImage *nativeImage_ = nullptr;
    GLuint nativeImageTexId_ = 0U;
    mutable std::mutex nativeImageSurfaceIdMutex_;
    uint64_t nativeImageSurfaceId_ = 0;
    std::atomic<int> availableFrameCnt_{0};

    bool CreateNativeImage();
    void DestroyNativeImage();

    // Vsync 相关
    bool InitNativeVsync();
    void DestroyNativeVsync();
    OH_NativeVSync *nativeVsync_ = nullptr;
    static void OnVsync(long long timestamp, void *data);
    std::atomic<int> vSyncCnt_{0};

    // 同步和任务队列
    mutable std::mutex wakeUpMutex_;
    std::condition_variable wakeUpCond_;
    bool wakeUp_ = false;
    mutable std::mutex taskMutex_;
    std::vector<RenderTask> tasks_;

    // 关联的 ImageRender 实例
    std::shared_ptr<ImageRender> imageRender_;
    void *window_ = nullptr;
    uint64_t width_ = 0;
    uint64_t height_ = 0;

    std::shared_ptr<OHNativeRender> nativeRender_;
    std::thread nativeRenderThread_;
};

#endif // RENDER_ENGINE_H
