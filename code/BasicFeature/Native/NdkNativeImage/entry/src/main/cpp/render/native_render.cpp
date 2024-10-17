#include "native_render.h"
#include <common/common.h>
#include <cmath>
#include <poll.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <hilog/log.h>

OHNativeRender::~OHNativeRender()
{
    if (nativeWindow_ != nullptr) {
        (void)OH_NativeWindow_NativeObjectUnreference(nativeWindow_);
        nativeWindow_ = nullptr;
    }
}

bool OHNativeRender::SetSurfaceId(uint64_t surfaceId, uint64_t width, uint64_t height)
{
    if (nativeWindow_ != nullptr) {
        (void)OH_NativeWindow_NativeObjectUnreference(nativeWindow_);
        nativeWindow_ = nullptr;
    }

    // 保存宽度和高度
    width_ = width;
    height_ = height;

    // 从 SurfaceId 创建 NativeWindow
    int ret = OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId, &nativeWindow_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to create NativeWindow from SurfaceId.");
        return false;
    }
    (void)OH_NativeWindow_NativeObjectReference(nativeWindow_);

    // 设置缓冲区的大小等属性
    int32_t result = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_BUFFER_GEOMETRY,
        static_cast<int32_t>(width_), static_cast<int32_t>(height_));
    if (result != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to set buffer geometry.");
        return false;
    }

    // 如果需要，可以设置其他属性，例如格式、用法等
    // 示例：
    // (void)OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_USAGE, BUFFER_USAGE_CPU_READ | BUFFER_USAGE_CPU_WRITE);

    return true;
}

void OHNativeRender::RenderFrame()
{
    OHNativeWindowBuffer *buffer = nullptr;
    int releaseFenceFd = -1;
    int32_t result = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer, &releaseFenceFd);
    if (result != 0 || buffer == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to request buffer.");
        return;
    }

    int retCode = -1;
    uint32_t timeout = 3000;
    if (releaseFenceFd != -1) {
        struct pollfd pollfds = {0};
        pollfds.fd = releaseFenceFd;
        pollfds.events = POLLIN;
        do {
            retCode = poll(&pollfds, 1, timeout);
        } while (retCode == -1 && (errno == EINTR || errno == EAGAIN));
        close(releaseFenceFd); // 防止fd泄漏
    }
    
    BufferHandle *handle = OH_NativeWindow_GetBufferHandleFromNative(buffer);
    if (handle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to get buffer handle.");
        return;
    }

    // 使用 mmap 获取虚拟地址
    void *mappedAddr = mmap(nullptr, handle->size, PROT_READ | PROT_WRITE, MAP_SHARED, handle->fd, 0);
    if (mappedAddr == MAP_FAILED) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to mmap buffer.");
        return;
    }

    // 获取像素指针
    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr);

    // 调用封装的函数来绘制渐变
    DrawGradient(pixel, width_, height_);

    // 解除内存映射
    result = munmap(mappedAddr, handle->size);
    if (result == -1) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to munmap buffer.");
    }

    // 设置刷新区域
    Region region{nullptr, 0};
    // 提交给消费者
    result = OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer, -1, region);
    if (result != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to flush buffer.");
    }
}

void OHNativeRender::DrawGradient(uint32_t* pixel, uint64_t width, uint64_t height)
{
    // 引入时间变量，实现动态效果
    static double time = 0.0;
    time += 0.05; // 调整增量以控制动画速度

    // 计算动画偏移，用于控制渐变的位置
    double offset = (sin(time) + 1.0) / 2.0; // 范围从 0.0 到 1.0

    // 遍历每一个像素
    for (uint64_t y = 0; y < height; y++) {
        for (uint64_t x = 0; x < width; x++) {
            // 计算当前像素的归一化横坐标，范围从 0.0 到 1.0
            double normalizedX = static_cast<double>(x) / static_cast<double>(width - 1);

            // 计算颜色强度，随着时间偏移
            double intensity = fabs(normalizedX - offset);
            intensity = 1.0 - intensity * 2.0; // 调整范围，使渐变从 1.0 到 0.0，再回到 1.0
            if (intensity < 0.0) {
                intensity = 0.0;
            }

            // 计算颜色分量，使用灰度值
            uint8_t red = static_cast<uint8_t>(intensity * 255);
            uint8_t green = static_cast<uint8_t>(intensity * 255);
            uint8_t blue = static_cast<uint8_t>(intensity * 255);
            uint8_t alpha = 255;

            // 组合颜色值（RGBA）
            uint32_t color = (alpha << 24) | (red << 16) | (green << 8) | blue;

            // 写入像素
            *pixel++ = color;
        }
    }
}
