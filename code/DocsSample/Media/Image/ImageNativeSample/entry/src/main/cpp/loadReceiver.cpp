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
// [Start receiver_import]
#include <hilog/log.h>
#include "napi/native_api.h"
#include <string>
#include <multimedia/image_framework/image/image_native.h>
#include <multimedia/image_framework/image/image_receiver_native.h>

#include "ohcamera/camera.h"
#include "ohcamera/camera_input.h"
#include "ohcamera/capture_session.h"
#include "ohcamera/photo_output.h"
#include "ohcamera/preview_output.h"
#include "ohcamera/video_output.h"
#include "ohcamera/camera_manager.h"

#include <mutex>
#include <condition_variable>
// [End receiver_import]

// [Start receiver_defineConst]
#undef LOG_DOMAIN
#define LOG_DOMAIN 0x3200

#undef LOG_TAG
#define LOG_TAG "MY_TAG"

#define IMAGE_WIDTH 320
#define IMAGE_HEIGHT 480
#define IMAGE_CAPACITY 2
// [End receiver_defineConst]

// [Start define_receiverInstance]
static OH_ImageReceiverNative* g_receiver = nullptr;

static std::mutex g_mutex;
static std::condition_variable g_condVar;
static bool g_imageReady = false;
static OH_ImageNative* g_imageInfoResult = nullptr;
// [End define_receiverInstance]

// [Start receiver_utility]
// 处理napi返回值。
napi_value GetJsResultDemo(napi_env env, int result)
{
    napi_value resultNapi = nullptr;
    napi_create_int32(env, result, &resultNapi);
    return resultNapi;
}

// 将uint64_t转换为一个以null结尾的char数组。
std::unique_ptr<char[]> ConvertUint64ToCharTemp(uint64_t value)
{
    std::string strValue = std::to_string(value);
    auto charBuffer = std::make_unique<char[]>(strValue.size() + 1);
    std::copy(strValue.begin(), strValue.end(), charBuffer.get());
    charBuffer[strValue.size()] = '\0';

    return charBuffer;
}
// [End receiver_utility]

// 初始化Receiver。
// [Start set_receiverOptions]
static Image_ErrorCode CreateAndConfigOptions(OH_ImageReceiverOptions** options)
{
    Image_ErrorCode errCode = OH_ImageReceiverOptions_Create(options);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create image receiver options failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    Image_Size imgSize = {IMAGE_WIDTH, IMAGE_HEIGHT};
    errCode = OH_ImageReceiverOptions_SetSize(*options, imgSize);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set image receiver options size failed, errCode: %{public}d.", errCode);
        OH_ImageReceiverOptions_Release(*options);
        return errCode;
    }
    errCode = OH_ImageReceiverOptions_SetCapacity(*options, IMAGE_CAPACITY);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set image receiver options capacity failed, errCode: %{public}d.", errCode);
        OH_ImageReceiverOptions_Release(*options);
        return errCode;
    }
    return IMAGE_SUCCESS;
}
// [End set_receiverOptions]

// [Start get_receiverOptions]
static Image_ErrorCode ValidateOptions(OH_ImageReceiverOptions* options)
{
    Image_Size imgSizeRead;
    Image_ErrorCode errCode = OH_ImageReceiverOptions_GetSize(options, &imgSizeRead);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver options size failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    if (imgSizeRead.width != IMAGE_WIDTH || imgSizeRead.height != IMAGE_HEIGHT) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver options size failed,"
                     "width: %{public}d, height: %{public}d.", imgSizeRead.width, imgSizeRead.height);
        return IMAGE_BAD_PARAMETER;
    }
    int32_t capacity = 0;
    errCode = OH_ImageReceiverOptions_GetCapacity(options, &capacity);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver options capacity failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    if (capacity != IMAGE_CAPACITY) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver options capacity failed, capacity: %{public}d.", capacity);
        return IMAGE_BAD_PARAMETER;
    }
    return IMAGE_SUCCESS;
}
// [End get_receiverOptions]

// [Start create_receiver]
static Image_ErrorCode CreateReceiver(OH_ImageReceiverOptions* options, OH_ImageReceiverNative** receiver)
{
    Image_ErrorCode errCode = OH_ImageReceiverNative_Create(options, receiver);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create image receiver failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    return IMAGE_SUCCESS;
}
// [End create_receiver]

