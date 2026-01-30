/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <string>
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include "napi/native_api.h"
#include "hilog/log.h"
#include <multimedia/image_framework/image/image_native.h>
#include <multimedia/image_framework/image/image_receiver_native.h>
#include "camera_manager.h"
#include <native_window/external_window.h>


#define LOG_TAG "NDK_CAMERA"
#define LOG_DOMAIN 0x3200
using namespace OHOS_CAMERA_NDK_SAMPLE;
static uint32_t g_imageWidth = 0;                  // 全局变量，存储相机使用的Profile图像宽数据
static uint32_t g_imageHeight = 0;                 // 全局变量，存储相机使用的Profile图像高数据
static std::string g_xComponentSurfaceId = "";      // 存储JS侧XComponentId主图
static std::string g_xComponentSurfaceIdSlave = ""; // 存储JS侧XComponentId主图
static uint32_t g_jpegComponent = 2000;
static NDKCamera *g_ndkCamera = nullptr;
bool g_isFirstBuffer = true;
const uint32_t ALIGNMENT = 16;
const int32_t ARGS_TWO = 2;
const int32_t ARGS_THREE = 3;
const int32_t ARGS_FOUR = 4;
const int32_t PREVIEW_HEIGHT = 1080;
const int32_t PREVIEW_WIDTH = 1920;
int32_t g_displayRotation = 0;
Camera_ImageRotation previewRotation = IAMGE_ROTATION_0;
bool g_isFront = false;

static napi_value ReleaseCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera Start");
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ReleaseCamera();
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

// [Start image_receiver]
void copyBuffer(OH_NativeBuffer *srcBuffer, size_t srcSize, OHNativeWindowBuffer *dstBuffer)
{
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest %{public}s IN", __func__);
    void *srcVir = nullptr;
    OH_NativeBuffer_Map(srcBuffer, &srcVir);
    BufferHandle *bufferHandle = OH_NativeWindow_GetBufferHandleFromNative(dstBuffer);
    OH_LOG_INFO(LOG_APP,
        "ImageReceiverNativeCTest %{public}s bufferHandle info fd= %{public}d , width= %{public}d, "
        "height=%{public}d, stride= %{public}d, size= %{public}d, format= %{public}d, usage= %{public}lu",
        __func__, bufferHandle->fd, bufferHandle->width, bufferHandle->height, bufferHandle->stride, bufferHandle->size,
        bufferHandle->format, bufferHandle->usage);

    void *mappedAddr =
        mmap(bufferHandle->virAddr, bufferHandle->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle->fd, 0);
    std::memcpy(static_cast<unsigned char *>(mappedAddr), static_cast<unsigned char *>(srcVir), srcSize);
    munmap(mappedAddr, bufferHandle->size);

    OH_NativeBuffer_Unmap(srcBuffer);
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest %{public}s SUCCESS", __func__);
}

