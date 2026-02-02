/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "camera_manager.h"

#define LOG_TAG "NDK_CAMERA_MANAGER"
#define LOG_DOMAIN 0x3210

namespace OHOS_CAMERA_NDK_SAMPLE {
static void *g_foldCb = nullptr;
const int32_t NUM_FIVE = 5;
const int32_t NUM_720 = 720;
const int32_t NUM_1080 = 1080;
const int32_t NUM_1920 = 1920;
const int32_t NUM_3072 = 3072;
const int32_t NUM_4096 = 4096;
const int32_t FRAME_MAX = 30;

void NDKCamera::GetCameraDevice()
{
    OH_LOG_INFO(LOG_APP, "GetCameraDevice position:%{public}d", position_);
    for (uint32_t i = 0; i < size_; ++i) {
        OH_LOG_INFO(LOG_APP, "GetCameraDevice index[%{public}d] cameraPosition:%{public}d", i,
            cameras_[i].cameraPosition);
        if (position_ == cameras_[i].cameraPosition) {
            cameraDeviceIndex_ = i;
            break;
        }
    }
}

NDKCamera::NDKCamera(char *previewSurfaceId, char *videoSurfaceId, Camera_SceneMode sceneMode, Camera_Position position,
    char *previewSurfaceSlaveId)
    : cameraManager_(nullptr),
      cameras_(nullptr),
      cameraOutputCapability_(nullptr),
      captureSession_(nullptr),
      cameraInput_(nullptr),
      previewOutput_(nullptr),
      photoOutput_(nullptr),
      videoOutput_(nullptr),
      profileNum_(NUM_720),
      ratio_(RATIO1_1),
      previewSurfaceId_(previewSurfaceId),
      videoSurfaceId_(videoSurfaceId),
      sceneMode_(sceneMode),
      position_(position),
      previewSurfaceSlaveId_(previewSurfaceSlaveId),
      previewSlaveOutput_(nullptr)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera start.");
    ReleaseCamera();
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager_);
    if (cameraManager_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "Get CameraManager failed.");
    }
    ret_ = OH_CameraManager_GetSupportedCameras(cameraManager_, &cameras_, &size_);
    GetCameraDevice();
    OH_LOG_INFO(LOG_APP, "cameraDeviceIndex:%{public}d", cameraDeviceIndex_);
    ret_ = OH_CameraManager_GetSupportedCameraOutputCapabilityWithSceneMode(cameraManager_,
        &cameras_[cameraDeviceIndex_], sceneMode_, &cameraOutputCapability_);
    ret = OH_CameraManager_CreateCaptureSession(cameraManager_, &captureSession_);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "Create captureSession failed.");
    }
    ret = OH_CaptureSession_SetSessionMode(captureSession_, sceneMode_);

    ret_ = OH_CameraManager_CreateCameraInput(cameraManager_, &cameras_[cameraDeviceIndex_], &cameraInput_);
    if (cameraInput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CreateCameraInput failed.");
    }
    ret_ = OH_CameraInput_Open(cameraInput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CameraInput_Open failed.");
    }

    if (sceneMode_ == NORMAL_PHOTO) {
        CreatePreviewOutput();
        CreatePhotoOutput();
    } else if (sceneMode_ == NORMAL_VIDEO) {
        CreatePreviewOutput();
        CreatePhotoOutput();
        CreateVideoOutput();
    }
    SessionFlowFn();
    SetColorSpace();
}

NDKCamera::~NDKCamera()
{
    OH_LOG_INFO(LOG_APP, "~NDKCamera");
    Camera_ErrorCode ret = CAMERA_OK;

    if (cameraManager_) {
        OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. enter");
        ret = OH_CameraManager_DeleteSupportedCameraOutputCapability(cameraManager_, cameraOutputCapability_);
        if (ret != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "Delete CameraOutputCapability failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. ok");
        }

        OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. enter");
        ret = OH_CameraManager_DeleteSupportedCameras(cameraManager_, cameras_, size_);
        if (ret != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "Delete Cameras failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. ok");
        }

        ret = OH_Camera_DeleteCameraManager(cameraManager_);
        if (ret != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "Delete CameraManager failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_Camera_DeleteCameraMananger. ok");
        }
        cameraManager_ = nullptr;
    }
    OH_LOG_INFO(LOG_APP, "~NDKCamera exit");
}

