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

#include "sample_callback.h"
#include "hilog/log.h"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
}

// 设置 OnError 回调函数
void SampleCallback::OnError(OH_AVCodec *codec, int32_t errorCode, void *userData) {
    // 回调的错误码由用户判断处理
    (void)codec;
    (void)errorCode;
    (void)userData;
    OH_LOG_ERROR(LOG_APP, "On error, error code: %{public}d", errorCode);
}

// 设置 OnStreamChanged 回调函数
void SampleCallback::OnStreamChanged(OH_AVCodec *codec, OH_AVFormat *format, void *userData) {
// surface模式下，该回调函数无作用
    (void)codec;
    (void)format;
    (void)userData;
}

// 设置 OH_AVCodecOnNeedInputBuffer 回调函数，编码输入帧送入数据队列
void SampleCallback::OnNeedInputBuffer(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *buffer, void *userData) {
// surface模式下，该回调函数无作用，用户通过获取的surface输入数据
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== Video OnNeedInputBuffer");
    (void)userData;
    (void)index;
    (void)buffer;
    if (userData == nullptr) {
        return;
    }
    (void)codec;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);
    std::unique_lock<std::mutex> lock(codecUserData->inputMutex_);
    codecUserData->inputBufferInfoQueue_.emplace(index, buffer);
    codecUserData->inputCond_.notify_all();
}

// 设置 OH_AVCodecOnNewOutputBuffer 回调函数，编码完成帧送入输出队列
void SampleCallback::OnNewOutputBuffer(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *buffer, void *userData) {
    // 完成帧buffer对应的index，送入outIndexQueue队列
    // 完成帧的数据buffer送入outBufferQueue队列
    // 数据处理，请参考:
    // - 释放编码帧
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== Video OnNewOutputBuffer");
    if (userData == nullptr) {
        return;
    }
    (void)codec;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);
    std::unique_lock<std::mutex> lock(codecUserData->outputMutex_);
    codecUserData->outputBufferInfoQueue_.emplace(index, buffer);
    codecUserData->outputCond_.notify_all();
}
