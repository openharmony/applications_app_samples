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
#define EPSILON 0.00001

int AreFloatsEqual(float a, float b)
{
    return fabs(a - b) < EPSILON;
}

namespace OHOS_CAMERA_SAMPLE {
NDKCamera *NDKCamera::ndkCamera_ = nullptr;
std::mutex NDKCamera::mtx_;
const int32_t NUM_1080P_WIDTH = 1920;
const int32_t NUM_1080P_HEIGHT = 1080;

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
      photoSurfaceId_(config.photoId),
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
      desiredPreviewW_(config.width),
      desiredPreviewH_(config.height),
      videoSurfaceId_(config.videoId),
      sceneMode_(config.sceneMode)
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
    ret = OH_CaptureSession_SetSessionMode(captureSession_, sceneMode_);
    CaptureSessionRegisterCallback();
    GetSupportedCameras();
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
    OH_LOG_ERROR(LOG_APP, "~NDKCamera exit");
}

Camera_ErrorCode NDKCamera::GetSupportedPreviewSizes(std::vector<Camera_Size> &outSizes)
{
    outSizes.clear();
    if (!cameraOutputCapability_ || cameraOutputCapability_->previewProfilesSize == 0) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedPreviewSizes: no capability or empty.");
        return CAMERA_INVALID_ARGUMENT;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->previewProfilesSize; ++i) {
        const Camera_Profile *profile = cameraOutputCapability_->previewProfiles[i];
        if (!profile) {
            continue;
        }
        outSizes.push_back(profile->size);
    }
    OH_LOG_INFO(LOG_APP, "GetSupportedPreviewSizes: %{public}zu sizes", outSizes.size());
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::GetSupportedPhotoSizes(std::vector<Camera_Size> &outSizes)
{
    outSizes.clear();
    if (!cameraOutputCapability_ || cameraOutputCapability_->photoProfilesSize == 0) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedPhotoSizes: no capability or empty.");
        return CAMERA_INVALID_ARGUMENT;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->photoProfilesSize; ++i) {
        const Camera_Profile *profile = cameraOutputCapability_->photoProfiles[i];
        OH_LOG_INFO(LOG_APP, "FindPhotoProfileBySize previewProfile_%{public}u*%{public}u", profile->size.width,
            profile->size.height);
        if (!profile) {
            continue;
        }
        outSizes.push_back(profile->size);
    }
    OH_LOG_INFO(LOG_APP, "GetSupportedPhotoSizes: %{public}zu sizes", outSizes.size());
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::GetSupportedVideoSizes(std::vector<Camera_Size> &outSizes)
{
    outSizes.clear();
    if (!cameraOutputCapability_ || cameraOutputCapability_->videoProfilesSize == 0) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedVideoSizes: no capability or empty.");
        return CAMERA_INVALID_ARGUMENT;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->videoProfilesSize; ++i) {
        const Camera_VideoProfile *profile = cameraOutputCapability_->videoProfiles[i];
        OH_LOG_INFO(LOG_APP, "FindVideoProfileBySize videoProfile_%{public}u*%{public}u", profile->size.width,
            profile->size.height);
        if (!profile) {
            continue;
        }
        outSizes.push_back(profile->size);
    }
    OH_LOG_INFO(LOG_APP, "GetSupportedVideoSizes: %{public}zu sizes", outSizes.size());
    return CAMERA_OK;
}

const Camera_Profile *NDKCamera::FindPreviewProfileBySize(uint32_t w, uint32_t h) const
{
    if (!cameraOutputCapability_) {
        OH_LOG_ERROR(LOG_APP, "FindPreviewProfileBySize return null");
        return nullptr;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->previewProfilesSize; ++i) {
        const Camera_Profile *p = cameraOutputCapability_->previewProfiles[i];
        OH_LOG_INFO(LOG_APP, "FindPreviewProfileBySize previewProfile_%{public}u*%{public}u", p->size.width,
            p->size.height);
        if (p && static_cast<uint32_t>(p->size.width) == w && static_cast<uint32_t>(p->size.height) == h) {
            return p;
        }
    }
    return nullptr;
}

const Camera_Profile *NDKCamera::FindPhotoProfileBySize(uint32_t w, uint32_t h) const
{
    if (!cameraOutputCapability_) {
        return nullptr;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->photoProfilesSize; ++i) {
        const Camera_Profile *p = cameraOutputCapability_->photoProfiles[i];
        if (p && static_cast<uint32_t>(p->size.width) == w && static_cast<uint32_t>(p->size.height) == h) {
            return p;
        }
    }
    return nullptr;
}

