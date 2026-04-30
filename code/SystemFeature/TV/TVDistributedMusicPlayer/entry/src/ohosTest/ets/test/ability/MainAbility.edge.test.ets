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
import MainAbility from '../../../../main/ets/MainAbility/MainAbility';

import { Want } from '@kit.AbilityKit';

// String.prototype.repeat polyfill
function strRepeat(str: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += str;
  }
  return result;
}

export default function mainAbilityedgeTestSuite(): void {
  describe('MainAbilityEdgeTest', () => {
  let mainAbility: MainAbility = new MainAbility();

  beforeEach(() => {
    mainAbility = new MainAbility();
  });

  afterEach(() => {
  });

  // onCreate - Want
  it('testonCreateMethod_Want', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'MainAbility'
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - deviceId
  it('testonCreateMethod_deviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.test'
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - custom parameters with deviceId
  it('testonCreateMethod_parameters_1', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'MainAbility'
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - with action parameter
  it('testonCreateMethod_action', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'MainAbility',
      action: 'ohos.want.action.viewData'
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - bundleName
  it('testonCreateMethod_bundleName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: ''
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - abilityName
  it('testonCreateMethod_1', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const longName: string = strRepeat('A', 255);
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: longName
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - special characters in abilityName
  it('testonCreateMethod_2', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      abilityName: 'test-ability_v2.0'
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreate - parameters
  it('testonCreateMethod_parameters_2', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      parameters: undefined
    };
    try {
      mainAbility.onCreate(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onDestroy
  it('testonDestroyMethod_Call', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const want: Want = {
        deviceId: 'device1',
        bundleName: 'com.example.test'
      };
      mainAbility.onCreate(want);
      mainAbility.onDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onForeground
  it('testonForegroundMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      mainAbility.onForeground();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onBackground
  it('testonBackgroundMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      mainAbility.onBackground();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onWindowStageDestroy
  it('testonWindowStageDestroyMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      mainAbility.onWindowStageDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onBackPressed
  it('testonBackPressedMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const result: boolean = mainAbility.onBackPressed();
      expect(result).assertEqual(false);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // onCreateonDestroy
  it('testonCreate_onDestroy_Call', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      for (let i = 0; i < 3; i++) {
        mainAbility.onCreate(want);
        mainAbility.onDestroy();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // changeWant - Want
  it('testchangeWantMethod_Want', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      action: 'ohos.want.action.viewData'
    };
    try {
      mainAbility.onCreate(want);
      mainAbility.changeWant(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Want
  for (let i = 0; i < 5; i++) {
    it('testOnCreateMethod_dynamicWant' + i, TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const want: Want = {
        deviceId: 'device' + i,
        bundleName: 'com.example.app' + i,
        abilityName: 'Ability' + i
      };
      try {
        mainAbility.onCreate(want);
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });
  }
  });
}
