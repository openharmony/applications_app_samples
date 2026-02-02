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
#include <cstdint>

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200
// preconfig mode
#define NO_PRECONFIG_MODE 1
#define TYPE_PRECONFIG_MODE 2
#define TYPE_RATIO_PRECONFIG_MODE 3

MediaLibrary_ErrorCode result = MEDIA_LIBRARY_OK;
OH_MediaAssetChangeRequest *g_changeRequest;
OH_MovingPhoto *movingPhoto;
const OH_ImageSourceNative *imageSourceNaive;
OH_MediaAssetManager *mediaAssetManager;
MediaLibrary_RequestId g_requestId;
MediaLibrary_RequestOptions requestOptions;
bool g_isMovingPhoto = false;
bool g_isSavingPhoto = true;
const char *URI;
char *g_mediaQualityCb;
MediaLibrary_DeliveryMode g_deliveryMode = MEDIA_LIBRARY_BALANCED_MODE;

static void *g_requestImageCallback = nullptr;
static void *g_requestImageQualityCallback = nullptr;
static OH_MediaAsset *g_mediaAsset = nullptr;

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
const int32_t ARGS_TWO = 2;
const int32_t BUFFER_SIZE = 100000;

NDKCamera::NDKCamera(CameraBuildingConfig config)
    : previewSurfaceId_(config.str),
      cameras_(nullptr),
      focusMode_(config.focusMode),
      cameraDeviceIndex_(config.cameraDeviceIndex),
      cameraOutputCapability_(nullptr),
      cameraInput_(nullptr),
      captureSession_(nullptr),
      size_(0),
      isCameraMuted_(nullptr),
      profile_(nullptr),
      photoSurfaceId_(nullptr),
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
      preconfigMode_(config.preconfigMode),
      isSuccess_(false),
      preconfigged_(false),
      photoOutputType_(config.photoOutputType),
      isMovingPhoto_(config.isMovingPhoto)
{
    valid_ = false;
    g_isMovingPhoto = config.isMovingPhoto;
    g_isSavingPhoto = config.isSavingPhoto;
    ReleaseCamera();
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager_);
    if (cameraManager_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Get CameraManager failed.");
    }

    ret = OH_CameraManager_CreateCaptureSession(cameraManager_, &captureSession_);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Create captureSession failed.");
    }

    auto itr1 = g_int32ToCameraSceneMode.find(config.sceneMode);
    if (itr1 != g_int32ToCameraSceneMode.end()) {
        sceneMode_ = itr1->second;
    }
    auto itr2 = g_int32ToCameraPreconfigType.find(config.preconfigType);
    if (itr2 != g_int32ToCameraPreconfigType.end()) {
        preconfigType_ = itr2->second;
    }
    auto itr3 = g_int32ToCameraPreconfigRatio.find(config.preconfigRatio);
    if (itr3 != g_int32ToCameraPreconfigRatio.end()) {
        preconfigRatio_ = itr3->second;
    }
    // expect CAMERA_OK
    ret = OH_CaptureSession_SetSessionMode(captureSession_, sceneMode_);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode sceneMode_: %{public}d!", sceneMode_);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode return with ret code: %{public}d!", ret);

    CaptureSessionRegisterCallback();
    GetSupportedCameras();
    GetSupportedSceneModes();
    GetSupportedOutputCapabilityWithSceneMode(sceneMode_);
    GetSupportedOutputCapability();
    CreatePreviewOutput();
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
        SessionRelease();
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
    SessionRelease();
    OH_LOG_ERROR(LOG_APP, " exit ReleaseSession");
    return ret_;
}

Camera_ErrorCode NDKCamera::SessionRelease(void)
{
    OH_LOG_ERROR(LOG_APP, " enter SessionRelease");
    Camera_ErrorCode ret = OH_CaptureSession_Release(captureSession_);
    captureSession_ = nullptr;
    OH_LOG_ERROR(LOG_APP, " exit SessionRelease");
    return ret;
}

