/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <memory>
#include <mutex>
#include <string>
#include <unordered_map>

#include "hilog/log.h"
#include "napi/native_api.h"

#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <ohaudio/native_audiocapturer.h>
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostream_base.h>
#include <ohaudio/native_audiostreambuilder.h>
#include <ohaudio/native_audio_common.h>
// [Start header_file]
#include <ohaudio/native_audio_debugging_manager.h>
// [End header_file]

#include "NapiUtils.h"

namespace {
// 文件权限：所有者读写，组和其他用户只读
constexpr mode_t FILE_PERMISSION = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
constexpr int32_t SUCCESS = 0;
constexpr int32_t ERROR = 1;
constexpr int32_t LOW_LATENCY_CAPTURER_RELEASED = 0;
constexpr int32_t LOW_LATENCY_CAPTURER_STOPPED = 1;
constexpr int32_t LOW_LATENCY_CAPTURER_RUNNING = 2;
constexpr int32_t PCM_PLAYER_IDLE = 0;
constexpr int32_t PCM_PLAYER_PLAYING = 1;
constexpr int32_t PCM_PLAYER_COMPLETED = 2;
constexpr int32_t LOW_LATENCY_CALLBACK_FRAME_SIZE_MS = 10;
constexpr int32_t PCM_PLAYER_CALLBACK_FRAME_SIZE_MS = 20;

// Argument count constants
constexpr size_t ARG_COUNT_ONE = 1;
constexpr size_t ARG_COUNT_TWO = 2;
constexpr size_t ARG_COUNT_FIVE = 5;

// Argument index constants
constexpr size_t ARG_INDEX_ZERO = 0;
constexpr size_t ARG_INDEX_ONE = 1;
constexpr size_t ARG_INDEX_TWO = 2;
constexpr size_t ARG_INDEX_THREE = 3;
constexpr size_t ARG_INDEX_FOUR = 4;

// Frame size calculation: ms * sampleRate / MS_PER_SECOND
constexpr int32_t MS_PER_SECOND = 1000;

struct StreamInitParams {
    int32_t streamId = 0;
    int32_t sourceType = 0;
    int32_t sampleRate = 0;
    int32_t channelCount = 0;
    int32_t sampleFormat = 0;
};

struct PlayerStartParams {
    int32_t streamId = 0;
    std::string path;
    int32_t sampleRate = 0;
    int32_t channelCount = 0;
    int32_t sampleFormat = 0;
};

struct LowLatencyCapturerContext {
    int32_t id = 0;
    OH_AudioCapturer *capturer = nullptr;
    bool isRunning = false;
    std::mutex statsMutex;
    int64_t capturedBytes = 0;
    int32_t callbackCount = 0;
    int32_t lastReadSize = 0;
    int32_t lastFastStatus = -1;
    int32_t lastError = 0;
    std::mutex saveMutex;
    FILE *saveFile = nullptr;
    int64_t savedBytes = 0;
};

struct PcmPlayerContext {
    int32_t id = 0;
    OH_AudioRenderer *renderer = nullptr;
    FILE *file = nullptr;
    bool isPlaying = false;
    bool isCompleted = false;
    int32_t lastError = 0;
    int64_t totalBytes = 0;
    int64_t playedBytes = 0;
    std::mutex mutex;
};

std::unordered_map<int32_t, std::shared_ptr<LowLatencyCapturerContext>> g_lowLatencyCapturers;
std::mutex g_lowLatencyCapturersMutex;
std::unordered_map<int32_t, std::shared_ptr<PcmPlayerContext>> g_pcmPlayers;
std::mutex g_pcmPlayersMutex;

int32_t ToInt32Result(OH_AudioStream_Result result)
{
    return static_cast<int32_t>(result);
}

void LogStreamResultIfFailed(const char *action, OH_AudioStream_Result result)
{
    if (result != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "%{public}s failed, ret=%{public}d", action, ToInt32Result(result));
    }
}

OH_AudioCommon_Result PrintCapturerSnapshotByC(OH_AudioCapturer *capturer, int32_t fd)
{
    if (capturer == nullptr) {
        return AUDIOCOMMON_RESULT_ERROR_INVALID_PARAM;
    }
    OH_AudioDebuggingManager *manager = nullptr;
    OH_AudioCommon_Result ret = OH_AudioManager_GetAudioDebuggingManager(&manager);
    if (ret != AUDIOCOMMON_RESULT_SUCCESS || manager == nullptr) {
        return ret == AUDIOCOMMON_RESULT_SUCCESS ? AUDIOCOMMON_RESULT_ERROR_SYSTEM : ret;
    }
    return OH_AudioDebuggingManager_PrintCapturerInfo(manager, capturer, fd);
}

OH_AudioCommon_Result PrintRendererSnapshotByC(OH_AudioRenderer *renderer, int32_t fd)
{
    if (renderer == nullptr) {
        return AUDIOCOMMON_RESULT_ERROR_INVALID_PARAM;
    }
    OH_AudioDebuggingManager *manager = nullptr;
    OH_AudioCommon_Result ret = OH_AudioManager_GetAudioDebuggingManager(&manager);
    if (ret != AUDIOCOMMON_RESULT_SUCCESS || manager == nullptr) {
        return ret == AUDIOCOMMON_RESULT_SUCCESS ? AUDIOCOMMON_RESULT_ERROR_SYSTEM : ret;
    }
    return OH_AudioDebuggingManager_PrintRendererInfo(manager, renderer, fd);
}

