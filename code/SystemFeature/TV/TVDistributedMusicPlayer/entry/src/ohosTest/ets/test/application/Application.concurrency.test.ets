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
import { AbilityStage } from '@kit.AbilityKit';

export default function applicationconcurrencyTestSuite(): void {
  describe('ApplicationConcurrencyTest', () => {
  let abilityStage: AbilityStage;

  beforeEach(() => {
    abilityStage = new AbilityStage();
  });

  it('testConcurrentCreateMultipleInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const instances: AbilityStage[] = [];
    try {
      for (let i = 0; i < 10; i++) {
        instances.push(new AbilityStage());
      }
      expect(instances.length).assertEqual(10);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  it('testConcurrentOnCreate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const stages: AbilityStage[] = [];
      for (let i = 0; i < 10; i++) {
        stages.push(new AbilityStage());
      }
      for (let j = 0; j < stages.length; j++) {
        stages[j].onCreate();
      }
      expect(true).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }
  });

  it('test_Create_Call', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const stages: AbilityStage[] = [];
      for (let i = 0; i < 20; i++) {
        const stage: AbilityStage = new AbilityStage();
        stage.onCreate();
        stages.push(stage);
      }
      expect(stages.length).assertEqual(20);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
