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

import preferences from '@ohos.data.preferences'
import { logger } from '@ohos/common'

const preferencesName: string = 'dataUser'
const TAG: string = 'PreferencesStore'

class PreferencesStore {
  private dataPreferences: preferences.Preferences = undefined

  async put(key, value) {
    if (this.dataPreferences === undefined) {
      this.dataPreferences = await preferences.getPreferences(getContext(this), preferencesName)
    }
    try {
      await this.dataPreferences.put(key, value)
      await this.dataPreferences.flush()
    } catch (err) {
      logger.error(TAG, `put error, ${JSON.stringify(err)}`)
    }
  }

  async get(key, defaultValue) {
    if (this.dataPreferences === undefined) {
      this.dataPreferences = await preferences.getPreferences(getContext(this), preferencesName)
    }
    try {
      return await this.dataPreferences.get(key, defaultValue)
    } catch (err) {
      logger.error(TAG, `put error, ${JSON.stringify(err)}`)
    }
  }
}

export default new PreferencesStore()