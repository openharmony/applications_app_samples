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

#include <js_native_api.h>
#include <unistd.h>
#include "camera_manager.h"
#include "camera_setting.h"
#include "camera_watermark.h"


#ifdef LOG_TAG
#undef LOG_TAG
#define LOG_TAG "camera-mian:"
#endif
#ifdef LOG_DOMAIN
#undef LOG_DOMAIN
#define LOG_DOMAIN 0x3200
#endif

#define PATH_NAME_MAX 128

using namespace OHOS_CAMERA_SAMPLE;
static NDKCamera *ndkCamera_ = nullptr;
static CameraSetting *g_cameraSetting = nullptr;
static CameraWatermark *g_cameraWatermark = nullptr;
const int32_t ARGS_TWO = 2;
const int32_t ARGS_THREE = 3;
const int32_t ARGS_FOUR = 4;
const size_t INIT_CAMERA_REQUIRED_ARGS = 3;
const useconds_t CAMERA_RELEASE_DELAY_US = 100000;
const int32_t INIT_CAMERA_SUCCESS = 0;
const int32_t INIT_CAMERA_FAILURE = -1;
struct Capture_Setting {
    int32_t quality;
    int32_t rotation;
    int32_t location;
    bool mirror;
    int32_t latitude;
    int32_t longitude;
    int32_t altitude;
};

napi_threadsafe_function cameraCBfn = nullptr;
struct CameraStatusArgs {
    std::string cameraId;
    int32_t status;
};

struct InitCameraParams {
    std::string surfaceId;
    int32_t focusMode = 0;
    std::string cameraId;
    bool isVideo = false;
};

std::unordered_map<std::string, NDKCamera *> g_mapCameraDevice_ = {};

// Read a UTF-8 string from a JS argument into a std::string.
static bool GetUtf8String(napi_env env, napi_value value, std::string &output)
{
    size_t length = 0;
    if (napi_get_value_string_utf8(env, value, nullptr, 0, &length) != napi_ok) {
        return false;
    }
    std::vector<char> buffer(length + 1, '\0');
    if (napi_get_value_string_utf8(env, value, buffer.data(), buffer.size(), &length) != napi_ok) {
        return false;
    }
    output.assign(buffer.data(), length);
    return true;
}

// Look up a camera instance by cameraId and return nullptr when it is unavailable.
static NDKCamera *FindCameraById(const char *cameraId)
{
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt == g_mapCameraDevice_.end() || ndkCameraIt->second == nullptr) {
        return nullptr;
    }
    return ndkCameraIt->second;
}

// Release the active capture session for a specific camera instance.
static int32_t ReleaseCameraSessionById(const std::string &cameraId)
{
    NDKCamera *cameraInstance = FindCameraById(cameraId.c_str());
    if (cameraInstance == nullptr) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 未找到相机实例: %{public}s", cameraId.c_str());
        return INIT_CAMERA_FAILURE;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: 找到相机实例，释放session: %{public}s", cameraId.c_str());
    Camera_ErrorCode releaseResult = cameraInstance->ReleaseSession();
    if (releaseResult != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP,
            "multi_camera: 相机session释放失败: %{public}s, error: %{public}d",
            cameraId.c_str(), releaseResult);
        return INIT_CAMERA_FAILURE;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: 相机session释放完成: %{public}s", cameraId.c_str());
    return INIT_CAMERA_SUCCESS;
}

// Dispatch photo or video capture according to the requested mode.
static Camera_ErrorCode StartCaptureByMode(
    NDKCamera *cameraInstance, const std::string &modeFlag, const std::string &videoId, const std::string &photoId)
{
    if (modeFlag == "photo") {
        OH_LOG_ERROR(LOG_APP, "multi_camera: StartPhoto surfaceId %{public}s", photoId.c_str());
        Camera_ErrorCode ret = cameraInstance->StartPhoto(const_cast<char *>(photoId.c_str()));
        OH_LOG_ERROR(LOG_APP, "multi_camera: StartPhoto result: %{public}d", ret);
        return ret;
    }
    if (modeFlag == "video") {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: StartVideo videoId: %{public}s, photoId: %{public}s",
            videoId.c_str(), photoId.c_str());
        Camera_ErrorCode ret = cameraInstance->StartVideo(
            const_cast<char *>(videoId.c_str()), const_cast<char *>(photoId.c_str()));
        OH_LOG_ERROR(LOG_APP, "multi_camera: StartVideo result: %{public}d", ret);
        return ret;
    }
    return CAMERA_INVALID_ARGUMENT;
}

