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

#include "oh_audio_playing.h"
#include <cstdint>
#include <hilog/log.h>
#include <node_api.h>
#include <unistd.h>
#include <cmath>
#include <cstring>
#include <chrono>
#include <thread>
#include <vector>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "OH_AUDIO_PLAYING"

// WAV file header constants
constexpr int WAV_HEADER_SIZE_RIFF = 4;
constexpr int WAV_HEADER_SIZE_FILE_SIZE = 4;
constexpr int WAV_HEADER_SIZE_WAVE = 4;
constexpr int WAV_HEADER_SIZE_CHUNK_ID = 4;
constexpr int WAV_HEADER_SIZE_CHUNK_SIZE = 4;
constexpr int WAV_HEADER_BASIC_SIZE = 12;
constexpr int WAV_FMT_CHUNK_MIN_SIZE = 16;
constexpr int WAV_FMT_CHUNK_SIZE_AUDIO_FORMAT = 2;
constexpr int WAV_FMT_CHUNK_SIZE_CHANNELS = 2;
constexpr int WAV_FMT_CHUNK_SIZE_SAMPLE_RATE = 4;
constexpr int WAV_FMT_CHUNK_SIZE_BYTE_RATE = 4;
constexpr int WAV_FMT_CHUNK_SIZE_BLOCK_ALIGN = 2;
constexpr int WAV_FMT_CHUNK_SIZE_BITS_PER_SAMPLE = 2;
constexpr int WAV_HEADER_MAX_SEARCH_SIZE = 4096;

// Audio effect constants
constexpr float AUDIO_EFFECT_GAIN_COEFFICIENT = 0.4f;
constexpr int16_t AUDIO_SAMPLE_MAX_VALUE_16BIT = 32767;
constexpr int16_t AUDIO_SAMPLE_MIN_VALUE_16BIT = -32768;

// Audio parameter constants
constexpr uint32_t DEFAULT_SAMPLE_RATE = 48000;
constexpr uint32_t DEFAULT_CHANNEL_COUNT = 2;
constexpr uint16_t BITS_PER_SAMPLE_8 = 8;
constexpr uint16_t BITS_PER_SAMPLE_16 = 16;
constexpr uint16_t BITS_PER_SAMPLE_24 = 24;
constexpr uint16_t BITS_PER_SAMPLE_32 = 32;
constexpr uint32_t BITS_PER_BYTE = 8;
constexpr uint32_t MILLIS_PER_SECOND = 1000;

// Buffer and timing constants
constexpr size_t FILE_READ_BUFFER_SIZE = 8192;
constexpr uint64_t WORKGROUP_INTERVAL_MS = 20;
constexpr uint32_t FILE_READER_SLEEP_MS = 10;

// Customize the audio interrupt event function
static void OnAudioInterruptEvent(OH_AudioRenderer *audioRenderer, [[maybe_unused]] void *userData,
    OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint)
{
    if ((type == AUDIOSTREAM_INTERRUPT_SHARE) && (hint == AUDIOSTREAM_INTERRUPT_HINT_RESUME)) {
        OH_LOG_INFO(LOG_APP, "Audio interrupt hint: RESUME");
        OHAudioPlayer::GetInstance().PlayStatusCallback(OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
            PlayStatus::Play);
    } else if (hint == AUDIOSTREAM_INTERRUPT_HINT_PAUSE) {
        OH_LOG_INFO(LOG_APP, "Audio interrupt hint: PAUSE");
        OHAudioPlayer::GetInstance().PlayStatusCallback(OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
            PlayStatus::Pause);
    } else if (hint == AUDIOSTREAM_INTERRUPT_HINT_STOP) {
        OH_LOG_INFO(LOG_APP, "Audio interrupt hint: STOP");
        OHAudioPlayer::GetInstance().PlayStatusCallback(OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
            PlayStatus::Stop);
    }
}

// Custom exception callback functions
static void OnAudioErrorEvent([[maybe_unused]] OH_AudioRenderer *audioRenderer, [[maybe_unused]] void *userData,
    OH_AudioStream_Result error)
{
    OH_LOG_ERROR(LOG_APP, "Audio render error, ret: %{public}d", error);
}

// Custom exception callback functions
static void OnAudioDeviceChangeEvent([[maybe_unused]] OH_AudioRenderer* renderer, [[maybe_unused]] void *userData,
    OH_AudioStream_DeviceChangeReason reason)
{
    OH_LOG_ERROR(LOG_APP, "receive audio device change, ret: %{public}d", reason);
    if (reason == REASON_OLD_DEVICE_UNAVAILABLE) {
        OHAudioPlayer::GetInstance().PlayStatusCallback(OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
            PlayStatus::Pause);
    }
}

// [Start ApplyAudioEffect]
// Apply audio effect with gain coefficient 0.4
static void ApplyAudioEffect(void *audioData, int32_t audioDataSize)
{
    const float gain = AUDIO_EFFECT_GAIN_COEFFICIENT;
    int16_t *samples = reinterpret_cast<int16_t *>(audioData);
    int32_t sampleCount = audioDataSize / sizeof(int16_t);

    for (int32_t i = 0; i < sampleCount; i++) {
        int32_t sample = static_cast<int32_t>(samples[i]);
        sample = static_cast<int32_t>(sample * gain);
        if (sample > AUDIO_SAMPLE_MAX_VALUE_16BIT) {
            sample = AUDIO_SAMPLE_MAX_VALUE_16BIT;
        } else if (sample < AUDIO_SAMPLE_MIN_VALUE_16BIT) {
            sample = AUDIO_SAMPLE_MIN_VALUE_16BIT;
        }
        samples[i] = static_cast<int16_t>(sample);
    }
}
// [End ApplyAudioEffect]

