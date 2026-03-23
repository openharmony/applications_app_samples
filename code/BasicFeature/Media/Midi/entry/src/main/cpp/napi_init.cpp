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

#include "napi/native_api.h"
#include "ohmidi/native_midi.h"
#include "ohmidi/native_midi_base.h"
#include <hilog/log.h>
#include <string>
#include <vector>
#include <mutex>
#include <map>
#include <atomic>
#include <thread>
#include <memory>
#include <queue>
#include <condition_variable>
#include <cstring>
#include <algorithm>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x0000
#define LOG_TAG "MidiSample"

// ============================================================================
// 共享缓存+常驻线程相关定义 - 解决每次MIDI事件创建新线程的问题
// ============================================================================
constexpr size_t MIDI_RING_BUFFER_SIZE = 1024;
constexpr size_t MIDI_MAX_UMP_WORDS = 4;
constexpr size_t MIDI_BATCH_SIZE = 64;
constexpr size_t MIDI_CACHE_LINE_SIZE = 64;

// MIDI related constants
constexpr uint32_t MIDI_MAX_VELOCITY = 127;
constexpr uint32_t MIDI_VELOCITY_SCALE = 65535;
constexpr uint32_t MIDI_UMP_MT_1_0 = 0x2;
constexpr uint32_t MIDI_UMP_MT_2_0 = 0x4;
constexpr uint32_t MIDI_UMP_STATUS_NOTE_ON = 0x9;
constexpr uint32_t MIDI_UMP_STATUS_NOTE_OFF = 0x8;
constexpr uint32_t MIDI_CHANNEL_MASK = 0x0F;
constexpr uint32_t MIDI_NOTE_MASK = 0x7F;
// Additional constants for codecheck compliance
constexpr uint32_t MIDI_DATA_WORDS_2 = 2;
constexpr uint32_t MIDI_DATA_WORDS_3 = 3;
constexpr uint32_t MIDI_DATA_WORDS_4 = 4;
constexpr uint32_t MIDI_UMP_WORDS_16 = 16;
constexpr uint32_t MIDI_UMP_WORDS_28 = 28;
constexpr uint32_t MIDI_UMP_SHIFT_8 = 8;
constexpr uint32_t MIDI_UMP_SHIFT_20 = 20;
constexpr uint32_t MIDI_UMP_SHIFT_24 = 24;
constexpr size_t MIDI_MAX_PORT_INDEX = 2;
constexpr size_t MIDI_PROTOCOL_1_0 = 1;
constexpr size_t MIDI_PROTOCOL_2_0 = 2;
// Event length constants
constexpr uint32_t MIDI_EVENT_LENGTH_1 = 1;
constexpr uint32_t MIDI_EVENT_LENGTH_2 = 2;
// Argument index constants
constexpr size_t MIDI_ARG_INDEX_2 = 2;
constexpr size_t MIDI_ARG_INDEX_3 = 3;
constexpr size_t MIDI_ARG_INDEX_4 = 4;

// 单个MIDI事件槽位（缓存行对齐）
struct alignas(MIDI_CACHE_LINE_SIZE) MidiEventSlot {
    uint64_t timestamp;
    uint32_t length;
    uint32_t data[MIDI_MAX_UMP_WORDS];

    MidiEventSlot()
        : timestamp(0), length(0)
    {
        for (size_t i = 0; i < MIDI_MAX_UMP_WORDS; i++) {
            data[i] = 0;
        }
    }
};

// 无锁环形缓冲区（SPSC - 单生产者单消费者）
class MidiRingBuffer {
public:
    MidiRingBuffer() : head_(0), tail_(0), overflowFlag_(false) {}

    // 批量写入（由MIDI回调调用，需快速返回）
    size_t PushBatch(const OH_MIDIEvent* events, size_t count)
    {
        size_t pushed = 0;
        for (size_t i = 0; i < count; i++) {
            size_t head = head_.load(std::memory_order_relaxed);
            size_t nextHead = (head + 1) % MIDI_RING_BUFFER_SIZE;
            size_t currentTail = tail_.load(std::memory_order_acquire);
            if (nextHead == currentTail) {
                overflowFlag_.store(true, std::memory_order_relaxed);
                continue; // 缓冲区满，跳过此事件
            }

            buffer_[head].timestamp = events[i].timestamp;
            buffer_[head].length = static_cast<uint32_t>(std::min(events[i].length, MIDI_MAX_UMP_WORDS));
            for (uint32_t j = 0; j < buffer_[head].length; j++) {
                buffer_[head].data[j] = events[i].data[j];
            }

            // Memory fence确保数据写入顺序
            std::atomic_thread_fence(std::memory_order_release);
            head_.store(nextHead, std::memory_order_relaxed);
            pushed++;
        }
        return pushed;
    }

    // 批量读取（由常驻工作线程调用）
    size_t PopBatch(MidiEventSlot* outEvents, size_t maxCount)
    {
        size_t tail = tail_.load(std::memory_order_relaxed);
        size_t head = head_.load(std::memory_order_acquire);

        size_t available = (head >= tail) ? (head - tail) : (MIDI_RING_BUFFER_SIZE - tail + head);
        size_t count = std::min(available, maxCount);

        for (size_t i = 0; i < count; i++) {
            outEvents[i] = buffer_[tail];
            tail = (tail + 1) % MIDI_RING_BUFFER_SIZE;
        }

        if (count > 0) {
            std::atomic_thread_fence(std::memory_order_release);
            tail_.store(tail, std::memory_order_relaxed);
        }
        return count;
    }

    bool Empty() const
    {
        return head_.load(std::memory_order_acquire) == tail_.load(std::memory_order_acquire);
    }

    bool HasOverflow() const
    {
        return overflowFlag_.load(std::memory_order_relaxed);
    }
    void ClearOverflow()
    {
        overflowFlag_.store(false, std::memory_order_relaxed);
    }

private:
    MidiEventSlot buffer_[MIDI_RING_BUFFER_SIZE];
    alignas(MIDI_CACHE_LINE_SIZE) std::atomic<size_t> head_;  // 写指针
    alignas(MIDI_CACHE_LINE_SIZE) std::atomic<size_t> tail_;  // 读指针
    std::atomic<bool> overflowFlag_;
};

// Callback data structures for thread-safe function calls
struct DeviceChangeCallbackData {
    int32_t action;
    int64_t deviceId;
    int32_t deviceType;
    int32_t nativeProtocol;
    std::string deviceName;
    std::string deviceAddress;
    uint64_t vendorId;
    uint64_t productId;
};

struct MidiReceivedCallbackData {
    int64_t deviceId;
    uint32_t portIndex;
    std::vector<uint32_t> umpData;
    std::vector<uint64_t> timestamps;
    std::vector<uint32_t> lengths;
};

static void CallJsMidiReceived(napi_env env, napi_value js_callback, void* context, void* data);

// 输入端口上下文（每个input port一个，包含常驻线程和共享缓存）
class InputPortContext : public std::enable_shared_from_this<InputPortContext> {
public:
    InputPortContext(int64_t deviceId, uint32_t portIndex)
        : deviceId_(deviceId), portIndex_(portIndex), tsfn_(nullptr),
          running_(false), started_(false), totalReceived_(0), totalDropped_(0)
    {}

    ~InputPortContext()
    {
        Stop();
    }

    bool Start(napi_env env, napi_value callback)
    {
        bool expected = false;
        if (!running_.compare_exchange_strong(expected, true, std::memory_order_acq_rel)) {
            return true; // 已经在运行
        }

        napi_value resourceName;
        std::string name = "MidiCallback_" + std::to_string(deviceId_) + "_" + std::to_string(portIndex_);
        napi_create_string_utf8(env, name.c_str(), NAPI_AUTO_LENGTH, &resourceName);

        if (napi_create_threadsafe_function(env, callback, nullptr, resourceName,
            0, 1, nullptr, nullptr, nullptr, CallJsMidiReceived, &tsfn_) != napi_ok) {
            running_.store(false);
            return false;
        }

        workerThread_ = std::thread(&InputPortContext::WorkerLoop, this);

        // 等待线程真正启动
        while (!started_.load(std::memory_order_acquire)) {
            std::this_thread::yield();
        }
        return true;
    }

