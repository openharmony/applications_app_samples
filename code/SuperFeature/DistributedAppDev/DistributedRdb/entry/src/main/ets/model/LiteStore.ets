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

import common from '@ohos.app.ability.common'
import preferences from '@ohos.data.preferences'
import Logger from '../model/Logger'

const TAG: string = 'LiteStore'

export enum SyncState {
  AutomaticSync = 'AutomaticSync',
  ManualSync = 'ManualSync'
}

class LiteStore {
  private store: preferences.Preferences | undefined = undefined
  private key: string = ''
  private context: common.UIAbilityContext

  constructor(key: string, context: common.UIAbilityContext) {
    this.key = key
    this.context = context
  }

  async setValue(value: preferences.ValueType) {
    if (this.store === undefined) {
      await this.getStore()
    }
    Logger.info(TAG, `setValue: ${value}`)
    if(this.store != undefined) {
      await this.store.put(this.key, value)
      await this.store.flush()
    }
  }

  async getValue(): Promise<preferences.ValueType | undefined> {
    if (this.store === undefined) {
      // 读取Preferences对象
      await this.getStore()
    }
    // 获取Preferences对象中的数据
    if(this.store != undefined) {
      let result = await this.store.get(this.key, 'ManualSync')
      Logger.info(TAG, `getValue: ${result}`)
      return result
    }
    return undefined
  }

  async getStore() {
    if (!this.context) {
      Logger.info(TAG, 'current context is undefined')
    }
    this.store = await preferences.getPreferences(this.context, 'rdb_mode')
  }
}

export default LiteStore