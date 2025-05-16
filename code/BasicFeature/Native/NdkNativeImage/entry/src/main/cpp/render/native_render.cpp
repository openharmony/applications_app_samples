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
#include "native_render.h"
#include <common/common.h>
#include <algorithm>
#include <cmath>
#include <native_image/native_image.h>
#include <poll.h>
#include <unistd.h>
#include <cerrno>
#include <cstdint>
#include <hilog/log.h>

namespace {
    // 动画相关
    constexpr double ANIMATION_SPEED_INCREMENT = 0.6;   // 动画速度增量

    // 文件描述符和轮询相关
    constexpr int INVALID_FD = -1;                      // 无效的文件描述符 
    constexpr uint32_t POLL_TIMEOUT_MS = 3000;          // poll 超时时间（毫秒）
    constexpr nfds_t NUM_POLL_FDS = 1;                  // poll 的文件描述符数量
    constexpr int NO_FENCE = -1;                        // 无同步栅栏
    constexpr int MAX_RETRY = 3;                        // 最大重试次数

    // 返回状态码
    constexpr int SUCCESS = 0;                          // 成功返回码
    constexpr int FAILURE = -1;                         // 失败返回码

    // 颜色和像素相关
    constexpr uint8_t MAX_COLOR_VALUE = 255;            // 颜色分量的最大值
    constexpr int32_t BYTES_PER_PIXEL = 4;              // 每个像素的字节数

    // 颜色通道位移
    constexpr uint8_t ALPHA_SHIFT = 24;                 // Alpha 通道位移
    constexpr uint8_t RED_SHIFT = 16;                   // Red 通道位移
    constexpr uint8_t GREEN_SHIFT = 8;                  // Green 通道位移
    constexpr uint8_t BLUE_SHIFT = 0;                   // Blue 通道位移

    // 强度相关
    constexpr double MAX_INTENSITY = 1.0;               // 最大强度值
    constexpr double MIN_INTENSITY = 0.5;               // 最小强度值
    constexpr double INTENSITY_MULTIPLIER = 2.0;        // 强度乘数
    constexpr double INTENSITY_LIMIT = 1.0;             // 强度限制

    // 箭头绘制相关
    constexpr int ARROW_SIZE_DIVISOR = 2;               // 箭头大小的除数
    constexpr int STEM_WIDTH_DIVISOR = 6;               // 箭头柄宽度的除数
    constexpr int HEAD_WIDTH_DIVISOR = 2;               // 箭头头部宽度的除数
    constexpr int HEAD_LENGTH_DIVISOR = 3;              // 箭头头部长度的除数
    constexpr double HEAD_SLOPE_MULTIPLIER = 0.5;       // 箭头头部斜率的乘数
}

OHNativeRender::~OHNativeRender()
{
    if (nativeWindow_ != nullptr) {
        (void)OH_NativeWindow_NativeObjectUnreference(nativeWindow_);
        nativeWindow_ = nullptr;
    }
}

bool OHNativeRender::SetSurfaceWidthAndHeight(OH_NativeImage* image, uint64_t surfaceId, uint64_t width, uint64_t height)
{
    if (nativeWindow_ != nullptr) {
        (void)OH_NativeWindow_NativeObjectUnreference(nativeWindow_);
        nativeWindow_ = nullptr;
    }

    // 保存宽度和高度
    width_ = width;
    height_ = height;
    //方式一： 从 NativeImage 创建 NativeWindow
    nativeWindow_ = OH_NativeImage_AcquireNativeWindow(image);
    //方式二： 从 SurfaceId 创建 NativeWindow 
    int ret = OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId, &nativeWindow_);
    if (ret != SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender",
            "Failed to create NativeWindow from SurfaceId.");
        return false;
    }
    (void)OH_NativeWindow_NativeObjectReference(nativeWindow_);

    // 设置缓冲区的大小等属性
    int32_t result = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_BUFFER_GEOMETRY,
        static_cast<int32_t>(width_), static_cast<int32_t>(height_));
    if (result != SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to set buffer geometry.");
        return false;
    }

    return true;
}

