/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start query_key_alias_set_cpp]
/* 以下查询密钥别名集为例 */
#include "huks/native_huks_api.h"
#include "huks/native_huks_param.h"
#include "napi/native_api.h"
#include <string.h>

OH_Huks_Result InitParamSet(
   struct OH_Huks_ParamSet **paramSet,
   const struct OH_Huks_Param *params,
   uint32_t paramCount)
{
   OH_Huks_Result ret = OH_Huks_InitParamSet(paramSet);
   if (ret.errorCode != OH_HUKS_SUCCESS) {
       return ret;
   }
   ret = OH_Huks_AddParams(*paramSet, params, paramCount);
   if (ret.errorCode != OH_HUKS_SUCCESS) {
       OH_Huks_FreeParamSet(paramSet);
       return ret;
   }
   ret = OH_Huks_BuildParamSet(paramSet);
   if (ret.errorCode != OH_HUKS_SUCCESS) {
       OH_Huks_FreeParamSet(paramSet);
       return ret;
   }
   return ret;
}

struct OH_Huks_Param g_testQueryParam[] = {
   {
       .tag = OH_HUKS_TAG_AUTH_STORAGE_LEVEL,
       .uint32Param = OH_HUKS_AUTH_STORAGE_LEVEL_DE
   }, 
};

static napi_value ListAliases(napi_env env, napi_callback_info info)
{
   struct OH_Huks_ParamSet *testQueryParamSet = nullptr;
   struct OH_Huks_KeyAliasSet *outData = nullptr;
   struct OH_Huks_Result ohResult;
   do {
       /* 1.初始化密钥属性集 */
       ohResult = InitParamSet(&testQueryParamSet, g_testQueryParam,
           sizeof(g_testQueryParam) / sizeof(OH_Huks_Param));
       if (ohResult.errorCode != OH_HUKS_SUCCESS) {
           break;
       }
       /* 2.查询密钥别名集 */
       ohResult = OH_Huks_ListAliases(testQueryParamSet, &outData);
   } while (0);

   OH_Huks_FreeParamSet(&testQueryParamSet);
   OH_Huks_FreeKeyAliasSet(outData);
   napi_value ret;
   napi_create_int32(env, ohResult.errorCode, &ret);
   return ret;
}
// [Start query_key_alias_set_cpp]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "listAliases", nullptr, ListAliases, nullptr, nullptr, nullptr, napi_default, nullptr }
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