// [Start OnAudioRendererWriteDataEvent]
// Custom data write function
static OH_AudioData_Callback_Result OnAudioRendererWriteDataEvent([[maybe_unused]] OH_AudioRenderer *audioRenderer,
    void *userData, void *audioData,
    int32_t audioDataSize)
{
    OH_AudioWorkgroup *workgroup = OHAudioPlayer::GetInstance().audioWorkgroup;
    if (workgroup != nullptr) {
        auto now = std::chrono::system_clock::now().time_since_epoch();
        auto startTimeMs = std::chrono::duration_cast<std::chrono::milliseconds>(now).count();
        OH_AudioWorkgroup_Start(workgroup, startTimeMs, startTimeMs + WORKGROUP_INTERVAL_MS);
    }
    auto audioFileOprInfo = reinterpret_cast<AudioFileOprInfo *>(userData);
    if (!audioFileOprInfo->audioBufferQueue) {
        OH_LOG_ERROR(LOG_APP, "Audio buffer queue is null");
        return AUDIO_DATA_CALLBACK_RESULT_INVALID;
    }

    size_t actualSize = 0;
    bool success = audioFileOprInfo->audioBufferQueue->Pop(
        reinterpret_cast<uint8_t*>(audioData),
        static_cast<size_t>(audioDataSize),
        actualSize);

    if (!success || actualSize == 0) {
        if (audioFileOprInfo->isFileEnd &&
            audioFileOprInfo->audioBufferQueue->IsEmpty()) {
            OHAudioPlayer::TriggerPlayCompletionCallback(audioFileOprInfo);
        }
        return AUDIO_DATA_CALLBACK_RESULT_INVALID;
    }

    if (OHAudioPlayer::GetInstance().isEffectOn) {
        ApplyAudioEffect(audioData, static_cast<int32_t>(actualSize));
    }

    uint32_t channels = audioFileOprInfo->channels;
    uint32_t bitsPerSample = audioFileOprInfo->bitsPerSample;
    uint32_t bytesPerFrame = channels * (bitsPerSample / BITS_PER_BYTE);
    uint64_t framesWritten = actualSize / bytesPerFrame;
    audioFileOprInfo->totalFramesWritten += framesWritten;
    audioFileOprInfo->currentFramesWritten += framesWritten;

    if (workgroup != nullptr) {
        OH_AudioWorkgroup_Stop(workgroup);
    }

    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}
// [End OnAudioRendererWriteDataEvent]

static bool ReadWavBasicHeader(int32_t fd)
{
    char riff[WAV_HEADER_SIZE_RIFF];
    char wave[WAV_HEADER_SIZE_WAVE];
    uint32_t fileSize;

    if (read(fd, riff, WAV_HEADER_SIZE_RIFF) < WAV_HEADER_SIZE_RIFF) {
        OH_LOG_ERROR(LOG_APP, "Failed to read RIFF header");
        return false;
    }
    if (read(fd, &fileSize, WAV_HEADER_SIZE_FILE_SIZE) < WAV_HEADER_SIZE_FILE_SIZE) {
        OH_LOG_ERROR(LOG_APP, "Failed to read file size");
        return false;
    }
    if (read(fd, wave, WAV_HEADER_SIZE_WAVE) < WAV_HEADER_SIZE_WAVE) {
        OH_LOG_ERROR(LOG_APP, "Failed to read WAVE header");
        return false;
    }
    if (strncmp(riff, "RIFF", WAV_HEADER_SIZE_RIFF) != 0 ||
        strncmp(wave, "WAVE", WAV_HEADER_SIZE_WAVE) != 0) {
        OH_LOG_ERROR(LOG_APP, "Invalid WAV format: riff=%{public}.4s, wave=%{public}.4s", riff, wave);
        return false;
    }
    OH_LOG_INFO(LOG_APP, "WAV basic header: riff=%{public}.4s, fileSize=%{public}u, wave=%{public}.4s",
        riff, fileSize, wave);
    return true;
}

static bool ReadWavFmtChunk(int32_t fd, uint32_t chunkSize, AudioFileOprInfo *audioFileOprInfo)
{
    if (chunkSize < WAV_FMT_CHUNK_MIN_SIZE) {
        OH_LOG_ERROR(LOG_APP, "Invalid fmt chunk size: %{public}u", chunkSize);
        return false;
    }

    uint16_t audioFormat, numChannels, blockAlign, bitsPerSample;
    uint32_t sampleRate, byteRate;

    read(fd, &audioFormat, WAV_FMT_CHUNK_SIZE_AUDIO_FORMAT);
    read(fd, &numChannels, WAV_FMT_CHUNK_SIZE_CHANNELS);
    read(fd, &sampleRate, WAV_FMT_CHUNK_SIZE_SAMPLE_RATE);
    read(fd, &byteRate, WAV_FMT_CHUNK_SIZE_BYTE_RATE);
    read(fd, &blockAlign, WAV_FMT_CHUNK_SIZE_BLOCK_ALIGN);
    read(fd, &bitsPerSample, WAV_FMT_CHUNK_SIZE_BITS_PER_SAMPLE);

    OH_LOG_INFO(LOG_APP, "fmt chunk: format=%{public}u, channels=%{public}u, rate=%{public}u, "
        "byteRate=%{public}u, align=%{public}u, bits=%{public}u",
        audioFormat, numChannels, sampleRate, byteRate, blockAlign, bitsPerSample);

    audioFileOprInfo->isWavFile = true;
    audioFileOprInfo->sampleRate = sampleRate;
    audioFileOprInfo->channels = numChannels;
    audioFileOprInfo->bitsPerSample = bitsPerSample;

    int skipBytes = chunkSize - WAV_FMT_CHUNK_MIN_SIZE;
    if (skipBytes > 0) {
        uint8_t* skipBuffer = new uint8_t[skipBytes];
        read(fd, skipBuffer, skipBytes);
        delete[] skipBuffer;
    }
    return true;
}