// Stop and release the current video output for the target camera.
static int32_t StopAndReleaseVideoOutputForCamera(const char *cameraId)
{
    NDKCamera *cameraInstance = FindCameraById(cameraId);
    if (cameraInstance == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Camera not found or null for cameraId: %{public}s", cameraId);
        return -1;
    }

    OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ found for camera: %{public}s", cameraId);
    Camera_ErrorCode stopResult = cameraInstance->VideoOutputStop();
    if (stopResult != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP, "VideoOutputStop failed for camera: %{public}s, error: %{public}d", cameraId, stopResult);
    }

    Camera_ErrorCode releaseResult = cameraInstance->VideoOutputRelease();
    if (releaseResult != CAMERA_OK) {
        OH_LOG_ERROR(
            LOG_APP, "VideoOutputRelease failed for camera: %{public}s, error: %{public}d",
            cameraId, releaseResult);
        return -1;
    }
    return 0;
}

static napi_value SetZoomRatio(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t zoomRatio;
    napi_get_value_int32(env, args[0], &zoomRatio);

    OH_LOG_ERROR(LOG_APP, "SetZoomRatio : %{public}d", zoomRatio);
    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->setZoomRatioFn(zoomRatio);
    }
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value HasFlash(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "HasFlash");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t flashMode;
    napi_get_value_int32(env, args[0], &flashMode);

    OH_LOG_ERROR(LOG_APP, "HasFlash flashMode : %{public}d", flashMode);
    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->HasFlashFn(flashMode);
    }
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsVideoStabilizationModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsVideoStabilizationModeSupportedFn");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t videoMode;
    napi_get_value_int32(env, args[0], &videoMode);

    OH_LOG_ERROR(LOG_APP, "IsVideoStabilizationModeSupportedFn videoMode : %{public}d", videoMode);
    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsVideoStabilizationModeSupportedFn(videoMode);
    }
    napi_create_int32(env, argc, &result);
    return result;
}
void ExecuteJSCallback(std::string cameraId, int status);

static bool CopySurfaceIdToHeap(const std::string &source, char *&surfaceId)
{
    try {
        surfaceId = new char[source.size() + 1];
    } catch (...) {
        surfaceId = nullptr;
        return false;
    }
    for (size_t index = 0; index <= source.size(); ++index) {
        surfaceId[index] = source[index];
    }
    return true;
}

static bool ParseInitCameraArgs(napi_env env, napi_callback_info info, InitCameraParams &params)
{
    size_t argc = ARGS_FOUR;
    napi_value args[ARGS_FOUR] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok || argc < INIT_CAMERA_REQUIRED_ARGS) {
        return false;
    }
    if (!GetUtf8String(env, args[0], params.surfaceId) ||
        napi_get_value_int32(env, args[1], &params.focusMode) != napi_ok ||
        !GetUtf8String(env, args[ARGS_TWO], params.cameraId)) {
        return false;
    }
    if (argc >= ARGS_FOUR) {
        napi_valuetype argType;
        if (napi_typeof(env, args[ARGS_THREE], &argType) == napi_ok && argType == napi_boolean &&
            napi_get_value_bool(env, args[ARGS_THREE], &params.isVideo) != napi_ok) {
            return false;
        }
    }
    return true;
}

static void ReleaseExistingCameraInstance(const std::string &cameraId)
{
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt == g_mapCameraDevice_.end() || ndkCameraIt->second == nullptr) {
        return;
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: 发现已存在的相机实例，安全释放: %{public}s", cameraId.c_str());
    try {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 释放相机资源: %{public}s", cameraId.c_str());
        ndkCameraIt->second->ReleaseCamera();
        OH_LOG_ERROR(LOG_APP, "multi_camera: 删除相机实例: %{public}s", cameraId.c_str());
        delete ndkCameraIt->second;
        ndkCameraIt->second = nullptr;
    } catch (...) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 释放相机实例时发生异常: %{public}s", cameraId.c_str());
        ndkCameraIt->second = nullptr;
    }
}