OH_AudioCommon_Result PrintAppSnapshotByC(int32_t fd)
{
    OH_AudioDebuggingManager *manager = nullptr;
    OH_AudioCommon_Result ret = OH_AudioManager_GetAudioDebuggingManager(&manager);
    if (ret != AUDIOCOMMON_RESULT_SUCCESS || manager == nullptr) {
        return ret == AUDIOCOMMON_RESULT_SUCCESS ? AUDIOCOMMON_RESULT_ERROR_SYSTEM : ret;
    }
    return OH_AudioDebuggingManager_PrintAppInfo(manager, fd);
}

std::shared_ptr<LowLatencyCapturerContext> GetOrCreateLowLatencyCapturer(int32_t id)
{
    std::lock_guard<std::mutex> lock(g_lowLatencyCapturersMutex);
    auto iter = g_lowLatencyCapturers.find(id);
    if (iter != g_lowLatencyCapturers.end()) {
        return iter->second;
    }
    auto context = std::make_shared<LowLatencyCapturerContext>();
    context->id = id;
    g_lowLatencyCapturers[id] = context;
    return context;
}

std::shared_ptr<LowLatencyCapturerContext> FindLowLatencyCapturer(int32_t id)
{
    std::lock_guard<std::mutex> lock(g_lowLatencyCapturersMutex);
    auto iter = g_lowLatencyCapturers.find(id);
    if (iter == g_lowLatencyCapturers.end()) {
        return nullptr;
    }
    return iter->second;
}

std::shared_ptr<LowLatencyCapturerContext> TakeLowLatencyCapturer(int32_t id)
{
    std::lock_guard<std::mutex> lock(g_lowLatencyCapturersMutex);
    auto iter = g_lowLatencyCapturers.find(id);
    if (iter == g_lowLatencyCapturers.end()) {
        return nullptr;
    }
    std::shared_ptr<LowLatencyCapturerContext> context = iter->second;
    g_lowLatencyCapturers.erase(iter);
    return context;
}

std::shared_ptr<PcmPlayerContext> GetOrCreatePcmPlayer(int32_t id)
{
    std::lock_guard<std::mutex> lock(g_pcmPlayersMutex);
    auto iter = g_pcmPlayers.find(id);
    if (iter != g_pcmPlayers.end()) {
        return iter->second;
    }
    auto context = std::make_shared<PcmPlayerContext>();
    context->id = id;
    g_pcmPlayers[id] = context;
    return context;
}

std::shared_ptr<PcmPlayerContext> FindPcmPlayer(int32_t id)
{
    std::lock_guard<std::mutex> lock(g_pcmPlayersMutex);
    auto iter = g_pcmPlayers.find(id);
    if (iter == g_pcmPlayers.end()) {
        return nullptr;
    }
    return iter->second;
}

void ResetStats(const std::shared_ptr<LowLatencyCapturerContext> &context)
{
    if (context == nullptr) {
        return;
    }
    {
        std::lock_guard<std::mutex> lock(context->statsMutex);
        context->capturedBytes = 0;
        context->callbackCount = 0;
        context->lastReadSize = 0;
        context->lastFastStatus = -1;
        context->lastError = 0;
    }
    {
        std::lock_guard<std::mutex> lock(context->saveMutex);
        context->savedBytes = 0;
    }
}

void UpdateReadStats(LowLatencyCapturerContext *context, int32_t length)
{
    if (context == nullptr) {
        return;
    }
    std::lock_guard<std::mutex> lock(context->statsMutex);
    context->capturedBytes += static_cast<int64_t>(length);
    context->callbackCount += 1;
    context->lastReadSize = length;
}

void SetLastError(LowLatencyCapturerContext *context, int32_t error)
{
    if (context == nullptr) {
        return;
    }
    std::lock_guard<std::mutex> lock(context->statsMutex);
    context->lastError = error;
}

void CloseSaveFileLocked(LowLatencyCapturerContext &context)
{
    if (context.saveFile != nullptr) {
        fflush(context.saveFile);
        fclose(context.saveFile);
        context.saveFile = nullptr;
    }
}

int32_t SetSaveFile(const std::shared_ptr<LowLatencyCapturerContext> &context, const std::string &path)
{
    if (context == nullptr) {
        return ERROR;
    }
    std::lock_guard<std::mutex> lock(context->saveMutex);
    CloseSaveFileLocked(*context);
    if (path.empty()) {
        return SUCCESS;
    }
    context->savedBytes = 0;
    context->saveFile = fopen(path.c_str(), "wb");
    if (context->saveFile == nullptr) {
        return ERROR;
    }
    return SUCCESS;
}

void SaveReadData(LowLatencyCapturerContext *context, const void *buffer, int32_t length)
{
    if (context == nullptr || buffer == nullptr || length <= 0) {
        return;
    }
    std::lock_guard<std::mutex> lock(context->saveMutex);
    if (context->saveFile == nullptr) {
        return;
    }
    size_t written = fwrite(buffer, 1, static_cast<size_t>(length), context->saveFile);
    if (written != static_cast<size_t>(length)) {
        OH_LOG_WARN(LOG_APP, "SaveReadData partial write: expected=%{public}d actual=%{public}zu",
            length, written);
    }
    context->savedBytes += static_cast<int64_t>(written);
}

void SetNamedInt32Property(napi_env env, napi_value object, const char *name, int32_t value)
{
    napi_value propertyValue = nullptr;
    napi_create_int32(env, value, &propertyValue);
    napi_set_named_property(env, object, name, propertyValue);
}

