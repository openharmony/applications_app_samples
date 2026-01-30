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
static void *g_bufferCb = nullptr;
const int32_t NUM_1920 = 1920;
const int32_t NUM_1080 = 1080;
const int32_t NUM_30 = 30;

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
      isHdrVideo(config.isHdr),
      isVideo_(config.isVideo),
      videoId_(config.videoId)
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
    OH_LOG_ERROR(LOG_APP, "InitCamera isVideoMode: %{public}d", isVideo_);
    if (isVideo_) {
        ret = OH_CaptureSession_SetSessionMode(captureSession_, Camera_SceneMode::NORMAL_VIDEO);
    } else {
        ret = OH_CaptureSession_SetSessionMode(captureSession_, Camera_SceneMode::NORMAL_PHOTO);
    }
    CaptureSessionRegisterCallback();
    GetSupportedCameras();
    GetSupportedOutputCapability();
    CreatePreviewOutput();
    if (isVideo_) {
        CreateVideoOutput(videoId_);
    } else {
        CreatePhotoOutputWithoutSurfaceId();
        PhotoOutputRegisterPhotoAvailableCallback();
    }
    CreateCameraInput();
    CameraInputOpen();
    CameraManagerRegisterCallback();
    RegisterTorchStatusCallback();
    SessionFlowFn();
    RegisterControlCenterEffectStatusChangeCallback();
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
    Camera_ErrorCode ret = OH_CaptureSession_BeginConfig(captureSession_);

    // Add CameraInput to the session
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);

    // Add previewOutput to the session
    ret = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);

    if (isVideo_) {
        // Adding VideoOutput to the Session
        AddVideoOutput();
        if (isHdrVideo) {
            // HDR Vivid 视频需要设置色彩空间为OH_COLORSPACE_BT2020_HLG_LIMIT
            OH_NativeBuffer_ColorSpace colorSpace = OH_NativeBuffer_ColorSpace::OH_COLORSPACE_BT2020_HLG_LIMIT;
            SetColorSpace(colorSpace);
        }
    } else {
        // Adding PhotoOutput to the Session
        AddPhotoOutput();
        ret = CreateMetadataOutput();
        ret = OH_CaptureSession_AddMetadataOutput(captureSession_, metadataOutput_);
        OH_NativeBuffer_ColorSpace colorSpace = OH_NativeBuffer_ColorSpace::OH_COLORSPACE_P3_FULL;
        SetColorSpace(colorSpace);
    }

    // Submit configuration information
    ret = OH_CaptureSession_CommitConfig(captureSession_);

    if (isVideo_) {
        bool isMirrorSupported = false;
        ret = OH_VideoOutput_IsMirrorSupported(videoOutput_, &isMirrorSupported);
        OH_LOG_INFO(LOG_APP, "VideoOutput IsMirrorSupported: %{public}d", isMirrorSupported);
        if (isMirrorSupported) {
            OH_VideoOutput_EnableMirror(videoOutput_, isMirrorSupported);
        }
    }
    if (isHdrVideo) {
        uint32_t mode = static_cast<uint32_t>(Camera_VideoStabilizationMode::STABILIZATION_MODE_AUTO);
        IsVideoStabilizationModeSupportedFn(mode);
    }

    // Start Session Work
    OH_LOG_INFO(LOG_APP, "session start");
    ret = OH_CaptureSession_Start(captureSession_);

    // Start focusing
    ret = IsFocusMode(focusMode_);

    // Start GetSupport
    const uint32_t maxFrameRateRanges = 10; // 假设最多10个帧率范围
    frameRateRange = (Camera_FrameRateRange *)malloc(sizeof(Camera_FrameRateRange) * maxFrameRateRanges);
    uint32_t size = maxFrameRateRanges;
    ret = PreviewOutputGetSupportedFrameRates(previewOutput_, &frameRateRange, &size);
    RegisterMacroStatusCallback();
    RegisterSystemPressureCallback();

    return ret;
}

