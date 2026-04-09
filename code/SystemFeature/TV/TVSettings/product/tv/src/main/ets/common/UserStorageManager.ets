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

import { common, Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { systemDateTime } from '@kit.BasicServicesKit';

export class UserStorageManger {
  public static context: common.UIAbilityContext
  public static preferenceTheme: preferences.Preferences | null = null

  static async putPreference(key: string, data: Object) {
    if (UserStorageManger.preferenceTheme !== null) {
      await UserStorageManger.preferenceTheme.put(key, data)
      await UserStorageManger.preferenceTheme.flush()
    }
  }

  static async getPreferencesFromStorage(key: string) {
    UserStorageManger.preferenceTheme = await preferences.getPreferences(UserStorageManger.context, key)
  }

  static async getPreference(key: string, defaultValue: object | string): Promise<object | string> {
    let theme: object | string = ''
    if (UserStorageManger.preferenceTheme !== null) {
      theme = await UserStorageManger.preferenceTheme.get(key, defaultValue) as object | string;
      return theme;
    }
    return theme;
  }
}


export class BooleanPreferences {
  private prefs: preferences.Preferences | null = null;
  private readonly context: Context;
  private readonly prefKey: string;

  constructor(context: Context, preferenceName: string = 'my_bool_prefs') {
    this.context = context;
    this.prefKey = preferenceName;
  }

  async initialize(): Promise<void> {
    try {
      this.prefs = await preferences.getPreferences(this.context, this.prefKey);
    } catch (err) {
      console.error('Failed to initialize preferences:', err);
    }
  }

  async saveBoolean(key: string,value: boolean): Promise<void> {
    if (!this.prefs) {
      await this.initialize();
    }
    try {
      await this.prefs?.put(key, value);
      await this.prefs?.flush();
    } catch (err) {
      console.error('Failed to save boolean:', err);
    }
  }

  async getBoolean(key: string): Promise<boolean> {
    if (!this.prefs) {
      await this.initialize();
    }
    try {
      const value = await this.prefs?.get(key, false);
      return !!value;
    } catch (err) {
      console.error('Failed to read boolean:', err);
      return false;
    }
  }


  async deletePreferences(): Promise<void> {
    try {
      await preferences.deletePreferences(this.context, this.prefKey);
      this.prefs = null;
    } catch (err) {
      console.error('Failed to delete preferences:', err);
    }
  }
}

export function getSystemStartTime():number {
  let openGetUptime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE)
  // 获取当前系统时间
  const time = new Date()
  const curTime = time.getTime()
  const systemStartTime = curTime - openGetUptime
  return systemStartTime
}

const PREFERENCE_TOKEN = 'my_prefs'

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

