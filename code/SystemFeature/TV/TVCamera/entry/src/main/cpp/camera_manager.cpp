/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdio>
#include "camera_manager.h"
#include "camera_setting.h"

#ifdef LOG_TAG
#undef LOG_TAG
#define LOG_TAG "camera-manager:"
#endif
#ifdef LOG_DOMAIN
#undef LOG_DOMAIN
#endif
#define LOG_DOMAIN 0x3200

namespace OHOS_CAMERA_SAMPLE {
NDKCamera *NDKCamera::ndkCamera_ = nullptr;
std::mutex NDKCamera::mtx_;
CallbackStatusJSFunc g_statusCBJSFunc = nullptr;
Camera_Manager *g_ptrCameraManager = nullptr;
bool g_bCameraManagerInit = false;
std::mutex g_oCameraManageMtx;
Camera_PhotoCaptureSetting g_photoSetting = {};
bool g_isPhotoSettingConfigured = false;

namespace {
constexpr int32_t PHOTO_CAPTURE_FORMAT = 3;
constexpr int32_t PARSED_RESOLUTION_FIELD_COUNT = 2;

// Parse a resolution string formatted as "width*height".
bool ParseResolution(const std::string &resolution, uint32_t &width, uint32_t &height)
{
    return sscanf(resolution.c_str(), "%u*%u", &width, &height) == PARSED_RESOLUTION_FIELD_COUNT;
}

// Find the first preview profile that matches the requested size and optional photo format.
Camera_Profile *FindPreviewProfile(
    Camera_OutputCapability *capability, uint32_t width, uint32_t height, bool requirePhotoFormat)
{
    Camera_Profile **profiles = capability->previewProfiles;
    for (int i = 0; i < capability->previewProfilesSize; i++) {
        Camera_Profile *profile = profiles[i];
        if (profile == nullptr || profile->size.width != width || profile->size.height != height) {
            continue;
        }
        if (!requirePhotoFormat || profile->format == PHOTO_CAPTURE_FORMAT) {
            return profile;
        }
    }
    return nullptr;
}

// Find the first record stream config that matches the requested size.
Camera_VideoProfile *FindRecordStream(Camera_OutputCapability *capability, uint32_t width, uint32_t height)
{
    Camera_VideoProfile **streamProfiles = capability->videoProfiles;
    for (int i = 0; i < capability->videoProfilesSize; i++) {
        Camera_VideoProfile *streamConfig = streamProfiles[i];
        if (streamConfig != nullptr && streamConfig->size.width == width && streamConfig->size.height == height) {
            return streamConfig;
        }
    }
    return nullptr;
}
} // namespace

NDKCamera::NDKCamera(char *str, uint32_t focusMode, std::string& cameraDeviceID, bool isVideo)
    : cameraDeviceIndex_(-1), cameraManager_(nullptr), captureSession_(nullptr), cameras_(nullptr), size_(0),
      cameraOutputCapability_(nullptr), previewProfile_(nullptr), photoProfile_(nullptr),
      recordStreamProfile_(nullptr), previewOutput_(nullptr),
      photoOutput_(nullptr), videoOutput_(nullptr), metaDataObjectType_(nullptr), metadataOutput_(nullptr),
      cameraInput_(nullptr), isCameraMuted_(nullptr), position_(CAMERA_POSITION_UNSPECIFIED),
      type_(CAMERA_TYPE_WIDE_ANGLE), previewSurfaceId_(str), photoSurfaceId_(nullptr), ret_(CAMERA_OK),
      takePictureTimes(0), exposureMode_(EXPOSURE_MODE_LOCKED), isExposureModeSupported_(false),
      isFocusModeSupported_(false), minExposureBias_(0), maxExposureBias_(0), step_(0), focusMode_(focusMode),
      valid_(false), m_strCameraID(cameraDeviceID)
{
    // 业务背景：NDKCamera是相机Native层封装，负责与OHOS相机服务交互
    // 策略：构造函数中依次执行：获取相机管理器→创建捕获会话→注册回调→获取相机能力→创建输入输出→启动会话
    // 注意：不在此处调用ReleaseCamera，因为成员变量可能未完全初始化
    OH_LOG_ERROR(LOG_APP, "multi_camera: NDKCamera构造函数 - cameraID: %{public}s, is_video: %{public}d",
                 cameraDeviceID.c_str(), isVideo);
    valid_ = false;

    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&cameraManager_);
    if (cameraManager_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Get CameraManager failed for camera: %{public}s", cameraDeviceID.c_str());
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Get CameraManager success for camera: %{public}s", cameraDeviceID.c_str());
    }

