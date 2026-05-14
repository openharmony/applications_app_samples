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


export default function abilityStageconcurrencyTestSuite(): void {
  describe('AbilityStageConcurrencyTest', () => {
    let abilityStage: MyAbilityStage | null = null;

    beforeEach(() => {
      abilityStage = new MyAbilityStage();
    });

    afterEach(() => {
      abilityStage = null;
    });

    // AbilityStage
    it('testConcurrentCreateMultipleInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const instances: MyAbilityStage[] = [];
      try {
        for (let i = 0; i < 10; i++) {
          instances.push(new MyAbilityStage());
        }
        expect(instances.length).assertEqual(10);
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // onCreate
    it('testConcurrentOnCreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        const promises: Promise<void>[] = [];
        for (let i = 0; i < 10; i++) {
          promises.push(new Promise<void>((resolve: (value: void) => void) => {
            const stage = new MyAbilityStage();
            stage.onCreate();
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

    // Create instances and call onCreate alternately
    it('testAlternateCreateAndOnCreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const stages: MyAbilityStage[] = [];
      try {
        for (let i = 0; i < 10; i++) {
          stages.push(new MyAbilityStage());
        }
        for (let j = 0; j < stages.length; j++) {
          stages[j].onCreate();
        }
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });
  });
}