    void Stop()
    {
        bool expected = true;
        if (!running_.compare_exchange_strong(expected, false, std::memory_order_acq_rel)) {
            return; // 已经停止
        }

        cv_.notify_one();

        // 先abort tsfn，阻止新的JS调用
        if (tsfn_ != nullptr) {
            napi_release_threadsafe_function(tsfn_, napi_tsfn_abort);
        }

        if (workerThread_.joinable()) {
            workerThread_.join();
        }

        // 再release tsfn
        if (tsfn_ != nullptr) {
            napi_release_threadsafe_function(tsfn_, napi_tsfn_release);
            tsfn_ = nullptr;
        }
    }

    // MIDI回调入口 - 批量写入环形缓冲区
    void PushEventBatch(const OH_MIDIEvent* events, size_t eventCount)
    {
        if (events == nullptr || eventCount == 0) {
            return;
        }

        size_t pushed = ringBuffer_.PushBatch(events, eventCount);
        if (pushed > 0) {
            std::unique_lock<std::mutex> lock(mutex_);
            cv_.notify_one();
        }
        if (pushed < eventCount) {
            totalDropped_.fetch_add(eventCount - pushed, std::memory_order_relaxed);
        }
        totalReceived_.fetch_add(pushed, std::memory_order_relaxed);
    }

    int64_t GetDeviceId() const
    {
        return deviceId_;
    }
    uint32_t GetPortIndex() const
    {
        return portIndex_;
    }

private:
    void WorkerLoop()
    {
        OH_LOG_DEBUG(LOG_APP, "[MidiWorkerLoop] ++enter, deviceId=%{public}lld, portIndex=%{public}u",
                     (long long)deviceId_, portIndex_);

        started_.store(true, std::memory_order_release);
        MidiEventSlot batchBuffer[MIDI_BATCH_SIZE];

        while (running_.load(std::memory_order_acquire)) {
            size_t eventCount = ringBuffer_.PopBatch(batchBuffer, MIDI_BATCH_SIZE);
            if (eventCount > 0) {
                ProcessBatch(batchBuffer, eventCount);
                continue;
            }

            // 无数据，等待
            std::unique_lock<std::mutex> lock(mutex_);
            cv_.wait(lock, [this] {
                return !ringBuffer_.Empty() || !running_.load(std::memory_order_acquire);
            });
        }

        OH_LOG_DEBUG(LOG_APP, "[MidiWorkerLoop] --exit, deviceId=%{public}lld", (long long)deviceId_);
    }

    void ProcessBatch(MidiEventSlot* events, size_t count)
    {
        if (tsfn_ == nullptr || count == 0) {
            return;
        }

        MidiReceivedCallbackData* callbackData = new MidiReceivedCallbackData();
        callbackData->deviceId = deviceId_;
        callbackData->portIndex = portIndex_;

        for (size_t i = 0; i < count; i++) {
            callbackData->timestamps.push_back(events[i].timestamp);
            callbackData->lengths.push_back(events[i].length);
            for (uint32_t j = 0; j < events[i].length; j++) {
                callbackData->umpData.push_back(events[i].data[j]);
            }
        }

        napi_status status = napi_call_threadsafe_function(tsfn_, callbackData, napi_tsfn_nonblocking);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP,
                "[InputPortContext::processBatch] napi_call_threadsafe_function failed: %{public}d",
                (int)status);
            delete callbackData;
        }
    }

    int64_t deviceId_;
    uint32_t portIndex_;
    napi_threadsafe_function tsfn_;

    MidiRingBuffer ringBuffer_;
    std::thread workerThread_;
    std::mutex mutex_;
    std::condition_variable cv_;
    std::atomic<bool> running_;
    std::atomic<bool> started_;
    std::atomic<uint64_t> totalReceived_;
    std::atomic<uint64_t> totalDropped_;
};

// Global MIDI client and state management
static OH_MIDIClient *g_midiClient = nullptr;
static std::mutex g_midiMutex;
static std::map<int64_t, OH_MIDIDevice*> g_openedDevices;
static napi_threadsafe_function g_deviceChangeTsfn = nullptr;

// 输入端口上下文存储（使用shared_ptr管理生命周期）
static std::map<std::pair<int64_t, uint32_t>, std::shared_ptr<InputPortContext>> g_inputPortContexts;

// 输出端口协议存储 key = (deviceId, portIndex), value = protocol
static std::map<std::pair<int64_t, uint32_t>, OH_MIDIProtocol> g_outputPortProtocols;

// BLE device open callback storage
struct BLEOpenCallbackInfo {
    napi_threadsafe_function tsfn;
    std::string deviceAddress;
};
static std::map<std::string, BLEOpenCallbackInfo> g_bleOpenCallbacks;

struct BleOpenedCallbackData {
    bool opened;
    int64_t deviceId;
    int32_t deviceType;
    int32_t nativeProtocol;
    std::string deviceName;
    std::string deviceAddress;
    uint64_t vendorId;
    uint64_t productId;
};

// Helper: Set int64 property on object
static inline void SetInt64Prop(napi_env env, napi_value obj, const char* name, int64_t value)
{
    napi_value val;
    napi_create_int64(env, value, &val);
    napi_set_named_property(env, obj, name, val);
}

// Helper: Set int32 property on object
static inline void SetInt32Prop(napi_env env, napi_value obj, const char* name, int32_t value)
{
    napi_value val;
    napi_create_int32(env, value, &val);
    napi_set_named_property(env, obj, name, val);
}

// Helper: Set string property on object
static inline void SetStringProp(napi_env env, napi_value obj, const char* name, const std::string& value)
{
    napi_value val;
    napi_create_string_utf8(env, value.c_str(), NAPI_AUTO_LENGTH, &val);
    napi_set_named_property(env, obj, name, val);
}

// Helper: Set bigint uint64 property on object
static inline void SetBigintUint64Prop(napi_env env, napi_value obj, const char* name, uint64_t value)
{
    napi_value val;
    napi_create_bigint_uint64(env, value, &val);
    napi_set_named_property(env, obj, name, val);
}

// Device info data structure for simplified parameter passing
struct DeviceInfoData {
    int64_t deviceId;
    int32_t deviceType;
    int32_t nativeProtocol;
    std::string deviceName;
    std::string deviceAddress;
    uint64_t vendorId;
    uint64_t productId;
};

// Helper: Set all device properties on JS object
static void SetDeviceProperties(napi_env env, napi_value obj, const DeviceInfoData& data)
{
    SetInt64Prop(env, obj, "deviceId", data.deviceId);
    SetInt32Prop(env, obj, "deviceType", data.deviceType);
    SetInt32Prop(env, obj, "nativeProtocol", data.nativeProtocol);
    SetStringProp(env, obj, "deviceName", data.deviceName);
    SetBigintUint64Prop(env, obj, "vendorId", data.vendorId);
    SetBigintUint64Prop(env, obj, "productId", data.productId);
    SetStringProp(env, obj, "deviceAddress", data.deviceAddress);
}

// Helper function to create JavaScript object from device info data
static napi_value CreateDeviceInfoObjectFromData(napi_env env, const DeviceInfoData& data)
{
    OH_LOG_DEBUG(LOG_APP, "[CreateDeviceInfoObjectFromData] deviceId=%{public}lld",
                 (long long)data.deviceId);

    napi_value deviceObj;
    napi_create_object(env, &deviceObj);
    SetDeviceProperties(env, deviceObj, data);
    return deviceObj;
}

// Helper function to create JavaScript object from device information
static napi_value CreateDeviceInfoObject(napi_env env, const OH_MIDIDeviceInformation& info)
{
    DeviceInfoData data;
    data.deviceId = info.midiDeviceId;
    data.deviceType = static_cast<int32_t>(info.deviceType);
    data.nativeProtocol = static_cast<int32_t>(info.nativeProtocol);
    data.deviceName = info.deviceName;
    data.deviceAddress = info.deviceAddress;
    data.vendorId = info.vendorId;
    data.productId = info.productId;
    return CreateDeviceInfoObjectFromData(env, data);
}

// Helper function to create JavaScript object from port information
static napi_value CreatePortInfoObject(napi_env env, const OH_MIDIPortInformation& info)
{
    OH_LOG_DEBUG(LOG_APP,
        "[CreatePortInfoObject] portIndex=%{public}u, deviceId=%{public}lld, direction=%{public}d, name=%{public}s",
        info.portIndex, (long long)info.deviceId, (int)info.direction, info.name);

    napi_value portObj;
    napi_create_object(env, &portObj);

    napi_value portIndex;
    napi_create_uint32(env, info.portIndex, &portIndex);
    napi_set_named_property(env, portObj, "portIndex", portIndex);

    napi_value deviceId;
    napi_create_int64(env, info.deviceId, &deviceId);
    napi_set_named_property(env, portObj, "deviceId", deviceId);

    napi_value direction;
    napi_create_int32(env, static_cast<int32_t>(info.direction), &direction);
    napi_set_named_property(env, portObj, "direction", direction);

    napi_value name;
    napi_create_string_utf8(env, info.name, NAPI_AUTO_LENGTH, &name);
    napi_set_named_property(env, portObj, "name", name);

    return portObj;
}

