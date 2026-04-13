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

// Customize the audio interrupt event function
static void OnAudioInterruptEvent(OH_AudioRenderer *audioRenderer, [[maybe_unused]] void *userData,
                                    OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint) {
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
                               OH_AudioStream_Result error) {
    OH_LOG_ERROR(LOG_APP, "Audio render error, ret: %{public}d", error);
}

// Custom exception callback functions
static void OnAudioDeviceChangeEvent([[maybe_unused]] OH_AudioRenderer* renderer, [[maybe_unused]] void *userData, 
                                     OH_AudioStream_DeviceChangeReason reason) {
    OH_LOG_ERROR(LOG_APP, "receive audio device change, ret: %{public}d", reason);
    if (reason == REASON_OLD_DEVICE_UNAVAILABLE) {
        OHAudioPlayer::GetInstance().PlayStatusCallback(OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
                                                        PlayStatus::Pause);
    }
}

// [Start ApplyAudioEffect]
// Apply audio effect with gain coefficient 0.4
static void ApplyAudioEffect(void *audioData, int32_t audioDataSize) {
    const float gain = 0.4f;
    int16_t *samples = reinterpret_cast<int16_t *>(audioData);
    int32_t sampleCount = audioDataSize / sizeof(int16_t);
    
    for (int32_t i = 0; i < sampleCount; i++) {
        int32_t sample = static_cast<int32_t>(samples[i]);
        sample = static_cast<int32_t>(sample * gain);
        if (sample > 32767) {
            sample = 32767;
        } else if (sample < -32768) {
            sample = -32768;
        }
        samples[i] = static_cast<int16_t>(sample);
    }
}
// [End ApplyAudioEffect]