static void SkipUnknownChunk(int32_t fd, uint32_t chunkSize, uint32_t &currentOffset)
{
    int skipBytes = chunkSize;
    if (skipBytes % 2 != 0) {
        skipBytes += 1;
    }
    if (skipBytes > 0) {
        uint8_t* skipBuffer = new uint8_t[skipBytes];
        read(fd, skipBuffer, skipBytes);
        delete[] skipBuffer;
    }
    currentOffset += skipBytes;
}

static bool ParseWavHeader(int32_t fd, AudioFileOprInfo *audioFileOprInfo)
{
    if (!ReadWavBasicHeader(fd)) {
        return false;
    }

    char chunkId[WAV_HEADER_SIZE_CHUNK_ID];
    uint32_t chunkSize;
    uint32_t currentOffset = WAV_HEADER_BASIC_SIZE;
    bool foundFmt = false;

    while (true) {
        if (read(fd, chunkId, WAV_HEADER_SIZE_CHUNK_ID) < WAV_HEADER_SIZE_CHUNK_ID) {
            OH_LOG_ERROR(LOG_APP, "Failed to read chunk ID at offset: %{public}u", currentOffset);
            return false;
        }
        if (read(fd, &chunkSize, WAV_HEADER_SIZE_CHUNK_SIZE) < WAV_HEADER_SIZE_CHUNK_SIZE) {
            OH_LOG_ERROR(LOG_APP, "Failed to read chunk size at offset: %{public}u", currentOffset);
            return false;
        }
        currentOffset += WAV_HEADER_SIZE_CHUNK_ID + WAV_HEADER_SIZE_CHUNK_SIZE;

        OH_LOG_INFO(LOG_APP, "Found chunk: %{public}.4s, size: %{public}u, offset: %{public}u",
            chunkId, chunkSize, currentOffset);

        if (strncmp(chunkId, "fmt ", WAV_HEADER_SIZE_CHUNK_ID) == 0) {
            if (!ReadWavFmtChunk(fd, chunkSize, audioFileOprInfo)) {
                return false;
            }
            foundFmt = true;
            currentOffset += chunkSize;
        } else if (strncmp(chunkId, "data", WAV_HEADER_SIZE_CHUNK_ID) == 0) {
            if (!foundFmt) {
                OH_LOG_ERROR(LOG_APP, "Found data chunk before fmt chunk");
                return false;
            }
            audioFileOprInfo->wavDataOffset = currentOffset;
            OH_LOG_INFO(LOG_APP, "Found data chunk at: %{public}u, size: %{public}u",
                audioFileOprInfo->wavDataOffset, chunkSize);
            return true;
        } else {
            SkipUnknownChunk(fd, chunkSize, currentOffset);
        }

        if (currentOffset > WAV_HEADER_MAX_SEARCH_SIZE) {
            OH_LOG_ERROR(LOG_APP, "WAV header too large, no data chunk found");
            return false;
        }
    }
}

// [Start GetAudioFileOffset]
// Get audio file offset value by seek timeStamp
static uint32_t GetAudioFileOffset(uint32_t songDuration, float targetTimeStamp, uint32_t fileSize,
    uint32_t sampleRate, uint32_t channels, uint32_t bitsPerSample)
{
    uint32_t fileOffset = floor((targetTimeStamp / songDuration) * fileSize);
    uint32_t bytesPerSampleFrame = channels * (bitsPerSample / BITS_PER_BYTE);
    uint32_t alignedOffset = fileOffset - fileOffset % bytesPerSampleFrame;
    OH_LOG_INFO(LOG_APP,
        "GetAudioFileOffset: targetTimeStamp=%{public}f, songDuration=%{public}u, "
        "fileSize=%{public}u, fileOffset=%{public}u, bytesPerSampleFrame=%{public}u, "
        "alignedOffset=%{public}u",
        targetTimeStamp, songDuration, fileSize, fileOffset, bytesPerSampleFrame, alignedOffset);
    return alignedOffset;
}
// [End GetAudioFileOffset]

static uint32_t GetAudioCurrentTime(uint32_t songDuration, float currentOffset, uint32_t fileSize)
{
    uint32_t currentTime = floor((currentOffset / fileSize) * songDuration);
    OH_LOG_INFO(LOG_APP,
        "Get audio current time successfully. "
        "Song duration: %{public}d, "
        "currentOffset: %{public}d, "
        "file size: %{public}d, "
        "current time : %{public}d",
        songDuration, currentOffset, fileSize, currentTime);
    return currentTime;
}

