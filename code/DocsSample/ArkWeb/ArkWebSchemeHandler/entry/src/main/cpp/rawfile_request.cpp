#include "rawfile_request.h"


#include "threads.h"


#include "hilog/log.h"
#include "rawfile/raw_file.h"
#include "rawfile/raw_file_manager.h"


#undef LOG_TAG
#define LOG_TAG "ss-handler"


namespace {


uint8_t buffer[1024];
cnd_t http_body_cnd;
mtx_t http_body_mtx;


// HttpBodyStream的读回调。
void ReadCallback(const ArkWeb_HttpBodyStream  *httpBodyStream, uint8_t* buffer, int bytesRead)
{
    OH_LOG_INFO(LOG_APP, "read http body back.");
    bool isEof = OH_ArkWebHttpBodyStream_IsEof(httpBodyStream);
    if (!isEof && bytesRead != 0) {
        memset(buffer, 0, 1000);
        OH_ArkWebHttpBodyStream_Read(httpBodyStream, buffer, 1000);
    } else {
        RawfileRequest *rawfileRequest = (RawfileRequest *)OH_ArkWebHttpBodyStream_GetUserData(httpBodyStream);
        if (rawfileRequest) {
            rawfileRequest->ReadRawfileDataOnWorkerThread();
            cnd_signal(&http_body_cnd);
        }
    }
}


int ReadHttpBodyOnWorkerThread(void* userData)
{
    memset(buffer, 0, 1000);
    ArkWeb_HttpBodyStream *httpBodyStream = (ArkWeb_HttpBodyStream *)userData;
    OH_ArkWebHttpBodyStream_Read(httpBodyStream, buffer, 1000);
    cnd_init(&http_body_cnd);
    mtx_init(&http_body_mtx, mtx_plain);
    cnd_wait(&http_body_cnd, &http_body_mtx);
    return 0;
}


int ReadRawfileOnWorkerThread(void* userData)
{
    RawfileRequest * rawfileRequest = (RawfileRequest *)userData;
    if (rawfileRequest) {
        rawfileRequest->ReadRawfileDataOnWorkerThread();
    }
    return 0;
}


// ArkWeb_HttpBodyStream的初始化回调。
void InitCallback(const ArkWeb_HttpBodyStream *httpBodyStream, ArkWeb_NetError result)
{
    OH_LOG_INFO(LOG_APP, "init http body stream done %{public}d.", result);
    bool isChunked = OH_ArkWebHttpBodyStream_IsChunked(httpBodyStream);
    OH_LOG_INFO(LOG_APP, "http body stream is chunked %{public}d.", isChunked);
    thrd_t th;
    if (thrd_create(&th, ReadHttpBodyOnWorkerThread, (void *)httpBodyStream) != thrd_success) {
        OH_LOG_ERROR(LOG_APP, "create thread failed.");
        return;
    }


    if (thrd_detach(th) != thrd_success) {
        OH_LOG_ERROR(LOG_APP, "detach thread failed.");
    }
}


const int blockSize = 1024 * 8;


}  // namespace


RawfileRequest::RawfileRequest(const ArkWeb_ResourceRequest *resourceRequest,
                               const ArkWeb_ResourceHandler *resourceHandler,
                               const NativeResourceManager* resourceManager)
        : resourceRequest_(resourceRequest),
          resourceHandler_(resourceHandler),
          resourceManager_(resourceManager) {}


RawfileRequest::~RawfileRequest() {}


void RawfileRequest::Start()
{
    OH_LOG_INFO(LOG_APP, "start a rawfile request.");
    char* url;
    OH_ArkWebResourceRequest_GetUrl(resourceRequest_, &url);
    std::string urlStr(url);
    std::size_t position = urlStr.rfind('/');
    if (position != std::string::npos) {
        rawfilePath_ = urlStr.substr(position + 1);
    }
    OH_ArkWeb_ReleaseString(url);


    OH_ArkWeb_CreateResponse(&response_);
    OH_ArkWebResourceRequest_GetHttpBodyStream(resourceRequest(), &stream_);
    if (stream_) {
        OH_LOG_ERROR(LOG_APP, "have http body stream");
        OH_ArkWebHttpBodyStream_SetUserData(stream_, this);
        OH_ArkWebHttpBodyStream_SetReadCallback(stream_, ReadCallback);
        OH_ArkWebHttpBodyStream_Init(stream_, InitCallback);
    } else {
        thrd_t th;
        if (thrd_create(&th, ReadRawfileOnWorkerThread, (void *)this) != thrd_success) {
            OH_LOG_ERROR(LOG_APP, "create thread failed.");
            return;
        }


        if (thrd_detach(th) != thrd_success) {
            OH_LOG_ERROR(LOG_APP, "detach thread failed.");
        }
    }
}


