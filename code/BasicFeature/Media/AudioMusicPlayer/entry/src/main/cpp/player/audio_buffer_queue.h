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

#ifndef AUDIO_BUFFER_QUEUE_H
#define AUDIO_BUFFER_QUEUE_H

#include <queue>
#include <vector>
#include <mutex>
#include <condition_variable>
#include <atomic>
#include <cstdint>

class AudioBufferQueue {
public:
    AudioBufferQueue() = default;
    ~AudioBufferQueue();

    void Init();
    bool Push(const std::vector<uint8_t>& data);
    bool Pop(uint8_t* buffer, size_t bufferSize, size_t& actualSize);
    void StopProducer();
    void Clear();
    void Reset();
    void ResumeProducer();
    bool IsRunning() const;
    bool IsEmpty() const;

private:
    static constexpr size_t MAX_BUFFER_SIZE = 1024 * 1024;

    std::queue<std::vector<uint8_t>> bufferQueue;
    size_t currentSize = 0;
    mutable std::mutex queueMutex;
    std::condition_variable notEmpty;
    std::condition_variable notFull;
    std::atomic<bool> isProducerRunning{true};
    bool isInitialized = false;
};

#endif // AUDIO_BUFFER_QUEUE_H
