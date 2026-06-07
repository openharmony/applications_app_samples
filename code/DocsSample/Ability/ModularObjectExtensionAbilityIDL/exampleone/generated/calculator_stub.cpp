#include <cstdlib>
#include <cstring>
#include <unistd.h>

#include "calculator_stub.h"

static const int MAX_BUFFER_SIZE = 10 * 1024 * 10; // 示例代码限制100KB
static void* OhipcReadInterfaceTokenAllocator(int32_t len)
{
    if (len <= 0 || len > MAX_BUFFER_SIZE) {
        return nullptr;
    }
    return malloc(len);
}

static const char* TYPE_LIB_INFO =
    "{\"version\":\"1.0\",\"taihe_version\":\"1.0.0\","
    "\"enums\":[],\"structs\":[],\"interfaces\":["
    "{\"memberId\":1,\"name\":\"ICalculator\","
    "\"descriptor\":\"OHOS.IPC.ICalculator\","
    "\"interface_type\":1,\"methods\":["
    "{\"memberId\":4,\"name\":\"Add\",\"code\":1001,"
    "\"oneway\":false,\"return_type\":{\"type\":\"i32\"},"
    "\"parameters\":["
    "{\"memberId\":2,\"name\":\"a\","
    "\"type_info\":{\"type\":\"i32\"}},"
    "{\"memberId\":3,\"name\":\"b\","
    "\"type_info\":{\"type\":\"i32\"}}]}]}]}";

namespace OHOS {
namespace IPC {

CalculatorStub::CalculatorStub(OH_AbilityRuntime_ModObjExtensionContextHandle context)
    : context_(context),
      remoteStub_(OH_AbilityRuntime_ModObjExtensionContext_CreateIPCRemoteStub(
          context,
          ICalculator::GetDescriptor(),
          &CalculatorStub::OnRemoteRequest,
          nullptr,
          this))
{
}

CalculatorStub::~CalculatorStub()
{
    if (remoteStub_ != nullptr) {
        OH_AbilityRuntime_ModObjExtensionContext_DestroyIPCRemoteStub(context_, remoteStub_);
        remoteStub_ = nullptr;
    }
}

ErrCode CalculatorStub::WriteRemoteObject(OHIPCParcel* parcel) const
{
    if (parcel == nullptr || remoteStub_ == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    if (OH_IPCParcel_WriteRemoteStub(parcel, remoteStub_) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    return OH_IPC_SUCCESS;
}

int32_t CalculatorStub::OnRemoteRequest(uint32_t code, const OHIPCParcel* data, OHIPCParcel* reply, void* userData)
{
    if (userData == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    auto* stub = static_cast<CalculatorStub*>(userData);
    return stub->OnRemoteRequestInner(code, data, reply);
}
// [Start CalculatorStub]
int32_t CalculatorStub::OnRemoteRequestInner(uint32_t code, const OHIPCParcel* data, OHIPCParcel* reply)
{
// [StartExclude CalculatorStub]
    if (data == nullptr || reply == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    char* remoteDescriptor = nullptr;
    int32_t remoteDescriptorLen = 0;
// [EndExclude CalculatorStub]
    if (OH_IPCParcel_ReadInterfaceToken(data, &remoteDescriptor,
        &remoteDescriptorLen, OhipcReadInterfaceTokenAllocator) != OH_IPC_SUCCESS) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
// [StartExclude CalculatorStub]
    if (remoteDescriptor == nullptr ||
        std::strcmp(remoteDescriptor, ICalculator::GetDescriptor()) != 0) {
        if (remoteDescriptor != nullptr) {
            free(remoteDescriptor);
        }
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    free(remoteDescriptor);
// [EndExclude CalculatorStub]
    switch (static_cast<ICalculator::IpcCode>(code)) {
        case ICalculator::IpcCode::COMMAND_ADD:
            return HandleAdd(data, reply);
// [StartExclude CalculatorStub]
        case ICalculator::IpcCode::COMMAND_GET_TYPE_LIB_INFO:
            return HandleGetTypeLibInfo(data, reply);
        case ICalculator::IpcCode::COMMAND_GET_VERSION:
            return HandleGetVersion(data, reply);
        case ICalculator::IpcCode::COMMAND_GET_TAIHE_VERSION:
            return HandleGetTaiheVersion(data, reply);
// [EndExclude CalculatorStub]
        default:
            return OH_IPC_CHECK_PARAM_ERROR;
    }
}

int32_t CalculatorStub::HandleAdd(const OHIPCParcel* data, OHIPCParcel* reply)
{
    int32_t aValue = 0;
    if (OH_IPCParcel_ReadInt32(data, &aValue) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    int32_t a = aValue;
// [StartExclude CalculatorStub]
    int32_t bValue = 0;
    if (OH_IPCParcel_ReadInt32(data, &bValue) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    int32_t b = bValue;
// [EndExclude CalculatorStub]
    int32_t result = 0;
    ErrCode errCode = Add(a, b, result);
    if (OH_IPCParcel_WriteInt32(reply, errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }

    if (OH_IPCParcel_WriteInt32(reply, result) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }

    return OH_IPC_SUCCESS;
}
// [End CalculatorStub]
int32_t CalculatorStub::HandleGetTypeLibInfo(const OHIPCParcel* data, OHIPCParcel* reply)
{
    int32_t fd = 0;
    if (OH_IPCParcel_ReadFileDescriptor(data, &fd) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }

    ErrCode errCode = GetTypeLibInfo(fd);
    if (OH_IPCParcel_WriteInt32(reply, errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    return OH_IPC_SUCCESS;
}

int32_t CalculatorStub::HandleGetVersion(const OHIPCParcel* data, OHIPCParcel* reply)
{
    std::string result;
    ErrCode errCode = GetVersion(result);
    if (OH_IPCParcel_WriteInt32(reply, errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }

    if (OH_IPCParcel_WriteString(reply, result.c_str()) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    return OH_IPC_SUCCESS;
}

int32_t CalculatorStub::HandleGetTaiheVersion(const OHIPCParcel* data, OHIPCParcel* reply)
{
    std::string result;
    ErrCode errCode = GetTaiheVersion(result);
    if (OH_IPCParcel_WriteInt32(reply, errCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }

    if (OH_IPCParcel_WriteString(reply, result.c_str()) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    return OH_IPC_SUCCESS;
}

ErrCode CalculatorStub::GetTypeLibInfo(int32_t fd)
{
    if (TYPE_LIB_INFO == nullptr || strlen(TYPE_LIB_INFO) == 0) {
        close(fd);
        return OH_IPC_INNER_ERROR;
    }

    int32_t ret = write(fd, TYPE_LIB_INFO, strlen(TYPE_LIB_INFO));
    close(fd);

    return ret >= 0 ? OH_IPC_SUCCESS : OH_IPC_INNER_ERROR;
}

ErrCode CalculatorStub::GetVersion(std::string& result)
{
    result = "1.0.0";
    return OH_IPC_SUCCESS;
}

ErrCode CalculatorStub::GetTaiheVersion(std::string& result)
{
    result = "1.0.0";
    return OH_IPC_SUCCESS;
}

} // namespace IPC
} // namespace OHOS
