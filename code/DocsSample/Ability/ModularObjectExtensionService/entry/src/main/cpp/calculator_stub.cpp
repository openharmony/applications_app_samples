/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start modular_object_extension_stub_impl]
#include "calculator_stub.h"
// [StartExclude modular_object_extension_stub_impl]

#include <AbilityKit/ability_runtime/modular_object_extension_context.h>
#include <cstdlib>
#include <cstring>

static constexpr const int32_t MAX_TOKEN_LENGTH = 256;

static void *OhipcReadInterfaceTokenAllocator(int32_t len)
{
    if (len <= 0 || len > MAX_TOKEN_LENGTH) {
        return nullptr;
    }
    return malloc(len);
}
// [EndExclude modular_object_extension_stub_impl]

CalculatorStub::CalculatorStub(OH_AbilityRuntime_ModObjExtensionContextHandle context)
    : context_(context), remoteStub_(OH_AbilityRuntime_ModObjExtensionContext_CreateIPCRemoteStub(
        context, ICalculator::GetDescriptor(), &CalculatorStub::OnRemoteRequest, nullptr, this)) {}

CalculatorStub::~CalculatorStub()
{
    if (remoteStub_ != nullptr) {
        OH_AbilityRuntime_ModObjExtensionContext_DestroyIPCRemoteStub(context_, remoteStub_);
        remoteStub_ = nullptr;
    }
}

int32_t CalculatorStub::OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData)
{
    // [StartExclude modular_object_extension_stub_impl]
    if (userData == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    auto *stub = static_cast<CalculatorStub *>(userData);
    // 验证接口描述符并分发请求
    if (data == nullptr || reply == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    char *remoteDescriptor = nullptr;
    int32_t remoteDescriptorLen = 0;
    if (OH_IPCParcel_ReadInterfaceToken(data, &remoteDescriptor, &remoteDescriptorLen,
                                        OhipcReadInterfaceTokenAllocator) != OH_IPC_SUCCESS) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    if (remoteDescriptor == nullptr || std::strcmp(remoteDescriptor, ICalculator::GetDescriptor()) != 0) {
        if (remoteDescriptor != nullptr) {
            free(remoteDescriptor);
        }
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    free(remoteDescriptor);
    // [EndExclude modular_object_extension_stub_impl]

    // 分发请求
    switch (static_cast<ICalculator::IpcCode>(code)) {
        case ICalculator::IpcCode::COMMAND_ADD:
            return stub->HandleAdd(data, reply);
        default:
            return OH_IPC_CHECK_PARAM_ERROR;
    }
}

int32_t CalculatorStub::HandleAdd(const OHIPCParcel *data, OHIPCParcel *reply)
{
    // 读取入参
    int32_t a = 0;
    if (OH_IPCParcel_ReadInt32(data, &a) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    int32_t b = 0;
    if (OH_IPCParcel_ReadInt32(data, &b) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    int32_t result;
    // 调用业务函数
    ErrCode errCode = Add(a, b, result);
    // 写入errCode和result
    if (OH_IPCParcel_WriteInt32(reply, errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    if (OH_IPCParcel_WriteInt32(reply, result) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }

    return OH_IPC_SUCCESS;
}

ErrCode CalculatorStub::Add(int32_t a, int32_t b, int32_t &result)
{
    // 业务逻辑实现
    result = a + b;
    return OH_IPC_SUCCESS;
}
// [End modular_object_extension_stub_impl]
