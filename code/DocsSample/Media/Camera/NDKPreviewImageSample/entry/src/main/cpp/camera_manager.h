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
#include <cstdlib>
#include "hilog/log.h"
#include <memory>
#include <new>
#include <multimedia/image_framework/image/image_native.h>
#include <multimedia/image_framework/image/image_receiver_native.h>
#include "ohcamera/camera.h"
#include "ohcamera/camera_input.h"
#include "ohcamera/camera_device.h"
#include "ohcamera/capture_session.h"
#include "ohcamera/photo_output.h"
#include "ohcamera/preview_output.h"
#include "ohcamera/video_output.h"
#include "ohcamera/camera_manager.h"

#include <multimedia/media_library/media_asset_manager_capi.h>
#include <multimedia/media_library/media_asset_change_request_capi.h>
#include <multimedia/media_library/media_access_helper_capi.h>
#include <multimedia/image_framework/image/image_packer_native.h>
// [End import_header]
#include <cmath>
#include <sensors/oh_sensor.h>
#include <thread>

#include <native_image/native_image.h>
#include <native_window/external_window.h>
#include <native_buffer/native_buffer.h>

namespace OHOS_CAMERA_NDK_SAMPLE {

class NDKCamera {
public:
    ~NDKCamera();
    NDKCamera(char *previewSurfaceId, char *videoSurfaceId, Camera_SceneMode sceneMode, Camera_Position position,
        char *previewSurfaceSlaveId);

    static void Destroy()
    {
        if (ndkCamera_ != nullptr) {
            delete ndkCamera_;
            ndkCamera_ = nullptr;
        }
    }

    Camera_ErrorCode RegisterBufferCb(void *cb);
    Camera_ErrorCode RegisterFoldCb(void *cb);

    Camera_ErrorCode ReleaseCamera(void);
    Camera_ErrorCode TakePicture(int rotation);
    Camera_ErrorCode SaveCurPhoto();
    Camera_ErrorCode ChangeSceneMode(Camera_SceneMode sceneMode);
    Camera_ErrorCode CreatePreviewOutput();
    Camera_ErrorCode CreatePhotoOutput();
    Camera_ErrorCode CreateVideoOutput();
    Camera_ErrorCode SessionFlowFn();
    Camera_ErrorCode SetColorSpace();
    Camera_ErrorCode PhotoOutputRegisterPhotoAssetAvailableCallback(void);
    Camera_ErrorCode PhotoOutputUnRegisterPhotoAssetAvailableCallback(void);
    Camera_ErrorCode RegisterFoldCallback();
    Camera_ErrorCode UnRegisterFoldCallback();
    Camera_ErrorCode UpdateRotateForCamera(int32_t rotation);
    Camera_ImageRotation GetVideoRotation(int32_t deviceDegree);
    Camera_ErrorCode VideoOutputStart(char *videoId);
    Camera_ErrorCode VideoOutputStop(void);
    Camera_ImageRotation GetDeviceRotation();
    Camera_ImageRotation GetPreviewRotation(int32_t rotation);

private:
    enum CurRatio {
        RATIO1_1 = 0,
        RATIO4_3,
        RATIO16_9,
    };

    void  GetCameraDevice();
    NDKCamera(const NDKCamera &) = delete;
    NDKCamera &operator=(const NDKCamera &) = delete;
    uint32_t cameraDeviceIndex_ = 0;
    Camera_Manager *cameraManager_;
    Camera_CaptureSession *captureSession_;
    Camera_Device *cameras_;
    uint32_t size_;
    Camera_OutputCapability *cameraOutputCapability_;
    int32_t profileNum_; // 分辨率
    CurRatio ratio_; // 比例
    Camera_Profile *previewProfile_;
    Camera_Profile *photoProfile_;
    Camera_VideoProfile *videoProfile_;
    Camera_PreviewOutput *previewOutput_;
    Camera_PreviewOutput *previewSlaveOutput_;
    Camera_PhotoOutput *photoOutput_;
    Camera_VideoOutput *videoOutput_;
    Camera_Position position_;
    Camera_Input *cameraInput_;
    char *previewSurfaceId_;
    char *previewSurfaceSlaveId_;
    char *videoSurfaceId_;
    Camera_ErrorCode ret_;
    static NDKCamera *ndkCamera_;
    Camera_SceneMode sceneMode_;
};
} // namespace OHOS_CAMERA_NDK_SAMPLE
#endif // CAMERA_NDK_CAMERA_H