// Thread-safe function call JS callback for device change
static void CallJsDeviceChange(napi_env env, napi_value js_callback, void* context, void* data)
{
    OH_LOG_INFO(LOG_APP, "[CallJsDeviceChange] ++enter (JS thread)");

    DeviceChangeCallbackData* callbackData = (DeviceChangeCallbackData*)data;
    OH_LOG_INFO(LOG_APP,
        "[CallJsDeviceChange] action=%{public}d, deviceId=%{public}lld, deviceName=%{public}s",
        callbackData->action, (long long)callbackData->deviceId, callbackData->deviceName.c_str());

    napi_value args[2];
    napi_create_int32(env, callbackData->action, &args[0]);

    DeviceInfoData deviceData;
    deviceData.deviceId = callbackData->deviceId;
    deviceData.deviceType = callbackData->deviceType;
    deviceData.nativeProtocol = callbackData->nativeProtocol;
    deviceData.deviceName = callbackData->deviceName;
    deviceData.deviceAddress = callbackData->deviceAddress;
    deviceData.vendorId = callbackData->vendorId;
    deviceData.productId = callbackData->productId;
    args[1] = CreateDeviceInfoObjectFromData(env, deviceData);

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    napi_status callStatus = napi_call_function(env, undefined, js_callback, 2, args, nullptr);
    if (callStatus != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "[CallJsDeviceChange] napi_call_function failed: %{public}d", (int)callStatus);
    } else {
        OH_LOG_INFO(LOG_APP, "[CallJsDeviceChange] JS callback executed successfully");
    }

    delete callbackData;
    OH_LOG_INFO(LOG_APP, "[CallJsDeviceChange] --exit (JS thread)");
}

// Helper: Create MIDI event JS object
static napi_value CreateMidiEventObject(napi_env env, uint64_t timestamp, uint32_t length,
    const std::vector<uint32_t>& umpData, size_t& dataIndex)
{
    napi_value eventObj;
    napi_create_object(env, &eventObj);

    napi_value tsValue;
    napi_create_bigint_uint64(env, timestamp, &tsValue);
    napi_set_named_property(env, eventObj, "timestamp", tsValue);

    napi_value lenValue;
    napi_create_uint32(env, length, &lenValue);
    napi_set_named_property(env, eventObj, "length", lenValue);

    napi_value dataArray;
    napi_create_array(env, &dataArray);
    for (uint32_t j = 0; j < length && dataIndex < umpData.size(); j++) {
        napi_value dataValue;
        napi_create_uint32(env, umpData[dataIndex], &dataValue);
        napi_set_element(env, dataArray, j, dataValue);
        dataIndex++;
    }
    napi_set_named_property(env, eventObj, "data", dataArray);
    return eventObj;
}

// Thread-safe function call JS callback for MIDI received
static void CallJsMidiReceived(napi_env env, napi_value js_callback, void* context, void* data)
{
    MidiReceivedCallbackData* callbackData = static_cast<MidiReceivedCallbackData*>(data);

    napi_value eventsArray;
    napi_create_array(env, &eventsArray);

    size_t eventIndex = 0;
    size_t dataIndex = 0;
    for (size_t i = 0; i < callbackData->lengths.size(); i++) {
        napi_value eventObj = CreateMidiEventObject(env, callbackData->timestamps[i],
            callbackData->lengths[i], callbackData->umpData, dataIndex);
        napi_set_element(env, eventsArray, static_cast<uint32_t>(eventIndex), eventObj);
        eventIndex++;
    }

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    napi_call_function(env, undefined, js_callback, 1, &eventsArray, nullptr);

    delete callbackData;
}

// Thread-safe function call JS callback for BLE opened
static void CallJsBleOpened(napi_env env, napi_value js_callback, void* context, void* data)
{
    OH_LOG_INFO(LOG_APP, "[CallJsBleOpened] ++enter (JS thread)");

    BleOpenedCallbackData* callbackData = (BleOpenedCallbackData*)data;
    OH_LOG_INFO(LOG_APP, "[CallJsBleOpened] opened=%{public}d, deviceId=%{public}lld, deviceName=%{public}s",
                callbackData->opened ? 1 : 0, (long long)callbackData->deviceId, callbackData->deviceName.c_str());

    napi_value args[2];
    napi_get_boolean(env, callbackData->opened, &args[0]);
    DeviceInfoData deviceData;
    deviceData.deviceId = callbackData->deviceId;
    deviceData.deviceType = callbackData->deviceType;
    deviceData.nativeProtocol = callbackData->nativeProtocol;
    deviceData.deviceName = callbackData->deviceName;
    deviceData.deviceAddress = callbackData->deviceAddress;
    deviceData.vendorId = callbackData->vendorId;
    deviceData.productId = callbackData->productId;
    args[1] = CreateDeviceInfoObjectFromData(env, deviceData);

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    napi_status callStatus = napi_call_function(env, undefined, js_callback, 2, args, nullptr);
    if (callStatus != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "[CallJsBleOpened] napi_call_function failed: %{public}d", (int)callStatus);
    } else {
        OH_LOG_INFO(LOG_APP, "[CallJsBleOpened] JS callback executed successfully");
    }

    delete callbackData;
    OH_LOG_INFO(LOG_APP, "[CallJsBleOpened] --exit (JS thread)");
}

// Device change callback - called by MIDI service (DO NOT hold lock here)
static void OnDeviceChange(void *userData, OH_MIDIDeviceChangeAction action, OH_MIDIDeviceInformation info)
{
    OH_LOG_INFO(LOG_APP,
        "[OnDeviceChange] ++enter (callback thread), action=%{public}d, deviceId=%{public}lld, "
        "deviceName=%{public}s, deviceType=%{public}d, deviceAddress=%{public}s",
        (int)action, (long long)info.midiDeviceId, info.deviceName,
        (int)info.deviceType, info.deviceAddress);

    // Do NOT hold lock in callback! Just copy data and send to JS thread
    if (g_deviceChangeTsfn != nullptr) {
        DeviceChangeCallbackData* callbackData = new DeviceChangeCallbackData();
        callbackData->action = static_cast<int32_t>(action);
        callbackData->deviceId = info.midiDeviceId;
        callbackData->deviceType = static_cast<int32_t>(info.deviceType);
        callbackData->nativeProtocol = static_cast<int32_t>(info.nativeProtocol);
        callbackData->deviceName = info.deviceName;
        callbackData->deviceAddress = info.deviceAddress;
        callbackData->vendorId = info.vendorId;
        callbackData->productId = info.productId;

        OH_LOG_DEBUG(LOG_APP, "[OnDeviceChange] calling napi_call_threadsafe_function");
        napi_status status = napi_call_threadsafe_function(g_deviceChangeTsfn, callbackData, napi_tsfn_nonblocking);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "[OnDeviceChange] napi_call_threadsafe_function failed: %{public}d", (int)status);
            delete callbackData;
        } else {
            OH_LOG_INFO(LOG_APP, "[OnDeviceChange] threadsafe function called successfully");
        }
    } else {
        OH_LOG_WARN(LOG_APP, "[OnDeviceChange] g_deviceChangeTsfn is nullptr, cannot notify JS");
    }

    OH_LOG_INFO(LOG_APP, "[OnDeviceChange] --exit (callback thread)");
}

// Error callback - called when MIDI service encounters critical errors
static void OnError(void *userData, OH_MIDIStatusCode code)
{
    OH_LOG_ERROR(LOG_APP, "[OnError] ++enter, errorCode=%{public}d", (int)code);
    // Error handling logic here
    OH_LOG_ERROR(LOG_APP, "[OnError] --exit");
}

// MIDI client callbacks
static OH_MIDICallbacks g_midiCallbacks = {
    .onDeviceChange = OnDeviceChange,
    .onError = OnError
};

