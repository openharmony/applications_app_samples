#ifndef RAWFILE_REQUEST_H
#define RAWFILE_REQUEST_H


#include <mutex>
#include <string>


#include <rawfile/raw_file_manager.h>
#include "web/arkweb_scheme_handler.h"
#include "web/arkweb_net_error_list.h"


class RawfileRequest {
public:
    RawfileRequest(const ArkWeb_ResourceRequest *resourceRequest,
                   const ArkWeb_ResourceHandler *resourceHandler,
                   const NativeResourceManager* resourceManager);
    ~RawfileRequest();


    void Start();
    void Stop();
    void ReadRawfileDataOnWorkerThread();


    const ArkWeb_ResourceHandler *resourceHandler() { return resourceHandler_; }
    const ArkWeb_ResourceRequest *resourceRequest() { return resourceRequest_; }
    const NativeResourceManager *resourceManager() { return resourceManager_; }
    ArkWeb_Response *response() { return response_; }
    ArkWeb_HttpBodyStream *stream() { return stream_; }
    const std::string rawfilePath() { return rawfilePath_; }


    void DidReceiveResponse();
    void DidReceiveData(const uint8_t *buffer, int64_t bufLen);
    void DidFinish();
    void DidFailWithError(ArkWeb_NetError errorCode);


private:
    const ArkWeb_ResourceRequest *resourceRequest_{nullptr};
    const ArkWeb_ResourceHandler *resourceHandler_{nullptr};
    const NativeResourceManager *resourceManager_{nullptr};
    ArkWeb_Response *response_;
    bool stopped_{false};
    std::string rawfilePath_;
    ArkWeb_HttpBodyStream *stream_{nullptr};
    std::mutex mutex_;
};


#endif  // RAWFILE_REQUEST_H