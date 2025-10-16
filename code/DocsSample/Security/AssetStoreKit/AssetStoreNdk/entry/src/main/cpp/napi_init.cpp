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

// [Start include]
#include "napi/native_api.h"
#include <string.h>
#include "asset/asset_api.h"
// [End include]

// [Start add_asset]
static napi_value AddAsset(napi_env env, napi_callback_info info)
{
    const char *secretStr = "demo_pwd";
    const char *aliasStr = "demo_alias";
    const char *labelStr = "demo_label";

    Asset_Blob secret = {(uint32_t)(strlen(secretStr)), (uint8_t *)secretStr};
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ACCESSIBILITY, .value.u32 = ASSET_ACCESSIBILITY_DEVICE_FIRST_UNLOCKED},
        {.tag = ASSET_TAG_SECRET, .value.blob = secret},
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
    };

    int32_t addResult = OH_Asset_Add(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value ret;
    napi_create_int32(env, addResult, &ret);
    return ret;
}
// [End add_asset]

// [Start remove_asset]
static napi_value RemoveAsset(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 此处指定别名删除单条关键资产，也可不指定别名删除多条关键资产。
    };

    int32_t removeResult = OH_Asset_Remove(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value ret;
    napi_create_int32(env, removeResult, &ret);
    return ret;
}
// [End remove_asset]

// [Start update_asset]
static napi_value UpdateAsset(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    const char *secretStr = "demo_pwd_new";
    const char *labelStr = "demo_label_new";

    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob new_secret = {(uint32_t)(strlen(secretStr)), (uint8_t *)secretStr};
    Asset_Blob new_label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Attr query[] = {{.tag = ASSET_TAG_ALIAS, .value.blob = alias }};
    Asset_Attr attributesToUpdate[] = {
        {.tag = ASSET_TAG_SECRET, .value.blob = new_secret},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = new_label},
    };

    int32_t updateResult = OH_Asset_Update(query, sizeof(query) / sizeof(query[0]), attributesToUpdate,
                                           sizeof(attributesToUpdate) / sizeof(attributesToUpdate[0]));
    napi_value ret;
    napi_create_int32(env, updateResult, &ret);
    return ret;
}
// [End update_asset]

// [Start query_single_plaintext]
static napi_value QueryAssetPlaintext(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了关键资产别名，最多查询到一条满足条件的关键资产。
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ALL}, // 此处表示需要返回关键资产的所有信息，即属性+明文。返回明文需要解密，查询时间较长。
    };

    Asset_ResultSet resultSet = {0};
    int32_t queryResult = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (queryResult == ASSET_SUCCESS) {
        // 解析resultSet。
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // 解析secret属性：其中data数据对应是secret->blob.data，长度对应是secret->blob.size。
            Asset_Attr *secret = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_SECRET);
        }
    }
    OH_Asset_FreeResultSet(&resultSet);
 
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_single_plaintext]

// [Start query_single_attribute]
static napi_value QueryAssetAttribute(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    
    Asset_Blob alias = { (uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr };
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了关键资产别名，最多查询到一条满足条件的关键资产。
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ATTRIBUTES}, // 此处表示仅返回关键资产属性。返回属性不需解密，查询时间较短。
    };

    Asset_ResultSet resultSet = {0};
    int32_t queryResult = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (queryResult == ASSET_SUCCESS) {
        // 解析结果。
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // 解析数据标签：其中数据是label->blob.data，长度对应是label->blob.size。
            Asset_Attr *label = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_DATA_LABEL_NORMAL_1);
        }
    }
    OH_Asset_FreeResultSet(&resultSet);
 
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_single_attribute]

