/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include <hilog/log.h>
#include "Demuxer.h"
#include "Player.h"

#undef LOG_TAG
#define LOG_TAG "Demuxer"

Demuxer::~Demuxer() { Release(); }

// [Start demuxer_create]
int32_t Demuxer::Create(SampleInfo &info)
{
    source_ = OH_AVSource_CreateWithFD(info.inputFd, info.inputFileOffset, info.inputFileSize);
    if (source_ == nullptr) {
        OH_LOG_ERROR(LOG_APP,
                     "Create demuxer source failed, fd: %{public}d, offset: %{public}ld, file size: %{public}ld",
                     info.inputFd, info.inputFileOffset, info.inputFileSize);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    
    demuxer_ = OH_AVDemuxer_CreateWithSource(source_);
    if (demuxer_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Create demuxer failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    auto sourceFormat = std::shared_ptr<OH_AVFormat>(OH_AVSource_GetSourceFormat(source_), OH_AVFormat_Destroy);
    if (sourceFormat == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get source format failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    int32_t ret = GetTrackInfo(sourceFormat, info);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Get video track info, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    
    return AVCODEC_SAMPLE_ERR_OK;
}
// [End demuxer_create]

int32_t Demuxer::ReadSample(int32_t trackId, OH_AVBuffer *buffer, OH_AVCodecBufferAttr &attr)
{
    if (demuxer_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Demuxer is null");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    int32_t ret = OH_AVDemuxer_ReadSampleBuffer(demuxer_, trackId, buffer);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Read sample failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    ret = OH_AVBuffer_GetBufferAttr(buffer, &attr);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "GetBufferAttr failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

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
        int trackType = -1;
        auto trackFormat =
            std::shared_ptr<OH_AVFormat>(OH_AVSource_GetTrackFormat(source_, index), OH_AVFormat_Destroy);
        OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_TRACK_TYPE, &trackType);
        if (trackType == MEDIA_TYPE_VID) {
            OH_AVDemuxer_SelectTrackByID(demuxer_, index);
            OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_WIDTH, &info.videoWidth);
            OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_HEIGHT, &info.videoHeight);
            OH_AVFormat_GetDoubleValue(trackFormat.get(), OH_MD_KEY_FRAME_RATE, &info.frameRate);
            OH_AVFormat_GetLongValue(trackFormat.get(), OH_MD_KEY_BITRATE, &info.bitrate);
            OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_ROTATION, &info.rotation);
            char *videoCodecMime;
            OH_AVFormat_GetStringValue(trackFormat.get(), OH_MD_KEY_CODEC_MIME,
                                       const_cast<char const **>(&videoCodecMime));
            info.videoCodecMime = videoCodecMime;
            OH_AVFormat_GetIntValue(trackFormat.get(), OH_MD_KEY_PROFILE, &info.hevcProfile);
            videoTrackId_ = index;

            OH_LOG_INFO(LOG_APP, "====== Demuxer Video config ======");
            OH_LOG_INFO(LOG_APP, "Mime: %{public}s", videoCodecMime);
            OH_LOG_INFO(LOG_APP, "%{public}d*%{public}d, %{public}.1ffps, %{public}ld"  "kbps", info.videoWidth,
                        info.videoHeight, info.frameRate, info.bitrate / 1024); // 1024 mean bitrate to kbps
            OH_LOG_INFO(LOG_APP, "====== Demuxer Video config ======");
        }
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Demuxer::GetVideoTrackId() { return videoTrackId_; }