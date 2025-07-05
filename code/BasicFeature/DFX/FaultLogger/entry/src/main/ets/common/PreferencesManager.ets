/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { preferences as dataPreferences } from '@kit.ArkData';
import Logger from '../model/Logger';

const TAG = '[PreferencesMgr]';

export default class PreferencesManager {
  private dataPreferencesManager: dataPreferences.Preferences | undefined = undefined;

  constructor() {
    Logger.info(TAG, 'getPreferences start');
    this.dataPreferencesManager = dataPreferences.getPreferencesSync(AppStorage.get('context'),
      { name: 'myStore' });
    Logger.info(TAG, 'Succeeded in getting preferences');
  }

  /**
   * 存储获取到的fault信息
   * @param faultMessageName
   * @param faultMessage
   */
  public putFaultMessage(faultMessageName: string, faultMessage: string): void {
    Logger.info(TAG, `putMessage start`);
    try {
      let faultData = this.dataPreferencesManager?.getSync(faultMessageName, []) as string[];
      faultData.unshift(faultMessage);
      this.dataPreferencesManager?.put(faultMessageName, faultData);
      this.dataPreferencesManager?.flush();
      Logger.info(TAG, 'Succeeded in putting value of faultMessage');
    } catch (err) {
      Logger.error(TAG, `Failed to put value of 'catch err'. code =` + err.code + ', message =' + err.message);
    }
  }

  /**
   * 获取fault信息
   * @param faultMessageName
   * @returns
   */
  public getFaultMessage(faultMessageName: string): string {
    Logger.info(TAG, `getFaultMessage start`);
    try {
      let faultData = this.dataPreferencesManager?.getSync(faultMessageName, []) as string[];
      if (faultData.length !== 0) {
        Logger.info(TAG, 'Succeeded in getting value of faultMessage');
        return faultData[0];
      } else {
        Logger.info(TAG, 'No exception log was obtained');
        return 'No exception log was obtained';
      }
    } catch (err) {
      Logger.error(TAG, `Failed to get value of 'catch err'. code =` + err.code + ', message =' + err.message);
      return 'No exception log was obtained';
    }
  }

  /**
   * 获取所有fault信息
   * @returns
   */
  public getAllFaultMessage(): string {
    Logger.info(TAG, `getAllFaultMessage start`);
    try {
      let allFaultDataObj = this.dataPreferencesManager?.getAllSync();
      ;
      if (allFaultDataObj !== undefined && JSON.stringify(allFaultDataObj) !== '{}') {
        Logger.info(TAG, 'Succeeded in getting all value of faultMessage');
        let allFaultData: string = Object.values(allFaultDataObj)
          .reduce((result: string, prve: string) => result + '\n' + prve, '');
        return allFaultData;
      } else {
        Logger.info(TAG, 'No all exception log was obtained');
        return 'No exception log was obtained';
      }
    } catch (err) {
      Logger.error(TAG, `Failed to get all value of 'catch err'. code =` + err.code + ', message =' + err.message);
      return 'No exception log was obtained';
    }
  }
}