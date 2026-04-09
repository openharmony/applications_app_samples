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

import { preferences as data_preferences} from '@kit.ArkData'
import Logger from './Logger'
import { Reminder } from '../common/Reminder'
import { UIContext } from '@kit.ArkUI';

const TAG: string = 'Preferences'

class PreferencesDataManager {
  private context = UIContext.getCallingScopeUIContext()?.getHostContext()

  async getData(key: string) {
    let getValue: Reminder[] | undefined = undefined;
    if (this.context == undefined) {
      return getValue
    }
    try {
      let preferences = await data_preferences.getPreferences(this.context, 'ReminderAgentManager')
      if (await preferences.get(key, 'default')) {
        let result = await preferences.get(key, 'default') as string;
        getValue = JSON.parse(result)
        Logger.info(TAG, `this is ${JSON.stringify(getValue)}`)
      } else {
        Logger.info(TAG, `this abouttoappear is unexist`)
      }
    } catch (err) {
      Logger.error(TAG, `this getData err is ${JSON.stringify(err)} name is ${key}`)
    }
    return getValue
  }

  async putData(key: string, value: Reminder[]) {
    if (this.context == undefined) {
      return
    }
    try {
      let preferences = await data_preferences.getPreferences(this.context, 'ReminderAgentManager')
      await preferences.put(key, JSON.stringify(value))
      await preferences.flush()
    } catch (err) {
      Logger.error(TAG, `this perferences is failed, err is ${JSON.stringify(err)}`)
    }
  }
}

export default new PreferencesDataManager()