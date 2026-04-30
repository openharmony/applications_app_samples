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
import { Want } from '@kit.AbilityKit';
import MyAbilityStage from '../../../../main/ets/Application/AbilityStage';


export default function abilityStageedgeTestSuite(): void {
  describe('AbilityStageEdgeTest', () => {
    let abilityStage: MyAbilityStage = new MyAbilityStage();

    // Reinitialize AbilityStage before each test
    beforeEach(() => {
      abilityStage = new MyAbilityStage();
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

    // Multiple onCreate calls must not crash
    it('testOnCreateMethod_multipleCalls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        for (let i = 0; i < 10; i++) {
          abilityStage.onCreate();
        }
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });


    it('testCreateMultipleAbilityStageInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const instances: MyAbilityStage[] = [];
      try {
        for (let i = 0; i < 5; i++) {
          instances.push(new MyAbilityStage());
        }
        expect(instances.length).assertEqual(5);
        for (let i = 0; i < instances.length; i++) {
          instances[i].onCreate();
        }
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // onCreate
    it('testOnCreateMethod_emptyInstanceStability', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const emptyStage: MyAbilityStage = new MyAbilityStage();
      try {
        emptyStage.onCreate();
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });


    it('testOnCreateMethod_instanceReplacement', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        abilityStage = new MyAbilityStage();
        abilityStage.onCreate();
        abilityStage = new MyAbilityStage();
        abilityStage.onCreate();
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // Fast consecutive onCreate calls
    it('testOnCreateMethod_fastConsecutiveCalls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        abilityStage.onCreate();
        abilityStage.onCreate();
        abilityStage.onCreate();
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // Reassign and recreate - robustness test
    it('testOnCreateMethod_nullReassignRecreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      abilityStage = new MyAbilityStage();
      try {
        abilityStage.onCreate();
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });
  });
}