static OH_AudioStreamBuilder* CreateAudioStreamBuilder()
{
    OH_AudioStreamBuilder* builder = nullptr;
    OH_AudioStream_Type streamType = AUDIOSTREAM_TYPE_RENDERER;
    auto ret = OH_AudioStreamBuilder_Create(&builder, streamType);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create stream builder failed, ret: %{public}d", ret);
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "Create stream builder success");
    return builder;
}

static void ConfigureAudioParams(OH_AudioStreamBuilder* builder)
{
    (void)OH_AudioStreamBuilder_SetSamplingRate(builder, DEFAULT_SAMPLE_RATE);
    (void)OH_AudioStreamBuilder_SetChannelCount(builder, DEFAULT_CHANNEL_COUNT);
    (void)OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    (void)OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    (void)OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);
}

static void SetupAudioCallbacks(OH_AudioStreamBuilder* builder, AudioFileOprInfo* audioFileOprInfo)
{
    (void)OH_AudioStreamBuilder_SetRendererInterruptCallback(builder, OnAudioInterruptEvent, nullptr);
    (void)OH_AudioStreamBuilder_SetRendererErrorCallback(builder, OnAudioErrorEvent, nullptr);
    (void)OH_AudioStreamBuilder_SetRendererWriteDataCallback(builder, OnAudioRendererWriteDataEvent,
        reinterpret_cast<void *>(audioFileOprInfo));
    (void)OH_AudioStreamBuilder_SetRendererOutputDeviceChangeCallback(builder, OnAudioDeviceChangeEvent, nullptr);
}

static void InitAudioWorkgroup(OHAudioPlayer& player)
{
    OH_AudioManager_GetAudioResourceManager(&player.audioResourceManager);
    if (player.audioResourceManager == nullptr) {
        return;
    }
    OH_AudioResourceManager_CreateWorkgroup(player.audioResourceManager, "audio_workgroup", &player.audioWorkgroup);
    if (player.audioWorkgroup != nullptr) {
        OH_AudioWorkgroup_AddCurrentThread(player.audioWorkgroup, &player.workgroupTokenId);
        OH_LOG_INFO(LOG_APP, "Audio workgroup created and thread added successfully.");
    }
}

void OHAudioPlayer::InitPlayer()
{
    if ((audioRenderer != nullptr) || (rendererBuilder != nullptr) || (audioFileOprInfo != nullptr)) {
        OH_LOG_INFO(LOG_APP, "Previous player remained, releasing...");
        ReleasePlayer();
    }

    rendererBuilder = CreateAudioStreamBuilder();
    if (rendererBuilder == nullptr) {
        return;
    }

    audioFileOprInfo = new AudioFileOprInfo();
    ConfigureAudioParams(rendererBuilder);
    SetupAudioCallbacks(rendererBuilder, audioFileOprInfo);

    auto ret = OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create audio renderer failed, ret: %{public}d", ret);
        ReleasePlayer();
        return;
    }

    if (isSilentMode) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed, ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode: %{public}d", isSilentMode);
        }
    }
    OH_LOG_INFO(LOG_APP, "Restored effect mode: %{public}d", isEffectOn);

    InitAudioWorkgroup(*this);
    OH_LOG_INFO(LOG_APP, "Init player successfully.");
}

static OH_AudioStream_SampleFormat GetSampleFormat(uint16_t bitsPerSample)
{
    if (bitsPerSample == BITS_PER_SAMPLE_8) {
        return AUDIOSTREAM_SAMPLE_U8;
    } else if (bitsPerSample == BITS_PER_SAMPLE_16) {
        return AUDIOSTREAM_SAMPLE_S16LE;
    } else if (bitsPerSample == BITS_PER_SAMPLE_24) {
        return AUDIOSTREAM_SAMPLE_S24LE;
    } else if (bitsPerSample == BITS_PER_SAMPLE_32) {
        return AUDIOSTREAM_SAMPLE_S32LE;
    }
    return AUDIOSTREAM_SAMPLE_S16LE;
}

void OHAudioPlayer::ReconfigurePlayer()
{
    if (!audioFileOprInfo) {
        return;
    }

    OH_LOG_INFO(LOG_APP, "Reconfiguring player: sampleRate=%{public}u, channels=%{public}u, bitsPerSample=%{public}u",
        audioFileOprInfo->sampleRate, audioFileOprInfo->channels, audioFileOprInfo->bitsPerSample);

    if (audioRenderer != nullptr) {
        OH_AudioRenderer_Release(audioRenderer);
        audioRenderer = nullptr;
    }

    OH_AudioStream_SampleFormat sampleFormat = GetSampleFormat(audioFileOprInfo->bitsPerSample);

    (void)OH_AudioStreamBuilder_SetSamplingRate(rendererBuilder, audioFileOprInfo->sampleRate);
    (void)OH_AudioStreamBuilder_SetChannelCount(rendererBuilder, audioFileOprInfo->channels);
    (void)OH_AudioStreamBuilder_SetSampleFormat(rendererBuilder, sampleFormat);
    SetupAudioCallbacks(rendererBuilder, audioFileOprInfo);

    auto ret = OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Recreate audio renderer failed, ret: %{public}d", ret);
        return;
    }

    if (isSilentMode) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed, ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode: %{public}d", isSilentMode);
        }
    }
    OH_LOG_INFO(LOG_APP, "Restored effect mode: %{public}d", isEffectOn);
}
// [End ReconfigurePlayer]
// [End InitPlayer]

