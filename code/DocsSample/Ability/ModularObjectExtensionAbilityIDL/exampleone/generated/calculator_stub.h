#ifndef OHOS_IPC_CALCULATOR_STUB_H
#define OHOS_IPC_CALCULATOR_STUB_H

#include <AbilityKit/ability_runtime/modular_object_extension_context.h>
#include "icalculator.h"

namespace OHOS {
namespace IPC {
// [Start CalculatorStub]
class CalculatorStub : public ICalculator {
public:
// [StartExclude CalculatorStub]
    explicit CalculatorStub(OH_AbilityRuntime_ModObjExtensionContextHandle context);
    ~CalculatorStub() override;

    OHIPCRemoteStub* GetRemoteStub() const
    {
        return remoteStub_;
    }
// [EndExclude CalculatorStub]
    ErrCode WriteRemoteObject(OHIPCParcel* parcel) const override;

    static int32_t OnRemoteRequest(
        uint32_t code,
        const OHIPCParcel* data,
        OHIPCParcel* reply,
        void* userData);
// [StartExclude CalculatorStub]
protected:
    ErrCode GetTypeLibInfo(int32_t fd) override;
    ErrCode GetVersion(std::string& result) override;
    ErrCode GetTaiheVersion(std::string& result) override;
// [EndExclude CalculatorStub]
private:
    int32_t OnRemoteRequestInner(uint32_t code, const OHIPCParcel* data, OHIPCParcel* reply);
    int32_t HandleAdd(const OHIPCParcel* data, OHIPCParcel* reply);
// [StartExclude CalculatorStub]
    int32_t HandleGetTypeLibInfo(const OHIPCParcel* data, OHIPCParcel* reply);
    int32_t HandleGetVersion(const OHIPCParcel* data, OHIPCParcel* reply);
    int32_t HandleGetTaiheVersion(const OHIPCParcel* data, OHIPCParcel* reply);

private:
    OHIPCRemoteStub* remoteStub_ = nullptr;
    OH_AbilityRuntime_ModObjExtensionContextHandle context_;
// [EndExclude CalculatorStub]
};
// [End CalculatorStub]
} // namespace IPC
} // namespace OHOS

#endif // OHOS_IPC_CALCULATOR_STUB_H