Camera_ErrorCode NDKCamera::CreatePreviewOutput()
{
    previewProfile_ = cameraOutputCapability_->previewProfiles[0];
    previewProfile_->size.width = NUM_1920;
    previewProfile_->size.height = NUM_1080;
    previewProfile_->format = CAMERA_FORMAT_YUV_420_SP;
    ret_ =
        OH_CameraManager_CreatePreviewOutput(cameraManager_, previewProfile_, previewSurfaceId_, &previewOutput_);
    if (previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CreatePreviewOutput failed.");
    }
    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, previewProfile_, previewSurfaceSlaveId_,
        &previewSlaveOutput_);
    if (previewSlaveOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CreatePreviewOutput failed.");
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput()
{
    photoProfile_ = cameraOutputCapability_->photoProfiles[0];
    photoProfile_->size.width = NUM_1920;
    photoProfile_->size.height = NUM_1080;
    photoProfile_->format = CAMERA_FORMAT_JPEG;
    ret_ = OH_CameraManager_CreatePhotoOutputWithoutSurface(cameraManager_, photoProfile_, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CreatePhotoOutput failed.");
    }
    PhotoOutputRegisterPhotoAssetAvailableCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput()
{
    videoProfile_ = cameraOutputCapability_->videoProfiles[0];
    videoProfile_->size.width = NUM_1920;
    videoProfile_->size.height = NUM_1080;
    videoProfile_->format = CAMERA_FORMAT_YUV_420_SP;
    videoProfile_->range.min = 1;
    videoProfile_->range.max = FRAME_MAX;
    ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, videoProfile_, videoSurfaceId_, &videoOutput_);
    if (videoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "CreateVideoOutput failed ret:%{public}d.", ret_);
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::SessionFlowFn()
{
    OH_LOG_INFO(LOG_APP, "SessionFlowFn start.");
    ret_ = OH_CaptureSession_BeginConfig(captureSession_);
    ret_ = OH_CaptureSession_AddInput(captureSession_, cameraInput_);
    ret_ = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);
    ret_ = OH_CaptureSession_AddPreviewOutput(captureSession_, previewSlaveOutput_);
    if (sceneMode_ == NORMAL_PHOTO) {
        ret_ = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
    } else if (sceneMode_ == NORMAL_VIDEO) {
        ret_ = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
        ret_ = OH_CaptureSession_AddVideoOutput(captureSession_, videoOutput_);
    }
    ret_ = OH_CaptureSession_CommitConfig(captureSession_);
    if (sceneMode_ == NORMAL_VIDEO) {
        bool isMirrorSupported = false;
        ret_ = OH_VideoOutput_IsMirrorSupported(videoOutput_, &isMirrorSupported);
        OH_LOG_INFO(LOG_APP, "VideoOutput IsMirrorSupported: %{public}d", isMirrorSupported);
        if (isMirrorSupported) {
            OH_VideoOutput_EnableMirror(videoOutput_, isMirrorSupported);
        }
    }
    InitPreviewRotation();
    ret_ = OH_CaptureSession_Start(captureSession_);
    OH_LOG_INFO(LOG_APP, "SessionFlowFn end.");
    return ret_;
}

Camera_ErrorCode NDKCamera::SetColorSpace()
{
    OH_NativeBuffer_ColorSpace curColorSpace;
    OH_CaptureSession_GetActiveColorSpace(captureSession_, &curColorSpace);
    OH_LOG_INFO(LOG_APP, "GetSupportedColorSpaces curColorSpace1:%{public}d", curColorSpace);
    OH_NativeBuffer_ColorSpace *colorSpace;
    uint32_t size;
    OH_CaptureSession_GetSupportedColorSpaces(captureSession_, &colorSpace, &size);
    for (int i = 0; i < size; i++) {
        OH_LOG_INFO(LOG_APP, "GetSupportedColorSpaces colorSpace:%{public}d", colorSpace[i]);
        if (OH_COLORSPACE_BT2020_HLG_LIMIT == colorSpace[i]) {
            OH_CaptureSession_SetActiveColorSpace(captureSession_, OH_COLORSPACE_BT2020_HLG_LIMIT);
            OH_LOG_INFO(LOG_APP, "GetSupportedColorSpaces set video hdr!");
        }
    }
    OH_CaptureSession_GetActiveColorSpace(captureSession_, &curColorSpace);
    OH_LOG_INFO(LOG_APP, "GetSupportedColorSpaces curColorSpace2:%{public}d", curColorSpace);
    return ret_;
}

Camera_ErrorCode NDKCamera::ReleaseCamera(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera ReleaseCamera");
    Camera_ErrorCode ret = CAMERA_OK;
    if (photoOutput_ != nullptr) {
        PhotoOutputUnRegisterPhotoAssetAvailableCallback();
    }

    OH_LOG_INFO(LOG_APP, "OH_CameraInput_Release cameraInput_.");
    if (cameraInput_ != nullptr) {
        OH_CameraInput_Close(cameraInput_);
        OH_LOG_INFO(LOG_APP, "OH_CameraInput_Release cameraInput_.");
        ret = OH_CameraInput_Release(cameraInput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "OH_CameraInput_Release failed.");
        }
    }
    if (captureSession_) {
        ret = OH_CaptureSession_Release(captureSession_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "OH_CaptureSession_Release failed.");
        }
    }
    if (photoOutput_ != nullptr) {
        ret = OH_PhotoOutput_Release(photoOutput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "OH_PhotoOutput_Release failed.");
        }
    }
    if (previewOutput_ != nullptr) {
        ret = OH_PreviewOutput_Release(previewOutput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "OH_PreviewOutput_Release failed.");
        }
    }
    if (previewSlaveOutput_ != nullptr) {
        ret = OH_PreviewOutput_Release(previewSlaveOutput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "OH_PreviewOutput_Release failed.");
        }
    }
    return ret_;
}