void ShowImage(OH_ImageNative *image)
{
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest %{public}s IN", __func__);
    uint64_t xComponentSurfaceId = std::stoull(g_xComponentSurfaceIdSlave);
    OH_LOG_ERROR(LOG_APP, "ImageReceiverNativeCTest %{public}s XComponentId is : %{public}lu.", __func__,
        xComponentSurfaceId);
    OHNativeWindow *nativeWindow = nullptr;
    int32_t res = OH_NativeWindow_CreateNativeWindowFromSurfaceId(xComponentSurfaceId, &nativeWindow);
    if (res) {
        OH_LOG_ERROR(LOG_APP,
            "ShowImage CreateNativeWindowFromSurfaceId failed, errCode: %{public}d.", res);
        return;
    }

    // 关键：调整nativeWindow大小及format，需要与image的大小、format保持一致
    res = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_BUFFER_GEOMETRY, g_imageWidth, g_imageHeight);
    res = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_FORMAT, NATIVEBUFFER_PIXEL_FMT_YCRCB_420_SP); // NV21
    // 设置旋转角度，后置默认旋转90，则需要将nativeWindow旋转270度，前置默认270，则需要将nativeWindow旋转90度
    if (g_isFront) {
        res = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_TRANSFORM, NATIVEBUFFER_FLIP_V_ROT90);
    } else {
        res = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_TRANSFORM, NATIVEBUFFER_ROTATE_270);
    }

    OH_NativeBuffer *imageBuffer = nullptr;
    Image_ErrorCode errCode = OH_ImageNative_GetByteBuffer(image, g_jpegComponent, &imageBuffer);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ShowImage GetByteBuffer failed, errCode: %{public}d.", errCode);
        return;
    }
    Image_Size imgSize = {};
    OH_ImageNative_GetImageSize(image, &imgSize);
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest %{public}s imgSize is : %{public}u, %{public}u.", __func__,
        imgSize.width, imgSize.height);
    size_t bufSize = 0;
    OH_ImageNative_GetBufferSize(image, g_jpegComponent, &bufSize);

    OHNativeWindowBuffer *nativeWindowBuffer = nullptr;
    int fenceFd = -1;
    res = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow, &nativeWindowBuffer, &fenceFd);
    if (res) {
        OH_LOG_ERROR(LOG_APP, "ShowImage RequestBuffer failed, errCode: %{public}d.", res);
        return;
    }

    // 将image数据拷贝到nativeWindowBuffer上
    copyBuffer(imageBuffer, bufSize, nativeWindowBuffer);

    Region region1{};
    res = OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow, nativeWindowBuffer, fenceFd, region1);
    if (res) {
        OH_LOG_ERROR(LOG_APP, "ShowImage FlushBuffer failed, errCode: %{public}d.", res);
        return;
    }
    OH_LOG_INFO(LOG_APP, "ImageReceiverNativeCTest %{public}s SUCCESS", __func__);
}

static void CallbackReadNextImage(OH_ImageReceiverNative *receiver)
{
    OH_LOG_INFO(LOG_APP, "CallbackReadNextImage %{public}s IN", __func__);
    // 读取 OH_ImageReceiverNative 下一张图片对象
    OH_ImageNative *image = nullptr;
    Image_ErrorCode errCode = OH_ImageReceiverNative_ReadNextImage(receiver, &image);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP,
            "CallbackReadNextImage %{public}s get image receiver next image failed, errCode: %{public}d.", __func__,
            errCode);
        return;
    }

    ShowImage(image);

    // 释放 OH_ImageNative 实例
    errCode = OH_ImageNative_Release(image);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "CallbackReadNextImage %{public}s release image native failed, errCode: %{public}d.",
            __func__, errCode);
    }
    OH_LOG_INFO(LOG_APP, "CallbackReadNextImage %{public}s SUCCESS", __func__);
}
// [End image_receiver]

