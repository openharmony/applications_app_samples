/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#include "log.h"
#include "napi_manager.h"
#include "app_napi.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * function for module exports
 */
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    LOGE("Init");
    napi_property_descriptor desc[] = {DECLARE_NAPI_FUNCTION("GetContext", NapiManager::GetContext),
                                       DECLARE_NAPI_STATIC_FUNCTION("Animate", AppNapi::Animate),
                                       DECLARE_NAPI_STATIC_FUNCTION("ChangeShape", AppNapi::ChangeShape)};

    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));

    bool ret = NapiManager::GetInstance()->Export(env, exports);
    if (!ret) {
        LOGE("Init failed");
    }

    return exports;
}
EXTERN_C_END

/*
 * Napi Module define
 */
static napi_module appNapiModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "cube",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

/*
 * Module register function
 */
extern "C" __attribute__((constructor)) void RegisterModule(void) { napi_module_register(&appNapiModule); }

#ifdef __cplusplus
}
#endif