// Helper: Cleanup existing MIDI client resources
static void CleanupExistingClient()
{
    if (g_midiClient != nullptr) {
        OH_LOG_INFO(LOG_APP, "[CleanupExistingClient] destroying existing client");
        OH_MIDIClient_Destroy(g_midiClient);
        g_midiClient = nullptr;
    }
    if (g_deviceChangeTsfn != nullptr) {
        OH_LOG_INFO(LOG_APP, "[CleanupExistingClient] releasing old threadsafe function");
        napi_release_threadsafe_function(g_deviceChangeTsfn, napi_tsfn_release);
        g_deviceChangeTsfn = nullptr;
    }
}

// Helper: Setup device change callback
static void SetupDeviceChangeCallback(napi_env env, napi_value callback)
{
    if (callback == nullptr) {
        return;
    }
    napi_valuetype valueType;
    napi_typeof(env, callback, &valueType);
    if (valueType != napi_function) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "[SetupDeviceChangeCallback] creating threadsafe function");
    napi_value resourceName;
    napi_create_string_utf8(env, "DeviceChangeCallback", NAPI_AUTO_LENGTH, &resourceName);
    napi_status tsfnStatus = napi_create_threadsafe_function(env, callback, nullptr, resourceName,
        0, 1, nullptr, nullptr, nullptr, CallJsDeviceChange, &g_deviceChangeTsfn);
    if (tsfnStatus != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "[SetupDeviceChangeCallback] failed: %{public}d", static_cast<int>(tsfnStatus));
    }
}

// Create MIDI client
static napi_value CreateMIDIClient(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[CreateMIDIClient] ++enter");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    std::lock_guard<std::mutex> lock(g_midiMutex);
    CleanupExistingClient();
    if (argc > 0 && args[0] != nullptr) {
        SetupDeviceChangeCallback(env, args[0]);
    }

    OH_MIDIStatusCode status = OH_MIDIClient_Create(&g_midiClient, g_midiCallbacks, nullptr);
    OH_LOG_INFO(LOG_APP, "[CreateMIDIClient] status=%{public}d", static_cast<int>(status));

    napi_value result;
    napi_create_int32(env, static_cast<int32_t>(status), &result);
    return result;
}

// Helper: Close all opened MIDI devices
static void CloseAllOpenedDevices()
{
    if (g_midiClient == nullptr) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "[CloseAllOpenedDevices] closing %{public}zu devices", g_openedDevices.size());
    for (auto& pair : g_openedDevices) {
        OH_MIDIClient_CloseDevice(g_midiClient, pair.second);
    }
    g_openedDevices.clear();
}

// Helper: Cleanup all port contexts and callbacks
static void CleanupAllPortContexts()
{
    // Cleanup input port contexts
    for (auto& pair : g_inputPortContexts) {
        if (pair.second != nullptr) {
            pair.second->Stop();
        }
    }
    g_inputPortContexts.clear();

    // Cleanup output port protocols
    g_outputPortProtocols.clear();

    // Cleanup BLE callbacks
    for (auto& pair : g_bleOpenCallbacks) {
        if (pair.second.tsfn != nullptr) {
            napi_release_threadsafe_function(pair.second.tsfn, napi_tsfn_release);
        }
    }
    g_bleOpenCallbacks.clear();

    // Release device change threadsafe function
    if (g_deviceChangeTsfn != nullptr) {
        napi_release_threadsafe_function(g_deviceChangeTsfn, napi_tsfn_release);
        g_deviceChangeTsfn = nullptr;
    }
}

// Destroy MIDI client
static napi_value DestroyMIDIClient(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[DestroyMIDIClient] ++enter");
    std::lock_guard<std::mutex> lock(g_midiMutex);

    if (g_midiClient != nullptr) {
        CloseAllOpenedDevices();
        OH_MIDIClient_Destroy(g_midiClient);
        g_midiClient = nullptr;
    }

    CleanupAllPortContexts();

    napi_value result;
    napi_get_undefined(env, &result);
    OH_LOG_INFO(LOG_APP, "[DestroyMIDIClient] --exit");
    return result;
}

// Get device count
static napi_value GetDeviceCount(napi_env env, napi_callback_info info)
{
    OH_LOG_DEBUG(LOG_APP, "[GetDeviceCount] ++enter");

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    if (g_midiClient == nullptr) {
        OH_LOG_WARN(LOG_APP, "[GetDeviceCount] client is null, returning -1");
        napi_create_int32(env, -1, &result);
        return result;
    }

    size_t count = 0;
    OH_MIDIStatusCode status = OH_MIDIClient_GetDeviceCount(g_midiClient, &count);
    if (status != OH_MIDI_STATUS_OK) {
        OH_LOG_ERROR(LOG_APP, "[GetDeviceCount] failed: %{public}d", (int)status);
        napi_create_int32(env, -1, &result);
        return result;
    }

    OH_LOG_DEBUG(LOG_APP, "[GetDeviceCount] count=%{public}zu", count);
    napi_create_uint32(env, static_cast<uint32_t>(count), &result);

    OH_LOG_DEBUG(LOG_APP, "[GetDeviceCount] --exit, count=%{public}zu", count);
    return result;
}

// Get device list
static napi_value GetDeviceInfos(napi_env env, napi_callback_info info)
{
    OH_LOG_DEBUG(LOG_APP, "[GetDeviceInfos] ++enter");

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    napi_create_array(env, &result);

    if (g_midiClient == nullptr) {
        OH_LOG_WARN(LOG_APP, "[GetDeviceInfos] client is null");
        return result;
    }

    size_t count = 0;
    OH_MIDIStatusCode status = OH_MIDIClient_GetDeviceCount(g_midiClient, &count);
    if (status != OH_MIDI_STATUS_OK || count == 0) {
        OH_LOG_DEBUG(LOG_APP, "[GetDeviceInfos] no devices or error: status=%{public}d, count=%{public}zu",
                     (int)status, count);
        return result;
    }

    std::vector<OH_MIDIDeviceInformation> devices(count);
    size_t actualCount = 0;
    status = OH_MIDIClient_GetDeviceInfos(g_midiClient, devices.data(), count, &actualCount);
    if (status == OH_MIDI_STATUS_OK) {
        OH_LOG_DEBUG(LOG_APP, "[GetDeviceInfos] got %{public}zu devices", actualCount);
        for (size_t i = 0; i < actualCount; i++) {
            OH_LOG_DEBUG(LOG_APP,
                "[GetDeviceInfos] device[%{public}zu]: id=%{public}lld, name=%{public}s, type=%{public}d",
                i, (long long)devices[i].midiDeviceId, devices[i].deviceName, (int)devices[i].deviceType);
            napi_value deviceObj = CreateDeviceInfoObject(env, devices[i]);
            napi_set_element(env, result, static_cast<uint32_t>(i), deviceObj);
        }
    } else {
        OH_LOG_ERROR(LOG_APP, "[GetDeviceInfos] OH_MIDIClient_GetDeviceInfos failed: %{public}d", (int)status);
    }

    OH_LOG_DEBUG(LOG_APP, "[GetDeviceInfos] --exit, actualCount=%{public}zu", actualCount);
    return result;
}

// Get port count for a device
static napi_value GetPortCount(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    OH_LOG_DEBUG(LOG_APP, "[GetPortCount] ++enter, deviceId=%{public}lld", (long long)deviceId);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    if (g_midiClient == nullptr) {
        OH_LOG_WARN(LOG_APP, "[GetPortCount] client is null");
        napi_create_int32(env, -1, &result);
        return result;
    }

    size_t count = 0;
    OH_MIDIStatusCode status = OH_MIDIClient_GetPortCount(g_midiClient, deviceId, &count);
    if (status != OH_MIDI_STATUS_OK) {
        OH_LOG_ERROR(LOG_APP, "[GetPortCount] failed: %{public}d", (int)status);
        napi_create_int32(env, -1, &result);
        return result;
    }

    OH_LOG_DEBUG(LOG_APP, "[GetPortCount] --exit, count=%{public}zu", count);
    napi_create_uint32(env, static_cast<uint32_t>(count), &result);
    return result;
}