float GetDeviceDegreeFromXYZ(float x, float y, float z)
{
    // 判断条件 (x * x + y * y) * 3 < z * z
    if ((x * x + y * y) * 3 < z * z) {
        return -1.0f;
    } else {
        // 计算 atan2(y, -x) 并转换为角度
        float sd = std::atan2(y, -x);                      // 返回弧度
        float sc = std::round(sd / 3.141592653589f * 180); // 转换为角度并四舍五入
        float getDeviceDegree = 90.0f - sc;

        // 保证角度在 0 到 360 之间
        if (getDeviceDegree >= 0) {
            getDeviceDegree = fmod(getDeviceDegree, 360.0f); // 取模，保证结果在 0 到 360 之间
        } else {
            getDeviceDegree = fmod(getDeviceDegree, 360.0f) + 360.0f; // 如果小于0，加上360
        }
        OH_LOG_INFO(LOG_APP, "GetDeviceDegreeFromXYZ getDeviceDegree:%{public}f", getDeviceDegree);
        return getDeviceDegree;
    }
}

Sensor_SubscriptionId *id;
Sensor_Subscriber *subscriber;
Sensor_SubscriptionAttribute *attr;
float g_deviceDegree = 0.0f;
bool g_isDegreeReady = false;

void SensorDataCallback(Sensor_Event *event)
{
    OH_LOG_INFO(LOG_APP, "SensorDataCallbackImpl start");
    // SENSOR_TYPE_GRAVITY:data[0]、data[1]、data[2]分别表示设备x、y、z轴的重力加速度分量，单位m/s²；
    float *data = nullptr;
    uint32_t length = 0;
    OH_SensorEvent_GetData(event, &data, &length); // 获取传感器数据。
    for (uint32_t i = 0; i < length; ++i) {
        OH_LOG_INFO(LOG_APP, "SensorDataCallbackImpl data[%{public}d]:%{public}f", i, data[i]);
    }
    float x = data[0];
    float y = data[1];
    float z = data[2];
    g_deviceDegree = GetDeviceDegreeFromXYZ(x, y, z);
    g_isDegreeReady = true;

    OH_Sensor_Unsubscribe(id, subscriber); // 取消订阅传感器数据。
    if (id != nullptr) {
        OH_Sensor_DestroySubscriptionId(id); // 销毁Sensor_SubscriptionId实例并回收内存。
    }
    if (attr != nullptr) {
        OH_Sensor_DestroySubscriptionAttribute(attr); // 销毁Sensor_SubscriptionAttribute实例并回收内存。
    }
    if (subscriber != nullptr) {
        OH_Sensor_DestroySubscriber(subscriber); // 销毁Sensor_Subscriber实例并回收内存。
        subscriber = nullptr;
    }
}

