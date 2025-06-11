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

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200

namespace OHOS_CAMERA_SAMPLE {
NDKCamera *NDKCamera::ndkCamera_ = nullptr;
std::mutex NDKCamera::mtx_;
const std::unordered_map<uint32_t, Camera_SceneMode> g_int32ToCameraSceneMode = {
    {1, Camera_SceneMode::NORMAL_PHOTO},
    {2, Camera_SceneMode::NORMAL_VIDEO},
    {12, Camera_SceneMode::SECURE_PHOTO} 
};

NDKCamera::NDKCamera(uint32_t focusMode, uint32_t cameraDeviceIndex, uint32_t sceneMode,
    const SurfaceIds& surfaceIds)
    : focusMode_(focusMode), cameraDeviceIndex_(cameraDeviceIndex),
      previewSurfaceId_(surfaceIds.previewId), 
      photoSurfaceId_(surfaceIds.photoId), 
      videoSurfaceId_(surfaceIds.videoId),
      cameras_(nullptr), profile_(nullptr), cameraOutputCapability_(nullptr), 
      captureSession_(nullptr), cameraInput_(nullptr), previewOutput_(nullptr), 
      photoOutput_(nullptr), videoOutput_(nullptr), isCameraMuted_(nullptr), 
      metaDataObjectType_(nullptr), metadataOutput_(nullptr),
      isExposureModeSupported_(false), isFocusModeSupported_(false), isSuccess_(false), 
      sceneMode_(NORMAL_VIDEO), exposureMode_(EXPOSURE_MODE_LOCKED), ret_(CAMERA_OK), 
      size_(0), minExposureBias_(0), maxExposureBias_(0), step_(0)
{
    // release camera
    ReleaseCamera();

    // create camera manager
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager_);
    if (cameraManager_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Get CameraManager failed.");
    }

    // create capture session
    ret = OH_CameraManager_CreateCaptureSession(cameraManager_, &captureSession_);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "Create captureSession failed.");
    }

    // look up sceneMode
    auto itr1 = g_int32ToCameraSceneMode.find(sceneMode);
    if (itr1 != g_int32ToCameraSceneMode.end()) {
        sceneMode_ = itr1->second;
    }

    // set session mode
    ret = OH_CaptureSession_SetSessionMode(captureSession_, NORMAL_VIDEO);

    // get capture session profile
    GetSupportedCameras();
    GetSupportedOutputCapability();

    // create preview output
    CreatePreviewOutput();

    // create camera input and register camera input callback
    CreateCameraInput();
    CameraInputOpen();  // 设备打开

    // config and start session
    SessionFlowFn();
}

NDKCamera::~NDKCamera()
{
    OH_LOG_INFO(LOG_APP, "~NDKCamera");
    Camera_ErrorCode ret = CAMERA_OK;

    if (cameraManager_) {
        OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. enter");
        ret = OH_CameraManager_DeleteSupportedCameraOutputCapability(cameraManager_, cameraOutputCapability_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete CameraOutputCapability failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameraOutputCapability. ok");
        }

        OH_LOG_ERROR(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. enter");
        ret = OH_CameraManager_DeleteSupportedCameras(cameraManager_, cameras_, size_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete Cameras failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_CameraManager_DeleteSupportedCameras. ok");
        }

        ret = OH_Camera_DeleteCameraManager(cameraManager_);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "Delete CameraManager failed.");
        } else {
            OH_LOG_INFO(LOG_APP, "Release OH_Camera_DeleteCameraMananger. ok");
        }
        cameraManager_ = nullptr;
    }
    OH_LOG_INFO(LOG_APP, "~NDKCamera exit");
}

Camera_ErrorCode NDKCamera::ReleaseCamera(void)
{
    OH_LOG_INFO(LOG_APP, " enter ReleaseCamera");
    if (previewOutput_ && captureSession_) {
        PreviewOutputStop();
        OH_CaptureSession_RemovePreviewOutput(captureSession_, previewOutput_);
        PreviewOutputRelease();
    }
    if (photoOutput_) {
        PhotoOutputRelease();
    }
    if (videoOutput_) {
        VideoOutputRelease();
    }
    if (captureSession_) {
        SessionRealese();
    }
    if (cameraInput_) {
        CameraInputClose();
    }
    OH_LOG_INFO(LOG_APP, " exit ReleaseCamera");
    return ret_;
}

Camera_ErrorCode NDKCamera::ReleaseSession(void)
{
    OH_LOG_INFO(LOG_APP, " enter ReleaseSession");
    PreviewOutputStop();
    PhotoOutputRelease();
    VideoOutputRelease();
    SessionRealese();
    OH_LOG_INFO(LOG_APP, " exit ReleaseSession");
    return ret_;
}