// [Start query_batch_attributes]
static napi_value QueryBatchAssetAttributes(napi_env env, napi_callback_info info)
{
    const char *labelStr = "demo_label";
    
    Asset_Blob label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ATTRIBUTES},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
        {.tag = ASSET_TAG_RETURN_LIMIT, .value.u32 = 10},
        {.tag = ASSET_TAG_RETURN_ORDERED_BY, .value.u32 = ASSET_TAG_DATA_LABEL_NORMAL_1},
    };

    Asset_ResultSet resultSet = { 0 };
    int32_t queryResult = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (queryResult == ASSET_SUCCESS) {
        // 解析结果。
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // 解析数据别名：其中别名是label->blob.data，长度对应是label->blob.size。
            Asset_Attr *alias = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_ALIAS);
        }
    }
    OH_Asset_FreeResultSet(&resultSet);
 
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_batch_attributes]

// [Start add_group_asset]
static napi_value AddGroupAsset(napi_env env, napi_callback_info info)
{
    const char *secretStr = "demo_pwd";
    const char *aliasStr = "demo_alias";
    const char *labelStr = "demo_label";
    const char *groupIdStr = "demo_group_id";

    Asset_Blob secret = {(uint32_t)(strlen(secretStr)), (uint8_t *)secretStr};
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Blob group_id = { (uint32_t)(strlen(groupIdStr)), (uint8_t *)groupIdStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_SECRET, .value.blob = secret},
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
        {.tag = ASSET_TAG_GROUP_ID, .value.blob = group_id},
    };

    int32_t addResult = OH_Asset_Add(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value ret;
    napi_create_int32(env, addResult, &ret);
    return ret;
}
// [End add_group_asset]

// [Start remove_group_asset]
static napi_value RemoveGroupAsset(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    const char *groupIdStr = "demo_group_id";

    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob group_id = {(uint32_t)(strlen(groupIdStr)), (uint8_t *)groupIdStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 此处指定别名删除单条群组关键资产，也可不指定别名删除多条群组关键资产。
        {.tag = ASSET_TAG_GROUP_ID, .value.blob = group_id},
    };

    int32_t removeResult = OH_Asset_Remove(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value ret;
    napi_create_int32(env, removeResult, &ret);
    return ret;
}
// [End remove_group_asset]

// [Start update_group_asset]
static napi_value UpdateGroupAsset(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    const char *secretStr = "demo_pwd_new";
    const char *labelStr = "demo_label_new";
    const char *groupIdStr = "demo_group_id";

    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob new_secret = {(uint32_t)(strlen(secretStr)), (uint8_t *)secretStr};
    Asset_Blob new_label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Blob group_id = {(uint32_t)(strlen(groupIdStr)), (uint8_t *)groupIdStr};
    Asset_Attr query[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias},
        {.tag = ASSET_TAG_GROUP_ID, .value.blob = group_id},
    };
    Asset_Attr attributesToUpdate[] = {
        {.tag = ASSET_TAG_SECRET, .value.blob = new_secret},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = new_label},
    };

    int32_t updateResult = OH_Asset_Update(query, sizeof(query) / sizeof(query[0]), attributesToUpdate,
                                           sizeof(attributesToUpdate) / sizeof(attributesToUpdate[0]));
    napi_value ret;
    napi_create_int32(env, updateResult, &ret);
    return ret;
}
// [End update_group_asset]

// [Start query_group_single_plaintext]
static napi_value QueryGroupAssetPlaintext(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    const char *groupIdStr = "demo_group_id";
    
    Asset_Blob alias = { (uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr };
    Asset_Blob group_id = { (uint32_t)(strlen(groupIdStr)), (uint8_t *)groupIdStr };
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了群组关键资产别名，最多查询到一条满足条件的群组关键资产。
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ALL}, // 此处表示需要返回群组关键资产的所有信息，即属性+明文。
        {.tag = ASSET_TAG_GROUP_ID, .value.blob = group_id},
    };

    Asset_ResultSet resultSet = {0};
    int32_t queryResult = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (queryResult == ASSET_SUCCESS) {
        // 解析resultSet。
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // 解析secret属性：其中data数据对应是secret->blob.data，长度对应是secret->blob.size。
            Asset_Attr *secret = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_SECRET);
        }
    }
    OH_Asset_FreeResultSet(&resultSet);
    
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_group_single_plaintext]

