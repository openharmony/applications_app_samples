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

import ConfigData from './ConfigData';
import LogUtil from './LogUtil';
import { preferences } from '@kit.ArkData';

const configData = ConfigData

export class PreferenceUtil {
  private getPreference(): preferences.Preferences {
    return preferences.getPreferencesSync(globalThis.settingsAbilityContext, {
      name: configData.PREFERENCES_PATH
    })
  }

  setStorageValue<T extends preferences.ValueType>(key: string, value: T): void {
    LogUtil.info(`Set preference, key: ${key}, value: ${value}`);
    const preference = this.getPreference();
    preference.putSync(key, value);
    preference.flush();
  }

  getStorageValue<T extends preferences.ValueType>(key: string, defaultValue: T): T {
    const preference = this.getPreference();
    let value = preference.getSync(key, defaultValue) as T;
    LogUtil.info(`Get storage value, key: ${key}, value: ${value}`);
    return value;
  }
}

let preferenceUtil: PreferenceUtil = new PreferenceUtil();
export default preferenceUtil
