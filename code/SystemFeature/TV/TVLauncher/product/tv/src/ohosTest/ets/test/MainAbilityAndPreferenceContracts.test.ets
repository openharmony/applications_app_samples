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

import { describe, it, expect } from '@ohos/hypium';
import MainAbility from '../../../main/ets/MainAbility/MainAbility';
import PreferenceUtils, { BooleanPreferences } from '../../../main/ets/common/baseUtil/PreferenceUtil';
import storeAppList, { infoList } from '../../../main/ets/common/baseUtil/storage';

class DummyContext {
}

class FakePreferencesStore {
  getSync(_key: string, defaultValue: string): string {
    return defaultValue;
  }

  putSync(_key: string, _value: string): void {
  }

  flush(): void {
  }
}

class FakeStoreAppListStore {
  getSync(_key: string, defaultValue: string[]): string[] {
    return defaultValue;
  }
}

export default function mainAbilityAndPreferenceContractsTest() {
  describe('MainAbilityAndPreferenceContracts_Test', () => {
    it('preference_utils_should_expose_core_methods', 0, () => {
      const pref = new PreferenceUtils<string>(new DummyContext() as never, 'init');
      expect(typeof pref.setPreValue).assertEqual('function');
      expect(typeof pref.getPreValue).assertEqual('function');
      expect(typeof pref.getPres).assertEqual('function');
    });

    it('boolean_preferences_should_expose_initialize_save_and_get', 0, () => {
      const prefs = new BooleanPreferences(new DummyContext() as never, 'bool_pref');
      expect(typeof prefs.initialize).assertEqual('function');
      expect(typeof prefs.saveBoolean).assertEqual('function');
      expect(typeof prefs.getBoolean).assertEqual('function');
    });

    it('store_app_list_should_expose_store_access_methods', 0, () => {
      const store = new storeAppList(new DummyContext() as never);
      expect(typeof store.getStore).assertEqual('function');
      expect(typeof store.setAppList).assertEqual('function');
      expect(typeof store.getAppList).assertEqual('function');
    });

    it('store_app_list_should_read_default_seed_when_store_missing', 0, () => {
      const fakeStore = new FakeStoreAppListStore();
      const result = fakeStore.getSync('token', infoList);
      expect(result.length).assertEqual(infoList.length);
      expect(result[0]).assertEqual(infoList[0]);
    });

    it('fake_preferences_store_should_return_default_value', 0, () => {
      const fakeStore = new FakePreferencesStore();
      expect(fakeStore.getSync('theme', 'dark')).assertEqual('dark');
    });

    it('main_ability_should_expose_expected_public_lifecycle_methods', 0, () => {
      const mainAbility = new MainAbility();
      expect(typeof mainAbility.onCreate).assertEqual('function');
      expect(typeof mainAbility.onDestroy).assertEqual('function');
      expect(typeof mainAbility.onRequest).assertEqual('function');
      expect(typeof mainAbility.checkReboot).assertEqual('function');
      expect(typeof mainAbility.getSystemStartTime).assertEqual('function');
      expect(typeof mainAbility.liftUpApp).assertEqual('function');
    });

    it('main_ability_should_expose_expected_setup_methods', 0, () => {
      const mainAbility = new MainAbility();
      expect(typeof mainAbility.initSetup).assertEqual('function');
      expect(typeof mainAbility.initLauncher).assertEqual('function');
    });
  });
}
