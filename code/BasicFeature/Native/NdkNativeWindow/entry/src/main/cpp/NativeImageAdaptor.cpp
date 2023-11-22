/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "NativeImageAdaptor.h"
#include "logger_common.h"

namespace NativeWindowSample {
using GetPlatformDisplayExt = PFNEGLGETPLATFORMDISPLAYEXTPROC;
constexpr const char *EGL_EXT_PLATFORM_WAYLAND = "EGL_EXT_platform_wayland";
constexpr const char *EGL_KHR_PLATFORM_WAYLAND = "EGL_KHR_platform_wayland";
constexpr int32_t EGL_CONTEXT_CLIENT_VERSION_NUM = 2;
constexpr char CHARACTER_WHITESPACE = ' ';
constexpr const char *CHARACTER_STRING_WHITESPACE = " ";
constexpr const char *EGL_GET_PLATFORM_DISPLAY_EXT = "eglGetPlatformDisplayEXT";
NativeImageAdaptor *NativeImageAdaptor::GetInstance()
{ 
    static NativeImageAdaptor imageAdaptor;
    return &imageAdaptor;
};

bool NativeImageAdaptor::CheckEglExtension(const char *extensions, const char *extension)
{
    // Check egl extension
    size_t extlen = strlen(extension);
    const char *end = extensions + strlen(extensions);

    while (extensions < end) {
        size_t n = 0;
        if (*extensions == CHARACTER_WHITESPACE) {
            extensions++;
            continue;
        }
        n = strcspn(extensions, CHARACTER_STRING_WHITESPACE);
        if (n == extlen && strncmp(extension, extensions, n) == 0) {
            return true;
        }
        extensions += n;
    }
    return false;
}

EGLDisplay NativeImageAdaptor::GetPlatformEglDisplay(EGLenum platform, void *native_display, const EGLint *attrib_list)
{
    static GetPlatformDisplayExt eglGetPlatformDisplayExt = NULL;
    if (!eglGetPlatformDisplayExt) {
        const char *extensions = eglQueryString(EGL_NO_DISPLAY, EGL_EXTENSIONS);
        if (extensions && (CheckEglExtension(extensions, EGL_EXT_PLATFORM_WAYLAND) ||
                           CheckEglExtension(extensions, EGL_KHR_PLATFORM_WAYLAND))) {
            eglGetPlatformDisplayExt = (GetPlatformDisplayExt)eglGetProcAddress(EGL_GET_PLATFORM_DISPLAY_EXT);
        }
    }

    if (eglGetPlatformDisplayExt) {
        return eglGetPlatformDisplayExt(platform, native_display, attrib_list);
    }

    return eglGetDisplay((EGLNativeDisplayType)native_display);
}

void NativeImageAdaptor::InitEGLEnv()
{
    LOGD("NativeImageAdaptor::InitEGLEnv begin");
    // Obtain the current display device
    eglDisplay_ = GetPlatformEglDisplay(EGL_PLATFORM_OHOS_KHR, EGL_DEFAULT_DISPLAY, NULL);
    if (eglDisplay_ == EGL_NO_DISPLAY) {
        LOGE("NativeImageAdaptor::InitEGLEnv fail");
    }

    EGLint major, minor;
    // Initialize EGLDisplay
    if (eglInitialize(eglDisplay_, &major, &minor) == EGL_FALSE) {
        LOGE("NativeImageAdaptor::eglInitialize fail");
    }
    // The API for binding graphic drawing is OpenGLES
    if (eglBindAPI(EGL_OPENGL_ES_API) == EGL_FALSE) {
        LOGE("eglBindAPI fail");
    }
    unsigned int ret;
    EGLint count;
    EGLint config_attribs[] = {EGL_SURFACE_TYPE, EGL_WINDOW_BIT, EGL_RED_SIZE, 8, EGL_GREEN_SIZE, 8, EGL_BLUE_SIZE,
                               8, EGL_ALPHA_SIZE, 8, EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_BIT, EGL_NONE};

    // Obtain a valid system configuration information
    ret = eglChooseConfig(eglDisplay_, config_attribs, &config_, 1, &count);
    if (!(ret && static_cast<unsigned int>(count) >= 1)) {
        LOGE("eglChooseConfig fail");
    }
    static const EGLint context_attribs[] = {EGL_CONTEXT_CLIENT_VERSION, EGL_CONTEXT_CLIENT_VERSION_NUM, EGL_NONE};
    eglContext_ = eglCreateContext(eglDisplay_, config_, EGL_NO_CONTEXT, context_attribs);
    if (eglContext_ == EGL_NO_CONTEXT) {
        LOGE("eglCreateContext fail");
    }
    // Associated Context
    eglMakeCurrent(eglDisplay_, EGL_NO_SURFACE, EGL_NO_SURFACE, eglContext_);
    LOGD("Create EGL context successfully");
}

bool NativeImageAdaptor::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"GetAvailableCount", nullptr, NativeImageAdaptor::GetAvailableCount, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"ProduceBuffer", nullptr, NativeImageAdaptor::NapiOnProduceBuffer, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);

    eglContext_ = EGL_NO_CONTEXT;
    eglDisplay_ = EGL_NO_DISPLAY;
    availableBufferCount_ = 0;
    // Creating OpenGL textures
    InitEGLEnv();
    GLuint textureId;
    glGenTextures(1, &textureId);
    // Create a NativeImage instance and associate it with OpenGL textures
    image_ = OH_NativeImage_Create(textureId, GL_TEXTURE_2D);
    // Obtain Producer NativeWindow
    nativeWindow_ = OH_NativeImage_AcquireNativeWindow(image_);

    int code = SET_BUFFER_GEOMETRY;
    width_ = 0x100;
    height_ = 0x100;
    int32_t ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, code, width_, height_);
    if (ret != 0) {
        LOGE("NativeImageAdaptor OH_NativeWindow_NativeWindowHandleOpt fail");
    }

    code = SET_USAGE;
    int32_t usage = NATIVEBUFFER_USAGE_CPU_READ | NATIVEBUFFER_USAGE_CPU_WRITE | NATIVEBUFFER_USAGE_MEM_DMA;
    ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, code, usage);

    OH_OnFrameAvailableListener listener;
    listener.context = static_cast<void*>(image_);
    listener.onFrameAvailable = NativeImageAdaptor::OnFrameAvailable;
    ret = OH_NativeImage_SetOnFrameAvailableListener(image_, listener);

    uint64_t surfaceId;
    ret = OH_NativeImage_GetSurfaceId(image_, &surfaceId);
    if (ret != 0) {
        LOGE("OH_NativeImage_GetSurfaceId fail");
    }
    return true;
}

