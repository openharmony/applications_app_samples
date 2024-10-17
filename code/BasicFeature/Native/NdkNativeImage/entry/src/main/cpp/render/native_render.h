//
// Created on 2024/10/11.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef NDK_NATIVE_IAMGE_NATIVE_RENDER_H
#define NDK_NATIVE_IAMGE_NATIVE_RENDER_H
#include <native_window/external_window.h>
#include <native_buffer/native_buffer.h>
#include <sys/mman.h>

class OHNativeRender {
public:
    OHNativeRender() = default;
    ~OHNativeRender();

    bool SetSurfaceId(uint64_t surfaceId, uint64_t width, uint64_t height);
    void RenderFrame();

private:
    void DrawGradient(uint32_t* pixel, uint64_t width, uint64_t height);
    
    OHNativeWindow* nativeWindow_ = nullptr;
    uint64_t width_ = 0;
    uint64_t height_ = 0;
};
#endif //NDK_NATIVE_IAMGE_NATIVE_RENDER_H
