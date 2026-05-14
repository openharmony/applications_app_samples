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
export default function mainAbilityTestSuite(): void {
  describe('MainAbilityTest', () => {
  let mainAbility: MainAbility = new MainAbility();

  beforeEach(() => {
    mainAbility = new MainAbility();
  });

  afterEach(() => {
  });

  // onCreate
  it('testonCreateMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
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

  // onDestroy
  it('testonDestroyMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: '',
      bundleName: 'com.example.test'
    };
    try {
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

  // onBackPressed
  it('testonBackPressedMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const result: boolean = mainAbility.onBackPressed();
      expect(result).assertEqual(false);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // changeWant
  it('testchangeWantMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const want: Want = {
      deviceId: 'device1',
      bundleName: 'com.example.test'
    };
    try {
      mainAbility.changeWant(want);
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
  });
}
