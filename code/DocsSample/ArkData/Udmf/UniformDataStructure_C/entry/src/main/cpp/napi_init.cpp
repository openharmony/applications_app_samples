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

#include <database/udmf/udmf_err_code.h>

// [Start import_module]
#include <database/udmf/uds.h>
#include <database/udmf/udmf.h>
#include <database/udmf/udmf_meta.h>
#include <hilog/log.h>

#undef LOG_TAG
#define LOG_TAG "MY_LOG"
// [End import_module]

static napi_value NAPI_Global_geiPlainText(napi_env env, napi_callback_info info)
{
    // [Start use_plaintext_datastructure]
    // 1.创建PlainText对象指针
    OH_UdmfRecord *plainTextRecord = OH_UdmfRecord_Create();
    OH_UdsPlainText *plainText = OH_UdsPlainText_Create();
    char content[] = "hello world";

    // 2.添加PlainText内容
    OH_UdsPlainText_SetContent(plainText, content);
    OH_UdmfRecord_AddPlainText(plainTextRecord, plainText);

    // 3.获取PlainText数据
    OH_UdsPlainText *plainText2 = OH_UdsPlainText_Create();
    OH_UdmfRecord_GetPlainText(plainTextRecord, plainText2);
    const char *content2 = OH_UdsPlainText_GetContent(plainText2);

    OH_LOG_INFO(LOG_APP, "content = %{public}s.", content2);
    // 4.使用完成后销毁指针。
    OH_UdsPlainText_Destroy(plainText);
    OH_UdmfRecord_Destroy(plainTextRecord);
    OH_UdsPlainText_Destroy(plainText2);
    // [End use_plaintext_datastructure]
    napi_value result;
    napi_create_int32(env, Udmf_ErrCode::UDMF_E_OK, &result);
    return result;
}

static napi_value NAPI_Global_getFileUri(napi_env env, napi_callback_info info)
{
    // [Start use_fileUri_datastructure]
    // 1.创建fileUri类型的数据结构
    const char *uri = "https://xxx/xx/xx.jpg";
    OH_UdsFileUri *fileUri = OH_UdsFileUri_Create();
    // 2. 设置fileUri中的URL和描述信息。
    OH_UdsFileUri_SetFileUri(fileUri, uri);
    OH_UdsFileUri_SetFileType(fileUri, UDMF_META_IMAGE);
    // 3. 创建OH_UdmfRecord对象，并向OH_UdmfRecord中添加fileUri类型数据。
    OH_UdmfRecord *record = OH_UdmfRecord_Create();
    OH_UdmfRecord_AddFileUri(record, fileUri);
    // 4. 获取fileUri数据。
    OH_UdsFileUri *fileUri1 = OH_UdsFileUri_Create();
    OH_UdmfRecord_GetFileUri(record, fileUri1);
    const char *fileUriStr = OH_UdsFileUri_GetFileUri(fileUri1);
    OH_LOG_INFO(LOG_APP, "fileUri1 = %{public}s.", fileUriStr);
    // 5. 使用完成后销毁指针。
    OH_UdsFileUri_Destroy(fileUri);
    OH_UdmfRecord_Destroy(record);
    OH_UdsFileUri_Destroy(fileUri1);
    // [End use_fileUri_datastructure]
    napi_value result;
    napi_create_int32(env, Udmf_ErrCode::UDMF_E_OK, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"geiPlainText", nullptr, NAPI_Global_geiPlainText, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getFileUri", nullptr, NAPI_Global_getFileUri, nullptr, nullptr, nullptr, napi_default, nullptr }};
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