// 获取设备支持的预览帧率
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
    if (isHdrVideo) {
        OH_LOG_ERROR(LOG_APP, "colorspace 11111 failed.");
        ret_ = OH_CameraManager_GetSupportedCameraOutputCapabilityWithSceneMode(cameraManager_,
            &cameras_[cameraDeviceIndex_], Camera_SceneMode::NORMAL_VIDEO, &cameraOutputCapability_);
    } else {
        OH_LOG_ERROR(LOG_APP, "colorspace 22222222 failed.");
        ret_ = OH_CameraManager_GetSupportedCameraOutputCapability(cameraManager_, &cameras_[cameraDeviceIndex_],
            &cameraOutputCapability_);
    }
    if (cameraOutputCapability_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedCameraOutputCapability failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    GetProfiles();
    return ret_;
}

void NDKCamera::GetProfiles()
{
    previewProfile_ = cameraOutputCapability_->previewProfiles[0];
    if (isHdrVideo) {
        Camera_Profile* profile = cameraOutputCapability_->previewProfiles[0];
        profile->size.width = NUM_1920;
        profile->size.height = NUM_1080;
        profile->format = Camera_Format::CAMERA_FORMAT_YCRCB_P010;
        previewProfile_ = profile;
    } else {
        Camera_Profile* profile = cameraOutputCapability_->previewProfiles[0];
        profile->size.width = NUM_1920;
        profile->size.height = NUM_1080;
        previewProfile_ = profile;
    }
    // VideoOutput的宽高比需要和PreviewOutput一致
    if (isHdrVideo) {
        Camera_VideoProfile* profile = cameraOutputCapability_->videoProfiles[0];
        profile->size.width = NUM_1920;
        profile->size.height = NUM_1080;
        profile->format = Camera_Format::CAMERA_FORMAT_YCRCB_P010;
        profile->range.min = 1;
        profile->range.max = NUM_30;
        videoProfile_ = profile;
    } else {
        Camera_VideoProfile* profile = cameraOutputCapability_->videoProfiles[0];
        profile->size.width = NUM_1920;
        profile->size.height = NUM_1080;
        profile->range.min = 1;
        profile->range.max = NUM_30;
        videoProfile_ = profile;
    }
}

Camera_ErrorCode NDKCamera::CreatePreviewOutput(void)
{
    if (previewProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, previewProfile_, previewSurfaceId_, &previewOutput_);
    OH_LOG_ERROR(LOG_APP, "create preview width: %{public}d, height: %{public}d, format: %{public}d",
        previewProfile_->size.width, previewProfile_->size.height, previewProfile_->format);
    if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreatePreviewOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
    PreviewOutputRegisterCallback();
}

Camera_ErrorCode NDKCamera::CreatePhotoOutputWithoutSurfaceId()
{
    OH_LOG_ERROR(LOG_APP, "CreatePhotoOutputWithoutSurfaceId enter.");
    profile_ = cameraOutputCapability_->photoProfiles[0];
    Camera_Profile* profile = cameraOutputCapability_->photoProfiles[0];
    profile->size.width = NUM_1920;
    profile->size.height = NUM_1080;
    profile_ = profile;
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
    ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, videoProfile_, videoId, &videoOutput_);
    OH_LOG_ERROR(LOG_APP, " create video width: %{public}d, height: %{public}d, format: %{public}d",
        videoProfile_->size.width, videoProfile_->size.height, videoProfile_->format);
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
    OH_LOG_INFO(LOG_APP, "StartVideo begin. videoId: %{public}s, photoId: %{public}s", videoId, photoId);
    return CAMERA_OK;
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

Camera_ErrorCode NDKCamera::StartPhotoWithOutSurfaceId()
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


// 设置白平衡模式
Camera_ErrorCode NDKCamera::SetWhiteBalance(int32_t whiteBalance)
{
    Camera_WhiteBalanceMode mode = static_cast<Camera_WhiteBalanceMode>(whiteBalance);

    // 查询白平衡模式是否支持
    bool isSupported = false;
    Camera_ErrorCode ret = OH_CaptureSession_IsWhiteBalanceModeSupported(captureSession_, mode, &isSupported);

    if (isSupported) {
        ret = OH_CaptureSession_SetWhiteBalanceMode(captureSession_, mode);
        if (ret != CAMERA_OK) {
            return CAMERA_INVALID_ARGUMENT;
        }
    } else {
        OH_LOG_ERROR(LOG_APP, "SetWhiteBalance: this mode is not supported %{public}d", mode);
    }

    Camera_WhiteBalanceMode getMode;
    ret = OH_CaptureSession_GetWhiteBalanceMode(captureSession_, &getMode);
    if (ret != CAMERA_OK) {
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "SetWhiteBalance: this white balance mode is %{public}d", getMode);

    return ret;
}