// [Start define_callback]
static void OnCallback(OH_ImageReceiverNative* receiver)
{
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest buffer available.");

    OH_ImageNative* image = nullptr;
    Image_ErrorCode errCode = OH_ImageReceiverNative_ReadNextImage(receiver, &image);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ImageReceiverNativeCTest get image receiver next image failed,"
                     "errCode: %{public}d.", errCode);
        OH_ImageNative_Release(image);
        return;
    }

    {
        std::lock_guard<std::mutex> lock(g_mutex);
        g_imageInfoResult = image;
        g_imageReady = true;
    }
    g_condVar.notify_one();
}
// [End define_callback]

// [Start register_callback]
static Image_ErrorCode RegisterCallbackAndQuery(OH_ImageReceiverNative* receiver)
{
    uint64_t surfaceID = 0;
    Image_ErrorCode errCode = OH_ImageReceiverNative_On(receiver, OnCallback);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Image receiver on failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    errCode = OH_ImageReceiverNative_GetReceivingSurfaceId(receiver, &surfaceID);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver surfaceID failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    OH_LOG_INFO(LOG_APP, "Get image receiver surfaceID: %{public}lu.", surfaceID);
    Image_Size imgSizeRead;
    errCode = OH_ImageReceiverNative_GetSize(receiver, &imgSizeRead);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver size failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    OH_LOG_INFO(LOG_APP, "Get image receiver size: width = %{public}d, height = %{public}d.",
                imgSizeRead.width, imgSizeRead.height);
    int32_t capacity = 0;
    errCode = OH_ImageReceiverNative_GetCapacity(receiver, &capacity);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get image receiver capacity failed, errCode: %{public}d.", errCode);
        return errCode;
    }
    OH_LOG_INFO(LOG_APP, "Get image receiver capacity: %{public}d.", capacity);
    return IMAGE_SUCCESS;
}
// [End register_callback]

// [Start init_receiver]
static napi_value ImageReceiverNativeCTest(napi_env env, napi_callback_info info)
{
    if (g_receiver != nullptr) {
        OH_ImageReceiverNative_Off(g_receiver);
        OH_ImageReceiverNative_Release(g_receiver);
        g_receiver = nullptr;
    }

    OH_ImageReceiverOptions* options = nullptr;
    Image_ErrorCode errCode = CreateAndConfigOptions(&options);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "CreateAndConfigOptions failed errCode=%{public}d", errCode);
        return GetJsResultDemo(env, errCode);
    }
    errCode = ValidateOptions(options);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ValidateOptions failed errCode=%{public}d", errCode);
        OH_ImageReceiverOptions_Release(options);
        return GetJsResultDemo(env, errCode);
    }
    errCode = CreateReceiver(options, &g_receiver);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "CreateReceiver failed errCode=%{public}d", errCode);
        OH_ImageReceiverOptions_Release(options);
        return GetJsResultDemo(env, errCode);
    }
    errCode = RegisterCallbackAndQuery(g_receiver);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "RegisterCallbackAndQuery failed errCode=%{public}d", errCode);
        OH_ImageReceiverOptions_Release(options);
        OH_ImageReceiverNative_Release(g_receiver);
        g_receiver = nullptr;
        return GetJsResultDemo(env, errCode);
    }
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest create and config success.");
    OH_ImageReceiverOptions_Release(options);
    return GetJsResultDemo(env, IMAGE_SUCCESS);
}
// [End init_receiver]

// 启动拍照流。
// [Start init_camera]
Camera_ErrorCode InitCameraManagerAndInput(Camera_Manager*& cameraManager,
                                           Camera_Device*& cameras,
                                           uint32_t& size,
                                           Camera_Input*& cameraInput)
{
    cameraManager = nullptr;
    cameras = nullptr;
    size = 0;
    cameraInput = nullptr;
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager);
    if (cameraManager == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_Camera_GetCameraManager failed.");
        return ret;
    }
    ret = OH_CameraManager_GetSupportedCameras(cameraManager, &cameras, &size);
    if (cameras == nullptr || size < 1 || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_GetSupportedCameras failed.");
        return ret;
    }

    for (uint32_t i = 0; i < size; ++i) {
        OH_LOG_INFO(LOG_APP, "Camera[%{public}u]: id=%{public}s, position=%{public}d, type=%{public}d, "
            "connectionType=%{public}d", i, cameras[i].cameraId, cameras[i].cameraPosition, cameras[i].cameraType,
            cameras[i].connectionType);
    }

    ret = OH_CameraManager_CreateCameraInput(cameraManager, &cameras[0], &cameraInput);
    if (cameraInput == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_CreateCameraInput failed.ret:%{public}d", ret);
        return ret;
    }
    return CAMERA_OK;
}
// [End init_camera]