napi_value NativeImageAdaptor::NapiOnProduceBuffer(napi_env env, napi_callback_info info)
{
    NativeImageAdaptor::GetInstance()->ProduceBuffer(0x00);
    return nullptr;
}

void NativeImageAdaptor::ProduceBuffer(uint32_t value)
{
    NativeWindowBuffer *buffer = nullptr;
    int fenceFd = -1;
    int ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer, &fenceFd);
    if (ret != 0) {
        LOGE("OH_NativeWindow_NativeWindowRequestBuffer fail");
        return;
    }
    
    BufferHandle *handle = OH_NativeWindow_GetBufferHandleFromNative(buffer);
    // Obtain the memory virtual address of bufferHandle using the system mmap interface
    void *mappedAddr = mmap(handle->virAddr, handle->size, PROT_READ | PROT_WRITE, MAP_SHARED, handle->fd, 0);
    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr);
    for (uint32_t x = 0; x < width_; x++) {
        for (uint32_t y = 0; y < height_; y++) {
            *pixel++ = value;
        }
    }
    // Remember to remove memory mapping after using memory
    int result = munmap(mappedAddr, handle->size);
    if (result == -1) {
        LOGE("munmap fail");
    }

    struct Region *region = new Region();
    struct Region::Rect *rect = new Region::Rect();
    rect->x = 0x100;
    rect->y = 0x100;
    rect->w = 0x100;
    rect->h = 0x100;
    region->rects = rect;
    ret = OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer, fenceFd, *region);
    if (ret != 0) {
        LOGE("OH_NativeWindow_NativeWindowFlushBuffer fail");
        return;
    }
    delete region;
}

void NativeImageAdaptor::OnFrameAvailable(void *context)
{
    NativeImageAdaptor::GetInstance()->DealCallback(context);
    return;
}

void NativeImageAdaptor::DealCallback(void *context)
{
    std::lock_guard<std::mutex> lockGuard(opMutex_);
    LOGD("NativeImageAdaptor success OnFrameAvailable, %{public}d", availableBufferCount_);
    availableBufferCount_++;
    int32_t ret = OH_NativeImage_UpdateSurfaceImage(image_);
    if (ret != 0) {
        LOGE("OH_NativeImage_UpdateSurfaceImage fail");
    }
    return;
}

int32_t NativeImageAdaptor::GetCount()
{
    std::lock_guard<std::mutex> lockGuard(opMutex_);
    return availableBufferCount_;
}

napi_value NativeImageAdaptor::GetAvailableCount(napi_env env, napi_callback_info info)
{
    napi_value val = nullptr;
    int32_t count = NativeImageAdaptor::GetInstance()->GetCount();
    (void)napi_create_int32(env, count, &val);
    return val;
}

NativeImageAdaptor::~NativeImageAdaptor()
{
    OH_NativeImage_UnsetOnFrameAvailableListener(image_);
    OH_NativeWindow_DestroyNativeWindow(nativeWindow_);
    OH_NativeImage_Destroy(&image_);
}
}