// Get port information for a device
static napi_value GetPortInfos(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    OH_LOG_DEBUG(LOG_APP, "[GetPortInfos] ++enter, deviceId=%{public}lld", (long long)deviceId);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    napi_create_array(env, &result);

    if (g_midiClient == nullptr) {
        OH_LOG_WARN(LOG_APP, "[GetPortInfos] client is null");
        return result;
    }

    size_t count = 0;
    OH_MIDIStatusCode status = OH_MIDIClient_GetPortCount(g_midiClient, deviceId, &count);
    if (status != OH_MIDI_STATUS_OK || count == 0) {
        OH_LOG_DEBUG(LOG_APP, "[GetPortInfos] no ports or error: status=%{public}d, count=%{public}zu",
                     (int)status, count);
        return result;
    }

    std::vector<OH_MIDIPortInformation> ports(count);
    size_t actualCount = 0;
    status = OH_MIDIClient_GetPortInfos(g_midiClient, deviceId, ports.data(), count, &actualCount);
    if (status == OH_MIDI_STATUS_OK) {
        OH_LOG_DEBUG(LOG_APP, "[GetPortInfos] got %{public}zu ports", actualCount);
        for (size_t i = 0; i < actualCount; i++) {
            napi_value portObj = CreatePortInfoObject(env, ports[i]);
            napi_set_element(env, result, static_cast<uint32_t>(i), portObj);
        }
    } else {
        OH_LOG_ERROR(LOG_APP, "[GetPortInfos] OH_MIDIClient_GetPortInfos failed: %{public}d", (int)status);
    }

    OH_LOG_DEBUG(LOG_APP, "[GetPortInfos] --exit, actualCount=%{public}zu", actualCount);
    return result;
}

// Open a MIDI device
static napi_value OpenDevice(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    OH_LOG_INFO(LOG_APP, "[OpenDevice] ++enter, deviceId=%{public}lld", (long long)deviceId);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    if (g_midiClient == nullptr) {
        OH_LOG_ERROR(LOG_APP, "[OpenDevice] client is null");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_CLIENT), &result);
        return result;
    }

    OH_MIDIDevice *device = nullptr;
    OH_LOG_DEBUG(LOG_APP, "[OpenDevice] calling OH_MIDIClient_OpenDevice");
    OH_MIDIStatusCode status = OH_MIDIClient_OpenDevice(g_midiClient, deviceId, &device);
    OH_LOG_INFO(LOG_APP, "[OpenDevice] OH_MIDIClient_OpenDevice returned status=%{public}d", (int)status);

    if (status == OH_MIDI_STATUS_OK && device != nullptr) {
        g_openedDevices[deviceId] = device;
        OH_LOG_INFO(LOG_APP, "[OpenDevice] device stored, total opened devices=%{public}zu", g_openedDevices.size());
    }

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_INFO(LOG_APP, "[OpenDevice] --exit, status=%{public}d", (int)status);
    return result;
}

// Helper: Cleanup input port contexts for a specific device
static void CleanupInputPortContextsForDevice(int64_t deviceId)
{
    OH_LOG_DEBUG(LOG_APP, "[CleanupInputPortContextsForDevice] cleaning up for device %{public}lld",
                 (long long)deviceId);
    for (auto ctxIt = g_inputPortContexts.begin(); ctxIt != g_inputPortContexts.end();) {
        if (ctxIt->first.first == deviceId) {
            if (ctxIt->second != nullptr) {
                ctxIt->second->Stop();
            }
            ctxIt = g_inputPortContexts.erase(ctxIt);
        } else {
            ++ctxIt;
        }
    }
}

// Helper: Parse MIDI events from JS array
static bool ParseMIDIEventsFromArray(napi_env env, napi_value jsArray,
    std::vector<OH_MIDIEvent>& events, std::vector<std::vector<uint32_t>>& eventDataBuffers)
{
    uint32_t eventCount = 0;
    napi_get_array_length(env, jsArray, &eventCount);
    OH_LOG_DEBUG(LOG_APP, "[ParseMIDIEventsFromArray] eventCount=%{public}u", eventCount);

    events.resize(eventCount);
    eventDataBuffers.resize(eventCount);

    for (uint32_t i = 0; i < eventCount; i++) {
        napi_value eventObj;
        napi_get_element(env, jsArray, i, &eventObj);

        napi_value timestampValue;
        napi_get_named_property(env, eventObj, "timestamp", &timestampValue);
        bool lossless = false;
        napi_get_value_bigint_uint64(env, timestampValue, &events[i].timestamp, &lossless);

        napi_value dataValue;
        napi_get_named_property(env, eventObj, "data", &dataValue);

        uint32_t dataLength = 0;
        napi_get_array_length(env, dataValue, &dataLength);

        events[i].length = dataLength;
        eventDataBuffers[i].resize(dataLength);

        for (uint32_t j = 0; j < dataLength; j++) {
            napi_value elem;
            napi_get_element(env, dataValue, j, &elem);
            napi_get_value_uint32(env, elem, &eventDataBuffers[i][j]);
        }
        events[i].data = eventDataBuffers[i].data();
    }
    return true;
}

// Close a MIDI device
static napi_value CloseDevice(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    OH_LOG_INFO(LOG_APP, "[CloseDevice] ++enter, deviceId=%{public}lld", (long long)deviceId);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    if (g_midiClient == nullptr) {
        OH_LOG_ERROR(LOG_APP, "[CloseDevice] client is null");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_CLIENT), &result);
        return result;
    }

    auto it = g_openedDevices.find(deviceId);
    if (it != g_openedDevices.end()) {
        // 清理该设备的所有InputPortContext（共享缓存模式）
        CleanupInputPortContextsForDevice(deviceId);

        OH_LOG_DEBUG(LOG_APP, "[CloseDevice] calling OH_MIDIClient_CloseDevice");
        OH_MIDIStatusCode status = OH_MIDIClient_CloseDevice(g_midiClient, it->second);
        OH_LOG_INFO(LOG_APP, "[CloseDevice] OH_MIDIClient_CloseDevice returned status=%{public}d", (int)status);
        g_openedDevices.erase(it);
        OH_LOG_INFO(LOG_APP, "[CloseDevice] device removed, remaining opened devices=%{public}zu",
            g_openedDevices.size());
        napi_create_int32(env, static_cast<int32_t>(status), &result);
    } else {
        OH_LOG_WARN(LOG_APP, "[CloseDevice] device not found in opened devices");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
    }

    OH_LOG_INFO(LOG_APP, "[CloseDevice] --exit");
    return result;
}

// MIDI data received callback - 优化版本：使用共享缓存，不再每次创建新线程
// 回调直接将数据写入环形缓冲区，由常驻线程处理
static void OnMIDIReceived(void *userData, const OH_MIDIEvent *events, size_t eventCount)
{
    // userData现在指向InputPortContext
    InputPortContext* context = static_cast<InputPortContext*>(userData);

    if (context == nullptr || events == nullptr || eventCount == 0) {
        return;
    }

    // 快速写入环形缓冲区（无锁操作），回调立即返回
    context->PushEventBatch(events, eventCount);
}

// Helper struct for input port arguments
struct InputPortArgs {
    int64_t deviceId;
    uint32_t portIndex;
    int32_t protocol;
    napi_value callbackValue;
};

