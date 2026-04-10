/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { JSON } from '@kit.ArkTS';
import { preferences } from '@kit.ArkData';
import { DEFAULT_SWITCH_ITEM_VALUE } from '../pages/general/AutoScreenOff';

const TAG = '[PreferencesUtil]'

export class PreferencesUtil {
  static setParam(context: Context, name: string, key: string, value: string) {
    try {
      let preference = preferences.getPreferencesSync(context, { name: name })
      preference.putSync(key, value)
      preference.flush()
      console.debug(TAG, `save key=${key} value = ${value} success`)
    } catch (error) {
      console.debug(TAG, `save key=${key} value = ${value} fail ${JSON.stringify(error)}`)
    }
  }

  static getParam(context: Context, name: string, key: string): string {
    try {
      let preference = preferences.getPreferencesSync(context, { name: name })
      let value = preference.getSync(key, DEFAULT_SWITCH_ITEM_VALUE) as string
      if (value && value !== DEFAULT_SWITCH_ITEM_VALUE) {
        console.debug(TAG, `get key=${key} value = ${value} success`)
        return value;
      } else {
        console.debug(TAG, `get key=${key} value = null `)
        return DEFAULT_SWITCH_ITEM_VALUE;
      }
    } catch (error) {
      console.debug(TAG, `get key=${key} fail ${JSON.stringify(error)} `)
      return DEFAULT_SWITCH_ITEM_VALUE
    }
  }
}

const PREFERENCE_TOKEN = 'my_prefs'

export default class PreferenceUtils<T extends preferences.ValueType> {
  private context: Context
  private initValue: T

  constructor(context: Context, initValue: T) {
    this.context = context;
    this.initValue = initValue
  }

  getPres() {
    return preferences.getPreferencesSync(this.context, {
      name: PREFERENCE_TOKEN
    })
  }

  setPreValue(key: string, value: T) {
    const appStore = this.getPres()
    appStore.putSync(key, value)
    appStore.flush()
  }

  getPreValue(key: string): T {
    const preInstance = this.getPres()
    let value = preInstance.getSync(key, this.initValue)
    return value as T
  }
}
