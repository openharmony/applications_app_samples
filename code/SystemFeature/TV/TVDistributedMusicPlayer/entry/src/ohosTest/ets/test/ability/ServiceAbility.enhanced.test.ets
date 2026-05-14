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
interface ColorModeConfig { colorMode: string; }
interface LanguageConfig { language: string; }
export default function serviceAbilityenhancedTestSuite(): void {
  describe('ServiceAbilityEnhancedTest', () => {
  let serviceAbilityInstance: ServiceAbility = new ServiceAbility();

  beforeEach(() => {
    serviceAbilityInstance = new ServiceAbility();
  });

  afterEach(() => {
  });

  // ServiceAbility
  it('test_Lifecycle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'ServiceAbility'
    };
    try {
      serviceAbilityInstance.onCreate();
      serviceAbilityInstance.onRequest(want, 0);
      serviceAbilityInstance.onDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConnect/onDisconnect cycle
  it('testonConnect_onDisconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'ServiceAbility'
    };
    try {
      const remoteObj = serviceAbilityInstance.onConnect(want);
      expect(remoteObj).not().assertNull();
      serviceAbilityInstance.onDisconnect(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Multiple onConnect calls must not crash
  it('testMultipleonConnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'ServiceAbility'
    };
    try {
      for (let i = 0; i < 5; i++) {
        const remoteObj = serviceAbilityInstance.onConnect(want);
        expect(remoteObj).not().assertNull();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onRequeststartId
  it('testonRequest_startId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    const startIds: number[] = [0, 1, 10, 100, -1, 9999];
    try {
      for (let i = 0; i < startIds.length; i++) {
        serviceAbilityInstance.onRequest(want, startIds[i]);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onConfigurationUpdate
  it('testonConfigurationUpdate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const config1: ColorModeConfig = {
      colorMode: 'dark'
    };
    const config2: ColorModeConfig = {
      colorMode: 'light'
    };
    const config3: LanguageConfig = {
      language: 'zh-CN'
    };
    const testConfigs: (ColorModeConfig | LanguageConfig)[] = [
      config1,
      config2,
      config3
    ];
    try {
      for (let i = 0; i < testConfigs.length; i++) {
        serviceAbilityInstance.onConfigurationUpdate(testConfigs[i]);
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDump
  it('testonDumpEnhanced', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const testParams: Array<string>[] = [
      [],
      ['param1'],
      ['param1', 'param2', 'param3']
    ];
    try {
      for (let i = 0; i < testParams.length; i++) {
        const result: Array<string> = serviceAbilityInstance.onDump(testParams[i]);
        expect(result).assertEqual(testParams[i]);
      }
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
