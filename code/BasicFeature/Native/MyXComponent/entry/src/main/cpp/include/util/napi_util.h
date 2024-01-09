/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef NAPI_UTIL_H
#define NAPI_UTIL_H

#include <string>
#include <napi/native_api.h>
#include "native_common.h"

class NapiUtil {
public:
    static void JsValueToString(const napi_env &env, const napi_value &value, const int32_t bufLen,
                                std::string &target);
    static napi_value SetNapiCallInt32(const napi_env &env, const int32_t intValue);
    static napi_value SetNapiCallBool(const napi_env env, bool value);
    static int StringToInt(std::string value);
    static int StringToLong(std::string value);
    static float StringToFloat(std::string value);
    static bool StringToBool(std::string value);
};

#endif // NAPI_UTIL_H