static AudioFileOprInfo* InitAudioFileOprInfo(uint32_t songFd, uint32_t songFileSize, uint32_t songFileOffset)
{
    AudioFileOprInfo* info = new AudioFileOprInfo();
    info->songFd = songFd;
    info->songFileSize = songFileSize;
    info->songFileOffset = songFileOffset;
    info->songCurrentOffset = 0;
    info->targetPositionMs = 0;
    info->isWavFile = false;
    info->wavDataOffset = 0;
    (void)lseek(info->songFd, songFileOffset, SEEK_SET);
    return info;
}

static bool HandleWavFile(uint32_t songFd, AudioFileOprInfo* info, uint32_t songFileSize, uint32_t songFileOffset)
{
    OH_LOG_INFO(LOG_APP, "Detected WAV file format");
    if (!ParseWavHeader(songFd, info)) {
        OH_LOG_ERROR(LOG_APP, "Failed to parse WAV header");
        return false;
    }
    info->isWavFile = true;
    uint32_t dataSize = songFileSize - info->wavDataOffset;
    info->songFileSize = dataSize;
    OH_LOG_INFO(LOG_APP, "WAV file size adjusted: original=%{public}u, dataSize=%{public}u",
        songFileSize, dataSize);

    uint32_t correctOffset = songFileOffset + info->wavDataOffset;
    lseek(songFd, correctOffset, SEEK_SET);
    OH_LOG_INFO(LOG_APP, "Seeked to data offset: %{public}u", correctOffset);
    return true;
}

static void CalculateSongDuration(AudioFileOprInfo* info)
{
    uint32_t sampleRate = info->sampleRate;
    uint32_t channels = info->channels;
    uint32_t bitsPerSample = info->bitsPerSample;
    uint32_t bytesPerSecond = sampleRate * channels * (bitsPerSample / BITS_PER_BYTE);
    info->songDuration = static_cast<uint32_t>(
        static_cast<double>(info->songFileSize) / bytesPerSecond * MILLIS_PER_SECOND);
    info->songTotalFrames = static_cast<uint64_t>(info->songDuration) * sampleRate / MILLIS_PER_SECOND;
    info->totalFramesWritten = 0;
    info->currentFramesWritten = 0;
    OH_LOG_INFO(LOG_APP, "Audio params: rate=%{public}u, channels=%{public}u, bits=%{public}u, duration=%{public}u ms",
        sampleRate, channels, bitsPerSample, info->songDuration);
}

static void InitBufferQueue(AudioFileOprInfo* info)
{
    info->audioBufferQueue = new AudioBufferQueue();
    info->audioBufferQueue->Init();
    info->isFileEnd = false;
    info->isCompletionCallbackTriggered = false;
}

static const char* GetFileExtension(const char* fileName)
{
    if (fileName == nullptr) {
        return nullptr;
    }
    return strrchr(fileName, '.');
}

void OHAudioPlayer::LoadSongInfo(const char *fileName, uint32_t songFd, uint32_t songFileSize,
    uint32_t songFileOffset)
{
    ReleaseCurrentSong();
    audioFileOprInfo = InitAudioFileOprInfo(songFd, songFileSize, songFileOffset);

    const char* fileExt = GetFileExtension(fileName);
    if (fileExt == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Invalid file name, no extension found");
        return;
    }

    bool success = false;
    if (strcmp(fileExt, ".wav") == 0 || strcmp(fileExt, ".WAV") == 0) {
        success = HandleWavFile(songFd, audioFileOprInfo, songFileSize, songFileOffset);
        ReconfigurePlayer();
    } else if (strcmp(fileExt, ".pcm") == 0 || strcmp(fileExt, ".PCM") == 0) {
        OH_LOG_INFO(LOG_APP, "Detected PCM file format");
        ReconfigurePlayer();
        success = true;
    } else {
        OH_LOG_ERROR(LOG_APP, "Unsupported file format: %{public}s", fileExt);
        return;
    }

    if (!success) {
        ReconfigurePlayer();
    }

    CalculateSongDuration(audioFileOprInfo);
    InitBufferQueue(audioFileOprInfo);

    fileReaderThread = new std::thread(FileReaderThreadFunc, audioFileOprInfo);
    OH_LOG_INFO(LOG_APP, "Started file reader thread");

    if (isSilentMode && audioRenderer != nullptr) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed, ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode: %{public}d", isSilentMode);
        }
    }
    OH_LOG_INFO(LOG_APP, "Restored effect mode: %{public}d", isEffectOn);

    OH_LOG_INFO(LOG_APP, "Load song info success. fd=%{public}d, size=%{public}d, duration=%{public}d, offset=%{public}d",
        songFd, songFileSize, audioFileOprInfo->songDuration, songFileOffset);
}

// [Start PlaySong]
void OHAudioPlayer::PlaySong()
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    if (audioFileOprInfo && audioFileOprInfo->audioBufferQueue) {
        if (!audioFileOprInfo->audioBufferQueue->IsRunning()) {
            audioFileOprInfo->audioBufferQueue->ResumeProducer();
            OH_LOG_INFO(LOG_APP, "Resumed file reader thread");
        }
    }

    auto ret = OH_AudioRenderer_Start(audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Play song failed, ret: %{public}d", ret);
        return;
    }

    isPlaying = true;
    OH_LOG_INFO(LOG_APP, "Play song successfully.");
}
// [End PlaySong]