// Helper: Parse input port arguments
static InputPortArgs ParseInputPortArgs(napi_env env, napi_callback_info info)
{
    InputPortArgs args = {0, 0, static_cast<int32_t>(MIDI_PROTOCOL_1_0), nullptr};
    size_t argc = 4;
    napi_value argv[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    napi_get_value_int64(env, argv[0], &args.deviceId);
    napi_get_value_uint32(env, argv[1], &args.portIndex);
    if (argc > MIDI_ARG_INDEX_2 && argv[MIDI_ARG_INDEX_2] != nullptr) {
        napi_get_value_int32(env, argv[MIDI_ARG_INDEX_2], &args.protocol);
    }
    if (argc > MIDI_ARG_INDEX_3 && argv[MIDI_ARG_INDEX_3] != nullptr) {
        args.callbackValue = argv[MIDI_ARG_INDEX_3];
    }
    return args;
}

// Open input port with callback
static napi_value OpenInputPort(napi_env env, napi_callback_info info)
{
    InputPortArgs args = ParseInputPortArgs(env, info);
    OH_LOG_INFO(LOG_APP, "[OpenInputPort] deviceId=%{public}lld, portIndex=%{public}u, protocol=%{public}d",
                (long long)args.deviceId, args.portIndex, args.protocol);

    std::lock_guard<std::mutex> lock(g_midiMutex);
    napi_value result;
    auto it = g_openedDevices.find(args.deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[OpenInputPort] client is null or device not opened");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_MIDIPortDescriptor descriptor = {args.portIndex, static_cast<OH_MIDIProtocol>(args.protocol)};
    auto key = std::make_pair(args.deviceId, args.portIndex);
    auto existingIt = g_inputPortContexts.find(key);
    if (existingIt != g_inputPortContexts.end()) {
        existingIt->second->Stop();
        g_inputPortContexts.erase(existingIt);
    }

    auto context = std::make_shared<InputPortContext>(args.deviceId, args.portIndex);
    OH_MIDIStatusCode status = OH_MIDIDevice_OpenInputPort(it->second, descriptor, OnMIDIReceived, context.get());
    OH_LOG_INFO(LOG_APP, "[OpenInputPort] OpenInputPort returned status=%{public}d", (int)status);

    if (status == OH_MIDI_STATUS_OK && args.callbackValue != nullptr) {
        napi_valuetype valueType;
        napi_typeof(env, args.callbackValue, &valueType);
        if (valueType == napi_function && !context->Start(env, args.callbackValue)) {
            OH_MIDIDevice_CloseInputPort(it->second, args.portIndex);
            status = OH_MIDI_STATUS_INVALID_DEVICE_HANDLE;
        } else if (valueType == napi_function) {
            g_inputPortContexts[key] = context;
        }
    }

    napi_create_int32(env, static_cast<int32_t>(status), &result);
    return result;
}

// Close input port
static napi_value CloseInputPort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    uint32_t portIndex = 0;
    napi_get_value_uint32(env, args[1], &portIndex);

    OH_LOG_INFO(LOG_APP, "[CloseInputPort] ++enter, deviceId=%{public}lld, portIndex=%{public}u",
                (long long)deviceId, portIndex);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[CloseInputPort] client is null or device not opened");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_LOG_DEBUG(LOG_APP, "[CloseInputPort] calling OH_MIDIDevice_CloseInputPort");
    OH_MIDIStatusCode status = OH_MIDIDevice_CloseInputPort(it->second, portIndex);
    OH_LOG_INFO(LOG_APP, "[CloseInputPort] OH_MIDIDevice_CloseInputPort returned status=%{public}d", (int)status);

    // Clean up input port context (共享缓存模式)
    auto key = std::make_pair(deviceId, portIndex);
    auto contextIt = g_inputPortContexts.find(key);
    if (contextIt != g_inputPortContexts.end()) {
        OH_LOG_DEBUG(LOG_APP, "[CloseInputPort] stopping context");
        if (contextIt->second != nullptr) {
            contextIt->second->Stop();
        }
        g_inputPortContexts.erase(contextIt);
        OH_LOG_INFO(LOG_APP, "[CloseInputPort] context removed, remaining contexts=%{public}zu",
                    g_inputPortContexts.size());
    }

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_INFO(LOG_APP, "[CloseInputPort] --exit, status=%{public}d", (int)status);
    return result;
}

// Open output port
static napi_value OpenOutputPort(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    uint32_t portIndex = 0;
    napi_get_value_uint32(env, args[1], &portIndex);

    int32_t protocol = static_cast<int32_t>(MIDI_PROTOCOL_1_0); // Default to MIDI 1.0
    napi_get_value_int32(env, args[MIDI_ARG_INDEX_2], &protocol);

    OH_LOG_INFO(LOG_APP, "[OpenOutputPort] ++enter, deviceId=%{public}lld, portIndex=%{public}u, protocol=%{public}d",
                (long long)deviceId, portIndex, protocol);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[OpenOutputPort] client is null or device not opened");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_MIDIPortDescriptor descriptor;
    descriptor.portIndex = portIndex;
    descriptor.protocol = static_cast<OH_MIDIProtocol>(protocol);

    OH_LOG_DEBUG(LOG_APP, "[OpenOutputPort] calling OH_MIDIDevice_OpenOutputPort");
    OH_MIDIStatusCode status = OH_MIDIDevice_OpenOutputPort(it->second, descriptor);
    OH_LOG_INFO(LOG_APP, "[OpenOutputPort] OH_MIDIDevice_OpenOutputPort returned status=%{public}d", (int)status);

    // Store protocol info for this output port
    if (status == OH_MIDI_STATUS_OK) {
        auto key = std::make_pair(deviceId, portIndex);
        g_outputPortProtocols[key] = static_cast<OH_MIDIProtocol>(protocol);
        OH_LOG_INFO(LOG_APP,
            "[OpenOutputPort] stored protocol=%{public}d for deviceId=%{public}lld, portIndex=%{public}u",
            protocol, (long long)deviceId, portIndex);
    }

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_INFO(LOG_APP, "[OpenOutputPort] --exit, status=%{public}d", (int)status);
    return result;
}

// Close output port
static napi_value CloseOutputPort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    uint32_t portIndex = 0;
    napi_get_value_uint32(env, args[1], &portIndex);

    OH_LOG_INFO(LOG_APP, "[CloseOutputPort] ++enter, deviceId=%{public}lld, portIndex=%{public}u",
                (long long)deviceId, portIndex);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[CloseOutputPort] client is null or device not opened");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_LOG_DEBUG(LOG_APP, "[CloseOutputPort] calling OH_MIDIDevice_CloseOutputPort");
    OH_MIDIStatusCode status = OH_MIDIDevice_CloseOutputPort(it->second, portIndex);
    OH_LOG_INFO(LOG_APP, "[CloseOutputPort] OH_MIDIDevice_CloseOutputPort returned status=%{public}d", (int)status);

    // Remove protocol info for this output port
    if (status == OH_MIDI_STATUS_OK) {
        auto key = std::make_pair(deviceId, portIndex);
        g_outputPortProtocols.erase(key);
        OH_LOG_INFO(LOG_APP, "[CloseOutputPort] removed protocol info for deviceId=%{public}lld, portIndex=%{public}u",
                    (long long)deviceId, portIndex);
    }

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_INFO(LOG_APP, "[CloseOutputPort] --exit, status=%{public}d", (int)status);
    return result;
}

// Send MIDI data
static napi_value SendMIDI(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);
    uint32_t portIndex = 0;
    napi_get_value_uint32(env, args[1], &portIndex);

    OH_LOG_DEBUG(LOG_APP, "[SendMIDI] deviceId=%{public}lld, portIndex=%{public}u", (long long)deviceId, portIndex);

    bool isArray = false;
    napi_is_array(env, args[MIDI_ARG_INDEX_2], &isArray);
    if (!isArray) {
        napi_value result;
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_GENERIC_INVALID_ARGUMENT), &result);
        return result;
    }

    std::vector<OH_MIDIEvent> events;
    std::vector<std::vector<uint32_t>> eventDataBuffers;
    ParseMIDIEventsFromArray(env, args[MIDI_ARG_INDEX_2], events, eventDataBuffers);
    uint32_t eventCount = static_cast<uint32_t>(events.size());

    std::lock_guard<std::mutex> lock(g_midiMutex);
    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    uint32_t eventsWritten = 0;
    OH_MIDIStatusCode status = OH_MIDIDevice_Send(it->second, portIndex, events.data(), eventCount, &eventsWritten);

    napi_create_object(env, &result);
    napi_value statusValue;
    napi_create_int32(env, static_cast<int32_t>(status), &statusValue);
    napi_set_named_property(env, result, "status", statusValue);
    napi_value writtenValue;
    napi_create_uint32(env, eventsWritten, &writtenValue);
    napi_set_named_property(env, result, "eventsWritten", writtenValue);
    return result;
}

// ============================================================================
// UMP Helper functions for MIDI 1.0 and MIDI 2.0 protocol support
// ============================================================================

// Build MIDI 2.0 Note On UMP (64-bit, 2 words)
static void BuildMIDI2NoteOn(uint32_t channel, uint32_t note, uint32_t velocity, uint32_t* umpData)
{
    // MIDI 2.0 Note On: MT=0x4, Group=0x0, Status=0x9, Channel, Note, Attribute Type=0x00
    // Word 0: (0x4 << 28) | (0x0 << 24) | (status << 20) | (channel << 16) | (note << 8) | 0x00
    // Word 1: (velocity16 << 16) | 0x0000
    uint16_t velocity16 = static_cast<uint16_t>((velocity * MIDI_VELOCITY_SCALE) / MIDI_MAX_VELOCITY);
    umpData[0] = (MIDI_UMP_MT_2_0 << MIDI_UMP_WORDS_28) | (0x0 << MIDI_UMP_SHIFT_24) |
                 (MIDI_UMP_STATUS_NOTE_ON << MIDI_UMP_SHIFT_20) |
                 ((channel & MIDI_CHANNEL_MASK) << MIDI_UMP_WORDS_16) |
                 ((note & MIDI_NOTE_MASK) << MIDI_UMP_SHIFT_8) | 0x00;
    umpData[1] = (static_cast<uint32_t>(velocity16) << MIDI_UMP_WORDS_16) | 0x0000;
}

