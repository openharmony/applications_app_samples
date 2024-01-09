/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#include <cstdio>
#include <locale>
#include <string>
#include <cstring>
#include "log.h"
#include "napi_util.h"

const int32_t MAX_STR_LENGTH = 2048;

napi_value NapiUtil::SetNapiCallInt32(const napi_env &env, const int32_t intValue)
{
    napi_value result;
    napi_create_int32(env, intValue, &result);
    return result;
}

napi_value NapiUtil::SetNapiCallBool(napi_env env, bool value)
{
    napi_value temp;
    napi_value result;
    napi_create_int32(env, value == true ? 1 : 0, &temp);
    napi_coerce_to_bool(env, temp, &result);
    return result;
}

int NapiUtil::StringToInt(std::string value) { return atoi(value.c_str()); }

int NapiUtil::StringToLong(std::string value) { return atol(value.c_str()); }

float NapiUtil::StringToFloat(std::string value) { return std::stof(value); }

bool NapiUtil::StringToBool(const std::string value) { return value == "true" ? true : false; }