void SetNamedInt64Property(napi_env env, napi_value object, const char *name, int64_t value)
{
    napi_value propertyValue = nullptr;
    napi_create_int64(env, value, &propertyValue);
    napi_set_named_property(env, object, name, propertyValue);
}

bool GetStreamIdArg(napi_env env, napi_callback_info info, int32_t &streamId)
{
    size_t argc = ARG_COUNT_ONE;
    napi_value argv[ARG_COUNT_ONE] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_ONE) {
        return false;
    }
    return NapiUtils::GetValueInt32(env, streamId, argv[ARG_INDEX_ZERO]) == napi_ok;
}

bool GetStreamIdAndPathArgs(napi_env env, napi_callback_info info, int32_t &streamId, std::string &path)
{
    size_t argc = ARG_COUNT_TWO;
    napi_value argv[ARG_COUNT_TWO] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_TWO) {
        return false;
    }
    if (NapiUtils::GetValueInt32(env, streamId, argv[ARG_INDEX_ZERO]) != napi_ok) {
        return false;
    }

    size_t pathLength = 0;
    status = napi_get_value_string_utf8(env, argv[ARG_INDEX_ONE], nullptr, 0, &pathLength);
    if (status != napi_ok) {
        return false;
    }
    path.resize(pathLength + 1);
    size_t copiedLength = 0;
    status = napi_get_value_string_utf8(env, argv[ARG_INDEX_ONE], &path[0], pathLength + 1, &copiedLength);
    if (status != napi_ok) {
        return false;
    }
    path.resize(copiedLength);
    return true;
}

bool GetFileDescriptorArg(napi_env env, napi_value value, int32_t &fd)
{
    return NapiUtils::GetValueInt32(env, fd, value) == napi_ok;
}

bool GetFdArg(napi_env env, napi_callback_info info, int32_t &fd)
{
    size_t argc = ARG_COUNT_ONE;
    napi_value argv[ARG_COUNT_ONE] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_ONE) {
        return false;
    }
    return GetFileDescriptorArg(env, argv[ARG_INDEX_ZERO], fd);
}

bool GetStreamIdAndFdArgs(napi_env env, napi_callback_info info, int32_t &streamId, int32_t &fd)
{
    size_t argc = ARG_COUNT_TWO;
    napi_value argv[ARG_COUNT_TWO] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_TWO) {
        return false;
    }
    if (NapiUtils::GetValueInt32(env, streamId, argv[ARG_INDEX_ZERO]) != napi_ok) {
        return false;
    }
    return GetFileDescriptorArg(env, argv[ARG_INDEX_ONE], fd);
}

bool GetInitArgs(napi_env env, napi_callback_info info, StreamInitParams &params)
{
    size_t argc = ARG_COUNT_FIVE;
    napi_value argv[ARG_COUNT_FIVE] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_FIVE) {
        return false;
    }
    const size_t indices[] = {ARG_INDEX_ZERO, ARG_INDEX_ONE, ARG_INDEX_TWO, ARG_INDEX_THREE, ARG_INDEX_FOUR};
    int32_t *values[] = {&params.streamId, &params.sourceType, &params.sampleRate, &params.channelCount,
        &params.sampleFormat};
    for (size_t i = 0; i < sizeof(indices) / sizeof(indices[0]); i++) {
        if (NapiUtils::GetValueInt32(env, *values[i], argv[indices[i]]) != napi_ok) {
            return false;
        }
    }
    return true;
}

bool GetPlayerStartArgs(napi_env env, napi_callback_info info, PlayerStartParams &params)
{
    size_t argc = ARG_COUNT_FIVE;
    napi_value argv[ARG_COUNT_FIVE] = {};
    napi_value self = nullptr;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != ARG_COUNT_FIVE) {
        return false;
    }
    if (NapiUtils::GetValueInt32(env, params.streamId, argv[ARG_INDEX_ZERO]) != napi_ok) {
        return false;
    }
    size_t pathLength = 0;
    status = napi_get_value_string_utf8(env, argv[ARG_INDEX_ONE], nullptr, 0, &pathLength);
    if (status != napi_ok) {
        return false;
    }
    params.path.resize(pathLength + 1);
    size_t copiedLength = 0;
    status = napi_get_value_string_utf8(
        env, argv[ARG_INDEX_ONE], &params.path[0], pathLength + 1, &copiedLength);
    if (status != napi_ok) {
        return false;
    }
    params.path.resize(copiedLength);
    if (NapiUtils::GetValueInt32(env, params.sampleRate, argv[ARG_INDEX_TWO]) != napi_ok ||
        NapiUtils::GetValueInt32(env, params.channelCount, argv[ARG_INDEX_THREE]) != napi_ok ||
        NapiUtils::GetValueInt32(env, params.sampleFormat, argv[ARG_INDEX_FOUR]) != napi_ok) {
        return false;
    }
    return true;
}

void LowLatencyCapturerOnReadDataCallback(
    OH_AudioCapturer *capturer, void *userData, void *buffer, int32_t length)
{
    (void)capturer;
    if (buffer == nullptr || length <= 0) {
        return;
    }
    auto *context = static_cast<LowLatencyCapturerContext *>(userData);
    UpdateReadStats(context, length);
    SaveReadData(context, buffer, length);
}