    ret = OH_CameraManager_CreateCaptureSession(cameraManager_, &captureSession_);
    if (captureSession_ == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Create captureSession failed for camera: %{public}s",
            cameraDeviceID.c_str());
    } else {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Create captureSession success for camera: %{public}s",
            cameraDeviceID.c_str());
    }
    CaptureSessionRegisterCallback();
    GetSupportedCameras();
    GetSupportedOutputCapability();
    CreatePreviewOutput(isVideo);
    CreateCameraInput();
    CameraInputOpen();
    CameraManagerRegisterCallback();
    SessionFlowFn();
    OH_LOG_ERROR(
        LOG_APP, "multi_camera: NDKCamera构造函数完成 - cameraID: %{public}s, valid: %{public}d",
        cameraDeviceID.c_str(), valid_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: NDKCamera构造完成 - cameraID:%{public}s valid:%{public}d",
        cameraDeviceID.c_str(), valid_);

    // 添加资源状态检查
    if (valid_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: 摄像头%{public}s 资源状态检查", cameraDeviceID.c_str());
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: - captureSession_: %{public}p", captureSession_);
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: - previewOutput_: %{public}p", previewOutput_);
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: - cameraInput_: %{public}p", cameraInput_);
        OH_LOG_ERROR(
            LOG_APP, "multi_camera_test: - previewSurfaceId_: %{public}s",
            previewSurfaceId_ ? previewSurfaceId_ : "NULL");
    }
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
    // 业务背景：释放相机资源时需要按照依赖顺序反向释放，避免资源泄漏或野指针
    // 策略：先释放输出流(视频/预览/拍照)→释放会话→关闭输入
    // 原因：输出流依赖会话存在，必须先移除再释放会话
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseCamera enter - cameraID: %{public}s", m_strCameraID.c_str());

    // 释放视频输出（如果存在）
    if (videoOutput_) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Stopping and releasing video output for camera: %{public}s",
            m_strCameraID.c_str());
        VideoOutputStop();
        if (captureSession_) {
            OH_CaptureSession_RemoveVideoOutput(captureSession_, videoOutput_);
        }
        VideoOutputRelease();
    }

    // 释放预览输出
    if (previewOutput_) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Stopping and releasing preview output for camera: %{public}s",
            m_strCameraID.c_str());
        PreviewOutputStop();
        if (captureSession_) {
            OH_CaptureSession_RemovePreviewOutput(captureSession_, previewOutput_);
        }
        PreviewOutputRelease();
    }

    // 释放拍照输出
    if (photoOutput_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Releasing photo output for camera: %{public}s", m_strCameraID.c_str());
        if (captureSession_) {
            OH_CaptureSession_RemovePhotoOutput(captureSession_, photoOutput_);
        }
        PhotoOutputRelease();
    }

    // 释放会话
    if (captureSession_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Releasing session for camera: %{public}s", m_strCameraID.c_str());
        SessionRealese();
    }

    // 关闭摄像头输入
    if (cameraInput_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Closing camera input for camera: %{public}s", m_strCameraID.c_str());
        CameraInputClose();
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseCamera exit - cameraID: %{public}s", m_strCameraID.c_str());
    return ret_;
}

Camera_ErrorCode NDKCamera::ReleaseSession(void)
{
    OH_LOG_ERROR(LOG_APP, "enter ReleaseSession - cameraID: %{public}s", m_strCameraID.c_str());

    // 安全地停止预览输出
    if (previewOutput_) {
        PreviewOutputStop();
    }

    // 安全地停止视频输出
    if (videoOutput_) {
        VideoOutputStop();
    }

    // 释放拍照输出
    if (photoOutput_) {
        PhotoOutputRelease();
    }

    // 释放会话
    if (captureSession_) {
        SessionRealese();
    }

    OH_LOG_ERROR(LOG_APP, "exit ReleaseSession - cameraID: %{public}s", m_strCameraID.c_str());
    return ret_;
}

