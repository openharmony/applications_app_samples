/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import data_rdb from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import Contact from '../model/Contact'
import Logger from '../model/Logger'
import { STORE_CONFIG } from '../model/RdbConst'

const TAG = 'RdbModel'

export default class RdbModel {
  private rdbStore: data_rdb.RdbStore = undefined
  private tableName: string = ''
  private sqlCreateTable: string = ''
  private columns: Array<string> = []
  private distributedTable: string = ''
  private dataChangeCallback = null
  private isCreateDbDone: boolean = false
  private context: common.UIAbilityContext

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>, context: common.UIAbilityContext) {
    this.tableName = tableName
    this.sqlCreateTable = sqlCreateTable
    this.columns = columns
    this.context = context

    this.getRdbStore()
  }

  async getRdbStore() {
    Logger.info(TAG, 'getRdbStore begin')
    if (this.isCreateDbDone) {
      return
    }
    this.rdbStore = await data_rdb.getRdbStore(this.context, STORE_CONFIG)
    Logger.info(TAG, 'getRdbStore end')
    try {
      await this.rdbStore.executeSql(this.sqlCreateTable)
      await this.rdbStore.setDistributedTables([this.tableName])
    } catch (e) {
      Logger.error(TAG, 'getRdbStore:' + JSON.stringify(e))
    }
    this.isCreateDbDone = true
    Logger.info(TAG, 'create table done')
  }

  async insertData(contact: Contact) {
    const valueBucket = {
      'name': contact.name,
      'gender': contact.gender,
      'phone': contact.phone,
      'remark': contact.remark
    }
    let ret = await this.rdbStore.insert(this.tableName, valueBucket)
    Logger.info(TAG, `insert done:${ret}`)
  }

  async updateData(contact: Contact) {
    const valueBucket = {
      'name': contact.name,
      'gender': contact.gender,
      'phone': contact.phone,
      'remark': contact.remark
    }
    let predicates = new data_rdb.RdbPredicates(this.tableName)
    Logger.info(TAG, `updateData id=${contact.id}`)
    predicates.equalTo('id', contact.id)
    let ret = await this.rdbStore.update(valueBucket, predicates)
    Logger.info(TAG, `updated row count: ${ret}`)
  }

  async deleteContacts(contacts: Array<Contact>) {
    let predicates = new data_rdb.RdbPredicates(this.tableName)
    contacts.forEach((contact) => {
      predicates.or()
        .equalTo('id', contact.id)
    })
    let rows = await this.rdbStore.delete(predicates)
    Logger.info(TAG, `delete rows: ${rows}`)
  }

  async query(predicates): Promise<Array<Contact>> {
    Logger.info(TAG, 'query start')
    Logger.info(TAG, 'predicates is ' + JSON.stringify(predicates))
    Logger.info(TAG, 'columns ' + JSON.stringify(this.columns))
    let resultSet = await this.rdbStore.query(predicates, this.columns)
    Logger.info(TAG, 'result is ' + JSON.stringify(resultSet.rowCount))
    return this.getListFromResultSet(resultSet)
  }

  async syncData(predicates) {
    Logger.info(TAG, 'syncData')
    let result = await this.rdbStore.sync(data_rdb.SyncMode.SYNC_MODE_PUSH, predicates)
    for (let i = 0; i < result.length; i++) {
      Logger.info(TAG, `device=${result[i][0]}, status = ${result[i][1]}`)
    }
  }

  async onDataChange(device, callback) {
    this.distributedTable = await this.rdbStore.obtainDistributedTableName(device, this.tableName)
    Logger.info(TAG, `obtainDistributedTableName,distributedTable=` + this.distributedTable)
    this.dataChangeCallback = callback
    await this.pullData()
    this.rdbStore.on('dataChange', data_rdb.SubscribeType.SUBSCRIBE_TYPE_REMOTE, async (devices) => {
      Logger.info(TAG, `on dataChange, callback`)
      await this.pullData()
    })
  }

  async pullData() {
    await this.rdbStore.executeSql('delete from ' + this.tableName)
    let predicates = new data_rdb.RdbPredicates(this.distributedTable)
    let resultSet = await this.rdbStore.query(predicates, this.columns)
    let result = this.getListFromResultSet(resultSet)
    Logger.info(TAG, `on dataChange,result.length=${result.length}`)
    for (let i = 0; i < result.length; i++) {
      Logger.info(TAG, `on dataChange,insert${result[i].name}`)
      let predicate = new data_rdb.RdbPredicates(this.tableName)
      predicate.equalTo('name', result[i].name)
      let exit = await this.rdbStore.query(predicate, this.columns)
      exit.goToFirstRow()
      if (exit.rowCount === 0) {
        await this.insertData(result[i])
      } else {
        result[i].id = exit.getDouble(resultSet.getColumnIndex('id'))
        await this.updateData(result[i])
      }
    }
    this.dataChangeCallback(result)
  }

  offDataChange() {
    this.rdbStore.off('dataChange', data_rdb.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (devices) => {
      for (let i = 0; i < devices.length; i++) {
        Logger.info(TAG, `device=${devices[i]} off data changed`)
      }
    })
  }

  getListFromResultSet(resultSet): Array<Contact> {
    let contacts: Array<Contact> = []
    resultSet.goToFirstRow()
    while (!resultSet.isEnded) {
      let contact = new Contact(resultSet.getDouble(resultSet.getColumnIndex('id'))
        , resultSet.getString(resultSet.getColumnIndex('name'))
        , resultSet.getDouble(resultSet.getColumnIndex('gender'))
        , resultSet.getString(resultSet.getColumnIndex('phone'))
        , resultSet.getString(resultSet.getColumnIndex('remark')))
      if (!contacts.includes(contact)) {
        contacts.push(contact)
      }
      resultSet.goToNextRow()
    }
    resultSet.close()
    Logger.info(TAG, 'contacts number is ' + contacts.length)
    return contacts
  }
}

//export default new RdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS)