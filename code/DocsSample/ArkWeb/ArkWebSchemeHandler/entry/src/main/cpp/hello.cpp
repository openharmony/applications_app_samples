#include "hilog/log.h"
#include "napi/native_api.h"
#include "rawfile_request.h"
#include "rawfile/raw_file_manager.h"
#include "web/arkweb_scheme_handler.h"
#include "web/arkweb_net_error_list.h"

#undef LOG_TAG
#define LOG_TAG "ss-handler"

ArkWeb_SchemeHandler *g_schemeHandler;
ArkWeb_SchemeHandler *g_schemeHandlerForSW;
NativeResourceManager *g_resourceManager;

// 注册三方协议的配置，需要在Web内核初始化之前调用，否则会注册失败。
static napi_value RegisterCustomSchemes(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "register custom schemes");
    OH_ArkWeb_RegisterCustomSchemes("custom", ARKWEB_SCHEME_OPTION_STANDARD | ARKWEB_SCHEME_OPTION_CORS_ENABLED);
    OH_ArkWeb_RegisterCustomSchemes("custom-local", ARKWEB_SCHEME_OPTION_LOCAL);
    OH_ArkWeb_RegisterCustomSchemes("custom-csp-bypassing", ARKWEB_SCHEME_OPTION_CSP_BYPASSING | ARKWEB_SCHEME_OPTION_STANDARD);
    OH_ArkWeb_RegisterCustomSchemes("custom-isolated", ARKWEB_SCHEME_OPTION_DISPLAY_ISOLATED);
    return nullptr;
}

// 请求开始的回调，在该函数中我们创建一个RawfileRequest来实现对Web内核请求的拦截。
void OnURLRequestStart(const ArkWeb_SchemeHandler *schemeHandler,
                       ArkWeb_ResourceRequest *resourceRequest,
                       const ArkWeb_ResourceHandler *resourceHandler,
                       bool *intercept)
{
    *intercept = true;
    RawfileRequest* request = new RawfileRequest(resourceRequest, resourceHandler, g_resourceManager);
    OH_ArkWebResourceRequest_SetUserData(resourceRequest, request);
    request->Start();
}

// 请求结束的回调，在该函数中我们需要标记RawfileRequest已经结束了，内部不应该再使用ResourceHandler。
void OnURLRequestStop(const ArkWeb_SchemeHandler *schemeHandler,
                      const ArkWeb_ResourceRequest *request)
{
    if (!request) {
        OH_LOG_ERROR(LOG_APP, "on request stop request is nullptr.");
        return;
    }

    RawfileRequest *rawfileRequest = (RawfileRequest *)OH_ArkWebResourceRequest_GetUserData(request);
    if (rawfileRequest) {
        rawfileRequest->Stop();
    }
}

void OnURLRequestStartForSW(const ArkWeb_SchemeHandler *schemeHandler,
                            ArkWeb_ResourceRequest *resourceRequest,
                            const ArkWeb_ResourceHandler *resourceHandler,
                            bool *intercept)
{
    *intercept = true;
    RawfileRequest* request = new RawfileRequest(resourceRequest, resourceHandler, g_resourceManager);
    OH_ArkWebResourceRequest_SetUserData(resourceRequest, request);
    request->Start();
}

void OnURLRequestStopForSW(const ArkWeb_SchemeHandler *schemeHandler,
                           const ArkWeb_ResourceRequest *request)
{
    if (!request) {
        OH_LOG_ERROR(LOG_APP, "on request stop request is nullptr.");
        return;
    }

    RawfileRequest *rawfileRequest = (RawfileRequest *)OH_ArkWebResourceRequest_GetUserData(request);
    if (rawfileRequest) {
        rawfileRequest->Stop();
    }
}

// 设置SchemeHandler。
static napi_value SetSchemeHandler(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "set scheme handler");
    OH_ArkWeb_CreateSchemeHandler(&g_schemeHandler);
    OH_ArkWeb_CreateSchemeHandler(&g_schemeHandlerForSW);

    OH_ArkWebSchemeHandler_SetOnRequestStart(g_schemeHandler, OnURLRequestStart);
    OH_ArkWebSchemeHandler_SetOnRequestStop(g_schemeHandler, OnURLRequestStop);

    OH_ArkWebSchemeHandler_SetOnRequestStart(g_schemeHandlerForSW, OnURLRequestStart);
    OH_ArkWebSchemeHandler_SetOnRequestStop(g_schemeHandlerForSW, OnURLRequestStop);

    OH_ArkWeb_SetSchemeHandler("custom", "scheme-handler", g_schemeHandler);
    OH_ArkWeb_SetSchemeHandler("custom-csp-bypassing", "scheme-handler", g_schemeHandler);
    OH_ArkWeb_SetSchemeHandler("custom-isolated", "scheme-handler", g_schemeHandler);
    OH_ArkWeb_SetSchemeHandler("custom-local", "scheme-handler", g_schemeHandler);
    OH_ArkWeb_SetSchemeHandler("https", "scheme-handler", g_schemeHandler);
    OH_ArkWeb_SetSchemeHandler("http", "scheme-handler", g_schemeHandler);

    OH_ArkWebServiceWorker_SetSchemeHandler("https", g_schemeHandlerForSW);
    return nullptr;
}

static napi_value InitResourceManager(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    g_resourceManager = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"setSchemeHandler", nullptr, SetSchemeHandler, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"initResourceManager", nullptr, InitResourceManager, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerCustomSchemes", nullptr, RegisterCustomSchemes, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
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
    napi_module_register(&demoModule);
}