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
import MyAbilityStage from '../../../../main/ets/Application/AbilityStage';

export default function abilityStageenhancedTestSuite(): void {
  describe('AbilityStageEnhancedTest', () => {
  let abilityStage: MyAbilityStage = new MyAbilityStage();

  beforeEach(() => {
    abilityStage = new MyAbilityStage();
  });

  afterEach(() => {
  });

  // onCreate
  it('testOnCreateMethod_normalCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      abilityStage.onCreate();
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Multiple onCreate calls stability (50 times)
  it('testOnCreateMethod_multipleCallStability', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      for (let i = 0; i < 50; i++) {
        abilityStage.onCreate();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Large number of instances (100) must not crash
  it('testOnCreateMethod_largeNumberOfInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const instances: MyAbilityStage[] = [];
    try {
      for (let i = 0; i < 100; i++) {
        instances.push(new MyAbilityStage());
        instances[i].onCreate();
      }
      expect(instances.length).assertEqual(100);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  // Fast instance replacement (20 iterations)
  it('testFastInstanceReplacement', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      for (let i = 0; i < 20; i++) {
        abilityStage = new MyAbilityStage();
        abilityStage.onCreate();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
