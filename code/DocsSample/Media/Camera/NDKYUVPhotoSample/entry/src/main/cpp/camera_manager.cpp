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

MediaLibrary_ErrorCode result = MEDIA_LIBRARY_OK;
const char *URI;


namespace OHOS_CAMERA_SAMPLE {
NDKCamera *NDKCamera::ndkCamera_ = nullptr;
std::mutex NDKCamera::mtx_;
const int32_t ARGS_TWO = 2;
const int32_t BUFFER_SIZE = 100000;
static bool g_captureReadyFlag = false;
static OH_PixelmapNative *pixelMap = nullptr;

NDKCamera::NDKCamera(CameraBuildingConfig config)
    : previewSurfaceId_(config.str),
      cameras_(nullptr),
      focusMode_(config.focusMode),
      cameraDeviceIndex_(config.cameraDeviceIndex),
      cameraOutputCapability_(nullptr),
      cameraInput_(nullptr),
      captureSession_(nullptr),
      size_(0),
      profile_(nullptr),
      previewOutput_(nullptr),
      photoOutput_(nullptr),
      isExposureModeSupported_(false),
      isFocusModeSupported_(false),
      exposureMode_(EXPOSURE_MODE_LOCKED),
      minExposureBias_(0),
      maxExposureBias_(0),
      step_(0),
      ret_(CAMERA_OK),
      sceneMode_(NORMAL_PHOTO),
      sceneModes_(nullptr),
      sceneModeSize_(0),
      isSuccess_(false)
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
    // expect CAMERA_OK
    ret = OH_CaptureSession_SetSessionMode(captureSession_, sceneMode_);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode sceneMode_: %{public}d!", sceneMode_);
    DRAWING_LOGD("OH_CaptureSession_SetSessionMode return with ret code: %{public}d!", ret);

    CaptureSessionRegisterCallback();
    GetSupportedCameras();
    GetSupportedSceneModes();
    cameraOutputCapability_ = GetSupportedFullCameraOutputCapability(cameraManager_,
        cameras_[cameraDeviceIndex_]);
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

    OH_LOG_ERROR(LOG_APP, "~NDKCamera exit");
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
        CameraInputRelease();
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
    
    CreatePhotoOutputWithoutSurfaceId();
    isSuccess_ = false;
    CanAddPhotoOutput(&isSuccess_);
    if (!isSuccess_) {
        DRAWING_LOGD("NDKCamera::SessionFlowFn CanAddPhotoOutput fail !");
    }
    ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
    
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

    DRAWING_LOGD("NDKCamera::CreatePreviewOutput into normal branch!");
    if (profile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
    }

    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, profile_, previewSurfaceId_, &previewOutput_);
    if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
    }
    PreviewOutputRegisterCallback();
    return ret_;
}

// [Start create_photo_output]
Camera_ErrorCode NDKCamera::CreatePhotoOutputWithoutSurfaceId()
{
    DRAWING_LOGD("NDKCamera::CreatePhotoOutputWithoutSurfaceId into createWithoutSurfaceID branch!");
    OH_LOG_INFO(LOG_APP, "CreatePhotoOutputWithoutSurfaceId format: %{public}d!", cameraProfile_->format);
    OH_LOG_INFO(LOG_APP, "CreatePhotoOutputWithoutSurfaceId width: %{public}d!", cameraProfile_->size.width);
    OH_LOG_INFO(LOG_APP, "CreatePhotoOutputWithoutSurfaceId height: %{public}d!", cameraProfile_->size.height);
    // 无需传入surfaceId，直接创建拍照流。
    ret_ = OH_CameraManager_CreatePhotoOutputWithoutSurface(cameraManager_, cameraProfile_, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutputWithoutSurfaceId failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    PhotoOutputRegisterCallback();
    return ret_;
}
// [End create_photo_output]

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

Camera_ErrorCode NDKCamera::SetPhotoOutputCallback(bool isSinglePhoto)
{
    if (isSinglePhoto) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::SetPhotoOutputCallback enter single!");
        UnregisterPhotoAssetAvailable(photoOutput_);
        PhotoOutputRegisterPhotoAvailableCallback(photoOutput_);
    } else {
        OH_LOG_INFO(LOG_APP, "NDKCamera::SetPhotoOutputCallback enter deferred!");
        PhotoOutputUnRegisterPhotoAvailableCallback(photoOutput_);
        RegisterPhotoAssetAvailable(photoOutput_);
    }
    return CAMERA_OK;
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

// [Start take_picture]
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
// [End take_picture]

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
// [Start photo_output_start_callback]
void PhotoOutputOnFrameStart(Camera_PhotoOutput *photoOutput)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameStart");
}

