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

#ifndef CAMERA_NDK_CAMERA_H
#define CAMERA_NDK_CAMERA_H
// [Start import_header]
#include <cstdint>
#include <cstdio>
#include <fcntl.h>
#include <map>
#include <string>
#include <vector>
#include <native_buffer/native_buffer.h>
#include "iostream"
#include "mutex"

#include "hilog/log.h"
#include "ohcamera/camera.h"
#include "ohcamera/camera_input.h"
#include "ohcamera/capture_session.h"
#include "ohcamera/photo_output.h"
#include "ohcamera/preview_output.h"
#include "ohcamera/video_output.h"
#include "ohcamera/camera_manager.h"
#include "common/log_common.h"

#include "multimedia/image_framework/image/image_native.h"
#include "multimedia/image_framework/image/image_source_native.h"
#include "multimedia/image_framework/image/image_packer_native.h"
#include "multimedia/media_library/media_access_helper_capi.h"
#include "multimedia/media_library/media_asset_base_capi.h"
#include "multimedia/media_library/media_asset_capi.h"
#include "multimedia/media_library/media_asset_change_request_capi.h"
#include "multimedia/media_library/media_asset_manager_capi.h"
#include "multimedia/media_library/moving_photo_capi.h"
#include "ohcamera/photo_native.h"
#include <window_manager/oh_display_info.h>
#include <window_manager/oh_display_manager.h>
// [End import_header]

namespace OHOS_CAMERA_SAMPLE {
class NDKCamera {
  public:
    struct CameraBuildingConfig {
        char *str;
        uint32_t focusMode;
        uint32_t cameraDeviceIndex;
    };
    ~NDKCamera();
    explicit NDKCamera(CameraBuildingConfig config);
    static void Destroy()
    {
        if (ndkCamera_ != nullptr) {
            delete ndkCamera_;
            ndkCamera_ = nullptr;
        }
    }

    Camera_ErrorCode CreateCameraInput(void);
    Camera_ErrorCode CameraInputOpen(void);
    Camera_ErrorCode CameraInputClose(void);
    Camera_ErrorCode CameraInputRelease(void);
    Camera_ErrorCode GetSupportedCameras(void);
    Camera_ErrorCode GetSupportedOutputCapability(void);
    Camera_ErrorCode CreatePreviewOutput(void);
    Camera_ErrorCode CreatePhotoOutputWithoutSurfaceId();
    Camera_ErrorCode PreviewOutputStop(void);
    Camera_ErrorCode PreviewOutputRelease(void);
    Camera_ErrorCode PhotoOutputRelease(void);
    Camera_ErrorCode HasFlashFn(uint32_t mode);
    Camera_ErrorCode setZoomRatioFn(uint32_t zoomRatio);
    Camera_ErrorCode SessionFlowFn(void);
    Camera_ErrorCode SessionBegin(void);
    Camera_ErrorCode SessionCommitConfig(void);
    Camera_ErrorCode SessionStart(void);
    Camera_ErrorCode SessionStop(void);
    Camera_ErrorCode AddPhotoOutput();
    Camera_ErrorCode IsExposureModeSupportedFn(uint32_t mode);
    Camera_ErrorCode IsMeteringPoint(int x, int y);
    Camera_ErrorCode IsExposureBiasRange(int exposureBias);
    Camera_ErrorCode IsFocusMode(uint32_t mode);
    Camera_ErrorCode IsFocusPoint(float x, float y);
    Camera_ErrorCode IsFocusModeSupported(uint32_t mode);
    Camera_ErrorCode ReleaseCamera(void);
    Camera_ErrorCode SessionRelease(void);
    Camera_ErrorCode ReleaseSession(void);

    Camera_ErrorCode TakePicture(int32_t degree);
    Camera_ErrorCode TakePictureWithPhotoSettings(Camera_PhotoCaptureSetting photoSetting);
    int32_t GetDefaultDisplayRotation();
    void InitPreviewRotation();
    OH_PixelmapNative* GetPixelMap();
    // callback
    Camera_ErrorCode CameraManagerRegisterCallback(void);
    Camera_ErrorCode CameraInputRegisterCallback(void);
    Camera_ErrorCode PreviewOutputRegisterCallback(void);
    Camera_ErrorCode PhotoOutputRegisterCallback(void);
    Camera_ErrorCode CaptureSessionRegisterCallback(void);
    Camera_ErrorCode SetPhotoOutputCallback(bool isSinglePhoto);

    // Get callback
    CameraManager_Callbacks *GetCameraManagerListener(void);
    CameraInput_Callbacks *GetCameraInputListener(void);
    PreviewOutput_Callbacks *GetPreviewOutputListener(void);
    PhotoOutput_Callbacks *GetPhotoOutputListener(void);
    CaptureSession_Callbacks *GetCaptureSessionRegister(void);

    // camera manager
    Camera_ErrorCode GetSupportedSceneModes(void);
    Camera_OutputCapability* GetSupportedFullCameraOutputCapability(Camera_Manager* cameraManager,
        Camera_Device &camera);
    // capture session
    Camera_ErrorCode CanAddInput(bool *isSuccess);
    Camera_ErrorCode CanAddPreviewOutput(bool *isSuccess);
    Camera_ErrorCode CanAddPhotoOutput(bool *isSuccess);

    Camera_ErrorCode RegisterPhotoAssetAvailable(Camera_PhotoOutput* photoOutput);
    Camera_ErrorCode UnregisterPhotoAssetAvailable(Camera_PhotoOutput* photoOutput);
    Camera_ErrorCode PhotoOutputUnRegisterPhotoAvailableCallback(Camera_PhotoOutput* photoOutput);
    Camera_ErrorCode PhotoOutputRegisterPhotoAvailableCallback(Camera_PhotoOutput* photoOutput);
    void RegisterCaptureReadyCallback(Camera_PhotoOutput* photoOutput);
    // media asset
    static MediaLibrary_ErrorCode MediaAssetGetUri(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetDisplayName(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetSize(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetDateModifiedMs(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetWidth(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetHeight(OH_MediaAsset* mediaAsset);
    static MediaLibrary_ErrorCode MediaAssetGetOrientation(OH_MediaAsset* mediaAsset);

  private:
    NDKCamera(const NDKCamera &) = delete;
    NDKCamera &operator=(const NDKCamera &) = delete;
    uint32_t cameraDeviceIndex_;
    Camera_Manager *cameraManager_;
    Camera_CaptureSession *captureSession_;
    Camera_Device *cameras_;
    uint32_t size_;
    Camera_OutputCapability *cameraOutputCapability_;
    const Camera_Profile *profile_;
    const Camera_Profile *cameraProfile_;
    Camera_PreviewOutput *previewOutput_;
    Camera_PhotoOutput *photoOutput_;
    Camera_Input *cameraInput_;
    char *previewSurfaceId_;
    Camera_ErrorCode ret_;
    Camera_ExposureMode exposureMode_;
    bool isExposureModeSupported_;
    bool isFocusModeSupported_;
    float minExposureBias_;
    float maxExposureBias_;
    float step_;
    uint32_t focusMode_;

    static NDKCamera *ndkCamera_;
    static std::mutex mtx_;
    volatile bool valid_;

    Camera_SceneMode sceneMode_;
    Camera_SceneMode *sceneModes_;
    Camera_PreconfigType preconfigType_;
    uint32_t sceneModeSize_;
    bool isSuccess_;
};
} // namespace OHOS_CAMERA_SAMPLE
#endif // CAMERA_NDK_CAMERA_H
