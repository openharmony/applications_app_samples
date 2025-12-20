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

// [Start request_media_assets]
#include "napi/native_api.h"
#include "multimedia/media_library/media_asset_base_capi.h"
#include "multimedia/media_library/media_asset_manager_capi.h"
#include <cstdio>
#include <cstring>

const char ERROR_REQUEST_ID[UUID_STR_MAX_LENGTH] = "00000000-0000-0000-0000-000000000000";

// 资源请求回调
void OnDataPrepared(int32_t result, MediaLibrary_RequestId requestIdStruct)
{
    printf("OnDataPrepared requestId: %s result: %d\n", requestIdStruct.requestId, result);
}

// [StartExclude request_media_assets]
static napi_value GetBoolean(napi_env env, bool value)
{
    napi_value val;
    napi_get_boolean(env, value, &val);
    return val;
}
// [EndExclude request_media_assets]

static napi_value RequestMediaAssets(napi_env env, napi_callback_info info)
{
    // 创建MediaAssetManager实例
    OH_MediaAssetManager *manager = OH_MediaAssetManager_Create();
    if (manager == nullptr) {
        // 处理异常。
        printf("Get MediaAssetManager failed.\n");
        // [StartExclude request_media_assets]
        return GetBoolean(env, false);
        // [EndExclude request_media_assets]
    } else {
        // 设置资源请求回调
        OH_MediaLibrary_OnDataPrepared callback = OnDataPrepared;
        
        // 设置资源请求策略
        MediaLibrary_RequestOptions options;
        options.deliveryMode = MEDIA_LIBRARY_HIGH_QUALITY_MODE;

        // 预置图片资源Uri，默认为高质量图片。注：以下Uri是示例，开发者需根据实际情况创建或获取
        const char *srcUri = "file://media/Photo/87/VID_1712195295_025/request_image_src.jpg";

        // 提供目标路径Uri。注：以下Uri是示例，开发者需根据实际情况创建或获取
        const char *destUri = "file://media/Photo/9/IMG_1712195237_008/request_image_dest.jpg";

        // 将图片资源请求到目标路径
        MediaLibrary_RequestId requestIdStruct = OH_MediaAssetManager_RequestImageForPath(manager, srcUri,
            options, destUri, callback);
        if (strcmp(requestIdStruct.requestId, ERROR_REQUEST_ID) == 0) {
            // 处理异常
            printf("Request image failed requestId：%s\n", requestIdStruct.requestId);
            // [StartExclude request_media_assets]
            return GetBoolean(env, false);
            // [EndExclude request_media_assets]
        } else {
            // 请求成功，打印请求Id
            printf("Request image success, requestId: %s\n", requestIdStruct.requestId);

            // 调用CancelRequest接口，用来取消尚在处理中的请求
            // 注：OH_MediaAssetManager_CancelRequest不是必须流程，开发者可根据实际情况选择是否调用该接口来取消尚未回调返回的资源请求
            bool ret = OH_MediaAssetManager_CancelRequest(manager, requestIdStruct);
            // [StartExclude request_media_assets]
            return GetBoolean(env, true);
            // [EndExclude request_media_assets]
        }
    }
}
// [End request_media_assets]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
  napi_property_descriptor desc[] = {
      {"requestMediaAssets", nullptr, RequestMediaAssets, nullptr, nullptr,
       nullptr, napi_default, nullptr},
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