void OHNativeRender::RenderFrame()
{
    OHNativeWindowBuffer *buffer = nullptr;
    int releaseFenceFd = INVALID_FD;
    int32_t result = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer, &releaseFenceFd);
    if (result != SUCCESS || buffer == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                     "OHNativeRender", "Failed to request buffer, ret : %{public}d.", result);
        return;
    }

    int retCode = FAILURE;
    uint32_t timeout = POLL_TIMEOUT_MS;
    if (releaseFenceFd != INVALID_FD) {
        struct pollfd pollfds = {};
        pollfds.fd = releaseFenceFd;
        pollfds.events = POLLIN;

        int retryCount = 0;

        do {
            retCode = poll(&pollfds, NUM_POLL_FDS, POLL_TIMEOUT_MS);
            retryCount++;

            // 超过最大重试次数则退出
            if (retryCount >= MAX_RETRY) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                    "OHNativeRender", "Poll reached maximum retry count.");
                break;
            }
        } while (retCode == FAILURE && (errno == EINTR || errno == EAGAIN));

        close(releaseFenceFd);
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
    DrawGradient(pixel, handle->stride / BYTES_PER_PIXEL, height_);

    // 解除内存映射
    result = munmap(mappedAddr, handle->size);
    if (result == FAILURE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "OHNativeRender", "Failed to munmap buffer.");
    }

    std::lock_guard<std::mutex> lock(mutex_);
    // 设置刷新区域
    Region region{nullptr, 0};
    // 提交给消费者
    result = OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer, NO_FENCE, region);
    if (result != SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                     "OHNativeRender", "Failed to flush buffer, result : %{public}d.", result);
    }
}

void OHNativeRender::DrawGradient(uint32_t* pixel, uint64_t width, uint64_t height)
{
    static double time = 0.0;
    time += ANIMATION_SPEED_INCREMENT;
    double offset = (sin(time) + MAX_INTENSITY) / INTENSITY_MULTIPLIER;

    // 箭头参数
    const int arrowSize = std::min(width, height) / ARROW_SIZE_DIVISOR;
    const int arrowX = width / ARROW_SIZE_DIVISOR;
    const int arrowY = height / ARROW_SIZE_DIVISOR;
    const int stemWidth = arrowSize / STEM_WIDTH_DIVISOR;
    const int headWidth = arrowSize / HEAD_WIDTH_DIVISOR;
    const int headLength = arrowSize / HEAD_LENGTH_DIVISOR;
    const int stemStart = arrowX - arrowSize / ARROW_SIZE_DIVISOR;
    const int stemEnd = arrowX + arrowSize / ARROW_SIZE_DIVISOR - headLength;

    for (uint64_t y = 0; y < height; y++) {
        for (uint64_t x = 0; x < width; x++) {
            double normalizedX = static_cast<double>(x) / static_cast<double>(width - 1);
            bool isArrow = false;

            if ((x >= stemStart && x <= stemEnd && y >= arrowY - stemWidth * HEAD_SLOPE_MULTIPLIER &&
                y <= arrowY + stemWidth * HEAD_SLOPE_MULTIPLIER) || (x >= stemEnd && x <= stemEnd + headLength &&
                fabs(static_cast<int>(y - arrowY)) <= (headWidth * HEAD_SLOPE_MULTIPLIER) *
                (1.0 - static_cast<double>(x - stemEnd) / headLength))) {
                isArrow = true;
            }

            uint8_t red = static_cast<uint8_t>((1.0 - normalizedX) * MAX_COLOR_VALUE);
            uint8_t blue = static_cast<uint8_t>(normalizedX * MAX_COLOR_VALUE);
            uint8_t green = 0;
            uint8_t alpha = MAX_COLOR_VALUE;
            if (isArrow) {
                red = green = blue = MAX_COLOR_VALUE;
            }
            double intensity = fabs(normalizedX - offset);
            intensity = MAX_INTENSITY - std::min(INTENSITY_MULTIPLIER * intensity, INTENSITY_LIMIT);
            intensity = std::max(intensity, MIN_INTENSITY);

            red = static_cast<uint8_t>(red * intensity);
            green = static_cast<uint8_t>(green * intensity);
            blue = static_cast<uint8_t>(blue * intensity);

            *pixel++ = (static_cast<uint32_t>(alpha) << ALPHA_SHIFT) | (static_cast<uint32_t>(red) << RED_SHIFT) |
                (static_cast<uint32_t>(green) << GREEN_SHIFT) | (static_cast<uint32_t>(blue) << BLUE_SHIFT);
        }
    }
}