/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import common from '@ohos.app.ability.common';
import { MediaFileUri } from './FileManager';
import Logger from '../util/Logger';
import { TestDlpFileInfo } from '../feature/DlpManager';
import { BusinessError } from '@ohos.base';

let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
let dataPreferencesManager: dataPreferences.Preferences = {} as dataPreferences.Preferences;


export class PreferencesManager {
  private mediaFileUri: MediaFileUri = new MediaFileUri();

  async getPreferences() {
    try {
      dataPreferences.getPreferences(context, 'myStore', (err: BusinessError, val: dataPreferences.Preferences) => {
        if (err) {
          Logger.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
          return;
        }
        dataPreferencesManager = val;
        this.getDlpFileInfos();
        Logger.info("Succeeded in getting preferences.");
      })
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      Logger.error("Failed to get preferences. code =" + code + ", message =" + message);
    }
  }

  async putDlpFileInfos(dlpFileInfos: Array<TestDlpFileInfo>) {
    try {
      dataPreferencesManager.put('dlpFileInfos', JSON.stringify(dlpFileInfos), async (err: BusinessError) => {
        if (err) {
          Logger.error("Failed to put value of 'dlpFileInfos'. code =" + err.code + ", message =" + err.message);
          return;
        }
        Logger.info("Succeeded in putting value of 'dlpFileInfos'.");
        dataPreferencesManager.flush();
      })
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      Logger.error("Failed to put value of 'dlpFileInfos'. code =" + code + ", message =" + message);
    }
  }

  async getDlpFileInfos() {
    try {
      let dlpFileInfos: Array<TestDlpFileInfo> = [];
      let promise = dataPreferencesManager.get('dlpFileInfos', []);
      promise.then(async (data: dataPreferences.ValueType) => {
        if (typeof data === 'string') {
          let dlpFileInfos: Array<TestDlpFileInfo> = JSON.parse(data);
          AppStorage.set('dlpFileInfos', dlpFileInfos);
          await this.mediaFileUri.getAllFiles(context, dlpFileInfos);
          Logger.info("Succeeded in getting value of 'dlpFileInfos'. dlpFileInfos: " + JSON.stringify(dlpFileInfos));
        } else {
          await this.mediaFileUri.getAllFiles(context, dlpFileInfos);
        }
      })
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      Logger.error("Failed to get value of 'dlpFileInfos'. code =" + code + ", message =" + message);
    }
  }
}