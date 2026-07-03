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
import promptAction from '@ohos.promptAction';
import { Logger } from '@ohos/common';
import PreferenceConstants from '../constants/PreferenceConstants';
import { common } from '@kit.AbilityKit';
import { IpBean, IpDeviceInfo } from './IpDeviceModel';


let preference: dataPreferences.Preferences;

export default class PreferenceModel {
  private static instance: PreferenceModel = new PreferenceModel();

  static getInstance(): PreferenceModel {
    return PreferenceModel.instance;
  }

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  /**
   * Read the specified Preferences persistence file and load the data into the Preferences instance.
   */
  async getPreferencesFromStorage() {
    try {
      preference = await dataPreferences.getPreferences(this.context, PreferenceConstants.PREFERENCES_NAME);
    } catch (err) {
      Logger.error(PreferenceConstants.TAG, `===>Failed to get preferences, Cause: ${err}`);
    }
  }

  /**
   * Save the data to the Preferences.
   */
  async putPreference(keyName: string, info: string) {
    Logger.info(PreferenceConstants.TAG, `===>keyName: ${keyName}, ${info}`);
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    // The name and data entered by the user are saved to the cached Preference instance.
    try {
      await preference.put(keyName, info);
    } catch (err) {
      Logger.error(PreferenceConstants.TAG, `===>Failed to put value, Cause: ${err}`);
    }
    // Store the Preference instance in the preference persistence file
    await preference.flush();
  }

  /**
   * Get preference data.
   */
  async getPreference<T>(keyName: string): Promise<T> {
    let value = '';
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    try {
      value = (await preference.get(keyName, '')).toString();
      Logger.info(PreferenceConstants.TAG, `===>getPreference keyName: ${keyName}, ${value}`);
    } catch (err) {
      Logger.error(PreferenceConstants.TAG, `===>getPreference Failed to get value, Cause: ${err}`);
    }
    return JSON.parse(value);
  }

  async deletePreferences(keyName: string) {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    try {
      await preference.delete(keyName);
      await preference.flush();
      let ipArray: IpBean[] = await this.getPreference(PreferenceConstants.PREFERENCE_IP_ARRAY_KEY);
      let newIpArray = ipArray.filter(item => item.ip !== keyName);
      await this.putPreference(PreferenceConstants.PREFERENCE_IP_ARRAY_KEY, JSON.stringify(newIpArray));
    } catch (err) {
      Logger.error(PreferenceConstants.TAG, `Failed to delete preference, Cause: ${err}`);
    }
    ;
  }

  async getAllIpDevices(): Promise<IpDeviceInfo[]> {
    let allIpDevices: IpDeviceInfo[] = [];
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    let storeIds: IpBean[] = await this.getPreference(PreferenceConstants.PREFERENCE_IP_ARRAY_KEY);
    Logger.info(PreferenceConstants.TAG, `===>getAllIpDevices storeIds: ${JSON.stringify(storeIds)}`);
    if (!Array.isArray(storeIds) || storeIds.length === 0) {
      return [];
    }
    const promises = storeIds.map(async (item: IpBean) => {
      try {
        const ipDeviceInfo: IpDeviceInfo = await this.getPreference(item.ip);
        return ipDeviceInfo;
      } catch (err) {
        Logger.error(PreferenceConstants.TAG, `Load failed for ${item.ip}: ${err}`);
        return null;
      }
    });
    const results = await Promise.all(promises);
    allIpDevices = results.filter(device => device !== null) as IpDeviceInfo[];
    return allIpDevices;
  }
};