// [Start init_image_receiver]
void InitImageReceiver(uint64_t &receiverSurfaceID)
{
    OH_ImageReceiverOptions *options = nullptr;
    // 注意捕获错误码处理异常及对象判空，当前示例仅展示调用流程。
    // 设置图片参数。
    Image_ErrorCode errCode = OH_ImageReceiverOptions_Create(&options);
    if (errCode != IMAGE_SUCCESS || options == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageReceiverOptions_Create call failed");
        return;
    }
    Image_Size imgSize;
    imgSize.width = PREVIEW_WIDTH;  // 创建预览流的宽。
    imgSize.height = PREVIEW_HEIGHT; // 创建预览流的高。
    int32_t capacity = 8;  // BufferQueue里最大Image数量，推荐填写8。
    errCode = OH_ImageReceiverOptions_SetSize(options, imgSize);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageReceiverOptions_SetSize call failed");
    }
    errCode = OH_ImageReceiverOptions_SetCapacity(options, capacity);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageReceiverOptions_SetCapacity call failed");
    }
    // 创建OH_ImageReceiverNative对象。
    OH_ImageReceiverNative *receiver = nullptr;
    errCode = OH_ImageReceiverNative_Create(options, &receiver);
    if (errCode != IMAGE_SUCCESS || receiver == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageReceiverNative_Create call failed");
        return;
    }

    errCode = OH_ImageReceiverNative_On(receiver, CallbackReadNextImage);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "%{public}s image receiver on failed, errCode: %{public}d.", __func__, errCode);
        OH_ImageReceiverOptions_Release(options);
        OH_ImageReceiverNative_Release(receiver);
        return;
    }
    // 获取OH_ImageReceiverNative对象的SurfaceId。
    errCode = OH_ImageReceiverNative_GetReceivingSurfaceId(receiver, &receiverSurfaceID);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageReceiverNative_GetReceivingSurfaceId call failed");
    } else {
        OH_LOG_INFO(LOG_APP, "receiver surfaceID:%{public}lu", receiverSurfaceID);
    }
}
// [End init_image_receiver]

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t argc = 5;
    napi_value argv[5];
    napi_status status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    char previewSurfaceId[256];
    size_t surfaceIdLen;
    status = napi_get_value_string_utf8(env, argv[0], previewSurfaceId, sizeof(previewSurfaceId), &surfaceIdLen);
    char previewSurfaceIdSlave[256];
    status =
        napi_get_value_string_utf8(env, argv[1], previewSurfaceIdSlave, sizeof(previewSurfaceIdSlave), &surfaceIdLen);

    char videoSurfaceId[256];
    status = napi_get_value_string_utf8(env, argv[ARGS_TWO], videoSurfaceId, sizeof(videoSurfaceId), &surfaceIdLen);

    int32_t sceneMode = 0;
    status = napi_get_value_int32(env, argv[ARGS_THREE], &sceneMode);

    int32_t cameraPosition = 0;
    status = napi_get_value_int32(env, argv[ARGS_FOUR], &cameraPosition);

    napi_value result;
    if (g_ndkCamera) {
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }

    g_imageWidth = PREVIEW_WIDTH;
    g_imageHeight = PREVIEW_HEIGHT;
    g_xComponentSurfaceId = std::string(previewSurfaceId);
    g_xComponentSurfaceIdSlave = std::string(previewSurfaceIdSlave);
    uint64_t receiverSurfaceID = 0;
    g_isFirstBuffer = true;
    InitImageReceiver(receiverSurfaceID);
    std::string surfaceIdSlaveStr = std::to_string(receiverSurfaceID);
    g_ndkCamera = new NDKCamera(const_cast<char *>(g_xComponentSurfaceId.c_str()), videoSurfaceId,
        static_cast<Camera_SceneMode>(sceneMode), static_cast<Camera_Position>(cameraPosition),
        const_cast<char *>(surfaceIdSlaveStr.c_str()));
    g_isFront = (cameraPosition == 2); // 2是前置镜头camera_postion_front
    previewRotation = g_ndkCamera->GetPreviewRotation(g_displayRotation);
    OH_LOG_ERROR(LOG_APP, "InitCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value TakePicture(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TakePicture Start");
    napi_value js_value;
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    napi_value result;
    int rotation = 0;
    napi_status status = napi_get_value_int32(env, js_value, &rotation);
    Camera_ErrorCode ret = g_ndkCamera->TakePicture(rotation);
    OH_LOG_ERROR(LOG_APP, "TakePicture result is %{public}d, rotation is %{public}d", ret, rotation);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value SaveCurPhoto(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "SaveCurPhoto Start");
    size_t argc = 1;
    napi_value args[0] = {};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value result;
    Camera_ErrorCode ret = g_ndkCamera->SaveCurPhoto();
    OH_LOG_ERROR(LOG_APP, "SaveCurPhoto result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_ref bufferCbRef_ = nullptr;
static napi_ref foldCbRef_ = nullptr;
static napi_env env_;
size_t g_size = 0;

static void BufferCb(void *buffer, size_t size)
{
    OH_LOG_ERROR(LOG_APP, "BufferCb size:%{public}zu", size);
    g_size = size;
    napi_value asyncResource = nullptr;
    napi_value asyncResourceName = nullptr;
    napi_async_work work;

    napi_create_string_utf8(env_, "BufferCb", NAPI_AUTO_LENGTH, &asyncResourceName);
    napi_status status = napi_create_async_work(
        env_, asyncResource, asyncResourceName, [](napi_env env, void *buffer) {},
        [](napi_env env, napi_status status, void *buffer) {
            napi_value retVal;
            napi_value callback = nullptr;
            void *data = nullptr;
            napi_value arrayBuffer = nullptr;
            size_t bufferSize = g_size;
            napi_create_arraybuffer(env, bufferSize, &data, &arrayBuffer);
            std::memcpy(data, buffer, bufferSize);
            OH_LOG_ERROR(LOG_APP, "BufferCb g_size: %{public}zu", g_size);
            napi_get_reference_value(env, bufferCbRef_, &callback);
            if (callback) {
                OH_LOG_ERROR(LOG_APP, "BufferCb callback is full");
            } else {
                OH_LOG_ERROR(LOG_APP, "BufferCb callback is null");
            }
            napi_call_function(env, nullptr, callback, 1, &arrayBuffer, &retVal);
            // 清理内存
            free(data); // 释放在异步工作中分配的内存
        },
        buffer, &work);
    // 错误检查：创建异步工作失败时释放内存
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to create async work");
        free(buffer); // 释放分配的内存
        return;
    }
    napi_queue_async_work_with_qos(env_, work, napi_qos_user_initiated);
}

