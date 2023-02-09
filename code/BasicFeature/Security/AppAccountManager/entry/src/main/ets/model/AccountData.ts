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

import Logger from '../model/Logger'
import appContext from '@ohos.application.context'
import preferences from '@ohos.data.preferences'


const TAG: string = '[AccountData]'

export class AccountData {
  static instance: AccountData = null
  private storage: preferences.Preferences = null

  public static getInstance() {
    if (this.instance === null) {
      this.instance = new AccountData()
    }
    return this.instance
  }

  async getFromStorage(context: appContext.Context, url: string) {
    let name = url
    Logger.info(TAG, `Name is ${name}`)
    try {
      this.storage = await preferences.getPreferences(context, `${name}`)
    } catch (err) {
      Logger.error(`getStorage failed, code is ${err.code}, message is ${err.message}`)
    }
    if (this.storage === null) {
      Logger.info(TAG, `Create stroage is fail.`)
    }
  }

  async getStorage(context: appContext.Context, url: string) {
    this.storage = null
    await this.getFromStorage(context, url)
    return this.storage
  }

  async putStorageValue(context: appContext.Context, key: string, value: string, url: string) {
    this.storage = await this.getStorage(context, url)
    try {
      await this.storage.put(key, value)
      await this.storage.flush()
      Logger.info(TAG, `put key && value success`)
    } catch (err) {
      Logger.info(TAG, `aaaaaa put failed`)
    }
    return
  }

  async hasStorageValue(context: appContext.Context, key: string, url: string) {
    this.storage = await this.getStorage(context, url)
    let result
    try {
      result = await this.storage.has(key)
    } catch (err) {
      Logger.error(`hasStorageValue failed, code is ${err.code}, message is ${err.message}`)
    }
    Logger.info(TAG, `hasStorageValue success result is ${result}`)
    return result
  }

  async getStorageValue(context: appContext.Context, key: string, url: string) {
    this.storage = await this.getStorage(context, url)
    let getValue
    try {
      getValue = await this.storage.get(key, 'null')
    } catch (err) {
      Logger.error(`getStorageValue failed, code is ${err.code}, message is ${err.message}`)
    }
    Logger.info(TAG, `getStorageValue success`)
    return getValue
  }

  async deleteStorageValue(context: appContext.Context, key: string, url: string) {
    this.storage = await this.getStorage(context, url)
    try {
      await this.storage.delete(key)
      await this.storage.flush()
    } catch (err) {
      Logger.error(`deleteStorageValue failed, code is ${err.code}, message is ${err.message}`)
    }
    Logger.info(TAG, `delete success`)
    return
  }
}