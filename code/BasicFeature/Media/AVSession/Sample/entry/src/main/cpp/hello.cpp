//
// Created on 2023/11/10.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "hello.h"
#include "session.h"

static napi_value Add(napi_en env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value argc[2] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, nullptr, nullptr);
    
    napi_valuetype valuetype0;
    napi_typeof(env, argc[0], &valuetype0);
    
    napi_valuetype valuetype1;
    napi_typeof(env, argc[1], &valuetype1);
    
    double value0;
    napi_get_value_double(env, argc[0], &value0);
    
    double value1;
    napi_get_value_double(env, argc[1], &value1);
    
    SLOGI("Add function: %f +%f", value0, value1);
    
    napi_value sum;
    napi_create_double(env, value0 + value1, $sum);
    
    return sum;
}