/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "demuxer.h"
#include <cstdint>

#undef LOG_TAG
#define LOG_TAG "Demuxer"

namespace {
using namespace std;
}

Demuxer::~Demuxer() { Release(); }

int32_t Demuxer::Create(SampleInfo &info)
{
    /**
     * // Need request Internet Permission first in module.json.
     * const char *url = "https://hd.ijycnd.com/play/Ddw1W2Ra/index.m3u8";
     * source_ = OH_AVSource_CreateWithURI(const_cast<char *>(url));
     */
    source_ = OH_AVSource_CreateWithFD(info.inputFd, info.inputFileOffset, info.inputFileSize);
    CHECK_AND_RETURN_RET_LOG(source_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR,
        "Create demuxer source failed, fd: %{public}d, offset: %{public}" PRId64", file size: %{public}" PRId64,
        info.inputFd, info.inputFileOffset, info.inputFileSize);
    demuxer_ = OH_AVDemuxer_CreateWithSource(source_);
    CHECK_AND_RETURN_RET_LOG(demuxer_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create demuxer failed");

    auto sourceFormat = std::shared_ptr<OH_AVFormat>(OH_AVSource_GetSourceFormat(source_), OH_AVFormat_Destroy);
    CHECK_AND_RETURN_RET_LOG(sourceFormat != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Get source format failed");

    int32_t ret = GetTrackInfo(sourceFormat, info);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Get video track info failed");

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Demuxer::ReadSample(int32_t trackId, OH_AVBuffer *buffer, OH_AVCodecBufferAttr &attr)
{
    CHECK_AND_RETURN_RET_LOG(demuxer_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Demuxer is null");
    int32_t ret = OH_AVDemuxer_ReadSampleBuffer(demuxer_, trackId, buffer);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Read sample failed");
    ret = OH_AVBuffer_GetBufferAttr(buffer, &attr);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "GetBufferAttr failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Demuxer::Release()
{
    if (demuxer_ != nullptr) {
        OH_AVDemuxer_Destroy(demuxer_);
        demuxer_ = nullptr;
    }
    if (source_ != nullptr) {
        OH_AVSource_Destroy(source_);
        source_ = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Demuxer::GetTrackInfo(std::shared_ptr<OH_AVFormat> sourceFormat, SampleInfo &info)
{
    int32_t trackCount = 0;
    OH_AVFormat_GetIntValue(sourceFormat.get(), OH_MD_KEY_TRACK_COUNT, &trackCount);
    for (int32_t index = 0; index < trackCount; index++) {
        auto trackFormat = GetTrackFormat(index);
        int trackType = GetTrackType(trackFormat);
        if (trackType == MEDIA_TYPE_VID) {
            ProcessVideoTrack(trackFormat, index, info);
        } else if (trackType == MEDIA_TYPE_AUD) {
            ProcessAudioTrack(trackFormat, index, info);
        }
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

std::shared_ptr<OH_AVFormat> Demuxer::GetTrackFormat(int32_t index)
{
    return std::shared_ptr<OH_AVFormat>(OH_AVSource_GetTrackFormat(source_, index), OH_AVFormat_Destroy);
}

int Demuxer::GetTrackType(std::shared_ptr<OH_AVFormat> trackFormat)
{
    int trackType = -1;
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_TRACK_TYPE, &trackType);
    return trackType;
}

void Demuxer::ProcessVideoTrack(std::shared_ptr<OH_AVFormat> trackFormat, int32_t index, SampleInfo &info)
{
    OH_AVDemuxer_SelectTrackByID(demuxer_, index);
    
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_WIDTH, &info.videoWidth);
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_HEIGHT, &info.videoHeight);
    OH_AVFormat_GetDoubleValue(trackFormat.get(), OH_MD_KEY_FRAME_RATE, &info.frameRate);
    OH_AVFormat_GetLongValue(trackFormat.get(), OH_MD_KEY_BITRATE, &info.bitrate);
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_ROTATION, &info.rotation);
    
    char *videoCodecMime;
    OH_AVFormat_GetStringValue(trackFormat.get(), OH_MD_KEY_CODEC_MIME, const_cast<char const **>(&videoCodecMime));
    info.videoCodecMime = videoCodecMime;
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_PROFILE, &info.hevcProfile);
    videoTrackId_ = index;
    
    LogVideoConfig(info, videoCodecMime);
}

void Demuxer::ProcessAudioTrack(std::shared_ptr<OH_AVFormat> trackFormat, int32_t index, SampleInfo &info)
{
    OH_AVDemuxer_SelectTrackByID(demuxer_, index);
    
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_AUDIO_SAMPLE_FORMAT, &info.audioSampleForamt);
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_AUD_CHANNEL_COUNT, &info.audioChannelCount);
    OH_AVFormat_GetLongValue(trackFormat.get(), OH_MD_KEY_CHANNEL_LAYOUT, &info.audioChannelLayout);
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_AUD_SAMPLE_RATE, &info.audioSampleRate);
    
    char *audioCodecMime;
    OH_AVFormat_GetStringValue(trackFormat.get(), OH_MD_KEY_CODEC_MIME, const_cast<char const **>(&audioCodecMime));
    
    HandleCodecConfig(trackFormat, info);
    
    OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_AAC_IS_ADTS, &info.aacAdts);
    info.audioCodecMime = audioCodecMime;
    audioTrackId_ = index;
    
    LogAudioConfig(info, audioCodecMime);
}