void GetCurGravity()
{
    Sensor_Type SENSOR_ID{ SENSOR_TYPE_GRAVITY };
    id = OH_Sensor_CreateSubscriptionId(); // 创建一个Sensor_SubscriptionId实例。
    if (id == nullptr) {
        OH_LOG_ERROR(LOG_APP, "sensor error0");
    }
    int32_t res = OH_SensorSubscriptionId_SetType(id, SENSOR_ID); // 设置传感器类型为重力。
    if (res != 0) {
        OH_LOG_ERROR(LOG_APP, "sensor error1");
    }
    attr = OH_Sensor_CreateSubscriptionAttribute(); // 创建Sensor_SubscriptionAttribute实例。
    if (attr == nullptr) {
        OH_LOG_ERROR(LOG_APP, "sensor error2");
    }
    int64_t sensorSamplePeriod = 15000000;
    res = OH_SensorSubscriptionAttribute_SetSamplingInterval(attr, sensorSamplePeriod); // 设置传感器数据报告间隔。
    if (res != 0) {
        OH_LOG_ERROR(LOG_APP, "sensor error3");
    }
    subscriber = OH_Sensor_CreateSubscriber();
    if (subscriber == nullptr) {
        OH_LOG_ERROR(LOG_APP, "sensor error2");
    }

    OH_SensorSubscriber_SetCallback(subscriber, SensorDataCallback);
    Sensor_Result sensorRes = OH_Sensor_Subscribe(id, attr, subscriber); // 订阅传感器数据。
    if (sensorRes != SENSOR_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "sensor error:%{public}d", sensorRes);
    }
}

Camera_ErrorCode NDKCamera::TakePicture(int rotation)
{
    OH_LOG_INFO(LOG_APP, "TakePicture start");

    Camera_ErrorCode ret = CAMERA_OK;
    GetCurGravity();

    while (!g_isDegreeReady) {
        OH_LOG_INFO(LOG_APP, "TakePicture Waiting for degree to be ready...");
        std::this_thread::sleep_for(std::chrono::milliseconds(NUM_FIVE)); // 延时100毫秒，避免高CPU占用
    }
    OH_LOG_INFO(LOG_APP, "TakePicture ready");
    Camera_ImageRotation imageRotation;
    bool isMirSupported;
    OH_PhotoOutput_IsMirrorSupported(photoOutput_, &isMirSupported);
    OH_PhotoOutput_GetPhotoRotation(photoOutput_, rotation, &imageRotation);

    Camera_PhotoCaptureSetting curPhotoSetting = {
        quality : QUALITY_LEVEL_HIGH,
        rotation : imageRotation,
        mirror : isMirSupported
    };
    ret = OH_PhotoOutput_Capture_WithCaptureSetting(photoOutput_, curPhotoSetting);
    OH_LOG_INFO(LOG_APP, "TakePicture get quality %{public}d, rotation %{public}d, mirror %{public}d",
        curPhotoSetting.quality, curPhotoSetting.rotation, curPhotoSetting.mirror);
    OH_LOG_INFO(LOG_APP, "TakePicture ret = %{public}d.", ret);
    g_isDegreeReady = false;
    return ret;
}

OH_MediaAsset *g_mediaAsset_;
size_t g_photoBufferSize = NUM_3072 * NUM_4096;
auto photoBuffer = std::make_unique<uint8_t[]>(g_photoBufferSize);