// [Start PauseSong]
void OHAudioPlayer::PauseSong()
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    audioFileOprInfo->targetPositionMs = GetProgress();
    audioFileOprInfo->currentFramesWritten = 0;
    OH_LOG_INFO(LOG_APP, "Pause song, saved targetPosition: %{public}d ms",
        audioFileOprInfo->targetPositionMs);

    auto ret = OH_AudioRenderer_Pause(audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Pause song failed, ret: %{public}d", ret);
        return;
    }

    isPlaying = false;
    OH_LOG_INFO(LOG_APP, "Pause song successfully.");
}
// [End PauseSong]

// [Start StopSong]
void OHAudioPlayer::StopSong()
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    if (audioFileOprInfo && audioFileOprInfo->audioBufferQueue) {
        audioFileOprInfo->audioBufferQueue->StopProducer();
    }

    auto ret = OH_AudioRenderer_Stop(audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Stop song failed, ret: %{public}d", ret);
        return;
    }
    ret = OH_AudioRenderer_Flush(audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Flush song failed, ret: %{public}d", ret);
        return;
    }

    if (audioFileOprInfo) {
        audioFileOprInfo->targetPositionMs = 0;
    }

    isPlaying = false;
    OH_LOG_INFO(LOG_APP, "Stop song successfully.");
}
// [End StopSong]

int32_t OHAudioPlayer::GetProgress()
{
    if (audioFileOprInfo == nullptr) {
        return 0;
    }

    uint32_t sampleRate = audioFileOprInfo->sampleRate;

    uint64_t framesWritten = audioFileOprInfo->currentFramesWritten.load();
    int32_t currentTimeMs = static_cast<int32_t>((framesWritten * MILLIS_PER_SECOND) / sampleRate);

    return audioFileOprInfo->targetPositionMs + currentTimeMs;
}

int32_t OHAudioPlayer::GetSongDuration()
{
    if (audioFileOprInfo == nullptr) {
        return 0;
    }
    return audioFileOprInfo->songDuration;
}

uint32_t OHAudioPlayer::GetRemainingTime()
{
    if (audioRenderer == nullptr || audioFileOprInfo == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer or audioFileOprInfo is null.");
        return 0;
    }

    uint32_t sampleRate = audioFileOprInfo->sampleRate;
    uint64_t framesWritten = audioFileOprInfo->totalFramesWritten.load();

    int64_t currentFramePosition;
    int64_t timestamp;
    OH_AudioRenderer_GetAudioTimestampInfo(audioRenderer, &currentFramePosition, &timestamp);

    uint64_t remainingFrames = framesWritten - currentFramePosition;
    remainingFrames = remainingFrames < 0 ? 0 : remainingFrames;
    return static_cast<uint32_t>((remainingFrames * MILLIS_PER_SECOND) / sampleRate);
}

static uint32_t CalculateSeekOffset(AudioFileOprInfo* info, uint32_t timeStamp)
{
    uint32_t fileOffset = GetAudioFileOffset(info->songDuration, timeStamp, info->songFileSize,
        info->sampleRate, info->channels, info->bitsPerSample);
    fileOffset += info->songFileOffset;
    if (info->isWavFile) {
        fileOffset += info->wavDataOffset;
    }
    OH_LOG_INFO(LOG_APP, "CalculateSeekOffset: offset=%{public}u (songOffset=%{public}u, wavOffset=%{public}u)",
        fileOffset, info->songFileOffset, info->isWavFile ? info->wavDataOffset : 0);
    return fileOffset;
}

static void ResetAfterSeek(AudioFileOprInfo* info, uint32_t seekOffset, uint32_t timeStamp)
{
    info->totalFramesWritten = 0;
    info->currentFramesWritten = 0;
    info->seekOffset = seekOffset;
    info->isSeekRequested = true;
    info->isFileEnd = false;
    info->isCompletionCallbackTriggered = false;
    info->targetPositionMs = timeStamp;
    if (info->audioBufferQueue) {
        info->audioBufferQueue->Reset();
        info->audioBufferQueue->ResumeProducer();
    }
}

void OHAudioPlayer::SeekPlaySong(uint32_t timeStamp)
{
    if (audioRenderer == nullptr || audioFileOprInfo == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer or audioFileOprInfo is null.");
        return;
    }

    bool wasPlaying = isPlaying;

    if (wasPlaying) {
        auto pauseRet = OH_AudioRenderer_Pause(audioRenderer);
        if (pauseRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Pause failed in seek, ret: %{public}d", pauseRet);
        }
    }

    auto flushRet = OH_AudioRenderer_Flush(audioRenderer);
    if (flushRet != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Flush failed in seek, ret: %{public}d", flushRet);
    }

    uint32_t seekOffset = CalculateSeekOffset(audioFileOprInfo, timeStamp);
    ResetAfterSeek(audioFileOprInfo, seekOffset, timeStamp);

    if (wasPlaying) {
        auto startRet = OH_AudioRenderer_Start(audioRenderer);
        if (startRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Start failed after seek, ret: %{public}d", startRet);
        }
    }

    OH_LOG_INFO(LOG_APP, "Seek position successfully");
}

