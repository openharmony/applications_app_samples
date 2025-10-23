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
// [Start FormEditDemo_PreferencesUtil]
// entry/src/main/ets/common/PreferencesUtil.ets
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { FormData } from './CommonData';

const TAG: string = 'PreferencesUtil';
const MY_STORE: string = 'myStore';

export class PreferencesUtil {
  private static preferencesUtil: PreferencesUtil;

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.preferencesUtil) {
      PreferencesUtil.preferencesUtil = new PreferencesUtil();
    }
    return PreferencesUtil.preferencesUtil;
  }

  getPreferences(context: Context): preferences.Preferences | undefined {
    try {
      preferences.removePreferencesFromCacheSync(context, MY_STORE);
      return preferences.getPreferencesSync(context, { name: MY_STORE });
    } catch (error) {
      let err = error as BusinessError;
      console.error(TAG, `getPreferences failed, error code=${err.code}, message=${err.message}`);
      return undefined;
    }
  }

  preferencesFlush(preferences: preferences.Preferences) {
    preferences.flush((err) => {
      if (err) {
        console.error(TAG, `Failed to flush. Code:${err.code}, message:${err.message}`);
      }
    })
  }

  preferencesPut(preferences: preferences.Preferences, formID: string, value: FormData): void {
    try {
      preferences.putSync(formID, value);
      this.preferencesFlush(preferences);
    } catch (error) {
      let err = error as BusinessError;
      console.error(TAG, `preferencesPut failed, error code=${err.code}, message=${err.message}`);
    }
  }

  removePreferencesFromCache(context: Context): void {
    preferences.removePreferencesFromCache(context, MY_STORE).catch((err: BusinessError) => {
      console.error(TAG, `removePreferencesFromCache failed, error code=${err.code}, message=${err.message}`);
    });
  }

  getValue(preferences: preferences.Preferences, formID: string): FormData | undefined {
    if (preferences === null) {
      console.error(TAG, `preferences is null`);
      return undefined;
    }
    try {
      return preferences.getSync(formID, new FormData('')) as FormData;
    } catch (error) {
      let err = error as BusinessError;
      console.error(TAG, `getSync failed, error code=${err.code}, message=${err.message}`);
      return undefined;
    }
  }

  removeFormId(context: Context, formId: string) {
    try {
      let preferences = this.getPreferences(context);
      if (!preferences) {
        console.error(TAG, `preferences is null`);
        return;
      }
      if (preferences.hasSync(formId)) {
        preferences.deleteSync(formId);
        this.preferencesFlush(preferences);
      }
    } catch (error) {
      console.error(TAG, `Failed to get preferences. Code:${error.code}, message:${error.message}`);
    }
  }
}
// [End FormEditDemo_PreferencesUtil]