Camera_ErrorCode NDKCamera::SessionRealese(void)
{
    OH_LOG_ERROR(LOG_APP, "enter SessionRealese - cameraID: %{public}s", m_strCameraID.c_str());

    // 添加空指针检查
    if (captureSession_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "SessionRealese skipped: captureSession_ is already null.");
        return CAMERA_OK; // 已经释放，返回成功
    }

    Camera_ErrorCode ret = OH_CaptureSession_Release(captureSession_);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SessionRealese failed with error code: %{public}d", ret);
    } else {
        OH_LOG_ERROR(LOG_APP, "SessionRealese success.");
    }

    captureSession_ = nullptr;
    OH_LOG_ERROR(LOG_APP, "exit SessionRealese - cameraID: %{public}s", m_strCameraID.c_str());
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
        OH_LOG_INFO(LOG_APP, "OH_CaptureSession_GetVideoStabilizationMode success. videoMode: %{public}u ", videoMode);
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
    // 业务背景：会话流程是相机初始化的核心步骤，决定了预览/拍照/录像功能
    // 策略：BeginConfig→AddInput→AddPreviewOutput→AddPhotoOutput→CommitConfig→Start→对焦
    // 注意：必须先BeginConfig才能AddInput/AddOutput，提交配置后相机才会开始工作
    OH_LOG_INFO(LOG_APP, "Start SessionFlowFn IN.");
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: SessionFlowFn开始 - cameraID:%{public}s", m_strCameraID.c_str());

    // Start configuring session
    OH_LOG_INFO(LOG_APP, "session beginConfig.");
    Camera_ErrorCode ret = OH_CaptureSession_BeginConfig(captureSession_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: BeginConfig结果 - cameraID:%{public}s ret:%{public}d",
        m_strCameraID.c_str(), ret);

    // Add CameraInput to the session
    OH_LOG_INFO(LOG_APP, "session addInput.");
    ret = OH_CaptureSession_AddInput(captureSession_, cameraInput_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: AddInput结果 - cameraID:%{public}s ret:%{public}d",
        m_strCameraID.c_str(), ret);

    // Add previewOutput to the session
    OH_LOG_INFO(LOG_APP, "session add Preview Output.");
    ret = OH_CaptureSession_AddPreviewOutput(captureSession_, previewOutput_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: AddPreviewOutput结果 - cameraID:%{public}s ret:%{public}d",
        m_strCameraID.c_str(), ret);

    // Adding PhotoOutput to the Session
    OH_LOG_INFO(LOG_APP, "session add Photo Output.");

    // Submit configuration information
    OH_LOG_INFO(LOG_APP, "session commitConfig");
    ret = OH_CaptureSession_CommitConfig(captureSession_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: CommitConfig结果 - cameraID:%{public}s ret:%{public}d",
        m_strCameraID.c_str(), ret);

    // Start Session Work
    OH_LOG_INFO(LOG_APP, "session start");
    ret = OH_CaptureSession_Start(captureSession_);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: Start结果 - cameraID:%{public}s ret:%{public}d",
        m_strCameraID.c_str(), ret);
    OH_LOG_INFO(LOG_APP, "session success");

    // Start focusing
    OH_LOG_INFO(LOG_APP, "IsFocusMode start");
    ret = IsFocusMode(focusMode_);
    OH_LOG_INFO(LOG_APP, "IsFocusMode success");
    return ret;
}

Camera_ErrorCode NDKCamera::CreateCameraInput(void)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: CreateCameraInput enter - cameraID: %{public}s", m_strCameraID.c_str());
    if (!valid_) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: CreateCameraInput failed, get device index invalid for camera: %{public}s",
            m_strCameraID.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreateCameraInput(cameraManager_, &cameras_[cameraDeviceIndex_], &cameraInput_);
    if (cameraInput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: CreateCameraInput failed for camera: %{public}s", m_strCameraID.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: CreateCameraInput exit success - cameraID: %{public}s", m_strCameraID.c_str());
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
    OH_LOG_ERROR(LOG_APP, "multi_camera: GetSupportedCameras enter - cameraID: %{public}s", m_strCameraID.c_str());
    ret_ = OH_CameraManager_GetSupportedCameras(cameraManager_, &cameras_, &size_);
    if (cameras_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Get supported cameras failed for camera: %{public}s",
            m_strCameraID.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: 检查%{public}d个相机设备以找到匹配的ID: %{public}s", size_, m_strCameraID.c_str());
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: 开始摄像头ID匹配 - 查找ID:'%{public}s' 系统支持数量:%{public}d",
        m_strCameraID.c_str(), size_);

    for (int i = 0; i < size_; i++) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 检查相机 %{public}d: %{public}s", i + 1, cameras_[i].cameraId);
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: 检查系统摄像头%{public}d ID:'%{public}s'", i, cameras_[i].cameraId);
        if (m_strCameraID == cameras_[i].cameraId) {
            cameraDeviceIndex_ = i;
            valid_ = true;
            OH_LOG_INFO(LOG_APP, "multi_camera: 找到匹配的相机[%{public}s] index %{public}d", cameras_[i].cameraId, i);
            break;
        }
    }

    if (!valid_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 未找到匹配的相机ID: %{public}s", m_strCameraID.c_str());
        OH_LOG_ERROR(
            LOG_APP, "multi_camera_test: 摄像头ID匹配失败 - 查找ID:%{public}s 系统支持数量:%{public}d",
            m_strCameraID.c_str(), size_);
    } else {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera_test: 摄像头ID匹配成功 - ID:%{public}s index:%{public}d",
            m_strCameraID.c_str(), cameraDeviceIndex_);
    }

    return ret_;
}