// [Start SetPlayingSpeed]
void OHAudioPlayer::SetPlayingSpeed(float speed)
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }
    auto ret = OH_AudioRenderer_SetSpeed(audioRenderer, speed);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set playing speed failed, ret: %{public}d", ret);
        return;
    }

    OH_LOG_INFO(LOG_APP, "Set playing speed successfully.");
}
// [End SetPlayingSpeed]

float OHAudioPlayer::GetPlayingVolume()
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return 0;
    }

    float currentVolume = 0;

    auto ret = OH_AudioRenderer_GetVolume(audioRenderer, &currentVolume);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Get stream volume failed, ret: %{public}d", ret);
        return 0;
    }

    OH_LOG_INFO(LOG_APP, "Get stream volume successfully. Current volume is %{public}f", currentVolume);

    return currentVolume;
}

// [Start SetPlayingVolume]
void OHAudioPlayer::SetPlayingVolume(float volume)
{
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    auto ret = OH_AudioRenderer_SetVolume(audioRenderer, volume);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set stream volume failed, ret: %{public}d", ret);
        return;
    }

    OH_LOG_INFO(LOG_APP, "Set stream volume successfully.");
}
// [End SetPlayingVolume]

// [Start SetSilentMode]
void OHAudioPlayer::SetSilentMode(bool isSilentModeOn)
{
    this->isSilentMode = isSilentModeOn;

    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    auto ret = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentModeOn);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set silent mode failed, ret: %{public}d", ret);
        return;
    }

    OH_LOG_INFO(LOG_APP, "Set silent mode successfully.");
}
// [End SetSilentMode]

// [Start SetEffectMode]
void OHAudioPlayer::SetEffectMode(bool isEffectModeOn)
{
    this->isEffectOn = isEffectModeOn;

    if (audioFileOprInfo == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioFileOprInfo is null.");
        return;
    }

    OH_LOG_INFO(LOG_APP, "Set effect mode successfully: %{public}d", isEffectModeOn);
}
// [End SetEffectMode]

// [Start ReleaseCurrentSong]
void OHAudioPlayer::ReleaseCurrentSong()
{
    if (audioFileOprInfo && audioFileOprInfo->audioBufferQueue) {
        audioFileOprInfo->audioBufferQueue->StopProducer();
    }

    if (fileReaderThread && fileReaderThread->joinable()) {
        fileReaderThread->join();
        delete fileReaderThread;
        fileReaderThread = nullptr;
    }

    if (audioRenderer != nullptr) {
        OH_AudioRenderer_Release(audioRenderer);
        audioRenderer = nullptr;
    }

    if (audioFileOprInfo != nullptr) {
        if (audioFileOprInfo->audioBufferQueue) {
            delete audioFileOprInfo->audioBufferQueue;
            audioFileOprInfo->audioBufferQueue = nullptr;
        }
        delete audioFileOprInfo;
        audioFileOprInfo = nullptr;
    }

    OH_LOG_INFO(LOG_APP, "Release current song successfully.");
}
// [End ReleaseCurrentSong]

// [Start ReleasePlayer]
void OHAudioPlayer::ReleasePlayer()
{
    ReleaseCurrentSong();

    if (rendererBuilder != nullptr) {
        OH_AudioStreamBuilder_Destroy(rendererBuilder);
        rendererBuilder = nullptr;
    }

    if (audioWorkgroup != nullptr && workgroupTokenId != 0) {
        OH_AudioWorkgroup_RemoveThread(audioWorkgroup, workgroupTokenId);
    }

    if (audioWorkgroup != nullptr && audioResourceManager != nullptr) {
        OH_AudioResourceManager_ReleaseWorkgroup(audioResourceManager, audioWorkgroup);
        audioWorkgroup = nullptr;
    }

    OH_LOG_INFO(LOG_APP, "Release player successfully.");
}
// [End ReleasePlayer]

static void HandleSeekRequest(AudioFileOprInfo* audioFileOpr)
{
    if (!audioFileOpr->isSeekRequested.load()) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "Seek requested, adjusting file position");

    uint32_t seekOffset = audioFileOpr->seekOffset.load();
    if (audioFileOpr->audioBufferQueue) {
        audioFileOpr->audioBufferQueue->Reset();
    }

    auto pos = lseek(audioFileOpr->songFd, seekOffset, SEEK_SET);
    if (pos == -1) {
        OH_LOG_ERROR(LOG_APP, "Failed to seek to offset: %{public}d", seekOffset);
    } else {
        OH_LOG_INFO(LOG_APP, "Seek completed to offset: %{public}d", seekOffset);
        uint32_t dataStartOffset = audioFileOpr->songFileOffset;
        if (audioFileOpr->isWavFile) {
            dataStartOffset += audioFileOpr->wavDataOffset;
        }
        audioFileOpr->songCurrentOffset = seekOffset - dataStartOffset;
        OH_LOG_INFO(LOG_APP, "Updated songCurrentOffset: %{public}u", audioFileOpr->songCurrentOffset);
    }
    audioFileOpr->isSeekRequested = false;
}

