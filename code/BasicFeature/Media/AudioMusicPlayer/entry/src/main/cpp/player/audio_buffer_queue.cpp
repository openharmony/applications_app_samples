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

#include "audio_buffer_queue.h"
#include <hilog/log.h>
#include <chrono>
#include <cstring>
#include <securec.h>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "AudioBufferQueue"

AudioBufferQueue::~AudioBufferQueue()
{
    StopProducer();
    Clear();
}

void AudioBufferQueue::Init()
{
    std::lock_guard<std::mutex> lock(queueMutex);
    isInitialized = true;
    currentSize = 0;
    while (!bufferQueue.empty()) {
        bufferQueue.pop();
    }
    isProducerRunning = true;
}

bool AudioBufferQueue::Push(const std::vector<uint8_t>& data)
{
    if (!isInitialized) {
        return false;
    }

    std::unique_lock<std::mutex> lock(queueMutex);
    notFull.wait(lock, [this, &data] { return currentSize + data.size() <= MAX_BUFFER_SIZE || !isProducerRunning; });

    if (!isProducerRunning) {
        return false;
    }
    bufferQueue.push(data);
    currentSize += data.size();
    notEmpty.notify_one();
    return true;
}

bool AudioBufferQueue::Pop(uint8_t* buffer, size_t bufferSize, size_t& actualSize)
{
    if (!isInitialized || buffer == nullptr) {
        actualSize = 0;
        return false;
    }

    std::unique_lock<std::mutex> lock(queueMutex);

    while (bufferQueue.empty() && isProducerRunning) {
        notFull.notify_one();
        notEmpty.wait(lock, [this] { return !bufferQueue.empty() || !isProducerRunning; });
    }

    if (bufferQueue.empty()) {
        actualSize = 0;
        return false;
    }

    size_t bytesCopied = 0;
    size_t bytesNeeded = bufferSize;
    while (bytesCopied < bytesNeeded && !bufferQueue.empty()) {
        auto& data = bufferQueue.front();
        size_t bytesToCopy = std::min(bytesNeeded - bytesCopied, data.size());
        memcpy_s(buffer + bytesCopied, bufferSize - bytesCopied, data.data(), bytesToCopy);
        bytesCopied += bytesToCopy;

        if (bytesToCopy == data.size()) {
            currentSize -= bytesToCopy;
            bufferQueue.pop();
        } else {
            data.erase(data.begin(), data.begin() + bytesToCopy);
            currentSize -= bytesToCopy;
        }
    }
    actualSize = bytesCopied;
    notFull.notify_one();
    return true;
}

void AudioBufferQueue::StopProducer()
{
    isProducerRunning = false;
    notEmpty.notify_all();
    notFull.notify_all();
}

void AudioBufferQueue::Clear()
{
    std::lock_guard<std::mutex> lock(queueMutex);
    while (!bufferQueue.empty()) {
        bufferQueue.pop();
    }
    currentSize = 0;
}

void AudioBufferQueue::Reset()
{
    std::lock_guard<std::mutex> lock(queueMutex);
    isProducerRunning = true;
    while (!bufferQueue.empty()) {
        bufferQueue.pop();
    }
    currentSize = 0;
    notFull.notify_all();
}

void AudioBufferQueue::ResumeProducer()
{
    std::lock_guard<std::mutex> lock(queueMutex);
    isProducerRunning = true;
    notFull.notify_all();
}

bool AudioBufferQueue::IsRunning() const
{
    return isProducerRunning.load();
}

bool AudioBufferQueue::IsEmpty() const
{
    std::lock_guard<std::mutex> lock(queueMutex);
    return bufferQueue.empty();
}
