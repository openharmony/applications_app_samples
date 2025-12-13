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
#include <sstream>
// [Start rdb_include]
#include <cstdlib>
#include <database/data/data_asset.h>
#include <database/rdb/oh_cursor.h>
#include <database/rdb/oh_predicates.h>
#include <database/rdb/oh_value_object.h>
#include <database/rdb/oh_values_bucket.h>
#include <database/rdb/relational_store.h>
#include <database/rdb/relational_store_error_code.h>
#include <hilog/log.h>
// [End rdb_include]

void RdbCreateTable(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Execute_create_table]
    char createTableSql[] = "CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, "
        "NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)";
    // 执行建表语句
    OH_Rdb_Execute(store_, createTableSql);
    // [End rdb_OH_Rdb_Execute_create_table]
}

void RdbInsert(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Insert_and_InsertWithConflictResolution]
    // 创建键值对实例
    OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
    valueBucket->putText(valueBucket, "NAME", "Lisa");
    valueBucket->putInt64(valueBucket, "AGE", 18); // The value of AGE is 18
    valueBucket->putReal(valueBucket, "SALARY", 100.5); // The value of SALARY is 100.5
    uint8_t arr[] = {1, 2, 3, 4, 5};
    int len = sizeof(arr) / sizeof(arr[0]);
    valueBucket->putBlob(valueBucket, "CODES", arr, len);
    // 插入数据
    int rowId = OH_Rdb_Insert(store_, "EMPLOYEE", valueBucket);
    
    OH_VBucket *valueBucket2 = OH_Rdb_CreateValuesBucket();
    valueBucket2->putInt64(valueBucket2, "ID", 2); // The value of ID is 2
    valueBucket2->putText(valueBucket2, "NAME", "zhangsan");
    valueBucket2->putInt64(valueBucket2, "AGE", 24); // The value of AGE is 24
    valueBucket2->putReal(valueBucket2, "SALARY", 120.4); // The value of SALARY is 120.4
    int64_t rowId2 = -1;
    // 支持插入数据时配置冲突策略
    int result = OH_Rdb_InsertWithConflictResolution(store_, "EMPLOYEE", valueBucket2,
        Rdb_ConflictResolution::RDB_CONFLICT_REPLACE, &rowId2);
    // 销毁键值对实例
    valueBucket->destroy(valueBucket);
    valueBucket2->destroy(valueBucket2);
    // [End rdb_OH_Rdb_Insert_and_InsertWithConflictResolution]
}

void RdbDelete(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Delete]
    // 删除数据
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    OH_VObject *valueObject = OH_Rdb_CreateValueObject();
    const char *name = "Lisa";
    valueObject->putText(valueObject, name);
    predicates->equalTo(predicates, "NAME", valueObject);
    int deleteRows = OH_Rdb_Delete(store_, predicates);
    valueObject->destroy(valueObject);
    predicates->destroy(predicates);
    // [End rdb_OH_Rdb_Delete]
}

void RdbUpdate(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Update_and_UpdateWithConflictResolution]
    // 创建valueBucket对象，用于存储要更新的新数据
    OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
    valueBucket->putText(valueBucket, "NAME", "Rose");
    valueBucket->putInt64(valueBucket, "AGE", 22); // The value of AGE is 22
    valueBucket->putReal(valueBucket, "SALARY", 200.5); // The value of SALARY is 200.5
    uint8_t arr[] = {1, 2, 3, 4, 5};
    int len = sizeof(arr) / sizeof(arr[0]);
    valueBucket->putBlob(valueBucket, "CODES", arr, len);
    // 创建谓词对象，指定更新条件：NAME为"Lisa"且SALARY为100.5
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        valueBucket->destroy(valueBucket);
        return;
    }
    OH_VObject *valueObject = OH_Rdb_CreateValueObject();
    const char *name = "Lisa";
    valueObject->putText(valueObject, name);
    predicates->equalTo(predicates, "NAME", valueObject)->andOperate(predicates);
    uint32_t count = 1;
    double salary = 100.5;
    valueObject->putDouble(valueObject, &salary, count);
    predicates->equalTo(predicates, "SALARY", valueObject);
    // 执行更新操作，将符合条件的数据更新为valueBucket中的值
    int changeRows = OH_Rdb_Update(store_, valueBucket, predicates);
    OH_Predicates *predicates2 = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (predicates2 == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        valueObject->destroy(valueObject);
        valueBucket->destroy(valueBucket);
        return;
    }
    OH_VObject *valueObject2 = OH_Rdb_CreateValueObject();
    valueObject2->putText(valueObject2, "Rose");
    predicates2->equalTo(predicates2, "NAME", valueObject2);
    valueBucket->putInt64(valueBucket, "ID", 1); // The value of ID is 1
    valueBucket->putText(valueBucket, "NAME", "zhangsan");
    int64_t changeRows2 = -1;
    
    // 支持更新数据时配置冲突策略
    int result = OH_Rdb_UpdateWithConflictResolution(store_, valueBucket, predicates2,
        Rdb_ConflictResolution::RDB_CONFLICT_REPLACE, &changeRows2);
    valueObject->destroy(valueObject);
    valueObject2->destroy(valueObject2);
    valueBucket->destroy(valueBucket);
    predicates->destroy(predicates);
    predicates2->destroy(predicates2);
    // [End rdb_OH_Rdb_Update_and_UpdateWithConflictResolution]
}