void Demuxer::HandleCodecConfig(std::shared_ptr<OH_AVFormat> trackFormat, SampleInfo &info)
{
    uint8_t *codecConfig = nullptr;
    OH_AVFormat_GetBuffer(trackFormat.get(), OH_MD_KEY_CODEC_CONFIG, &codecConfig, &info.codecConfigLen);
    
    if (info.codecConfig != nullptr && info.codecConfigLen > 0 && info.codecConfigLen < sizeof(info.codecConfig)) {
        copy(codecConfig, codecConfig + info.codecConfigLen, info.codecConfig);
        LogCodecConfigDetails(info);
    }
}

void Demuxer::LogVideoConfig(const SampleInfo &info, const char *videoCodecMime)
{
    AVCODEC_SAMPLE_LOGI("====== Demuxer Video config ======");
    AVCODEC_SAMPLE_LOGI("Mime: %{public}s", videoCodecMime);
    AVCODEC_SAMPLE_LOGI("%{public}d * %{public}d, %{public}.1ffps, %{public}" PRId64 "kbps",
                        info.videoWidth, info.videoHeight, info.frameRate, info.bitrate / 1024);
    AVCODEC_SAMPLE_LOGI("====== Demuxer Video config ======");
}

void Demuxer::LogAudioConfig(const SampleInfo &info, const char *audioCodecMime)
{
    AVCODEC_SAMPLE_LOGI("====== Demuxer Audio config ======");
    AVCODEC_SAMPLE_LOGI("audioMime:%{public}s sampleForamt:%{public}d sampleRate:%{public}d "
                        "channelCount:%{public}d channelLayout:%{public}ld adts:%{public}i",
                        audioCodecMime, info.audioSampleForamt, info.audioSampleRate,
                        info.audioChannelCount, info.audioChannelLayout, info.aacAdts);
    AVCODEC_SAMPLE_LOGI("====== Demuxer Audio config ======");
}

void Demuxer::LogCodecConfigDetails(const SampleInfo &info)
{
    AVCODEC_SAMPLE_LOGI("codecConfig:%{public}p, len:%{public}i, 0:0x%{public}02x 1:0x:%{public}02x, bufLen:%{public}u",
                        info.codecConfig, static_cast<int>(info.codecConfigLen),
                        info.codecConfig[0], info.codecConfig[1],
                        static_cast<unsigned int>(sizeof(info.codecConfig)));
}

int32_t Demuxer::GetVideoTrackId() { return videoTrackId_; }
int32_t Demuxer::GetAudioTrackId() { return audioTrackId_; }

int32_t Demuxer::Seek(int64_t position)
{
    int32_t ret = OH_AVDemuxer_SeekToTime(demuxer_, position, SEEK_MODE_NEXT_SYNC);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Seek failed");
    return AVCODEC_SAMPLE_ERR_OK;
}