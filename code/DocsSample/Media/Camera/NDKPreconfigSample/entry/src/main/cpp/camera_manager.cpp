/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
#include <cstdint>

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200
// preconfig mode
#define NO_PRECONFIG_MODE 1
#define TYPE_PRECONFIG_MODE 2
#define TYPE_RATIO_PRECONFIG_MODE 3

#define EPSILON 0.00001

MediaLibrary_ErrorCode result = MEDIA_LIBRARY_OK;
OH_MediaAssetChangeRequest *g_changeRequest;
OH_MovingPhoto *movingPhoto;
const OH_ImageSourceNative *imageSourceNaive;
OH_MediaAssetManager *mediaAssetManager;
MediaLibrary_RequestId g_requestId;
MediaLibrary_RequestOptions requestOptions;
const char *g_uri;
char *g_mediaQualityCb;
MediaLibrary_DeliveryMode g_deliveryMode = MEDIA_LIBRARY_BALANCED_MODE;

static void *g_requestImageCallback = nullptr;
static void *g_requestImageQualityCallback = nullptr;
static OH_MediaAsset *g_mediaAsset = nullptr;
const int32_t NUM_TWO = 2;
const int32_t NUM_FIVE = 5;
const int32_t NUM_FIFTY = 50;
const int32_t NUM_720 = 720;
const int32_t NUM_1080 = 1080;
const int32_t NUM_2160 = 2160;
const int32_t BUFFER_SIZE = 100000;

int AreFloatsEqual(float a, float b)
{
    return fabs(a - b) < EPSILON;
}

namespace OHOS_CAMERA_SAMPLE {
NDKCamera *NDKCamera::ndkCamera_ = nullptr;
std::mutex NDKCamera::mtx_;
const std::unordered_map<uint32_t, Camera_SceneMode> g_int32ToCameraSceneMode = { { 1, Camera_SceneMode::NORMAL_PHOTO },
    { 2, Camera_SceneMode::NORMAL_VIDEO },
    { 12, Camera_SceneMode::SECURE_PHOTO } };
const std::unordered_map<uint32_t, Camera_PreconfigType> g_int32ToCameraPreconfigType = { { 0,
    Camera_PreconfigType::PRECONFIG_720P },
    { 1, Camera_PreconfigType::PRECONFIG_1080P },
    { 2, Camera_PreconfigType::PRECONFIG_4K },
    { 3, Camera_PreconfigType::PRECONFIG_HIGH_QUALITY } };
const std::unordered_map<uint32_t, Camera_PreconfigRatio> g_int32ToCameraPreconfigRatio = { { 0,
    Camera_PreconfigRatio::PRECONFIG_RATIO_1_1 },
    { 1, Camera_PreconfigRatio::PRECONFIG_RATIO_4_3 },
    { 2, Camera_PreconfigRatio::PRECONFIG_RATIO_16_9 } };

NDKCamera::NDKCamera(char *str, uint32_t focusMode, uint32_t cameraDeviceIndex, uint32_t sceneMode,
    uint32_t preconfigMode, uint32_t preconfigType, uint32_t preconfigRatio, uint32_t photoOutputType,
    char *videoId, char *photoId)
    : previewSurfaceId_(str),
      cameras_(nullptr),
      focusMode_(focusMode),
      cameraDeviceIndex_(cameraDeviceIndex),
      cameraOutputCapability_(nullptr),
      cameraInput_(nullptr),
      captureSession_(nullptr),
      size_(0),
      isCameraMuted_(nullptr),
      profile_(nullptr),
      photoSurfaceId_(photoId),
      previewOutput_(nullptr),
      photoOutput_(nullptr),
      metaDataObjectType_(nullptr),
      metadataOutput_(nullptr),
      isExposureModeSupported_(false),
      isFocusModeSupported_(false),
      exposureMode_(EXPOSURE_MODE_LOCKED),
      minExposureBias_(0),
      maxExposureBias_(0),
      step_(0),
      ret_(CAMERA_OK),
      sceneMode_(NORMAL_PHOTO),
      sceneModes_(nullptr),
      preconfigType_(PRECONFIG_720P),
      preconfigRatio_(PRECONFIG_RATIO_1_1),
      activePreviewProfile_(nullptr),
      activePhotoProfile_(nullptr),
      activeVideoProfile_(nullptr),
      sceneModeSize_(0),
      preconfigMode_(preconfigMode),
      isSuccess_(false),
      preconfigged_(true),
      photoOutputType_(photoOutputType),
      videoSurfaceId_(videoId)
{
    valid_ = false;
    ReleaseCamera();
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager_);
    if (cameraManager_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Get CameraManager failed.");
    }

    ret = OH_CameraManager_CreateCaptureSession(cameraManager_, &captureSession_);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Create captureSession failed.");
    }

    auto sceneModeItr = g_int32ToCameraSceneMode.find(sceneMode);
    if (sceneModeItr != g_int32ToCameraSceneMode.end()) {
        sceneMode_ = sceneModeItr->second;
        OH_LOG_INFO(LOG_APP,
            "Constructor: sceneMode %{public}d converted to sceneMode_=%{public}d", sceneMode, sceneMode_);
    }
    OH_LOG_INFO(LOG_APP,
        "Constructor received: preconfigMode=%{public}d, preconfigType=%{public}d, preconfigRatio=%{public}d",
        preconfigMode, preconfigType, preconfigRatio);

    auto preconfigTypeItr = g_int32ToCameraPreconfigType.find(preconfigType);
    if (preconfigTypeItr != g_int32ToCameraPreconfigType.end()) {
        preconfigType_ = preconfigTypeItr->second;
        OH_LOG_INFO(LOG_APP, "preconfigType_ converted to: %{public}d", preconfigType_);
    }

    isHdrVideo = (preconfigType_ == Camera_PreconfigType::PRECONFIG_HIGH_QUALITY);

    auto preconfigRatioItr = g_int32ToCameraPreconfigRatio.find(preconfigRatio);
    if (preconfigRatioItr != g_int32ToCameraPreconfigRatio.end()) {
        preconfigRatio_ = preconfigRatioItr->second;
        OH_LOG_INFO(LOG_APP, "preconfigRatio_ converted to: %{public}d", preconfigRatio_);
    }

    // expect CAMERA_OK
    ret = OH_CaptureSession_SetSessionMode(captureSession_, sceneMode_);
    OH_LOG_INFO(LOG_APP,
        "OH_CaptureSession_SetSessionMode sceneMode_: %{public}d! ret code: %{public}d", sceneMode_, ret);

    CaptureSessionRegisterCallback();
    GetSupportedCameras();
    GetSupportedSceneModes();
    GetSupportedOutputCapabilityWithSceneMode(sceneMode_);
    GetSupportedOutputCapability();

    CreatePreviewOutput();
    if (sceneMode_ == Camera_SceneMode::NORMAL_VIDEO) {
        CreateVideoOutput(videoSurfaceId_);
    } else {
        CreatePhotoOutput(photoSurfaceId_);
    }
    CreateCameraInput();
    CameraInputOpen();
    CameraManagerRegisterCallback();
    SessionFlowFn();
    valid_ = true;
}