Camera_ErrorCode NDKCamera::GetSupportedOutputCapability(void)
{
    if (!valid_) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedCameraOutputCapability failed, get device index invalid.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_GetSupportedCameraOutputCapability(cameraManager_, &cameras_[cameraDeviceIndex_],
                                                               &cameraOutputCapability_);
    if (cameraOutputCapability_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetSupportedCameraOutputCapability failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::ConfigureVideoPreviewProfiles()
{
    std::string videoResolution = CameraSetting::GetDesiredVideoResolution();
    uint32_t targetWidth = 0;
    uint32_t targetHeight = 0;
    OH_LOG_ERROR(LOG_APP,
                 "multi_camera: Desired resolution: %{public}s for camera: %{public}s, is_video: %{public}d",
                 videoResolution.c_str(), m_strCameraID.c_str(), true);
    if (!ParseResolution(videoResolution, targetWidth, targetHeight)) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Failed to parse resolution: %{public}s", videoResolution.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: Looking for resolution: %{public}u x %{public}u", targetWidth, targetHeight);

    Camera_Profile *matchedPreview = FindPreviewProfile(cameraOutputCapability_, targetWidth, targetHeight, false);
    previewProfile_ = matchedPreview != nullptr ? matchedPreview : cameraOutputCapability_->previewProfiles[0];
    auto *matchedStream = FindRecordStream(cameraOutputCapability_, targetWidth, targetHeight);
    recordStreamProfile_ = matchedStream != nullptr ? matchedStream : cameraOutputCapability_->videoProfiles[0];
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::ConfigurePhotoPreviewProfiles()
{
    std::string photoResolution = CameraSetting::GetDesiredPhotoResolution();
    uint32_t targetWidth = 0;
    uint32_t targetHeight = 0;
    OH_LOG_ERROR(LOG_APP, "photoMulti_camera: Desired resolution: %{public}s for camera: %{public}s",
                 photoResolution.c_str(), m_strCameraID.c_str());
    if (!ParseResolution(photoResolution, targetWidth, targetHeight)) {
        OH_LOG_ERROR(LOG_APP, "photoMulti_camera: Failed to parse resolution: %{public}s", photoResolution.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_ERROR(LOG_APP, "photoMulti_camera: Looking for resolution: %{public}u x %{public}u", targetWidth,
                 targetHeight);

    Camera_Profile *matchedPreview = FindPreviewProfile(cameraOutputCapability_, targetWidth, targetHeight, true);
    Camera_Profile *fallbackProfile = cameraOutputCapability_->previewProfiles[0];
    previewProfile_ = matchedPreview != nullptr ? matchedPreview : fallbackProfile;
    photoProfile_ = previewProfile_;
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::CreatePreviewOutputInner()
{
    if (previewProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_LOG_ERROR(
        LOG_APP,
        "previewProfiles: Selected profile - height: %{public}d, width: %{public}d, format: %{public}d",
        previewProfile_->size.height, previewProfile_->size.width, previewProfile_->format);
    OH_LOG_ERROR(
        LOG_APP, "multi_camera: Using surfaceId: %{public}s for camera: %{public}s",
        previewSurfaceId_, m_strCameraID.c_str());
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: 开始创建预览输出 - cameraID:%{public}s surfaceId:%{public}s",
        m_strCameraID.c_str(), previewSurfaceId_);

    ret_ = OH_CameraManager_CreatePreviewOutput(cameraManager_, previewProfile_, previewSurfaceId_, &previewOutput_);

    OH_LOG_ERROR(LOG_APP, "multi_camera_test: 预览输出创建结果 - cameraID:%{public}s ret:%{public}d previewOutput_:%{public}p",
                 m_strCameraID.c_str(), ret_, previewOutput_);

    if (previewSurfaceId_ == nullptr || previewOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: CreatePreviewOutput failed for camera: %{public}s, ret: %{public}d",
            m_strCameraID.c_str(), ret_);
        OH_LOG_ERROR(
            LOG_APP,
            "multi_camera_test: 预览输出创建失败 - cameraID:%{public}s "
            "surfaceId:%{public}s previewOutput_:%{public}p ret:%{public}d",
            m_strCameraID.c_str(), previewSurfaceId_ ? previewSurfaceId_ : "NULL", previewOutput_, ret_);
        return CAMERA_INVALID_ARGUMENT;
    }
    PreviewOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreatePreviewOutput(bool isVideo)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: CreatePreviewOutput enter - cameraID: %{public}s", m_strCameraID.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: CreatePreviewOutput开始 - cameraID:%{public}s", m_strCameraID.c_str());
    if (!valid_) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: CreatePreviewOutput failed, device index invalid for camera: %{public}s",
                     m_strCameraID.c_str());
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: CreatePreviewOutput失败 - 设备索引无效 cameraID:%{public}s",
                     m_strCameraID.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
    if (cameraOutputCapability_->previewProfilesSize <= 0) {
        OH_LOG_ERROR(LOG_APP, "Get previewProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

    Camera_ErrorCode ret = isVideo ? ConfigureVideoPreviewProfiles() : ConfigurePhotoPreviewProfiles();
    if (ret != CAMERA_OK) {
        return ret;
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: CreatePreviewOutput exit success - cameraID: %{public}s",
                 m_strCameraID.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: 预览输出创建成功 - cameraID:%{public}s", m_strCameraID.c_str());
    return CreatePreviewOutputInner();
}

Camera_ErrorCode NDKCamera::CreatePhotoOutput(char *photoSurfaceId)
{
    if (cameraOutputCapability_->photoProfilesSize <= 0) {
        OH_LOG_ERROR(LOG_APP, "Get photoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    if (photoSurfaceId == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreatePhotoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreatePhotoOutput(cameraManager_, photoProfile_, photoSurfaceId, &photoOutput_);
    PhotoOutputRegisterCallback();
    return ret_;
}

Camera_ErrorCode NDKCamera::CreateVideoOutput(char *videoId)
{
    if (cameraOutputCapability_->videoProfilesSize <= 0) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    if (recordStreamProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CameraManager_CreateVideoOutput(cameraManager_, recordStreamProfile_, videoId, &videoOutput_);
    if (videoId == nullptr || videoOutput_ == nullptr || ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "CreateVideoOutput failed.");
        return CAMERA_INVALID_ARGUMENT;
    }

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

    // 添加空指针检查
    if (previewOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputStop failed: previewOutput_ is null.");
        return CAMERA_INVALID_ARGUMENT;
    }

    ret_ = OH_PreviewOutput_Stop(previewOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputStop failed with error code: %{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }

    OH_LOG_ERROR(LOG_APP, "PreviewOutputStop success.");
    return ret_;
}

Camera_ErrorCode NDKCamera::PreviewOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PreviewOutputRelease.");

    // 添加空指针检查
    if (previewOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputRelease skipped: previewOutput_ is already null.");
        return CAMERA_OK; // 已经释放，返回成功
    }

    ret_ = OH_PreviewOutput_Release(previewOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PreviewOutputRelease failed with error code: %{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }

    previewOutput_ = nullptr;
    OH_LOG_ERROR(LOG_APP, "PreviewOutputRelease success.");
    return ret_;
}

Camera_ErrorCode NDKCamera::PhotoOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter PhotoOutputRelease.");

    // 添加空指针检查
    if (photoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease skipped: photoOutput_ is already null.");
        return CAMERA_OK; // 已经释放，返回成功
    }

    ret_ = OH_PhotoOutput_Release(photoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease failed with error code: %{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }

    // 释放成功后设置为空指针，避免重复释放
    photoOutput_ = nullptr;
    OH_LOG_ERROR(LOG_APP, "PhotoOutputRelease success.");
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
    OH_CaptureSession_SetSessionMode(captureSession_, NORMAL_VIDEO);
    CreateVideoOutput(videoId);
    AddVideoOutput();
    SessionCommitConfig();
    SessionStart();
    VideoOutputRegisterCallback();
    return ret;
}

Camera_ErrorCode NDKCamera::VideoOutputStart(bool enableMirror)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputStart begin. enableMirror: %{public}d", enableMirror);

    // 添加空指针检查
    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputStart failed: videoOutput_ is null.");
        return CAMERA_INVALID_ARGUMENT;
    }

    // 检查是否支持镜像
    bool isMirrorSupported = false;
    Camera_ErrorCode mirrorSupportRet = OH_VideoOutput_IsMirrorSupported(videoOutput_, &isMirrorSupported);
    if (mirrorSupportRet == CAMERA_OK && isMirrorSupported) {
        OH_LOG_INFO(LOG_APP, "VideoOutput supports mirroring.");
        OH_VideoOutput_EnableMirror(videoOutput_, enableMirror);
    } else {
        OH_LOG_INFO(LOG_APP, "VideoOutput does not support mirroring or failed to check.");
    }

    Camera_ErrorCode ret = OH_VideoOutput_Start(videoOutput_);
    if (ret == CAMERA_OK) {
        OH_LOG_INFO(LOG_APP, "OH_VideoOutput_Start success.");
    } else {
        OH_LOG_ERROR(LOG_APP, "OH_VideoOutput_Start failed with error code: %{public}d", ret);
    }
    return ret;
}

Camera_ErrorCode NDKCamera::StartPhoto(char *mSurfaceId)
{
    Camera_ErrorCode ret = CAMERA_OK;
    if (takePictureTimes == 0) {
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
        ret = OH_CaptureSession_AddPhotoOutput(captureSession_, photoOutput_);
        OH_LOG_INFO(LOG_APP, "startPhoto AddPhotoOutput ret = %{public}d.", ret);
        ret = SessionCommitConfig();

        OH_LOG_INFO(LOG_APP, "startPhoto SessionCommitConfig ret = %{public}d.", ret);
        ret = SessionStart();
        OH_LOG_INFO(LOG_APP, "startPhoto SessionStart ret = %{public}d.", ret);
    }
    ret = TakePicture();
    OH_LOG_INFO(LOG_APP, "startPhoto OH_PhotoOutput_Capture ret = %{public}d.", ret);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    takePictureTimes++;
    return ret_;
}

// exposure mode
Camera_ErrorCode NDKCamera::IsExposureModeSupportedFn(uint32_t mode)
{
    OH_LOG_INFO(LOG_APP, "IsExposureModeSupportedFn start.");
    exposureMode_ = static_cast<Camera_ExposureMode>(mode);
    ret_ = OH_CaptureSession_IsExposureModeSupported(captureSession_, exposureMode_, &isExposureModeSupported_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_SetExposureMode(captureSession_, exposureMode_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetExposureMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetExposureMode(captureSession_, &exposureMode_);
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "IsFocusModeSupported failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_SetFocusMode(captureSession_, focusMode);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "SetFocusMode failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    ret_ = OH_CaptureSession_GetFocusMode(captureSession_, &focusMode);
    if (ret_ != CAMERA_OK) {
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
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "GetFocusPoint failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    OH_LOG_INFO(LOG_APP, "IsFocusPoint end.");
    return ret_;
}

int32_t NDKCamera::GetVideoFrameWidth(void)
{
    if (recordStreamProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return recordStreamProfile_->size.width;
}

int32_t NDKCamera::GetVideoFrameHeight(void)
{
    if (recordStreamProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return recordStreamProfile_->size.height;
}

int32_t NDKCamera::GetVideoFrameRate(void)
{
    if (recordStreamProfile_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get videoProfiles failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return recordStreamProfile_->range.min;
}

Camera_ErrorCode NDKCamera::VideoOutputStop(void)
{
    OH_LOG_ERROR(LOG_APP, "enter VideoOutputStop for camera: %{public}s", m_strCameraID.c_str());

    // 添加空指针检查
    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(
            LOG_APP, "VideoOutputStop skipped: videoOutput_ is null for camera: %{public}s",
            m_strCameraID.c_str());
        return CAMERA_OK; // 返回成功，因为没有需要停止的资源
    }

    try {
        ret_ = OH_VideoOutput_Stop(videoOutput_);
        if (ret_ != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "VideoOutputStop failed with error code: %{public}d for camera: %{public}s",
                ret_, m_strCameraID.c_str());
            return CAMERA_INVALID_ARGUMENT;
        }

        OH_LOG_ERROR(LOG_APP, "VideoOutputStop success for camera: %{public}s", m_strCameraID.c_str());
        return ret_;
    } catch (...) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputStop exception caught for camera: %{public}s", m_strCameraID.c_str());
        return CAMERA_INVALID_ARGUMENT;
    }
}

Camera_ErrorCode NDKCamera::VideoOutputRelease(void)
{
    OH_LOG_ERROR(LOG_APP, "enter VideoOutputRelease.");

    // 添加空指针检查
    if (videoOutput_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputRelease skipped: videoOutput_ is already null.");
        return CAMERA_OK; // 已经释放，返回成功
    }

    ret_ = OH_VideoOutput_Release(videoOutput_);
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputRelease failed with error code: %{public}d", ret_);
        return CAMERA_INVALID_ARGUMENT;
    }

    // 释放成功后设置为空指针，避免重复释放
    videoOutput_ = nullptr;
    OH_LOG_ERROR(LOG_APP, "VideoOutputRelease success.");
    return ret_;
}

Camera_ErrorCode NDKCamera::TakePicture(void)
{
    Camera_ErrorCode ret = CAMERA_OK;

    if (g_isPhotoSettingConfigured) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera_test: - OH_PhotoOutput_Capture_WithCaptureSetting rotate:%{public}d",
            g_photoSetting.rotation);
        ret = OH_PhotoOutput_Capture_WithCaptureSetting(photoOutput_, g_photoSetting);
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: - OH_PhotoOutput_Capture");
        ret = OH_PhotoOutput_Capture(photoOutput_);
    }
    OH_LOG_ERROR(LOG_APP, "takePicture OH_PhotoOutput_Capture ret = %{public}d.", ret);
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "startPhoto failed.");
        return CAMERA_INVALID_ARGUMENT;
    }
    return ret;
}
Camera_ErrorCode NDKCamera::setPhotoSettings(Camera_PhotoCaptureSetting setting)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: - setPhotoSettings %{public}d", setting.rotation);
    g_isPhotoSettingConfigured = true;
    g_photoSetting = setting;
    return CAMERA_OK;
}

Camera_ErrorCode NDKCamera::TakePictureWithPhotoSettings(Camera_PhotoCaptureSetting photoSetting)
{
    Camera_ErrorCode ret = CAMERA_OK;
    ret = OH_PhotoOutput_Capture_WithCaptureSetting(photoOutput_, photoSetting);

    OH_LOG_INFO(LOG_APP,
                "TakePictureWithPhotoSettings get quality %{public}d, rotation %{public}d, mirror %{public}d, "
                "latitude, %{public}f, longitude %{public}f, altitude %{public}f",
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
    OH_LOG_INFO(
        LOG_APP, "camerastatus RegisterCallback CameraManagerStatusCallback %{public}s; %{public}d",
        status->camera->cameraId, status->status);
    if (g_statusCBJSFunc != nullptr) {
        g_statusCBJSFunc(status->camera->cameraId, status->status);
        OH_LOG_INFO(LOG_APP, "camerastatus g_statusCBJSFunc end %{public}s; %{public}d", status->camera->cameraId,
                    status->status);
    }
}

CameraManager_Callbacks* CreateCameraManagerListener()
{
    static CameraManager_Callbacks cameraManagerListener = {.onCameraStatus = CameraManagerStatusCallback};
    return &cameraManagerListener;
}

Camera_ErrorCode initRegisterCallback(int inSize, CallbackStatusJSFunc callback)
{
    std::lock_guard<std::mutex > lock(g_oCameraManageMtx);

    if (g_bCameraManagerInit) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: CameraManager RegisterCallback has initialized %{public}d.", inSize);
        return CAMERA_OK;
    }
    g_statusCBJSFunc = callback;
    Camera_ErrorCode ret = OH_Camera_GetCameraManager(&g_ptrCameraManager);
    if (g_ptrCameraManager == nullptr || ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Get CameraManager failed ");
        return CAMERA_OK;
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera: Get CameraManager success ");
    }
    ret = OH_CameraManager_RegisterCallback(g_ptrCameraManager, CreateCameraManagerListener());
    if (ret != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: OH_CameraManager_RegisterCallback failed.");
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: OH_CameraManager_RegisterCallback end %{public}d.", inSize);
    g_bCameraManagerInit = true;
    return ret;
}

Camera_ErrorCode unInitRegisterCallback()
{
    std::lock_guard<std::mutex > lock(g_oCameraManageMtx);

    if (!g_bCameraManagerInit) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: unInitRegisterCallback is false, no need invoke uninit.");
        return CAMERA_OK;
    }
    Camera_ErrorCode ret = CAMERA_OK;
    if (g_ptrCameraManager) {
        ret = OH_CameraManager_UnregisterCallback(g_ptrCameraManager, CreateCameraManagerListener());
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "multi_camera: OH_CameraManager_RegisterCallback failed.");
        }

        ret = OH_Camera_DeleteCameraManager(g_ptrCameraManager);
        if (ret != CAMERA_OK) {
            OH_LOG_ERROR(LOG_APP, "multi_camera: Delete CameraManager failed.");
        } else {
            OH_LOG_ERROR(LOG_APP, "multi_camera: unInitRegisterCallback. ok");
        }
        g_ptrCameraManager = nullptr;
    }
    g_bCameraManagerInit = false;
    g_statusCBJSFunc = nullptr;
    return ret;
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
    static PreviewOutput_Callbacks previewOutputListener = {.onFrameStart = PreviewOutputOnFrameStart,
                                                            .onFrameEnd = PreviewOutputOnFrameEnd,
                                                            .onError = PreviewOutputOnError};
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
void PhotoOutputOnFrameStart(Camera_PhotoOutput *photoOutput) { OH_LOG_INFO(LOG_APP, "PhotoOutputOnFrameStart"); }

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
    static PhotoOutput_Callbacks photoOutputListener = {.onFrameStart = PhotoOutputOnFrameStart,
                                                        .onFrameShutter = PhotoOutputOnFrameShutter,
                                                        .onFrameEnd = PhotoOutputOnFrameEnd,
                                                        .onError = PhotoOutputOnError};
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
void VideoOutputOnFrameStart(Camera_VideoOutput *videoOutput) { OH_LOG_INFO(LOG_APP, "VideoOutputOnFrameStart"); }

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
        .onFrameStart = VideoOutputOnFrameStart, .onFrameEnd = VideoOutputOnFrameEnd, .onError = VideoOutputOnError};
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
    static MetadataOutput_Callbacks metadataOutputListener = {.onMetadataObjectAvailable = OnMetadataObjectAvailable,
                                                              .onError = OnMetadataOutputError};
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
    static CaptureSession_Callbacks captureSessionCallbacks = {.onFocusStateChange = CaptureSessionOnFocusStateChange,
                                                               .onError = CaptureSessionOnError};
    return &captureSessionCallbacks;
}