// Build MIDI 2.0 Note Off UMP (64-bit, 2 words)
static void BuildMIDI2NoteOff(uint32_t channel, uint32_t note, uint32_t velocity, uint32_t* umpData)
{
    // MIDI 2.0 Note Off: MT=0x4, Group=0x0, Status=0x8, Channel, Note, Attribute Type=0x00
    // Word 0: (0x4 << 28) | (0x0 << 24) | (status << 20) | (channel << 16) | (note << 8) | 0x00
    // Word 1: (velocity16 << 16) | 0x0000
    uint16_t velocity16 = static_cast<uint16_t>((velocity * MIDI_VELOCITY_SCALE) / MIDI_MAX_VELOCITY);
    umpData[0] = (MIDI_UMP_MT_2_0 << MIDI_UMP_WORDS_28) | (0x0 << MIDI_UMP_SHIFT_24) |
                 (MIDI_UMP_STATUS_NOTE_OFF << MIDI_UMP_SHIFT_20) |
                 ((channel & MIDI_CHANNEL_MASK) << MIDI_UMP_WORDS_16) |
                 ((note & MIDI_NOTE_MASK) << MIDI_UMP_SHIFT_8) | 0x00;
    umpData[1] = (static_cast<uint32_t>(velocity16) << MIDI_UMP_WORDS_16) | 0x0000;
}

// Build MIDI 1.0 Note On UMP (32-bit, 1 word)
static void BuildMIDI1NoteOn(uint32_t channel, uint32_t note, uint32_t velocity, uint32_t* umpData)
{
    // UMP format: MT[31-28]=0x2, Group[27-24]=0x0, Status[23-20]=0x9
    // Channel[19-16], Data1[15-8]=note, Data2[7-0]=velocity
    umpData[0] = (MIDI_UMP_MT_1_0 << MIDI_UMP_WORDS_28) | (0x0 << MIDI_UMP_SHIFT_24) |
                 (MIDI_UMP_STATUS_NOTE_ON << MIDI_UMP_SHIFT_20) |
                 ((channel & MIDI_CHANNEL_MASK) << MIDI_UMP_WORDS_16) |
                 ((note & MIDI_NOTE_MASK) << MIDI_UMP_SHIFT_8) | (velocity & MIDI_NOTE_MASK);
}

// Build MIDI 1.0 Note Off UMP (32-bit, 1 word)
static void BuildMIDI1NoteOff(uint32_t channel, uint32_t note, uint32_t velocity, uint32_t* umpData)
{
    // UMP format: MT[31-28]=0x2, Group[27-24]=0x0, Status[23-20]=0x8
    // Channel[19-16], Data1[15-8]=note, Data2[7-0]=velocity
    umpData[0] = (MIDI_UMP_MT_1_0 << MIDI_UMP_WORDS_28) | (0x0 << MIDI_UMP_SHIFT_24) |
                 (MIDI_UMP_STATUS_NOTE_OFF << MIDI_UMP_SHIFT_20) |
                 ((channel & MIDI_CHANNEL_MASK) << MIDI_UMP_WORDS_16) |
                 ((note & MIDI_NOTE_MASK) << MIDI_UMP_SHIFT_8) | (velocity & MIDI_NOTE_MASK);
}

// Get output port protocol (returns MIDI_PROTOCOL_1_0 by default if not found)
static OH_MIDIProtocol GetOutputPortProtocol(int64_t deviceId, uint32_t portIndex)
{
    auto key = std::make_pair(deviceId, portIndex);
    auto it = g_outputPortProtocols.find(key);
    if (it != g_outputPortProtocols.end()) {
        return it->second;
    }
    return OH_MIDI_PROTOCOL_1_0; // Default to MIDI 1.0
}

// Helper: Parse note message args (deviceId, portIndex, channel, note, velocity)
struct NoteMessageArgs {
    int64_t deviceId;
    uint32_t portIndex;
    uint32_t channel;
    uint32_t note;
    uint32_t velocity;
};

static NoteMessageArgs ParseNoteMessageArgs(napi_env env, napi_callback_info info)
{
    NoteMessageArgs args = {0, 0, 0, 0, 0};
    size_t argc = 5;
    napi_value argv[5] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    napi_get_value_int64(env, argv[0], &args.deviceId);
    napi_get_value_uint32(env, argv[1], &args.portIndex);
    napi_get_value_uint32(env, argv[MIDI_ARG_INDEX_2], &args.channel);
    napi_get_value_uint32(env, argv[MIDI_ARG_INDEX_3], &args.note);
    napi_get_value_uint32(env, argv[MIDI_ARG_INDEX_4], &args.velocity);
    return args;
}

// Helper: Send note message (internal implementation)
static napi_value SendNoteMessage(napi_env env, int64_t deviceId, uint32_t portIndex,
    uint32_t channel, uint32_t note, uint32_t velocity, bool isNoteOn)
{
    const char* funcName = isNoteOn ? "SendNoteOn" : "SendNoteOff";
    OH_LOG_DEBUG(LOG_APP,
        "[%{public}s] dev=%{public}lld, port=%{public}u, ch=%{public}u, note=%{public}u, vel=%{public}u",
        funcName, (long long)deviceId, portIndex, channel, note, velocity);

    std::lock_guard<std::mutex> lock(g_midiMutex);
    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[%{public}s] client is null or device not opened", funcName);
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_MIDIProtocol protocol = GetOutputPortProtocol(deviceId, portIndex);
    uint32_t umpData[MIDI_DATA_WORDS_2];
    OH_MIDIEvent event;
    event.timestamp = 0;
    event.data = umpData;

    if (protocol == OH_MIDI_PROTOCOL_2_0) {
        if (isNoteOn) {
            BuildMIDI2NoteOn(channel, note, velocity, umpData);
        } else {
            BuildMIDI2NoteOff(channel, note, velocity, umpData);
        }
        event.length = MIDI_EVENT_LENGTH_2;
    } else {
        if (isNoteOn) {
            BuildMIDI1NoteOn(channel, note, velocity, umpData);
        } else {
            BuildMIDI1NoteOff(channel, note, velocity, umpData);
        }
        event.length = MIDI_EVENT_LENGTH_1;
    }

    uint32_t eventsWritten = 0;
    OH_MIDIStatusCode status = OH_MIDIDevice_Send(it->second, portIndex, &event, 1, &eventsWritten);
    napi_create_int32(env, static_cast<int32_t>(status), &result);
    return result;
}

// Send Note On message (helper function for testing)
static napi_value SendNoteOn(napi_env env, napi_callback_info info)
{
    NoteMessageArgs args = ParseNoteMessageArgs(env, info);
    return SendNoteMessage(env, args.deviceId, args.portIndex, args.channel, args.note, args.velocity, true);
}

// Send Note Off message (helper function for testing)
static napi_value SendNoteOff(napi_env env, napi_callback_info info)
{
    NoteMessageArgs args = ParseNoteMessageArgs(env, info);
    return SendNoteMessage(env, args.deviceId, args.portIndex, args.channel, args.note, args.velocity, false);
}

// Flush output port
static napi_value FlushOutputPort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int64_t deviceId = 0;
    napi_get_value_int64(env, args[0], &deviceId);

    uint32_t portIndex = 0;
    napi_get_value_uint32(env, args[1], &portIndex);

    OH_LOG_DEBUG(LOG_APP, "[FlushOutputPort] ++enter, deviceId=%{public}lld, portIndex=%{public}u",
                 (long long)deviceId, portIndex);

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    auto it = g_openedDevices.find(deviceId);
    if (g_midiClient == nullptr || it == g_openedDevices.end()) {
        OH_LOG_ERROR(LOG_APP, "[FlushOutputPort] client is null or device not opened");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_DEVICE_HANDLE), &result);
        return result;
    }

    OH_MIDIStatusCode status = OH_MIDIDevice_FlushOutputPort(it->second, portIndex);
    OH_LOG_DEBUG(LOG_APP, "[FlushOutputPort] OH_MIDIDevice_FlushOutputPort returned status=%{public}d", (int)status);

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_DEBUG(LOG_APP, "[FlushOutputPort] --exit, status=%{public}d", (int)status);
    return result;
}

// BLE raw data structure for async processing
struct BleRawData {
    std::string deviceAddress;
    bool opened;
    OH_MIDIDevice* device;
    int64_t deviceId;
    int32_t deviceType;
    int32_t nativeProtocol;
    std::string deviceName;
    uint64_t vendorId;
    uint64_t productId;
};