// 设置HDR Vivid 视频
void NDKCamera::EnableHdrVideo(bool isHdr)
{
    OH_LOG_INFO(LOG_APP, "EnableHdrVideo: isHdr is %{public}d", isHdr);
    isHdrVideo = isHdr;
}

bool NDKCamera::IsMacroSupported(Camera_CaptureSession* captureSession)
{
    //判断设备是否支持微距能力
    bool isMacroSupported = false;
    if (captureSession == nullptr) {
        OH_LOG_ERROR(LOG_APP, "IsMacroSupported: session is nullptr.");
        return isMacroSupported;
    }
    Camera_ErrorCode ret = OH_CaptureSession_IsMacroSupported(captureSession, &isMacroSupported);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsMacroSupported failed.");
    }
    if (isMacroSupported) {
        OH_LOG_INFO(LOG_APP, "support macro capability.");
    } else {
        OH_LOG_ERROR(LOG_APP, "No support macro capability.");
    }
    return isMacroSupported;
}

void NDKCamera::EnableMacro(bool isMacro)
{
    OH_LOG_INFO(LOG_APP, "EnableMacro: isMacro is %{public}d", isMacro);
    if (IsMacroSupported(captureSession_)) {
        Camera_ErrorCode ret = OH_CaptureSession_EnableMacro(captureSession_, isMacro);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_EnableMacro failed.");
        }
    }
}

bool NDKCamera::IsControlCenterSupported()
{
    //判断设备是否支持控制相机控制器
    bool isSupported = false;
    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "IsControlCenterSupported: session is nullptr.");
        return isSupported;
    }
    Camera_ErrorCode ret = OH_CaptureSession_IsControlCenterSupported(captureSession_, &isSupported);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_IsControlCenterSupported failed.");
    }
    if (isSupported) {
        OH_LOG_INFO(LOG_APP, "support control center.");
    } else {
        OH_LOG_ERROR(LOG_APP, "No support control center.");
    }
    return isSupported;
}

void NDKCamera::EnableControlCenter(bool isControlCenter)
{
    OH_LOG_INFO(LOG_APP, "EnableControlCenter: isControlCenter is %{public}d", isControlCenter);
    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "EnableControlCenter: session is nullptr.");
        return;
    }
    if (IsControlCenterSupported()) {
        SessionStop();
        SessionBegin();
        SessionCommitConfig();
        Camera_ErrorCode ret = OH_CaptureSession_EnableControlCenter(captureSession_, isControlCenter);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_EnableControlCenter failed.");
        }
        SessionStart();
    }
}

void NDKCamera::SetIsControl(bool isControlCenter)
{
    isControl = isControlCenter;
    EnableControlCenter(isControl);
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
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.width;
}

