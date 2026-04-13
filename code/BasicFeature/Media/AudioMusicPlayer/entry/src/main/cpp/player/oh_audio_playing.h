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

#ifndef OHAUDIO_PLAY_PCM_OH_AUDIO_PLAYING_H
#define OHAUDIO_PLAY_PCM_OH_AUDIO_PLAYING_H

#include <cstdint>
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostreambuilder.h>
#include <ohaudio/native_audio_resource_manager.h>
#include <uv.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <thread>
#include <atomic>
#include <mutex>
#include "audio_buffer_queue.h"

enum PlayStatus { Play = 1, Pause = 2, Stop = 3, Complete = 4};

#pragma pack(push, 1)
struct WavHeader {
    char riff[4];
    uint32_t fileSize;
    char wave[4];
    char fmt[4];
    uint32_t fmtSize;
    uint16_t audioFormat;
    uint16_t numChannels;
    uint32_t sampleRate;
    uint32_t byteRate;
    uint16_t blockAlign;
    uint16_t bitsPerSample;
    char data[4];
    uint32_t dataSize;
};
#pragma pack(pop)

struct AudioFileOprInfo {
    uint32_t songFd = -1;
    uint32_t songDuration = 0;
    uint32_t songFileSize = 0;
    uint32_t songFileOffset = 0;
    uint32_t songCurrentOffset = 0;
    bool isReadEnd = false;
    bool isNeedLoop = false;
    bool isWavFile = false;
    uint32_t wavDataOffset = 0;
    uint32_t sampleRate = 48000;
    uint16_t channels = 2;
    uint16_t bitsPerSample = 16;
    AudioBufferQueue* audioBufferQueue = nullptr;
    std::atomic<bool> isFileEnd{false};
    std::atomic<bool> isCompletionCallbackTriggered{false};
    std::atomic<uint64_t> totalFramesWritten{0};
    std::atomic<uint64_t> currentFramesWritten{0};
    uint64_t songTotalFrames{0};
    int32_t targetPositionMs = 0;
    int32_t producerThreadTokenId = 0;
    
    std::mutex songInfoMutex;
    std::atomic<bool> isSeekRequested{false};
    std::atomic<uint32_t> seekOffset{0};
};

class OHAudioPlayer {
private:
    OHAudioPlayer() = default;
    OHAudioPlayer(const OHAudioPlayer &) = delete;            // Forbid copying construction
    OHAudioPlayer &operator=(const OHAudioPlayer &) = delete; // Forbid assignment construction

    // In singleton mode, local static singletons will release memory when the program ends.
    ~OHAudioPlayer() { ReleasePlayer(); }

private:
    OH_AudioStreamBuilder *rendererBuilder = nullptr;
    OH_AudioRenderer *audioRenderer = nullptr;
    AudioFileOprInfo *audioFileOprInfo = nullptr;
    std::thread* fileReaderThread = nullptr;

    static void FileReaderThreadFunc(AudioFileOprInfo* audioFileOprInfo);

public:
    OH_AudioResourceManager *audioResourceManager = nullptr;
    OH_AudioWorkgroup *audioWorkgroup = nullptr;
    int32_t workgroupTokenId = 0;
    bool isSilentMode = false;
    bool isEffectOn = false;
    bool isPlaying = false;

public:
    void InitPlayer();
    void ReconfigurePlayer();
    void ReleaseCurrentSong();
    void LoadSongInfo(const char *fileName, uint32_t songFd, uint32_t songFileSize, uint32_t songFileOffset);
    void PlaySong();
    void PauseSong();
    void StopSong();
    int32_t GetProgress();
    int32_t GetSongDuration();
    uint32_t GetRemainingTime();
    void SeekPlaySong(uint32_t timeStamp);
    void SetPlayingSpeed(float speed);
    float GetPlayingVolume();
    void SetPlayingVolume(float volume);
    void SetSilentMode(bool isSilentMode);
    void SetEffectMode(bool isEffectOn);
    void ReleasePlayer();
    void (*PlayStatusCallback)(void *context, PlayStatus playStatus) = nullptr;
    void *PlayStatusCallbackContext = nullptr;
    static void TriggerPlayCompletionCallback(AudioFileOprInfo* audioFileOprInfo);

    static OHAudioPlayer &GetInstance() {
        static OHAudioPlayer instance;
        return instance;
    }
};

#endif // OHAUDIO_PLAY_PCM_OH_AUDIO_PLAYING_H
