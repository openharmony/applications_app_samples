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

// [Start vector_include]
#include <hilog/log.h>
#include <database/data/oh_data_values.h>
#include <database/rdb/oh_cursor.h>
#include <database/rdb/relational_store.h>
// [End vector_include]

void VectorQuery(OH_Rdb_Store *store_)
{
    // [Start vector_OH_Rdb_ExecuteV2_query]
    // 不使用参数绑定查询数据
    OH_Cursor *cursor = OH_Rdb_ExecuteQueryV2(store_, "select * from test where id = 1;", nullptr);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    int rowCount = 0;
    cursor->getRowCount(cursor, &rowCount);
    cursor->goToNextRow(cursor);
    size_t count = 0;
    // floatvector数组是第二列数据
    OH_Cursor_GetFloatVectorCount(cursor, 1, &count);
    float test2[count];
    size_t outLen;
    OH_Cursor_GetFloatVector(cursor, 1, test2, count, &outLen);
    cursor->destroy(cursor);
    
    // 使用参数绑定查询数据
    char querySql[] = "select * from test where id = ?;";
    OH_Data_Values *values3 = OH_Values_Create();
    OH_Values_PutInt(values3, 1);
    cursor = OH_Rdb_ExecuteQueryV2(store_, querySql, values3);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    OH_Values_Destroy(values3);
    cursor->destroy(cursor);
    
    // 子查询，创建第二张表
    OH_Rdb_ExecuteV2(store_, "CREATE TABLE IF NOT EXISTS test1(id text PRIMARY KEY);", nullptr, nullptr);
    cursor = OH_Rdb_ExecuteQueryV2(store_, "select * from test where id in (select id from test1);", nullptr);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    cursor->destroy(cursor);
    
    // 聚合查询
    cursor = OH_Rdb_ExecuteQueryV2(store_,
        "select * from test where data1 <-> '[1.0, 1.0]' > 0 group by id having max(data1 <=> '[1.0, 1.0]');", nullptr);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    cursor->destroy(cursor);
    
    // 多表查询
    cursor = OH_Rdb_ExecuteQueryV2(store_, "select id, data1 <-> '[1.5, 5.6]' as distance from test "
        "union select id, data1 <-> '[1.5, 5.6]' as distance from test order by distance limit 5;", nullptr);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    cursor->destroy(cursor);
    // [End vector_OH_Rdb_ExecuteV2_query]
}

void VectorCRUD(OH_Rdb_Store *store_)
{
    // [Start vector_OH_Rdb_ExecuteV2_insert]
    char createTableSql[] = "CREATE TABLE test (id INTEGER PRIMARY KEY AUTOINCREMENT, data1 floatvector(2));";
    // 执行建表语句
    OH_Rdb_ExecuteByTrxId(store_, 0, createTableSql);
    
    // 不使用参数绑定插入数据
    OH_Rdb_ExecuteV2(store_, "INSERT INTO test (id, data1) VALUES (0, '[3.4, 4.5]');", nullptr, nullptr);
    // 使用参数绑定插入数据
    OH_Data_Values *values = OH_Values_Create();
    OH_Values_PutInt(values, 1);
    float test[] = { 1.2, 2.3 };
    size_t len = sizeof(test) / sizeof(test[0]);
    OH_Values_PutFloatVector(values, test, len);
    char insertSql[] = "INSERT INTO test (id, data1)   VALUES (?, ?);";
    OH_Rdb_ExecuteV2(store_, insertSql, values, nullptr);
    OH_Values_Destroy(values);
    // [End vector_OH_Rdb_ExecuteV2_insert]

    // [Start vector_OH_Rdb_ExecuteV2_update_and_delete]
    // 不使用参数绑定修改数据
    OH_Rdb_ExecuteV2(store_, "update test set data1 = '[5.1, 6.1]' where id = 0;", nullptr, nullptr);
    
    // 使用参数绑定修改数据
    float test1[2] = { 5.5, 6.6 };
    OH_Data_Values *values1 = OH_Values_Create();
    OH_Values_PutFloatVector(values1, test1, 2); // The size of Float is 2
    OH_Values_PutInt(values1, 1);
    OH_Rdb_ExecuteV2(store_, "update test set data1 = ? where id = ?", values1, nullptr);
    OH_Values_Destroy(values1);
    
    // 不使用参数绑定删除数据
    OH_Rdb_ExecuteV2(store_, "delete from test where id = 0", nullptr, nullptr);
    
    // 使用参数绑定删除数据
    OH_Data_Values *values2 = OH_Values_Create();
    OH_Values_PutInt(values2, 1);
    OH_Rdb_ExecuteV2(store_, "delete from test where id = ?", values2, nullptr);
    OH_Values_Destroy(values2);
    // [End vector_OH_Rdb_ExecuteV2_update_and_delete]

    VectorQuery(store_);
}