static bool CreateManagedCamera(const InitCameraParams &params)
{
    char *surfaceId = nullptr;
    if (!CopySurfaceIdToHeap(params.surfaceId, surfaceId)) {
        return false;
    }
    try {
        std::string cameraId = params.cameraId;
        ndkCamera_ = new NDKCamera(surfaceId, params.focusMode, cameraId, params.isVideo);
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: C++层NDKCamera创建成功 - cameraId:%{public}s", params.cameraId.c_str());
        return true;
    } catch (...) {
        delete[] surfaceId;
        ndkCamera_ = nullptr;
        return false;
    }
}

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCamera Start");
    napi_value result = nullptr;
    InitCameraParams params;
    if (!ParseInitCameraArgs(env, info, params)) {
        napi_create_int32(env, CAMERA_INVALID_ARGUMENT, &result);
        return result;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCamera focusMode : %{public}d", params.focusMode);
    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCamera surfaceId : %{public}s", params.surfaceId.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCamera cameraDeviceId : %{public}s", params.cameraId.c_str());
    OH_LOG_ERROR(
        LOG_APP,
        "multi_camera_test: C++层InitCamera开始 - cameraId:%{public}s surfaceId:%{public}s",
        params.cameraId.c_str(), params.surfaceId.c_str());

    ReleaseExistingCameraInstance(params.cameraId);
    usleep(CAMERA_RELEASE_DELAY_US);

    OH_LOG_ERROR(LOG_APP, "multi_camera: 开始创建新的NDKCamera实例: %{public}s", params.cameraId.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: C++层开始创建NDKCamera - cameraId:%{public}s", params.cameraId.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera: enableFeature参数: %{public}d", params.isVideo);
    if (!CreateManagedCamera(params)) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 创建NDKCamera实例失败: %{public}s", params.cameraId.c_str());
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: C++层NDKCamera创建失败 - cameraId:%{public}s", params.cameraId.c_str());
        napi_create_int32(env, INIT_CAMERA_FAILURE, &result);
        return result;
    }

    g_mapCameraDevice_[params.cameraId] = ndkCamera_;
    ndkCamera_ = nullptr;
    initRegisterCallback(g_mapCameraDevice_.size(), ExecuteJSCallback);
    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCamera RegisterCallback - 相机初始化完成: %{public}s", params.cameraId.c_str());
    OH_LOG_ERROR(LOG_APP, "multi_camera: 当前管理的相机数量: %{public}d", g_mapCameraDevice_.size());
    OH_LOG_ERROR(
        LOG_APP,
        "multi_camera_test: C++层InitCamera完成 - cameraId:%{public}s 管理数量:%{public}d",
        params.cameraId.c_str(), g_mapCameraDevice_.size());
    napi_create_int32(env, INIT_CAMERA_SUCCESS, &result);
    OH_LOG_ERROR(LOG_APP, "multi_camera_test: C++层InitCamera返回成功(0) - cameraId:%{public}s", params.cameraId.c_str());
    return result;
}

static napi_value UpdateSurfaceId(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: UpdateSurfaceId called");

    napi_value result = nullptr;
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取cameraId
    char cameraId[PATH_NAME_MAX] = {0};
    size_t cameraIdLen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &cameraIdLen);
    if (cameraIdLen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: UpdateSurfaceId cameraId len out of max : %{public}d", cameraIdLen);
        napi_create_int32(env, -1, &result);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, cameraIdLen + 1, &cameraIdLen);

    // 获取新的surfaceId
    char *newSurfaceId = nullptr;
    size_t surfaceIdLen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &surfaceIdLen);
    newSurfaceId = new char[surfaceIdLen + 1];
    napi_get_value_string_utf8(env, args[1], newSurfaceId, surfaceIdLen + 1, &surfaceIdLen);

    OH_LOG_ERROR(
        LOG_APP,
        "multi_camera_test: UpdateSurfaceId - cameraId:%{public}s newSurfaceId:%{public}s",
        cameraId, newSurfaceId);

    // 查找对应的摄像头实例
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        try {
            // 更新surfaceId
            ndkCameraIt->second->UpdateSurfaceId(newSurfaceId);
            OH_LOG_ERROR(LOG_APP, "multi_camera_test: UpdateSurfaceId成功 - cameraId:%{public}s", cameraId);
            napi_create_int32(env, 0, &result);
        } catch (...) {
            OH_LOG_ERROR(LOG_APP, "multi_camera_test: UpdateSurfaceId失败 - cameraId:%{public}s", cameraId);
            napi_create_int32(env, -1, &result);
        }
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: UpdateSurfaceId未找到摄像头实例 - cameraId:%{public}s", cameraId);
        napi_create_int32(env, -1, &result);
    }

    delete[] newSurfaceId;
    return result;
}

