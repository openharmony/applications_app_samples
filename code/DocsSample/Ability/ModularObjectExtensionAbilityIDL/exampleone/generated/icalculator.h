#ifndef OHOS_IPC_ICALCULATOR_H
#define OHOS_IPC_ICALCULATOR_H

#include <IPCKit/ipc_kit.h>

#include <array>
#include <cstdint>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <vector>

namespace OHOS {
namespace IPC {

using ErrCode = int32_t;
// [Start ICalculator]
class ICalculator {
public:
    virtual ~ICalculator() = default;
    static const char* GetDescriptor() { return "OHOS.IPC.ICalculator"; }

    virtual ErrCode WriteRemoteObject(OHIPCParcel* parcel) const = 0;

    enum class IpcCode : uint32_t {
        COMMAND_ADD = 1001,
        COMMAND_GET_TYPE_LIB_INFO = 1,
        COMMAND_GET_VERSION = 2,
        COMMAND_GET_TAIHE_VERSION = 3,
    };

    virtual ErrCode Add(int32_t a, int32_t b, int32_t& result) = 0;
    virtual ErrCode GetTypeLibInfo(int32_t fd) = 0;
    virtual ErrCode GetVersion(std::string& result) = 0;
    virtual ErrCode GetTaiheVersion(std::string& result) = 0;
};
// [End ICalculator]
} // namespace IPC
} // namespace OHOS

#endif // OHOS_IPC_ICALCULATOR_H
