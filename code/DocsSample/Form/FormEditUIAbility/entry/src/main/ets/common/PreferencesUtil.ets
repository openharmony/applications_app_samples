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
// [Start FormEditUIAbility_PreferencesUtil]
// entry/src/main/ets/common/PreferencesUtil.ets
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'PreferencesUtil';
const MY_STORE: string = 'myStore';
const key: string = 'formID';

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
    preferences.flushSync();
  }

  preferencesPut(preferences: preferences.Preferences, formID: string): void {
    try {
      preferences.putSync(key, formID);
      preferences.flushSync();
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

  getValue(preferences: preferences.Preferences): string | undefined {
    if (preferences === null) {
      console.error(TAG, `preferences is null`);
      return undefined;
    }
    try {
      return preferences.getSync(key, '') as string
    } catch (error) {
      let err = error as BusinessError;
      console.error(TAG, `getSync failed, error code=${err.code}, message=${err.message}`);
      return undefined;
    }
  }

  removeFormId(context: Context) {
    try {
      let preferences = this.getPreferences(context);
      if (!preferences) {
        console.error(TAG, `preferences is null`);
        return;
      }
      if (preferences.hasSync(key)) {
        preferences.deleteSync(key);
        preferences.flushSync();
        console.info(TAG, `deleteSync done.`)
      }
    } catch (error) {
      console.error(TAG, `Failed to get preferences. Code:${error.code}, message:${error.message}`);
    }
  }
}
// [End FormEditUIAbility_PreferencesUtil]