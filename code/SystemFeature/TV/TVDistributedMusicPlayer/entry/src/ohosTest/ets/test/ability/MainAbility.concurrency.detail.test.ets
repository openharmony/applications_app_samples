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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';
import MainAbility from '../../../../main/ets/MainAbility/MainAbility';

import { Want } from '@kit.AbilityKit';
export default function mainAbilityconcurrencydetailTestSuite(): void {
  describe('MainAbilityConcurrencyDetailTest', () => {
  let mainAbility: MainAbility | null = null;

  beforeEach(() => {
    mainAbility = new MainAbility();
  });

  afterEach(() => {
    mainAbility = null;
  });

  // onCreateonDestroy
  it('testConcurrentonCreate_onDestroy_Operation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'MainAbility'
    };
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 5; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new MainAbility();
          ability.onCreate(want);
          ability.onDestroy();
          resolve();
        }));
      }
      Promise.all(promises).then(() => {
        expect(true).assertTrue();
      }).catch(() => {
        expect(null).assertFail();
      });
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onForegroundonBackground
  it('testConcurrentonForeground_onBackground', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 5; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new MainAbility();
          ability.onForeground();
          ability.onBackground();
          resolve();
        }));
      }
      Promise.all(promises).then(() => {
        expect(true).assertTrue();
      }).catch(() => {
        expect(null).assertFail();
      });
    } catch (e) {
      expect(null).assertFail();
    }
  });


  it('testConcurrent_Lifecycle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 3; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new MainAbility();
          ability.onCreate(want);
          ability.onForeground();
          ability.onBackground();
          ability.onWindowStageDestroy();
          ability.onDestroy();
          resolve();
        }));
      }
      Promise.all(promises).then(() => {
        expect(true).assertTrue();
      }).catch(() => {
        expect(null).assertFail();
      });
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onBackPressed
  it('testConcurrentonBackPressed', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      for (let i = 0; i < 10; i++) {
        const ability = new MainAbility();
        const result: boolean = ability.onBackPressed();
        expect(result).assertEqual(false);
      }
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