OH_AudioData_Callback_Result PcmPlayerOnWriteDataCallback(
    OH_AudioRenderer *renderer, void *userData, void *buffer, int32_t bufferLen)
{
    (void)renderer;
    auto *context = static_cast<PcmPlayerContext *>(userData);
    if (context == nullptr || buffer == nullptr || bufferLen <= 0) {
        return AUDIO_DATA_CALLBACK_RESULT_VALID;
    }

    std::fill_n(static_cast<unsigned char *>(buffer), static_cast<size_t>(bufferLen), 0);
    std::lock_guard<std::mutex> lock(context->mutex);
    if (context->file == nullptr || context->isCompleted) {
        context->isCompleted = true;
        context->isPlaying = false;
        return AUDIO_DATA_CALLBACK_RESULT_VALID;
    }

    size_t readSize = fread(buffer, 1, static_cast<size_t>(bufferLen), context->file);
    if (readSize == 0 && ferror(context->file) != 0) {
        OH_LOG_WARN(LOG_APP, "fread error in PCM write callback");
    }
    context->playedBytes += static_cast<int64_t>(readSize);
    if (readSize < static_cast<size_t>(bufferLen) || context->playedBytes >= context->totalBytes) {
        context->isCompleted = true;
        context->isPlaying = false;
    }
    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}

void LowLatencyCapturerOnDeviceChange(
    OH_AudioCapturer *capturer, void *userData, OH_AudioDeviceDescriptorArray *deviceArray)
{
    (void)capturer;
    (void)deviceArray;
    auto *context = static_cast<LowLatencyCapturerContext *>(userData);
    int32_t id = context == nullptr ? -1 : context->id;
    OH_LOG_INFO(LOG_APP, "low latency capturer %{public}d device changed", id);
}

void LowLatencyCapturerOnInterrupt(
    OH_AudioCapturer *capturer, void *userData, OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint)
{
    (void)capturer;
    auto *context = static_cast<LowLatencyCapturerContext *>(userData);
    int32_t id = context == nullptr ? -1 : context->id;
    OH_LOG_INFO(LOG_APP, "low latency capturer %{public}d interrupt type=%{public}d hint=%{public}d",
        id, static_cast<int32_t>(type), static_cast<int32_t>(hint));
}

void LowLatencyCapturerOnError(OH_AudioCapturer *capturer, void *userData, OH_AudioStream_Result error)
{
    (void)capturer;
    auto *context = static_cast<LowLatencyCapturerContext *>(userData);
    SetLastError(context, ToInt32Result(error));
    int32_t id = context == nullptr ? -1 : context->id;
    OH_LOG_ERROR(LOG_APP, "low latency capturer %{public}d error=%{public}d", id, ToInt32Result(error));
}

int32_t ReleaseLowLatencyCapturerInternal(const std::shared_ptr<LowLatencyCapturerContext> &context)
{
    if (context == nullptr) {
        return SUCCESS;
    }

    int32_t result = SUCCESS;
    OH_AudioCapturer *capturer = context->capturer;
    context->capturer = nullptr;
    if (capturer != nullptr) {
        if (context->isRunning) {
            OH_AudioStream_Result stopResult = OH_AudioCapturer_Stop(capturer);
            LogStreamResultIfFailed("OH_AudioCapturer_Stop", stopResult);
            if (stopResult != AUDIOSTREAM_SUCCESS) {
                result = ToInt32Result(stopResult);
            }
        }
        OH_AudioStream_Result releaseResult = OH_AudioCapturer_Release(capturer);
        LogStreamResultIfFailed("OH_AudioCapturer_Release", releaseResult);
        if (releaseResult != AUDIOSTREAM_SUCCESS && result == SUCCESS) {
            result = ToInt32Result(releaseResult);
        }
    }
    context->isRunning = false;
    {
        std::lock_guard<std::mutex> lock(context->saveMutex);
        CloseSaveFileLocked(*context);
    }
    return result;
}

int32_t ReleasePcmPlayerInternal(const std::shared_ptr<PcmPlayerContext> &context)
{
    if (context == nullptr) {
        return SUCCESS;
    }

    int32_t result = SUCCESS;
    OH_AudioRenderer *renderer = nullptr;
    FILE *file = nullptr;
    {
        std::lock_guard<std::mutex> lock(context->mutex);
        renderer = context->renderer;
        file = context->file;
        context->renderer = nullptr;
        context->file = nullptr;
        context->isPlaying = false;
    }

    if (renderer != nullptr) {
        OH_AudioStream_Result stopResult = OH_AudioRenderer_Stop(renderer);
        LogStreamResultIfFailed("OH_AudioRenderer_Stop", stopResult);
        OH_AudioStream_Result releaseResult = OH_AudioRenderer_Release(renderer);
        LogStreamResultIfFailed("OH_AudioRenderer_Release", releaseResult);
        if (releaseResult != AUDIOSTREAM_SUCCESS && result == SUCCESS) {
            result = ToInt32Result(releaseResult);
        }
    }
    if (file != nullptr) {
        fclose(file);
    }
    return result;
}