Camera_ErrorCode NDKCamera::SaveCurPhoto()
{
    OH_LOG_INFO(LOG_APP, "SaveCurPhoto start");
    if (g_mediaAsset_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnImageDataPrepared: get current mediaAsset failed!");
    }
    // 调用媒体库接口通过buffer存图
    OH_MediaAssetChangeRequest *changeRequest = OH_MediaAssetChangeRequest_Create(g_mediaAsset_);
    MediaLibrary_ErrorCode mediaErr = OH_MediaAssetChangeRequest_AddResourceWithBuffer(changeRequest,
        MEDIA_LIBRARY_IMAGE_RESOURCE, photoBuffer.get(), g_photoBufferSize);
    OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: AddResourceWithBuffer get errCode:%{public}d", mediaErr);
    mediaErr = OH_MediaAssetChangeRequest_SaveCameraPhoto(changeRequest, MEDIA_LIBRARY_IMAGE_JPEG);
    OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: SaveCameraPhoto get errCode:%{public}d", mediaErr);
    mediaErr = OH_MediaAccessHelper_ApplyChanges(changeRequest);
    OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: ApplyChanges get errCode:%{public}d", mediaErr);
    return CAMERA_OK;
}

static void *g_bufferCb = nullptr;
Camera_ErrorCode NDKCamera::RegisterBufferCb(void *cb)
{
    OH_LOG_INFO(LOG_APP, " RegisterBufferCb start");
    if (cb == nullptr) {
        OH_LOG_INFO(LOG_APP, " RegisterBufferCb invalid error");
        return CAMERA_INVALID_ARGUMENT;
    }
    g_bufferCb = cb;

    return CAMERA_OK;
}


Camera_ErrorCode NDKCamera::RegisterFoldCb(void *cb)
{
    OH_LOG_INFO(LOG_APP, " RegisterFoldCb start");
    if (cb == nullptr) {
        OH_LOG_INFO(LOG_APP, " RegisterFoldCb invalid error");
        return CAMERA_INVALID_ARGUMENT;
    }
    g_foldCb = cb;
    RegisterFoldCallback();

    return CAMERA_OK;
}

void OnImageDataPrepared(MediaLibrary_ErrorCode result, MediaLibrary_RequestId requestId,
    MediaLibrary_MediaQuality mediaQuality, MediaLibrary_MediaContentType type, OH_ImageSourceNative *imageSourceNative)
{
    if (imageSourceNative == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnImageDataPrepared: imageSourceNative is nullptr!");
        return;
    }
    if (mediaQuality == MediaLibrary_MediaQuality::MEDIA_LIBRARY_QUALITY_FAST) {
        OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: Using fast media quality.");
    } else if (mediaQuality == MediaLibrary_MediaQuality::MEDIA_LIBRARY_QUALITY_FULL) {
        OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: Using full media quality.");
    }
    // 通过OH_ImageSourceNative创建OH_PixelmapNative
    OH_PixelmapNative *pixelmapNative = nullptr;
    OH_DecodingOptions *decodingOptions = nullptr;
    Image_ErrorCode imageErr = IMAGE_SUCCESS;
    imageErr = OH_ImageSourceNative_CreatePixelmap(imageSourceNative, decodingOptions, &pixelmapNative);
    if (imageErr != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OnImageDataPrepared: CreatePixelmap failed.");
        return;
    }
    // 创建Image Packer并设置打包选项
    OH_ImagePackerNative *imagePacker;
    OH_ImagePackerNative_Create(&imagePacker);
    OH_PackingOptions *options;
    OH_PackingOptions_Create(&options);
    char format[] = "image/jpeg";
    Image_MimeType image_MimeType = { format, strlen(format) };
    OH_PackingOptions_SetMimeType(options, &image_MimeType);
    OH_PackingOptions_SetQuality(options, 100); // 最高质量100
    size_t bufferSize = NUM_3072 * NUM_4096;            // 传大于编码后的size大小，编码后会重新赋值
    // 解析出图片buffer
    auto buffer = std::make_unique<uint8_t[]>(bufferSize);
    imageErr =
        OH_ImagePackerNative_PackToDataFromPixelmap(imagePacker, options, pixelmapNative, buffer.get(), &bufferSize);
    OH_LOG_INFO(LOG_APP, "OnImageDataPrepared: packToData ret code:%{public}u outsize:%{public}zu buffer:%{public}p",
        imageErr, bufferSize, buffer.get());
    // 拷贝buffer
    g_photoBufferSize = bufferSize;
    void *res = memcpy(photoBuffer.get(), buffer.get(), bufferSize);
    if (!res) {
        OH_LOG_ERROR(LOG_APP, "memccpy err!");
    }
    OH_LOG_INFO(LOG_APP, "OnImageDataPrepared g_photoBufferSize:%{public}zu photoBuffer:%{public}p", g_photoBufferSize,
        photoBuffer.get());
    // 传给应用回调
    auto cb = (void (*)(void *, size_t))(g_bufferCb);
    cb(photoBuffer.get(), g_photoBufferSize);
}