// [Start query_group_single_attribute]
static napi_value QueryGroupAssetAttribute(napi_env env, napi_callback_info info)
{
    const char *aliasStr = "demo_alias";
    const char *groupIdStr = "demo_group_id";
    
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob group_id = {(uint32_t)(strlen(groupIdStr)), (uint8_t *)groupIdStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias}, // 指定了群组关键资产别名，最多查询到一条满足条件的群组关键资产。
        {.tag = ASSET_TAG_RETURN_TYPE, .value.u32 = ASSET_RETURN_ATTRIBUTES}, // 此处表示仅返回群组关键资产属性，不包含群组关键资产明文。
        {.tag = ASSET_TAG_GROUP_ID, .value.blob = group_id},
    };

    Asset_ResultSet resultSet = {0};
    int32_t queryResult = OH_Asset_Query(attr, sizeof(attr) / sizeof(attr[0]), &resultSet);
    if (queryResult == ASSET_SUCCESS) {
        // 解析结果。
        for (uint32_t i = 0; i < resultSet.count; i++) {
            // 解析数据标签：其中数据是label->blob.data，长度对应是label->blob.size。
            Asset_Attr *label = OH_Asset_ParseAttr(resultSet.results + i, ASSET_TAG_DATA_LABEL_NORMAL_1);
        }
    }
    OH_Asset_FreeResultSet(&resultSet);
    
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_group_single_attribute]

// [Start add_sync_asset]
static napi_value AddSyncAsset(napi_env env, napi_callback_info info)
{
    char *secretStr = "demo_pwd";
    char *aliasStr = "demo_alias";
    char *labelStr = "demo_label";

    Asset_Blob secret = {(uint32_t)(strlen(secretStr)), (uint8_t *)secretStr};
    Asset_Blob alias = {(uint32_t)(strlen(aliasStr)), (uint8_t *)aliasStr};
    Asset_Blob label = {(uint32_t)(strlen(labelStr)), (uint8_t *)labelStr};
    Asset_Attr attr[] = {
        {.tag = ASSET_TAG_SECRET, .value.blob = secret},
        {.tag = ASSET_TAG_ALIAS, .value.blob = alias},
        {.tag = ASSET_TAG_DATA_LABEL_NORMAL_1, .value.blob = label},
        {.tag = ASSET_TAG_SYNC_TYPE, .value.u32 = ASSET_SYNC_TYPE_TRUSTED_DEVICE}, // 需指定在可信设备间同步（如新旧设备间克隆）。
    };

    int32_t addResult = OH_Asset_Add(attr, sizeof(attr) / sizeof(attr[0]));
    napi_value ret;
    napi_create_int32(env, addResult, &ret);
    return ret;
}
// [End add_sync_asset]

// [Start query_sync_result]
static napi_value QuerySyncResult(napi_env env, napi_callback_info info)
{
    Asset_SyncResult syncResult = {0};
    int32_t queryResult = OH_Asset_QuerySyncResult(NULL, 0, &syncResult);
    napi_value ret;
    napi_create_int32(env, queryResult, &ret);
    return ret;
}
// [End query_sync_result]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AddAsset", nullptr, AddAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RemoveAsset", nullptr, RemoveAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"UpdateAsset", nullptr, UpdateAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryAssetPlaintext", nullptr, QueryAssetPlaintext, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryAssetAttribute", nullptr, QueryAssetAttribute, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"BatchQuery", nullptr, QueryBatchAssetAttributes, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AddGroupAsset", nullptr, AddGroupAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RemoveGroupAsset", nullptr, RemoveGroupAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"UpdateGroupAsset", nullptr, UpdateGroupAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryGroupPlaintext", nullptr, QueryGroupAssetPlaintext, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QueryGroupAttribute", nullptr, QueryGroupAssetAttribute, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AddSyncAsset", nullptr, AddSyncAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"QuerySyncResult", nullptr, QuerySyncResult, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }