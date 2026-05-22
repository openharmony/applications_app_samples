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

// [Start modular_object_extension_proxy_impl]
#include "calculator_proxy.h"
// [StartExclude modular_object_extension_proxy_impl]
#include <memory>

namespace {
struct ParcelDeleter {
    void operator()(OHIPCParcel* parcel) const
    {
        if (parcel != nullptr) {
            OH_IPCParcel_Destroy(parcel);
        }
    }
};
} // namespace
// [EndExclude modular_object_extension_proxy_impl]

ErrCode CalculatorProxy::Add(int32_t a, int32_t b, int32_t& result)
{
    // [StartExclude modular_object_extension_proxy_impl]
    // 创建请求Parcel对象，写入接口描述符
    if (remote_ == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }

    std::unique_ptr<OHIPCParcel, ParcelDeleter> parcelData(OH_IPCParcel_Create());
    std::unique_ptr<OHIPCParcel, ParcelDeleter> parcelReply(OH_IPCParcel_Create());
    if (parcelData == nullptr || parcelReply == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }

    if (OH_IPCParcel_WriteInterfaceToken(parcelData.get(),
        ICalculator::GetDescriptor()) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    // [EndExclude modular_object_extension_proxy_impl]
    // 写入参数
    if (OH_IPCParcel_WriteInt32(parcelData.get(), a) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    if (OH_IPCParcel_WriteInt32(parcelData.get(), b) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    // 发送请求，等待服务端返回结果
    OH_IPC_MessageOption option = { OH_IPC_REQUEST_MODE_SYNC, 0 };
    int32_t transportErr = OH_IPCRemoteProxy_SendRequest(
        remote_,
        static_cast<uint32_t>(ICalculator::IpcCode::COMMAND_ADD),
        parcelData.get(),
        parcelReply.get(),
        &option);
    if (transportErr != OH_IPC_SUCCESS) {
        return transportErr;
    }

    // 读取服务端返回的结果
    int32_t errCode = OH_IPC_SUCCESS;
    if (OH_IPCParcel_ReadInt32(parcelReply.get(), &errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }

    int32_t resultValue = 0;
    if (OH_IPCParcel_ReadInt32(parcelReply.get(), &resultValue) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    result = resultValue;

    return errCode;
}
// [End modular_object_extension_proxy_impl]