void PhotoOutputOnFrameShutter(Camera_PhotoOutput *photoOutput, Camera_FrameShutterInfo *info)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameShutter");
}
// [End photo_output_start_callback]

// [Start photo_output_end_callback]
void PhotoOutputOnFrameEnd(Camera_PhotoOutput *photoOutput, int32_t frameCount)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutput frameCount = %{public}d", frameCount);
}
// [End photo_output_end_callback]

// [Start photo_output_error_callback]
void PhotoOutputOnError(Camera_PhotoOutput *photoOutput, Camera_ErrorCode errorCode)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutput errorCode = %{public}d", errorCode);
}
// [End photo_output_error_callback]

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

// [Start get_full_outputCapability]
Camera_OutputCapability* NDKCamera::GetSupportedFullCameraOutputCapability(Camera_Manager* cameraManager,
    Camera_Device &camera)
{
    Camera_OutputCapability* cameraOutputCapability = nullptr;
    // 获取相机设备支持的输出流能力。
    const Camera_Profile* previewProfile = nullptr;
    const Camera_Profile* photoProfile = nullptr;
    Camera_ErrorCode ret = OH_CameraManager_GetSupportedFullCameraOutputCapabilityWithSceneMode(cameraManager, &camera,
        Camera_SceneMode::NORMAL_PHOTO, &cameraOutputCapability);
    if (cameraOutputCapability == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CameraManager_GetSupportedCameraOutputCapability failed.");
        return cameraOutputCapability;
    }
    // 以NORMAL_PHOTO模式为例，需要添加预览流、拍照流。
    if (cameraOutputCapability->previewProfiles == nullptr) {
        OH_LOG_ERROR(LOG_APP, "previewProfiles == null");
    } else {
        // 根据所需从cameraOutputCapability->previewProfiles中选择合适的预览分辨率。
        previewProfile = cameraOutputCapability->previewProfiles[0];
        profile_ = previewProfile;
    }
    if (cameraOutputCapability->photoProfiles == nullptr) {
        OH_LOG_ERROR(LOG_APP, "photoProfiles == null");
    } else {
        // 根据所需从cameraOutputCapability->photoProfiles中选择yuv格式的拍照流。
        // 若没有yuv格式的拍照流，则选择当前模式下第一个支持的拍照流。
        for (int i = 0; i < cameraOutputCapability->photoProfilesSize; i++) {
            if (cameraOutputCapability->photoProfiles[i]->format == CAMERA_FORMAT_YUV_420_SP) {
                photoProfile = cameraOutputCapability->photoProfiles[i];
                break;
            }
        }
        if (photoProfile->format != CAMERA_FORMAT_YUV_420_SP) {
            photoProfile = cameraOutputCapability->photoProfiles[0];
        }
        cameraProfile_ = photoProfile;
    }
    return cameraOutputCapability;
}
// [End get_full_outputCapability]

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