static napi_value SetBufferCb(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "SetBufferCb start");
    napi_value result;
    napi_get_undefined(env, &result);

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr);

    env_ = env;
    napi_create_reference(env, argValue[0], 1, &bufferCbRef_);
    if (bufferCbRef_) {
        OH_LOG_ERROR(LOG_APP, "SetBufferCb callbackRef is full");
    } else {
        OH_LOG_ERROR(LOG_APP, "SetBufferCb callbackRef is null");
    }
    g_ndkCamera->RegisterBufferCb(reinterpret_cast<void *>(BufferCb));
    return result;
}


// 深度复制 Camera_FoldStatusInfo
static Camera_FoldStatusInfo *DeepCopyFoldStatusInfo(Camera_FoldStatusInfo *src)
{
    if (src == nullptr) {
        return nullptr;
    }

    Camera_FoldStatusInfo *dst = new Camera_FoldStatusInfo();
    if (dst == nullptr) {
        return nullptr;
    }

    // 复制基础字段
    dst->cameraSize = src->cameraSize;
    dst->foldStatus = src->foldStatus;

    // 深度复制相机数组
    if (src->cameraSize > 0 && src->supportedCameras != nullptr) {
        dst->supportedCameras = new Camera_Device *[src->cameraSize];

        for (uint32_t i = 0; i < src->cameraSize; i++) {
            if (src->supportedCameras[i] == nullptr) {
                dst->supportedCameras[i] = nullptr;
                continue;
            }
            // 分配新的 Camera_Device
            dst->supportedCameras[i] = new Camera_Device();
            Camera_Device *srcCamera = src->supportedCameras[i];
            Camera_Device *dstCamera = dst->supportedCameras[i];
            // 深度复制 cameraId（字符串）
            if (srcCamera->cameraId != nullptr) {
                size_t len = strlen(srcCamera->cameraId) + 1;
                dstCamera->cameraId = new char[len];
                strcpy(dstCamera->cameraId, srcCamera->cameraId);
            } else {
                dstCamera->cameraId = nullptr;
            }
            // 复制其他字段
            dstCamera->cameraPosition = srcCamera->cameraPosition;
            dstCamera->cameraType = srcCamera->cameraType;
            dstCamera->connectionType = srcCamera->connectionType;

            OH_LOG_INFO(LOG_APP, "Copied camera: %{public}s", dstCamera->cameraId ? dstCamera->cameraId : "null");
        }
    } else {
        dst->supportedCameras = nullptr;
    }

    return dst;
}