void RdbQuery(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Query]
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    const char *columnNames[] = {"NAME", "AGE"};
    int len = sizeof(columnNames) / sizeof(columnNames[0]);
    OH_Cursor *cursor = OH_Rdb_Query(store_, predicates, columnNames, len);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        predicates->destroy(predicates);
        return;
    }
    int columnCount = 0;
    cursor->getColumnCount(cursor, &columnCount);
    
    // OH_Cursor是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始
    int64_t age;
    while (cursor->goToNextRow(cursor) == OH_Rdb_ErrCode::RDB_OK) {
        int32_t ageColumnIndex = -1;
        cursor->getColumnIndex(cursor, "AGE", &ageColumnIndex);
        if (ageColumnIndex != -1) {
            cursor->getInt64(cursor, ageColumnIndex, &age);
        }
    }
    
    // 释放谓词实例
    predicates->destroy(predicates);
    // 释放结果集
    cursor->destroy(cursor);
    // [End rdb_OH_Rdb_Query]
}

void RdbQueryByLike(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Query_by_like_and_notLike]
    OH_Predicates *likePredicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (likePredicates == NULL) {
        return;
    }
    OH_VObject *likePattern = OH_Rdb_CreateValueObject();
    likePattern->putText(likePattern, "zh%");
    // 配置谓词以LIKE模式匹配
    likePredicates->like(likePredicates, "NAME", likePattern);
    
    char *colName[] = { "NAME", "AGE" };
    auto *likeQueryCursor = OH_Rdb_Query(store_, likePredicates, colName, 2); // the length of columnNames is 2
    if (likeQueryCursor == NULL) {
        likePredicates->destroy(likePredicates);
        likePattern->destroy(likePattern);
        return;
    }
    size_t dataLength = 0;
    int colIndex = -1;
    while (likeQueryCursor->goToNextRow(likeQueryCursor) == OH_Rdb_ErrCode::RDB_OK) {
        likeQueryCursor->getColumnIndex(likeQueryCursor, "NAME", &colIndex);
        likeQueryCursor->getSize(likeQueryCursor, colIndex, &dataLength);
        char *name = (char *)malloc((dataLength + 1) * sizeof(char));
        likeQueryCursor->getText(likeQueryCursor, colIndex, name, dataLength + 1);
        free(name);
    }

    likeQueryCursor->destroy(likeQueryCursor);
    likePredicates->destroy(likePredicates);
    likePattern->destroy(likePattern);
    
    OH_Predicates *notLikePredicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (notLikePredicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    // 配置谓词以NOT LIKE模式匹配
    OH_Predicates_NotLike(notLikePredicates, "NAME", "zh%");
    auto *notLikeQueryCursor = OH_Rdb_Query(store_, notLikePredicates, colName, 2); // the length of columnNames is 2
    if (notLikeQueryCursor == NULL) {
        notLikePredicates->destroy(notLikePredicates);
        return;
    }
    dataLength = 0;
    colIndex = -1;
    while (notLikeQueryCursor->goToNextRow(notLikeQueryCursor) == OH_Rdb_ErrCode::RDB_OK) {
        notLikeQueryCursor->getColumnIndex(notLikeQueryCursor, "NAME", &colIndex);
        notLikeQueryCursor->getSize(notLikeQueryCursor, colIndex, &dataLength);
        char *name2 = (char *)malloc((dataLength + 1) * sizeof(char));
        notLikeQueryCursor->getText(notLikeQueryCursor, colIndex, name2, dataLength + 1);
        free(name2);
    }
    
    notLikePredicates->destroy(notLikePredicates);
    notLikeQueryCursor->destroy(notLikeQueryCursor);
    // [End rdb_OH_Rdb_Query_by_like_and_notLike]
}

