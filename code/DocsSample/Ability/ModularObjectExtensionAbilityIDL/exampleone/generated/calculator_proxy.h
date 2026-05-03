#ifndef OHOS_IPC_CALCULATOR_PROXY_H
#define OHOS_IPC_CALCULATOR_PROXY_H

#include "icalculator.h"

namespace OHOS {
namespace IPC {
// [Start CalculatorProxy]
class CalculatorProxy : public ICalculator {
public:
    explicit CalculatorProxy(OHIPCRemoteProxy* remote) : remoteProxy_(remote) {}
    ~CalculatorProxy() override = default;
// [StartExclude CalculatorProxy]
    OHIPCRemoteProxy* GetRemoteProxy() const
    {
        return remoteProxy_;
    }
// [EndExclude CalculatorProxy]
    ErrCode WriteRemoteObject(OHIPCParcel* parcel) const override;

    ErrCode Add(int32_t a, int32_t b, int32_t& result) override;
// [StartExclude CalculatorProxy]
    ErrCode GetTypeLibInfo(int32_t fd) override;
    ErrCode GetVersion(std::string& result) override;
    ErrCode GetTaiheVersion(std::string& result) override;
// [EndExclude CalculatorProxy]
private:
    OHIPCRemoteProxy* remoteProxy_ = nullptr;
};
// [End CalculatorProxy]
} // namespace IPC
} // namespace OHOS

#endif // OHOS_IPC_CALCULATOR_PROXY_H
