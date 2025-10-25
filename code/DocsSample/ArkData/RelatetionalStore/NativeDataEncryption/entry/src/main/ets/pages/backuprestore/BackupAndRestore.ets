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


// [StartExclude backuprestore_TS_IncludeSupported]
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit'
// [EndExclude backuprestore_TS_IncludeSupported]


const DOMAIN = 0x0000

// Backing up a relational database
// Back up manually

export async function backupManually() {

  // 手动备份
  // 手动备份：通过调用[backup](../reference/apis-arkdata/arkts-apis-data-relationalStore-RdbStore.md#backup)接口实现数据库手动备份。示例如下：

  // [Start backupManually]

  let store: relationalStore.RdbStore | undefined = undefined;
  let context = getContext();
  const STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'RdbTest.db',
    securityLevel: relationalStore.SecurityLevel.S3,
    allowRebuild: true
  };
  try {
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    await store.executeSql('CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)');
    hilog.info(DOMAIN, "BackupAndRestore", 'Succeeded in getting RdbStore.');
  } catch (e) {
    const err = e as BusinessError;
    hilog.info(DOMAIN, "BackupAndRestore", `Failed to get RdbStore. Code:${err.code},message:${err.message}`);
  }

  if (!store) {
    return;
  }

  try {
    /**
     * "Backup.db"为备份数据库文件名，默认在RdbStore同路径下备份。
     * 也可指定绝对路径："/data/storage/el2/database/Backup.db"，文件路径需要存在，不会自动创建目录。
     */
    await store.backup("Backup.db");
    hilog.info(DOMAIN, "BackupAndRestore", `Succeeded in backing up RdbStore.`);
  } catch (e) {
    const err = e as BusinessError;
    hilog.info(DOMAIN, "BackupAndRestore", `Failed to backup RdbStore. Code:${err.code}, message:${err.message}`);
  }

  // [End backupManually]


  // 关系型数据库数据恢复

  // 针对数据库出现异常的情况，在数据库重建成功后，需要用提前备份好的数据进行数据恢复。

  // 恢复方式分以下两种，手动备份恢复和自动备份恢复（仅系统应用可用）。

  // 恢复手动备份数据

  // 关系型数据库通过调用backup接口可以实现[手动备份数据库](#手动备份)，通过restore接口可以实现手动恢复数据库。

  // 具体恢复过程和关键示例代码片段如下，完整示例代码请结合关系型数据库的备份、重建等上下文进行实现。

  // 抛出数据库异常错误码

  // [Start databaseExceptionErrorCodeThrown]
  let predicates = new relationalStore.RdbPredicates("EMPLOYEE");
  if (store != undefined) {
    (store as relationalStore.RdbStore).query(predicates, ["ID", "NAME", "AGE", "SALARY", "CODES"])
      .then((result: relationalStore.ResultSet) => {
        let resultSet = result;
        try {
          /* ...
             业务的增删改逻辑
             ...
          */
          // 抛出异常
          if (resultSet?.rowCount == -1) {
            resultSet ?.isColumnNull(0);
          }
          // todo resultSet.goToFirstRow(), resultSet.count等其它接口也会抛异常
          while (resultSet.goToNextRow()) {
            hilog.info(DOMAIN, "BackupAndRestore", JSON.stringify(resultSet.getRow()));
          }
          resultSet.close();
        } catch (err) {
          if (err.code === 14800011) {
            // 执行下文的步骤，即关闭结果集之后进行数据的恢复
          }
          hilog.info(DOMAIN, "BackupAndRestore", JSON.stringify(err));
        }
      })
  }
  // [End databaseExceptionErrorCodeThrown]

  // 关闭所有打开着的结果集
  // [Start closeAllOpenResultSets]
  let resultSets: Array<relationalStore.ResultSet> = [];
  // 使用resultSet.close()方法关闭所有打开着的结果集
  for (let resultSet of resultSets) {
    try {
      resultSet.close();
    } catch (e) {
      if (e.code !== 14800014) {
        hilog.info(DOMAIN, "BackupAndRestore", `Code:${e.code}, message:${e.message}`);
      }
    }
  }
  // [End closeAllOpenResultSets]
}


// Rebuilding a relational database abnormally
// 关系型数据库异常重建
export async function rebuildingRelationalDatabaseAbnormally() {

  // 关系型数据库异常重建

  // 在创建或使用关系型数据库的过程中，抛出14800011异常错误码说明数据库出现异常，可以删除数据库后恢复数据。

  // 需要通过在[StoreConfig](../reference/apis-arkdata/arkts-apis-data-relationalStore-i.md#storeconfig)中配置allowRebuild参数为true以设置数据库在出现异常时自动删库。数据库重建成功后为空库，需要开发者重新建表并且使用提前备份好的数据进行数据恢复，备份操作可见[关系型数据库备份](#关系型数据库备份)，数据恢复可见[关系型数据库恢复](#关系型数据库数据恢复)。

  // 若数据库异常前已配置StoreConfig中的allowRebuild为true，则数据库出现异常时将自动删库。

  // 若数据库异常前未配置StoreConfig中的allowRebuild或allowRebuild配置为false，则需将其配置为true再次进行开库。具体示例如下：

  // [Start rebuildingRelationalDatabaseAbnormally]
  let store: relationalStore.RdbStore | undefined = undefined;
  let context = getContext();
  try {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbTest.db',
      securityLevel: relationalStore.SecurityLevel.S3,
      allowRebuild: true
    };
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    await store.executeSql('CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)');
    hilog.info(DOMAIN, "BackupAndRestore", 'Succeeded in getting RdbStore.');
  } catch (e) {
    const err = e as BusinessError;
    hilog.info(DOMAIN, "BackupAndRestore", `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
  }
  // [End rebuildingRelationalDatabaseAbnormally]
}

// Restoring manual backup data
// 调用restore接口恢复数据
export async function restoringManualBackupData() {

  // [Start invokeTheRestoreInterfaceToRestoreData]
  let store: relationalStore.RdbStore | undefined = undefined;
  let context = getContext();
  let STORE_CONFIG: relationalStore.StoreConfig = {
    name: "RdbTest.db",
    securityLevel: relationalStore.SecurityLevel.S3,
    allowRebuild: true
  }
  try {
    /**
     * "Backup.db"为备份数据库文件名，默认在当前 store 所在路径下查找备份文件 Backup.db。
     * 如在备份时指定了绝对路径："/data/storage/el2/database/Backup.db", 需要传入绝对路径。
     */
    let backupFilePath = context.databaseDir + '/rdb/Backup.db';
    const backupExist: boolean = await fileIo.access(backupFilePath);
    if (!backupExist) {
      hilog.info(DOMAIN, "BackupAndRestore", "Backup is not exist.");
      // todo 开库建表
      // todo 自行生成数据
      return;
    }
  } catch (e) {
    hilog.info(DOMAIN, "BackupAndRestore", `Code:${e.code}, message:${e.message}`);
  }

  try {
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    // 调用restore接口恢复数据
    await store.restore("Backup.db");
    hilog.info(DOMAIN, "BackupAndRestore", "Restore from backup success.");
  } catch (e) {
    const err = e as BusinessError;
    hilog.info(DOMAIN, "BackupAndRestore", `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
  }
  // [End invokeTheRestoreInterfaceToRestoreData]
}