void RdbQueryByGlobe(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_Query_by_glob_and_notGlob]
    OH_Predicates *globPredicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (globPredicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    // 配置谓词以GLOB模式匹配
    OH_Predicates_Glob(globPredicates, "NAME", "zh*");
    
    char *colName[] = { "NAME", "AGE" };
    auto *globQueryCursor = OH_Rdb_Query(store_, globPredicates, colName, 2); // the length of columnNames is 2
    if (globQueryCursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        globPredicates->destroy(globPredicates);
        return;
    }

    size_t dataLength = 0;
    int colIndex = -1;
    while (globQueryCursor->goToNextRow(globQueryCursor) == OH_Rdb_ErrCode::RDB_OK) {
        globQueryCursor->getColumnIndex(globQueryCursor, "NAME", &colIndex);
        globQueryCursor->getSize(globQueryCursor, colIndex, &dataLength);
        char *name = (char *)malloc((dataLength + 1) * sizeof(char));
        globQueryCursor->getText(globQueryCursor, colIndex, name, dataLength + 1);
        free(name);
    }
    globQueryCursor->destroy(globQueryCursor);
    globPredicates->destroy(globPredicates);
    
    OH_Predicates *notGlobPredicates = OH_Rdb_CreatePredicates("EMPLOYEE");
    if (notGlobPredicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    // 配置谓词以NOT GLOB模式匹配
    OH_Predicates_NotGlob(notGlobPredicates, "NAME", "zh*");
    auto *notGlobQueryCursor = OH_Rdb_Query(store_, notGlobPredicates, colName, 2); // the length of columnNames is 2
    if (notGlobQueryCursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        notGlobPredicates->destroy(notGlobPredicates);
        return;
    }
    dataLength = 0;
    colIndex = -1;
    while (notGlobQueryCursor->goToNextRow(notGlobQueryCursor) == OH_Rdb_ErrCode::RDB_OK) {
        notGlobQueryCursor->getColumnIndex(notGlobQueryCursor, "NAME", &colIndex);
        notGlobQueryCursor->getSize(notGlobQueryCursor, colIndex, &dataLength);
        char *name2 = (char *)malloc((dataLength + 1) * sizeof(char));
        notGlobQueryCursor->getText(notGlobQueryCursor, colIndex, name2, dataLength + 1);
        free(name2);
    }

    notGlobQueryCursor->destroy(notGlobQueryCursor);
    notGlobPredicates->destroy(notGlobPredicates);
    // [End rdb_OH_Rdb_Query_by_glob_and_notGlob]
}


void RdbTransInsert(OH_Rdb_Transaction *trans)
{
    // [Start rdb_trans_insert]
    char transCreateTableSql[] =
        "CREATE TABLE IF NOT EXISTS transaction_table (id INTEGER PRIMARY KEY AUTOINCREMENT, data1 INTEGER, "
        "data2 INTEGER, data3 FLOAT, data4 TEXT, data5 BLOB, data6 ASSET, data7 ASSETS, data8 UNLIMITED INT, "
        "data9 FLOATVECTOR);";
    
    auto *execResult = OH_Value_Create();
    
    // 通过事务对象执行创建数据库表SQL语句
    int ret = OH_RdbTrans_Execute(trans, transCreateTableSql, nullptr, &execResult);
    
    // 创建OH_Data_Values实例
    OH_Data_Values *values = OH_Values_Create();
    ret = OH_Values_PutInt(values, 1); // The value of id is 1
    ret = OH_Values_PutInt(values, 2); // The value of datat2 is 2
    ret = OH_Values_PutReal(values, 1.1); // The value of datat3 is 1.1
    ret = OH_Values_PutText(values, "1"); // The value of datat3 is 1
    unsigned char val[] = {1, 2};
    ret = OH_Values_PutBlob(values, val, sizeof(val) / sizeof(val[0]));
    
    Data_Asset *asset = OH_Data_Asset_CreateOne();
    ret = OH_Data_Asset_SetName(asset, "name");
    ret = OH_Values_PutAsset(values, asset);
    OH_Data_Asset_DestroyOne(asset);
    
    Data_Asset **assets = OH_Data_Asset_CreateMultiple(2); // The number of created Data_Assets is 2
    ret = OH_Data_Asset_SetName(assets[0], "name1");
    ret = OH_Data_Asset_SetName(assets[1], "name2");
    ret = OH_Values_PutAssets(values, assets, 2); // The number of Data_ Assets is 2
    ret = OH_Data_Asset_DestroyMultiple(assets, 2); // The number of destroyed Data_Assets is 2
    
    uint64_t bigInt[] = {1, 2, 3, 4, 5};
    ret = OH_Values_PutUnlimitedInt(values, 0, bigInt, sizeof(bigInt) / sizeof(bigInt[0]));
    
    const char *insertSql = "INSERT INTO transaction_table "
                            "(data1, data2, data3, data4, data5, data6, data7, data8) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    OH_Data_Value *outValue = nullptr;
    
    // 通过事务对象执行数据插入SQL语句
    ret = OH_RdbTrans_Execute(trans, insertSql, values, &outValue);
    OH_Value_Destroy(outValue);
    OH_Values_Destroy(values);
    
    OH_VBucket *transValueBucket = OH_Rdb_CreateValuesBucket();
    transValueBucket->putInt64(transValueBucket, "data1", 1); // The value of datat1 is 1
    transValueBucket->putInt64(transValueBucket, "data2", 2); // The value of datat2 is 2
    transValueBucket->putReal(transValueBucket, "data3", 1.1); // The value of datat3 is 1.1
    transValueBucket->putText(transValueBucket, "data4", "1"); // The value of datat4 is 1
    transValueBucket->putBlob(transValueBucket, "data5", val, sizeof(val) / sizeof(val[0]));
    int64_t insertRowId = -1;
    // 通过事务对象执行OH_VBucket数据插入
    int insertRet = OH_RdbTrans_Insert(trans, "transaction_table", transValueBucket, &insertRowId);
    transValueBucket->destroy(transValueBucket);
    
    OH_VBucket *transValueBucket2 = OH_Rdb_CreateValuesBucket();
    transValueBucket2->putInt64(transValueBucket2, "id", 1); // The value of id is 1
    transValueBucket2->putInt64(transValueBucket2, "data2", 2); // The value of datat2 is 2
    transValueBucket2->putReal(transValueBucket2, "data3", 1.2); // The value of datat3 is 1.2
    
    int64_t transInsertRow = -1;
    // 支持插入数据时配置冲突策略
    int result = OH_RdbTrans_InsertWithConflictResolution(
        trans, "transaction_table", transValueBucket2, Rdb_ConflictResolution::RDB_CONFLICT_REPLACE, &transInsertRow);
    
    transValueBucket2->destroy(transValueBucket2);
    // [End rdb_trans_insert]
}

void RdbTransUpdate(OH_Rdb_Transaction *trans)
{
    // [Start rdb_trans_update]
    OH_VBucket *transValueBucket3 = OH_Rdb_CreateValuesBucket();
    transValueBucket3->putInt64(transValueBucket3, "id", 1); // The value of id is 1
    transValueBucket3->putInt64(transValueBucket3, "data2", 3); // The value of data2 is 3
    transValueBucket3->putReal(transValueBucket3, "data3", 1.2); // The value of data3 is 1.2
    
    OH_Predicates *transUpdatePredicates = OH_Rdb_CreatePredicates("transaction_table");
    if (transUpdatePredicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        transValueBucket3->destroy(transValueBucket3);
        return;
    }
    auto targetValue = OH_Rdb_CreateValueObject();
    int64_t two = 2;
    targetValue->putInt64(targetValue, &two, 1); // The value of id is 1
    transUpdatePredicates->equalTo(transUpdatePredicates, "data2", targetValue);
    
    int64_t updateRows = -1;
    // 支持更新数据时配置冲突策略
    OH_RdbTrans_UpdateWithConflictResolution(trans, transValueBucket3, transUpdatePredicates,
                                             Rdb_ConflictResolution::RDB_CONFLICT_REPLACE, &updateRows);
    targetValue->destroy(targetValue);
    transValueBucket3->destroy(transValueBucket3);
    transUpdatePredicates->destroy(transUpdatePredicates);
    // [End rdb_trans_update]
}

void RdbTransQuery(OH_Rdb_Transaction *trans)
{
    // [Start rdb_trans_query]
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("transaction_table");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    const char *columns[] = {"data1", "data2", "data3"};
    // 通过事务对象执行数据查询
    OH_Cursor *cursor = OH_RdbTrans_Query(trans, predicates, columns, sizeof(columns) / sizeof(columns[0]));
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        predicates->destroy(predicates);
        return;
    }
    int columnCount = 0;
    cursor->getColumnCount(cursor, &columnCount);
    
    predicates->destroy(predicates);
    cursor->destroy(cursor);
    // [End rdb_trans_query]
}

