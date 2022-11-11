/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import dataAbility from '@ohos.data.dataAbility'
import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@ohos.prompt'
import Logger from '../util/Logger'
import { DA_HELPER, BASE_URI, COLUMNS } from '../model/DaHelperConst'

const TAG: string = 'DataAbilityHelper'

// 对应Stage模型DataShareHelper
class DataAbilityHelper {
  private resultSet: any

  // 在指定的远程路径中打开文件
  openFile() {
    DA_HELPER.openFile(BASE_URI, 'rwt', (err, data) => {
      Logger.info(TAG, `openFile err = ${JSON.stringify(err)}, fd = ${data}`)
      prompt.showToast({
        message: 'openFile success'
      })
    })
  }

  // 注册观察者以观察给定uri指定的数据
  on() {
    DA_HELPER.on('dataChange', BASE_URI, () => {
      Logger.info(TAG, `on dataChange`)
      prompt.showToast({
        message: 'on dataChange success'
      })
    })
  }

  // 注销观察者以停止观察给定uri指定的数据
  off() {
    DA_HELPER.off('dataChange', BASE_URI, () => {
      Logger.info(TAG, `off dataChange`)
      prompt.showToast({
        message: 'off dataChange success'
      })
    })
  }

  // 获取给定URI指定数据的MIME类型
  getType() {
    DA_HELPER.getType(BASE_URI, (err, data) => {
      Logger.info(TAG, `getType err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: 'getType success'
      })
    })
  }

  // 获取支持的文件的MIME类型
  getFileTypes() {
    DA_HELPER.getFileTypes(BASE_URI, 'image/*', (err, data) => {
      Logger.info(TAG, `getFileTypes err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: 'getFileTypes success'
      })
    })
  }

  // 将引用数据功能的给定uri转换为规范化uri，Stage模型DataShareHelper的normalizeUri
  normalizeUri() {
    DA_HELPER.normalizeUri(BASE_URI, (err, data) => {
      Logger.info(TAG, `normalizeUri err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: 'normalizeUri success'
      })
    })
  }

  // 将由normalizeUri（uri）生成的给定规范化uri转换为非规范化uri，Stage模型DataShareHelper的denormalizeUri
  denormalizeUri() {
    DA_HELPER.denormalizeUri(BASE_URI, (err, data) => {
      Logger.info(TAG, `denormalizeUri err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: 'denormalizeUri success'
      })
    })
  }

  // 通知已注册的观察者uri指定的数据资源的更改，Stage模型DataShareHelper的notifyChange
  notifyChange() {
    DA_HELPER.notifyChange(BASE_URI, (err) => {
      Logger.info(TAG, `notifyChange success, err = ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'notifyChange success'
      })
    })
  }

  // 调用DataAbility的扩展接口
  async call() {
    Logger.info(TAG, `call success err`)
    await DA_HELPER.call(BASE_URI, 'insert', BASE_URI, { 'key1': 'value1' }).then((data) => {
      Logger.info(TAG, `call success = ${JSON.stringify(data)}`)
      prompt.showToast({
        message:  $r('app.string.call_success')
      })
    }).catch((err) => {
      Logger.error(TAG, `call err = ${err}`)
      prompt.showToast({
        message:  $r('app.string.call_fail')
      })
    })
  }

  // 查询数据库中的数据
  executeBatch() {
    let operations = new Array()
    operations.push({ uri: BASE_URI, type: featureAbility.DataAbilityOperationType.TYPE_INSERT,
      valuesBucket: { name: 'Book name', introduction: 'Book introduction' } })
    DA_HELPER.executeBatch(BASE_URI, operations, (err, data) => {
      Logger.info(TAG, `executeBatch success err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: 'executeBatch success'
      })
    })
  }

  // 添加数据,对应Stage模型中DataShareHelper的insert
  async insertBook() {
    Logger.info(TAG, `insert onClick`)
    let valuesBuckets = { name: 'Book name', introduction: 'Book introduction' }
    let num = await DA_HELPER.insert(BASE_URI, valuesBuckets)
    Logger.info(TAG, `insert num= ${num}`)
    this.resultSet = await this.queryAll()
    return this.resultSet
  }

  // 查询所有数据,对应Stage模型中DataShareHelper的queryAll
  async queryAll() {
    Logger.info(TAG, `queryAll start`)
    let dahelper = featureAbility.acquireDataAbilityHelper(BASE_URI)
    let predicates = new dataAbility.DataAbilityPredicates()
    return await dahelper.query(BASE_URI, COLUMNS, predicates)
  }

  // 修改数据,对应stage模型中DataShareHelper的updateBook
  async updateBook(book) {
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.equalTo('id', book.id)
    let valuesBucket = {
      'name': book.name,
      'introduction': book.introduction
    }
    let num = await DA_HELPER.update(BASE_URI, valuesBucket, predicates)
    Logger.info(TAG + `update book num= ${num}`)
    this.resultSet = await this.queryAll()
    return this.resultSet
  }

  // 删除指定数据,对应Stage模型中DataShareHelper的deleteBook
  async deleteBook(book) {
    if (book === null) {
      return
    }
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.equalTo('id', book.id)
    let num = await DA_HELPER.delete(BASE_URI, predicates)
    Logger.info(TAG, `delete num= ${num}`)
    this.resultSet = await this.queryAll()
    return this.resultSet
  }
}

export default new DataAbilityHelper()