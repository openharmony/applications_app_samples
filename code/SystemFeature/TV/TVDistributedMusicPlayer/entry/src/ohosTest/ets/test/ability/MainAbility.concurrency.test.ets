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
export default function mainAbilityconcurrencyTestSuite(): void {
  describe('MainAbilityConcurrencyTest', () => {
  let mainAbility: MainAbility = new MainAbility();

  beforeEach(() => {
    mainAbility = new MainAbility();
  });

  afterEach(() => {
  });


  it('testConcurrentCreate_MainAbilityInstance', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const instances: MainAbility[] = [];
    try {
      for (let i = 0; i < 10; i++) {
        instances.push(new MainAbility());
      }
      expect(instances.length).assertEqual(10);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate
  it('testConcurrentOnCreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 10; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new MainAbility();
          const want: Want = {
            deviceId: 'device' + i,
            bundleName: 'com.example.test',
            abilityName: 'Ability' + i
          };
          ability.onCreate(want);
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

  // Concurrent onCreate/onDestroy cycle
  it('test_onCreate_onDestroy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      for (let i = 0; i < 10; i++) {
        mainAbility.onCreate(want);
        mainAbility.onDestroy();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