void RdbTransDelete(OH_Rdb_Transaction *trans)
{
    // [Start rdb_trans_delete]
    OH_Predicates *predicates2 = OH_Rdb_CreatePredicates("transaction_table");
    if (predicates2 == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    OH_VObject *valueObject = OH_Rdb_CreateValueObject();
    if (valueObject == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreateValueObject failed.");
        predicates2->destroy(predicates2);
        return;
    }
    valueObject->putText(valueObject, "1"); // Change the text value of the object to 1
    predicates2->equalTo(predicates2, "data4", valueObject);
    int64_t changes = -1;
    // 通过事务对象执行数据删除
    int deleteRet = OH_RdbTrans_Delete(trans, predicates2, &changes);
    predicates2->destroy(predicates2);
    valueObject->destroy(valueObject);
    // [End rdb_trans_delete]
}

void RdbTransTest(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_CreateTransaction]
    OH_RDB_TransOptions *options = OH_RdbTrans_CreateOptions();
    // 配置事务类型
    OH_RdbTransOption_SetType(options, RDB_TRANS_DEFERRED);
    OH_Rdb_Transaction *trans = nullptr;
    // 创建事务对象
    int res = OH_Rdb_CreateTransaction(store_, options, &trans);
    OH_RdbTrans_DestroyOptions(options);
    // [End rdb_OH_Rdb_CreateTransaction]
    
    // 通过事务对象进行增删改查
    RdbTransInsert(trans);
    RdbTransUpdate(trans);
    RdbTransQuery(trans);
    RdbTransDelete(trans);
    
    // [Start rdb_OH_RdbTrans_Commit]
    // 提交事务
    OH_RdbTrans_Commit(trans);
    // 销毁事务
    OH_RdbTrans_Destroy(trans);
    // [End rdb_OH_RdbTrans_Commit]
    
    // [Start rdb_OH_RdbTrans_Rollback]
    OH_RDB_TransOptions *options2 = OH_RdbTrans_CreateOptions();
    OH_RdbTransOption_SetType(options2, RDB_TRANS_DEFERRED);
    OH_Rdb_Transaction *trans2 = nullptr;
    int transCreateRet = OH_Rdb_CreateTransaction(store_, options2, &trans2);
    OH_RdbTrans_DestroyOptions(options2);

    // 回滚事务
    OH_RdbTrans_Rollback(trans2);
    OH_RdbTrans_Destroy(trans2);
    // [End rdb_OH_RdbTrans_Rollback]
}