Camera_ErrorCode NDKCamera::HasFlashFn(uint32_t mode)
{
    Camera_FlashMode flashMode = static_cast<Camera_FlashMode>(mode);
    // Check for flashing lights
    bool hasFlash = false;
    Camera_ErrorCode ret = OH_CaptureSession_HasFlash(captureSession_, &hasFlash);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_HasFlash failed.");
    }
    if (hasFlash) {
        OH_LOG_INFO(LOG_APP, "hasFlash success-----");
    } else {
        OH_LOG_ERROR(LOG_APP, "hasFlash fail-----");
    }

    // Check if the flash mode is supported
    bool isSupported = false;
    ret = OH_CaptureSession_IsFlashModeSupported(captureSession_, flashMode, &isSupported);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsFlashModeSupported failed.");
    }
    if (isSupported) {
        OH_LOG_INFO(LOG_APP, "isFlashModeSupported success-----");
    } else {
        OH_LOG_ERROR(LOG_APP, "isFlashModeSupported fail-----");
    }

    // Set flash mode
    ret = OH_CaptureSession_SetFlashMode(captureSession_, flashMode);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_SetFlashMode success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_SetFlashMode failed. %{public}d ", ret);
    }

    // Obtain the flash mode of the current device
    ret = OH_CaptureSession_GetFlashMode(captureSession_, &flashMode);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetFlashMode success. flashMode ?{public}d ", flashMode);
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_GetFlashMode failed. %d ", ret);
    }
    return ret;
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
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsVideoStabilizationModeSupported fail-----");
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode success. videoMode ?{public}f ", videoMode);
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode failed. %{public}d ", ret);
    }
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
    } else if (requestOption == ARGS_TWO) {
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
    Camera_ErrorCode ret = OH_CaptureSession_CommitConfig(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_CommitConfig success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_CommitConfig failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::SessionStart(void)
{
    Camera_ErrorCode ret = OH_CaptureSession_Start(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_Start success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_Start failed. %d ", ret);
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
        DRAWING_LOGD("NDKCamera::SessionFlowFn can not add input!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }

    // Add CameraInput to the session
    OH_LOG_INFO(LOG_APP, "session addInput.");
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);

    isSuccess_ = false;
    CanAddPreviewOutput(&isSuccess_);
    if (!isSuccess_) {
        DRAWING_LOGD("NDKCamera::SessionFlowFn can not add preview output!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }

    // Add previewOutput to the session
    OH_LOG_INFO(LOG_APP, "session add Preview Output.");
    ret = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);
    GetActivePreviewOutputProfile();

    DRAWING_LOGD("NDKCamera::SessionFlowFn hit at point 1 !");
    CreatePhotoOutputWithoutSurfaceId();
    DRAWING_LOGD("NDKCamera::SessionFlowFn hit at point 2 !");
    isSuccess_ = false;
    CanAddPhotoOutput(&isSuccess_);
    if (!isSuccess_) {
        DRAWING_LOGD("NDKCamera::SessionFlowFn hit at point 3 !");
    }
    DRAWING_LOGD("NDKCamera::SessionFlowFn hit at point 4 !");
    ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
    DRAWING_LOGD("NDKCamera::SessionFlowFn hit at point 5 !");

    DRAWING_LOGD("NDKCamera::CreatePhotoOutput register photo asset available callback!");
    PhotoOutputRegisterPhotoAssetAvailableCallback();
    // Submit configuration information
    OH_LOG_INFO(LOG_APP, "session commitConfig");
    ret = OH_CaptureSession_CommitConfig(captureSession_);

    InitPreviewRotation();

    // Start Session Work
    OH_LOG_INFO(LOG_APP, "session start");
    ret = OH_CaptureSession_Start(captureSession_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "session success");
    }

    // Start focusing
    OH_LOG_INFO(LOG_APP, "IsFocusMode start");
    ret = IsFocusMode(focusMode_);
    OH_LOG_INFO(LOG_APP, "IsFocusMode success");
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
    DRAWING_LOGD("NDKCamera::CreatePreviewOutput start!");
    isSuccess_ = false;
    if (preconfigMode_ == TYPE_RATIO_PRECONFIG_MODE) {
        ret_ = CanPreconfigWithRatio(&isSuccess_);
        if (ret_ != CAMERA_OK) {
            DRAWING_LOGD("NDKCamera::CreatePreviewOutput CanPreconfigWithRatio failed!");
        }
    } else if (preconfigMode_ == TYPE_PRECONFIG_MODE) {
        ret_ = CanPreconfig(&isSuccess_);
        if (ret_ != CAMERA_OK) {
            DRAWING_LOGD("NDKCamera::CreatePreviewOutput CanPreconfig failed!");
        }
    }

    if (preconfigMode_ == NO_PRECONFIG_MODE || !isSuccess_) {
        DRAWING_LOGD("NDKCamera::CreatePreviewOutput into normal branch!");
        profile_ = cameraOutputCapability_->previewProfiles[0];
        if (profile_ == nullptr) {
            OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
        }
        cameraProfile_ = cameraOutputCapability_->previewProfiles[0];

        ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, cameraProfile_, previewSurfaceId_, &previewOutput_);
        if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
        }
        PreviewOutputRegisterCallback();
        return ret_;
    } else {
        if (preconfigMode_ == TYPE_RATIO_PRECONFIG_MODE) {
            ret_ = PreconfigWithRatio();
        } else {
            ret_ = Preconfig();
        }
        preconfigged_ = true;
        ret_ = OH_CameraManager_CreatePreviewOutputUsedInPreconfig(cameraManager_, previewSurfaceId_, &previewOutput_);
        if (previewOutput_ == nullptr || ret_ != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
            return CAMERA_INVALID_ARGUMENT;
        }
        PreviewOutputRegisterCallback();
        return ret_;
    }
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput(char *photoSurfaceId)
{
    if (preconfigged_) {
        DRAWING_LOGD("NDKCamera::CreatePhotoOutput into preconfigged branch!");
        ret_ = OH_CameraManager_CreatePhotoOutputUsedInPreconfig(cameraManager_, photoSurfaceId, &photoOutput_);
        if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
            DRAWING_LOGD("OH_CameraManager_CreatePhotoOutputUsedInPreconfig failed!");
            OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
            return CAMERA_INVALID_ARGUMENT;
        }
        DRAWING_LOGD("OH_CameraManager_CreatePhotoOutputUsedInPreconfig return with ret code: %{public}d!", ret_);
        PhotoOutputRegisterCallback();
        return ret_;
    } else {
        DRAWING_LOGD("NDKCamera::CreatePhotoOutput into normal branch!");
        profile_ = cameraOutputCapability_->photoProfiles[0];
        if (profile_ == nullptr) {
            OH_LOG_ERROR(LOG_APP, "Get photoProfiles failed.");
            return CAMERA_INVALID_ARGUMENT;
        }

        if (photoSurfaceId == nullptr) {
            OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
            return CAMERA_INVALID_ARGUMENT;
        }

        ret_ = OH_CameraManager_CreatePhotoOutput(cameraManager_, profile_, photoSurfaceId, &photoOutput_);
        PhotoOutputRegisterCallback();
        return ret_;
    }
}

Camera_ErrorCode NDKCamera::CreatePhotoOutputWithoutSurfaceId()
{
    DRAWING_LOGD("NDKCamera::CreatePhotoOutput into createWithoutSurfaceID branch!");
    cameraProfile_ = cameraOutputCapability_->photoProfiles[0];
    ret_ = OH_CameraManager_CreatePhotoOutputWithoutSurface(cameraManager_, cameraProfile_, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("OH_CameraManager_CreatePhotoOutputWithoutSurface failed!");
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CreatePhotoOutput register photo asset available callback!");
    PhotoOutputRegisterPhotoAssetAvailableCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput(char *videoId)
{
    DRAWING_LOGD("NDKCamera::CreateVideoOutput start!");
    if (preconfigged_) {
        DRAWING_LOGD("NDKCamera::CreateVideoOutput into preconfigged_ branch!");
        ret_ = OH_CameraManager_CreateVideoOutputUsedInPreconfig(cameraManager_, videoId, &videoOutput_);
        if (videoOutput_ == nullptr || ret_ != CAMERA_OK) {
            DRAWING_LOGD("OH_CameraManager_CreateVideoOutputUsedInPreconfig failed!");
            OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
            return CAMERA_INVALID_ARGUMENT;
        }
        DRAWING_LOGD("OH_CameraManager_CreateVideoOutputUsedInPreconfig return with ret code: %{public}d!", ret_);
        return ret_;
    } else {
        DRAWING_LOGD("NDKCamera::CreateVideoOutput into normal branch!");
        videoProfile_ = cameraOutputCapability_->videoProfiles[0];

        if (videoProfile_ == nullptr) {
            OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
            return CAMERA_INVALID_ARGUMENT;
        }
        ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, videoProfile_, videoId, &videoOutput_);
        if (videoId == nullptr || videoOutput_ == nullptr || ret_ != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
            return CAMERA_INVALID_ARGUMENT;
        }

        return ret_;
    }
}

Camera_ErrorCode NDKCamera::AddVideoOutput(void)
{
    Camera_ErrorCode ret = OH_CaptureSession_AddVideoOutput(captureSession_, videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddVideoOutput success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddVideoOutput failed. %d ", ret);
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

Camera_ErrorCode NDKCamera::CreateMetadataOutput(void)
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
    MetadataOutputRegisterCallback();
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

Camera_ErrorCode NDKCamera::StartVideo(char *videoId, char *photoId)
{
    OH_LOG_INFO(LOG_APP, "StartVideo begin.");
    Camera_ErrorCode ret = SessionStop();
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "SessionStop success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "SessionStop failed. %d ", ret);
    }
    ret = SessionBegin();
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "SessionBegin success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "SessionBegin failed. %d ", ret);
    }
    OH_CaptureSession_RemovePhotoOutput(captureSession_, photoOutput_);
    CreatePhotoOutput(photoId);
    // expect CAMERA_SERVICE_FATAL_ERROR
    ret = OH_CaptureSession_SetSessionMode(captureSession_, Camera_SceneMode::NORMAL_PHOTO);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode NORMAL_PHOTO return with ret code: %{public}d!", ret);
    isSuccess_ = false;
    CanAddPhotoOutput(&isSuccess_);
    if (!isSuccess_) {
        DRAWING_LOGD("NDKCamera::StartVideo can not add photo output!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }
    AddPhotoOutput();
    GetActivePhotoOutputProfile();
    CreateVideoOutput(videoId);
    // expect CAMERA_SERVICE_FATAL_ERROR
    ret = OH_CaptureSession_SetSessionMode(captureSession_, Camera_SceneMode::NORMAL_VIDEO);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode NORMAL_VIDEO return with ret code: %{public}d!", ret);
    isSuccess_ = false;
    CanAddVideoOutput(&isSuccess_);
    if (!isSuccess_) {
        DRAWING_LOGD("NDKCamera::StartVideo can not add video output!");
        return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
    }
    AddVideoOutput();
    GetActiveVideoOutputProfile();
    SessionCommitConfig();
    SessionStart();
    VideoOutputRegisterCallback();
    return ret;
}

Camera_ErrorCode NDKCamera::VideoOutputStart(void)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputStart begin.");
    Camera_ErrorCode ret = OH_VideoOutput_Start(videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_VideoOutput_Start success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_Start failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::StartPhoto(char *mSurfaceId)
{
    Camera_ErrorCode ret = CAMERA_OK;
        ret = SessionStop();
        if (ret == CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "SessionStop success.");
        } else {
            OH_LOG_ERROR(LOG_APP, "SessionStop failed. %d ", ret);
        }
        ret = SessionBegin();
        if (ret == CAMERA_OK) {
            OH_LOG_INFO(LOG_APP, "SessionBegin success.");
        } else {
            OH_LOG_ERROR(LOG_APP, "SessionBegin failed. %d ", ret);
        }
        OH_LOG_INFO(LOG_APP, "startPhoto begin.");
        ret = CreatePhotoOutput(mSurfaceId);
        OH_LOG_INFO(LOG_APP, "startPhoto CreatePhotoOutput ret = %{public}d.", ret);
        // expect CAMERA_SERVICE_FATAL_ERROR
        ret = OH_CaptureSession_SetSessionMode(captureSession_, Camera_SceneMode::NORMAL_PHOTO);
        DRAWING_LOGD("OH_CaptureSession_SetSessionMode NORMAL_PHOTO return with ret code: %{public}d!", ret);

        isSuccess_ = false;
        CanAddPhotoOutput(&isSuccess_);
        if (!isSuccess_) {
            DRAWING_LOGD("NDKCamera::StartPhoto can not add photo output!");
            return Camera_ErrorCode::CAMERA_OPERATION_NOT_ALLOWED;
        }
        ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
        OH_LOG_INFO(LOG_APP, "startPhoto AddPhotoOutput ret = %{public}d.", ret);
        GetActivePhotoOutputProfile();
        ret = SessionCommitConfig();

        OH_LOG_INFO(LOG_APP, "startPhoto SessionCommitConfig ret = %{public}d.", ret);
        ret = SessionStart();
        OH_LOG_INFO(LOG_APP, "startPhoto SessionStart ret = %{public}d.", ret);
    OH_LOG_INFO(LOG_APP, "startPhoto OH_PhotoOutput_Capture ret = %{public}d.", ret);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    takePictureTimes++;
    return ret_;
}

Camera_ErrorCode NDKCamera::StartPhotoWithOutSurfaceId()
{
    Camera_ErrorCode ret = CAMERA_OK;
    return ret_;
}

// exposure mode
Camera_ErrorCode NDKCamera::IsExposureModeSupportedFn(uint32_t mode)
{
    OH_LOG_INFO(LOG_APP, "IsExposureModeSupportedFn start.");
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
    OH_LOG_INFO(LOG_APP, "IsExposureModeSupportedFn end.");
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

Camera_ErrorCode NDKCamera::EnableMovingPhoto(bool isMovingPhoto)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::EnableMovingPhoto start!");
    bool isMovingSupported = false;
    Camera_ErrorCode ret = OH_PhotoOutput_IsMovingPhotoSupported(photoOutput_, &isMovingSupported);
    if (ret != CAMERA_OK || !isMovingSupported) {
        OH_LOG_ERROR(LOG_APP, "NDKCamera::EnableMovingPhoto failed, isMovingPhoto: %{public}b", isMovingSupported);
    } else {
        isMovingSupported = isMovingPhoto ? true : false;
    }
    ret = OH_PhotoOutput_EnableMovingPhoto(photoOutput_, isMovingPhoto);
    OH_LOG_INFO(LOG_APP, "NDKCamera::EnableMovingPhoto end!");
    return ret;
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
    videoProfile_ = cameraOutputCapability_->videoProfiles[0];
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.width;
}

int32_t NDKCamera::GetVideoFrameHeight(void)
{
    videoProfile_ = cameraOutputCapability_->videoProfiles[0];
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.height;
}

int32_t NDKCamera::GetVideoFrameRate(void)
{
    videoProfile_ = cameraOutputCapability_->videoProfiles[0];
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
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

    OH_LOG_INFO(LOG_APP,
        "TakePictureWithPhotoSettings get quality %{public}d, rotation %{public}d, mirror %{public}d, "
        "latitude, %{public}d, longitude %{public}d, altitude %{public}d",
        photoSetting.quality, photoSetting.rotation, photoSetting.mirror, photoSetting.location->latitude,
        photoSetting.location->longitude, photoSetting.location->altitude);

    OH_LOG_ERROR(LOG_APP, "takePicture TakePictureWithPhotoSettings ret = %{public}d.", ret);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret;
}

// CameraManager Callback
// 监听cameraStatus信息。
void CameraManagerStatusCallback(Camera_Manager *cameraManager, Camera_StatusInfo *status)
{
    OH_LOG_INFO(LOG_APP, "CameraManagerStatusCallback is called");
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
// 监听cameraInput错误信息。
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
    OH_LOG_INFO(LOG_APP, "PreviewOutputOnFrameStart");
}

void PreviewOutputOnFrameEnd(Camera_PreviewOutput *previewOutput, int32_t frameCount)
{
    OH_LOG_INFO(LOG_APP, "PreviewOutput frameCount = %{public}d", frameCount);
}

void PreviewOutputOnError(Camera_PreviewOutput *previewOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "PreviewOutput errorCode = %{public}d", errorCode);
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
    OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameStart");
}

void VideoOutputOnFrameEnd(Camera_VideoOutput *videoOutput, int32_t frameCount)
{
    OH_LOG_INFO(LOG_APP, "VideoOutput frameCount = %{public}d", frameCount);
}

void VideoOutputOnError(Camera_VideoOutput *videoOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "VideoOutput errorCode = %{public}d", errorCode);
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
    ret_ = OH_VideoOutput_RegisterCallback(videoOutput_, GetVideoOutputListener());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_RegisterCallback failed.");
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

Camera_ErrorCode NDKCamera::MetadataOutputRegisterCallback(void)
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
    DRAWING_LOGD("CaptureSession_Callbacks CaptureSessionOnFocusStateChange");
    OH_LOG_INFO(LOG_APP, "CaptureSessionOnFocusStateChange");
}

void CaptureSessionOnError(Camera_CaptureSession *session, Camera_ErrorCode errorCode)
{
    DRAWING_LOGD("CaptureSession_Callbacks CaptureSessionOnError");
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

// wang.qg code
Camera_ErrorCode NDKCamera::GetSupportedSceneModes(void)
{
    DRAWING_LOGD("NDKCamera::GetSupportedSceneModes start!");
    DRAWING_LOGD("NDKCamera::GetSupportedSceneModes cameraDeviceIndex_: %{public}d", cameraDeviceIndex_);
    ret_ = OH_CameraManager_GetSupportedSceneModes(&cameras_[cameraDeviceIndex_], &sceneModes_, &sceneModeSize_);
    if (sceneModes_ == nullptr || &sceneModeSize_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::GetSupportedSceneModes failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::GetSupportedSceneModes sceneModeSize_: %{public}d", sceneModeSize_);
    for (uint32_t i = 0; i < sceneModeSize_; i++) {
        DRAWING_LOGD("NDKCamera::GetSupportedSceneModes sceneMode_: %{public}d", sceneModes_[i]);
    }
    DRAWING_LOGD("NDKCamera::GetSupportedSceneModes return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetSupportedOutputCapabilityWithSceneMode(Camera_SceneMode sceneMode)
{
    DRAWING_LOGD("NDKCamera::GetSupportedOutputCapabilityWithSceneMode start! sceneMode: %{public}d", sceneMode);
    ret_ = OH_CameraManager_GetSupportedCameraOutputCapabilityWithSceneMode(cameraManager_,
        &cameras_[cameraDeviceIndex_], sceneMode, &cameraOutputCapability_);
    if (cameraOutputCapability_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::GetSupportedOutputCapabilityWithSceneMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    DRAWING_LOGD("NDKCamera::GetSupportedOutputCapabilityWithSceneMode sceneMode: %{public}d "
        "return with ret code: %{public}d!",
        sceneMode, ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddInput(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanAddInput start!");
    ret_ = OH_CaptureSession_CanAddInput(captureSession_, cameraInput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanAddInput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanAddInput isSuccess: %{public}d!", *isSuccess);
    DRAWING_LOGD("NDKCamera::CanAddInput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddPreviewOutput(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanAddPreviewOutput start!");
    ret_ = OH_CaptureSession_CanAddPreviewOutput(captureSession_, previewOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanAddPreviewOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanAddPreviewOutput isSuccess: %{public}d!", *isSuccess);
    DRAWING_LOGD("NDKCamera::CanAddPreviewOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddPhotoOutput(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanAddPhotoOutput start!");
    ret_ = OH_CaptureSession_CanAddPhotoOutput(captureSession_, photoOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanAddPhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanAddPhotoOutput isSuccess: %{public}d!", *isSuccess);
    DRAWING_LOGD("NDKCamera::CanAddPhotoOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanAddVideoOutput(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanAddVideoOutput start!");
    ret_ = OH_CaptureSession_CanAddVideoOutput(captureSession_, videoOutput_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanAddVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanAddVideoOutput isSuccess: %{public}d!", *isSuccess);
    DRAWING_LOGD("NDKCamera::CanAddVideoOutput return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanPreconfig(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanPreconfig start!");
    ret_ = OH_CaptureSession_CanPreconfig(captureSession_, preconfigType_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanPreconfig failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanPreconfig isSuccess: %{public}d, preconfigTyep: %{public}d!", *isSuccess,
        preconfigType_);
    DRAWING_LOGD("NDKCamera::CanPreconfig return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::Preconfig(void)
{
    DRAWING_LOGD("NDKCamera::Preconfig start!");
    ret_ = OH_CaptureSession_Preconfig(captureSession_, preconfigType_);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::Preconfig failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::Preconfig return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::CanPreconfigWithRatio(bool *isSuccess)
{
    DRAWING_LOGD("NDKCamera::CanPreconfigWithRatio start!");
    ret_ = OH_CaptureSession_CanPreconfigWithRatio(captureSession_, preconfigType_, preconfigRatio_, isSuccess);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::CanPreconfigWithRatio failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::CanPreconfigWithRatio isSuccess: %{public}d, type: %{public}d, ratio: %{public}d!",
        *isSuccess, preconfigType_, preconfigRatio_);
    DRAWING_LOGD("NDKCamera::CanPreconfigWithRatio return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::PreconfigWithRatio(void)
{
    DRAWING_LOGD("NDKCamera::PreconfigWithRatio start!");
    ret_ = OH_CaptureSession_PreconfigWithRatio(captureSession_, preconfigType_, preconfigRatio_);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::PreconfigWithRatio failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::PreconfigWithRatio return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActivePreviewOutputProfile(void)
{
    DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile start!");
    ret_ = OH_PreviewOutput_GetActiveProfile(previewOutput_, &activePreviewProfile_);
    if (activePreviewProfile_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile activePreviewProfile_ format: %{public}d!",
        activePreviewProfile_->format);
    DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile activePreviewProfile_ width: %{public}d!",
        activePreviewProfile_->size.width);
    DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile activePreviewProfile_ height: %{public}d!",
        activePreviewProfile_->size.height);
    DRAWING_LOGD("NDKCamera::GetActivePreviewOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActivePhotoOutputProfile(void)
{
    DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile start!");
    ret_ = OH_PhotoOutput_GetActiveProfile(photoOutput_, &activePhotoProfile_);
    if (activePhotoProfile_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile activePhotoProfile_ format: %{public}d!",
        activePhotoProfile_->format);
    DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile activePhotoProfile_ width: %{public}d!",
        activePhotoProfile_->size.width);
    DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile activePhotoProfile_ height: %{public}d!",
        activePhotoProfile_->size.height);
    DRAWING_LOGD("NDKCamera::GetActivePhotoOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}
void onPhotoAvailable(Camera_PhotoOutput *photoOutput, OH_PhotoNative *photo)
{
    DRAWING_LOGD("[RM005 log] onPhotoAvailable start!");
    NDKCamera::PhotoNativeGetMainImage(photo);
    NDKCamera::PhotoNativeRelease(photo);
    DRAWING_LOGD("[RM005 log] onPhotoAvailable finish!");
}
Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAvailableCallback(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAvailableCallback start!");
    ret_ = OH_PhotoOutput_RegisterPhotoAvailableCallback(photoOutput_, onPhotoAvailable);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAvailableCallback failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAvailableCallback return with ret code: %{public}d!",
        ret_);
    return ret_;
}
void onPhotoAssetAvailable(Camera_PhotoOutput *photoOutput, OH_MediaAsset *mediaAsset)
{
    if (mediaAsset == nullptr) {
        DRAWING_LOGI("[RM005 log] onPhotoAssetAvailable mediaAsset is nullptr !");
        return;
    }
    DRAWING_LOGD("[RM005 log] onPhotoAssetAvailable start!");
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
    DRAWING_LOGD("[RM005 log] onPhotoAssetAvailable finish!");
    return;
}
Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback start!");
    MediaAssetManagerCreate();
    ret_ = OH_PhotoOutput_RegisterPhotoAssetAvailableCallback(photoOutput_, onPhotoAssetAvailable);
    if (ret_ != CAMERA_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback failed.");
    }
    DRAWING_LOGD(
        "[RM005 log] NDKCamera::PhotoOutputRegisterPhotoAssetAvailableCallback return with ret code: %{public}d!",
        ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::GetActiveVideoOutputProfile(void)
{
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile start!");
    ret_ = OH_VideoOutput_GetActiveProfile(videoOutput_, &activeVideoProfile_);
    if (activeVideoProfile_ == nullptr || ret_ != CAMERA_OK) {
        DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ format: %{public}d!",
        activeVideoProfile_->format);
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ width: %{public}d!",
        activeVideoProfile_->size.width);
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ height: %{public}d!",
        activeVideoProfile_->size.height);
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ range.min: %{public}d!",
        activeVideoProfile_->range.min);
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile activeVideoProfile_ range.max: %{public}d!",
        activeVideoProfile_->range.max);
    DRAWING_LOGD("NDKCamera::GetActiveVideoOutputProfile return with ret code: %{public}d!", ret_);
    return ret_;
}
Camera_ErrorCode NDKCamera::PhotoNativeGetMainImage(OH_PhotoNative *photoNative)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeGetMainImage start!");
    Camera_ErrorCode result = CAMERA_OK;
    OH_ImageNative *imageNative = nullptr;
    result = OH_PhotoNative_GetMainImage(photoNative, &imageNative);
    if (imageNative == nullptr || result != CAMERA_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeGetMainImage failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeGetMainImage return with ret code: %{public}d!", result);
    /* Todo: save 'imageNative' into the device. */
    return result;
}
Camera_ErrorCode NDKCamera::PhotoNativeRelease(OH_PhotoNative *photoNative)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeRelease start!");
    Camera_ErrorCode result = CAMERA_OK;
    result = OH_PhotoNative_Release(photoNative);
    if (result != CAMERA_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeRelease failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::PhotoNativeRelease return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetUri(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetUri start!");
    result = OH_MediaAsset_GetUri(mediaAsset, &URI);
    if (URI == nullptr || result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetUri failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetUri uri: %{public}s", URI);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetUri return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDisplayName(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDisplayName start!");
    const char *displayName = nullptr;
    result = OH_MediaAsset_GetDisplayName(mediaAsset, &displayName);
    if (displayName == nullptr || result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDisplayName failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDisplayName displayName: %{public}s", displayName);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDisplayName return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetSize(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetSize start!");
    uint32_t mediaAssetSize;
    result = OH_MediaAsset_GetSize(mediaAsset, &mediaAssetSize);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetSize failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetSize mediaAssetSize: %{public}d", mediaAssetSize);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetSize return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDateModifiedMs(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDateModifiedMs start!");
    uint32_t dateModifiedMs;
    result = OH_MediaAsset_GetDateModifiedMs(mediaAsset, &dateModifiedMs);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDateModifiedMs failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDateModifiedMs dateModifiedMs: %{public}lu", dateModifiedMs);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetDateModifiedMs return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetWidth(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetWidth start!");
    uint32_t width;
    result = OH_MediaAsset_GetWidth(mediaAsset, &width);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetWidth failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetWidth width: %{public}d", width);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetWidth return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetHeight(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetHeight start!");
    uint32_t height;
    result = OH_MediaAsset_GetHeight(mediaAsset, &height);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetHeight failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetHeight height: %{public}d", height);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetHeight return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetOrientation(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetOrientation start!");
    uint32_t orientation;
    result = OH_MediaAsset_GetOrientation(mediaAsset, &orientation);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetOrientation failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetOrientation orientation: %{public}d", orientation);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetGetOrientation return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetRelease()
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetRelease start!");
    result = OH_MediaAsset_Release(g_mediaAsset);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetRelease failed.");
    }
    g_mediaAsset = nullptr;
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetRelease return with ret code: %{public}d!", result);
    return result;
}

// [Start deferred_photo]
MediaLibrary_ErrorCode NDKCamera::MediaAssetChangeRequest(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetChangeRequest start!");
    MediaAssetChangeRequestCreate(mediaAsset);
    MediaAssetManagerRequestImage(mediaAsset);
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetChangeRequest finish!");
    return MEDIA_LIBRARY_OK;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetChangeRequestCreate(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetChangeRequestCreate start!");
    g_changeRequest = OH_MediaAssetChangeRequest_Create(mediaAsset);
    if (g_changeRequest == nullptr) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetChangeRequestCreate failed.");
    }
    return MEDIA_LIBRARY_OK;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestAddResourceWithBuffer(OH_ImageSourceNative *imageSourceNative)
{
    DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer start!");
    size_t bufferSize = BUFFER_SIZE;
    char buffer[BUFFER_SIZE];
    int fd = open("/data/storage/el2/base/haps/test.jpg", O_RDONLY);
    int fr = read(fd, buffer, bufferSize);
    if (fr == -1) {
        DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer read failed.");
        return MEDIA_LIBRARY_OK;
    }
    if (fr == BUFFER_SIZE) {
        DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer read not complete.");
        return MEDIA_LIBRARY_OK;
    }
    result = OH_MediaAssetChangeRequest_AddResourceWithBuffer(g_changeRequest,
        MediaLibrary_ResourceType::MEDIA_LIBRARY_IMAGE_RESOURCE, (uint8_t *)buffer, (uint32_t)bufferSize);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer failed.");
        DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer failed %{public}d.", result);
        return MEDIA_LIBRARY_OK;
    }
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD(
            "[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer OH_MediaAccessHelper_ApplyChanges failed.");
        return MEDIA_LIBRARY_OK;
    }
    DRAWING_LOGD("[RM003 log] NDKCamera::ChangeRequestAddResourceWithBuffer OH_MediaAccessHelper_ApplyChanges return "
                 "with ret code: %{public}d!",
        result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestSaveCameraPhoto(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestSaveCameraPhoto start!");
    result = OH_MediaAssetChangeRequest_SaveCameraPhoto(g_changeRequest,
        MediaLibrary_ImageFileType::MEDIA_LIBRARY_IMAGE_JPEG);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD(
            "[RM005 log] NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAssetChangeRequest_SaveCameraPhoto failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAssetChangeRequest_SaveCameraPhoto "
                 "return with ret code: %{public}d!",
        result);
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAccessHelper_ApplyChanges failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestSaveCameraPhoto OH_MediaAccessHelper_ApplyChanges return with "
                 "ret code: %{public}d!",
        result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestDiscardCameraPhoto(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestDiscardCameraPhoto start!");
    result = OH_MediaAssetChangeRequest_DiscardCameraPhoto(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestDiscardCameraPhoto "
                     "OH_MediaAssetChangeRequest_DiscardCameraPhoto failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAssetChangeRequest_DiscardCameraPhoto "
                 "return with ret code: %{public}d!",
        result);
    result = OH_MediaAccessHelper_ApplyChanges(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD(
            "[RM005 log] NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAccessHelper_ApplyChanges failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestDiscardCameraPhoto OH_MediaAccessHelper_ApplyChanges return with "
                 "ret code: %{public}d!",
        result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::ChangeRequestRelease(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestRelease start!");
    result = OH_MediaAssetChangeRequest_Release(g_changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestRelease failed.");
    }
    g_changeRequest = nullptr;
    DRAWING_LOGD("[RM005 log] NDKCamera::ChangeRequestRelease return with ret code: %{public}d!", result);
    return result;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetManagerCreate(void)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetManagerCreate start!");
    mediaAssetManager = OH_MediaAssetManager_Create();
    if (mediaAssetManager == nullptr) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetManagerCreate failed.");
    }
    return MEDIA_LIBRARY_OK;
}
void OnRequsetImageDataPreparedWithDetails(MediaLibrary_ErrorCode result, MediaLibrary_RequestId requestId,
    MediaLibrary_MediaQuality mediaQuality, MediaLibrary_MediaContentType type, OH_ImageSourceNative *imageSourceNative)
{
    auto cb = (void (*)(char *))(g_requestImageCallback);
    auto qCb = (void (*)(char *))(g_requestImageQualityCallback);
    DRAWING_LOGD("[RM005 log] OnRequsetImageDataPreparedWithDetails start!");
    if (mediaQuality == MediaLibrary_MediaQuality::MEDIA_LIBRARY_QUALITY_FAST) {
        DRAWING_LOGD("[RM005 log] OnRequsetImageDataPreparedWithDetails into fast quality mode!");
        g_mediaQualityCb = "fast";
        qCb(g_mediaQualityCb);
    } else {
        DRAWING_LOGD("[RM005 log] OnRequsetImageDataPreparedWithDetails into high quality mode!");
        g_mediaQualityCb = "high";
        qCb(g_mediaQualityCb);
    }
    DRAWING_LOGD("[RM005 log] OnRequsetImageDataPreparedWithDetails GetUri uri_ = %{public}s", URI);
    cb(const_cast<char *>(URI));
    NDKCamera::ChangeRequestAddResourceWithBuffer(imageSourceNative);
    return;
}
MediaLibrary_ErrorCode NDKCamera::MediaAssetManagerRequestImage(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetManagerRequestImage start! g_deliveryMode = %{public}d",
        g_deliveryMode);
    requestOptions.deliveryMode = g_deliveryMode;
    result = OH_MediaAssetManager_RequestImage(mediaAssetManager, mediaAsset, requestOptions, &g_requestId,
        OnRequsetImageDataPreparedWithDetails);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetManagerRequestImage failed.");
    }
    DRAWING_LOGD("[RM005 log] NDKCamera::MediaAssetManagerRequestImage return with ret code: %{public}d!", result);
    return result;
}
// [End deferred_photo]

Camera_ErrorCode NDKCamera::IsVideoModeAvailable(bool *available)
{
    if (available == nullptr) {
        return CAMERA_INVALID_ARGUMENT;
    }
    *available = false;

    Camera_OutputCapability *videoCap = nullptr;
    // 明确以 NORMAL_VIDEO 场景拉一份“带场景”的能力，最稳妥
    Camera_ErrorCode ret = OH_CameraManager_GetSupportedCameraOutputCapabilityWithSceneMode(cameraManager_,
        &cameras_[cameraDeviceIndex_], Camera_SceneMode::NORMAL_VIDEO, &videoCap);
    if (ret != CAMERA_OK || videoCap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get video capability failed. ret=%{public}d", ret);
        return ret;
    }

    if (videoCap->videoProfilesSize > 0 && videoCap->videoProfiles[0] != nullptr) {
        *available = true;
    }

    // 释放临时能力对象，避免泄漏
    (void)OH_CameraManager_DeleteSupportedCameraOutputCapability(cameraManager_, videoCap);
    return CAMERA_OK;
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
} // namespace OHOS_CAMERA_SAMPLE