napi_value CreateStatsValue(napi_env env, const std::shared_ptr<LowLatencyCapturerContext> &context)
{
    napi_value result = nullptr;
    napi_create_object(env, &result);

    int32_t state = LOW_LATENCY_CAPTURER_RELEASED;
    int32_t streamId = -1;
    int32_t latencyMode = -1;
    int32_t fastStatus = -1;
    int32_t frameSize = 0;
    int64_t capturedBytes = 0;
    int32_t callbackCount = 0;
    int32_t lastReadSize = 0;
    int32_t lastFastStatus = -1;
    int32_t lastError = 0;
    int64_t savedBytes = 0;

    if (context != nullptr && context->capturer != nullptr) {
        state = context->isRunning ? LOW_LATENCY_CAPTURER_RUNNING : LOW_LATENCY_CAPTURER_STOPPED;

        uint32_t nativeStreamId = 0;
        if (OH_AudioCapturer_GetStreamId(context->capturer, &nativeStreamId) == AUDIOSTREAM_SUCCESS) {
            streamId = static_cast<int32_t>(nativeStreamId);
        }

        int32_t nativeFrameSize = 0;
        if (OH_AudioCapturer_GetFrameSizeInCallback(context->capturer, &nativeFrameSize) == AUDIOSTREAM_SUCCESS) {
            frameSize = nativeFrameSize;
        }

        std::lock_guard<std::mutex> lock(context->statsMutex);
        capturedBytes = context->capturedBytes;
        callbackCount = context->callbackCount;
        lastReadSize = context->lastReadSize;
        lastFastStatus = context->lastFastStatus;
        lastError = context->lastError;
    }
    if (context != nullptr && context->capturer != nullptr) {
        std::lock_guard<std::mutex> lock(context->saveMutex);
        savedBytes = context->savedBytes;
    }

    SetNamedInt32Property(env, result, "state", state);
    SetNamedInt32Property(env, result, "streamId", streamId);
    SetNamedInt32Property(env, result, "latencyMode", latencyMode);
    SetNamedInt32Property(env, result, "fastStatus", fastStatus);
    SetNamedInt32Property(env, result, "frameSize", frameSize);
    SetNamedInt64Property(env, result, "capturedBytes", capturedBytes);
    SetNamedInt32Property(env, result, "callbackCount", callbackCount);
    SetNamedInt32Property(env, result, "lastReadSize", lastReadSize);
    SetNamedInt32Property(env, result, "lastFastStatus", lastFastStatus);
    SetNamedInt32Property(env, result, "lastError", lastError);
    SetNamedInt64Property(env, result, "savedBytes", savedBytes);
    return result;
}

napi_value CreatePlayerStatsValue(napi_env env, const std::shared_ptr<PcmPlayerContext> &context)
{
    napi_value result = nullptr;
    napi_create_object(env, &result);

    int32_t state = PCM_PLAYER_IDLE;
    int64_t playedBytes = 0;
    int64_t totalBytes = 0;
    int32_t lastError = 0;
    if (context != nullptr) {
        std::lock_guard<std::mutex> lock(context->mutex);
        if (context->isPlaying) {
            state = PCM_PLAYER_PLAYING;
        } else if (context->isCompleted) {
            state = PCM_PLAYER_COMPLETED;
        }
        playedBytes = context->playedBytes;
        totalBytes = context->totalBytes;
        lastError = context->lastError;
    }

    SetNamedInt32Property(env, result, "state", state);
    SetNamedInt64Property(env, result, "playedBytes", playedBytes);
    SetNamedInt64Property(env, result, "totalBytes", totalBytes);
    SetNamedInt32Property(env, result, "lastError", lastError);
    return result;
}

OH_AudioStream_Result SetCapturerStreamParams(OH_AudioStreamBuilder *builder, const StreamInitParams &params)
{
    OH_AudioStream_Result result = OH_AudioStreamBuilder_SetSamplingRate(builder, params.sampleRate);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetChannelCount(builder, params.channelCount);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetSampleFormat(
        builder, static_cast<OH_AudioStream_SampleFormat>(params.sampleFormat));
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetCapturerInfo(
        builder, static_cast<OH_AudioStream_SourceType>(params.sourceType));
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    return OH_AudioStreamBuilder_SetFrameSizeInCallback(
        builder, LOW_LATENCY_CALLBACK_FRAME_SIZE_MS * params.sampleRate / MS_PER_SECOND);
}

OH_AudioStream_Result SetCapturerCallbacks(OH_AudioStreamBuilder *builder,
    const std::shared_ptr<LowLatencyCapturerContext> &context)
{
    OH_AudioStream_Result result = OH_AudioStreamBuilder_SetCapturerReadDataCallback(
        builder, LowLatencyCapturerOnReadDataCallback, context.get());
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetCapturerDeviceChangeCallback(
        builder, LowLatencyCapturerOnDeviceChange, context.get());
    LogStreamResultIfFailed("OH_AudioStreamBuilder_SetCapturerDeviceChangeCallback", result);
    result = OH_AudioStreamBuilder_SetCapturerInterruptCallback(
        builder, LowLatencyCapturerOnInterrupt, context.get());
    LogStreamResultIfFailed("OH_AudioStreamBuilder_SetCapturerInterruptCallback", result);
    result = OH_AudioStreamBuilder_SetCapturerErrorCallback(
        builder, LowLatencyCapturerOnError, context.get());
    LogStreamResultIfFailed("OH_AudioStreamBuilder_SetCapturerErrorCallback", result);
    return result;
}

OH_AudioStream_Result ConfigureCapturerBuilder(OH_AudioStreamBuilder *builder, const StreamInitParams &params,
    const std::shared_ptr<LowLatencyCapturerContext> &context)
{
    OH_AudioStream_Result result = SetCapturerStreamParams(builder, params);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    return SetCapturerCallbacks(builder, context);
}

