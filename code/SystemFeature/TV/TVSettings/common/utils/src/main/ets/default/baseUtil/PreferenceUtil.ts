/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import ConfigData from './ConfigData';
import LogUtil from './LogUtil'
//import Storage from '@ohos.data.storage';

//let preference = Storage.getStorageSync(ConfigData.PREFERENCES_PATH);
this.storage = await dataStorage.getPreferences(globalThis.settingsAbilityContext, ConfigData.PREFERENCES_PATH)

export class PreferenceUtil {
  /**
   * Set up storage data
   *
   * @param key - key
   * @param value - value
   */
  setStorageValue(key,value): void {
    LogUtil.info(`Set preference, key: ${key}, value: ${value}")`);
    preference.putSync(key, value);
    preference.flushSync();
  }

  /**
   * Get stored data
   *
   * @param key - key
   * @param defaultValue - defaultValue
   */
  getStorageValue(key: string, defaultValue) {
    let value = preference.getSync(key, defaultValue);
    LogUtil.info(`Get storage value, key: ${key}, value: ${value}`);
    return value;
  }
}

let preferenceUtil = new PreferenceUtil();
export default preferenceUtil as PreferenceUtil