Camera_ErrorCode NDKCamera::SessionRealese(void)
{
    OH_LOG_INFO(LOG_APP, " enter SessionRealese");
    Camera_ErrorCode ret = OH_CaptureSession_Release(captureSession_);
    captureSession_ = nullptr;
    OH_LOG_INFO(LOG_APP, " exit SessionRealese");
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetFlashMode success. flashMode: %{public}d ", flashMode);
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode success. videoMode: %{public}f ",
                    videoMode);
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetZoomRatio success. zoom: %{public}f ", zoom);
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
    bool isSupport = false;
    OH_CaptureSession_IsVideoStabilizationModeSupported(captureSession_,
        Camera_VideoStabilizationMode::STABILIZATION_MODE_AUTO, &isSupport);
    if (isSupport) {
        OH_CaptureSession_SetVideoStabilizationMode(captureSession_,
            Camera_VideoStabilizationMode::STABILIZATION_MODE_AUTO);
    }

    // Start focusing
    OH_LOG_INFO(LOG_APP, "IsFocusMode start");
    OH_CaptureSession_SetFocusMode(captureSession_, Camera_FocusMode::FOCUS_MODE_AUTO);
    OH_LOG_INFO(LOG_APP, "IsFocusMode success");

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

    // start configuring session
    OH_LOG_INFO(LOG_APP, "session beginConfig.");
    Camera_ErrorCode ret = OH_CaptureSession_BeginConfig(captureSession_);

    // add cameraInput to the session
    OH_LOG_INFO(LOG_APP, "session add Input.");
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);

    // add previewOutput to the session
    OH_LOG_INFO(LOG_APP, "session add Preview Output.");
    ret = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);
    
    if (sceneMode_ == Camera_SceneMode::NORMAL_VIDEO) {
        // create video output and register video output callback
        CreateVideoOutput(videoSurfaceId_);

        // add videoOutput to the Session
        AddVideoOutput();
    }

    // Submit configuration information
    OH_LOG_INFO(LOG_APP, "session commitConfig");
    ret = OH_CaptureSession_CommitConfig(captureSession_);
    
    // Start Session Work
    OH_LOG_INFO(LOG_APP, "session start");
    SessionStart();
    OH_LOG_INFO(LOG_APP, "session success");
    OH_VideoOutput_Start(videoOutput_);

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

    // register camera input callback
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
    profile_ = cameraOutputCapability_->previewProfiles[0];

    if (profile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    profile_->size.width = videoFrameWidth;
    profile_->size.height = videoFrameHeight;
    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, profile_, previewSurfaceId_, &previewOutput_);

    if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    // register preview output callback
    PreviewOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput(char *photoSurfaceId)
{
    DRAWING_LOGD("NDKCamera::CreatePhotoOutput start!");
    profile_ = cameraOutputCapability_->photoProfiles[0];

    if (profile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get photoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    profile_->size.width = videoFrameWidth;
    profile_->size.height = videoFrameHeight;
    ret_ = OH_CameraManager_CreatePhotoOutput(cameraManager_, profile_, photoSurfaceId, &photoOutput_);

    if (photoSurfaceId == nullptr || photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    // register photo output callback
    PhotoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput(char *videoId)
{
    DRAWING_LOGD("NDKCamera::CreateVideoOutput start!");
    videoProfile_ = cameraOutputCapability_->videoProfiles[0];

    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput width：%{public}d", videoProfile_->size.width);
    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput height：%{public}d", videoProfile_->size.height);
    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput format：%{public}d", videoProfile_->format);
    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput range.min：%{public}d", videoProfile_->range.min);
    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput range.max：%{public}d", videoProfile_->range.max);

    videoProfile_->size.width = videoFrameWidth;
    videoProfile_->size.height = videoFrameHeight;
    ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, videoProfile_, videoId, &videoOutput_);

    if (videoId == nullptr || videoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    // register video output callback
    VideoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::AddVideoOutput(void)
{
    Camera_ErrorCode ret = OH_CaptureSession_AddVideoOutput(captureSession_, videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_AddVideoOutput success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_AddVideoOutput failed. %d ", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::AddPhotoOutput()
{
    Camera_ErrorCode ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_AddPhotoOutput success.");
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

    // register metadata output callback
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
    if (previewOutput_ != nullptr) {
        ret_ = OH_PreviewOutput_Release(previewOutput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "PreviewOutputRelease failed.");
            return CAMERA_INVALID_ARGUMENT;
        }
        previewOutput_ = nullptr;
    }
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::PhotoOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PhotoOutputRelease.");
    ret_ = OH_PhotoOutput_Release(photoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    photoOutput_ = nullptr;
    return ret_;
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
    float exposureBiasValue = (float)exposureBias;
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
    if (videoOutput_ == nullptr) {
        OH_LOG_DEBUG(LOG_APP, "VideoOutputRelease videoOutput_ is already null.");
        return CAMERA_OK;
    }
    ret_ = OH_VideoOutput_Release(videoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    videoOutput_ = nullptr;
    return ret_;
}

Camera_ErrorCode NDKCamera::TakePicture(void)
{
    Camera_ErrorCode ret = CAMERA_OK;
    ret = OH_PhotoOutput_Capture(photoOutput_);
    OH_LOG_ERROR(LOG_APP, "takePicture OH_PhotoOutput_Capture ret = %{public}d.", ret);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
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
void CameraManagerStatusCallback(Camera_Manager *cameraManager, Camera_StatusInfo *status)
{
    OH_LOG_INFO(LOG_APP, "CameraManagerStatusCallback");
}

CameraManager_Callbacks *NDKCamera::GetCameraManagerListener(void)
{
    static CameraManager_Callbacks cameraManagerListener = {.onCameraStatus = CameraManagerStatusCallback};
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
    static CameraInput_Callbacks cameraInputCallbacks = {.onError = OnCameraInputError};
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
    DRAWING_LOGD("PhotoOutputOnFrameStart start!");
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameStart");
}

void PhotoOutputOnFrameShutter(Camera_PhotoOutput *photoOutput, Camera_FrameShutterInfo *info)
{
    DRAWING_LOGD("PhotoOutputOnFrameShutter start!");
    OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameShutter");
}

void PhotoOutputOnFrameEnd(Camera_PhotoOutput *photoOutput, int32_t frameCount)
{
    DRAWING_LOGD("PhotoOutputOnFrameEnd start!");
    OH_LOG_INFO(LOG_APP, "PhotoOutput frameCount = %{public}d", frameCount);
}

void PhotoOutputOnError(Camera_PhotoOutput *photoOutput, Camera_ErrorCode errorCode)
{
    DRAWING_LOGD("PhotoOutputOnError start!");
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
} // namespace OHOS_CAMERA_SAMPLE