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
import ServiceAbility from '../../../../main/ets/serviceability/ServiceAbility';

import { Want } from '@kit.AbilityKit';
export default function serviceAbilityconcurrencydetailTestSuite(): void {
  describe('ServiceAbilityConcurrencyDetailTest', () => {
  let serviceAbilityInstance: ServiceAbility | null = null;

  beforeEach(() => {
    serviceAbilityInstance = new ServiceAbility();
  });

  afterEach(() => {
    serviceAbilityInstance = null;
  });

  // onRequest
  it('testConcurrentonRequestOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 5; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new ServiceAbility();
          const want: Want = {
            deviceId: 'device' + i,
            bundleName: 'com.example.test'
          };
          ability.onRequest(want, i);
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

  // onConnectonDisconnect
  it('testConcurrentonConnect_onDisconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'ServiceAbility'
    };
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 5; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new ServiceAbility();
          const remoteObj: Object = ability.onConnect(want);
          expect(remoteObj !== null).assertTrue();
          ability.onDisconnect(want);
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

  // ServiceAbility
  it('testConcurrent_Lifecycle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      const promises: Promise<void>[] = [];
      for (let i = 0; i < 3; i++) {
        promises.push(new Promise<void>((resolve: (value: void) => void) => {
          const ability = new ServiceAbility();
          ability.onCreate();
          ability.onRequest(want, 0);
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
  });
}
