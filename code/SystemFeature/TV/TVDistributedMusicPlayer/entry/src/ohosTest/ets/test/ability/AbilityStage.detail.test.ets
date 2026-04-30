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


export default function abilityStagedetailTestSuite(): void {
  describe('AbilityStageDetailTest', () => {
    let abilityStage: MyAbilityStage | null = null;

    beforeEach(() => {
      abilityStage = new MyAbilityStage();
    });

    afterEach(() => {
      abilityStage = null;
    });

    // onCreate
    it('testOnCreateBasicCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        if (abilityStage != null) {
          abilityStage.onCreate();
        }
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // Multiple onCreate calls must not crash
    it('testMultipleOnCreateCalls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        for (let i = 0; i < 10; i++) {
          if (abilityStage != null) {
            abilityStage.onCreate();
          }
        }
        expect(true).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    });

    // Instance isolation - separate instances must not interfere
    it('testInstanceIsolation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      try {
        const stage1: MyAbilityStage = new MyAbilityStage();
        const stage2: MyAbilityStage = new MyAbilityStage();
        stage1.onCreate();
        stage2.onCreate();
        expect(stage1).not().assertEqual(stage2);
      } catch (e) {
        expect(null).assertFail();
      }
    });
  });
}
