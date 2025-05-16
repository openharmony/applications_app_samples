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

#ifndef NATIVE_IMAGE_NATIVE_RENDER_H
#define NATIVE_IMAGE_NATIVE_RENDER_H
#include <native_window/external_window.h>
#include <native_buffer/native_buffer.h>
#include <native_image/native_image.h>
#include <sys/mman.h>
#include <mutex>

class OHNativeRender {
public:
    OHNativeRender() = default;
    ~OHNativeRender();

    bool SetSurfaceWidthAndHeight(OH_NativeImage* image, uint64_t surfaceId, uint64_t width, uint64_t height);
    void RenderFrame();

private:
    void DrawGradient(uint32_t* pixel, uint64_t width, uint64_t height);

    OHNativeWindow* nativeWindow_ = nullptr;
    std::mutex mutex_;
    uint64_t width_ = 0;
    uint64_t height_ = 0;
};
#endif // NATIVE_IMAGE_NATIVE_RENDER_H