void mediaLibRequestBuffer(Camera_PhotoOutput *photoOutput, OH_MediaAsset *mediaAsset)
{
    if (photoOutput == nullptr) {
        OH_LOG_ERROR(LOG_APP, "photoOutput is nullptr!");
    }
    if (mediaAsset == nullptr) {
        OH_LOG_ERROR(LOG_APP, "mediaAsset is nullptr!");
    }
    OH_MediaAssetManager *mediaAssetManager = OH_MediaAssetManager_Create();
    if (mediaAssetManager == nullptr) {
        OH_LOG_ERROR(LOG_APP, "mediaAssetManager is nullptr!");
    }
    MediaLibrary_RequestOptions requestOptions;
    requestOptions.deliveryMode = MEDIA_LIBRARY_FAST_MODE;
    MediaLibrary_RequestId requestId;
    MediaLibrary_ErrorCode result = OH_MediaAssetManager_RequestImage(mediaAssetManager, mediaAsset, requestOptions,
        &requestId, OnImageDataPrepared);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_MediaAssetManager_RequestImage failed.");
    }
}


void OnPhotoAssetAvailable(Camera_PhotoOutput *photoOutput, OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "OnPhotoAssetAvailable start!");
    if (mediaAsset == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable mediaAsset nullptr!");
    }
    // 处理方式一：调用媒体库落盘接口保存一阶段图，二阶段图就绪后媒体库会主动帮应用替换落盘图片
    // 处理方式二：调用媒体库接口请求图片并注册一阶段图或二阶段图buffer回调，业务处理后通过buffer存图
    g_mediaAsset_ = mediaAsset;
    mediaLibRequestBuffer(photoOutput, mediaAsset);
}

Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback(void)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputRegisterPhotoAssetAvailableCallback start!");
    Camera_ErrorCode errCode = OH_PhotoOutput_RegisterPhotoAssetAvailableCallback(photoOutput_, OnPhotoAssetAvailable);
    if (errCode != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRegisterPhotoAssetAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "PhotoOutputRegisterPhotoAssetAvailableCallback return with ret code: %{public}d!", errCode);
    return errCode;
}

Camera_ErrorCode NDKCamera::PhotoOutputUnRegisterPhotoAssetAvailableCallback(void)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAssetAvailableCallback start!");
    ret_ = OH_PhotoOutput_UnregisterPhotoAssetAvailableCallback(photoOutput_, OnPhotoAssetAvailable);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputUnRegisterPhotoAssetAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAssetAvailableCallback return with ret code: %{public}d!", ret_);
    return ret_;
}

void FoldStatusInfoCallback(Camera_Manager *cameraManager, Camera_FoldStatusInfo *foldStatus)
{
    OH_LOG_INFO(LOG_APP, "FoldStatusInfoCallback start!");
    auto cb = ((void (*)(Camera_FoldStatusInfo *))(g_foldCb));
    for (uint32_t i = 0; i < foldStatus->cameraSize; i++) {
        OH_LOG_INFO(LOG_APP, "FoldStatus camera %{public}s", foldStatus->supportedCameras[i]->cameraId);
    }
    cb(foldStatus);
    OH_LOG_INFO(LOG_APP, "FoldStatusInfoCallback end! ");
}

