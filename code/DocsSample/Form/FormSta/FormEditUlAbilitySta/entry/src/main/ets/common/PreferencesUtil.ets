'use static'

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

// [Start FormEditUIAbilitySta_PreferencesUtil]
// entry/src/main/ets/common/PreferencesUtil.ets
import preferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'PreferencesUtil';
const MY_STORE: string = 'myStore';
const key: string = 'formID';
const DOMAIN = 0x0000;

export class PreferencesUtil {
  private static preferencesUtil: PreferencesUtil | null = null;

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.preferencesUtil) {
      PreferencesUtil.preferencesUtil = new PreferencesUtil();
    }
    return PreferencesUtil.preferencesUtil!;
  }

  getPreferences(context: common.Context): preferences.Preferences | undefined {
    try {
      preferences.removePreferencesFromCacheSync(context, MY_STORE);
      return preferences.getPreferencesSync(context, { name: MY_STORE });
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `getPreferences failed. code: ${error?.code}, message: ${error?.message}`);
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
      hilog.error(DOMAIN, TAG, `preferencesPut failed. code: ${error?.code}, message: ${error?.message}`);
    }
  }

  removePreferencesFromCache(context: common.Context): void {
    preferences.removePreferencesFromCache(context, MY_STORE).catch((err) => {
      hilog.error(DOMAIN, TAG, `removePreferencesFromCache failed. code: ${err?.code}, message: ${err?.message}`);
    });
  }

  getValue(preferences: preferences.Preferences): string | undefined {
    if (preferences === null) {
      hilog.error(DOMAIN, TAG, `preferences is null`);
      return undefined;
    }
    try {
      return preferences.getSync(key, '') as string
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `getSync failed. code: ${error?.code}, message: ${error?.message}`);
      return undefined;
    }
  }

  removeFormId(context: common.Context) {
    try {
      let preferences = this.getPreferences(context);
      if (!preferences) {
        hilog.error(DOMAIN, TAG, `preferences is null`);
        return;
      }
      if (preferences.hasSync(key)) {
        preferences.deleteSync(key);
        preferences.flushSync();
        hilog.info(DOMAIN, TAG, `deleteSync done.`)
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to get preferences. code: ${error?.code}, message: ${error?.message}`);
    }
  }
}

// [End FormEditUIAbilitySta_PreferencesUtil]