// [Start get_media_asset_info]
MediaLibrary_ErrorCode NDKCamera::MediaAssetGetUri(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetUri start!");
    result = OH_MediaAsset_GetUri(mediaAsset, &URI);
    if (URI == nullptr || result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetUri failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetUri uri: %{public}s", URI);
    DRAWING_LOGD("NDKCamera::MediaAssetGetUri return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDisplayName(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetDisplayName start!");
    const char *displayName = nullptr;
    result = OH_MediaAsset_GetDisplayName(mediaAsset, &displayName);
    if (displayName == nullptr || result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetDisplayName failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetDisplayName displayName: %{public}s", displayName);
    DRAWING_LOGD("NDKCamera::MediaAssetGetDisplayName return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetSize(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetSize start!");
    uint32_t mediaAssetSize;
    result = OH_MediaAsset_GetSize(mediaAsset, &mediaAssetSize);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetSize failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetSize mediaAssetSize: %{public}d", mediaAssetSize);
    DRAWING_LOGD("NDKCamera::MediaAssetGetSize return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetDateModifiedMs(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetDateModifiedMs start!");
    uint32_t dateModifiedMs;
    result = OH_MediaAsset_GetDateModifiedMs(mediaAsset, &dateModifiedMs);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetDateModifiedMs failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetDateModifiedMs dateModifiedMs: %{public}lu", dateModifiedMs);
    DRAWING_LOGD("NDKCamera::MediaAssetGetDateModifiedMs return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetWidth(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetWidth start!");
    uint32_t width;
    result = OH_MediaAsset_GetWidth(mediaAsset, &width);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetWidth failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetWidth width: %{public}d", width);
    DRAWING_LOGD("NDKCamera::MediaAssetGetWidth return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetHeight(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetHeight start!");
    uint32_t height;
    result = OH_MediaAsset_GetHeight(mediaAsset, &height);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetHeight failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetHeight height: %{public}d", height);
    DRAWING_LOGD("NDKCamera::MediaAssetGetHeight return with ret code: %{public}d!", result);
    return result;
}

MediaLibrary_ErrorCode NDKCamera::MediaAssetGetOrientation(OH_MediaAsset *mediaAsset)
{
    DRAWING_LOGD("NDKCamera::MediaAssetGetOrientation start!");
    uint32_t orientation;
    result = OH_MediaAsset_GetOrientation(mediaAsset, &orientation);
    if (result != MEDIA_LIBRARY_OK) {
        DRAWING_LOGD("NDKCamera::MediaAssetGetOrientation failed.");
    }
    DRAWING_LOGD("NDKCamera::MediaAssetGetOrientation orientation: %{public}d", orientation);
    DRAWING_LOGD("NDKCamera::MediaAssetGetOrientation return with ret code: %{public}d!", result);
    return result;
}
// [End get_media_asset_info]

int32_t NDKCamera::GetDefaultDisplayRotation()
{
    int32_t imageRotation = 0;
    NativeDisplayManager_Rotation displayRotation = DISPLAY_MANAGER_ROTATION_0;
    int32_t ret = OH_NativeDisplayManager_GetDefaultDisplayRotation(&displayRotation);
    if (ret != DISPLAY_MANAGER_OK) {
        OH_LOG_INFO(LOG_APP, "OH_NativeDisplayManager_GetDefaultDisplayRotation failed.");
    }
    imageRotation = displayRotation * IAMGE_ROTATION_90;
    return imageRotation;
}

void NDKCamera::InitPreviewRotation()
{
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

// [Start set_photo_single_cb]
// 单段式拍照回调函数。
void OnPhotoAvailable(Camera_PhotoOutput* photoOutput, OH_PhotoNative* photo)
{
    OH_LOG_INFO(LOG_APP, "OnPhotoAvailable start!");
    OH_ImageNative* imageNative;
    Camera_ErrorCode errCode = OH_PhotoNative_GetMainImage(photo, &imageNative);
    if (errCode != CAMERA_OK || imageNative == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_PhotoNative_GetMainImage call failed, errorCode: %{public}d", errCode);
        return;
    }
    OH_LOG_INFO(LOG_APP, "OH_PhotoNative_GetMainImage success!");
    OH_PictureNative* picture;
    errCode = OH_PhotoNative_GetUncompressedImage(photo, &picture);
    if (errCode != CAMERA_OK || picture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_PhotoNative_GetUncompressedImage call failed, errorCode: %{public}d", errCode);
        return;
    }
    OH_LOG_INFO(LOG_APP, "OnPhotoAvailable errCode:%{public}d picture:%{public}p", errCode, picture);
    // 读取OH_PictureNative中的主图mainPixelMap。
    OH_PixelmapNative* mainPixelmap;
    Image_ErrorCode imageErr = OH_PictureNative_GetMainPixelmap(picture, &mainPixelmap);
    if (imageErr != IMAGE_SUCCESS || mainPixelmap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageNative_GetImageSize call failed, errorCode: %{public}d", imageErr);
        return;
    }
    pixelMap = nullptr;
    pixelMap = mainPixelmap;
    OH_LOG_INFO(LOG_APP, "OH_PictureNative_GetMainPixelmap success");

    uint32_t byteCount = 0;
    imageErr = OH_PixelmapNative_GetByteCount(mainPixelmap, &byteCount);
    OH_LOG_INFO(LOG_APP, "OH_PixelmapNative_GetByteCount count:%{public}u", byteCount);
    OH_Pixelmap_ImageInfo* imageInfo;
    imageErr = OH_PixelmapNative_GetImageInfo(mainPixelmap, imageInfo);
    OH_LOG_INFO(LOG_APP, "OH_PixelmapNative_GetImageInfo errorCode:%{public}d", imageErr);

    uint32_t width;
    uint32_t height;
    uint32_t rowStride;
    int32_t pixelFormat = PIXEL_FORMAT::PIXEL_FORMAT_UNKNOWN;
    int32_t alphaMode = PIXELMAP_ALPHA_TYPE::PIXELMAP_ALPHA_TYPE_UNKNOWN;
    int32_t alphaType = PIXELMAP_ALPHA_TYPE::PIXELMAP_ALPHA_TYPE_UNKNOWN;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &height);
    OH_PixelmapImageInfo_GetRowStride(imageInfo, &rowStride);
    OH_PixelmapImageInfo_GetPixelFormat(imageInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetAlphaMode(imageInfo, &alphaMode);
    OH_PixelmapImageInfo_GetAlphaType(imageInfo, &alphaType);
    OH_LOG_INFO(LOG_APP, "OH_PixelmapNative_GetImageInfo w: %{public}d, h: %{public}d,"
        "rowStride: %{public}d, pixelFormat: %{public}d, alphaMode: %{public}d, alphaType:"
        "%{public}d", width, height, rowStride, pixelFormat, alphaMode, alphaType);
   // 释放资源。
    OH_PictureNative_Release(picture);
}

// 注册单段式拍照回调。
Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAvailableCallback(Camera_PhotoOutput* photoOutput)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputRegisterPhotoAvailableCallback start!");
    Camera_ErrorCode ret = OH_PhotoOutput_RegisterPhotoAvailableCallback(photoOutput, OnPhotoAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRegisterPhotoAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "PhotoOutputRegisterPhotoAvailableCallback return with ret code: %{public}d!", ret);
    return ret;
}

// 解注册单段式拍照回调。
Camera_ErrorCode NDKCamera::PhotoOutputUnRegisterPhotoAvailableCallback(Camera_PhotoOutput* photoOutput)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback start!");
    Camera_ErrorCode ret = OH_PhotoOutput_UnregisterPhotoAvailableCallback(photoOutput, OnPhotoAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback return with ret code: %{public}d!", ret);
    return ret;
}
// [End set_photo_single_cb]

// [Start set_photo_double_cb]
// 声明快速返图回调。
void OnRequestQuickImageDataPreparedWithDetails(MediaLibrary_ErrorCode result, MediaLibrary_RequestId requestId,
    MediaLibrary_MediaQuality mediaQuality, MediaLibrary_MediaContentType type, OH_ImageSourceNative* imageSourceNative,
    OH_PictureNative* pictureNative)
{
    OH_LOG_INFO(LOG_APP, "OnRequestQuickImageDataPreparedWithDetails start!");
    if (!pictureNative && !imageSourceNative) {
        OH_LOG_ERROR(LOG_APP, "pictureNative and imageSourceNative are null.");
        return;
    } else if (!pictureNative && imageSourceNative) {
        OH_LOG_ERROR(LOG_APP, "OnRequestQuickImageDataPreparedWithDetails, pictureNative is null.");
    } else if (pictureNative && !imageSourceNative) {
        OH_LOG_ERROR(LOG_APP, "OnRequestQuickImageDataPreparedWithDetails, imageSourceNative is null.");
    } else {
        OH_LOG_INFO(LOG_APP, "pictureNative and imageSourceNative are not null.");
    }
}

// 分段式拍照回调函数。
void OnPhotoAssetAvailable(Camera_PhotoOutput* photoOutput, OH_MediaAsset* mediaAsset)
{
    OH_LOG_INFO(LOG_APP, "OnPhotoAssetAvailable start!");
    if (mediaAsset == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable invalid error, mediaAsset is null.");
        return;
    }
    // 尝试获取mediaAsset中的uri信息。
    NDKCamera::MediaAssetGetUri(mediaAsset);
    // 尝试获取mediaAsset中的displayName信息。
    NDKCamera::MediaAssetGetDisplayName(mediaAsset);
    // 尝试获取mediaAsset中的size信息。
    NDKCamera::MediaAssetGetSize(mediaAsset);
    // 尝试获取mediaAsset中的修改时间信息。
    NDKCamera::MediaAssetGetDateModifiedMs(mediaAsset);
    // 尝试获取mediaAsset中的图片宽度信息。
    NDKCamera::MediaAssetGetWidth(mediaAsset);
    // 尝试获取mediaAsset中的图片高度信息。
    NDKCamera::MediaAssetGetHeight(mediaAsset);
    // 尝试获取mediaAsset中的图片方向信息。
    NDKCamera::MediaAssetGetOrientation(mediaAsset);
    // 创建媒体资产管理对象。
    OH_MediaAssetManager* mediaAssetManager = OH_MediaAssetManager_Create();
    if (mediaAssetManager == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable failed to create mediaAssetManager.");
        return;
    }

    // 创建媒体资产变更请求。
    OH_MediaAssetChangeRequest* changeRequest = OH_MediaAssetChangeRequest_Create(mediaAsset);
    if (changeRequest == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable failed to create changeRequest.");
    }
    // 注册媒体资产快速请求回调。
    MediaLibrary_RequestOptions requestOptions;
    requestOptions.deliveryMode = MEDIA_LIBRARY_BALANCED_MODE;
    MediaLibrary_RequestId requestId;
    result = OH_MediaAssetManager_QuickRequestImage(mediaAssetManager, mediaAsset, requestOptions, &requestId,
        OnRequestQuickImageDataPreparedWithDetails);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable failed to quick image.");
    }
    // 创建媒体资产保存变更请求。
    result = OH_MediaAssetChangeRequest_SaveCameraPhoto(changeRequest,
        MediaLibrary_ImageFileType::MEDIA_LIBRARY_IMAGE_JPEG);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable failed to save camera photo.");
    }
    result = OH_MediaAccessHelper_ApplyChanges(changeRequest);
    if (result != MEDIA_LIBRARY_OK) {
        OH_LOG_ERROR(LOG_APP, "OnPhotoAssetAvailable failed to apply changes.");
    }
}