int32_t NDKCamera::GetVideoFrameHeight(void)
{
    if (videoProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return videoProfile_->size.height;
}

int32_t NDKCamera::GetVideoFrameRate(void)
{
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
    OH_LOG_INFO(LOG_APP, "CaptureSessionOnFocusStateChange, focusState = %{public}d", focusState);
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

// 保存NAPI侧注册的buffer处理回调函数。
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

static bool ProcessImageNative(OH_ImageNative* imageNative, uint32_t** components,
                               OH_NativeBuffer** nativeBuffer, size_t* nativeBufferSize)
{
    if (imageNative == nullptr || components == nullptr || nativeBuffer == nullptr || nativeBufferSize == nullptr) {
        return false;
    }

    Image_Size size;
    Image_ErrorCode imageErr = OH_ImageNative_GetImageSize(imageNative, &size);
    if (imageErr != IMAGE_SUCCESS) {
        return false;
    }

    size_t componentTypeSize = 0;
    imageErr = OH_ImageNative_GetComponentTypes(imageNative, nullptr, &componentTypeSize);
    if (imageErr != IMAGE_SUCCESS || componentTypeSize == 0) {
        OH_LOG_ERROR(LOG_APP, "GetComponentTypes failed: %{public}d, size: %{public}zu",
            imageErr, componentTypeSize);
        return false;
    }

    if (componentTypeSize > (SIZE_MAX / sizeof(uint32_t))) {
        OH_LOG_ERROR(LOG_APP, "componentTypeSize too large: %{public}zu", componentTypeSize);
        return false;
    }

    uint32_t* compArray = new (std::nothrow) uint32_t[componentTypeSize];
    if (!compArray) {
        return false;
    }

    size_t tempSize = componentTypeSize;
    imageErr = OH_ImageNative_GetComponentTypes(imageNative, &compArray, &tempSize);
    if (imageErr != IMAGE_SUCCESS) {
        delete[] compArray;
        return false;
    }
    *components = compArray;

    imageErr = OH_ImageNative_GetByteBuffer(imageNative, compArray[0], nativeBuffer);
    if (imageErr != IMAGE_SUCCESS) {
        delete[] compArray;
        return false;
    }

    imageErr = OH_ImageNative_GetBufferSize(imageNative, compArray[0], nativeBufferSize);
    if (imageErr != IMAGE_SUCCESS) {
        delete[] compArray;
        return false;
    }

    int32_t rowStride = 0;
    int32_t pixelStride = 0;
    OH_ImageNative_GetRowStride(imageNative, compArray[0], &rowStride);
    OH_ImageNative_GetPixelStride(imageNative, compArray[0], &pixelStride);
    OH_LOG_INFO(LOG_APP, "Buffer size: %{public}zu, strides: %{public}d/%{public}d",
        *nativeBufferSize, rowStride, pixelStride);

    return true;
}


static void CleanupResources(OH_ImageNative* imageNative, uint32_t* components,
                             OH_NativeBuffer* nativeBuffer, void* virAddr)
{
    if (components) {
        delete[] components;
    }

    if (imageNative) {
        int32_t ret = OH_ImageNative_Release(imageNative);
        if (ret != 0) {
            OH_LOG_ERROR(LOG_APP, "Release image failed: %{public}d", ret);
        }
    }

    if (nativeBuffer && virAddr) {
        int32_t ret = OH_NativeBuffer_Unmap(nativeBuffer);
        if (ret != 0) {
            OH_LOG_ERROR(LOG_APP, "Unmap buffer failed: %{public}d", ret);
        }
    }
}


void OnPhotoAvailable(Camera_PhotoOutput *photoOutput, OH_PhotoNative *photo)
{
    OH_LOG_INFO(LOG_APP, "OnPhotoAvailable start!");

    OH_ImageNative *imageNative = nullptr;
    Camera_ErrorCode errCode = OH_PhotoNative_GetMainImage(photo, &imageNative);
    if (errCode != CAMERA_OK || !imageNative) {
        OH_LOG_ERROR(LOG_APP, "GetMainImage failed: %{public}d", errCode);
        return;
    }

    uint32_t* components = nullptr;
    OH_NativeBuffer* nativeBuffer = nullptr;
    size_t nativeBufferSize = 0;

    if (!ProcessImageNative(imageNative, &components, &nativeBuffer, &nativeBufferSize)) {
        CleanupResources(imageNative, components, nullptr, nullptr);
        return;
    }

    void* virAddr = nullptr;
    int32_t ret = OH_NativeBuffer_Map(nativeBuffer, &virAddr);
    if (ret != 0 || !virAddr) {
        OH_LOG_ERROR(LOG_APP, "Map buffer failed: %{public}d", ret);
        CleanupResources(imageNative, components, nativeBuffer, nullptr);
        return;
    }

    auto cb = (void (*)(void *, size_t))(g_bufferCb);
    if (cb && virAddr && nativeBufferSize > 0) {
        cb(virAddr, nativeBufferSize);
        OH_LOG_INFO(LOG_APP, "Buffer callback called");
    } else {
        OH_LOG_ERROR(LOG_APP, "Invalid callback parameters");
    }

    CleanupResources(imageNative, components, nativeBuffer, virAddr);

    OH_LOG_INFO(LOG_APP, "OnPhotoAvailable end");
}

Camera_ErrorCode NDKCamera::PhotoOutputRegisterPhotoAvailableCallback(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback start!");
    Camera_ErrorCode ret = OH_PhotoOutput_RegisterPhotoAvailableCallback(photoOutput_, OnPhotoAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::PhotoOutputRegisterPhotoAvailableCallback return with ret code: %{public}d!",
        ret_);
    return ret;
}

// 解注册单段式拍照回调。
Camera_ErrorCode NDKCamera::PhotoOutputUnRegisterPhotoAvailableCallback()
{
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback start!");
    Camera_ErrorCode ret = OH_PhotoOutput_UnregisterPhotoAvailableCallback(photoOutput_, OnPhotoAvailable);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "PhotoOutputUnRegisterPhotoAvailableCallback return with ret code: %{public}d!", ret);
    return ret;
}

void TorchStatusCallback(Camera_Manager *cameraManager, Camera_TorchStatusInfo *torchStatus)
{
    OH_LOG_INFO(LOG_APP, "TorchStatusCallback is called! %{public}d", torchStatus->isTorchActive);
}

Camera_ErrorCode NDKCamera::RegisterTorchStatusCallback(void)
{
    OH_LOG_INFO(LOG_APP, "NDKCamera::RegisterTorchStatusCallback start!");
    Camera_ErrorCode ret = OH_CameraManager_RegisterTorchStatusCallback(cameraManager_, TorchStatusCallback);
    if (ret != CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "NDKCamera::RegisterTorchStatusCallback failed.");
    }
    OH_LOG_INFO(LOG_APP, "NDKCamera::RegisterTorchStatusCallback return with ret code: %{public}d!", ret_);
    return ret;
}