void InitAttachStore()
{
    // [Start rdb_OH_Rdb_Attach_and_Detach]
    char attachStoreTableCreateSql[] = "CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, "
        "NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)";
    OH_Rdb_ConfigV2 *attachDbConfig = OH_Rdb_CreateConfig();
    if (attachDbConfig == NULL) {
        OH_LOG_ERROR(LOG_APP, "Create store config failed.");
        return;
    }
    OH_Rdb_SetModuleName(attachDbConfig, "entry");
    OH_Rdb_SetDatabaseDir(attachDbConfig, "/data/storage/el3/database");
    OH_Rdb_SetArea(attachDbConfig, RDB_SECURITY_AREA_EL3);
    OH_Rdb_SetStoreName(attachDbConfig, "RdbAttach.db");
    OH_Rdb_SetSecurityLevel(attachDbConfig, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetBundleName(attachDbConfig, "com.example.nativedemo");

    int errCode1 = 0;
    // 创建附加示例数据库 RdbAttach.db
    OH_Rdb_Store *attachStore = OH_Rdb_CreateOrOpen(attachDbConfig, &errCode1);
    
    if (attachStore == NULL) {
        OH_LOG_ERROR(LOG_APP, "Create attachStore failed, errCode: %{public}d", errCode1);
        OH_Rdb_DestroyConfig(attachDbConfig);
        return;
    }
    
    if (errCode1 != OH_Rdb_ErrCode::RDB_OK) {
        OH_LOG_ERROR(LOG_APP, "Create attachStore failed, errCode: %{public}d", errCode1);
        OH_Rdb_DestroyConfig(attachDbConfig);
        OH_Rdb_CloseStore(attachStore);
        return;
    }
    errCode1 = OH_Rdb_Execute(attachStore, attachStoreTableCreateSql);
    if (errCode1 != OH_Rdb_ErrCode::RDB_OK) {
        OH_LOG_ERROR(LOG_APP, "Create table failed, errCode: %{public}d", errCode1);
        OH_Rdb_DestroyConfig(attachDbConfig);
        OH_Rdb_CloseStore(attachStore);
        return;
    }
    OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
    valueBucket->putText(valueBucket, "NAME", "Lisa");
    valueBucket->putInt64(valueBucket, "AGE", 18); // The value of AGE is 18
    valueBucket->putReal(valueBucket, "SALARY", 100.5); // The value of AGE is 100.5
    uint8_t arr[] = {1, 2, 3, 4, 5};
    int len = sizeof(arr) / sizeof(arr[0]);
    valueBucket->putBlob(valueBucket, "CODES", arr, len);
    int rowId = OH_Rdb_Insert(attachStore, "EMPLOYEE", valueBucket);
    OH_LOG_INFO(LOG_APP, "Insert data result: %{public}d", rowId);
    valueBucket->destroy(valueBucket);
    OH_Rdb_CloseStore(attachStore);
    // [StartExclude rdb_OH_Rdb_Attach_and_Detach]
}

void AttachTest(OH_Rdb_Store *store_)
{
    OH_Rdb_ConfigV2 *attachDbConfig = OH_Rdb_CreateConfig();
    if (attachDbConfig == NULL) {
        OH_LOG_ERROR(LOG_APP, "Create store config failed.");
        return;
    }
    OH_Rdb_SetModuleName(attachDbConfig, "entry");
    OH_Rdb_SetDatabaseDir(attachDbConfig, "/data/storage/el3/database");
    OH_Rdb_SetArea(attachDbConfig, RDB_SECURITY_AREA_EL3);
    OH_Rdb_SetStoreName(attachDbConfig, "RdbAttach.db");
    OH_Rdb_SetSecurityLevel(attachDbConfig, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetBundleName(attachDbConfig, "com.example.nativedemo");
    int errCode = 0;
    InitAttachStore();

    // [EndExclude rdb_OH_Rdb_Attach_and_Detach]
    // 附加数据库
    size_t attachedNumber = 0;
    // The maximum waiting time allowed for attaching databases is 10
    errCode = OH_Rdb_Attach(store_, attachDbConfig, "attach", 10, &attachedNumber);
    OH_Rdb_DestroyConfig(attachDbConfig);
    if (errCode != OH_Rdb_ErrCode::RDB_OK) {
        OH_LOG_ERROR(LOG_APP, "Attach store failed, errCode: %{public}d", errCode);
        return;
    }
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("attach.EMPLOYEE");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        // The maximum waiting time allowed for detaching databases is 10
        errCode = OH_Rdb_Detach(store_, "attach", 10, &attachedNumber);
        OH_LOG_INFO(LOG_APP, "Detach result: %{public}d", errCode);
        return;
    }
    char *colName[] = {};
    int len = sizeof(colName) / sizeof(colName[0]);
    OH_Cursor *cursor = OH_Rdb_Query(store_, predicates, colName, len);
    if (cursor == NULL) {
        OH_LOG_ERROR(LOG_APP, "Query failed.");
        // The maximum waiting time allowed for detaching databases is 10
        errCode = OH_Rdb_Detach(store_, "attach", 10, &attachedNumber);
        OH_LOG_INFO(LOG_APP, "Detach result: %{public}d", errCode);
        predicates->destroy(predicates);
        return;
    }
    int rowCount = -1;
    errCode = cursor->getRowCount(cursor, &rowCount);
    if (errCode != OH_Rdb_ErrCode::RDB_OK) {
        OH_LOG_ERROR(LOG_APP, "Get row count failed, errCode: %{public}d", errCode);
    } else {
        OH_LOG_INFO(LOG_APP, "Query success, row count: %{public}d", rowCount);
    }
    cursor->destroy(cursor);
    predicates->destroy(predicates);
    // 分离数据库
    // The maximum waiting time allowed for detaching databases is 10
    errCode = OH_Rdb_Detach(store_, "attach", 10, &attachedNumber);
    OH_LOG_INFO(LOG_APP, "Detach result: %{public}d", errCode);
    // [End rdb_OH_Rdb_Attach_and_Detach]
}

void AssetInset(OH_Rdb_Store *store_)
{
    // [Start rdb_asset_insert]
    // 列的属性为单个资产类型时，sql语句中应指定为asset，多个资产类型应指定为assets。
    char createAssetTableSql[] = "CREATE TABLE IF NOT EXISTS asset_table (id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "data1 ASSET, data2 ASSETS );";
    const char *table = "asset_table";
    int errCode = OH_Rdb_Execute(store_, createAssetTableSql);
    OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
    Data_Asset *asset = OH_Data_Asset_CreateOne();
    OH_Data_Asset_SetName(asset, "name0");
    OH_Data_Asset_SetUri(asset, "uri0");
    OH_Data_Asset_SetPath(asset, "path0");
    OH_Data_Asset_SetCreateTime(asset, 1); // Set the creation time of Data_Asset to 1
    OH_Data_Asset_SetModifyTime(asset, 1); // Set the modify time of Data_Asset to 1
    OH_Data_Asset_SetSize(asset, 1); // Set the size of the Data_Asset to 1
    OH_Data_Asset_SetStatus(asset, Data_AssetStatus::ASSET_NORMAL);
    errCode = OH_VBucket_PutAsset(valueBucket, "data1", asset);
    
    Data_Asset **assets = OH_Data_Asset_CreateMultiple(2);
    
    OH_Data_Asset_SetName(assets[0], "name0");
    OH_Data_Asset_SetUri(assets[0], "uri0");
    OH_Data_Asset_SetPath(assets[0], "path0");
    OH_Data_Asset_SetCreateTime(assets[0], 1); // Set the creation time of Data_Asset to 1
    OH_Data_Asset_SetModifyTime(assets[0], 1); // Set the modify time of Data_Asset to 1
    OH_Data_Asset_SetSize(assets[0], 1); // Set the size of the Data_Asset to 1
    OH_Data_Asset_SetStatus(assets[0], Data_AssetStatus::ASSET_NORMAL);
    
    OH_Data_Asset_SetName(assets[1], "name1");
    OH_Data_Asset_SetUri(assets[1], "uri1");
    OH_Data_Asset_SetPath(assets[1], "path1");
    OH_Data_Asset_SetCreateTime(assets[1], 1); // Set the creation time of Data_Asset to 1
    OH_Data_Asset_SetModifyTime(assets[1], 1); // Set the modify time of Data_Asset to 1
    OH_Data_Asset_SetSize(assets[1], 1); // Set the size of the Data_Asset to 1
    OH_Data_Asset_SetStatus(assets[1], Data_AssetStatus::ASSET_NORMAL);
    
    uint32_t assetsCount = 2;
    errCode = OH_VBucket_PutAssets(valueBucket, "data2", assets, assetsCount);
    int rowID = OH_Rdb_Insert(store_, table, valueBucket);
    // 释放Data_Asset*和Data_Asset**
    OH_Data_Asset_DestroyMultiple(assets, assetsCount);
    OH_Data_Asset_DestroyOne(asset);
    valueBucket->destroy(valueBucket);
    // [End rdb_asset_insert]
}