void NDKCamera::RegisterJSCallback(CallbackStatusJSFunc callback)
{
    g_statusCBJSFunc = callback;
    OH_LOG_INFO(LOG_APP, "CameraManagerStatusCallback invoke.");
}

Camera_ErrorCode NDKCamera::CaptureSessionRegisterCallback(void)
{
    ret_ = OH_CaptureSession_RegisterCallback(captureSession_, GetCaptureSessionRegister());
    if (ret_ != CAMERA_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_CaptureSession_RegisterCallback failed.");
    }
    return ret_;
}

Camera_ErrorCode NDKCamera::UpdateSurfaceId(char *newSurfaceId)
{
    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: UpdateSurfaceId开始 - cameraID:%{public}s newSurfaceId:%{public}s",
        m_strCameraID.c_str(), newSurfaceId);

    if (!newSurfaceId || strlen(newSurfaceId) == 0) {
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: UpdateSurfaceId失败 - newSurfaceId无效");
        return CAMERA_INVALID_ARGUMENT;
    }

    // 简化实现：只更新surfaceId，不重新创建预览输出
    // 因为重新创建可能会导致复杂的状态管理问题

    // 更新previewSurfaceId
    if (previewSurfaceId_) {
        delete[] previewSurfaceId_;
    }
    size_t len = strlen(newSurfaceId);
    previewSurfaceId_ = new char[len + 1];
    if (previewSurfaceId_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: UpdateSurfaceId失败 - 内存分配失败");
        return CAMERA_INVALID_ARGUMENT;
    }
    for (size_t index = 0; index <= len; ++index) {
        previewSurfaceId_[index] = newSurfaceId[index];
    }

    OH_LOG_ERROR(
        LOG_APP, "multi_camera_test: UpdateSurfaceId完成 - cameraID:%{public}s newSurfaceId:%{public}s",
        m_strCameraID.c_str(), newSurfaceId);

    return CAMERA_OK;
}
} // namespace OHOS_CAMERA_SAMPLE