NDKCamera::~NDKCamera()
{
    valid_ = false;
    OH_LOG_ERROR(LOG_APP, "~NDKCamera");
    Camera_ErrorCode ret = CAMERA_OK;

    if (cameraManager_) {
        OH_LOG_ERROR(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. enter");
        ret = OH_CameraManager_DeleteSupportedCameraOutputCapability(cameraManager_, cameraOutputCapability_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete CameraOutputCapability failed.");
        } else {
            OH_LOG_ERROR(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. ok");
        }

        OH_LOG_ERROR(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. enter");
        ret = OH_CameraManager_DeleteSupportedCameras(cameraManager_, cameras_, size_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete Cameras failed.");
        } else {
            OH_LOG_ERROR(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. ok");
        }

        ret = OH_Camera_DeleteCameraManager(cameraManager_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete CameraManager failed.");
        } else {
            OH_LOG_ERROR(LOG_APP, "Release OH_Camera_DeleteCameraMananger. ok");
        }
        cameraManager_ = nullptr;
    }
    MediaAssetRelease();
    OH_LOG_ERROR(LOG_APP, "~NDKCamera exit");
}

Camera_ErrorCode NDKCamera::RequestImageCallback(void *cb)
{
    if (cb == nullptr) {
        OH_LOG_ERROR(LOG_APP, " RequestImageCallback invalid error");
        return CAMERA_INVALID_ARGUMENT;
    }
    g_requestImageCallback = cb;

    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::RequestImageQualityCallback(void *cb)
{
    if (cb == nullptr) {
        OH_LOG_ERROR(LOG_APP, " RequestImageCallback invalid error");
        return CAMERA_INVALID_ARGUMENT;
    }
    g_requestImageQualityCallback = cb;

    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::ReleaseCamera(void)
{
    OH_LOG_ERROR(LOG_APP, " enter ReleaseCamera");
    if (previewOutput_) {
        PreviewOutputStop();
        OH_CaptureSession_RemovePreviewOutput(captureSession_, previewOutput_);
        PreviewOutputRelease();
    }
    if (photoOutput_) {
        PhotoOutputRelease();
    }
    if (captureSession_) {
        SessionRealese();
    }
    if (cameraInput_) {
        CameraInputClose();
    }
    OH_LOG_ERROR(LOG_APP, " exit ReleaseCamera");
    return ret_;
}

Camera_ErrorCode NDKCamera::ReleaseSession(void)
{
    OH_LOG_ERROR(LOG_APP, " enter ReleaseSession");
    PreviewOutputStop();
    PhotoOutputRelease();
    SessionRealese();
    OH_LOG_ERROR(LOG_APP, " exit ReleaseSession");
    return ret_;
}

Camera_ErrorCode NDKCamera::SessionRealese(void)
{
    OH_LOG_ERROR(LOG_APP, " enter SessionRealese");
    Camera_ErrorCode ret = OH_CaptureSession_Release(captureSession_);
    captureSession_ = nullptr;
    OH_LOG_ERROR(LOG_APP, " exit SessionRealese");
    return ret;
}

Camera_ErrorCode NDKCamera::setZoomRatioFn(uint32_t zoomRatio)
{
    float zoom = float(zoomRatio);
    // Obtain supported zoom range
    float minZoom;
    float maxZoom;
    Camera_ErrorCode ret = OH_CaptureSession_GetZoomRatioRange(captureSession_, &minZoom, &maxZoom);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_GetZoomRatioRange failed.");
    } else {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetZoomRatioRange success. minZoom: %{public}f, maxZoom:%{public}f",
            minZoom, maxZoom);
    }

    // Set Zoom
    ret = OH_CaptureSession_SetZoomRatio(captureSession_, zoom);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_SetZoomRatio success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_SetZoomRatio failed. %{public}d ", ret);
    }

    // Obtain the zoom value of the current device
    ret = OH_CaptureSession_GetZoomRatio(captureSession_, &zoom);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetZoomRatio success. zoom ?{public}f ", zoom);
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_GetZoomRatio failed. %{public}d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SetRequestOption(uint32_t requestOption)
{
    if (requestOption == 0) {
        g_deliveryMode = MEDIA_LIBRARY_FAST_MODE;
    } else if (requestOption == 1) {
        g_deliveryMode = MEDIA_LIBRARY_HIGH_QUALITY_MODE;
    } else if (requestOption == NUM_TWO) {
        g_deliveryMode = MEDIA_LIBRARY_BALANCED_MODE;
    } else {
        return CAMERA_INVALID_ARGUMENT;
    }
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::SessionBegin(void)
{
    Camera_ErrorCode ret = OH_CaptureSession_BeginConfig(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_BeginConfig success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_BeginConfig failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SessionCommitConfig(void)
{
    OH_LOG_INFO(LOG_APP, "SessionCommitConfig: captureSession_=%{public}p", captureSession_);

    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: captureSession_ is nullptr in CommitConfig!");
        return CAMERA_INVALID_ARGUMENT;
    }

    Camera_ErrorCode ret = OH_CaptureSession_CommitConfig(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_CommitConfig success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_CommitConfig failed. ret=%{public}d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SessionStart(void)
{
    OH_LOG_INFO(LOG_APP, "SessionStart: captureSession_=%{public}p", captureSession_);

    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: captureSession_ is nullptr in Start!");
        return CAMERA_INVALID_ARGUMENT;
    }

    Camera_ErrorCode ret = OH_CaptureSession_Start(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_Start success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_Start failed. ret=%{public}d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SessionStop(void)
{
    Camera_ErrorCode ret = OH_CaptureSession_Stop(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_Stop success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_Stop failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SessionFlowFn(void)
{
    OH_LOG_INFO(LOG_APP, "Start SessionFlowFn IN.");
    // Start configuring session
    OH_LOG_INFO(LOG_APP, "session beginConfig.");
    Camera_ErrorCode ret = OH_CaptureSession_BeginConfig(captureSession_);

    isSuccess_ = false;
    CanAddInput(&isSuccess_);
    if (!isSuccess_) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::SessionFlowFn can not add input!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }

    // Add CameraInput to the session
    OH_LOG_INFO(LOG_APP, "session addInput.");
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);

    isSuccess_ = false;
    CanAddPreviewOutput(&isSuccess_);
    if (!isSuccess_) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::SessionFlowFn can not add preview output!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }

    // Add previewOutput to the session
    OH_LOG_INFO(LOG_APP, "session add Preview Output.");
    ret = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);
    if (sceneMode_ == Camera_SceneMode::NORMAL_VIDEO) {
        if (videoOutput_ == nullptr) {
            OH_LOG_INFO(LOG_APP, "videoOutput_ is nullptr");
        }
        ret = OH_CaptureSession_AddVideoOutput(captureSession_, videoOutput_);
        bool isMirrorSupported = false;
        ret = OH_VideoOutput_IsMirrorSupported(videoOutput_, &isMirrorSupported);
        OH_LOG_INFO(LOG_APP, "VideoOutput IsMirrorSupported: %{public}d", isMirrorSupported);
        if (isMirrorSupported) {
            OH_VideoOutput_EnableMirror(videoOutput_, isMirrorSupported);
        }
        if (preconfigType_ == Camera_PreconfigType::PRECONFIG_HIGH_QUALITY) {
            OH_NativeBuffer_ColorSpace colorSpace = OH_NativeBuffer_ColorSpace::OH_COLORSPACE_BT2020_HLG_LIMIT;
            SetColorSpace(colorSpace);
        }
        VideoOutputRegisterCallback();
    } else {
        if (photoOutput_ == nullptr) {
            OH_LOG_INFO(LOG_APP, "photoOutput_ is nullptr");
        }
        ret = AddPhotoOutput();
    }
    
    // Submit configuration information
    OH_LOG_INFO(LOG_APP, "session commitConfig");
    ret = OH_CaptureSession_CommitConfig(captureSession_);

    if (preconfigType_ == Camera_PreconfigType::PRECONFIG_HIGH_QUALITY) {
        uint32_t mode = static_cast<uint32_t>(Camera_VideoStabilizationMode::STABILIZATION_MODE_AUTO);
        IsVideoStabilizationModeSupportedFn(mode);
    }
    // Start Session Work
    OH_LOG_INFO(LOG_APP, "session start");
    ret = OH_CaptureSession_Start(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "session success");
    }

    // Get and print active profiles after session started
    OH_LOG_INFO(LOG_APP, "===== Getting Active Profiles =====");
    GetActivePreviewOutputProfile();
    if (photoOutput_&& sceneMode_ == Camera_SceneMode::NORMAL_PHOTO) {
        GetActivePhotoOutputProfile();
    }
    if (videoOutput_ && sceneMode_ == Camera_SceneMode::NORMAL_VIDEO) {
        GetActiveVideoOutputProfile();
    }

    // Start focusing
    OH_LOG_INFO(LOG_APP, "IsFocusMode start");
    ret = IsFocusMode(focusMode_);
    OH_LOG_INFO(LOG_APP, "IsFocusMode success");

    // Start GetSupport
    OH_LOG_INFO(LOG_APP, "GetSupportedFrameRates start");
    const uint32_t maxFrameRateRanges = 10;
    Camera_FrameRateRange *frameRateRange =
        (Camera_FrameRateRange *)malloc(sizeof(Camera_FrameRateRange) * maxFrameRateRanges);
    uint32_t size = maxFrameRateRanges;
    ret = PreviewOutputGetSupportedFrameRates(previewOutput_, &frameRateRange, &size);
    return ret;
}

Camera_ErrorCode NDKCamera::PreviewOutputGetSupportedFrameRates(Camera_PreviewOutput *previewOutput,
    Camera_FrameRateRange **frameRateRange, uint32_t *size)
{
    Camera_ErrorCode ret = OH_PreviewOutput_GetSupportedFrameRates(previewOutput, frameRateRange, size);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_PreviewOutput_GetSupportedFrameRates failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    for (uint32_t i = 0; i < *size; i++) {
        OH_LOG_DEBUG(LOG_APP, "PreviewOutputGetSupportedFrameRates: SupportedFrameRates min %{public}d",
            (*frameRateRange)[i].min);
        OH_LOG_DEBUG(LOG_APP, "PreviewOutputGetSupportedFrameRates: SupportedFrameRates max %{public}d",
            (*frameRateRange)[i].max);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::CreateCameraInput(void)
{
    OH_LOG_ERROR(LOG_APP, "enter CreateCameraInput.");
    ret_ = OH_CameraManager_CreateCameraInput(cameraManager_, &cameras_[cameraDeviceIndex_], &cameraInput_);
    if (cameraInput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateCameraInput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "exit CreateCameraInput.");
    CameraInputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CameraInputOpen(void)
{
    OH_LOG_ERROR(LOG_APP, "enter CameraInputOpen.");
    ret_ = OH_CameraInput_Open(cameraInput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CameraInput_Open failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "exit CameraInputOpen.");
    return ret_;
}

Camera_ErrorCode NDKCamera::CameraInputClose(void)
{
    OH_LOG_ERROR(LOG_APP, "enter CameraInput_Close.");
    ret_ = OH_CameraInput_Close(cameraInput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CameraInput_Close failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "exit CameraInput_Close.");
    return ret_;
}

Camera_ErrorCode NDKCamera::CameraInputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter CameraInputRelease.");
    ret_ = OH_CameraInput_Release(cameraInput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CameraInput_Release failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "exit CameraInputRelease.");
    return ret_;
}

Camera_ErrorCode NDKCamera::GetSupportedCameras(void)
{
    ret_ = OH_CameraManager_GetSupportedCameras(cameraManager_, &cameras_, &size_);
    if (cameras_ == nullptr || &size_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Get supported cameras failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::GetSupportedOutputCapability(void)
{
    ret_ = OH_CameraManager_GetSupportedCameraOutputCapability(cameraManager_, &cameras_[cameraDeviceIndex_],
        &cameraOutputCapability_);
    if (cameraOutputCapability_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedCameraOutputCapability failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePreviewOutput(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePreviewOutput start!");
    OH_LOG_INFO(LOG_APP, "preconfigMode_=%{public}d, preconfigType_=%{public}d, preconfigRatio_=%{public}d",
        preconfigMode_, preconfigType_, preconfigRatio_);

    isSuccess_ = false;
    ret_ = CanPreconfigWithRatio(&isSuccess_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePreviewOutput CanPreconfigWithRatio failed!");
    }
    OH_LOG_INFO(LOG_APP, "CanPreconfigWithRatio returned isSuccess=%{public}d", isSuccess_);
    
    ret_ = PreconfigWithRatio();
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePreviewOutput PreconfigWithRatio failed!");
    }
    OH_LOG_INFO(LOG_APP, "PreconfigWithRatio success");
    ret_ = OH_CameraManager_CreatePreviewOutputUsedInPreconfig(cameraManager_, previewSurfaceId_, &previewOutput_);
    if (previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CameraManager_CreatePreviewOutputUsedInPreconfig failed!");
        OH_LOG_INFO(LOG_APP, "ERROR: CreatePreviewOutputUsedInPreconfig failed! ret=%{public}d", ret_);
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "OH_CameraManager_CreatePreviewOutputUsedInPreconfig return with ret code: %{public}d!", ret_);
    PreviewOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput(char *photoSurfaceId)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePhotoOutput into preconfigged branch!");
    ret_ = OH_CameraManager_CreatePhotoOutputUsedInPreconfig(cameraManager_, photoSurfaceId, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CameraManager_CreatePhotoOutputUsedInPreconfig failed!");
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "OH_CameraManager_CreatePhotoOutputUsedInPreconfig return with ret code: %{public}d!", ret_);
    PhotoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutputWithoutSurfaceId()
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePhotoOutput into createWithoutSurfaceID branch!");
    cameraProfile_ = cameraOutputCapability_->photoProfiles[0];
    ret_ = OH_CameraManager_CreatePhotoOutputWithoutSurface(cameraManager_, cameraProfile_, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CameraManager_CreatePhotoOutputWithoutSurface failed!");
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreatePhotoOutput register photo asset available callback!");
    PhotoOutputRegisterPhotoAssetAvailableCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput(char *videoId)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreateVideoOutput start!");
    // 添加参数检查
    if (videoId == nullptr) {
        OH_LOG_INFO(LOG_APP, "ERROR: videoId is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }
    if (cameraManager_ == nullptr) {
        OH_LOG_INFO(LOG_APP, "ERROR: cameraManager_ is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CreateVideoOutput into preconfigged_ branch!");
    OH_LOG_INFO(LOG_APP, "CreateVideoOutput %{public}s", videoId);
    ret_ = OH_CameraManager_CreateVideoOutputUsedInPreconfig(cameraManager_, videoId, &videoOutput_);
    if (videoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "Successfully created video output for preconfig mode");
    return ret_;
}

Camera_ErrorCode NDKCamera::AddVideoOutput(void)
{
    OH_LOG_INFO(LOG_APP,
        "AddVideoOutput: captureSession_=%{public}p, videoOutput_=%{public}p", captureSession_, videoOutput_);

    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: captureSession_ is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }

    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: videoOutput_ is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }

    Camera_ErrorCode ret = OH_CaptureSession_AddVideoOutput(captureSession_, videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddVideoOutput success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddVideoOutput failed. ret=%{public}d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::AddPhotoOutput()
{
    Camera_ErrorCode ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddPhotoOutput success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddPhotoOutput failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::MetadataOutputRegisterCallback(void)
{
    metaDataObjectType_ = cameraOutputCapability_->supportedMetadataObjectTypes[0];
    if (metaDataObjectType_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get metaDataObjectType failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreateMetadataOutput(cameraManager_, metaDataObjectType_, &metadataOutput_);
    if (metadataOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateMetadataOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    RegisterMetadataOutputCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::IsCameraMuted(void)
{
    ret_ = OH_CameraManager_IsCameraMuted(cameraManager_, isCameraMuted_);
    if (isCameraMuted_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsCameraMuted failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::PreviewOutputStop(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PreviewOutputStop.");
    ret_ = OH_PreviewOutput_Stop(previewOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputStop failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::PreviewOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PreviewOutputRelease.");
    ret_ = OH_PreviewOutput_Release(previewOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::PhotoOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PhotoOutputRelease.");
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::IsVideoStabilizationModeSupportedFn(uint32_t mode)
{
    Camera_VideoStabilizationMode videoMode = static_cast<Camera_VideoStabilizationMode>(mode);
    // Check if the specified video anti shake mode is supported
    bool isSupported = false;
    Camera_ErrorCode ret =
        OH_CaptureSession_IsVideoStabilizationModeSupported(captureSession_, videoMode, &isSupported);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsVideoStabilizationModeSupported failed.");
    }
    if (isSupported) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_IsVideoStabilizationModeSupported success-----");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsVideoStabilizationModeSupported is not supported-----");
    }

    // Set video stabilization
    ret = OH_CaptureSession_SetVideoStabilizationMode(captureSession_, videoMode);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_SetVideoStabilizationMode success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_SetVideoStabilizationMode failed. %{public}d ", ret);
    }

    ret = OH_CaptureSession_GetVideoStabilizationMode(captureSession_, &videoMode);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode success. videoMode：%{public}f ", videoMode);
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode failed. %{public}d ", ret);
    }
    return ret;
}

// 设置色彩空间
Camera_ErrorCode NDKCamera::SetColorSpace(OH_NativeBuffer_ColorSpace colorSpace)
{
    OH_LOG_ERROR(LOG_APP, "SetColorSpace: this color space is %{public}d, start", colorSpace);
    Camera_ErrorCode ret = OH_CaptureSession_SetActiveColorSpace(captureSession_, colorSpace);
    if (ret != CAMERA_OK) {
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_NativeBuffer_ColorSpace getMode;
    ret = OH_CaptureSession_GetActiveColorSpace(captureSession_, &getMode);
    if (ret != CAMERA_OK) {
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "SetColorSpace: this color space is %{public}d", getMode);

    return ret;
}

Camera_ErrorCode NDKCamera::StartVideo(char *videoId, char *photoId)
{
    OH_LOG_INFO(LOG_APP, "StartVideo: isHdrVideo is %{public}d", isHdrVideo);

    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::VideoOutputStart(void)
{
    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: videoOutput_ is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }
    Camera_ErrorCode ret = OH_VideoOutput_Start(videoOutput_);
    OH_LOG_INFO(LOG_APP, "OH_VideoOutput_Start returned: ret=%{public}d", ret);

    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_VideoOutput_Start success.");
        OH_LOG_INFO(LOG_APP, "Video output started successfully!");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_Start failed. ret=%{public}d ", ret);
        OH_LOG_INFO(LOG_APP, "ERROR: OH_VideoOutput_Start failed! ret=%{public}d", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::StartPhoto(char *mSurfaceId)
{
    return ret_;
}

Camera_ErrorCode NDKCamera::StartPhotoWithOutSurfaceId()
{
    return ret_;
}

// exposure mode
Camera_ErrorCode NDKCamera::IsExposureModeSupportedFn(uint32_t mode)
{
    exposureMode_ = static_cast<Camera_ExposureMode>(mode);
    ret_ = OH_CaptureSession_IsExposureModeSupported(captureSession_, exposureMode_, &isExposureModeSupported_);
    if (&isExposureModeSupported_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_SetExposureMode(captureSession_, exposureMode_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetExposureMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetExposureMode(captureSession_, &exposureMode_);
    if (&exposureMode_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetExposureMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::IsMeteringPoint(int x, int y)
{
    OH_LOG_INFO(LOG_APP, "IsMeteringPoint start.");
    ret_ = OH_CaptureSession_GetExposureMode(captureSession_, &exposureMode_);
    if (&exposureMode_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetExposureMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    Camera_Point exposurePoint;
    exposurePoint.x = x;
    exposurePoint.y = y;
    ret_ = OH_CaptureSession_SetMeteringPoint(captureSession_, exposurePoint);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetMeteringPoint failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetMeteringPoint(captureSession_, &exposurePoint);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetMeteringPoint failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "IsMeteringPoint end.");
    return ret_;
}

Camera_ErrorCode NDKCamera::IsExposureBiasRange(int exposureBias)
{
    OH_LOG_INFO(LOG_APP, "IsExposureBiasRange end.");
    float exposureBiasValue = static_cast<float>(exposureBias);
    ret_ = OH_CaptureSession_GetExposureBiasRange(captureSession_, &minExposureBias_, &maxExposureBias_, &step_);
    if (&minExposureBias_ == nullptr || &maxExposureBias_ == nullptr || &step_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetExposureBiasRange failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_SetExposureBias(captureSession_, exposureBiasValue);
    OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_SetExposureBias end.");
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetExposureBias failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetExposureBias(captureSession_, &exposureBiasValue);
    if (&exposureBiasValue == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetExposureBias failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "IsExposureBiasRange end.");
    return ret_;
}

// focus mode
Camera_ErrorCode NDKCamera::IsFocusModeSupported(uint32_t mode)
{
    Camera_FocusMode focusMode = static_cast<Camera_FocusMode>(mode);
    ret_ = OH_CaptureSession_IsFocusModeSupported(captureSession_, focusMode, &isFocusModeSupported_);
    if (&isFocusModeSupported_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsFocusModeSupported failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::IsFocusMode(uint32_t mode)
{
    OH_LOG_INFO(LOG_APP, "IsFocusMode start.");
    Camera_FocusMode focusMode = static_cast<Camera_FocusMode>(mode);
    ret_ = OH_CaptureSession_IsFocusModeSupported(captureSession_, focusMode, &isFocusModeSupported_);
    if (&isFocusModeSupported_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsFocusModeSupported failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_SetFocusMode(captureSession_, focusMode);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetFocusMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetFocusMode(captureSession_, &focusMode);
    if (&focusMode == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetFocusMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "IsFocusMode end.");
    return ret_;
}

Camera_ErrorCode NDKCamera::PreviewOutputSetFrameRate(uint32_t minFps, uint32_t maxFps)
{
    Camera_ErrorCode ret = OH_PreviewOutput_SetFrameRate(previewOutput_, minFps, maxFps);
    if (ret != CAMERA_OK) {
        return CAMERA_INVALID_ARGUMENT;
    }

    ret = OH_PreviewOutput_GetActiveFrameRate(previewOutput_, frameRateRange);
    if (ret != CAMERA_OK) {
        return CAMERA_INVALID_ARGUMENT;
    }

    return ret;
}

Camera_ErrorCode NDKCamera::IsFocusPoint(float x, float y)
{
    OH_LOG_INFO(LOG_APP, "IsFocusPoint start.");
    Camera_Point focusPoint;
    focusPoint.x = x;
    focusPoint.y = y;
    ret_ = OH_CaptureSession_SetFocusPoint(captureSession_, focusPoint);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetFocusPoint failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetFocusPoint(captureSession_, &focusPoint);
    if (&focusPoint == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetFocusPoint failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "IsFocusPoint end.");
    return ret_;
}

int32_t NDKCamera::GetVideoFrameWidth(void)
{
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed, NULL");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "GetVideoFrameWidth: width=%{public}d", videoProfile_->size.width);
    return videoProfile_->size.width;
}

int32_t NDKCamera::GetVideoFrameHeight(void)
{
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed, NULL");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "GetVideoFrameHeight: height=%{public}d", videoProfile_->size.width);
    return videoProfile_->size.height;
}

int32_t NDKCamera::GetVideoFrameRate(void)
{
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed, NULL");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "GetVideoFrameRate min: %{public}d", videoProfile_->range.min);
    OH_LOG_INFO(LOG_APP, "GetVideoFrameRate max: %{public}d", videoProfile_->range.max);
    return videoProfile_->range.min;
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

Camera_ErrorCode NDKCamera::VideoOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter VideoOutputRelease.");
    ret_ = OH_VideoOutput_Release(videoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::TakePicture(int32_t degree)
{
    Camera_ErrorCode ret = CAMERA_OK;
    Camera_ImageRotation imageRotation;
    bool isMirSupported;
    OH_PhotoOutput_IsMirrorSupported(photoOutput_, &isMirSupported);
    OH_PhotoOutput_GetPhotoRotation(photoOutput_, degree, &imageRotation);

    Camera_PhotoCaptureSetting curPhotoSetting = {
        quality : QUALITY_LEVEL_HIGH,
        rotation : imageRotation,
        mirror : isMirSupported
    };
    ret = OH_PhotoOutput_Capture_WithCaptureSetting(photoOutput_, curPhotoSetting);
    OH_LOG_INFO(LOG_APP, "TakePicture get quality %{public}d, rotation %{public}d, mirror %{public}d",
        curPhotoSetting.quality, curPhotoSetting.rotation, curPhotoSetting.mirror);
    OH_LOG_INFO(LOG_APP, "TakePicture ret = %{public}d.", ret);
    return ret;
}

Camera_ErrorCode NDKCamera::TakePictureWithPhotoSettings(Camera_PhotoCaptureSetting photoSetting)
{
    Camera_ErrorCode ret = CAMERA_OK;
    ret = OH_PhotoOutput_Capture_WithCaptureSetting(photoOutput_, photoSetting);
    OH_LOG_ERROR(LOG_APP, "takePicture TakePictureWithPhotoSettings ret = %{public}d.", ret);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret;
}

// CameraManager Callback
void CameraManagerStatusCallback(Camera_Manager *cameraManager, Camera_StatusInfo *status)
{
    OH_LOG_INFO(LOG_APP, "CameraManagerStatusCallback");
}

CameraManager_Callbacks *NDKCamera::GetCameraManagerListener(void)
{
    static CameraManager_Callbacks cameraManagerListener = {
        .onCameraStatus = CameraManagerStatusCallback
    };
    return &cameraManagerListener;
}

Camera_ErrorCode NDKCamera::CameraManagerRegisterCallback(void)
{
    ret_ = OH_CameraManager_RegisterCallback(cameraManager_, GetCameraManagerListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_RegisterCallback failed.");
    }
    return ret_;
}

// CameraInput Callback
void OnCameraInputError(const Camera_Input *cameraInput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "OnCameraInput errorCode = %{public}d", errorCode);
}

CameraInput_Callbacks *NDKCamera::GetCameraInputListener(void)
{
    static CameraInput_Callbacks cameraInputCallbacks = {
        .onError = OnCameraInputError
    };
    return &cameraInputCallbacks;
}

Camera_ErrorCode NDKCamera::CameraInputRegisterCallback(void)
{
    ret_ = OH_CameraInput_RegisterCallback(cameraInput_, GetCameraInputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraInput_RegisterCallback failed.");
    }
    return ret_;
}

// PreviewOutput Callback
void PreviewOutputOnFrameStart(Camera_PreviewOutput *previewOutput)
{
    static int previewStartCount = 0;
    if (previewStartCount < NUM_FIVE) {
        OH_LOG_INFO(LOG_APP,
            "PreviewOutputOnFrameStart - Preview is receiving frames (count=%{public}d)", previewStartCount);
        previewStartCount++;
    }
}

void PreviewOutputOnFrameEnd(Camera_PreviewOutput *previewOutput, int32_t frameCount)
{
    static int previewEndCount = 0;
    if (previewEndCount < NUM_FIVE) {
        OH_LOG_INFO(LOG_APP, "PreviewOutputOnFrameEnd - frameCount = %{public}d", frameCount);
        previewEndCount++;
    }
}

void PreviewOutputOnError(Camera_PreviewOutput *previewOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_ERROR(LOG_APP, "PreviewOutputOnError - errorCode = %{public}d", errorCode);
    OH_LOG_INFO(LOG_APP, "ERROR: PreviewOutputOnError - errorCode = %{public}d", errorCode);
}

PreviewOutput_Callbacks *NDKCamera::GetPreviewOutputListener(void)
{
    static PreviewOutput_Callbacks previewOutputListener = {
        .onFrameStart = PreviewOutputOnFrameStart,
        .onFrameEnd = PreviewOutputOnFrameEnd,
        .onError = PreviewOutputOnError
    };
    return &previewOutputListener;
}

Camera_ErrorCode NDKCamera::PreviewOutputRegisterCallback(void)
{
    ret_ = OH_PreviewOutput_RegisterCallback(previewOutput_, GetPreviewOutputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_PreviewOutput_RegisterCallback failed.");
    }
    return ret_;
}

// PhotoOutput Callback
void PhotoOutputOnFrameStart(Camera_PhotoOutput *photoOutput)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameStart");
}

void PhotoOutputOnFrameShutter(Camera_PhotoOutput *photoOutput, Camera_FrameShutterInfo *info)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameShutter");
}

void PhotoOutputOnFrameEnd(Camera_PhotoOutput *photoOutput, int32_t frameCount)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutput frameCount = %{public}d", frameCount);
}

void PhotoOutputOnError(Camera_PhotoOutput *photoOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutput errorCode = %{public}d", errorCode);
}

PhotoOutput_Callbacks *NDKCamera::GetPhotoOutputListener(void)
{
    static PhotoOutput_Callbacks photoOutputListener = {
        .onFrameStart = PhotoOutputOnFrameStart,
        .onFrameShutter = PhotoOutputOnFrameShutter,
        .onFrameEnd = PhotoOutputOnFrameEnd,
        .onError = PhotoOutputOnError
    };
    return &photoOutputListener;
}

Camera_ErrorCode NDKCamera::PhotoOutputRegisterCallback(void)
{
    ret_ = OH_PhotoOutput_RegisterCallback(photoOutput_, GetPhotoOutputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_PhotoOutput_RegisterCallback failed.");
    }
    return ret_;
}

// VideoOutput Callback
void VideoOutputOnFrameStart(Camera_VideoOutput *videoOutput)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameStart - Video frame started");
    OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameStart called - recording frames are being captured");
}

void VideoOutputOnFrameEnd(Camera_VideoOutput *videoOutput, int32_t frameCount)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameEnd - frameCount = %{public}d", frameCount);
    OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameEnd - frameCount = %{public}d", frameCount);
}

void VideoOutputOnError(Camera_VideoOutput *videoOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_ERROR(LOG_APP, "VideoOutputOnError - errorCode = %{public}d", errorCode);
    OH_LOG_INFO(LOG_APP, "ERROR: VideoOutputOnError - errorCode = %{public}d", errorCode);
}

VideoOutput_Callbacks *NDKCamera::GetVideoOutputListener(void)
{
    static VideoOutput_Callbacks videoOutputListener = {
        .onFrameStart = VideoOutputOnFrameStart,
        .onFrameEnd = VideoOutputOnFrameEnd,
        .onError = VideoOutputOnError
    };
    return &videoOutputListener;
}

Camera_ErrorCode NDKCamera::VideoOutputRegisterCallback(void)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputRegisterCallback: videoOutput_=%{public}p", videoOutput_);

    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ERROR: videoOutput_ is nullptr in RegisterCallback!");
        return CAMERA_INVALID_ARGUMENT;
    }

    ret_ = OH_VideoOutput_RegisterCallback(videoOutput_, GetVideoOutputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_RegisterCallback failed. ret=%{public}d", ret_);
    } else {
        OH_LOG_INFO(LOG_APP, "OH_VideoOutput_RegisterCallback success.");
    }
    return ret_;
}

// Metadata Callback
void OnMetadataObjectAvailable(Camera_MetadataOutput *metadataOutput, Camera_MetadataObject *metadataObject,
    uint32_t size)
{
    OH_LOG_INFO(LOG_APP, "size = %{public}d", size);
}

void OnMetadataOutputError(Camera_MetadataOutput *metadataOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "OnMetadataOutput errorCode = %{public}d", errorCode);
}

MetadataOutput_Callbacks *NDKCamera::GetMetadataOutputListener(void)
{
    static MetadataOutput_Callbacks metadataOutputListener = {
        .onMetadataObjectAvailable = OnMetadataObjectAvailable,
        .onError = OnMetadataOutputError
    };
    return &metadataOutputListener;
}

Camera_ErrorCode NDKCamera::RegisterMetadataOutputCallback(void)
{
    ret_ = OH_MetadataOutput_RegisterCallback(metadataOutput_, GetMetadataOutputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_MetadataOutput_RegisterCallback failed.");
    }
    return ret_;
}

// Session Callback
void CaptureSessionOnFocusStateChange(Camera_CaptureSession *session, Camera_FocusState focusState)
{
    OH_LOG_INFO(LOG_APP, "CaptureSession_Callbacks CaptureSessionOnFocusStateChange");
    OH_LOG_INFO(LOG_APP, "CaptureSessionOnFocusStateChange");
}

void CaptureSessionOnError(Camera_CaptureSession *session, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "CaptureSession_Callbacks CaptureSessionOnError");
    OH_LOG_INFO(LOG_APP, "CaptureSession errorCode = %{public}d", errorCode);
}

CaptureSession_Callbacks *NDKCamera::GetCaptureSessionRegister(void)
{
    static CaptureSession_Callbacks captureSessionCallbacks = {
        .onFocusStateChange = CaptureSessionOnFocusStateChange,
        .onError = CaptureSessionOnError
    };
    return &captureSessionCallbacks;
}

Camera_ErrorCode NDKCamera::CaptureSessionRegisterCallback(void)
{
    ret_ = OH_CaptureSession_RegisterCallback(captureSession_, GetCaptureSessionRegister());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_RegisterCallback failed.");
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::GetSupportedSceneModes(void)
{
    ret_ = OH_CameraManager_GetSupportedSceneModes(&cameras_[cameraDeviceIndex_], &sceneModes_, &sceneModeSize_);
    if (sceneModes_ == nullptr || &sceneModeSize_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedSceneModes failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedSceneModes sceneModeSize_: %{public}d", sceneModeSize_);
    for (uint32_t i = 0; i < sceneModeSize_; i++) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedSceneModes sceneMode_: %{public}d", sceneModes_[i]);
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedSceneModes return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetSupportedOutputCapabilityWithSceneMode(Camera_SceneMode sceneMode)
{
    ret_ = OH_CameraManager_GetSupportedCameraOutputCapabilityWithSceneMode(cameraManager_,
        &cameras_[cameraDeviceIndex_], sceneMode, &cameraOutputCapability_);
    if (cameraOutputCapability_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    if (sceneMode == Camera_SceneMode::NORMAL_VIDEO) {
        OH_LOG_INFO(LOG_APP, "===== ALL AVAILABLE VIDEO PROFILES =====");
        for (uint32_t i = 0; i < cameraOutputCapability_->videoProfilesSize && i < NUM_FIFTY; i++) {
            if (cameraOutputCapability_->videoProfiles[i] != nullptr) {
                Camera_VideoProfile *vp = cameraOutputCapability_->videoProfiles[i];
                float ratio = (float)vp->size.width / vp->size.height;
                OH_LOG_INFO(LOG_APP,
                    "Video profile[%{public}d]: %{public}dx%{public}d (ratio=%.2f), format=%{public}d, "
                     "fps=[%{public}d,%{public}d]",
                    i, vp->size.width, vp->size.height, ratio, vp->format, vp->range.min, vp->range.max);
            }
        }
        OH_LOG_INFO(LOG_APP, "===== END OF VIDEO PROFILES =====");

        if (cameraOutputCapability_->videoProfilesSize > 0) {
            OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
                "videoProfiles[0] format: %{public}d!",
                sceneMode, cameraOutputCapability_->videoProfiles[0]->format);
            OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
                "videoProfiles[0] width: %{public}d!",
                sceneMode, cameraOutputCapability_->videoProfiles[0]->size.width);
            OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
                "videoProfiles[0] height: %{public}d!",
                sceneMode, cameraOutputCapability_->videoProfiles[0]->size.height);
            OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
                "videoProfiles[0] range.min: %{public}d!",
                sceneMode, cameraOutputCapability_->videoProfiles[0]->range.min);
            OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
                "videoProfiles[0] range.max: %{public}d!",
                sceneMode, cameraOutputCapability_->videoProfiles[0]->range.max);
        }
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
            "metadataProfilesSize: %{public}d!",
            sceneMode, cameraOutputCapability_->metadataProfilesSize);
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
        "return with ret code: %{public}d!",
        sceneMode, ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddInput(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddInput start!");
    ret_ = OH_CaptureSession_CanAddInput(captureSession_, cameraInput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddInput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddInput isSuccess: %{public}d!", *isSuccess);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddInput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddPreviewOutput(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPreviewOutput start!");
    ret_ = OH_CaptureSession_CanAddPreviewOutput(captureSession_, previewOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPreviewOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPreviewOutput isSuccess: %{public}d!", *isSuccess);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPreviewOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddPhotoOutput(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPhotoOutput start!");
    ret_ = OH_CaptureSession_CanAddPhotoOutput(captureSession_, photoOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPhotoOutput isSuccess: %{public}d!", *isSuccess);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddPhotoOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddVideoOutput(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddVideoOutput start!");
    ret_ = OH_CaptureSession_CanAddVideoOutput(captureSession_, videoOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddVideoOutput isSuccess: %{public}d!", *isSuccess);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanAddVideoOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanPreconfig(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfig start!");
    ret_ = OH_CaptureSession_CanPreconfig(captureSession_, preconfigType_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfig failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfig isSuccess: %{public}d, preconfigTyep: %{public}d!", *isSuccess,
        preconfigType_);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfig return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::Preconfig(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::Preconfig start!");
    ret_ = OH_CaptureSession_Preconfig(captureSession_, preconfigType_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::Preconfig failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::Preconfig return with ret code: %{public}d!", ret_);
    return ret_;
}

Camera_ErrorCode NDKCamera::CanPreconfigWithRatio(bool *isSuccess)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfigWithRatio start!");
    ret_ = OH_CaptureSession_CanPreconfigWithRatio(captureSession_, preconfigType_, preconfigRatio_, isSuccess);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfigWithRatio failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfigWithRatio isSuccess: %{public}d, type: %{public}d, ratio: %{public}d!",
        *isSuccess, preconfigType_, preconfigRatio_);
    OH_LOG_INFO(LOG_APP, "NDKCamera::CanPreconfigWithRatio return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::PreconfigWithRatio(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PreconfigWithRatio start!");
    OH_LOG_INFO(LOG_APP, "Calling OH_CaptureSession_PreconfigWithRatio with type=%{public}d, ratio=%{public}d",
        preconfigType_, preconfigRatio_);
    ret_ = OH_CaptureSession_PreconfigWithRatio(captureSession_, preconfigType_, preconfigRatio_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PreconfigWithRatio failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "PreconfigWithRatio SUCCESS! ret=%{public}d", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActivePreviewOutputProfile(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePreviewOutputProfile start!");
    ret_ = OH_PreviewOutput_GetActiveProfile(previewOutput_, &activePreviewProfile_);
    if (activePreviewProfile_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePreviewOutputProfile failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "Preview Active Profile - format: %{public}d", activePreviewProfile_->format);
    OH_LOG_INFO(LOG_APP, "Preview Active Profile - width: %{public}d", activePreviewProfile_->size.width);
    OH_LOG_INFO(LOG_APP, "Preview Active Profile - height: %{public}d", activePreviewProfile_->size.height);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePreviewOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActivePhotoOutputProfile(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePhotoOutputProfile start!");
    ret_ = OH_PhotoOutput_GetActiveProfile(photoOutput_, &activePhotoProfile_);
    if (activePhotoProfile_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePhotoOutputProfile failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "Photo Active Profile - format: %{public}d", activePhotoProfile_->format);
    OH_LOG_INFO(LOG_APP, "Photo Active Profile - width: %{public}d", activePhotoProfile_->size.width);
    OH_LOG_INFO(LOG_APP, "Photo Active Profile - height: %{public}d", activePhotoProfile_->size.height);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActivePhotoOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}

void onPhotoAvailable(Camera_PhotoOutput *photoOutput, OH_PhotoNative *photo)
{
    OH_LOG_INFO(LOG_APP, "onPhotoAvailable start!");
    NDKCamera::PhotoNativeGetMainImage(photo);
    NDKCamera::PhotoNativeRelease(photo);
    OH_LOG_INFO(LOG_APP, "onPhotoAvailable finish!");
}
Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAvailableCallback(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback start!");
    ret_ = OH_PhotoOutput_RegisterPhotoAvailableCallback(photoOutput_, onPhotoAvailable);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP,
        "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback return with ret code: %{public}d!", ret_);
    return ret_;
}
void onPhotoAssetAvailable(Camera_PhotoOutput *photoOutput, OH_MediaAsset *mediaAsset)
{
    if (mediaAsset == nullptr) {
        DRAWING_LOGI("onPhotoAssetAvailable mediaAsset is nullptr !");
        return;
    }
    OH_LOG_INFO(LOG_APP, "onPhotoAssetAvailable start!");
    NDKCamera::MediaAssetRelease();
    g_mediaAsset = mediaAsset;
    NDKCamera::MediaAssetGetUri(mediaAsset);
    NDKCamera::MediaAssetGetDisplayName(mediaAsset);
    NDKCamera::MediaAssetGetSize(mediaAsset);
    NDKCamera::MediaAssetGetDateModifiedMs(mediaAsset);
    NDKCamera::MediaAssetGetWidth(mediaAsset);
    NDKCamera::MediaAssetGetHeight(mediaAsset);
    NDKCamera::MediaAssetGetOrientation(mediaAsset);
    NDKCamera::MediaAssetManagerCreate();
    NDKCamera::MediaAssetChangeRequest(mediaAsset);
    OH_LOG_INFO(LOG_APP, "onPhotoAssetAvailable finish!");
    return;
}
Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback start!");
    MediaAssetManagerCreate();
    ret_ = OH_PhotoOutput_RegisterPhotoAssetAvailableCallback(photoOutput_, onPhotoAssetAvailable);
    if (ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP,
        "NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActiveVideoOutputProfile(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile start!");
    OH_LOG_INFO(LOG_APP, "===== GetActiveVideoOutputProfile =====");
    OH_LOG_INFO(LOG_APP, "videoOutput_=%{public}p", videoOutput_);

    if (videoOutput_ == nullptr) {
        OH_LOG_INFO(LOG_APP, "ERROR: videoOutput_ is nullptr!");
        return CAMERA_INVALID_ARGUMENT;
    }

    ret_ = OH_VideoOutput_GetActiveProfile(videoOutput_, &activeVideoProfile_);
    if (activeVideoProfile_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile failed.");
        OH_LOG_INFO(LOG_APP, "ERROR: GetActiveProfile failed! ret=%{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ format: %{public}d!",
        activeVideoProfile_->format);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ width: %{public}d!",
        activeVideoProfile_->size.width);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ height: %{public}d!",
        activeVideoProfile_->size.height);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ range.min: %{public}d!",
        activeVideoProfile_->range.min);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ range.max: %{public}d!",
        activeVideoProfile_->range.max);
    OH_LOG_INFO(LOG_APP, "Active Video Profile: %{public}dx%{public}d, format=%{public}d, fps=[%{public}d,%{public}d]",
        activeVideoProfile_->size.width, activeVideoProfile_->size.height, activeVideoProfile_->format,
        activeVideoProfile_->range.min, activeVideoProfile_->range.max);
    OH_LOG_INFO(LOG_APP, "NDKCamera::GetActiveVideoOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::PhotoNativeGetMainImage(OH_PhotoNative *photoNative)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeGetMainImage start!");
    Camera_ErrorCode result = CAMERA_OK;
    OH_ImageNative *imageNative = nullptr;
    result = OH_PhotoNative_GetMainImage(photoNative, &imageNative);
    if (imageNative == nullptr || result != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeGetMainImage failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeGetMainImage return with ret code: %{public}d!", result);
    return result;
}
Camera_ErrorCode NDKCamera::PhotoNativeRelease(OH_PhotoNative *photoNative)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeRelease start!");
    Camera_ErrorCode result = CAMERA_OK;
    result = OH_PhotoNative_Release(photoNative);
    if (result != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeRelease failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoNativeRelease return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetUri(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetUri start!");
    const char *uri = nullptr;
    result = OH_MediaAsset_GetUri(mediaAsset, &g_uri);
    if (g_uri == nullptr || result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetUri failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetUri uri: %{public}s", g_uri);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetUri return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDisplayName(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDisplayName start!");
    const char *displayName = nullptr;
    result = OH_MediaAsset_GetDisplayName(mediaAsset, &displayName);
    if (displayName == nullptr || result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDisplayName failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDisplayName displayName: %{public}s", displayName);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDisplayName return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetSize(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetSize start!");
    uint32_t mediaAssetSize;
    result = OH_MediaAsset_GetSize(mediaAsset, &mediaAssetSize);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetSize failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetSize mediaAssetSize: %{public}d", mediaAssetSize);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetSize return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDateModifiedMs(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDateModifiedMs start!");
    uint32_t dateModifiedMs;
    result = OH_MediaAsset_GetDateModifiedMs(mediaAsset, &dateModifiedMs);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDateModifiedMs failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDateModifiedMs dateModifiedMs: %{public}lu", dateModifiedMs);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetDateModifiedMs return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetWidth(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetWidth start!");
    uint32_t width;
    result = OH_MediaAsset_GetWidth(mediaAsset, &width);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetWidth failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetWidth width: %{public}d", width);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetWidth return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetHeight(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetHeight start!");
    uint32_t height;
    result = OH_MediaAsset_GetHeight(mediaAsset, &height);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetHeight failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetHeight height: %{public}d", height);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetHeight return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetOrientation(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetOrientation start!");
    uint32_t orientation;
    result = OH_MediaAsset_GetOrientation(mediaAsset, &orientation);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetOrientation failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetOrientation orientation: %{public}d", orientation);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetGetOrientation return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetRelease()
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetRelease start!");
    result = OH_MediaAsset_Release(g_mediaAsset);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetRelease failed.");
    }
    g_mediaAsset = nullptr;
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetRelease return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetChangeRequest(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetChangeRequest start!");
    MediaAssetChangeRequestCreate(mediaAsset);
    MediaAssetManagerRequestImage(mediaAsset);
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetChangeRequest finish!");
    return MEDIA_LIBRARY_OK;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetChangeRequestCreate(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetChangeRequestCreate start!");
    g_changeRequest = OH_MediaAssetChangeRequest_Create(mediaAsset);
    if (g_changeRequest == nullptr) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetChangeRequestCreate failed.");
    }
    return MEDIA_LIBRARY_OK;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestAddResourceWithBuffer(OH_ImageSourceNative *imageSourceNative)
{
    OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer start!");
    size_t bufferSize = BUFFER_SIZE;
    char buffer[BUFFER_SIZE];
    int fd = open("/data/storage/el2/base/haps/test.jpg", O_RDONLY);
    int fr = read(fd, buffer, bufferSize);
    if (fr == -1) {
        OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer read failed.");
        return MEDIA_LIBRARY_OK;
    }
    if (fr == BUFFER_SIZE) {
        OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer read not complete.");
        return MEDIA_LIBRARY_OK;
    }
    result = OH_MediaAssetChangeRequest_AddResourceWithBuffer(g_changeRequest,
        MediaLibrary_ResourceType::MEDIA_LIBRARY_IMAGE_RESOURCE, (uint8_t *)buffer, (uint32_t)bufferSize);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer failed.");
        OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer failed %{public}d.", result);
        return MEDIA_LIBRARY_OK;
    }
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP,
            "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer OH_MediaAccessHelper_ApplyChanges failed.");
        return MEDIA_LIBRARY_OK;
    }
    OH_LOG_INFO(LOG_APP, "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer "
        "OH_MediaAccessHelper_ApplyChanges return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestSaveCameraPhoto(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestSaveCameraPhoto start!");
    result = OH_MediaAssetChangeRequest_SaveCameraPhoto(g_changeRequest,
        MediaLibrary_ImageFileType::MEDIA_LIBRARY_IMAGE_JPEG);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP,
            "NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAssetChangeRequest_SaveCameraPhoto failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestSaveCameraPhoto "
        "OH_MediaAssetChangeRequest_SaveCameraPhoto return with ret code: %{public}d!", result);
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAccessHelper_ApplyChanges failed.");
    }
    OH_LOG_INFO(LOG_APP,
        "NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAccessHelper_ApplyChanges return with ret code: %{public}d!",
        result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestDiscardCameraPhoto(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestDiscardCameraPhoto start!");
    result = OH_MediaAssetChangeRequest_DiscardCameraPhoto(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP,
            "NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAssetChangeRequest_DiscardCameraPhoto failed.");
    }
    OH_LOG_INFO(LOG_APP,
        "NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAssetChangeRequest_DiscardCameraPhoto return with "
        "ret code: %{public}d!", result);
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAccessHelper_ApplyChanges failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestDiscardCameraPhoto "
        "OH_MediaAccessHelper_ApplyChanges return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestRelease(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestRelease start!");
    result = OH_MediaAssetChangeRequest_Release(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestRelease failed.");
    }
    g_changeRequest = nullptr;
    OH_LOG_INFO(LOG_APP, "NDKCamera::ChangeRequestRelease return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetManagerCreate(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetManagerCreate start!");
    mediaAssetManager = OH_MediaAssetManager_Create();
    if (mediaAssetManager == nullptr) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetManagerCreate failed.");
    }
    return MEDIA_LIBRARY_OK;
}
void OnRequsetImageDataPreparedWithDetails(MediaLibrary_ErrorCode result, MediaLibrary_RequestId requestId,
    MediaLibrary_MediaQuality mediaQuality, MediaLibrary_MediaContentType type, OH_ImageSourceNative *imageSourceNative)
{
    auto cb = (void (*)(char *))(g_requestImageCallback);
    auto qCb = (void (*)(char *))(g_requestImageQualityCallback);
    OH_LOG_INFO(LOG_APP, "OnRequsetImageDataPreparedWithDetails start!");
    if (mediaQuality == MediaLibrary_MediaQuality::MEDIA_LIBRARY_QUALITY_FAST) {
        OH_LOG_INFO(LOG_APP, "OnRequsetImageDataPreparedWithDetails into fast quality mode!");
        g_mediaQualityCb = "fast";
        qCb(g_mediaQualityCb);
    } else {
        OH_LOG_INFO(LOG_APP, "OnRequsetImageDataPreparedWithDetails into high quality mode!");
        g_mediaQualityCb = "high";
        qCb(g_mediaQualityCb);
    }
    OH_LOG_INFO(LOG_APP, "OnRequsetImageDataPreparedWithDetails GetUri g_uri = %{public}s", g_uri);
    cb(const_cast<char *>(g_uri));
    NDKCamera::ChangeRequestAddResourceWithBuffer(imageSourceNative);
    return;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetManagerRequestImage(OH_MediaAsset *mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetManagerRequestImage start! g_deliveryMode = %{public}d", g_deliveryMode);
    requestOptions.deliveryMode = g_deliveryMode;
    result = OH_MediaAssetManager_RequestImage(mediaAssetManager, mediaAsset, requestOptions, &g_requestId,
        OnRequsetImageDataPreparedWithDetails);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetManagerRequestImage failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::MediaAssetManagerRequestImage return with ret code: %{public}d!", result);
    return result;
}
} // namespace OHOS_CAMERA_SAMPLE