void AssertQuery(OH_Rdb_Store *store_)
{
    // [Start rdb_asset_query]
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("asset_table");
    if (predicates == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreatePredicates failed.");
        return;
    }
    OH_Cursor *cursor = OH_Rdb_Query(store_, predicates, NULL, 0);
    if (cursor == NULL) {
        predicates->destroy(predicates);
    } else {
        cursor->goToNextRow(cursor);
        
        uint32_t assetCount = 0;
        // assetCount作为出参获取该列资产类型数据的数量
        int errCode = cursor->getAssets(cursor, 2, nullptr, &assetCount); // Column index is 2
        Data_Asset **assets = OH_Data_Asset_CreateMultiple(assetCount);
        errCode = cursor->getAssets(cursor, 2, assets, &assetCount); // Column index is 2
        // The number of Data_Assets is 2
        if (assetCount < 2) {
            predicates->destroy(predicates);
            cursor->destroy(cursor);
        } else {
            Data_Asset *asset = assets[1];
            char name[10] = "";
            size_t nameLength = 10;
            errCode = OH_Data_Asset_GetName(asset, name, &nameLength);
            
            char uri[10] = "";
            size_t uriLength = 10;
            errCode = OH_Data_Asset_GetUri(asset, uri, &uriLength);
            
            char path[10] = "";
            size_t pathLength = 10;
            errCode = OH_Data_Asset_GetPath(asset, path, &pathLength);
            
            int64_t createTime = 0;
            errCode = OH_Data_Asset_GetCreateTime(asset, &createTime);
            
            int64_t modifyTime = 0;
            errCode = OH_Data_Asset_GetModifyTime(asset, &modifyTime);
            
            size_t size = 0;
            errCode = OH_Data_Asset_GetSize(asset, &size);
            
            Data_AssetStatus status = Data_AssetStatus::ASSET_NULL;
            errCode = OH_Data_Asset_GetStatus(asset, &status);
            
            predicates->destroy(predicates);
            OH_Data_Asset_DestroyMultiple(assets, assetCount);
            cursor->destroy(cursor);
        }
    }
    // [End rdb_asset_query]
}

