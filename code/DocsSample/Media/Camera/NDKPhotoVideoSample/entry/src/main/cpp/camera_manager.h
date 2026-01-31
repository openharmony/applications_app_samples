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
#include <native_buffer/buffer_common.h>
#include <unistd.h>
#include <string>
#include <thread>
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
#include "napi/native_api.h"
#include "ohcamera/camera_manager.h"

namespace OHOS_CAMERA_SAMPLE {
class NDKCamera {
  public:
    struct CameraBuildingConfig {
        char *str;
        uint32_t focusMode;
        uint32_t cameraDeviceIndex;
        bool isVideo;
        bool isHdr;
        char *videoId;
    };
    ~NDKCamera();
    explicit NDKCamera(CameraBuildingConfig config);
    // [StartExclude import_header]
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
    Camera_ErrorCode CreateVideoOutput(char *videoId);
    Camera_ErrorCode CreateMetadataOutput(void);
    Camera_ErrorCode PreviewOutputStop(void);
    Camera_ErrorCode PreviewOutputRelease(void);
    Camera_ErrorCode PhotoOutputRelease(void);
    void GetProfiles(void);
    Camera_ErrorCode HasFlashFn(uint32_t mode);
    Camera_ErrorCode IsVideoStabilizationModeSupportedFn(uint32_t mode);
    Camera_ErrorCode setZoomRatioFn(uint32_t zoomRatio);
    Camera_ErrorCode SessionFlowFn(void);
    Camera_ErrorCode SessionBegin(void);
    Camera_ErrorCode SessionCommitConfig(void);
    Camera_ErrorCode SessionStart(void);
    Camera_ErrorCode SessionStop(void);
    Camera_ErrorCode StartVideo(char *videoId, char *photoId);
    Camera_ErrorCode AddVideoOutput(void);
    Camera_ErrorCode AddPhotoOutput();
    Camera_ErrorCode VideoOutputStart(void);
    Camera_ErrorCode StartPhotoWithOutSurfaceId();
    Camera_ErrorCode IsExposureModeSupportedFn(uint32_t mode);
    Camera_ErrorCode IsMeteringPoint(int x, int y);
    Camera_ErrorCode IsExposureBiasRange(int exposureBias);
    Camera_ErrorCode IsFocusMode(uint32_t mode);
    Camera_ErrorCode IsFocusPoint(float x, float y);
    Camera_ErrorCode IsFocusModeSupported(uint32_t mode);
    Camera_ErrorCode ReleaseCamera(void);
    Camera_ErrorCode SessionRelease(void);
    Camera_ErrorCode ReleaseSession(void);
    int32_t GetVideoFrameWidth(void);
    int32_t GetVideoFrameHeight(void);
    int32_t GetVideoFrameRate(void);
    Camera_ImageRotation GetVideoRotation(int32_t deviceDegree);
    Camera_ErrorCode SetWhiteBalance(int32_t whiteBalance);
    Camera_ErrorCode SetColorSpace(OH_NativeBuffer_ColorSpace colorSpace);
    void EnableHdrVideo(bool isHdr);
    bool IsMacroSupported(Camera_CaptureSession* captureSession);
    void EnableMacro(bool isMacro);
    bool IsControlCenterSupported(void);
    void EnableControlCenter(bool isControlCenter);
    void SetIsControl(bool isControl);
    Camera_ErrorCode PreviewOutputGetSupportedFrameRates(Camera_PreviewOutput* previewOutput,
    Camera_FrameRateRange** frameRateRange, uint32_t* size);
    Camera_ErrorCode PreviewOutputSetFrameRate(uint32_t minFps, uint32_t maxFps);
    Camera_ErrorCode VideoOutputStop(void);
    Camera_ErrorCode VideoOutputRelease(void);
    Camera_ErrorCode TakePicture(int32_t degree);
    // callback
    Camera_ErrorCode CameraManagerRegisterCallback(void);
    Camera_ErrorCode CameraInputRegisterCallback(void);
    Camera_ErrorCode PreviewOutputRegisterCallback(void);
    Camera_ErrorCode PhotoOutputRegisterCallback(void);
    Camera_ErrorCode VideoOutputRegisterCallback(void);
    Camera_ErrorCode MetadataOutputRegisterCallback(void);
    Camera_ErrorCode CaptureSessionRegisterCallback(void);
    Camera_ErrorCode PhotoOutputRegisterPhotoAvailableCallback(void);
    Camera_ErrorCode PhotoOutputUnRegisterPhotoAvailableCallback();
    Camera_ErrorCode RegisterBufferCb(void* cb);
    Camera_ErrorCode RegisterTorchStatusCallback(void);
    Camera_ErrorCode RegisterMacroStatusCallback(void);
    Camera_ErrorCode UnregisterMacroStatusCallback(void);
    Camera_ErrorCode RegisterSystemPressureCallback(void);
    Camera_ErrorCode RegisterControlCenterEffectStatusChangeCallback(void);
    Camera_ErrorCode UnregisterControlCenterEffectStatusChangeCallback(void);

    // Get callback
    CameraManager_Callbacks *GetCameraManagerListener(void);
    CameraInput_Callbacks *GetCameraInputListener(void);
    PreviewOutput_Callbacks *GetPreviewOutputListener(void);
    PhotoOutput_Callbacks *GetPhotoOutputListener(void);
    VideoOutput_Callbacks *GetVideoOutputListener(void);
    MetadataOutput_Callbacks *GetMetadataOutputListener(void);
    CaptureSession_Callbacks *GetCaptureSessionRegister(void);

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
    const Camera_Profile *previewProfile_;
    const Camera_VideoProfile *videoProfile_;
    Camera_PreviewOutput *previewOutput_;
    Camera_PhotoOutput *photoOutput_;
    Camera_VideoOutput *videoOutput_;
    const Camera_MetadataObjectType *metaDataObjectType_;
    Camera_MetadataOutput *metadataOutput_;
    Camera_Input *cameraInput_;
    bool *isCameraMuted_;
    Camera_Position position_;
    Camera_Type type_;
    char *videoId_;
    char *previewSurfaceId_;
    char *photoSurfaceId_;
    Camera_ErrorCode ret_;
    uint32_t takePictureTimes = 0;
    Camera_ExposureMode exposureMode_;
    bool isExposureModeSupported_;
    bool isFocusModeSupported_;
    float minExposureBias_;
    float maxExposureBias_;
    Camera_FrameRateRange* frameRateRange;
    OH_NativeBuffer_ColorSpace* colorSpaces;
    uint32_t colorSpaceSize;
    float step_;
    uint32_t focusMode_;
    bool isHdrVideo;
    bool isControl;
    bool isVideo_;

    static NDKCamera *ndkCamera_;
    static std::mutex mtx_;
    volatile bool valid_;
// [EndExclude import_header]
};
} // namespace OHOS_CAMERA_SAMPLE
// [End import_header]
#endif // CAMERA_NDK_CAMERA_H