// Helper: Create threadsafe function for BLE device callback
static napi_threadsafe_function CreateBLEThreadsafeFunction(napi_env env, napi_value callbackValue,
    const std::string& deviceAddr)
{
    napi_valuetype valueType;
    napi_typeof(env, callbackValue, &valueType);
    if (valueType != napi_function) {
        return nullptr;
    }

    // Delete old callback if exists
    auto oldCallback = g_bleOpenCallbacks.find(deviceAddr);
    if (oldCallback != g_bleOpenCallbacks.end() && oldCallback->second.tsfn != nullptr) {
        OH_LOG_DEBUG(LOG_APP, "[CreateBLEThreadsafeFunction] releasing old threadsafe function");
        napi_release_threadsafe_function(oldCallback->second.tsfn, napi_tsfn_release);
    }

    // Create threadsafe function for this BLE device
    napi_value resourceName;
    std::string resourceNameStr = "BleOpenedCallback_" + deviceAddr;
    napi_create_string_utf8(env, resourceNameStr.c_str(), NAPI_AUTO_LENGTH, &resourceName);

    napi_threadsafe_function tsfn = nullptr;
    napi_status tsfnStatus = napi_create_threadsafe_function(env, callbackValue, nullptr, resourceName, 0,
        1, nullptr, nullptr, nullptr, CallJsBleOpened, &tsfn);

    if (tsfn != nullptr) {
        BLEOpenCallbackInfo callbackInfo;
        callbackInfo.deviceAddress = deviceAddr;
        callbackInfo.tsfn = tsfn;
        g_bleOpenCallbacks[deviceAddr] = callbackInfo;
        OH_LOG_INFO(LOG_APP, "[CreateBLEThreadsafeFunction] threadsafe function stored, total=%{public}zu",
                    g_bleOpenCallbacks.size());
    } else {
        OH_LOG_ERROR(LOG_APP, "[CreateBLEThreadsafeFunction] failed: %{public}d", (int)tsfnStatus);
    }
    return tsfn;
}

// Helper: Process BLE device opened in worker thread
static void BleWorkerThreadFunc(BleRawData* rawData)
{
    OH_LOG_DEBUG(LOG_APP, "[BleWorkerThread] addr=%{public}s, opened=%{public}d",
                 rawData->deviceAddress.c_str(), rawData->opened ? 1 : 0);

    napi_threadsafe_function tsfn = nullptr;
    {
        std::lock_guard<std::mutex> lock(g_midiMutex);
        if (rawData->opened && rawData->device != nullptr) {
            g_openedDevices[rawData->deviceId] = rawData->device;
        }
        auto it = g_bleOpenCallbacks.find(rawData->deviceAddress);
        if (it != g_bleOpenCallbacks.end()) {
            tsfn = it->second.tsfn;
            g_bleOpenCallbacks.erase(it);
        }
    }

    if (tsfn == nullptr) {
        OH_LOG_WARN(LOG_APP, "[BleWorkerThread] no callback for %{public}s", rawData->deviceAddress.c_str());
        delete rawData;
        return;
    }

    BleOpenedCallbackData* callbackData = new BleOpenedCallbackData();
    callbackData->opened = rawData->opened;
    callbackData->deviceId = rawData->deviceId;
    callbackData->deviceType = rawData->deviceType;
    callbackData->nativeProtocol = rawData->nativeProtocol;
    callbackData->deviceName = rawData->deviceName;
    callbackData->deviceAddress = rawData->deviceAddress;
    callbackData->vendorId = rawData->vendorId;
    callbackData->productId = rawData->productId;
    delete rawData;

    napi_status status = napi_call_threadsafe_function(tsfn, callbackData, napi_tsfn_nonblocking);
    if (status != napi_ok) {
        delete callbackData;
    }
    napi_release_threadsafe_function(tsfn, napi_tsfn_release);
}

// BLE device open callback - spawn async thread for processing
// All heavy work (locking, data copy, JS callback) happens in worker thread
static void OnBLEDeviceOpened(void *userData, bool opened, OH_MIDIDevice *device, OH_MIDIDeviceInformation info)
{
    std::string deviceAddr = info.deviceAddress;
    OH_LOG_INFO(LOG_APP, "[OnBLEDeviceOpened] ++enter (callback thread), addr=%{public}s, opened=%{public}d",
                deviceAddr.c_str(), opened ? 1 : 0);

    // Copy necessary data in callback thread (quick operation)
    BleRawData* rawData = new BleRawData();
    rawData->deviceAddress = deviceAddr;
    rawData->opened = opened;
    rawData->device = device;
    rawData->deviceId = info.midiDeviceId;
    rawData->deviceType = static_cast<int32_t>(info.deviceType);
    rawData->nativeProtocol = static_cast<int32_t>(info.nativeProtocol);
    rawData->deviceName = info.deviceName;
    rawData->vendorId = info.vendorId;
    rawData->productId = info.productId;

    // Spawn worker thread for all heavy operations
    std::thread workerThread(BleWorkerThreadFunc, rawData);
    workerThread.detach();

    OH_LOG_INFO(LOG_APP, "[OnBLEDeviceOpened] --exit (callback thread, worker spawned)");
}

// Open BLE device asynchronously
static napi_value OpenBLEDevice(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // Get device address
    size_t addrLen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &addrLen);
    std::string deviceAddr(addrLen, '\0');
    napi_get_value_string_utf8(env, args[0], &deviceAddr[0], addrLen + 1, &addrLen);

    OH_LOG_INFO(LOG_APP, "[OpenBLEDevice] ++enter, address=%{public}s", deviceAddr.c_str());

    // Get callback function
    napi_value callbackValue = nullptr;
    if (argc > 1 && args[1] != nullptr) {
        callbackValue = args[1];
    }

    std::lock_guard<std::mutex> lock(g_midiMutex);

    napi_value result;
    if (g_midiClient == nullptr) {
        OH_LOG_ERROR(LOG_APP, "[OpenBLEDevice] client is null");
        napi_create_int32(env, static_cast<int32_t>(OH_MIDI_STATUS_INVALID_CLIENT), &result);
        return result;
    }

    // Create threadsafe function if callback provided
    if (callbackValue != nullptr) {
        CreateBLEThreadsafeFunction(env, callbackValue, deviceAddr);
    }

    OH_LOG_DEBUG(LOG_APP, "[OpenBLEDevice] calling OH_MIDIClient_OpenBLEDevice");
    OH_MIDIStatusCode status = OH_MIDIClient_OpenBLEDevice(g_midiClient, deviceAddr.c_str(),
                                                           OnBLEDeviceOpened, nullptr);

    OH_LOG_INFO(LOG_APP, "[OpenBLEDevice] OH_MIDIClient_OpenBLEDevice returned status=%{public}d", (int)status);

    napi_create_int32(env, static_cast<int32_t>(status), &result);

    OH_LOG_INFO(LOG_APP, "[OpenBLEDevice] --exit, status=%{public}d", (int)status);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    OH_LOG_INFO(LOG_APP, "[Init] ++enter, registering MIDI module");

    napi_property_descriptor desc[] = {
        { "createMIDIClient", nullptr, CreateMIDIClient, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "destroyMIDIClient", nullptr, DestroyMIDIClient, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getDeviceCount", nullptr, GetDeviceCount, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getDeviceInfos", nullptr, GetDeviceInfos, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getPortCount", nullptr, GetPortCount, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getPortInfos", nullptr, GetPortInfos, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "openDevice", nullptr, OpenDevice, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "closeDevice", nullptr, CloseDevice, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "openInputPort", nullptr, OpenInputPort, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "closeInputPort", nullptr, CloseInputPort, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "openOutputPort", nullptr, OpenOutputPort, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "closeOutputPort", nullptr, CloseOutputPort, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "sendMIDI", nullptr, SendMIDI, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "sendNoteOn", nullptr, SendNoteOn, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "sendNoteOff", nullptr, SendNoteOff, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "flushOutputPort", nullptr, FlushOutputPort, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "openBLEDevice", nullptr, OpenBLEDevice, nullptr, nullptr, nullptr, napi_default, nullptr },
    };

    size_t descCount = sizeof(desc) / sizeof(desc[0]);
    napi_define_properties(env, exports, descCount, desc);

    OH_LOG_INFO(LOG_APP, "[Init] --exit, registered %{public}zu functions", descCount);
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
    OH_LOG_INFO(LOG_APP, "[RegisterEntryModule] ++enter");
    napi_module_register(&demoModule);
    OH_LOG_INFO(LOG_APP, "[RegisterEntryModule] --exit, module registered");
}