void FindModifyTimeTest(OH_Rdb_Store *store_)
{
    // [Start rdb_OH_Rdb_FindModifyTime]
    constexpr uint32_t  tableCount = 1;
    const char *table[tableCount];
    table[0] = "EMPLOYEE";
    Rdb_DistributedConfig distributedConfig{ .version = 1, .isAutoSync = true };
    // 设置分布式表
    OH_Rdb_SetDistributedTables(store_, table, tableCount, RDB_DISTRIBUTED_CLOUD, &distributedConfig);
    // 查询数据的最后修改时间
    OH_VObject *values = OH_Rdb_CreateValueObject();
    int64_t keys[] = { 1 };
    values->putInt64(values, keys, 1); // The value of keys is 1
    OH_Cursor *cursor = OH_Rdb_FindModifyTime(store_, "EMPLOYEE", "ROWID", values);
    if (cursor == NULL) {
        return;
    }
    while (cursor->goToNextRow(cursor) == OH_Rdb_ErrCode::RDB_OK) {
        int64_t rowId;
        cursor->getInt64(cursor, 1, &rowId); // 1 is the column index
    }
    // [End rdb_OH_Rdb_FindModifyTime]
}

void RdbStoreTest()
{
    // [Start rdb_OH_Rdb_CreateOrOpen]
    // 创建OH_Rdb_ConfigV2对象
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    // 该路径为应用沙箱路径
    // 数据库文件创建位置将位于沙箱路径 /data/storage/el3/database/rdb/RdbTest.db
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el3/database");
    // 数据库文件存放的安全区域，与databaseDir参数中el路径对应
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL3);
    // 数据库文件名
    OH_Rdb_SetStoreName(config, "RdbTest.db");
    // 应用包名
    OH_Rdb_SetBundleName(config, "com.samples.rdbstore");
    // 应用模块名
    OH_Rdb_SetModuleName(config, "entry");
    // 数据库文件安全等级
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    // 数据库是否加密
    OH_Rdb_SetEncrypted(config, false);
    // [StartExclude rdb_OH_Rdb_CreateOrOpen]
    
    // [Start rdb_OH_Rdb_SetCustomDir_and_SetReadOnly]
    
    // 可设置自定义数据库路径
    // 数据库文件创建位置将位于沙箱路径 /data/storage/el3/database/a/b/RdbTest.db
    OH_Rdb_SetCustomDir(config, "../a/b");
    // 可设置为只读模式打开数据库
    OH_Rdb_SetReadOnly(config, true);
    // [End rdb_OH_Rdb_SetCustomDir_and_SetReadOnly]

    // [Start rdb_OH_Rdb_SetPlugins]
    const char *plugins[] = {
        "/system/lib64/platformsdk/libcustomtokenizer.z.so"
    };
    int32_t count = sizeof(plugins) / sizeof(plugins[0]);
    OH_Rdb_SetPlugins(config, plugins, count);
    // [End rdb_OH_Rdb_SetPlugins]
    
    // 实例代码中后续要进行写操作，设置为非只读模式打开数据库
    OH_Rdb_SetReadOnly(config, false);
    // [EndExclude rdb_OH_Rdb_CreateOrOpen]
    
    int errCode = 0;
    // 获取OH_Rdb_Store实例
    OH_Rdb_Store *store_ = OH_Rdb_CreateOrOpen(config, &errCode);
    if (store_ == NULL) {
        OH_LOG_ERROR(LOG_APP, "Create store failed, errCode: %{public}d", errCode);
        OH_Rdb_DestroyConfig(config);
        return;
    }
    if (errCode != OH_Rdb_ErrCode::RDB_OK) {
        OH_LOG_ERROR(LOG_APP, "Create attachStore failed, errCode: %{public}d", errCode);
        OH_Rdb_DestroyConfig(config);
        OH_Rdb_CloseStore(store_);
        return;
    }
    // [End rdb_OH_Rdb_CreateOrOpen]
    // 建表
    RdbCreateTable(store_);
    // 进行增删改查操作
    RdbInsert(store_);
    RdbUpdate(store_);
    RdbDelete(store_);
    RdbQuery(store_);
    RdbQueryByLike(store_);
    RdbQueryByGlobe(store_);

    // [Start rdb_OH_Rdb_SetLocale]
    OH_Rdb_SetLocale(store_, "zh_CN");
    // [End rdb_OH_Rdb_SetLocale]

    // 通过事务对象进行增删改查
    RdbTransTest(store_);

    // 附加数据库
    AttachTest(store_);

    // 向数据库表中插入资产类型数据
    AssetInset(store_);

    // 从结果集中读取资产类型数据
    AssertQuery(store_);

    FindModifyTimeTest(store_);

    // [Start rdb_OH_Rdb_CloseStore_and_DeleteStore]
    // 释放数据库实例
    OH_Rdb_CloseStore(store_);
    // 删除数据库文件
    OH_Rdb_DeleteStoreV2(config);
    // [End rdb_OH_Rdb_CloseStore_and_DeleteStore]
}

static napi_value Add(napi_env env, napi_callback_info info)
{
    RdbStoreTest();
    return nullptr;
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