napi_value ReturnStreamError(napi_env env, OH_AudioStream_Result result, napi_value &value)
{
    NapiUtils::SetValueInt32(env, result == AUDIOSTREAM_SUCCESS ? ERROR : ToInt32Result(result), value);
    return value;
}

int64_t GetFileTotalBytes(FILE *file)
{
    if (fseek(file, 0, SEEK_END) != 0) {
        OH_LOG_WARN(LOG_APP, "fseek to end failed");
        return -1;
    }
    int64_t totalBytes = static_cast<int64_t>(ftell(file));
    if (fseek(file, 0, SEEK_SET) != 0) {
        OH_LOG_WARN(LOG_APP, "fseek to start failed");
        return -1;
    }
    return totalBytes;
}

OH_AudioStream_Result SetRendererStreamParams(OH_AudioStreamBuilder *builder,
    int32_t sampleRate, int32_t channelCount, int32_t sampleFormat)
{
    OH_AudioStream_Result result = OH_AudioStreamBuilder_SetSamplingRate(builder, sampleRate);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetSampleFormat(
        builder, static_cast<OH_AudioStream_SampleFormat>(sampleFormat));
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    result = OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    return OH_AudioStreamBuilder_SetFrameSizeInCallback(
        builder, PCM_PLAYER_CALLBACK_FRAME_SIZE_MS * sampleRate / MS_PER_SECOND);
}

OH_AudioStream_Result ConfigureRendererBuilder(OH_AudioStreamBuilder *builder,
    int32_t sampleRate, int32_t channelCount, int32_t sampleFormat,
    const std::shared_ptr<PcmPlayerContext> &context)
{
    OH_AudioStream_Result result = SetRendererStreamParams(builder, sampleRate, channelCount, sampleFormat);
    if (result != AUDIOSTREAM_SUCCESS) {
        return result;
    }
    return OH_AudioStreamBuilder_SetRendererWriteDataCallback(
        builder, PcmPlayerOnWriteDataCallback, context.get());
}
// Documentation example snippets referenced by OpenHarmony docs
static void ExampleGetDebugManager()
{
    // [Start get_debug_manager_c]
    // 获取音频调试管理器
    OH_AudioDebuggingManager *debugManager = nullptr;
    OH_AudioCommon_Result result = OH_AudioManager_GetAudioDebuggingManager(&debugManager);
    if (result != AUDIOCOMMON_RESULT_SUCCESS || debugManager == nullptr) {
        // 获取失败，处理错误
        return;
    }
    // [End get_debug_manager_c]
    (void)debugManager;
}

static void ExamplePrintAppSnapshot(OH_AudioDebuggingManager *debugManager)
{
    // [Start print_app_snapshot_c]
    // 打印应用快照到文件
    int32_t fd = open("/data/storage/el2/base/cache/audio_snapshot.txt", O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintAppInfo(debugManager, fd);
        close(fd);
    }

    // 也可将快照信息输出到hilog日志（fd < 0时输出到hilog）
    OH_AudioDebuggingManager_PrintAppInfo(debugManager, -1);
    // [End print_app_snapshot_c]
}

static void ExamplePrintCapturerSnapshot(OH_AudioDebuggingManager *debugManager, OH_AudioCapturer *capturer)
{
    // [Start print_capturer_snapshot_c]
    // 打印指定录音实例的快照
    int32_t fd = open("/data/storage/el2/base/cache/capturer_snapshot.txt",
        O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintCapturerInfo(debugManager, capturer, fd);
        close(fd);
    }
    // [End print_capturer_snapshot_c]
}

static void ExamplePrintRendererSnapshot(OH_AudioDebuggingManager *debugManager, OH_AudioRenderer *renderer)
{
    // [Start print_renderer_snapshot_c]
    // 打印指定播放实例的快照
    int32_t fd = open("/data/storage/el2/base/cache/renderer_snapshot.txt",
        O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintRendererInfo(debugManager, renderer, fd);
        close(fd);
    }
    // [End print_renderer_snapshot_c]
}

static void ExampleConcurrentSnapshot(OH_AudioCapturer *capturer, OH_AudioRenderer *renderer)
{
    // [Start concurrent_snapshot_c]
    // 获取调试管理器
    OH_AudioDebuggingManager *debugManager = nullptr;
    OH_AudioCommon_Result result = OH_AudioManager_GetAudioDebuggingManager(&debugManager);
    if (result != AUDIOCOMMON_RESULT_SUCCESS || debugManager == nullptr) {
        return;
    }

    // 打印各录音流快照
    int32_t fd = open("/data/storage/el2/base/cache/capturer_snapshot.txt",
        O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintCapturerInfo(debugManager, capturer, fd);
        close(fd);
    }

    // 打印各播放流快照
    fd = open("/data/storage/el2/base/cache/renderer_snapshot.txt",
        O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintRendererInfo(debugManager, renderer, fd);
        close(fd);
    }

    // 一次性获取应用整体快照
    fd = open("/data/storage/el2/base/cache/app_snapshot.txt", O_WRONLY | O_CREAT | O_TRUNC, FILE_PERMISSION);
    if (fd >= 0) {
        OH_AudioDebuggingManager_PrintAppInfo(debugManager, fd);
        close(fd);
    }
    // [End concurrent_snapshot_c]
}
} // namespace