const Camera_VideoProfile *NDKCamera::FindVideoProfileBySize(uint32_t w, uint32_t h) const
{
    if (!cameraOutputCapability_) {
        OH_LOG_ERROR(LOG_APP, "FindVideoProfileBySize return null");
        return nullptr;
    }
    for (uint32_t i = 0; i < cameraOutputCapability_->videoProfilesSize; ++i) {
        const Camera_VideoProfile *vp = cameraOutputCapability_->videoProfiles[i];
        if (vp && static_cast<uint32_t>(vp->size.width) == w && static_cast<uint32_t>(vp->size.height) == h) {
            OH_LOG_ERROR(LOG_APP, "FindVideoProfileBySize return profile");
            return vp;
        }
    }
    return nullptr;
}

Camera_ErrorCode NDKCamera::SetPreviewResolution(uint32_t width, uint32_t height)
{
    const Camera_Profile *previewProfile = FindPreviewProfileBySize(width, height);
    if (!previewProfile) {
        OH_LOG_ERROR(LOG_APP, "SetPreviewResolution: not supported: %{public}u*%{public}u", width, height);
        return CAMERA_INVALID_ARGUMENT;
    }
    desiredPreviewW_ = width;
    desiredPreviewH_ = height;
    cachedPreviewProfile_ = previewProfile;
    OH_LOG_INFO(LOG_APP, "SetPreviewResolution cached %{public}u*%{public}u", width, height);
    OH_LOG_INFO(LOG_APP, "SetPreviewResolution cachedPreviewProfile %{public}p", cachedPreviewProfile_);
    OH_LOG_INFO(LOG_APP, "SetPreviewResolution desiredPreviewW_  desiredPreviewH_: %{public}u*%{public}u",
        desiredPreviewW_, desiredPreviewH_);
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::SetPhotoResolution(uint32_t width, uint32_t height)
{
    const Camera_Profile *profile = FindPhotoProfileBySize(width, height);
    if (!profile) {
        OH_LOG_ERROR(LOG_APP, "SetPhotoResolution: not supported: %{public}u*%{public}u", width, height);
        return CAMERA_INVALID_ARGUMENT;
    }
    desiredPhotoW_ = width;
    desiredPhotoH_ = height;
    cachedPhotoProfile_ = profile;
    photoResolutionChanged_ = true;
    OH_LOG_INFO(LOG_APP, "SetPhotoResolution cached %{public}u*%{public}u", width, height);
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::SetVideoResolution(uint32_t width, uint32_t height)
{
    const Camera_VideoProfile *videoProfile = FindVideoProfileBySize(width, height);
    if (!videoProfile) {
        OH_LOG_ERROR(LOG_APP, "SetVideoResolution: not supported: %{public}u*%{public}u", width, height);
        return CAMERA_INVALID_ARGUMENT;
    }
    desiredVideoW_ = width;
    desiredVideoH_ = height;
    cachedVideoProfile_ = videoProfile;
    OH_LOG_INFO(LOG_APP, "SetVideoResolution cachedVideoProfile1 %{public}p", cachedVideoProfile_);
    OH_LOG_INFO(LOG_APP, "SetVideoResolution desiredPreviewW_  desiredPreviewH_: %{public}u*%{public}u",
        desiredPreviewW_, desiredPreviewH_);
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::ReleaseCamera(void)
{
    OH_LOG_ERROR(LOG_APP, " enter ReleaseCamera");
    if (previewOutput_) {
        PreviewOutputStop();
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetFlashMode success. flashMode：%{public}d ", flashMode);
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode success. videoMode：%{public}f ", videoMode);
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetZoomRatio success. zoom：%{public}f ", zoom);
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

    // Add CameraInput to the session
    OH_LOG_INFO(LOG_APP, "session addInput.");
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);

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
    } else {
        if (photoOutput_ == nullptr) {
            OH_LOG_INFO(LOG_APP, "photoOutput_ is nullptr");
        }
        ret = AddPhotoOutput();
    }

    // Submit configuration information
    OH_LOG_INFO(LOG_APP, "session commitConfig");
    ret = OH_CaptureSession_CommitConfig(captureSession_);

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

    // Start GetSupport
    OH_LOG_INFO(LOG_APP, "GetSupportedFrameRates start");
    const uint32_t maxFrameRateRanges = 10; // 假设最多10个帧率范围
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
    const Camera_Profile *selectedProfile = nullptr;
    if (desiredPreviewW_ > 0 && desiredPreviewH_ > 0) {
        selectedProfile = FindPreviewProfileBySize(desiredPreviewW_, desiredPreviewH_);
        if (selectedProfile) {
            OH_LOG_INFO(LOG_APP, "CreatePreviewOutput selectedProfile desired %{public}u*%{public}u",
                selectedProfile->size.width, selectedProfile->size.height);
        } else {
            OH_LOG_ERROR(LOG_APP,
                "CreatePreviewOutput failed: this device is not supported this size, %{public}u*%{public}u",
                desiredPreviewW_, desiredPreviewH_);
        }
    }
    if (!selectedProfile) {
        Camera_Profile *temp = cameraOutputCapability_->previewProfiles[0];
        temp->size.width = NUM_1080P_WIDTH;
        temp->size.height = NUM_1080P_HEIGHT;
        selectedProfile = temp;
    }
    previewProfile_ = selectedProfile;
    if (previewProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput Get previewProfiles failed.");
    }
    for (int i = 0; i < cameraOutputCapability_->photoProfilesSize; i++) {
        profile_ = cameraOutputCapability_->photoProfiles[i];
        if (profile_->size.width == selectedProfile->size.width &&
            profile_->size.height == selectedProfile->size.height) {
            break;
        }
    }

    for (int i = 0; i < cameraOutputCapability_->videoProfilesSize; i++) {
        videoProfile_ = cameraOutputCapability_->videoProfiles[i];
        if (videoProfile_->size.width == selectedProfile->size.width &&
            videoProfile_->size.height == selectedProfile->size.height) {
            OH_LOG_INFO(LOG_APP, "CreatePreviewOutput videoProfile_%{public}u*%{public}u", videoProfile_->size.width,
                videoProfile_->size.height);
            break;
        }
    }
    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, previewProfile_, previewSurfaceId_, &previewOutput_);
    OH_LOG_ERROR(LOG_APP,
        "CreatePreviewOutput previewProfile_ preview width %{public}d, height: %{public}d， format: %{public}d",
        previewProfile_->size.width, previewProfile_->size.height, previewProfile_->format);
    if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
    }
    PreviewOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput(char *photoSurfaceId)
{
    if (profile_ == nullptr) {
        profile_ = cameraOutputCapability_->photoProfiles[0];
    }
    if (profile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get photoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    if (photoSurfaceId == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_LOG_ERROR(LOG_APP,
        "CreatePhotoOutput Profile_ video width %{public}d, height: %{public}d， format: %{public}d",
        profile_->size.width, profile_->size.height, profile_->format);

    ret_ = OH_CameraManager_CreatePhotoOutput(cameraManager_, profile_, photoSurfaceId, &photoOutput_);
    if (ret_ != CAMERA_OK || photoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed. ret:%{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }
    PhotoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePhotoOutputWithoutSurfaceId()
{
    OH_LOG_ERROR(LOG_APP, "CreatePhotoOutputWithoutSurfaceId enter.");
    profile_ = cameraOutputCapability_->photoProfiles[0];
    if (profile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get photoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreatePhotoOutputWithoutSurface(cameraManager_, profile_, &photoOutput_);
    if (photoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutputWithoutSurfaceId failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    PhotoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput(char *videoId)
{
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "CreateVideoOutput videoProfile_ video width %{public}d, height: %{public}d",
        videoProfile_->size.width, videoProfile_->size.height);
    ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, videoProfile_, videoId, &videoOutput_);
    if (videoId == nullptr || videoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    VideoOutputRegisterCallback();
    return ret_;
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
    ret_ = OH_PhotoOutput_Release(photoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::StartVideo(char *videoId, char *photoId)
{
    OH_LOG_INFO(LOG_APP, "StartVideo begin .");
    Camera_ErrorCode ret = CAMERA_OK;
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
    OH_LOG_DEBUG(LOG_APP, "PreviewOutputGetActiveFrameRate: ActiveFrameRate frameRateRange_ min %{public}d",
        (*frameRateRange).min);
    OH_LOG_DEBUG(LOG_APP, "PreviewOutputGetActiveFrameRate: ActiveFrameRate frameRateRange_ max %{public}d",
        (*frameRateRange).max);

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
    if (cachedVideoProfile_) {
        videoProfile_ = cachedVideoProfile_;
    }
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.width;
}

int32_t NDKCamera::GetVideoFrameHeight(void)
{
    if (cachedVideoProfile_) {
        videoProfile_ = cachedVideoProfile_;
    }
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.height;
}

int32_t NDKCamera::GetVideoFrameRate(void)
{
    if (cachedVideoProfile_) {
        videoProfile_ = cachedVideoProfile_;
    }
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->range.min;
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
    OH_LOG_INFO(LOG_APP, "CaptureSessionOnFocusStateChange");
}

void CaptureSessionOnError(Camera_CaptureSession *session, Camera_ErrorCode errorCode)
{
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