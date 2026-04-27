/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const TAG = 'PreferencesManager：';
const PREFERENCE_TOKEN = 'myStore';

export default class PreferenceUtils<T extends preferences.ValueType> {
  private context: Context
  private initValue: T

  constructor(context: Context, initValue: T) {
    this.context = context;
    this.initValue = initValue;
  }

  getPres() {
    return preferences.getPreferencesSync(this.context, {
      name: PREFERENCE_TOKEN
    });
  }

  setPreValue(key: string, value: T) {
    try {
      const appStore = this.getPres();
      appStore.putSync(key, value);
      appStore.flush();
      console.log(TAG, 'setPreValue setPreValue', JSON.stringify(key), JSON.stringify(value));
    } catch (e) {
      console.log(TAG, 'setPreValue error', e);
    }
  }

  getPreValue(key: string): T {
    const preInstance = this.getPres();
    let value = preInstance.getSync(key, this.initValue);
    console.log(TAG,'getPreValue', value);
    console.log(TAG,'getinitValue', this.initValue);
    return value as T;
  }
}
