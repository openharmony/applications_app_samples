//
// Created on 2025/10/17.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef UIEXTENSIONANDACCESSIBILITY_EMBEDDED_H
#define UIEXTENSIONANDACCESSIBILITY_EMBEDDED_H
#include "napi/native_api.h"

napi_value embeddedNode(napi_env env, napi_callback_info info);

#endif // UIEXTENSIONANDACCESSIBILITY_EMBEDDED_H
