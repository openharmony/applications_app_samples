/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import {
  Entry,
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  List, Image, $r, AlphabetIndexer, Margin, ForEach, Color, TextAlign, ImageFit, JSON
} from '@ohos.arkui.component';
import relationalStore from '@ohos.data.relationalStore';
import type common from '@ohos.app.ability.common';
import { Contact } from '../model/Contact';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { STORE_CONFIG, SQL_CREATE_TABLE, TABLE_NAME } from '../constant/RdbConstant';
import { BusinessError } from '@ohos.base';
import { CommonConstants } from '../constant/CommonConstant';
import hilog from '@ohos.hilog';

class DatabaseConnection {
  private static instance: DatabaseConnection | undefined = undefined;
  public rdbStore: relationalStore.RdbStore | undefined = undefined;

  /**
   * 静态方法，用于获取数据库连接实例
   *
   * @returns 数据库实例
   */
  public static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance as DatabaseConnection;
  }

  /**
   * 初始化数据库
   *
   * @param context 上下文
   */
  public async initRdbStore(context: common.Context): Promise<void> {
    hilog.info(0x0000, 'testTag', 'init rdbStore begin');
    if (!context) {
      hilog.error(0x0000, 'testTag', 'initRdbStore context is invalid');
      return;
    }

    if (this.rdbStore) {
      hilog.error(0x0000, 'testTag', 'rdbStore is exist');
      return;
    }

    try {
      this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
      hilog.info(0x0000, 'testTag', 'getRdbStore succeed');
      await this.createTable();
    } catch (err: Error) {
      hilog.error(0x0000, 'testTag', `getRdbStore failed, err: ${err}`);
      return;
    }
  }

  /**
   * 创建数据库表
   */
  private async createTable(): Promise<void> {
    hilog.info(0x0000, 'testTag', 'create table begin');
    try {
      // 执行sql语句，联系人个各个属性设定
      if (this.rdbStore != undefined) {
        await (this.rdbStore as relationalStore.RdbStore).execute(SQL_CREATE_TABLE)
        hilog.info(0x0000, 'testTag', 'create table succeed');
        return;
      }
    } catch (err: Error) {
      hilog.error(0x0000, 'testTag', `create table failed,  err: ${err}`);
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
    hilog.info(0x0000, 'testTag', 'query begin');

    if (!context) {
      hilog.error(0x0000, 'testTag', 'context is null or undefined');
      return [] as Contact[];
    }

    try {
      this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
      const resultSet: relationalStore.ResultSet =
        await (this.rdbStore as relationalStore.RdbStore).querySql('select * from contact');
      // 处理查询到的结果数组
      return this.getListFromResultSet(resultSet);
    } catch (err: Error) {
      hilog.error(0x0000, 'testTag', 'query result error:' + JSON.stringify(err));
      return [] as Contact[];
    }
  }

  /**
   * 批量插入数据库
   */
  public async batchInsertData(context: common.Context, array: Array<Contact>): Promise<number> {
    hilog.info(0x0000, 'testTag', 'batch insert begin');
    if (!context) {
      hilog.error(0x0000, 'testTag', 'context is null or undefined');
    }

    if (!this.rdbStore) {
      hilog.info(0x0000, 'testTag', 'batch insert rdbStore is null');
      await this.initRdbStore(context);
    }

    let valueBuckets: relationalStore.ValuesBucket[] = [] as relationalStore.ValuesBucket[];

    for (let index = 0; index < array.length; index++) {
      let contactItem = array[index] as Contact;
      let value1 = contactItem.name;
      let value2 = contactItem.phone;
      let value3 = contactItem.email;
      let value4 = contactItem.address;
      let value5 = contactItem.avatar;
      let value6 = contactItem.category;

      const valueBucket: relationalStore.ValuesBucket = {
        'name': value1,
        'phone': value2,
        'email': value3,
        'address': value4,
        'avatar': value5,
        'category': value6
      }
      valueBuckets = [...valueBuckets, valueBucket];
      hilog.info(0x0000, 'testTag', 'valueBuckets:' + JSON.stringify(valueBuckets));
    }

    return (this.rdbStore as relationalStore.RdbStore).batchInsert(TABLE_NAME, valueBuckets).then((row: long)=>{
      hilog.info(0x0000, 'testTag', `batchInsert:${row}`);
      return row as number;
    }).catch((err: Error)=>{
      hilog.error(0x0000, 'testTag', 'batchInsert, err: ' + err);
      return 0 as number;
    })
    return 0 as number;
  }


  /**
   * 插入数据库
   */
  public async insertData(context: common.Context, contact: Contact): Promise<void> {
    hilog.info(0x0000, 'testTag', 'insert begin');
    if (!context) {
      hilog.info(0x0000, 'testTag', 'context is null or undefined');
    }

    this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);

    let value1 = contact.name;
    let value2 = contact.phone;
    let value3 = contact.email;
    let value4 = contact.address;
    let value5 = contact.avatar;
    let value6 = contact.category;

    const valueBucket: relationalStore.ValuesBucket = {
      'name': value1,
      'phone': value2,
      'email': value3,
      'address': value4,
      'avatar': value5,
      'category': value6
    }

    if (this.rdbStore != undefined) {
      (this.rdbStore as relationalStore.RdbStore)
        .insert(TABLE_NAME, valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE).then((row: long)=>{
        hilog.info(0x0000, 'testTag', `insert done:${row}`);
        return undefined;
      }).catch((err: Error)=>{
        hilog.error(0x0000, 'testTag', 'Insert failed, err: ' + err);
        return undefined;
      })
    }
  }

  /**
   * 删除操作
   */
  public async deleteData(context: common.Context, contact: Contact): Promise<void> {
    hilog.info(0x0000, 'testTag', 'delete begin');
    if (!context) {
      hilog.info(0x0000, 'testTag', 'context is null or undefined');
    }

    this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);

    hilog.info(0x0000, 'testTag', `delete name: ${contact.name}`);
    await (this.rdbStore as relationalStore.RdbStore).execute('DELETE FROM contact WHERE name = ?;', [contact.name]);
  }

  /**
   * 更新数据库
   */
  public async updateData(context: common.Context, contact: Contact): Promise<void> {
    hilog.info(0x0000, 'testTag', 'update begin');
    if (!context) {
      hilog.info(0x0000, 'testTag', 'context is null or undefined');
    }

    if (!this.rdbStore) {
      hilog.info(0x0000, 'testTag', 'update rdbStore is null');
      await this.initRdbStore(context);
    }
    let value1 = contact.name;
    let value2 = contact.phone;
    let value3 = contact.email;
    let value4 = contact.address;
    let value5 = contact.avatar;
    let value6 = contact.category;

    const valueBucket: relationalStore.ValuesBucket = {
      'name': value1,
      'phone': value2,
      'email': value3,
      'address': value4,
      'avatar': value5,
      'category': value6
    }


    if (this.rdbStore != undefined) {
      await (this.rdbStore as relationalStore.RdbStore).execute(
        'UPDATE contact SET phone = ?, email = ?, address = ? WHERE name = ?;', [value2, value3, value4, value1] )
    }
  }

  /**
   * 处理数据格式
   */
  getListFromResultSet(resultSet: relationalStore.ResultSet): Array<Contact> {
    // 声明结果变量
    let contacts: Contact[] = [] as Contact[];
    // 进入结果集的第一行
    resultSet.goToFirstRow();
    // 如果没有结束就继续遍历
    while (resultSet.goToNextRow()) {
      // 读取各个属性，初始化临时变量contact
      let contact: Contact = new Contact(
        resultSet.getString(resultSet.getColumnIndex('name')),
        resultSet.getString(resultSet.getColumnIndex('phone')),
        resultSet.getString(resultSet.getColumnIndex('email')),
        resultSet.getString(resultSet.getColumnIndex('address')),
        resultSet.getString(resultSet.getColumnIndex('avatar')),
        resultSet.getString(resultSet.getColumnIndex('category'))
      )

      const isDuplicate: boolean = contacts.some(
        (c: Contact) => c.name === contact.name && c.phone === contact.phone
      );

      if (!isDuplicate) {
        // 如果数据集合中没有这条数据就添加进去
        contacts.push(contact)
      }
      // 进入下一行
      resultSet.goToNextRow();
    }
    // 数据整合完毕就释放资源
    resultSet.close();
    hilog.info(0x0000, 'testTag', 'contacts number is ' + contacts.length);
    return contacts;
  }
}

export default DatabaseConnection;