// [Start get_cameraOutCapability]
Camera_ErrorCode GetCameraOutputCapability(Camera_Manager* cameraManager,
                                           Camera_Device* cameras,
                                           uint32_t cameraDeviceIndex,
                                           Camera_OutputCapability*& capability)
{
    capability = nullptr;
    Camera_ErrorCode ret = OH_CameraManager_GetSupportedCameraOutputCapability(cameraManager,
                                                                               &cameras[cameraDeviceIndex],
                                                                               &capability);
    if (capability == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_GetSupportedCameraOutputCapability failed.");
    }
    return ret;
}
// [End get_cameraOutCapability]

// [Start create_captureSession]
Camera_CaptureSession* CreateAndStartSession(Camera_Manager* cameraManager, Camera_Input* cameraInput, int sessionMode)
{
    Camera_CaptureSession* captureSession = nullptr;
    Camera_ErrorCode ret = OH_CameraManager_CreateCaptureSession(cameraManager, &captureSession);
    if (captureSession == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_CreateCaptureSession failed.");
        return nullptr;
    }
    ret = OH_CaptureSession_SetSessionMode(captureSession, static_cast<Camera_SceneMode>(sessionMode));
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_SetSessionMode failed.");
        return nullptr;
    }
    ret = OH_CaptureSession_BeginConfig(captureSession);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_BeginConfig failed.");
        return nullptr;
    }
    ret = OH_CaptureSession_AddInput(captureSession, cameraInput);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddInput failed.");
        return nullptr;
    }
    return captureSession;
}
// [End create_captureSession]

// [Start start_captureSession]
static Camera_ErrorCode StartCaptureSession(Camera_Manager* mgr, Camera_Input* input, Camera_PhotoOutput* photoOutput,
    Camera_CaptureSession** sessionOut)
{
    *sessionOut = CreateAndStartSession(mgr, input, NORMAL_PHOTO);
    if (*sessionOut == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateAndStartSession failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    Camera_ErrorCode ret = OH_CaptureSession_AddPhotoOutput(*sessionOut, photoOutput);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddPhotoOutput failed.");
        return ret;
    }

    ret = OH_CaptureSession_CommitConfig(*sessionOut);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_CommitConfig failed.");
        return ret;
    }

    ret = OH_CaptureSession_Start(*sessionOut);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_Start failed.");
    }
    return ret;
}
// [End start_captureSession]

// [Start start_cameraSession]
Camera_ErrorCode StartTakePhoto(char* str)
{
    Camera_Manager* cameraManager = nullptr;
    Camera_Device* cameras = nullptr;
    uint32_t size = 0;
    Camera_Input* cameraInput = nullptr;
    Camera_ErrorCode ret = InitCameraManagerAndInput(cameraManager, cameras, size, cameraInput);
    if (ret != CAMERA_OK) return ret;

    Camera_OutputCapability* cameraOutputCapability = nullptr;
    ret = GetCameraOutputCapability(cameraManager, cameras, 0, cameraOutputCapability);
    if (ret != CAMERA_OK) return ret;
    const Camera_Profile* photoProfile = cameraOutputCapability->photoProfiles[0];
    Camera_PhotoOutput* photoOutput = nullptr;
    ret = OH_CameraManager_CreatePhotoOutput(cameraManager, photoProfile, str, &photoOutput);
    if (photoProfile == nullptr || photoOutput == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_CreatePhotoOutput failed.");
        return ret;
    }

    ret = OH_CameraInput_Open(cameraInput);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraInput_open failed.");
        return ret;
    }

    Camera_CaptureSession* captureSession = nullptr;
    ret = StartCaptureSession(cameraManager, cameraInput, photoOutput, &captureSession);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "StartCaptureSession failed.");
        return ret;
    }

    ret = OH_PhotoOutput_Capture(photoOutput);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_PhotoOutput_Capture failed.");
        return ret;
    }
    return CAMERA_OK;
}
// [End start_cameraSession]

// [Start load_cameraSession]
static napi_value TakePhoto(napi_env env, napi_callback_info info)
{
    if (g_receiver == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageReceiver not initialized.");
        return GetJsResultDemo(env, IMAGE_BAD_PARAMETER);
    }
    uint64_t surfaceId = 0;
    Image_ErrorCode errCode = OH_ImageReceiverNative_GetReceivingSurfaceId(g_receiver, &surfaceId);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get surfaceId failed.");
        return GetJsResultDemo(env, errCode);
    }

    auto surfaceId_c = ConvertUint64ToCharTemp(surfaceId);
    Camera_ErrorCode photoRet = StartTakePhoto(surfaceId_c.get());
    return GetJsResultDemo(env, photoRet);
}
// [End load_cameraSession]

