/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { Context } from '@ohos.arkui.UIContext';
import Logger from '../common/Logger';

export class DataPreferencesHelper {
  private preferences: dataPreferences.Preferences;

  public static EXTRA_ACTIVE_STATUS = 'extra_active_status';

  constructor(context: Context) {
    let options: dataPreferences.Options = { name: 'MdmSample' };
    this.preferences = dataPreferences.getPreferencesSync(context, options);
  }

  save(key: string, value: string) {
    if (this.preferences != null) {
      try {
        this.preferences.putSync(key, value);
        this.preferences.flush();
      } catch (err) {
        Logger.error('save data failed!');
      }
    }
  }

  get(key: string, defaultValue: string): string {
    let activeStatus: string = defaultValue;
    if (this.preferences != null) {
      activeStatus = this.preferences.getSync(key, defaultValue) as string;
    }
    return activeStatus;
  }
}