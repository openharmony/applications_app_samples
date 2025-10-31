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

// [Start encryption_include]
#include "database/rdb/relational_store.h"
#include <cstring>
// [End encryption_include]

// By default, the database is encrypted and decrypted
static napi_value DefaultConfigRdbStore(napi_env env, napi_callback_info info)
{
    // [Start DefaultConfigRdbStore]
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL2);
    OH_Rdb_SetBundleName(config, "com.example.nativedemo");
    OH_Rdb_SetStoreName(config, "RdbTest.db");
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    // 设置为使用加密方式创建或打开数据库
    OH_Rdb_SetEncrypted(config, true);
    
    int errCode = 0;
    
    // 获取OH_Rdb_Store实例
    OH_Rdb_Store *store = OH_Rdb_CreateOrOpen(config, &errCode);
    // [End DefaultConfigRdbStore]
    
    napi_value sum;
    return sum;
}

// Customized configuration to implement database encryption and decryption
static napi_value CustomizedConfigRdbStore(napi_env env,
                                           napi_callback_info info)
{
    // [Start CustomizedConfigRdbStore]
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL2);
    OH_Rdb_SetStoreName(config, "RdbTestConfigEncryptParam.db");
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetBundleName(config, "com.example.nativedemo");
    // 设置为使用加密方式创建或打开数据库
    OH_Rdb_SetEncrypted(config, true);
    // 创建自定义加密参数对象
    OH_Rdb_CryptoParam *cryptoParam = OH_Rdb_CreateCryptoParam();
    
    // 示例中使用硬编码密钥仅用于演示目的， 实际应用中应使用安全的密钥管理服务
    uint8_t key[6] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36};
    // 使用指定的密钥打开加密数据库。不指定则由数据库负责生成并保存密钥，并使用生成的密钥。
    const int32_t length = 6;
    OH_Crypto_SetEncryptionKey(cryptoParam, key, length);
    // 此处是示例代码，实际项目中建议使用memset_s 接口
    memset(key, 0, sizeof(key));
    // 设置KDF算法迭代次数。迭代次数必须大于零。不指定或等于零则使用默认值10000和默认加密算法。
    const int64_t iteration = 64000;
    OH_Crypto_SetIteration(cryptoParam, iteration);
    // 设置加密算法，如不设置默认为AES_256_GCM
    OH_Crypto_SetEncryptionAlgo(cryptoParam, Rdb_EncryptionAlgo::RDB_AES_256_CBC);
    // 设置HMAC算法，如不设置默认为SHA256
    OH_Crypto_SetHmacAlgo(cryptoParam, RDB_HMAC_SHA512);
    // 设置KDF算法，如不设置默认为SHA256
    OH_Crypto_SetKdfAlgo(cryptoParam, RDB_KDF_SHA512);
    // 设置打开加密数据库时使用的页大小，须为1024到65536之间的整数且为2的幂，如不设置默认为1024
    const int64_t pageSize = 4096;
    OH_Crypto_SetCryptoPageSize(cryptoParam, pageSize);
    // 设置自定义加密参数
    OH_Rdb_SetCryptoParam(config, cryptoParam);
    
    int errCode = 0;
    OH_Rdb_Store *store = OH_Rdb_CreateOrOpen(config, &errCode);
    // 销毁自定义加密参数对象
    OH_Rdb_DestroyCryptoParam(cryptoParam);
    cryptoParam = nullptr;
    OH_Rdb_CloseStore(store);
    store = nullptr;
    // [End CustomizedConfigRdbStore]
    
    napi_value sum;
    return sum;
}

// Invoke the OH_Rdb_Backup interface to back up the database
static napi_value BackupRdbStore(napi_env env, napi_callback_info info)
{
    // [Start BackupRdbStore]
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL2);
    OH_Rdb_SetStoreName(config, "RdbTest.db");
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetBundleName(config, "com.example.nativedemo");
    
    int errCode = 0;
    OH_Rdb_Store *store = OH_Rdb_CreateOrOpen(config, &errCode);
    
    // 备份数据库
    int result =
      OH_Rdb_Backup(store, "/data/storage/el2/database/RdbTest_bak.db");
    OH_Rdb_CloseStore(store);
    store = nullptr;
    // [End BackupRdbStore]
    
    napi_value sum;
    return sum;
}

// Invoke the OH_Rdb_Restore interface to restore the database
static napi_value RestoreRdbStore(napi_env env, napi_callback_info info)
{
    // [Start rdb_OH_Rdb_Restore]
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL2);
    OH_Rdb_SetStoreName(config, "RdbRestoreTest.db");
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetBundleName(config, "com.example.nativedemo");
    int errCode = 0;
    OH_Rdb_Store *store = OH_Rdb_CreateOrOpen(config, &errCode);
    
    OH_Rdb_DestroyConfig(config);
    config = nullptr;
    // 恢复数据库
    int result2 =
      OH_Rdb_Restore(store, "/data/storage/el2/database/RdbTest_bak.db");
    OH_Rdb_CloseStore(store);
    store = nullptr;
    // [End rdb_OH_Rdb_Restore]
    
    napi_value sum;
    return sum;
}

// 关系型数据库，通过OH_Rdb_SetSecurityLevel接口设置数据库的安全等级。此处以创建安全等级为S3的数据库为例。
// For a relational database, the security level of the database is set through
// the OH_Rdb_SetSecurityLevel interface. The following describes how to create
// a database with the security level of S3.
// 调用OH_Rdb_SetSecurityLevel接口设置数据库的安全等级。
static napi_value SetSecurityLevelForRdbStore(napi_env env,
                                              napi_callback_info info)
{
    // [Start SetSecurityLevelForRdbStore]
    OH_Rdb_ConfigV2 *config = OH_Rdb_CreateConfig();
    OH_Rdb_SetDatabaseDir(config, "/data/storage/el2/database");
    OH_Rdb_SetStoreName(config, "RdbTest.db");
    OH_Rdb_SetBundleName(config, "com.example.nativedemo");
    OH_Rdb_SetModuleName(config, "entry");
    // 数据库文件安全等级
    OH_Rdb_SetSecurityLevel(config, OH_Rdb_SecurityLevel::S3);
    OH_Rdb_SetEncrypted(config, false);
    OH_Rdb_SetArea(config, RDB_SECURITY_AREA_EL2);
    
    int errCode = 0;
    OH_Rdb_Store *store_ = OH_Rdb_CreateOrOpen(config, &errCode);
    OH_Rdb_CloseStore(store_);
    store_ = nullptr;
    // [End SetSecurityLevelForRdbStore]
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"defaultConfigRdbStore", nullptr, DefaultConfigRdbStore, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"customizedConfigRdbStore", nullptr, CustomizedConfigRdbStore, nullptr, nullptr, nullptr, napi_default,
            nullptr},
        {"backupRdbStore", nullptr, BackupRdbStore, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"restoreRdbStore", nullptr, RestoreRdbStore, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSecurityLevelForRdbStore", nullptr, SetSecurityLevelForRdbStore, nullptr, nullptr, nullptr, napi_default,
            nullptr}};
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
