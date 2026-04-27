/**
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

import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const PREFERENCE_TOKEN = 'my_prefs'

export class BooleanPreferences {
  private prefs: preferences.Preferences | null = null;
  // 接收上下文
  private readonly context: Context;
  private readonly prefKey: string;

  constructor(context: Context, _preferenceName: string = 'my_bool_prefs') {
    this.context = context;
    // 固定键名，若需要多值可扩展
    this.prefKey = 'bool_value';
  }

  async initialize(): Promise<void> {
    try {
      this.prefs = await preferences.getPreferences(this.context, this.prefKey);
    } catch (err) {
      console.error('Failed to initialize preferences:', err);
    }
  }

  async saveBoolean(value: boolean): Promise<void> {
    if (!this.prefs) {
      await this.initialize();
    }
    try {
      await this.prefs?.put(this.prefKey, value);
      await this.prefs?.flush();
    } catch (err) {
      console.error('Failed to save boolean:', err);
    }
  }

  async getBoolean(): Promise<boolean> {
    if (!this.prefs) {
      await this.initialize();
    }
    try {
      const value = await this.prefs?.get(this.prefKey, false);
      // 确保返回布尔类型
      return !!value;
    } catch (err) {
      console.error('Failed to read boolean:', err);
      return false;
    }
  }
}

export default class PreferenceUtils<T extends preferences.ValueType> {
  public context: Context
  public initValue: T

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
    console.log('setPreValue setPreValue', JSON.stringify(key), JSON.stringify(value))
  }

  getPreValue(key: string): T {
    const preInstance = this.getPres()
    let value = preInstance.getSync(key, this.initValue)
    console.log('getPreValue', value)
    console.log('getinitValue', this.initValue)
    return value as T
  }
}