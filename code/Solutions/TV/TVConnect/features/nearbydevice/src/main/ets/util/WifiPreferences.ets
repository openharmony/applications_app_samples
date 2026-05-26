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

import dataPreferences from '@ohos.data.preferences';

/*
 * 用户首选项管理
 * */
export class WifiPreferences {
  private static mPreferences: dataPreferences.Preferences | null = null;
  private static PREFER_NAME: string = 'wifiConnectPreferences';

  public static async initPreferences(): Promise<dataPreferences.Preferences> {
    return dataPreferences.getPreferences(getContext(), WifiPreferences.PREFER_NAME);
  }

  public static async put(key: string, value: dataPreferences.ValueType): Promise<boolean> {
    if (key == null || value == null) {
      return false;
    }
    try {
      if (WifiPreferences.mPreferences == null) {
        WifiPreferences.mPreferences = await WifiPreferences.initPreferences();
      }
      let keyValue = await WifiPreferences.mPreferences.get(key, '');
      if (!(JSON.stringify(keyValue) === JSON.stringify(value))) {
        await WifiPreferences.mPreferences.put(key, value);
        await WifiPreferences.mPreferences.flush();
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  public static async get(key: string, defaultValue: dataPreferences.ValueType): Promise<dataPreferences.ValueType> {
    if (key == null) {
      return defaultValue;
    }
    try {
      if (WifiPreferences.mPreferences == null) {
        WifiPreferences.mPreferences = await WifiPreferences.initPreferences();
      }
      let data: dataPreferences.ValueType = await WifiPreferences.mPreferences.get(key, defaultValue);
      return data;
    } catch (err) {
      return defaultValue;
    }
  }

  public static async getAll() {
    try {
      if (WifiPreferences.mPreferences == null) {
        WifiPreferences.mPreferences = await WifiPreferences.initPreferences();
      }
      let data = await WifiPreferences.mPreferences.getAll();
    } catch (err) {

    }
  }

  public static async clear(): Promise<boolean> {
    try {
      if (WifiPreferences.mPreferences == null) {
        WifiPreferences.mPreferences = await WifiPreferences.initPreferences();
      }
      await WifiPreferences.mPreferences?.clear();
      await WifiPreferences.mPreferences?.flush();
      return true;
    } catch (err) {
      return false;
    }
  }
}