static napi_value CreateJsCameraObject(napi_env env, Camera_Device *camera, uint32_t index)
{
    if (camera == nullptr) {
        return nullptr;
    }

    napi_value cameraObject;
    napi_create_object(env, &cameraObject);

    // 相机ID
    napi_value jsCameraId;
    napi_create_string_utf8(env, camera->cameraId, NAPI_AUTO_LENGTH, &jsCameraId);
    napi_set_named_property(env, cameraObject, "cameraId", jsCameraId);

    // 相机位置
    napi_value jsCameraPosition;
    napi_create_int32(env, camera->cameraPosition, &jsCameraPosition);
    napi_set_named_property(env, cameraObject, "cameraPosition", jsCameraPosition);

    // 相机类型
    napi_value jsCameraType;
    napi_create_int32(env, camera->cameraType, &jsCameraType);
    napi_set_named_property(env, cameraObject, "cameraType", jsCameraType);

    // 连接类型
    napi_value jsConnectionType;
    napi_create_int32(env, camera->connectionType, &jsConnectionType);
    napi_set_named_property(env, cameraObject, "connectionType", jsConnectionType);

    // 索引
    napi_value jsIndex;
    napi_create_uint32(env, index, &jsIndex);
    napi_set_named_property(env, cameraObject, "index", jsIndex);

    return cameraObject;
}

static napi_value CreateFoldStatusJsObject(napi_env env, Camera_FoldStatusInfo *foldData)
{
    napi_value jsObject;
    napi_create_object(env, &jsObject);

    // cameraSize属性
    napi_value jsCameraSize;
    napi_create_uint32(env, foldData->cameraSize, &jsCameraSize);
    napi_set_named_property(env, jsObject, "cameraSize", jsCameraSize);

    // foldStatus属性
    napi_value jsFoldStatus;
    napi_create_int32(env, foldData->foldStatus, &jsFoldStatus);
    napi_set_named_property(env, jsObject, "foldStatus", jsFoldStatus);

    // 创建相机数组
    napi_value jsCamerasArray;
    napi_create_array_with_length(env, foldData->cameraSize, &jsCamerasArray);

    if (foldData->supportedCameras != nullptr) {
        for (uint32_t i = 0; i < foldData->cameraSize; i++) {
            Camera_Device *camera = foldData->supportedCameras[i];
            if (camera == nullptr) {
                continue;
            }
            napi_value cameraObject = CreateJsCameraObject(env, camera, i);
            if (cameraObject != nullptr) {
                napi_set_element(env, jsCamerasArray, i, cameraObject);
            }
        }
    }

    napi_set_named_property(env, jsObject, "supportedCameras", jsCamerasArray);
    return jsObject;
}

static void FoldAsyncComplete(napi_env env, napi_status status, void *data)
{
    Camera_FoldStatusInfo *foldData = static_cast<Camera_FoldStatusInfo *>(data);
    if (foldData == nullptr) {
        return;
    }

    OH_LOG_ERROR(LOG_APP, "FoldCb foldData! cameraSize: %{public}u, foldStatus: %{public}d", foldData->cameraSize,
        foldData->foldStatus);
    napi_value callback = nullptr;
    napi_get_reference_value(env, foldCbRef_, &callback);

    if (callback == nullptr) {
        OH_LOG_ERROR(LOG_APP, "FoldCb callback is null");
        return;
    }

    OH_LOG_ERROR(LOG_APP, "FoldCb callback is full");

    napi_value jsObject = CreateFoldStatusJsObject(env, foldData);

    napi_value retVal;
    napi_call_function(env, nullptr, callback, 1, &jsObject, &retVal);
}

static bool CreateFoldAsyncWork(napi_env env, Camera_FoldStatusInfo *copyData)
{
    napi_value asyncResourceName;
    napi_create_string_utf8(env, "FoldCb", NAPI_AUTO_LENGTH, &asyncResourceName);

    napi_async_work work;
    napi_status status = napi_create_async_work(
        env, nullptr, asyncResourceName,
        [](napi_env env, void *data) {},
        FoldAsyncComplete,
        copyData, &work);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to create async work");
        return false;
    }

    napi_queue_async_work_with_qos(env, work, napi_qos_user_initiated);
    return true;
}