static napi_value InitCameraManager(napi_env env, napi_callback_info info)
{
    // 强制输出日志，确保这个方法被调用
    printf(" == = FORCE LOG: InitCameraManager called == = \n");
    OH_LOG_ERROR(LOG_APP, " == = FORCE LOG: InitCameraManager Start == = ");
    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCameraManager Start - 初始化摄像头管理器以监听热插拔");

    napi_value result = nullptr;
    int32_t resultCode = 0; // 0: success, -1: error

    try {
        // 简化热插拔监听管理器，不创建空的摄像头实例
        // 直接注册JavaScript回调函数，避免创建无效的摄像头实例
        OH_LOG_ERROR(LOG_APP, "multi_camera: 初始化热插拔监听管理器");
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: InitCameraManager - 避免创建空摄像头实例");

        // 关键：注册JavaScript回调函数，这样摄像头状态变化时才能通知到JavaScript层
        OH_LOG_ERROR(LOG_APP, "multi_camera: 注册JavaScript回调函数");
        initRegisterCallback(0, ExecuteJSCallback); // 使用0而不是map大小，避免计数错误
        OH_LOG_ERROR(LOG_APP, "multi_camera: JavaScript回调函数注册完成");
        OH_LOG_ERROR(LOG_APP, "multi_camera_test: InitCameraManager完成 - 未创建额外摄像头实例");
    } catch (...) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: InitCameraManager 发生异常");
        resultCode = -1;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: InitCameraManager End with result: %{public}d", resultCode);
    napi_create_int32(env, resultCode, &result);
    return result;
}

