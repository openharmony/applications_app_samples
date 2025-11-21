#ifndef SIGN_VERIFY_H
#define SIGN_VERIFY_H

#include <node_api.h>

// 函数声明
napi_value SignVerifyKey(napi_env env, napi_callback_info info);
napi_value SignVerifyKeyECC(napi_env env, napi_callback_info info);
napi_value SignVerifyKeySM2SM3(napi_env env, napi_callback_info info);
napi_value SignVerifyKeySM2NoDigest(napi_env env, napi_callback_info info);
napi_value SignVerifyKeyRsaSha256Pss(napi_env env, napi_callback_info info);
napi_value SignVerifyKeyRsaSha256Pkcs1V15(napi_env env, napi_callback_info info);

#endif // SIGN_VERIFY_H