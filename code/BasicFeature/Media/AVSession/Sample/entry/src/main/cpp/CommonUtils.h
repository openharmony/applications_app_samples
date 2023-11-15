//
// Created on 2023/11/10.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef AVCastDemo_CommonUtils_H
#define AVCastDemo_CommonUtils_H

#include "hello.h"
#include "napi/native_api.h"
#include <js_native_api_types.h>
#include <string>

class CommonUtils {
public:
    static std::string GetStringArgument(napi_env env, napi_value value);
};

#endif //AVCastDemo_CommonUtils_H