static napi_value ReleaseCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseCamera Start");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseCamera cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 找到相机实例，开始释放: %{public}s", cameraId);
        ndkCameraIt->second->ReleaseCamera();
        delete ndkCameraIt->second;
        ndkCameraIt->second = nullptr;
        g_mapCameraDevice_.erase(ndkCameraIt);
        OH_LOG_ERROR(LOG_APP, "multi_camera: unRegisterCallback 相机实例释放完成: %{public}s", cameraId);
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 未找到相机实例: %{public}s", cameraId);
    }
    if (g_mapCameraDevice_.size() == 0) {
        unInitRegisterCallback();
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: 当前管理的相机数量: %{public}d", g_mapCameraDevice_.size());
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}
static napi_value ReleaseSession(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseSession Start");
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result = nullptr;
    int32_t resultCode = INIT_CAMERA_SUCCESS;
    std::string cameraId;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < 1 || args[0] == nullptr || !GetUtf8String(env, args[0], cameraId)) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseSession - Invalid arguments");
        resultCode = INIT_CAMERA_FAILURE;
        napi_create_int32(env, resultCode, &result);
        return result;
    }
    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseSession cameraDevice name: %{public}s", cameraId.c_str());

    try {
        resultCode = ReleaseCameraSessionById(cameraId);
    } catch (...) {
        OH_LOG_ERROR(
            LOG_APP, "multi_camera: Exception occurred in ReleaseSession for camera: %{public}s", cameraId.c_str());
        resultCode = INIT_CAMERA_FAILURE;
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: ReleaseSession End with result: %{public}d", resultCode);
    napi_create_int32(env, resultCode, &result);
    return result;
}
static napi_value StartPhotoOrVideo(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "multi_camera: StartPhotoOrVideo Start");
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_value result = nullptr;
    std::string modeFlag;
    std::string videoId;
    std::string photoId;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARGS_FOUR || !GetUtf8String(env, args[0], modeFlag) || !GetUtf8String(env, args[1], videoId) ||
        !GetUtf8String(env, args[ARGS_TWO], photoId)) {
        napi_create_int32(env, CAMERA_INVALID_ARGUMENT, &result);
        return result;
    }

    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[ARGS_TWO + 1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: get cameraId len out of max: %{public}d", tILen);
        napi_create_int32(env, CAMERA_INVALID_ARGUMENT, &result);
        return result;
    }
    napi_get_value_string_utf8(env, args[ARGS_TWO + 1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "multi_camera: StartPhotoOrVideo cameraDevice name: %{public}s", cameraId);

    OH_LOG_ERROR(
        LOG_APP, "multi_camera: StartPhotoOrVideo mode: %{public}s, cameraId: %{public}s",
        modeFlag.c_str(), cameraId);
    NDKCamera *cameraInstance = FindCameraById(cameraId);
    Camera_ErrorCode ret = CAMERA_INVALID_ARGUMENT;
    if (cameraInstance == nullptr) {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 未找到相机实例: %{public}s", cameraId);
    } else {
        OH_LOG_ERROR(LOG_APP, "multi_camera: 找到相机实例，开始拍照/录像");
        ret = StartCaptureByMode(cameraInstance, modeFlag, videoId, photoId);
    }

    OH_LOG_ERROR(LOG_APP, "multi_camera: StartPhotoOrVideo End with result: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value VideoOutputStart(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "VideoOutputStart Start");
    napi_value result;

    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max : %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name : %{public}s", cameraId);
    //=========================

    // 处理 enableMirror 参数，默认为 true
    bool enableMirror = true;
    if (argc > 1 && args[1] != nullptr) {
        napi_get_value_bool(env, args[1], &enableMirror);
        OH_LOG_ERROR(LOG_APP, "enableMirror: %{public}d", enableMirror);
    }

    //add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    Camera_ErrorCode ret;
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ret = ndkCameraIt->second->VideoOutputStart(enableMirror);
    }

    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value IsExposureModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported exposureMode start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t exposureMode;
    napi_get_value_int32(env, args[0], &exposureMode);

    OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported exposureMode : %{public}d", exposureMode);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsExposureModeSupportedFn(exposureMode);
    }
    OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported exposureMode end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsMeteringPoint(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    int x;
    napi_get_value_int32(env, args[0], &x);

    napi_valuetype valuetype1;
    napi_typeof(env, args[0], &valuetype0);
    int y;
    napi_get_value_int32(env, args[1], &y);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[ARGS_TWO], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[ARGS_TWO], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsMeteringPoint(x, y);
    }
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsExposureBiasRange(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsExposureBiasRange start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int exposureBiasValue;
    napi_get_value_int32(env, args[0], &exposureBiasValue);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsExposureBiasRange(exposureBiasValue);
    }
    OH_LOG_ERROR(LOG_APP, "IsExposureBiasRange end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsFocusModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsFocusModeSupported start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t focusMode;
    napi_get_value_int32(env, args[0], &focusMode);

    OH_LOG_ERROR(LOG_APP, "IsFocusModeSupportedFn videoMode : %{public}d", focusMode);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsFocusModeSupported(focusMode);
    }

    OH_LOG_ERROR(LOG_APP, "IsFocusModeSupported end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsFocusPoint(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    double x;
    napi_get_value_double(env, args[0], &x);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);
    double y;
    napi_get_value_double(env, args[1], &y);

    float focusPointX = static_cast<float>(x);
    float focusPointY = static_cast<float>(y);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[ARGS_TWO], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[ARGS_TWO], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ndkCameraIt->second->IsFocusPoint(focusPointX, focusPointY);
    }
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value GetVideoFrameWidth(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameWidth Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================

    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        napi_create_int32(env, ndkCameraIt->second->GetVideoFrameWidth(), &result);
    }

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameWidth End");
    return result;
}

static napi_value GetVideoFrameHeight(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameHeight Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        napi_create_int32(env, ndkCameraIt->second->GetVideoFrameHeight(), &result);
    }

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameHeight End");
    return result;
}

static napi_value GetVideoFrameRate(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameRate Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        napi_create_int32(env, ndkCameraIt->second->GetVideoFrameRate(), &result);
    }

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameRate End");
    return result;
}

