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
export default function serviceAbilitydetailTestSuite(): void {
  describe('ServiceAbilityDetailTest', () => {
  let serviceAbilityInstance: ServiceAbility | null = null;

  beforeEach(() => {
    serviceAbilityInstance = new ServiceAbility();
  });

  afterEach(() => {
    serviceAbilityInstance = null;
  });

  // onCreate/onDestroy cycle
  it('testonCreate_onDestroy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      if (serviceAbilityInstance != null) {
        serviceAbilityInstance.onCreate();
        serviceAbilityInstance.onDestroy();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest -
  it('testonRequest_BasicParam', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      if (serviceAbilityInstance != null) {
        serviceAbilityInstance.onRequest(want, 0);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConnect returns valid remote object
  it('testonConnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      const remoteObj = serviceAbilityInstance != null ? serviceAbilityInstance.onConnect(want) : null;
      if (remoteObj != null) {
        expect(true).assertTrue();
      } else {
        expect(null).assertFail();
      }
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDisconnect
  it('testonDisconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      if (serviceAbilityInstance != null) {
        serviceAbilityInstance.onDisconnect(want);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onReconnect
  it('testonReconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      if (serviceAbilityInstance != null) {
        serviceAbilityInstance.onReconnect(want);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
