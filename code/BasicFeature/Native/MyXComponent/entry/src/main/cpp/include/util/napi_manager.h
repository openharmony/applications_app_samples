/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef NAPI_MANAGER_H
#define NAPI_MANAGER_H

#include <string>
#include <unordered_map>

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>
#include <uv.h>

#include "native_common.h"
#include "app_napi.h"

class NapiManager {
public:
    ~NapiManager() {}

    static NapiManager *GetInstance() { return &NapiManager::manager_; }

    static napi_value GetContext(napi_env env, napi_callback_info info);

    /**APP Lifecycle**/
    static napi_value NapiOnCreate(napi_env env, napi_callback_info info);
    static napi_value NapiOnShow(napi_env env, napi_callback_info info);
    static napi_value NapiOnHide(napi_env env, napi_callback_info info);
    static napi_value NapiOnDestroy(napi_env env, napi_callback_info info);

    void OnCreateNative(napi_env env, uv_loop_t *loop);
    void OnShowNative();
    void OnHideNative();
    void OnDestroyNative();

    /**JS Page Lifecycle**/
    static napi_value NapiOnPageShow(napi_env env, napi_callback_info info);
    static napi_value NapiOnPageHide(napi_env env, napi_callback_info info);

    void OnPageShowNative();
    void OnPageHideNative();

    OH_NativeXComponent *GetNativeXComponent(std::string &id);
    void SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent);
    AppNapi *GetApp(std::string &id);

public:
    // Napi export
    bool Export(napi_env env, napi_value exports);

public:
    napi_env mainEnv_ = nullptr;
    uv_loop_t *mainLoop_ = nullptr;
    uv_async_t mainOnMessageSignal_{};

private:
    static void MainOnMessage(const uv_async_t *req);
    static NapiManager manager_;

    std::string id_;
    std::unordered_map<std::string, OH_NativeXComponent *> nativeXComponentMap_;
    std::unordered_map<std::string, AppNapi *> appNapiMap_;
};

#endif // PLUGIN_MANAGER_H