static napi_value VideoOutputStopAndRelease(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    int32_t resultCode = 0; // 0: success, -1: error

    // 参数验证
    if (argc < 1 || args[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease: Invalid arguments");
        resultCode = -1;
        napi_create_int32(env, resultCode, &result);
        return result;
    }

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        resultCode = -1;
        napi_create_int32(env, resultCode, &result);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);

    try {
        resultCode = StopAndReleaseVideoOutputForCamera(cameraId);
    } catch (...) {
        OH_LOG_ERROR(LOG_APP, "Exception occurred in VideoOutputStopAndRelease for camera: %{public}s", cameraId);
        resultCode = -1;
    }

    OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease End with result: %{public}d", resultCode);
    napi_create_int32(env, resultCode, &result);
    return result;
}

static napi_value TakePicture(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "TakePicture Start");
    napi_value result;
    size_t argc = 5;
    napi_value args[1] = {nullptr};
    OH_LOG_ERROR(LOG_APP, "cheyang argc ; %{public}d", argc);
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[0], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    Camera_ErrorCode ret;
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ret = ndkCameraIt->second->TakePicture();
    }
    OH_LOG_ERROR(LOG_APP, "TakePicture result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value GetCaptureParam(napi_env env, napi_value captureConfigValue, Capture_Setting *config)
{
    napi_value value = nullptr;
    napi_get_named_property(env, captureConfigValue, "quality", &value);
    napi_get_value_int32(env, value, &config->quality);

    napi_get_named_property(env, captureConfigValue, "rotation", &value);
    napi_get_value_int32(env, value, &config->rotation);

    napi_get_named_property(env, captureConfigValue, "mirror", &value);
    napi_get_value_bool(env, value, &config->mirror);

    napi_get_named_property(env, captureConfigValue, "latitude", &value);
    napi_get_value_int32(env, value, &config->latitude);

    napi_get_named_property(env, captureConfigValue, "longitude", &value);
    napi_get_value_int32(env, value, &config->longitude);

    napi_get_named_property(env, captureConfigValue, "altitude", &value);
    napi_get_value_int32(env, value, &config->altitude);

    OH_LOG_ERROR(LOG_APP, "get quality %{public}d, rotation %{public}d, mirror %{public}d, latitude "
        "%{public}d, longitude %{public}d, altitude %{public}d", config->quality, config->rotation,
        config->mirror, config->latitude, config->longitude, config->altitude);
    return 0;
}
static void SetConfig(Capture_Setting settings, Camera_PhotoCaptureSetting *photoSetting, Camera_Location *location)
{
    if (photoSetting == nullptr || location == nullptr) {
        OH_LOG_ERROR(LOG_APP, "photoSetting is null");
    }
    photoSetting->quality = static_cast<Camera_QualityLevel>(settings.quality);
    photoSetting->rotation = static_cast<Camera_ImageRotation>(settings.rotation);
    photoSetting->mirror = settings.mirror;
    location->altitude = settings.altitude;
    location->latitude = settings.latitude;
    location->longitude = settings.longitude;
    photoSetting->location = location;
}

static napi_value TakePictureWithSettings(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "TakePictureWithSettings Start");
    size_t requireArgc = 1;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    Camera_PhotoCaptureSetting photoSetting;
    Capture_Setting settingInner;
    Camera_Location *location = new Camera_Location;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    GetCaptureParam(env, args[0], &settingInner);
    SetConfig(settingInner, &photoSetting, location);

    napi_value result;

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
    //=========================
    // add by multcamera
    Camera_ErrorCode ret;
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ret = ndkCameraIt->second->TakePictureWithPhotoSettings(photoSetting);
    }

    OH_LOG_ERROR(LOG_APP, "TakePictureWithSettings result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value setPhotoSettings(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "setPhotoSettings Start");
    size_t requireArgc = 1;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    Camera_PhotoCaptureSetting photoSetting;
    Capture_Setting settingInner;
    Camera_Location *location = new Camera_Location;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    GetCaptureParam(env, args[0], &settingInner);
    SetConfig(settingInner, &photoSetting, location);

    napi_value result;

    //=========================
    char cameraId[PATH_NAME_MAX] = {0};
    size_t tILen = 0;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &tILen);
    if (tILen >= PATH_NAME_MAX) {
        OH_LOG_ERROR(LOG_APP, "get cameraId len out of max: %{public}d", tILen);
        return result;
    }
    napi_get_value_string_utf8(env, args[1], cameraId, tILen + 1, &tILen);
    OH_LOG_ERROR(LOG_APP, "cameraDevice name: %{public}s", cameraId);
