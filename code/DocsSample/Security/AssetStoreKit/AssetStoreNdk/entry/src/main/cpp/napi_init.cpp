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

#include "napi/native_api.h"
#include <cstring>
#include "asset/asset_api.h"

static constexpr int INT_ARG_7 = 7; // 入参索引
static constexpr int INT_ARG_6 = 6; // 入参索引

static napi_value NAPI_Global_AddAsset(napi_env env, napi_callback_info info)
{
    static const char *secretContent = "demo_pwd";
    static const char *aliasContent = "demo_alias";
    static const char *labelContent = "demo_label";

    Asset_Blob secret = {(uint32_t)(strlen(secretContent)), (uint8_t *)secretContent};
    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};
    Asset_Blob label = {(uint32_t)(strlen(labelContent)), (uint8_t *)labelContent};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ACCESSIBILITY, .value.u32 = ASSET_ACCESSIBILITY_DEVICE_FIRST_UNLOCKED},
        {.tag = ASSET_TAG_SECRET, .value.blob = secret},
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
    };

    int32_t ret = OH_Asset_Add(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value result;
    if (ret == ASSET_SUCCESS) {
        // Asset added successfully.
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        // Failed to add Asset.
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    return result;
}

static napi_value RemoveAsset(napi_env env, napi_callback_info info)
{
    static const char *aliasContent = "demo_alias";
    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};

    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 此处指定别名删除，也可不指定别名删除多条数据
    };

    int32_t ret = OH_Asset_Remove(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value result;
    if (ret == ASSET_SUCCESS) {
        // Asset added successfully.
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        // Failed to add Asset.
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    return result;
}

static napi_value NAPI_Global_UpdateAsset(napi_env env, napi_callback_info info)
{
    static const char *aliasContent = "demo_alias";
    static const char *secretContent = "demo_pwd_new";
    static const char *labelContent = "demo_label_new";

    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};
    Asset_Blob new_secret = {(uint32_t)(strlen(secretContent)), (uint8_t *)secretContent};
    Asset_Blob new_label = {(uint32_t)(strlen(labelContent)), (uint8_t *)labelContent};
    Asset_Attr query[] = {{.tag = ASSET_TAG_ALIAS, .value.blob = alias}};
    Asset_Attr attributesToUpdate[] = {
        {.tag = ASSET_TAG_SECRET, .value.blob = new_secret},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = new_label},
    };

    int32_t ret = OH_Asset_Update(query, sizeof(query) / sizeof(query[0]), attributesToUpdate,
                                  sizeof(attributesToUpdate) / sizeof(attributesToUpdate[0]));
    napi_value result;
    if (ret == ASSET_SUCCESS) {
        // Asset added successfully.
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        // Failed to add Asset.
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    return result;
}

static napi_value NAPI_Global_QueryAsset(napi_env env, napi_callback_info info)
{
    static const char *aliasContent = "demo_alias";
    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了关键资产别名，最多查询到一条满足条件的关键资产
        {.tag = ASSET_TAG_RETURN_TYPE,
         .value.u32 = ASSET_RETURN_ALL}, // 此处表示需要返回关键资产的所有信息，即属性+明文
    };

    Asset_ResultSet resultSet = {0};
    napi_value result;
    int32_t ret = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (ret == ASSET_SUCCESS) {
        // Parse the resultSet.
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // Parse the secret: the data is secret->blob.data, the size is secret->blob.size.
            Asset_Attr *secret = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_SECRET);
        }
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    OH_Asset_FreeResultSet(&resultSet);
    return result;
}
static napi_value NAPI_Global_QueryAttributes(napi_env env, napi_callback_info info)
{
    static const char *aliasContent = "demo_alias";
    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了关键资产别名，最多查询到一条满足条件的关键资产
        {.tag = ASSET_TAG_RETURN_TYPE,
         .value.u32 = ASSET_RETURN_ATTRIBUTES}, // 此处表示仅返回关键资产属性，不包含关键资产明文
    };

    Asset_ResultSet resultSet = {0};
    int32_t ret = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    napi_value result;
    if (ret == ASSET_SUCCESS) {
        // Parse the result.
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // Parse the data label: the data is label->blob.data, the size is label->blob.size.
            Asset_Attr *label = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_DATA_LABEL_NORMAL_1);
        }
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    OH_Asset_FreeResultSet(&resultSet);
    return result;
}

static napi_value NAPI_Global_BatchQuery(napi_env env, napi_callback_info info)
{
    static const char *labelContent = "demo_label";
    Asset_Blob label = {(uint32_t)(strlen(labelContent)), (uint8_t *)labelContent};
    static const char *aliasContent = "demo_alias";
    Asset_Blob alias = {(uint32_t)(strlen(aliasContent)), (uint8_t *)aliasContent};

    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ATTRIBUTES},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
        {.tag = ASSET_TAG_RETURN_OFFSET, .value.u32 = 0},
        {.tag = ASSET_TAG_RETURN_LIMIT, .value.u32 = 1},
        {.tag = ASSET_TAG_RETURN_ORDERED_BY, .value.u32 = ASSET_TAG_DATA_LABEL_NORMAL_1},
    };

    Asset_ResultSet resultSet = {0};
    int32_t ret = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    napi_value result;
    if (ret == ASSET_SUCCESS) {
        // Parse the result.
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // Parse the data alias: the data is alias->blob.data, the size is alias->blob.size..
            Asset_Attr *alias = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_ALIAS);
        }
        napi_create_string_utf8(env, "success", INT_ARG_7, &result);
    } else {
        napi_create_string_utf8(env, "failed", INT_ARG_6, &result);
    }
    OH_Asset_FreeResultSet(&resultSet);
    return result;
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AddAsset", nullptr, NAPI_Global_AddAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RemoveAsset", nullptr, RemoveAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"UpdateAsset", nullptr, NAPI_Global_UpdateAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryAsset", nullptr, NAPI_Global_QueryAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryAttributes", nullptr, NAPI_Global_QueryAttributes, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"BatchQuery", nullptr, NAPI_Global_BatchQuery, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
