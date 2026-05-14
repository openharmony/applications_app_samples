/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';
import ServiceAbility from '../../../../main/ets/serviceability/ServiceAbility';

import { Want } from '@kit.AbilityKit';
interface ServiceConfigParams { colorMode?: string; language?: string; }

function expectTrueForServiceRequest(serviceAbilityInstance: ServiceAbility, wantParam: Want): void {
  serviceAbilityInstance.onRequest(wantParam, -1);
  expect(true).assertTrue();
}

export default function serviceAbilityedgeTestSuite(): void {
  describe('ServiceAbilityEdgeTest', () => {
  let serviceAbilityInstance: ServiceAbility = new ServiceAbility();

  beforeEach(() => {
    serviceAbilityInstance = new ServiceAbility();
  });

  afterEach(() => {
  });

  // onCreate
  it('testOnCreateMethod_normalCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      serviceAbilityInstance.onCreate();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDestroy
  it('testonDestroyMethod_Call', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      serviceAbilityInstance.onCreate();
      serviceAbilityInstance.onDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - Want
  it('testonRequestMethod_Want', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
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

  // onRequest - startId
  it('testonRequestMethod_startId_1', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      for (let startId = 0; startId < 5; startId++) {
        serviceAbilityInstance.onRequest(want, startId);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - bundleName
  it('testonRequestMethod_bundleName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: ''
    };
    try {
      serviceAbilityInstance.onRequest(want, 1);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - with parameters
  it('testonRequestMethod_parameters', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'ServiceAbility'
    };
    try {
      serviceAbilityInstance.onRequest(want, 2);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - deviceId
  it('testonRequestMethod_deviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.test'
    };
    try {
      serviceAbilityInstance.onRequest(want, 3);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConnect - Want
  it('testonConnectMethod_Want', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      const remoteObj = serviceAbilityInstance.onConnect(want);
      expect(remoteObj !== null).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDisconnect - Want
  it('testonDisconnectMethod_Want', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      serviceAbilityInstance.onDisconnect(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConnectonDisconnect
  it('testonConnect_onDisconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'ServiceAbility'
    };
    try {
      for (let i = 0; i < 3; i++) {
        const remoteObj = serviceAbilityInstance.onConnect(want);
        expect(remoteObj !== null).assertTrue();
        serviceAbilityInstance.onDisconnect(want);
      }
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

  // onConfigurationUpdate
  it('testonConfigurationUpdateMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const config: ServiceConfigParams = {
      colorMode: 'dark'
    };
    try {
      serviceAbilityInstance.onConfigurationUpdate(config);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDump
  it('testonDumpMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const params: string[] = ['param1', 'param2'];
    try {
      const result: string[] = serviceAbilityInstance.onDump(params);
      expect(result).assertEqual(params);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Multiple onCreate/onDestroy cycles
  it('testonCreate_onDestroyMultipleCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      for (let i = 0; i < 5; i++) {
        serviceAbilityInstance.onCreate();
        serviceAbilityInstance.onDestroy();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - large startId value
  it('testonRequestMethod_startId_2', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      serviceAbilityInstance.onRequest(want, 999999);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequest - startId
  it('testonRequestMethod_startId_3', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      serviceAbilityInstance.onRequest(want, -1);
      expectTrueForServiceRequest(serviceAbilityInstance, want);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  });
}
