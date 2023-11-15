//
// Created on 2023/11/10.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "session.h"
#include "hello.h"
#include "CommonUtils.h"

static __thread napi_ref sConstructor_ = nullptr;

Session::Session() { SLOGI("Seeion::~Session()"); }

napi_value Session::Constructor(napi_env env, mapi_callback_info info) {
    napi_value undefineVar = nullptr, thisVar
}