// 注册分段式拍照回调函数。
Camera_ErrorCode NDKCamera::RegisterPhotoAssetAvailable(Camera_PhotoOutput* photoOutput)
{
    Camera_ErrorCode ret = OH_PhotoOutput_RegisterPhotoAssetAvailableCallback(photoOutput, OnPhotoAssetAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "RegisterPhotoAssetAvailable failed. %d ", ret);
    }
    return ret;
}
// 解注册分段式拍照回调函数。
Camera_ErrorCode NDKCamera::UnregisterPhotoAssetAvailable(Camera_PhotoOutput* photoOutput)
{
    Camera_ErrorCode ret = OH_PhotoOutput_UnregisterPhotoAssetAvailableCallback(photoOutput, OnPhotoAssetAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "UnregisterPhotoAssetAvailable failed. %d ", ret);
    }
    return ret;
}
// [End set_photo_double_cb]

// [Start capture_ready_cb]
void CaptureReadyCb(Camera_PhotoOutput* photoOutput)
{
    g_captureReadyFlag = true;
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnCaptureReady captureReadyFlag = %{public}d", g_captureReadyFlag);
}

void NDKCamera::RegisterCaptureReadyCallback(Camera_PhotoOutput* photoOutput)
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnCaptureReady");
    Camera_ErrorCode ret = OH_PhotoOutput_RegisterCaptureReadyCallback(photoOutput, CaptureReadyCb);
}
// [End capture_ready_cb]

OH_PixelmapNative* NDKCamera::GetPixelMap()
{
    return pixelMap;
}

} // namespace OHOS_CAMERA_SAMPLE
