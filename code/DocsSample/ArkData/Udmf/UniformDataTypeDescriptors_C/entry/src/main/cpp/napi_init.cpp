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

// [Start import_module]
#include <cstdio>
#include <cstring>
#include <database/udmf/utd.h>
#include <database/udmf/uds.h>
#include <database/udmf/udmf.h>
#include <database/udmf/udmf_meta.h>
#include <database/udmf/udmf_err_code.h>
#include <hilog/log.h>

#undef LOG_TAG
#define LOG_TAG "MY_LOG"
// [End import_module]

static napi_value NAPI_Global_getTypesAndCompare(napi_env env, napi_callback_info info)
{
    // [Start uniform_data_type_descriptors_c]
    // 1. 通过文件后缀名获取纯文本类型的UTD的typeId
    unsigned int typeIds1Count = 0;
    const char **typeIds1 = OH_Utd_GetTypesByFilenameExtension(".txt", &typeIds1Count);
    OH_LOG_INFO(LOG_APP, "the count of typeIds1 is %{public}u", typeIds1Count);
    // 2. 通过MIME类型获取typeId
    unsigned int typeIds2Count = 0;
    const char **typeIds2 = OH_Utd_GetTypesByMimeType("text/plain", &typeIds2Count);
    OH_LOG_INFO(LOG_APP, "the count of typeIds2 is %{public}u", typeIds2Count);
    // 3. 使用以上两个步骤获取到的typeId创建UTD实例对象。
    OH_Utd *utd1 = OH_Utd_Create(typeIds1[0]);
    OH_Utd *utd2 = OH_Utd_Create(typeIds2[0]);
    // 4. 比较两种方式获取到的typeId对应的UTD是否相同
    bool isEquals = OH_Utd_Equals(utd1, utd2);
    if (isEquals) {
        OH_LOG_INFO(LOG_APP, "utd1 == utd2");
    } else {
        OH_LOG_INFO(LOG_APP, "utd1 != utd2");
    }
    // 5. 比较两种方式获取到的typeId是否存在归属关系
    bool isBelongsTo = OH_Utd_BelongsTo(typeIds1[0], typeIds2[0]);
    if (isBelongsTo) {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] belongs to typeIds2[0]");
    } else {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] don't belongs to typeIds2[0]");
    }
    // 6. 比较两种方式获取到的typeIds1[0]是否是typeIds2[0]的低层级类型
    bool isLower = OH_Utd_IsLower(typeIds1[0], typeIds2[0]);
    if (isLower) {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] is lower typeIds2[0]");
    } else {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] is not lower typeIds2[0]");
    }
    // 7. 比较两种方式获取到的typeIds1[0]是否是typeIds2[0]的高层级类型
    bool isHigher = OH_Utd_IsHigher(typeIds1[0], typeIds2[0]);
    if (isHigher) {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] is higher typeIds2[0]");
    } else {
        OH_LOG_INFO(LOG_APP, "typeIds1[0] is not higher typeIds2[0]");
    }
    // 8. 销毁OH_Utd_GetTypesByFilenameExtension与OH_Utd_GetTypesByMimeType函数获取到的指针，同时销毁UTD指针
    OH_Utd_DestroyStringList(typeIds1, typeIds1Count);
    OH_Utd_DestroyStringList(typeIds2, typeIds2Count);
    OH_Utd_Destroy(utd1);
    OH_Utd_Destroy(utd2);
    // [End uniform_data_type_descriptors_c]
    napi_value result;
    napi_create_int32(env, Udmf_ErrCode::UDMF_E_OK, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {{"getTypesAndCompare", nullptr, NAPI_Global_getTypesAndCompare, nullptr, nullptr,
                                        nullptr, napi_default, nullptr }};
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
