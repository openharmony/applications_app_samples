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
import { AbilityConstant } from '@kit.AbilityKit';

import { Want } from '@kit.AbilityKit';
export default function mainAbilityenhancedTestSuite(): void {
  describe('MainAbilityEnhancedTest', () => {
  let mainAbility: MainAbility = new MainAbility();

  beforeEach(() => {
    mainAbility = new MainAbility();
  });

  afterEach(() => {
  });


  it('test_Lifecycle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.distributedmusicplayer',
      abilityName: 'MainAbility'
    };
    try {
      mainAbility.onCreate(want);
      mainAbility.onForeground();
      mainAbility.onBackground();
      mainAbility.onWindowStageDestroy();
      mainAbility.onDestroy();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Pass parameters to onCreate method
  it('test_parameters_onCreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
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

  // onNewWant
  it('testonNewWantMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      action: 'ohos.want.action.viewData'
    };
    try {
      const launchParam: AbilityConstant.LaunchParam = {
        launchReason: 0,
        lastExitReason: 0,
        lastExitMessage: ''
      };
      mainAbility.onNewWant(want, launchParam);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // changeWant with viewData action parameter
  it('testchangeWant_viewData', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test',
      action: 'ohos.want.action.viewData'
    };
    try {
      mainAbility.changeWant(want);
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Multiple lifecycle cycles stability (20 iterations)
  it('testMultipleLifecycleStability', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      for (let i = 0; i < 20; i++) {
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
