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

import { describe, it } from '@ohos/hypium';
import { TestCoveragePlan } from './base/TestCoveragePlan';
import { TestAsserts } from './base/TestAsserts';

export default function regressionSuiteTest(): void {
  describe('TVDeviceManagerUiRegressionSuiteTest', () => {
    it('should provide regression gate matrix for all business areas', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      TestAsserts.assertTrue(matrix.has('foundation'));
      TestAsserts.assertTrue(matrix.has('confirm'));
      TestAsserts.assertTrue(matrix.has('inputpin'));
      TestAsserts.assertTrue(matrix.has('pincode'));
      TestAsserts.assertTrue(matrix.has('scenarios'));
      TestAsserts.assertTrue(matrix.has('regression'));
    });

    it('should keep confirm and regression as separate execution domains', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      const confirmLevels: string[] = matrix.get('confirm') ?? [];
      const regressionLevels: string[] = matrix.get('regression') ?? [];
      TestAsserts.assertStringEquals(confirmLevels[0], 'deep');
      TestAsserts.assertStringEquals(regressionLevels[0], 'smoke');
    });

    it('should expose positive minimum expected case count for all areas', 0, () => {
      const areas: string[] = ['foundation', 'confirm', 'inputpin', 'pincode', 'scenarios', 'regression'];
      areas.forEach((area: string) => {
        TestAsserts.assertNumberAtLeast(TestCoveragePlan.getMinimumExpectedCasesByArea(area), 1);
      });
    });

    it('should keep regression matrix size aligned with plan area count', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      TestAsserts.assertNumberEquals(matrix.size, TestCoveragePlan.getAreas().length);
    });

    it('should keep every regression gate level resolvable by declared coverage levels', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      matrix.forEach((levels: string[]) => {
        levels.forEach((level: string) => {
          TestAsserts.assertTrue(TestCoveragePlan.hasLevel(level));
        });
      });
    });

    it('should keep all regression suite areas unique for execution routing', 0, () => {
      const areas: string[] = Array.from(TestCoveragePlan.createRegressionGateMatrix().keys());

      // 回归套件的 area 名称会被执行器直接拿来路由任务，如果这里发生重复，分批执行就会出现覆盖丢失。
      // 这里单独锁定唯一性，是为了保证后续继续扩 area 时仍能稳定映射到具体测试组。
      TestAsserts.assertStringArrayUnique(areas);
    });

    // smoke 与 deep 是当前唯一执行层级，回归套件不应引入额外字符串层级造成执行器不兼容。
    // 这里把 gate matrix 的 level 值域锁死，确保层级扩展必须通过显式设计变更进入。
    it('should keep regression gate levels constrained to smoke and deep only', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      const levels: string[] = [];

      matrix.forEach((value: string[]) => {
        value.forEach((level: string) => {
          if (!levels.includes(level)) {
            levels.push(level);
          }
        });
      });

      TestAsserts.assertArrayLength(levels, 2);
      TestAsserts.assertStringArrayContains(levels, ['smoke', 'deep']);
      TestAsserts.assertStringArrayUnique(levels);
    });

    // regression 域本身是聚合入口，因此它不应被标记为 deep，否则会把聚合层级和业务深度层级混淆。
    // 这里锁定 regression 仍为 smoke，是为了保证回归门禁的策略语义清晰。
    it('should keep regression area gated to smoke only to reflect aggregation semantics', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      const regressionLevels: string[] = matrix.get('regression') ?? [];

      TestAsserts.assertArrayLength(regressionLevels, 1);
      TestAsserts.assertStringEquals(regressionLevels[0], 'smoke');
    });

    // scenarios 域承载的是并发、旋转、故障等系统性风险，必须保持 deep 执行来保证覆盖密度。
    // 这里单独锁定 scenarios 的 gate 等级，避免后续为了提速把系统场景下调导致风险外溢。
    it('should keep scenarios area gated to deep for system risk coverage', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      const scenariosLevels: string[] = matrix.get('scenarios') ?? [];

      TestAsserts.assertArrayLength(scenariosLevels, 1);
      TestAsserts.assertStringEquals(scenariosLevels[0], 'deep');
    });
  });
}
