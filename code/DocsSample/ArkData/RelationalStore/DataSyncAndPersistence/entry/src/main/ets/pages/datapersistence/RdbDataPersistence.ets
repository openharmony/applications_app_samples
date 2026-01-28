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

// [Start persistence_get_store]
import { relationalStore } from '@kit.ArkData'; // 导入模块
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIContext } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
const DOMAIN = 0x0000;

let store: relationalStore.RdbStore | undefined = undefined;
let tokenType = relationalStore.Tokenizer.ICU_TOKENIZER;
let tokenTypeSupported = relationalStore.isTokenizerSupported(tokenType);
if (!tokenTypeSupported) {
  tokenType = relationalStore.Tokenizer.NONE_TOKENIZER;
  hilog.error(DOMAIN, 'rdbDataPersistence', `ICU_TOKENIZER is not supported on this platform.`);
}
const STORE_CONFIG: relationalStore.StoreConfig = {
  // 数据库文件名
  name: 'RdbTest.db',
  // 数据库安全级别
  securityLevel: relationalStore.SecurityLevel.S3,
  // 可选参数，指定数据库是否加密，默认不加密
  encrypt: false,
  // 可选参数，数据库自定义路径。默认在本应用沙箱目录下创建RdbStore实例。
  customDir: 'customDir/subCustomDir',
  // 可选参数，指定数据库是否以只读方式打开。默认为false，表示数据库可读可写。为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
  isReadOnly: false,
  // 可选参数，指定用户在全文搜索场景(FTS)下使用哪种分词器。默认在FTS下仅支持英文分词，不支持其他语言分词。
  tokenizer: tokenType,
};
// [StartExclude persistence_get_store]
export async function rdbDataPersistence() {
  // [EndExclude persistence_get_store]
  // 判断数据库版本，如果不匹配则需进行升降级操作
  // 假设当前数据库版本为3，表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
  // 建表Sql语句, IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT
  const SQL_CREATE_TABLE =
    'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB, ADDRESS TEXT)';
  if (store === undefined) {
    try {
      const context = new UIContext().getHostContext() as common.UIAbilityContext;
      store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    } catch (e) {
      const err = e as BusinessError;
      hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
  }
  hilog.info(DOMAIN, 'rdbDataPersistence', 'Succeeded in getting RdbStore.');
  if (store !== undefined) {
    let transaction = await store.createTransaction({});
    let storeVersion = await transaction.execute('PRAGMA user_version');
    // 当数据库创建时，数据库默认版本为0
    // 示例应用升级流程较短，所以使用单个事务。如果实际业务中升级逻辑较多，建议拆分多个独立事务串行执行。
    if (storeVersion === 0) {
      try {
        await transaction.execute(SQL_CREATE_TABLE); // 创建数据表，以便后续调用insert接口插入数据
        storeVersion = 1;
        hilog.info(DOMAIN, 'rdbDataPersistence', 'Upgrade store version from 0 to 1 success.');
        // 设置数据库的版本，入参为大于0的整数
      } catch (e) {
        const err = e as BusinessError;
        await transaction.rollback();
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to execute sql. Code:${err.code}, message:${err.message}`);
        return;
      }
    }
    // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
    // 当前数据库存在并且版本为1，数据库需要从1版本升级到2版本
    if (storeVersion === 1) {
      // version = 1：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
      // => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS, IDENTITY)
      try {
        await transaction.execute('ALTER TABLE EMPLOYEE ADD COLUMN IDENTITY UNLIMITED INT');
        storeVersion = 2;
        hilog.info(DOMAIN, 'rdbDataPersistence', 'Upgrade store version from 1 to 2 success.');
      } catch (e) {
        const err = e as BusinessError;
        await transaction.rollback();
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to execute sql. Code:${err.code}, message:${err.message}`);
        return;
      }
    }
    // 当前数据库存在并且版本为2，数据库需要从2版本升级到3版本
    if (storeVersion === 2) {
      // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS, IDENTITY)
      // => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
      try {
        await transaction.execute('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS');
        storeVersion = 3;
        await transaction.execute('PRAGMA user_version = 3');
        hilog.info(DOMAIN, 'rdbDataPersistence', 'Upgrade store version from 2 to 3 success.')
      } catch (e) {
        const err = e as BusinessError;
        await transaction.rollback();
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to execute sql. Code:${err.code}, message:${err.message}`);
        return;
      }
    }
    await transaction.commit();
    // 请确保获取到RdbStore实例，完成数据表创建后，再进行数据库的增、删、改、查等操作
  }
  // [End persistence_get_store]

  // [Start persistence_insert_data]
  // 插入数据
  let value1 = 'Lisa';
  let value2 = 18;
  let value3 = 100.5;
  let value4 = new Uint8Array([1, 2, 3, 4, 5]);
  let value5 = BigInt('15822401018187971961171');
  const valueBucket: relationalStore.ValuesBucket = {
    NAME: value1,
    AGE: value2,
    SALARY: value3,
    CODES: value4,
    IDENTITY: value5,
  };
  if (store !== undefined) {
    try {
      const rowId = await store.insert('EMPLOYEE', valueBucket);
      hilog.info(DOMAIN, 'rdbDataPersistence', `Succeeded in inserting data. rowId:${rowId}`);
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to insert data. Code:${err.code}, message:${err.message}`);
    }
  }
  // [End persistence_insert_data]

  // [Start persistence_update_and_delete_data]
  // 修改数据、删除数据
  let value6 = 'Rose';
  let value7 = 22;
  let value8 = 200.5;
  let value9 = new Uint8Array([1, 2, 3, 4, 5]);
  let value10 = BigInt('15822401018187971967863');
  const valueBucket2: relationalStore.ValuesBucket = {
    NAME: value6,
    AGE: value7,
    SALARY: value8,
    CODES: value9,
    IDENTITY: value10,
  };

  // 修改数据
  let predicates1 = new relationalStore.RdbPredicates('EMPLOYEE'); // 创建表'EMPLOYEE'的predicates
  predicates1.equalTo('NAME', 'Lisa'); // 匹配表'EMPLOYEE'中'NAME'为'Lisa'的字段
  if (store !== undefined) {
    (store as relationalStore.RdbStore).update(valueBucket2, predicates1, (err: BusinessError, rows: number) => {
      if (err) {
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to update data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(DOMAIN, 'rdbDataPersistence', `Succeeded in updating data. row count: ${rows}`);
    })
  }

  // 删除数据
  predicates1 = new relationalStore.RdbPredicates('EMPLOYEE');
  predicates1.equalTo('NAME', 'Lisa');
  if (store !== undefined) {
    (store as relationalStore.RdbStore).delete(predicates1, (err: BusinessError, rows: number) => {
      if (err) {
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to delete data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(DOMAIN, 'rdbDataPersistence', `Delete rows: ${rows}`);
    })
  }
  // [End persistence_update_and_delete_data]

  // [Start persistence_query_data]
  // 查找数据
  let predicates2 = new relationalStore.RdbPredicates('EMPLOYEE');
  predicates2.equalTo('NAME', 'Rose');
  if (store !== undefined) {
    (store as relationalStore.RdbStore).query(predicates2, ['ID', 'NAME', 'AGE', 'SALARY', 'CODES', 'IDENTITY'], (err: BusinessError, resultSet) => {
      if (err) {
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to query data. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(DOMAIN, 'rdbDataPersistence', `ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
      // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
      while (resultSet.goToNextRow()) {
        const id = resultSet.getLong(resultSet.getColumnIndex('ID'));
        const name = resultSet.getString(resultSet.getColumnIndex('NAME'));
        const age = resultSet.getLong(resultSet.getColumnIndex('AGE'));
        const salary = resultSet.getDouble(resultSet.getColumnIndex('SALARY'));
        const identity = resultSet.getValue(resultSet.getColumnIndex('IDENTITY'));
        hilog.info(DOMAIN, 'rdbDataPersistence', `id=${id}, name=${name}, age=${age}, salary=${salary}, identity=${identity}`);
      }
      // 释放数据集的内存
      resultSet.close();
    })
  }
  // [End persistence_query_data]

  // [Start persistence_chinese_query_data]
  // 中文关键字检索，查找数据
  if (store !== undefined && tokenTypeSupported) {
    // 创建全文检索表
    const SQL_CREATE_TABLE = 'CREATE VIRTUAL TABLE IF NOT EXISTS example USING fts4(name, content, tokenize=icu zh_CN)';
    try {
      await store.execute(SQL_CREATE_TABLE);
      hilog.info(DOMAIN, 'rdbDataPersistence', 'Succeeded in creating fts table.');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to creating fts table. code: ${err.code}, message: ${err.message}.`);
    }
  }
  if (store !== undefined) {
    try {
      const resultSet = await store.querySql('SELECT name FROM example WHERE example MATCH ?', ['测试']);
      while (resultSet.goToNextRow()) {
        const name = resultSet.getValue(resultSet.getColumnIndex('name'));
        hilog.info(DOMAIN, 'rdbDataPersistence', `name=${name}`);
      }
      resultSet.close();
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, 'rdbDataPersistence', `Query failed. code: ${err.code}, message: ${err.message}.`);
    }
  }
  // [End persistence_chinese_query_data]

  // [Start persistence_transaction_insert_update_and_delete_data]
  // 使用事务对象执行数据的插入、删除和更新操作
  if (store !== undefined) {
    // 创建事务对象
    try {
      const transaction = await store.createTransaction();
      try {
        // 使用事务对象插入数据
        const rowId = await transaction.insert(
          'EMPLOYEE',
          {
            NAME: 'Lisa',
            AGE: 18,
            SALARY: 100.5,
            CODES: new Uint8Array([1, 2, 3, 4, 5]),
            IDENTITY: BigInt('15822401018187971967763')
          },
          relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
        );
        hilog.info(DOMAIN, 'rdbDataPersistence', `Insert is successful, rowId = ${rowId}`);

        const predicates = new relationalStore.RdbPredicates('EMPLOYEE');
        predicates.equalTo('NAME', 'Lisa');
        // 使用事务对象更新数据
        const rows = await transaction.update(
          {
            NAME: 'Rose',
            AGE: 22,
            SALARY: 200.5,
            CODES: new Uint8Array([1, 2, 3, 4, 5]),
            IDENTITY: BigInt('15822401018187971967763')
          },
          predicates,
          relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
        );
        hilog.info(DOMAIN, 'rdbDataPersistence', `Updated row count: ${rows}`);

        // 使用事务对象删除数据
        await transaction.execute('DELETE FROM EMPLOYEE WHERE age = ? OR age = ?', [21, 20]);
        hilog.info(DOMAIN, 'rdbDataPersistence', `execute delete success`);

        // 提交事务
        await transaction.commit();
        hilog.info(DOMAIN, 'rdbDataPersistence', 'Transaction commit success.');
      } catch (error) {
        const err = error as BusinessError;
        // 执行失败回滚事务
        await transaction.rollback();
        hilog.error(DOMAIN, 'rdbDataPersistence', `Transaction execute failed, code is ${err.code}, message is ${err.message}`);
      }
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, 'rdbDataPersistence', `createTransaction failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  // [End persistence_transaction_insert_update_and_delete_data]

  // [Start persistence_backup_store]
  // 在同路径下备份数据库
  if (store !== undefined) {
    // 'Backup.db'为备份数据库文件名，默认在RdbStore同路径下备份。也可指定路径：customDir + 'Backup.db'
    (store as relationalStore.RdbStore).backup('Backup.db', (err: BusinessError) => {
      if (err) {
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to backup RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(DOMAIN, 'rdbDataPersistence', `Succeeded in backing up RdbStore.`);
    })
  }
  // [End persistence_backup_store]

  // [Start persistence_restore]
  // 备份数据库中恢复数据
  if (store !== undefined) {
    (store as relationalStore.RdbStore).restore('Backup.db', (err: BusinessError) => {
      if (err) {
        hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to restore RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      hilog.info(DOMAIN, 'rdbDataPersistence', `Succeeded in restoring RdbStore.`);
    })
  }
  // [End persistence_restore]

  // [Start persistence_delete_store]
  // 删除数据库
  const context = new UIContext().getHostContext() as common.UIAbilityContext;
  relationalStore.deleteRdbStore(context, 'RdbTest.db', (err: BusinessError) => {
    if (err) {
      hilog.error(DOMAIN, 'rdbDataPersistence', `Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    hilog.info(DOMAIN, 'rdbDataPersistence', 'Succeeded in deleting RdbStore.');
  });
  // [End persistence_delete_store]
}