Camera_ErrorCode NDKCamera::RegisterFoldCallback(void)
{
    OH_LOG_INFO(LOG_APP, "RegisterFoldCallback start!");
    Camera_ErrorCode errCode = OH_CameraManager_RegisterFoldStatusInfoCallback(cameraManager_, FoldStatusInfoCallback);
    if (errCode != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "RegisterFoldCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "RegisterFoldCallback return with ret code: %{public}d!", errCode);
    return errCode;
}

Camera_ErrorCode NDKCamera::UnRegisterFoldCallback(void)
{
    OH_LOG_INFO(LOG_APP, "UnRegisterFoldCallback start!");
    ret_ = OH_CameraManager_UnregisterFoldStatusInfoCallback(cameraManager_, FoldStatusInfoCallback);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "UnRegisterFoldCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "UnRegisterFoldCallback return with ret code: %{public}d!", ret_);
    return ret_;
}

Camera_ErrorCode NDKCamera::UpdateRotateForCamera(int rotation)
{
    OH_LOG_INFO(LOG_APP, "UpdateRotateForCamera start! imageRotation:%{public}d", rotation);
    Camera_ImageRotation previewRotation;
    OH_PreviewOutput_GetPreviewRotation(previewOutput_, static_cast<Camera_ImageRotation>(rotation), &previewRotation);
    OH_LOG_ERROR(LOG_APP, "UpdateRotateForCamera previewRotation:%{public}d", static_cast<int>(previewRotation));
    Camera_ErrorCode errCode = OH_PreviewOutput_SetPreviewRotation(previewOutput_, previewRotation, false);
    errCode = OH_PreviewOutput_SetPreviewRotation(previewSlaveOutput_, previewRotation, false);
    if (errCode != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "UpdateRotateForCamera failed.");
    }
    OH_LOG_INFO(LOG_APP, "UpdateRotateForCamera return with ret code: %{public}d!", errCode);
    return errCode;
}

Camera_ImageRotation NDKCamera::GetDeviceRotation()
{
    uint32_t orientation = 0;
    OH_CameraDevice_GetCameraOrientation(&cameras_[cameraDeviceIndex_], &orientation);
    return static_cast<Camera_ImageRotation>(orientation);
}

Camera_ImageRotation NDKCamera::GetPreviewRotation(int32_t rotation)
{
    Camera_ImageRotation previewRotation;
    OH_PreviewOutput_GetPreviewRotation(previewOutput_, static_cast<Camera_ImageRotation>(rotation), &previewRotation);
    return previewRotation;
}

Camera_ImageRotation NDKCamera::GetVideoRotation(int32_t deviceDegree)
{
    OH_LOG_INFO(LOG_APP, "GetVideoRotation start deviceDegree:%{public}d", deviceDegree);
    Camera_ImageRotation videoRotation;
    if (!videoOutput_) {
        OH_LOG_INFO(LOG_APP, "GetVideoRotation failed 111.");
    }
    ret_ = OH_VideoOutput_GetVideoRotation(videoOutput_, deviceDegree, &videoRotation);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "GetVideoRotation failed.");
    }
    OH_LOG_INFO(LOG_APP, "GetVideoRotation start videoRotation:%{public}d", videoRotation);
    return videoRotation;
}

Camera_ErrorCode NDKCamera::VideoOutputStart(char *videoId)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputStart begin. videoId: %{public}s", videoId);
    Camera_ErrorCode ret = OH_VideoOutput_Start(videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_VideoOutput_Start success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_Start failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::VideoOutputStop(void)
{
    OH_LOG_ERROR(LOG_APP, "enter VideoOutputStop.");
    ret_ = OH_VideoOutput_Stop(videoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputStop failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

int32_t NDKCamera::GetDefaultDisplayRotation() {
    int32_t imageRotation = 0;
    NativeDisplayManager_Rotation displayRotation = DISPLAY_MANAGER_ROTATION_0;
    int32_t ret = OH_NativeDisplayManager_GetDefaultDisplayRotation(&displayRotation);
    if (ret != DISPLAY_MANAGER_OK) {
        OH_LOG_INFO(LOG_APP, "OH_NativeDisplayManager_GetDefaultDisplayRotation failed.");
    }
    imageRotation = displayRotation * IAMGE_ROTATION_90;
    return imageRotation;
}

void NDKCamera::InitPreviewRotation() {
    // previewOutput_是创建的预览输出
    Camera_ImageRotation previewRotation = IAMGE_ROTATION_0;
    int32_t imageRotation = GetDefaultDisplayRotation();
    Camera_ErrorCode ret = OH_PreviewOutput_GetPreviewRotation(previewOutput_, imageRotation, &previewRotation);
    if (ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_PreviewOutput_GetPreviewRotation failed.");
    }
    ret = OH_PreviewOutput_SetPreviewRotation(previewOutput_, previewRotation, false);
    if (ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_PreviewOutput_SetPreviewRotation failed.");
    }
}
} // namespace OHOS_CAMERA_NDK_SAMPLE