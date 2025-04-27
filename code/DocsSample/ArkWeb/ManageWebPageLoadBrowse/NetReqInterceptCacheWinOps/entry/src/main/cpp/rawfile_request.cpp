/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 
// [Start intercepted_request_processing_cpp]
#include "rawfile_request.h"
#include "threads.h"

#include "hilog/log.h"
#include "rawfile/raw_file.h"
#include "rawfile/raw_file_manager.h"

#undef LOG_TAG
#define LOG_TAG "ss-handler"

namespace {

uint8_t g_buffer[1024];
cnd_t g_httpBodyCnd;
mtx_t g_httpBodyMtx;
const int HTTP_OK = 200;
const int HTTP_NOT_FOUND = 404;
const int BUFFER_SIZE = 1000;

// HttpBodyStream的读回调。
void ReadCallback(const ArkWeb_HttpBodyStream  *httpBodyStream, uint8_t* buffer, int bytesRead)
{
    OH_LOG_INFO(LOG_APP, "read http body back.");
    bool isEof = OH_ArkWebHttpBodyStream_IsEof(httpBodyStream);
    if (!isEof && bytesRead != 0) {
        memset(buffer, 0, BUFFER_SIZE);
        OH_ArkWebHttpBodyStream_Read(httpBodyStream, buffer, BUFFER_SIZE);
    } else {
        RawfileRequest *rawfileRequest = (RawfileRequest *)OH_ArkWebHttpBodyStream_GetUserData(httpBodyStream);
        if (rawfileRequest) {
            rawfileRequest->ReadRawfileDataOnWorkerThread();
            cnd_signal(&g_httpBodyCnd);
        }
    }
}

int ReadHttpBodyOnWorkerThread(void* userData)
{
    memset(g_buffer, 0, BUFFER_SIZE);
    ArkWeb_HttpBodyStream *httpBodyStream = (ArkWeb_HttpBodyStream *)userData;
    OH_ArkWebHttpBodyStream_Read(httpBodyStream, g_buffer, BUFFER_SIZE);
    int initResult = cnd_init(&g_httpBodyCnd);
    if (initResult == 0) {
        OH_LOG_INFO(LOG_APP, "cnd_init success.");
    } else {
        OH_LOG_INFO(LOG_APP, "cnd_init fail.");
    }
    int mtxResult = mtx_init(&g_httpBodyMtx, mtx_plain);
    if (mtxResult == 0) {
        OH_LOG_INFO(LOG_APP, "mtx_init success.");
    } else {
        OH_LOG_INFO(LOG_APP, "mtx_init fail.");
    }
    int waitResult = cnd_wait(&g_httpBodyCnd, &g_httpBodyMtx);
    if (waitResult == 0) {
        OH_LOG_INFO(LOG_APP, "cnd_wait success.");
    } else {
        OH_LOG_INFO(LOG_APP, "cnd_wait fail.");
    }
    return 0;
}

int ReadRawfileOnWorkerThread(void* userData)
{
    RawfileRequest* rawfileRequest = (RawfileRequest*)userData;
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

const int BLOCK_SIZE = 1024 * 8;
const int MAXWHILE = 100;

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
    // [Start get_intercepted_request_info]
    char* url;
    OH_ArkWebResourceRequest_GetUrl(resourceRequest_, &url);
    std::string urlStr(url);
    std::size_t position = urlStr.rfind('/');
    if (position != std::string::npos) {
        rawfilePath_ = urlStr.substr(position + 1);
    }
    OH_ArkWeb_ReleaseString(url);
    // [End get_intercepted_request_info]

    // [Start set_intercepted_request_response]
    // [StartExclude set_intercepted_request_response]
    OH_ArkWeb_CreateResponse(&response_);
    // [EndExclude set_intercepted_request_response]
    OH_ArkWebResourceRequest_GetHttpBodyStream(resourceRequest(), &stream_);
    if (stream_) {
        OH_LOG_ERROR(LOG_APP, "have http body stream");
        // [Start get_put_post_request_data]
        OH_ArkWebHttpBodyStream_SetUserData(stream_, this);
        OH_ArkWebHttpBodyStream_SetReadCallback(stream_, ReadCallback);
        OH_ArkWebHttpBodyStream_Init(stream_, InitCallback);
        // [End get_put_post_request_data]
    } else {
        thrd_t th;
        if (thrd_create(&th, ReadRawfileOnWorkerThread, static_cast<void*>(this)) != thrd_success) {
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

    RawFile *rawfile = OH_ResourceManager_OpenRawFile(resourceManager(), RawfilePath().c_str());
    // [StartExclude set_intercepted_request_response]
    if (!rawfile) {
        OH_ArkWebResponse_SetStatus(response(), HTTP_NOT_FOUND);
    } else {
        OH_ArkWebResponse_SetStatus(response(), HTTP_OK);
    }
    // [EndExclude set_intercepted_request_response]

    for (auto &urlInfo : urlInfos) {
        if (urlInfo.resource == RawfilePath()) {
            OH_ArkWebResponse_SetMimeType(response(), urlInfo.mimeType.c_str());
            break;
        }
    }
    // [StartExclude set_intercepted_request_response]
    OH_ArkWebResponse_SetCharset(response(), "UTF-8");
    // [EndExclude set_intercepted_request_response]

    long len = OH_ResourceManager_GetRawFileSize(rawfile);
    // [StartExclude set_intercepted_request_response]
    OH_ArkWebResponse_SetHeaderByName(response(), "content-length", std::to_string(len).c_str(), false);
    // EndExclude set_intercepted_request_response]
    DidReceiveResponse();

    long consumed = 0;
    uint8_t buffer[BLOCK_SIZE];
    int i = 0;
    while (++i < MAXWHILE) {
        int ret = OH_ResourceManager_ReadRawFile(rawfile, buffer, BLOCK_SIZE);
        if (ret > 0) {
            OH_LOG_INFO(LOG_APP, "read rawfile %{public}d bytes.", ret);
        } else if (ret == 0) {
            OH_LOG_INFO(LOG_APP, "read rawfile Reached end of file, %{public}d bytes read.", ret);
            break;
        } else {
            OH_LOG_ERROR(LOG_APP, "read rawfile Error, %{public}d bytes read.", ret);
            break;
        }
        consumed += ret;
        OH_ResourceManager_SeekRawFile(rawfile, consumed, 0);
        DidReceiveData(buffer, ret);
        memset(buffer, 0, BLOCK_SIZE);
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
        // [StartExclude set_intercepted_request_response]
        OH_ArkWebResourceHandler_DidReceiveResponse(resourceHandler_, response_);
        // [EndExclude set_intercepted_request_response]
    }
}

void RawfileRequest::DidReceiveData(const uint8_t *buffer, int64_t bufLen)
{
    OH_LOG_INFO(LOG_APP, "did receive data.");
    std::lock_guard<std::mutex> guard(mutex_);
    if (!stopped_) {
        // [StartExclude set_intercepted_request_response]
        OH_ArkWebResourceHandler_DidReceiveData(resourceHandler_, buffer, bufLen);
        // [EndExclude set_intercepted_request_response]
    }
}

void RawfileRequest::DidFinish()
{
    OH_LOG_INFO(LOG_APP, "did finish.");
    std::lock_guard<std::mutex> guard(mutex_);
    if (!stopped_) {
        // [StartExclude set_intercepted_request_response]
        OH_ArkWebResourceHandler_DidFinish(resourceHandler_);
        // [EndExclude set_intercepted_request_response]
        // [End set_intercepted_request_response]
    }
}

void RawfileRequest::DidFailWithError(ArkWeb_NetError errorCode)
{
    OH_LOG_INFO(LOG_APP, "did finish with error %{public}d.", errorCode);
    if (!stopped_) {
        OH_ArkWebResourceHandler_DidFailWithError(resourceHandler_, errorCode);
    }
}
// [End intercepted_request_processing_cpp]