static napi_value LowLatencyCapturerInit(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    StreamInitParams params;
    if (!GetInitArgs(env, info, params) || params.streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }

    auto context = GetOrCreateLowLatencyCapturer(params.streamId);
    if (context->capturer != nullptr) {
        NapiUtils::SetValueInt32(env, SUCCESS, value);
        return value;
    }
    ResetStats(context);

    OH_AudioStreamBuilder *capturerBuilder = nullptr;
    OH_AudioStream_Result result = OH_AudioStreamBuilder_Create(&capturerBuilder, AUDIOSTREAM_TYPE_CAPTURER);
    if (result != AUDIOSTREAM_SUCCESS || capturerBuilder == nullptr) {
        LogStreamResultIfFailed("OH_AudioStreamBuilder_Create", result);
        return ReturnStreamError(env, result, value);
    }

    result = ConfigureCapturerBuilder(capturerBuilder, params, context);
    if (result != AUDIOSTREAM_SUCCESS) {
        OH_AudioStreamBuilder_Destroy(capturerBuilder);
        NapiUtils::SetValueInt32(env, ToInt32Result(result), value);
        return value;
    }

    result = OH_AudioStreamBuilder_GenerateCapturer(capturerBuilder, &context->capturer);
    OH_AudioStreamBuilder_Destroy(capturerBuilder);
    if (result != AUDIOSTREAM_SUCCESS || context->capturer == nullptr) {
        LogStreamResultIfFailed("OH_AudioStreamBuilder_GenerateCapturer", result);
        return ReturnStreamError(env, result, value);
    }

    context->isRunning = false;
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

static napi_value LowLatencyCapturerStart(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    auto context = FindLowLatencyCapturer(streamId);
    if (context == nullptr || context->capturer == nullptr) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    if (context->isRunning) {
        NapiUtils::SetValueInt32(env, SUCCESS, value);
        return value;
    }
    OH_AudioStream_Result result = OH_AudioCapturer_Start(context->capturer);
    LogStreamResultIfFailed("OH_AudioCapturer_Start", result);
    if (result == AUDIOSTREAM_SUCCESS) {
        context->isRunning = true;
    }
    NapiUtils::SetValueInt32(env, ToInt32Result(result), value);
    return value;
}

static napi_value LowLatencyCapturerSetSaveFile(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    std::string path;
    if (!GetStreamIdAndPathArgs(env, info, streamId, path) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    int32_t result = SetSaveFile(FindLowLatencyCapturer(streamId), path);
    NapiUtils::SetValueInt32(env, result, value);
    return value;
}

static napi_value LowLatencyCapturerStop(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    auto context = FindLowLatencyCapturer(streamId);
    if (context == nullptr || context->capturer == nullptr) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    if (!context->isRunning) {
        NapiUtils::SetValueInt32(env, SUCCESS, value);
        return value;
    }
    OH_AudioStream_Result result = OH_AudioCapturer_Stop(context->capturer);
    LogStreamResultIfFailed("OH_AudioCapturer_Stop", result);
    if (result == AUDIOSTREAM_SUCCESS) {
        context->isRunning = false;
    }
    NapiUtils::SetValueInt32(env, ToInt32Result(result), value);
    return value;
}

static napi_value LowLatencyCapturerRelease(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    int32_t result = ReleaseLowLatencyCapturerInternal(TakeLowLatencyCapturer(streamId));
    NapiUtils::SetValueInt32(env, result, value);
    return value;
}

static napi_value LowLatencyCapturerGetStats(napi_env env, napi_callback_info info)
{
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        return CreateStatsValue(env, nullptr);
    }
    return CreateStatsValue(env, FindLowLatencyCapturer(streamId));
}

static napi_value LowLatencyCapturerPrintSnapshot(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    int32_t fd = -1;
    if (!GetStreamIdAndFdArgs(env, info, streamId, fd) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_INVALID_PARAM, value);
        return value;
    }
    auto context = FindLowLatencyCapturer(streamId);
    if (context == nullptr || context->capturer == nullptr) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_ILLEGAL_STATE, value);
        return value;
    }
    NapiUtils::SetValueInt32(env, PrintCapturerSnapshotByC(context->capturer, fd), value);
    return value;
}

static napi_value LowLatencyCapturerResetStats(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    ResetStats(FindLowLatencyCapturer(streamId));
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

std::shared_ptr<PcmPlayerContext> PreparePlayerContext(int32_t streamId)
{
    auto context = GetOrCreatePcmPlayer(streamId);
    int32_t releaseRet = ReleasePcmPlayerInternal(context);
    if (releaseRet != SUCCESS) {
        return nullptr;
    }
    return context;
}

FILE *OpenPcmFile(const std::string &path, int64_t &totalBytes)
{
    FILE *file = fopen(path.c_str(), "rb");
    if (file == nullptr) {
        return nullptr;
    }
    totalBytes = GetFileTotalBytes(file);
    if (totalBytes <= 0) {
        fclose(file);
        return nullptr;
    }
    return file;
}

OH_AudioRenderer *CreatePcmRenderer(int32_t sampleRate, int32_t channelCount, int32_t sampleFormat,
    const std::shared_ptr<PcmPlayerContext> &context)
{
    OH_AudioStreamBuilder *rendererBuilder = nullptr;
    OH_AudioStream_Result result = OH_AudioStreamBuilder_Create(&rendererBuilder, AUDIOSTREAM_TYPE_RENDERER);
    if (result != AUDIOSTREAM_SUCCESS || rendererBuilder == nullptr) {
        LogStreamResultIfFailed("OH_AudioStreamBuilder_Create renderer", result);
        return nullptr;
    }

    result = ConfigureRendererBuilder(rendererBuilder, sampleRate, channelCount, sampleFormat, context);
    if (result != AUDIOSTREAM_SUCCESS) {
        OH_AudioStreamBuilder_Destroy(rendererBuilder);
        return nullptr;
    }

    OH_AudioRenderer *renderer = nullptr;
    result = OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &renderer);
    OH_AudioStreamBuilder_Destroy(rendererBuilder);
    if (result != AUDIOSTREAM_SUCCESS || renderer == nullptr) {
        LogStreamResultIfFailed("OH_AudioStreamBuilder_GenerateRenderer", result);
        return nullptr;
    }
    return renderer;
}