// 获取接收到的图像信息。
// [Start wait_callBack]
// 同步等待。
static OH_ImageNative* NotifyJsImageInfoSync()
{
    std::unique_lock<std::mutex> lock(g_mutex);
    g_imageReady = false;
    g_imageInfoResult = nullptr;

    // 等待OnCallback回调通知。
    bool ret = g_condVar.wait_for(lock, std::chrono::seconds(1), [] {
        OH_LOG_INFO(LOG_APP, "NotifyJsImageInfoSync: wait_for wakeup, g_imageReady=%{public}d", g_imageReady);
        return g_imageReady;
    });
    if (!ret) {
        OH_LOG_ERROR(LOG_APP, "NotifyJsImageInfoSync: wait_for timeout.");
        return nullptr;
    }
    return g_imageInfoResult;
}
// [End wait_callBack]

// [Start get_imageSize]
// 获取图片大小。
static napi_value GetImageSizeInfo(napi_env env, OH_ImageNative* image)
{
    OH_LOG_INFO(LOG_APP, "GetImageSizeInfo: enter, image=%{public}p", image);

    Image_Size imgSizeRead;
    Image_ErrorCode errCode = OH_ImageNative_GetImageSize(image, &imgSizeRead);
    OH_LOG_INFO(LOG_APP, "GetImageSizeInfo: GetImageSize errCode=%{public}d, width=%{public}d, height=%{public}d",
                errCode, imgSizeRead.width, imgSizeRead.height);

    if (errCode == IMAGE_SUCCESS) {
        napi_value resultObj;
        napi_create_object(env, &resultObj);

        napi_value width;
        napi_value height;
        napi_create_int32(env, imgSizeRead.width, &width);
        napi_create_int32(env, imgSizeRead.height, &height);

        napi_set_named_property(env, resultObj, "width", width);
        napi_set_named_property(env, resultObj, "height", height);

        OH_LOG_INFO(LOG_APP, "GetImageSizeInfo: exit");
        return resultObj;
    }

    OH_LOG_ERROR(LOG_APP, "GetImageSizeInfo: Failed to get image size");
    return nullptr;
}
// [End get_imageSize]

// [Start get_componentType]
// 获取组件类型。
static size_t GetComponentTypeSize(OH_ImageNative* image, size_t& componentTypeSize)
{
    OH_LOG_INFO(LOG_APP, "GetComponentTypeSize: enter, image=%{public}p", image);
    // 获取组件类型的大小。
    Image_ErrorCode errCode = OH_ImageNative_GetComponentTypes(image, nullptr, &componentTypeSize);
    OH_LOG_INFO(LOG_APP, "GetComponentTypeSize: GetComponentTypes (query size) errCode=%{public}d,"
                "componentTypeSize=%{public}zu", errCode, componentTypeSize);
    return componentTypeSize;
}
// [End get_componentType]