void MacroStatusCallback(Camera_CaptureSession *captureSession, bool isMacroDetected)
{
    OH_LOG_INFO(LOG_APP, "MacroStatusCallback isMacro: %{public}d", isMacroDetected);
}

// 注册回调函数
Camera_ErrorCode NDKCamera::RegisterMacroStatusCallback()
{
    Camera_ErrorCode ret = OH_CaptureSession_RegisterMacroStatusChangeCallback(captureSession_, MacroStatusCallback);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_RegisterMacroStatusChangeCallback failed.");
    }
    return ret;
}

// 解注册
Camera_ErrorCode NDKCamera::UnregisterMacroStatusCallback()
{
    Camera_ErrorCode ret = OH_CaptureSession_UnregisterMacroStatusChangeCallback(captureSession_, MacroStatusCallback);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_UnregisterMacroStatusChangeCallback failed.");
    }
    return ret;
}

void SystemPressureLevelChangeCallback(Camera_CaptureSession *captureSession,
    Camera_SystemPressureLevel systemPressureLevel)
{
    OH_LOG_INFO(LOG_APP, "SystemPressureLevelChangeCallback level: %{public}d", systemPressureLevel);
}

Camera_ErrorCode NDKCamera::RegisterSystemPressureCallback()
{
    Camera_ErrorCode ret = OH_CaptureSession_RegisterSystemPressureLevelChangeCallback(
        captureSession_, SystemPressureLevelChangeCallback);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP,
            "OH_CaptureSession_RegisterSystemPressureLevelChangeCallback failed.");
    }
    return ret;
}

void ControlCenterEffectStatusChange(Camera_CaptureSession *session,
    Camera_ControlCenterStatusInfo* controlCenterStatusInfo)
{
    OH_LOG_INFO(LOG_APP, "ControlCenterEffectStatusChange isActive: %{public}d", controlCenterStatusInfo->isActive);
}

// 注册回调函数
Camera_ErrorCode NDKCamera::RegisterControlCenterEffectStatusChangeCallback()
{
    Camera_ErrorCode ret = OH_CaptureSession_RegisterControlCenterEffectStatusChangeCallback(
        captureSession_, ControlCenterEffectStatusChange);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_RegisterControlCenterEffectStatusChangeCallback failed.");
    }
    return ret;
}

// 解注册
Camera_ErrorCode NDKCamera::UnregisterControlCenterEffectStatusChangeCallback()
{
    Camera_ErrorCode ret = OH_CaptureSession_UnregisterControlCenterEffectStatusChangeCallback(
        captureSession_, ControlCenterEffectStatusChange);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_UnregisterControlCenterEffectStatusChangeCallback failed.");
    }
    return ret;
}

} // namespace OHOS_CAMERA_SAMPLE