static napi_value PcmPlayerStart(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    PlayerStartParams params;
    if (!GetPlayerStartArgs(env, info, params) || params.streamId <= 0 || params.path.empty()) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }

    auto context = PreparePlayerContext(params.streamId);
    if (context == nullptr) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }

    int64_t totalBytes = 0;
    FILE *file = OpenPcmFile(params.path, totalBytes);
    if (file == nullptr) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }

    OH_AudioRenderer *renderer = CreatePcmRenderer(
        params.sampleRate, params.channelCount, params.sampleFormat, context);
    if (renderer == nullptr) {
        fclose(file);
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }

    {
        std::lock_guard<std::mutex> lock(context->mutex);
        context->renderer = renderer;
        context->file = file;
        context->isPlaying = false;
        context->isCompleted = false;
        context->lastError = 0;
        context->totalBytes = totalBytes;
        context->playedBytes = 0;
    }

    OH_AudioStream_Result result = OH_AudioRenderer_Start(renderer);
    if (result != AUDIOSTREAM_SUCCESS) {
        ReleasePcmPlayerInternal(context);
        LogStreamResultIfFailed("OH_AudioRenderer_Start", result);
        NapiUtils::SetValueInt32(env, ToInt32Result(result), value);
        return value;
    }
    {
        std::lock_guard<std::mutex> lock(context->mutex);
        context->isPlaying = true;
    }
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

static napi_value PcmPlayerStop(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    int32_t result = ReleasePcmPlayerInternal(FindPcmPlayer(streamId));
    NapiUtils::SetValueInt32(env, result, value);
    return value;
}

static napi_value PcmPlayerGetStats(napi_env env, napi_callback_info info)
{
    int32_t streamId = 0;
    if (!GetStreamIdArg(env, info, streamId) || streamId <= 0) {
        return CreatePlayerStatsValue(env, nullptr);
    }
    return CreatePlayerStatsValue(env, FindPcmPlayer(streamId));
}

static napi_value PcmPlayerPrintSnapshot(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t streamId = 0;
    int32_t fd = -1;
    if (!GetStreamIdAndFdArgs(env, info, streamId, fd) || streamId <= 0) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_INVALID_PARAM, value);
        return value;
    }
    auto context = FindPcmPlayer(streamId);
    if (context == nullptr) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_ILLEGAL_STATE, value);
        return value;
    }

    OH_AudioRenderer *renderer = nullptr;
    {
        std::lock_guard<std::mutex> lock(context->mutex);
        renderer = context->renderer;
    }
    if (renderer == nullptr) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_ILLEGAL_STATE, value);
        return value;
    }
    NapiUtils::SetValueInt32(env, PrintRendererSnapshotByC(renderer, fd), value);
    return value;
}

static napi_value AudioDebuggingManagerPrintAppInfo(napi_env env, napi_callback_info info)
{
    napi_value value = nullptr;
    int32_t fd = -1;
    if (!GetFdArg(env, info, fd)) {
        NapiUtils::SetValueInt32(env, AUDIOCOMMON_RESULT_ERROR_INVALID_PARAM, value);
        return value;
    }
    NapiUtils::SetValueInt32(env, PrintAppSnapshotByC(fd), value);
    return value;
}

static napi_value AudioDebuggingManagerProbe(napi_env env, napi_callback_info info)
{
    (void)info;
    napi_value value = nullptr;
    OH_AudioDebuggingManager *manager = nullptr;
    OH_AudioCommon_Result ret = OH_AudioManager_GetAudioDebuggingManager(&manager);
    if (ret == AUDIOCOMMON_RESULT_SUCCESS && manager == nullptr) {
        ret = AUDIOCOMMON_RESULT_ERROR_SYSTEM;
    }
    NapiUtils::SetValueInt32(env, ret, value);
    return value;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"lowLatencyCapturerInit", nullptr, LowLatencyCapturerInit,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerStart", nullptr, LowLatencyCapturerStart,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerStop", nullptr, LowLatencyCapturerStop,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerRelease", nullptr, LowLatencyCapturerRelease,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerSetSaveFile", nullptr, LowLatencyCapturerSetSaveFile,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerGetStats", nullptr, LowLatencyCapturerGetStats,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerResetStats", nullptr, LowLatencyCapturerResetStats,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lowLatencyCapturerPrintSnapshot", nullptr, LowLatencyCapturerPrintSnapshot,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pcmPlayerStart", nullptr, PcmPlayerStart,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pcmPlayerStop", nullptr, PcmPlayerStop,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pcmPlayerGetStats", nullptr, PcmPlayerGetStats,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pcmPlayerPrintSnapshot", nullptr, PcmPlayerPrintSnapshot,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioDebuggingManagerProbe", nullptr, AudioDebuggingManagerProbe,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioDebuggingManagerPrintAppInfo", nullptr, AudioDebuggingManagerPrintAppInfo,
            nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