static void FoldCb(Camera_FoldStatusInfo *foldStatusInfo)
{
    OH_LOG_ERROR(LOG_APP, "FoldCb start! cameraSize: %{public}u, foldStatus: %{public}d", foldStatusInfo->cameraSize,
        foldStatusInfo->foldStatus);
    Camera_FoldStatusInfo *copyData = DeepCopyFoldStatusInfo(foldStatusInfo);
    if (copyData == nullptr) {
        OH_LOG_ERROR(LOG_APP, "DeepCopyFoldStatusInfo failed");
        return;
    }

    // 创建异步工作
    if (!CreateFoldAsyncWork(env_, copyData)) {
        OH_LOG_ERROR(LOG_APP, "CreateFoldAsyncWork failed");
    }
}

static napi_value SetFoldCb(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "SetFoldCb start");
    napi_value result;
    napi_get_undefined(env, &result);

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr);

    env_ = env;
    napi_create_reference(env, argValue[0], 1, &foldCbRef_);
    if (foldCbRef_) {
        OH_LOG_ERROR(LOG_APP, "SetFoldCb callbackRef is full");
    } else {
        OH_LOG_ERROR(LOG_APP, "SetFoldCb callbackRef is null");
    }
    g_ndkCamera->RegisterFoldCb(reinterpret_cast<void *>(FoldCb));
    return result;
}

static napi_value UpdateRotateForCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "UpdateRotate start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    int32_t rotation = 0;
    napi_status status = napi_get_value_int32(env, js_value, &rotation);
    OH_LOG_ERROR(LOG_APP, "UpdateRotate rotation:%{public}d", rotation);
    g_displayRotation = rotation;
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        g_ndkCamera->UpdateRotateForCamera(rotation);
        previewRotation = g_ndkCamera->GetPreviewRotation(g_displayRotation);
    }
    return result;
}

static napi_value GetVideoRotation(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoRotation start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    int32_t deviceDegree = 0;
    napi_status status = napi_get_value_int32(env, js_value, &deviceDegree);
    OH_LOG_ERROR(LOG_APP, "GetVideoRotation deviceDegree:%{public}d", deviceDegree);

    int32_t videoRotation = 0; // 用于保存视频旋转角度
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        // 调用 g_ndkCamera 获取视频旋转角度
        videoRotation = g_ndkCamera->GetVideoRotation(deviceDegree);
    }
    // 创建一个返回的 napi_value，将 videoRotation 转换为 JavaScript 中的整数
    napi_create_int32(env, videoRotation, &result);
    return result;
}

static napi_value StartVideoOutput(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "StartVideoOutput start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    size_t surfaceIdLen;
    char videoSurfaceId[256];
    napi_status status =
        napi_get_value_string_utf8(env, argv[0], videoSurfaceId, sizeof(videoSurfaceId), &surfaceIdLen);
    OH_LOG_ERROR(LOG_APP, "StartVideoOutput");
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        g_ndkCamera->VideoOutputStart(videoSurfaceId);
    }
    return result;
}

static napi_value StopVideoOutput(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "StopVideoOutput start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    int32_t deviceDegree = 0;
    napi_status status = napi_get_value_int32(env, js_value, &deviceDegree);
    OH_LOG_ERROR(LOG_APP, "StopVideoOutput");
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        g_ndkCamera->VideoOutputStop();
    }
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"initCamera", nullptr, InitCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"takePicture", nullptr, TakePicture, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"saveCurPhoto", nullptr, SaveCurPhoto, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setBufferCb", nullptr, SetBufferCb, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setFoldCb", nullptr, SetFoldCb, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"updateRotateForCamera", nullptr, UpdateRotateForCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoRotation", nullptr, GetVideoRotation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startVideoOutput", nullptr, StartVideoOutput, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopVideoOutput", nullptr, StopVideoOutput, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