static bool PushAudioData(AudioFileOprInfo* audioFileOpr, uint8_t* readBuffer, ssize_t readSize)
{
    if (!audioFileOpr->audioBufferQueue->IsRunning()) {
        OH_LOG_INFO(LOG_APP, "Producer stopped, exiting thread");
        return false;
    }

    uint32_t validReadSize = static_cast<uint32_t>(readSize);
    if (audioFileOpr->songCurrentOffset + validReadSize > audioFileOpr->songFileSize) {
        validReadSize = audioFileOpr->songFileSize - audioFileOpr->songCurrentOffset;
    }

    if (validReadSize > 0) {
        std::vector<uint8_t> data(readBuffer, readBuffer + validReadSize);
        audioFileOpr->songCurrentOffset += validReadSize;
        if (!audioFileOpr->audioBufferQueue->Push(data)) {
            OH_LOG_ERROR(LOG_APP, "Push failed, data lost");
            if (!audioFileOpr->audioBufferQueue->IsRunning()) {
                OH_LOG_INFO(LOG_APP, "Producer stopped after push failed");
                return false;
            }
        }
    }
    return true;
}

static bool HandleFileEndWithLoop(AudioFileOprInfo* audioFileOpr)
{
    if (audioFileOpr->songCurrentOffset < audioFileOpr->songFileSize) {
        return true;
    }

    if (!audioFileOpr->isFileEnd) {
        audioFileOpr->isFileEnd = true;
        OH_LOG_INFO(LOG_APP, "Set isFileEnd=true, waiting for buffer");
    }

    if (!audioFileOpr->isNeedLoop) {
        if (audioFileOpr->audioBufferQueue->IsEmpty()) {
            audioFileOpr->audioBufferQueue->StopProducer();
            OH_LOG_INFO(LOG_APP, "Buffer empty, stopping producer");
            return false;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(FILE_READER_SLEEP_MS));
        return true;
    }

    if (audioFileOpr->audioBufferQueue->IsEmpty()) {
        uint32_t seekOffset = audioFileOpr->songFileOffset;
        if (audioFileOpr->isWavFile) {
            seekOffset += audioFileOpr->wavDataOffset;
        }
        lseek(audioFileOpr->songFd, seekOffset, SEEK_SET);
        audioFileOpr->songCurrentOffset = 0;
        audioFileOpr->isFileEnd = false;
        OH_LOG_INFO(LOG_APP, "Loop: seeking to offset=%{public}u", seekOffset);
    } else {
        std::this_thread::sleep_for(std::chrono::milliseconds(FILE_READER_SLEEP_MS));
    }
    return true;
}

static bool HandleReadEOF(AudioFileOprInfo* audioFileOpr)
{
    if (!audioFileOpr->isNeedLoop) {
        audioFileOpr->isFileEnd = true;
        audioFileOpr->audioBufferQueue->StopProducer();
        return false;
    }

    uint32_t seekOffset = audioFileOpr->songFileOffset;
    if (audioFileOpr->isWavFile) {
        seekOffset += audioFileOpr->wavDataOffset;
    }
    lseek(audioFileOpr->songFd, seekOffset, SEEK_SET);
    audioFileOpr->songCurrentOffset = 0;
    return true;
}

void OHAudioPlayer::FileReaderThreadFunc(AudioFileOprInfo* audioFileOpr)
{
    if (!audioFileOpr || !audioFileOpr->audioBufferQueue) {
        return;
    }

    OH_LOG_INFO(LOG_APP, "File reader thread started");

    OH_AudioWorkgroup *workgroup = OHAudioPlayer::GetInstance().audioWorkgroup;
    if (workgroup != nullptr) {
        OH_AudioWorkgroup_AddCurrentThread(workgroup, &audioFileOpr->producerThreadTokenId);
        OH_LOG_INFO(LOG_APP, "Producer thread added to workgroup");
    }

    uint8_t readBuffer[FILE_READ_BUFFER_SIZE];
    bool isReadError = false;

    while (audioFileOpr->audioBufferQueue->IsRunning()) {
        HandleSeekRequest(audioFileOpr);

        auto readSize = read(audioFileOpr->songFd, readBuffer, sizeof(readBuffer));

        if (readSize > 0) {
            if (!PushAudioData(audioFileOpr, readBuffer, readSize)) {
                break;
            }
            if (!HandleFileEndWithLoop(audioFileOpr)) {
                break;
            }
        } else if (readSize == 0) {
            if (!HandleReadEOF(audioFileOpr)) {
                break;
            }
        } else {
            OH_LOG_ERROR(LOG_APP, "File reader thread: read error");
            isReadError = true;
            audioFileOpr->audioBufferQueue->StopProducer();
            break;
        }
    }

    if (isReadError) {
        TriggerPlayCompletionCallback(audioFileOpr);
    }

    if (workgroup != nullptr && audioFileOpr->producerThreadTokenId != 0) {
        OH_AudioWorkgroup_RemoveThread(workgroup, audioFileOpr->producerThreadTokenId);
        OH_LOG_INFO(LOG_APP, "Producer thread removed from workgroup");
    }

    OH_LOG_INFO(LOG_APP, "File reader thread exited");
}

// [Start TriggerPlayCompletionCallback]
void OHAudioPlayer::TriggerPlayCompletionCallback(AudioFileOprInfo* audioFileOpr)
{
    if (!audioFileOpr) {
        return;
    }

    bool expected = false;
    if (audioFileOpr->isCompletionCallbackTriggered.compare_exchange_strong(expected, true)) {
        OH_LOG_INFO(LOG_APP, "Triggering play completion callback");
        if (OHAudioPlayer::GetInstance().PlayStatusCallback) {
            OHAudioPlayer::GetInstance().PlayStatusCallback(
                OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
                PlayStatus::Complete);
        }
    }
}
// [End TriggerPlayCompletionCallback]