// [Start get_componentInfo]
// 获取组件信息。
static napi_value GetComponentInfo(napi_env env, size_t componentTypeSize, OH_ImageNative* image, napi_value resultObj)
{
    if (componentTypeSize > 0) {
        uint32_t* components = new uint32_t[componentTypeSize];
        Image_ErrorCode errCode = OH_ImageNative_GetComponentTypes(image, &components, &componentTypeSize);
        OH_LOG_INFO(LOG_APP, "GetImageInfoObject: GetComponentTypes (get types) errCode=%{public}d,"
                    "firstComponent=%{public}u", errCode, componentTypeSize > 0 ? components[0] : 0);
        if (errCode != IMAGE_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "GetImageInfoObject: GetComponentTypes (get types) failed");
            delete [] components;
            return resultObj;
        }
        
        OH_NativeBuffer* nativeBuffer = nullptr;
        errCode = OH_ImageNative_GetByteBuffer(image, components[0], &nativeBuffer);
        if (errCode == IMAGE_SUCCESS) {
            OH_LOG_INFO(LOG_APP, "Get native buffer success.");
        }
    
        size_t nativeBufferSize = 0;
        errCode = OH_ImageNative_GetBufferSize(image, components[0], &nativeBufferSize);
        OH_LOG_INFO(LOG_APP, "GetImageInfoObject: GetBufferSize errCode=%{public}d, nativeBufferSize=%{public}zu",
                    errCode, nativeBufferSize);
        if (errCode == IMAGE_SUCCESS) {
            napi_value bufSize;
            napi_create_int32(env, static_cast<int32_t>(nativeBufferSize), &bufSize);
            napi_set_named_property(env, resultObj, "bufferSize", bufSize);
        }
    
        int32_t rowStride = 0;
        errCode = OH_ImageNative_GetRowStride(image, components[0], &rowStride);
        OH_LOG_INFO(LOG_APP, "GetImageInfoObject: GetRowStride errCode=%{public}d,"
                    "rowStride=%{public}d", errCode, rowStride);
        if (errCode == IMAGE_SUCCESS) {
            napi_value jsRowStride;
            napi_create_int32(env, rowStride, &jsRowStride);
            napi_set_named_property(env, resultObj, "rowStride", jsRowStride);
        }
    
        int32_t pixelStride = 0;
        errCode = OH_ImageNative_GetPixelStride(image, components[0], &pixelStride);
        OH_LOG_INFO(LOG_APP, "GetImageInfoObject: GetPixelStride errCode=%{public}d, pixelStride=%{public}d",
                    errCode, pixelStride);
        if (errCode == IMAGE_SUCCESS) {
            napi_value jsPixelStride;
            napi_create_int32(env, pixelStride, &jsPixelStride);
            napi_set_named_property(env, resultObj, "pixelStride", jsPixelStride);
        }
        delete [] components;
    }
    return resultObj;
}
// [End get_componentInfo]

// [Start get_imageInfo]
// 获取图像属性并封装为napi对象。
static napi_value GetImageInfoObject(napi_env env, OH_ImageNative* image)
{
    OH_LOG_INFO(LOG_APP, "GetImageInfoObject: enter, image=%{public}p", image);
    napi_value resultObj;
    napi_create_object(env, &resultObj);
    resultObj = GetImageSizeInfo(env, image);
    
    size_t componentTypeSize = 0;
    componentTypeSize = GetComponentTypeSize(image, componentTypeSize);
    if (componentTypeSize > 0) {
        resultObj = GetComponentInfo(env, componentTypeSize, image, resultObj);
    }

    int64_t timestamp = 0;
    Image_ErrorCode errCode = OH_ImageNative_GetTimestamp(image, &timestamp);
    OH_LOG_INFO(LOG_APP, "GetImageInfoObject: GetTimestamp errCode=%{public}d, timestamp=%{public}ld",
                errCode, timestamp);
    if (errCode == IMAGE_SUCCESS) {
        napi_value jsTimestamp;
        napi_create_int64(env, timestamp, &jsTimestamp);
        napi_set_named_property(env, resultObj, "timestamp", jsTimestamp);
    }

    OH_LOG_INFO(LOG_APP, "GetImageInfoObject: exit");
    return resultObj;
}
// [End get_imageInfo]

// [Start get_receiverImageInfo]
static napi_value GetReceiverImageInfo(napi_env env, napi_callback_info info)
{
    OH_ImageNative* image = NotifyJsImageInfoSync();
    if (!image) {
        napi_value undefined;
        napi_get_undefined(env, &undefined);
        return undefined;
    }
    napi_value resultObj = GetImageInfoObject(env, image);
    OH_ImageNative_Release(image);
    return resultObj;
}
// [End get_receiverImageInfo]

// 释放receiver。
// [Start release_receiver]
static napi_value ReleaseImageReceiver(napi_env env, napi_callback_info info)
{
    if (g_receiver == nullptr) {
        OH_LOG_INFO(LOG_APP, "No image receiver to release.");
        return nullptr;
    }
    Image_ErrorCode errCode = OH_ImageReceiverNative_Off(g_receiver);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ImageReceiverNativeCTest image receiver off failed, errCode: %{public}d.", errCode);
    }
    errCode = OH_ImageReceiverNative_Release(g_receiver);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Release image receiver failed, errCode: %{public}d.", errCode);
    }
    g_receiver = nullptr;

    return GetJsResultDemo(env, errCode);
}
// [End release_receiver]

EXTERN_C_START
napi_value InitReceiverDemo(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "initImageReceiver", nullptr, ImageReceiverNativeCTest, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePhoto", nullptr, TakePhoto, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getReceiverImageInfo", nullptr, GetReceiverImageInfo, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseImageReceiver", nullptr, ReleaseImageReceiver, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END