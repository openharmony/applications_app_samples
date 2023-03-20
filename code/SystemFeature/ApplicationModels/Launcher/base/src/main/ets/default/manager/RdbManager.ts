/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import dataRdb from '@ohos.data.relationalStore'
import { CheckEmptyUtils } from '../utils/CheckEmptyUtils'
import { CommonConstants } from '../constants/CommonConstants'
import { GridLayoutItemInfo } from '../bean/GridLayoutItemInfo'
import { GridLayoutInfoColumns } from '../bean/GridLayoutInfoColumns'
import { Logger } from '../utils/Logger'

export const TABLE_NAME: string = 'launcher'

export const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS launcher ' +
'(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
'app_name TEXT, ' +
'appIcon_id INTEGER, ' +
'container INTEGER, ' +
'type_id INTEGER, ' +
'card_id INTEGER, ' +
'card_name TEXT, ' +
'badge_number INTEGER, ' +
'module_name TEXT, ' +
'bundle_name TEXT, ' +
'ability_name TEXT, ' +
'area TEXT, ' +
'page INTEGER, ' +
'column INTEGER, ' +
'row INTEGER)'

export const STORE_CONFIG = { name: 'launcher.db', securityLevel: dataRdb.SecurityLevel.S1 }
const TAG: string = 'RdbModel'
class RdbManagerModel {
  private mRdbStore: dataRdb.RdbStore = undefined

  constructor() {
  }

  /**
   * initRdbConfig
   *
   * @param context
   */
  async initRdbConfig(context): Promise<void> {
    Logger.info(TAG, 'initRdbConfig start')
    this.mRdbStore = await dataRdb.getRdbStore(context, STORE_CONFIG)
    await this.mRdbStore.executeSql(SQL_CREATE_TABLE)
    Logger.info(TAG, 'create table end')
  }

  /**
   * deleteTable
   *
   * @param tableName
   */
  async deleteTable(tableName: string): Promise<void> {
    Logger.info(TAG, 'deleteTable start')
    try {
      let detelSql = `DELETE FROM ${tableName};`
      let detelSequenceSql = `UPDATE sqlite_sequence SET seq=0 WHERE name = '${tableName}';`
      await this.mRdbStore.executeSql(detelSql)
      await this.mRdbStore.executeSql(detelSequenceSql)
      Logger.debug(TAG, 'deleteTable end')
    } catch (e) {
      Logger.error(TAG, `deleteTable err: ${e}`)
    }
  }

  /**
   * insertData
   *
   * @param layoutInfo
   */
  async insertData(layoutInfo: any) {
    Logger.info(TAG, 'insertGridLayoutInfo start');
    let result: boolean = true
    if (CheckEmptyUtils.isEmpty(layoutInfo)) {
      Logger.error(TAG, 'insertGridLayoutInfo gridlayoutinfo is empty')
      result = false
      return result
    }
    try {
      // delete gridlayoutinfo table
      await this.deleteTable(TABLE_NAME)
      // insert into gridlayoutinfo
      for (let i in layoutInfo) {
        let layout = layoutInfo[i]
        for (let j in layout) {
          let element = layout[j]
          Logger.info(TAG, `insertGridLayoutInfo i= ${i}`)
          let item = {}
          if (element.typeId === CommonConstants.TYPE_APP) {
            item = {
              'app_name': element.appName,
              'bundle_name': element.bundleName,
              'module_name': element.modelName,
              'ability_name': element.abilityName,
              'appIcon_id': element.appIconId,
              'type_id': element.typeId,
              'area': element.area[0] + ',' + element.area[1],
              'page': element.page,
              'column': element.column,
              'row': element.row,
              'container': -100
            }
            let ret = await this.mRdbStore.insert(TABLE_NAME, item)
            Logger.debug(TAG, `insertGridLayoutInfo type is app ${i} ret: ${ret}`)
          } else if (element.typeId === CommonConstants.TYPE_CARD) {
            item = {
              'app_name': element.appName,
              'bundle_name': element.bundleName,
              'module_name': element.modelName,
              'ability_name': element.abilityName,
              'card_id': element.cardId,
              'card_name': element.cardName,
              'type_id': element.typeId,
              'area': element.area[0] + ',' + element.area[1],
              'page': element.page,
              'column': element.column,
              'row': element.row,
              'container': -100
            }
            let ret = await this.mRdbStore.insert(TABLE_NAME, item)
            Logger.debug(TAG, `insertGridLayoutInfo type is card ${i} ret: ${ret}`)
          }
        }
      }
    } catch (e) {
      Logger.error(TAG, `insertGridLayoutInfo error: ${e}`)
    }
    return result
  }

  async queryLayoutInfo() {
    Logger.info(TAG, 'queryLayoutInfo start')
    const resultList: GridLayoutItemInfo[] = []
    const predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.equalTo(GridLayoutInfoColumns.CONTAINER, -100)
      .and().orderByAsc('page').and().orderByAsc('row').and().orderByAsc('column')
    let resultSet = await this.mRdbStore.query(predicates)
    Logger.info(TAG, `queryLayoutInfo query,count=${resultSet.rowCount}`)
    let isLast = resultSet.goToFirstRow()
    while (isLast) {
      const layoutInfo: GridLayoutItemInfo = GridLayoutItemInfo.fromResultSet(resultSet)
      resultList.push(layoutInfo)
      isLast = resultSet.goToNextRow()
    }
    resultSet.close()
    resultSet = null
    return resultList
  }

  async insertItem(item: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(item)) {
      return
    }
    let element = {
      'app_name': item.appName,
      'module_name': item.moduleName,
      'bundle_name': item.bundleName,
      'ability_name': item.abilityName,
      'appIcon_id': item.appIconId,
      'card_id': item.cardId,
      'card_name': item.cardName,
      'type_id': item.typeId,
      'area': item.area[0] + ',' + item.area[1],
      'page': item.page,
      'column': item.column,
      'row': item.row,
      'container': -100
    }
    let ret = await this.mRdbStore.insert(TABLE_NAME, element)
    Logger.debug(TAG, `insertGridLayoutInfo ret: ${ret}`)
  }

  async deleteItemByPosition(page: number, row: number, column: number) {
    const predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.equalTo('page', page)
      .and().equalTo('row', row)
      .and().equalTo('column', column)
    let ret = await this.mRdbStore.delete(predicates)
    Logger.debug(TAG, `deleteItem ret: ${ret}`)
  }
}

export let RdbManager = new RdbManagerModel()