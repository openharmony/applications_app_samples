/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import rdb from '@ohos.data.relationalStore';
import promptAction from '@ohos.promptAction';
import type common from '@ohos.app.ability.common';
import { Contact } from '../model/Contact';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { STORE_CONFIG, SQL_CREATE_TABLE, TABLE_NAME } from '../constant/RdbConstant';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constant/CommonConstant';
import { logger } from '../utils/Logger';


const TAG = 'Database';

// TODO: 知识点：为保证插入并读取数据成功，建议一条数据不要超过2M。超出该大小，插入成功，读取失败。
class DatabaseConnection {
  private static instance: DatabaseConnection | undefined = undefined;
  public rdbStore: rdb.RdbStore | undefined = undefined;

  /**
   * 静态方法，用于获取数据库连接实例
   *
   * @returns 数据库实例
   */
  public static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance;
  }

  /**
   * 初始化数据库
   *
   * @param context 上下文
   */
  public async initRdbStore(context: common.Context): Promise<void> {
    logger.info(TAG, 'init rdbStore begin');
    if (!context) {
      logger.error(TAG, 'initRdbStore context is invalid');
      return;
    }

    if (this.rdbStore) {
      logger.info(TAG, 'rdbStore is exist');
      return;
    }

    try {
      this.rdbStore = await rdb.getRdbStore(context, STORE_CONFIG);
      logger.info(TAG, 'getRdbStore succeed');
      await this.createTable();
    } catch (err) {
      logger.error(TAG, `getRdbStore failed, err: ${err}`);
      return;
    }
  }

  /**
   * 创建数据库表
   */
  private async createTable(): Promise<void> {
    logger.info(TAG, 'create table begin');
    try {
      // 执行sql语句，联系人个各个属性设定
      if (this.rdbStore != undefined) {
        await this.rdbStore.executeSql(SQL_CREATE_TABLE)
        logger.info(TAG, 'create table succeed');
        return;
      }
    } catch (err) {
      logger.error(TAG, `create table failed,  err: ${err}`);
      return;
    }
  }

  /**
   * 查询数据库
   *
   * @param context 上下文
   * @param predicates predicates
   * @return ret | resultSet 结果
   */
  public async query(context: common.Context): Promise<Array<Contact>> {
    logger.info(TAG, 'query begin');

    if (!context) {
      logger.info(TAG, 'context is null or undefined');
      return [];
    }

    let predicates = new rdb.RdbPredicates(TABLE_NAME);
    predicates.orderByAsc('category')
    if (predicates === null || predicates === undefined) {
      logger.info(TAG, 'predicates is null or undefined');
      return [];
    }

    try {
      this.rdbStore = await rdb.getRdbStore(context, STORE_CONFIG);
      const resultSet: rdb.ResultSet =
        await this.rdbStore.query(predicates);
      logger.info(TAG, 'result is ' + JSON.stringify(resultSet.rowCount));
      // 处理查询到的结果数组
      return this.getListFromResultSet(resultSet);
    } catch (err) {
      logger.error(TAG, 'query result error:' + JSON.stringify(err));
      return [];
    }
  }

  /**
   * 批量插入数据库
   */
  public async batchInsertData(context: common.Context, array: Array<Contact>): Promise<number> {
    logger.info(TAG, 'batch insert begin');
    if (!context) {
      logger.info(TAG, 'context is null or undefined');
    }

    const predicates = new rdb.RdbPredicates(TABLE_NAME);
    if (predicates === null || predicates === undefined) {
      logger.info(TAG, 'predicates is null or undefined');
    }

    if (!this.rdbStore) {
      logger.info(TAG, 'batch insert rdbStore is null');
      await this.initRdbStore(context);
    }

    let valueBuckets: ValuesBucket[] = [];

    for (let index = 0; index < array.length; index++) {
      let contactItem = array[index] as Contact;
      let value1 = contactItem.name;
      let value2 = contactItem.phone;
      let value3 = contactItem.email;
      let value4 = contactItem.address;
      let value5 = contactItem.avatar;
      let value6 = contactItem.category;

      const valueBucket: ValuesBucket = {
        'name': value1,
        'phone': value2,
        'email': value3,
        'address': value4,
        'avatar': value5,
        'category': value6
      }
      valueBuckets.push(valueBucket);
    }

    if (this.rdbStore != undefined) {
      return await this.rdbStore.batchInsert(TABLE_NAME, valueBuckets);
    }
    return 0;
  }

  /**
   * 插入数据库
   */
  public async insertData(context: common.Context, contact: Contact): Promise<void> {
    logger.info(TAG, 'insert begin');
    if (!context) {
      logger.info(TAG, 'context is null or undefined');
    }

    const predicates = new rdb.RdbPredicates(TABLE_NAME);
    if (predicates === null || predicates === undefined) {
      logger.info(TAG, 'predicates is null or undefined');
    }

    this.rdbStore = await rdb.getRdbStore(context, STORE_CONFIG);

    let value1 = contact.name;
    let value2 = contact.phone;
    let value3 = contact.email;
    let value4 = contact.address;
    let value5 = contact.avatar;
    let value6 = contact.category;

    const valueBucket: ValuesBucket = {
      'name': value1,
      'phone': value2,
      'email': value3,
      'address': value4,
      'avatar': value5,
      'category': value6
    }

    if (this.rdbStore != undefined) {
      this.rdbStore.insert(TABLE_NAME, valueBucket, rdb.ConflictResolution.ON_CONFLICT_REPLACE,
        (err: BusinessError, rows: number) => {
          if (err) {
            logger.error(TAG, 'Insert failed, err: ' + err)
            return
          }
          logger.info(TAG, `insert done:${rows}`);
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_add_prompt_text', contact.name),
            duration: CommonConstants.PROMPT_DURATION_TIME
          });
        })
    }
  }

  /**
   * 删除操作
   */
  public async deleteData(context: common.Context, contact: Contact): Promise<void> {
    logger.info(TAG, 'delete begin');
    if (!context) {
      logger.info(TAG, 'context is null or undefined');
    }

    const predicates = new rdb.RdbPredicates(TABLE_NAME);
    if (predicates === null || predicates === undefined) {
      logger.info(TAG, 'predicates is null or undefined');
    }

    this.rdbStore = await rdb.getRdbStore(context, STORE_CONFIG);

    predicates.or().equalTo('id', contact.id);
    this.rdbStore.delete(predicates, (err: BusinessError, row: number) => {
      if (err) {
        logger.error(TAG, 'delete failed, err: ' + err)
        return;
      }
      logger.info(TAG, `delete contact success:${row}`);
      promptAction.showToast({
        message: $r('app.string.operate_rdb_in_taskpool_delete_prompt_text', contact.name),
        duration: CommonConstants.PROMPT_DURATION_TIME
      });
    });

  }

  /**
   * 更新数据库
   */
  public async updateData(context: common.Context, contact: Contact): Promise<void> {
    logger.info(TAG, 'update begin');
    if (!context) {
      logger.info(TAG, 'context is null or undefined');
    }

    const predicates = new rdb.RdbPredicates(TABLE_NAME);
    if (predicates === null || predicates === undefined) {
      logger.info(TAG, 'predicates is null or undefined');
    }

    if (!this.rdbStore) {
      logger.info(TAG, 'update rdbStore is null');
      await this.initRdbStore(context);
    }
    let value1 = contact.name;
    let value2 = contact.phone;
    let value3 = contact.email;
    let value4 = contact.address;
    let value5 = contact.avatar;
    let value6 = contact.category;

    const valueBucket: ValuesBucket = {
      'name': value1,
      'phone': value2,
      'email': value3,
      'address': value4,
      'avatar': value5,
      'category': value6
    }

    predicates.equalTo('id', contact.id);

    if (this.rdbStore != undefined) {
      this.rdbStore.update(valueBucket, predicates, rdb.ConflictResolution.ON_CONFLICT_REPLACE,
        (err: BusinessError, row: number) => {
          if (err) {
            logger.error(TAG, 'updated failed, err: ' + err);
            return
          }
          logger.info(TAG, `update done:${row}`);
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_update_prompt_text', contact.name),
            duration: CommonConstants.PROMPT_DURATION_TIME
          });
        })
    }
  }

  /**
   * 处理数据格式
   */
  getListFromResultSet(resultSet: rdb.ResultSet): Array<Contact> {
    // 声明结果变量
    let contacts: Contact[] = [];
    // 进入结果集的第一行
    resultSet.goToFirstRow();
    // 如果没有结束就继续遍历
    while (!resultSet.isEnded) {
      // 读取各个属性，初始化临时变量contact
      let contact: Contact = new Contact(
        resultSet.getDouble(resultSet.getColumnIndex('id')),
        resultSet.getString(resultSet.getColumnIndex('name')),
        resultSet.getString(resultSet.getColumnIndex('phone')),
        resultSet.getString(resultSet.getColumnIndex('email')),
        resultSet.getString(resultSet.getColumnIndex('address')),
        resultSet.getString(resultSet.getColumnIndex('avatar')),
        resultSet.getString(resultSet.getColumnIndex('category'))
      )
      if (!contacts.includes(contact)) {
        // 如果数据集合中没有这条数据就添加进去
        contacts.push(contact);
      }
      // 进入下一行
      resultSet.goToNextRow();
    }
    // 数据整合完毕就释放资源
    resultSet.close();
    logger.info(TAG, 'contacts number is ' + contacts.length);
    // 返回整合的联系人数据
    promptAction.showToast({
      message: $r('app.string.operate_rdb_in_taskpool_query_prompt_text', contacts.length),
      duration: CommonConstants.PROMPT_DURATION_TIME
    });
    return contacts;
  }
}

export default DatabaseConnection;