//     //=========================
//     // add by multcamera
    Camera_ErrorCode ret;
    auto ndkCameraIt = g_mapCameraDevice_.find(cameraId);
    if (ndkCameraIt != g_mapCameraDevice_.end() && nullptr != ndkCameraIt->second) {
        OH_LOG_ERROR(LOG_APP, "mult ndkCamera_ is not null");
        ret = ndkCameraIt->second->setPhotoSettings(photoSetting);
    }

    OH_LOG_ERROR(LOG_APP, "setPhotoSettings result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value ResolutionPhoto(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionPhoto Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *resolutionPhoto = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    resolutionPhoto = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], resolutionPhoto, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionPhoto resolutionPhoto : %{public}s", resolutionPhoto);

    if (g_cameraSetting) {
        OH_LOG_INFO(LOG_APP, "g_cameraSetting is not null");
        delete g_cameraSetting;
        g_cameraSetting = nullptr;
    }
    g_cameraSetting = new CameraSetting();
    CameraSettingErrorCode ret = g_cameraSetting->ResolutionPhoto(resolutionPhoto);
    delete[] resolutionPhoto;

    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionPhoto End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

static napi_value ResolutionVedio(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionVedio Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *resolutionPhoto = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    resolutionPhoto = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], resolutionPhoto, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionVedio resolutionVedio : %{public}s", resolutionPhoto);

    if (g_cameraSetting) {
        OH_LOG_INFO(LOG_APP, "g_cameraSetting is not null");
        delete g_cameraSetting;
        g_cameraSetting = nullptr;
    }
    g_cameraSetting = new CameraSetting();
    CameraSettingErrorCode ret = g_cameraSetting->ResolutionVideo(resolutionPhoto);
    delete[] resolutionPhoto;

    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionVedio End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

static napi_value WatermarkPhotoPic(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoPic Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *photoPicPath = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    photoPicPath = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], photoPicPath, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoPic photoPicPath : %{public}s", photoPicPath);

    if (g_cameraWatermark) {
        OH_LOG_INFO(LOG_APP, "g_cameraWatermark is not null");
        delete g_cameraWatermark;
        g_cameraWatermark = nullptr;
    }
    g_cameraWatermark = new CameraWatermark();
    CameraWatermarkErrorCode ret = g_cameraWatermark->WatermarkPhotoPic(photoPicPath);
    delete[] photoPicPath;

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoPic End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

static napi_value WatermarkPhotoFont(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoFont Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *photoFontStr = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    photoFontStr = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], photoFontStr, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoFont photoFontStr : %{public}s", photoFontStr);

    if (g_cameraWatermark) {
        OH_LOG_INFO(LOG_APP, "g_cameraWatermark is not null");
        delete g_cameraWatermark;
        g_cameraWatermark = nullptr;
    }
    g_cameraWatermark = new CameraWatermark();
    CameraWatermarkErrorCode ret = g_cameraWatermark->WatermarkPhotoFont(photoFontStr);
    delete[] photoFontStr;

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoFont End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

static napi_value WatermarkVedioPic(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioPic Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *vedioPicPath = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    vedioPicPath = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], vedioPicPath, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioPic vedioPicPath : %{public}s", vedioPicPath);

    if (g_cameraWatermark) {
        OH_LOG_INFO(LOG_APP, "g_cameraWatermark is not null");
        delete g_cameraWatermark;
        g_cameraWatermark = nullptr;
    }
    g_cameraWatermark = new CameraWatermark();
    CameraWatermarkErrorCode ret = g_cameraWatermark->WatermarkVedioPic(vedioPicPath);
    delete[] vedioPicPath;

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioPic End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

