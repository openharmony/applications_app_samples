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
export default function serviceAbilityTestSuite(): void {
  describe('ServiceAbilityTest', () => {
  let serviceAbilityInstance: ServiceAbility = new ServiceAbility();

  beforeEach(() => {
    serviceAbilityInstance = new ServiceAbility();
  });

  afterEach(() => {
  });

  // onCreate
  it('testonCreateMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      serviceAbilityInstance.onCreate();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDestroy
  it('testonDestroyMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      serviceAbilityInstance.onCreate();
      serviceAbilityInstance.onDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest
  it('testonRequestMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      serviceAbilityInstance.onRequest(want, 0);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConnect
  it('testonConnectMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      const remoteObj = serviceAbilityInstance.onConnect(want);
      expect(remoteObj).not().assertNull();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDisconnect
  it('testonDisconnectMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      serviceAbilityInstance.onDisconnect(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onReconnect
  it('testonReconnectMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      serviceAbilityInstance.onReconnect(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDump
  it('testonDumpMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const params: Array<string> = ['test1', 'test2'];
    try {
      const result: Array<string> = serviceAbilityInstance.onDump(params);
      expect(result).assertEqual(params);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