// [Start OnAudioRendererWriteDataEvent]
// Custom data write function
static OH_AudioData_Callback_Result OnAudioRendererWriteDataEvent([[maybe_unused]] OH_AudioRenderer *audioRenderer,
                                                                  void *userData, void *audioData,
                                                                  int32_t audioDataSize) {
    OH_AudioWorkgroup *workgroup = OHAudioPlayer::GetInstance().audioWorkgroup;
    if (workgroup != nullptr) {
        auto now = std::chrono::system_clock::now().time_since_epoch();
        auto startTimeMs = std::chrono::duration_cast<std::chrono::milliseconds>(now).count();
        constexpr static uint64_t intervalMs = 20;
        OH_AudioWorkgroup_Start(workgroup, startTimeMs, startTimeMs + intervalMs);
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
    uint32_t bytesPerFrame = channels * (bitsPerSample / 8);
    uint64_t framesWritten = actualSize / bytesPerFrame;
    audioFileOprInfo->totalFramesWritten += framesWritten;
    audioFileOprInfo->currentFramesWritten += framesWritten;

    if (workgroup != nullptr) {
        OH_AudioWorkgroup_Stop(workgroup);
    }

    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}
// [End OnAudioRendererWriteDataEvent]

// [Start ParseWavHeader]
static bool ParseWavHeader(int32_t fd, AudioFileOprInfo *audioFileOprInfo) {
    char riff[4];
    uint32_t fileSize;
    char wave[4];
    char chunkId[4];
    uint32_t chunkSize;
    
    auto readSize = read(fd, riff, 4);
    if (readSize < 4) {
        OH_LOG_ERROR(LOG_APP, "Failed to read RIFF header");
        return false;
    }
    
    readSize = read(fd, &fileSize, 4);
    if (readSize < 4) {
        OH_LOG_ERROR(LOG_APP, "Failed to read file size");
        return false;
    }
    
    readSize = read(fd, wave, 4);
    if (readSize < 4) {
        OH_LOG_ERROR(LOG_APP, "Failed to read WAVE header");
        return false;
    }
    
    if (strncmp(riff, "RIFF", 4) != 0 || strncmp(wave, "WAVE", 4) != 0) {
        OH_LOG_ERROR(LOG_APP, "Invalid WAV file format: riff=%{public}.4s, wave=%{public}.4s", riff, wave);
        return false;
    }
    
    OH_LOG_INFO(LOG_APP, "WAV basic header: riff=%{public}.4s, fileSize=%{public}u, wave=%{public}.4s", 
                riff, fileSize, wave);
    
    uint32_t currentOffset = 12;
    bool foundFmt = false;
    
    while (true) {
        readSize = read(fd, chunkId, 4);
        if (readSize < 4) {
            OH_LOG_ERROR(LOG_APP, "Failed to read chunk ID at offset: %{public}u", currentOffset);
            return false;
        }
        
        readSize = read(fd, &chunkSize, 4);
        if (readSize < 4) {
            OH_LOG_ERROR(LOG_APP, "Failed to read chunk size at offset: %{public}u", currentOffset);
            return false;
        }
        
        currentOffset += 8;
        
        OH_LOG_INFO(LOG_APP, "Found chunk: %{public}.4s, size: %{public}u, offset: %{public}u", 
                    chunkId, chunkSize, currentOffset);
        
        if (strncmp(chunkId, "fmt ", 4) == 0) {
            if (chunkSize < 16) {
                OH_LOG_ERROR(LOG_APP, "Invalid fmt chunk size: %{public}u", chunkSize);
                return false;
            }
            
            uint16_t audioFormat;
            uint16_t numChannels;
            uint32_t sampleRate;
            uint32_t byteRate;
            uint16_t blockAlign;
            uint16_t bitsPerSample;
            
            readSize = read(fd, &audioFormat, 2);
            readSize = read(fd, &numChannels, 2);
            readSize = read(fd, &sampleRate, 4);
            readSize = read(fd, &byteRate, 4);
            readSize = read(fd, &blockAlign, 2);
            readSize = read(fd, &bitsPerSample, 2);
            
            OH_LOG_INFO(LOG_APP, "fmt chunk details: audioFormat=%{public}u, channels=%{public}u, "
                                "sampleRate=%{public}u, byteRate=%{public}u, blockAlign=%{public}u, "
                                "bitsPerSample=%{public}u", audioFormat, numChannels, sampleRate, 
                                byteRate, blockAlign, bitsPerSample);
            
            audioFileOprInfo->isWavFile = true;
            audioFileOprInfo->sampleRate = sampleRate;
            audioFileOprInfo->channels = numChannels;
            audioFileOprInfo->bitsPerSample = bitsPerSample;
            foundFmt = true;
            
            int skipBytes = chunkSize - 16;
            if (skipBytes > 0) {
                uint8_t* skipBuffer = new uint8_t[skipBytes];
                read(fd, skipBuffer, skipBytes);
                delete[] skipBuffer;
                OH_LOG_INFO(LOG_APP, "Skipped %{public}d extra bytes in fmt chunk", skipBytes);
            }
            
            currentOffset += chunkSize;
            
        } else if (strncmp(chunkId, "data", 4) == 0) {
            if (!foundFmt) {
                OH_LOG_ERROR(LOG_APP, "Found data chunk before fmt chunk");
                return false;
            }
            
            audioFileOprInfo->wavDataOffset = currentOffset;
            OH_LOG_INFO(LOG_APP, "Found data chunk at: %{public}u, size: %{public}u", 
                        audioFileOprInfo->wavDataOffset, chunkSize);
            return true;
            
        } else {
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
        
        if (currentOffset > 4096) {
            OH_LOG_ERROR(LOG_APP, "WAV header too large (>%{public}u bytes), no data chunk found", currentOffset);
            return false;
        }
    }
    
    return true;
}
// [End ParseWavHeader]

// [Start GetAudioFileOffset]
// Get audio file offset value by seek timeStamp
static uint32_t GetAudioFileOffset(uint32_t songDuration, float targetTimeStamp, uint32_t fileSize, 
                                    uint32_t sampleRate, uint32_t channels, uint32_t bitsPerSample) {
    uint32_t fileOffset = floor((targetTimeStamp / songDuration) * fileSize);
    // bytes per sample frame = channels * bytes per sample
    uint32_t bytesPerSampleFrame = channels * (bitsPerSample / 8);
    uint32_t alignedOffset = fileOffset - fileOffset % bytesPerSampleFrame;
    OH_LOG_INFO(LOG_APP,
                "GetAudioFileOffset: targetTimeStamp=%{public}f, songDuration=%{public}u, "
                "fileSize=%{public}u, fileOffset=%{public}u, bytesPerSampleFrame=%{public}u, "
                "alignedOffset=%{public}u",
                targetTimeStamp, songDuration, fileSize, fileOffset, bytesPerSampleFrame, alignedOffset);
    return alignedOffset;
}
// [End GetAudioFileOffset]

static uint32_t GetAudioCurrentTime(uint32_t songDuration, float currentOffset, uint32_t fileSize) {
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

// [Start InitPlayer]
void OHAudioPlayer::InitPlayer() {
    // Check the residual status of the previous player
    if ((audioRenderer != nullptr) || (rendererBuilder != nullptr) || (audioFileOprInfo != nullptr)) {
        OH_LOG_INFO(LOG_APP, "Previous audio player or builder or fileInfo remained and release it.");
        ReleasePlayer();
    }
    
    // Create stream builder
    OH_AudioStream_Type streamType = AUDIOSTREAM_TYPE_RENDERER;
    auto ret = OH_AudioStreamBuilder_Create(&rendererBuilder, streamType);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create stream builder failed, ret: %{public}d", ret);
        return;
    }

//    ret = OH_AudioStreamBuilder_SetLatencyMode(rendererBuilder, AUDIOSTREAM_LATENCY_MODE_FAST);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set latencyMode failed, ret: %{public}d", ret);
        return;
    }
    OH_LOG_INFO(LOG_APP, "Set latencyMode success, ret: %{public}d", ret);

    // New audioFileOprInfo instance
    audioFileOprInfo = new AudioFileOprInfo();

    // Configure audio parameters
    // Set audio sample rate
    (void)OH_AudioStreamBuilder_SetSamplingRate(rendererBuilder, 48000);
    // Set audio channel count
    (void)OH_AudioStreamBuilder_SetChannelCount(rendererBuilder, 2);
    // Set audio sample format
    (void)OH_AudioStreamBuilder_SetSampleFormat(rendererBuilder, AUDIOSTREAM_SAMPLE_S16LE);
    // Set audio encode type
    (void)OH_AudioStreamBuilder_SetEncodingType(rendererBuilder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    // Set audio render info
    (void)OH_AudioStreamBuilder_SetRendererInfo(rendererBuilder, AUDIOSTREAM_USAGE_MUSIC);
    // Configure audio callback
    // Set audio interrupt callback
    (void)OH_AudioStreamBuilder_SetRendererInterruptCallback(rendererBuilder, OnAudioInterruptEvent, nullptr);
    // Set audio render error callback
    (void)OH_AudioStreamBuilder_SetRendererErrorCallback(rendererBuilder, OnAudioErrorEvent, nullptr);
    // Set audio render write data callback
    (void)OH_AudioStreamBuilder_SetRendererWriteDataCallback(rendererBuilder, OnAudioRendererWriteDataEvent,
                                                             reinterpret_cast<void *>(audioFileOprInfo));
    // Set audio render write data callback
    (void)OH_AudioStreamBuilder_SetRendererOutputDeviceChangeCallback(rendererBuilder, OnAudioDeviceChangeEvent,
                                                                      nullptr);
    ret = OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Create audio renderer failed, ret: %{public}d", ret);
        ReleasePlayer();
    }

    if (isSilentMode) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed in InitPlayer, ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode in InitPlayer: %{public}d", isSilentMode);
        }
    }

    OH_LOG_INFO(LOG_APP, "Restored effect mode in InitPlayer: %{public}d", isEffectOn);

    OH_AudioManager_GetAudioResourceManager(&audioResourceManager);
    if (audioResourceManager != nullptr) {
        OH_AudioResourceManager_CreateWorkgroup(audioResourceManager, "audio_workgroup", &audioWorkgroup);
        if (audioWorkgroup != nullptr) {
            OH_AudioWorkgroup_AddCurrentThread(audioWorkgroup, &workgroupTokenId);
            OH_LOG_INFO(LOG_APP, "Audio workgroup created and thread added successfully.");
        }
    }
    OH_LOG_INFO(LOG_APP, "Init player successfully.");
}