// 在worker线程中读取rawfile，并通过ResourceHandler返回给Web内核。
void RawfileRequest::ReadRawfileDataOnWorkerThread()
{
    OH_LOG_INFO(LOG_APP, "read rawfile in worker thread.");
    const struct UrlInfo {
        std::string resource;
        std::string mimeType;
    } urlInfos[] = {
        {"test.html", "text/html"},
        {"video.html", "text/html"},
        {"isolated.html", "text/html"},
        {"csp_bypassing.html", "text/html"},
        {"post_data.html", "text/html"},
        {"chunked_post_stream.html", "text/html"},
        {"local.html", "text/html"},
        {"service_worker.html", "text/html"},
        {"csp_script.js", "text/javascript"},
        {"sw.js", "text/javascript"},
        {"isolated_script.js", "text/javascript"},
        {"local_script.js", "text/javascript"},
        {"test.mp4", "video/mp4"},
        {"xhr", "application/json"}
    };


    if (!resourceManager()) {
        OH_LOG_ERROR(LOG_APP, "read rawfile error, resource manager is nullptr.");
        return;
    }


    RawFile *rawfile = OH_ResourceManager_OpenRawFile(resourceManager(), rawfilePath().c_str());
    if (!rawfile) {
        OH_ArkWebResponse_SetStatus(response(), 404);
    } else {
        OH_ArkWebResponse_SetStatus(response(), 200);
    }


    for (auto &urlInfo : urlInfos) {
        if (urlInfo.resource == rawfilePath()) {
            OH_ArkWebResponse_SetMimeType(response(), urlInfo.mimeType.c_str());
            break;
        }
    }
    OH_ArkWebResponse_SetCharset(response(), "UTF-8");


    long len = OH_ResourceManager_GetRawFileSize(rawfile);
    OH_ArkWebResponse_SetHeaderByName(response(), "content-length", std::to_string(len).c_str(), false);
    DidReceiveResponse();


    long consumed = 0;
    uint8_t buffer[blockSize];
    while (true) {
        int ret = OH_ResourceManager_ReadRawFile(rawfile, buffer, blockSize);
        OH_LOG_INFO(LOG_APP, "read rawfile %{public}d bytes.", ret);
        if (ret == 0) {
            break;
        }
        consumed += ret;
        OH_ResourceManager_SeekRawFile(rawfile, consumed, 0);
        DidReceiveData(buffer, ret);
        memset(buffer, 0, blockSize);
    }


    OH_ResourceManager_CloseRawFile(rawfile);
    DidFinish();
}


void RawfileRequest::Stop()
{
    OH_LOG_INFO(LOG_APP, "stop the rawfile request.");
    std::lock_guard<std::mutex> guard(mutex_);
    stopped_ = true;
    if (response_) {
        OH_ArkWeb_DestroyResponse(response_);
    }
    OH_ArkWebResourceRequest_Destroy(resourceRequest_);
    OH_ArkWebResourceHandler_Destroy(resourceHandler_);
}


void RawfileRequest::DidReceiveResponse()
{
    OH_LOG_INFO(LOG_APP, "did receive response.");
    std::lock_guard<std::mutex> guard(mutex_);
    if (!stopped_) {
        OH_ArkWebResourceHandler_DidReceiveResponse(resourceHandler_, response_);
    }
}


void RawfileRequest::DidReceiveData(const uint8_t *buffer, int64_t bufLen)
{
    OH_LOG_INFO(LOG_APP, "did receive data.");
    std::lock_guard<std::mutex> guard(mutex_);
    if (!stopped_) {
        OH_ArkWebResourceHandler_DidReceiveData(resourceHandler_, buffer, bufLen);
    }
}


void RawfileRequest::DidFinish()
{
    OH_LOG_INFO(LOG_APP, "did finish.");
    std::lock_guard<std::mutex> guard(mutex_);
    if (!stopped_) {
        OH_ArkWebResourceHandler_DidFinish(resourceHandler_);
    }
}


void RawfileRequest::DidFailWithError(ArkWeb_NetError errorCode)
{
    OH_LOG_INFO(LOG_APP, "did finish with error %{public}d.", errorCode);
    if (!stopped_) {
        OH_ArkWebResourceHandler_DidFailWithError(resourceHandler_, errorCode);
    }
}