void VectorStoreTest()
{
    // [Start vector_OH_Rdb_GetSupportedDbType]
    int numType = 0;
    // 如果numType为2则支持向量数据库，为1则不支持向量数据库
    OH_Rdb_GetSupportedDbType(&numType);
    // [End vector_OH_Rdb_GetSupportedDbType]
    
    // [Start vector_OH_Rdb_Store]
    // 创建OH_Rdb_Config对象
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    // 该路径为应用沙箱路径
    // 数据库文件创建位置位于沙箱路径 /data/storage/el2/database/rdb/rdb_vector_test.db
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    // 数据库文件名
    OH_Rdb_SetStoreName(config, "rdb_vector_test.db");
    // 应用包名
    OH_Rdb_SetBundleName(config, "com.samples.vectorStore");
    // 数据库是否加密
    OH_Rdb_SetEncrypted(config, false);
    // 数据库文件安全等级
    OH_Rdb_SetSecurityLevel(config,   OH_Rdb_SecurityLevel::S1);
    // 数据库文件存放的安全区域
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL1);
    // 数据库类型
    OH_Rdb_SetDbType(config, RDB_CAYLEY);
    
    // 获取OH_Rdb_Store实例
    int errCode = 0;
    OH_Rdb_Store *store_ = OH_Rdb_CreateOrOpen(config, &errCode);
    // [End vector_OH_Rdb_Store]

    // 执行向量数据库的增删改查
    VectorCRUD(store_);

    // [Start vector_OH_Rdb_ExecuteV2_create_view]
    OH_Rdb_ExecuteV2(store_, "CREATE VIEW v1 as select * from test where id > 0;", nullptr, nullptr);
    OH_Cursor *cursor1 = OH_Rdb_ExecuteQueryV2(store_, "select * from v1;", nullptr);
    if (cursor1 == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        return;
    }
    cursor1->destroy(cursor1);
    // [End vector_OH_Rdb_ExecuteV2_create_view]

    // [Start vector_OH_Rdb_ExecuteV2_create_index]
    // 基础用法，创建的索引名称为diskann_l2_idx，索引列为repr，类型为gsdiskann，距离度量类型为L2
    OH_Rdb_ExecuteV2(store_, "CREATE INDEX diskann_l2_idx ON test USING GSDISKANN(data1 L2);", nullptr, nullptr);
    
    // 删除表test中的diskann_l2_idx索引
    OH_Rdb_ExecuteV2(store_, "DROP INDEX test.diskann_l2_idx;", nullptr, nullptr);
    
    // 扩展语法，设置QUEUE_SIZE为20，OUT_DEGREE为50
    OH_Rdb_ExecuteV2(store_, "CREATE INDEX diskann_l2_idx ON test USING GSDISKANN(repr L2) WITH "
        "(queue_size=20, out_degree=50);", nullptr, nullptr);
    // [End vector_OH_Rdb_ExecuteV2_create_index]

    // [Start vector_OH_Rdb_ExecuteV2_data_aging]
    // 每隔五分钟执行写操作后，会触发数据老化任务
    OH_Rdb_ExecuteV2(store_,"CREATE TABLE test2(rec_time integer not null) WITH "
        "(time_col = 'rec_time', interval = '5 minute');", nullptr, nullptr);
    // [End vector_OH_Rdb_ExecuteV2_data_aging]

    // [Start vector_OH_Rdb_ExecuteV2_data_compression]
    // content列配置了数据压缩，并且配置了数据老化。
    OH_Rdb_ExecuteV2(store_,"CREATE TABLE IF NOT EXISTS test3 (time integer not null, content text) with "
        "(time_col = 'time', interval = '5 minute', compress_col = 'content');", nullptr, nullptr);
    // [End vector_OH_Rdb_ExecuteV2_data_compression]

    // [Start vector_OH_Rdb_DeleteStoreV2]
    OH_Rdb_CloseStore(store_);
    OH_Rdb_DeleteStoreV2(config);
    // [End vector_OH_Rdb_DeleteStoreV2]
}

static napi_value Add(napi_env env, napi_callback_info info)
{
    VectorStoreTest();
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr }
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