// [Start ReconfigurePlayer]
void OHAudioPlayer::ReconfigurePlayer() {
    if (!audioFileOprInfo) {
        return;
    }

    OH_LOG_INFO(LOG_APP, "Reconfiguring player: sampleRate=%{public}u, channels=%{public}u, bitsPerSample=%{public}u",
                audioFileOprInfo->sampleRate, audioFileOprInfo->channels, audioFileOprInfo->bitsPerSample);

    if (audioRenderer != nullptr) {
        OH_AudioRenderer_Release(audioRenderer);
        audioRenderer = nullptr;
    }

    OH_AudioStream_SampleFormat sampleFormat = AUDIOSTREAM_SAMPLE_S16LE;
    if (audioFileOprInfo->bitsPerSample == 8) {
        sampleFormat = AUDIOSTREAM_SAMPLE_U8;
    } else if (audioFileOprInfo->bitsPerSample == 16) {
        sampleFormat = AUDIOSTREAM_SAMPLE_S16LE;
    } else if (audioFileOprInfo->bitsPerSample == 24) {
        sampleFormat = AUDIOSTREAM_SAMPLE_S24LE;
    } else if (audioFileOprInfo->bitsPerSample == 32) {
        sampleFormat = AUDIOSTREAM_SAMPLE_S32LE;
    }

    (void)OH_AudioStreamBuilder_SetSamplingRate(rendererBuilder, audioFileOprInfo->sampleRate);
    (void)OH_AudioStreamBuilder_SetChannelCount(rendererBuilder, audioFileOprInfo->channels);
    (void)OH_AudioStreamBuilder_SetSampleFormat(rendererBuilder, sampleFormat);

    (void)OH_AudioStreamBuilder_SetRendererInterruptCallback(rendererBuilder, OnAudioInterruptEvent, nullptr);
    (void)OH_AudioStreamBuilder_SetRendererErrorCallback(rendererBuilder, OnAudioErrorEvent, nullptr);
    (void)OH_AudioStreamBuilder_SetRendererWriteDataCallback(rendererBuilder, OnAudioRendererWriteDataEvent,
                                                             reinterpret_cast<void *>(audioFileOprInfo));

    auto ret = OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &audioRenderer);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Recreate audio renderer failed, ret: %{public}d", ret);
        return;
    }

    if (isSilentMode) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed in ReconfigurePlayer, ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode in ReconfigurePlayer: %{public}d", isSilentMode);
        }
    }

    OH_LOG_INFO(LOG_APP, "Restored effect mode in ReconfigurePlayer: %{public}d", isEffectOn);
}
// [End ReconfigurePlayer]
// [End InitPlayer]

// [Start LoadSongInfo]
void OHAudioPlayer::LoadSongInfo(const char *fileName, uint32_t songFd, uint32_t songFileSize, uint32_t songFileOffset) {
    ReleaseCurrentSong();
    
    audioFileOprInfo = new AudioFileOprInfo();

    audioFileOprInfo->songFd = songFd;
    audioFileOprInfo->songFileSize = songFileSize;
    audioFileOprInfo->songFileOffset = songFileOffset;
    audioFileOprInfo->songCurrentOffset = 0;
    audioFileOprInfo->targetPositionMs = 0;
    audioFileOprInfo->isWavFile = false;
    audioFileOprInfo->wavDataOffset = 0;
    (void)lseek(audioFileOprInfo->songFd, songFileOffset, SEEK_SET);

    if (fileName == nullptr) {
        OH_LOG_ERROR(LOG_APP, "File name is null, cannot determine file format");
        return;
    }

    const char *fileExt = strrchr(fileName, '.');
    if (fileExt == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Invalid file name, no extension found");
        return;
    }

    if (strcmp(fileExt, ".wav") == 0 || strcmp(fileExt, ".WAV") == 0) {
        OH_LOG_INFO(LOG_APP, "Detected WAV file format from extension");
        if (ParseWavHeader(songFd, audioFileOprInfo)) {
            audioFileOprInfo->isWavFile = true;
            uint32_t originalFileSize = songFileSize;
            songFileSize = originalFileSize - audioFileOprInfo->wavDataOffset;
            audioFileOprInfo->songFileSize = songFileSize;
            OH_LOG_INFO(LOG_APP, "WAV file size adjusted: original=%{public}u, wavDataOffset=%{public}u, dataSize=%{public}u", 
                        originalFileSize, audioFileOprInfo->wavDataOffset, songFileSize);
            
            uint32_t correctOffset = songFileOffset + audioFileOprInfo->wavDataOffset;
            auto seekResult = lseek(songFd, correctOffset, SEEK_SET);
            OH_LOG_INFO(LOG_APP, "Seeked to correct data offset: %{public}u, result: %{public}lld", 
                        correctOffset, seekResult);
            
            ReconfigurePlayer();
        } else {
            OH_LOG_ERROR(LOG_APP, "Failed to parse WAV header, treating as PCM with default params");
            ReconfigurePlayer();
        }
    } else if (strcmp(fileExt, ".pcm") == 0 || strcmp(fileExt, ".PCM") == 0) {
        OH_LOG_INFO(LOG_APP, "Detected PCM file format from extension, using default params");
        ReconfigurePlayer();
    } else {
        OH_LOG_ERROR(LOG_APP, "Unsupported file format:: %{public}s", fileExt);
        return;
    }

    uint32_t sampleRate = audioFileOprInfo->sampleRate;
    uint32_t channels = audioFileOprInfo->channels;
    uint32_t bitsPerSample = audioFileOprInfo->bitsPerSample;
    uint32_t bytesPerSecond = sampleRate * channels * (bitsPerSample / 8);
    audioFileOprInfo->songDuration = static_cast<uint32_t>(
        static_cast<double>(songFileSize) / bytesPerSecond * 1000);
    
    audioFileOprInfo->songTotalFrames = static_cast<uint64_t>(audioFileOprInfo->songDuration) * sampleRate / 1000;
    audioFileOprInfo->totalFramesWritten = 0;
    audioFileOprInfo->currentFramesWritten = 0;
    
    OH_LOG_INFO(LOG_APP, "Audio params: sampleRate=%{public}u, channels=%{public}u, bitsPerSample=%{public}u, duration=%{public}u ms",
                sampleRate, channels, bitsPerSample, audioFileOprInfo->songDuration);

    audioFileOprInfo->audioBufferQueue = new AudioBufferQueue();
    audioFileOprInfo->audioBufferQueue->Init();
    audioFileOprInfo->isFileEnd = false;
    audioFileOprInfo->isCompletionCallbackTriggered = false;

    fileReaderThread = new std::thread(FileReaderThreadFunc, audioFileOprInfo);
    OH_LOG_INFO(LOG_APP, "Started file reader thread in LoadSongInfo");

    if (isSilentMode && audioRenderer != nullptr) {
        auto silentRet = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
        if (silentRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Restore silent mode failed in LoadSongInfo (PCM), ret: %{public}d", silentRet);
        } else {
            OH_LOG_INFO(LOG_APP, "Restored silent mode in LoadSongInfo (PCM): %{public}d", isSilentMode);
        }
    }

    OH_LOG_INFO(LOG_APP, "Restored effect mode in LoadSongInfo (PCM): %{public}d", isEffectOn);

    OH_LOG_INFO(LOG_APP,
                "Load song information successfully. "
                "Song fd: %{public}d, "
                "file size: %{public}d, "
                "Song duration: %{public}d. "
                "file offset: %{public}d.",
                songFd, songFileSize, audioFileOprInfo->songDuration, songFileOffset);
}
// [End LoadSongInfo]

// [Start PlaySong]
void OHAudioPlayer::PlaySong() {
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
void OHAudioPlayer::PauseSong() {
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
void OHAudioPlayer::StopSong() {
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

int32_t OHAudioPlayer::GetProgress() {
    if (audioFileOprInfo == nullptr) {
        return 0;
    }
    
    uint32_t sampleRate = audioFileOprInfo->sampleRate;
    
    uint64_t framesWritten = audioFileOprInfo->currentFramesWritten.load();
    int32_t currentTimeMs = static_cast<int32_t>((framesWritten * 1000) / sampleRate);
    
    return audioFileOprInfo->targetPositionMs + currentTimeMs;
}

int32_t OHAudioPlayer::GetSongDuration() {
    if (audioFileOprInfo == nullptr) {
        return 0;
    }
    return audioFileOprInfo->songDuration;
}

uint32_t OHAudioPlayer::GetRemainingTime() {
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
    return static_cast<uint32_t>((remainingFrames * 1000) / sampleRate);
}

// [Start SeekPlaySong]
void OHAudioPlayer::SeekPlaySong(uint32_t timeStamp) {
    if (audioRenderer == nullptr || audioFileOprInfo == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer or audioFileOprInfo is null.");
        return;
    }

    OH_LOG_INFO(LOG_APP, "wjjseek SeekPlaySong: %{public}d ms", timeStamp);

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

    audioFileOprInfo->totalFramesWritten = 0;
    audioFileOprInfo->currentFramesWritten = 0;

    uint32_t sampleRate = audioFileOprInfo->sampleRate;
    uint32_t channels = audioFileOprInfo->channels;
    uint32_t bitsPerSample = audioFileOprInfo->bitsPerSample;
    auto fileOffset = GetAudioFileOffset(audioFileOprInfo->songDuration, timeStamp, audioFileOprInfo->songFileSize, 
                                          sampleRate, channels, bitsPerSample);
    fileOffset += audioFileOprInfo->songFileOffset;
    if (audioFileOprInfo->isWavFile) {
        fileOffset += audioFileOprInfo->wavDataOffset;
    }

    OH_LOG_INFO(LOG_APP, "wjjseek SeekPlaySong: fileOffset=%{public}u (songFileOffset=%{public}u, wavDataOffset=%{public}u)", 
                fileOffset, audioFileOprInfo->songFileOffset, 
                audioFileOprInfo->isWavFile ? audioFileOprInfo->wavDataOffset : 0);

    audioFileOprInfo->seekOffset = fileOffset;
    audioFileOprInfo->isSeekRequested = true;
    audioFileOprInfo->isFileEnd = false;
    audioFileOprInfo->isCompletionCallbackTriggered = false;

    if (audioFileOprInfo->audioBufferQueue) {
        audioFileOprInfo->audioBufferQueue->Reset();
        audioFileOprInfo->audioBufferQueue->ResumeProducer();
    }

    audioFileOprInfo->targetPositionMs = timeStamp;

    if (wasPlaying) {
        auto startRet = OH_AudioRenderer_Start(audioRenderer);
        if (startRet != AUDIOSTREAM_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "Start failed after seek, ret: %{public}d", startRet);
        }
    }

    OH_LOG_INFO(LOG_APP, "Seek position successfully");
}
// [End SeekPlaySong]

// [Start SetPlayingSpeed]
void OHAudioPlayer::SetPlayingSpeed(float speed) {
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

float OHAudioPlayer::GetPlayingVolume() {
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
void OHAudioPlayer::SetPlayingVolume(float volume) {
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
void OHAudioPlayer::SetSilentMode(bool isSilentMode) {
    this->isSilentMode = isSilentMode;
    
    if (audioRenderer == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioRenderer is null.");
        return;
    }

    auto ret = OH_AudioRenderer_SetSilentModeAndMixWithOthers(audioRenderer, isSilentMode);
    if (ret != AUDIOSTREAM_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Set silent mode failed, ret: %{public}d", ret);
        return;
    }

    OH_LOG_INFO(LOG_APP, "Set silent mode successfully.");
}
// [End SetSilentMode]

// [Start SetEffectMode]
void OHAudioPlayer::SetEffectMode(bool isEffectOn) {
    this->isEffectOn = isEffectOn;
    
    if (audioFileOprInfo == nullptr) {
        OH_LOG_ERROR(LOG_APP, "The audioFileOprInfo is null.");
        return;
    }
    
    OH_LOG_INFO(LOG_APP, "Set effect mode successfully: %{public}d", isEffectOn);
}
// [End SetEffectMode]

// [Start ReleaseCurrentSong]
void OHAudioPlayer::ReleaseCurrentSong() {
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
void OHAudioPlayer::ReleasePlayer() {
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

// [Start FileReaderThreadFunc]
void OHAudioPlayer::FileReaderThreadFunc(AudioFileOprInfo* audioFileOprInfo)
{
    if (!audioFileOprInfo || !audioFileOprInfo->audioBufferQueue) {
        return;
    }

    OH_LOG_INFO(LOG_APP, "File reader thread started");

    OH_AudioWorkgroup *workgroup = OHAudioPlayer::GetInstance().audioWorkgroup;
    if (workgroup != nullptr) {
        OH_AudioWorkgroup_AddCurrentThread(workgroup, &audioFileOprInfo->producerThreadTokenId);
        OH_LOG_INFO(LOG_APP, "Producer thread added to workgroup with token: %{public}d", 
                   audioFileOprInfo->producerThreadTokenId);
    }

    uint8_t readBuffer[8192];
    bool isReadError = false;

    while (audioFileOprInfo->audioBufferQueue->IsRunning()) {
        if (audioFileOprInfo->isSeekRequested.load()) {
            OH_LOG_INFO(LOG_APP, "Seek requested, adjusting file position");
            
            uint32_t seekOffset = audioFileOprInfo->seekOffset.load();
            
            if (audioFileOprInfo->audioBufferQueue) {
                audioFileOprInfo->audioBufferQueue->Reset();
            }
            
            auto pos = lseek(audioFileOprInfo->songFd, seekOffset, SEEK_SET);
            if (pos == -1) {
                OH_LOG_ERROR(LOG_APP, "Failed to seek to offset: %{public}d", seekOffset);
            } else {
                OH_LOG_INFO(LOG_APP, "Seek completed to offset: %{public}d", seekOffset);
                
                // Update songCurrentOffset (relative to data start position)
                uint32_t dataStartOffset = audioFileOprInfo->songFileOffset;
                if (audioFileOprInfo->isWavFile) {
                    dataStartOffset += audioFileOprInfo->wavDataOffset;
                }
                audioFileOprInfo->songCurrentOffset = seekOffset - dataStartOffset;
                OH_LOG_INFO(LOG_APP, "Updated songCurrentOffset: %{public}u (seekOffset=%{public}u, dataStartOffset=%{public}u)", 
                            audioFileOprInfo->songCurrentOffset, seekOffset, dataStartOffset);
            }
            
            audioFileOprInfo->isSeekRequested = false;
        }
        
        auto readSize = read(audioFileOprInfo->songFd, readBuffer, sizeof(readBuffer));
        
        if (readSize > 0) {
            if (!audioFileOprInfo->audioBufferQueue->IsRunning()) {
                OH_LOG_INFO(LOG_APP, "Producer stopped, exiting thread");
                break;
            }
            
            uint32_t validReadSize = readSize;
            
            if (audioFileOprInfo->songCurrentOffset + readSize > audioFileOprInfo->songFileSize) {
                validReadSize = audioFileOprInfo->songFileSize - audioFileOprInfo->songCurrentOffset;
            }
            
            if (validReadSize > 0) {
                std::vector<uint8_t> data(readBuffer, readBuffer + validReadSize);
                audioFileOprInfo->songCurrentOffset += validReadSize;

                if (!audioFileOprInfo->audioBufferQueue->Push(data)) {
                    OH_LOG_ERROR(LOG_APP, "Push failed, data lost");
                    if (!audioFileOprInfo->audioBufferQueue->IsRunning()) {
                        OH_LOG_INFO(LOG_APP, "Producer stopped after push failed, exiting thread");
                        break;
                    }
                }
            }

            if (audioFileOprInfo->songCurrentOffset >= audioFileOprInfo->songFileSize) {
                if (!audioFileOprInfo->isFileEnd) {
                    audioFileOprInfo->isFileEnd = true;
                    OH_LOG_INFO(LOG_APP, "Set isFileEnd=true, waiting for buffer to be consumed");
                }
                
                if (audioFileOprInfo->isNeedLoop) {
                    if (audioFileOprInfo->audioBufferQueue->IsEmpty()) {
                        uint32_t seekOffset = audioFileOprInfo->songFileOffset;
                        if (audioFileOprInfo->isWavFile) {
                            seekOffset += audioFileOprInfo->wavDataOffset;
                        }
                        (void)lseek(audioFileOprInfo->songFd, seekOffset, SEEK_SET);
                        audioFileOprInfo->songCurrentOffset = 0;
                        audioFileOprInfo->isFileEnd = false;
                        OH_LOG_INFO(LOG_APP, "Loop: buffer empty, seeking to offset=%{public}u", seekOffset);
                    } else {
                        std::this_thread::sleep_for(std::chrono::milliseconds(10));
                    }
                } else {
                    if (audioFileOprInfo->audioBufferQueue->IsEmpty()) {
                        audioFileOprInfo->audioBufferQueue->StopProducer();
                        OH_LOG_INFO(LOG_APP, "Buffer empty, stopping producer");
                        break;
                    } else {
                        std::this_thread::sleep_for(std::chrono::milliseconds(10));
                    }
                }
            }
        } else if (readSize == 0) {

            if (audioFileOprInfo->isNeedLoop) {
                uint32_t seekOffset = audioFileOprInfo->songFileOffset;
                if (audioFileOprInfo->isWavFile) {
                    seekOffset += audioFileOprInfo->wavDataOffset;
                }
                (void)lseek(audioFileOprInfo->songFd, seekOffset, SEEK_SET);
                audioFileOprInfo->songCurrentOffset = 0;
                continue;
            } else {
                audioFileOprInfo->isFileEnd = true;
                audioFileOprInfo->audioBufferQueue->StopProducer();
                break;
            }
        } else {
            OH_LOG_ERROR(LOG_APP, "File reader thread: read error, triggering completion callback");
            isReadError = true;
            audioFileOprInfo->audioBufferQueue->StopProducer();
            break;
        }
    }

    if (isReadError) {
        TriggerPlayCompletionCallback(audioFileOprInfo);
    }

    if (workgroup != nullptr && audioFileOprInfo->producerThreadTokenId != 0) {
        OH_AudioWorkgroup_RemoveThread(workgroup, audioFileOprInfo->producerThreadTokenId);
        OH_LOG_INFO(LOG_APP, "Producer thread removed from workgroup");
    }

    OH_LOG_INFO(LOG_APP, "File reader thread exited");
}
// [End FileReaderThreadFunc]

// [Start TriggerPlayCompletionCallback]
void OHAudioPlayer::TriggerPlayCompletionCallback(AudioFileOprInfo* audioFileOprInfo)
{
    if (!audioFileOprInfo) {
        return;
    }

    bool expected = false;
    if (audioFileOprInfo->isCompletionCallbackTriggered.compare_exchange_strong(expected, true)) {
        OH_LOG_INFO(LOG_APP, "Triggering play completion callback");
        if (OHAudioPlayer::GetInstance().PlayStatusCallback) {
            OHAudioPlayer::GetInstance().PlayStatusCallback(
                OHAudioPlayer::GetInstance().PlayStatusCallbackContext,
                PlayStatus::Complete);
        }
    }
}
// [End TriggerPlayCompletionCallback]