static napi_value WatermarkVedioFont(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioFont Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char *vedioFontStr = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    vedioFontStr = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], vedioFontStr, typeLen + 1, &typeLen);

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioFont vedioFontStr : %{public}s", vedioFontStr);

    if (g_cameraWatermark) {
        OH_LOG_INFO(LOG_APP, "g_cameraWatermark is not null");
        delete g_cameraWatermark;
        g_cameraWatermark = nullptr;
    }
    g_cameraWatermark = new CameraWatermark();
    CameraWatermarkErrorCode ret = g_cameraWatermark->WatermarkVedioFont(vedioFontStr);
    delete[] vedioFontStr;

    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioFont End");
    napi_create_int32(env, static_cast<int32_t>(ret), &result);
    return result;
}

void CallJS(napi_env env, napi_value js_cb, void *context, void *data)
{
    OH_LOG_INFO(LOG_APP, "camerastatus CallJS begin.");
    napi_value undefined;
    napi_value result;
    napi_value argv[ARGS_TWO];
    napi_get_undefined(env, &undefined);
    CameraStatusArgs *args = (CameraStatusArgs *)data;
    napi_create_string_utf8(env, args->cameraId.c_str(), NAPI_AUTO_LENGTH, &argv[0]);
    napi_create_int32(env, static_cast<int32_t>(args->status), &argv[1]);
    napi_call_function(env, undefined, js_cb, ARGS_TWO, argv, &result);
    delete static_cast<CameraStatusArgs*>(data);
}

void ExecuteJSCallback(std::string cameraId, int status)
{
    OH_LOG_INFO(LOG_APP, "camerastatus ExecuteJSCallback!");
    if (cameraCBfn == nullptr) {
        OH_LOG_INFO(LOG_APP, "camerastatus cameraCBfn is nullptr!");
        return;
    }
    CameraStatusArgs *args = new CameraStatusArgs;
    args->cameraId = cameraId;
    args->status = status;
    napi_status tstatus = napi_call_threadsafe_function(cameraCBfn, args, napi_tsfn_blocking);
    if (tstatus != napi_ok) {
        OH_LOG_INFO(LOG_APP, "camerastatus napi_call_threadsafe_function failed!status is %{public}d", tstatus);
    }
}

napi_value cameraStatusCallBack(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "camerastatus cameraStatusCallBack register.");
    napi_value js_cb;
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_cb, nullptr, nullptr);
    napi_value work_name;
    napi_create_string_utf8(env, "cameraStatusCallBack", NAPI_AUTO_LENGTH, &work_name);
    napi_create_threadsafe_function(
        env, js_cb, nullptr, work_name, 0, 1, nullptr, nullptr, nullptr, CallJS, &cameraCBfn);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "initCamera", nullptr, InitCamera, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "initCameraManager", nullptr, InitCameraManager, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "startPhotoOrVideo", nullptr, StartPhotoOrVideo, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "videoOutputStart", nullptr, VideoOutputStart, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setZoomRatio", nullptr, SetZoomRatio, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hasFlash", nullptr, HasFlash, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isVideoStabilizationModeSupported", nullptr, IsVideoStabilizationModeSupported,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureModeSupported", nullptr, IsExposureModeSupported,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "IsFocusModeSupported", nullptr, IsFocusModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isFocusPoint", nullptr, IsFocusPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameWidth", nullptr, GetVideoFrameWidth, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameHeight", nullptr, GetVideoFrameHeight, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameRate", nullptr, GetVideoFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "videoOutputStopAndRelease", nullptr, VideoOutputStopAndRelease,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePicture", nullptr, TakePicture, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePictureWithSettings", nullptr, TakePictureWithSettings, nullptr, nullptr, nullptr,
          napi_default, nullptr },
        { "setPhotoSettings", nullptr, setPhotoSettings, nullptr, nullptr, nullptr,
          napi_default, nullptr },
        { "releaseSession", nullptr, ReleaseSession, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "resolutionPhoto", nullptr, ResolutionPhoto, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "resolutionVedio", nullptr, ResolutionVedio, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "watermarkPhotoPic", nullptr, WatermarkPhotoPic, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "watermarkVedioPic", nullptr, WatermarkVedioPic, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "watermarkPhotoFont", nullptr, WatermarkPhotoFont, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "watermarkVedioFont", nullptr, WatermarkVedioFont, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "updateSurfaceId", nullptr, UpdateSurfaceId, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "cameraStatusCallBack", nullptr, cameraStatusCallBack, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
