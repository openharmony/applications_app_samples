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

import { afterEach, beforeEach, describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';
import { TestCoveragePlan } from './base/TestCoveragePlan';
import { TestDataFactory } from './base/TestDataFactory';
import { TVDeviceManagerUiHarness } from './base/UiTestHarness';
import { BusinessScenarioCatalog } from './base/BusinessScenarioCatalog';

function resetFoundationState(): void {
  AppStorage.clear();
  globalThis.windowNum = 0;
  globalThis.style = undefined;
}

export default function foundationTest(): void {
  describe('TVDeviceManagerUiFoundationTest', () => {
    beforeEach(() => {
      resetFoundationState();
    });

    afterEach(() => {
      resetFoundationState();
    });

    it('should expose four rotation names for matrix execution', 0, () => {
      TestAsserts.assertRotationMatrix(TVDeviceManagerUiHarness.getRotationNames());
    });

    it('should expose complete lifecycle event seed', 0, () => {
      TestAsserts.assertLifecycleEvents(TestDataFactory.createLifecycleEvents());
    });

    it('should expose confirm button keys used by dialog model', 0, () => {
      TestAsserts.assertDialogButtonKeys(TestDataFactory.createConfirmButtonKeys());
    });

    it('should expose readable text labels used in major dialogs', 0, () => {
      TestDataFactory.createReadableLabels().forEach((label: string) => {
        TestAsserts.assertReadableText(label);
      });
    });

    it('should expose complete coverage batch ids', 0, () => {
      TestAsserts.assertCoverageBatchIds(TestCoveragePlan.getBatchIds());
    });

    it('should expose all business scenarios with non empty ids', 0, () => {
      const ids: string[] = BusinessScenarioCatalog.createAllScenarios().map((item) => item.id);
      TestAsserts.assertNoEmptyStrings(ids);
      TestAsserts.assertStringArrayUnique(ids);
    });

    it('should keep coverage total above regression baseline', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.countTotalCases(), 500);
    });

    it('should expose matrix seed scenarios for foundation level generator bootstrap', 0, () => {
      const seeds = TestCoveragePlan.createMatrixSeedScenarios();
      TestAsserts.assertNumberAtLeast(seeds.length, 4);
    });

    it('should keep focus scenarios readable and non empty for ui harness bootstrap', 0, () => {
      const scenarios = TestDataFactory.createFocusScenarios();
      scenarios.forEach((scenario) => {
        TestAsserts.assertReadableText(scenario.name);
        TestAsserts.assertFocusPath(scenario.sequence);
      });
    });

    it('should keep display matrix entry count aligned with harness rotation matrix', 0, () => {
      const displayMatrix: number[][] = TVDeviceManagerUiHarness.createDisplayMatrix();
      const rotationNames: string[] = TVDeviceManagerUiHarness.getRotationNames();

      // foundation 层不直接验证具体业务，而是验证所有矩阵生成器的公共地基是否稳定。
      // 这里锁定显示矩阵和旋转矩阵的基数，可以提前发现某个底层种子被删减导致全局规模塌缩。
      TestAsserts.assertArrayLength(displayMatrix, 4);
      TestAsserts.assertArrayLength(rotationNames, 4);
    });
  });
}
