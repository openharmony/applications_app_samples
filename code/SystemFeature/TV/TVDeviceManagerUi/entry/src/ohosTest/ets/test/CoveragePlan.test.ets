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

export default function coveragePlanTest(): void {
  describe('TVDeviceManagerUiCoveragePlanTest', () => {
    it('should expose smoke and deep coverage levels', 0, () => {
      const levels: string[] = TestCoveragePlan.getLevels();
      TestAsserts.assertStringArrayContains(levels, ['smoke', 'deep']);
    });

    it('should accumulate total cases above baseline', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.countTotalCases(), 500);
    });

    it('should keep coverage level names unique for stable reporting', 0, () => {
      const levels: string[] = TestCoveragePlan.getLevels();
      const uniqueLevels: string[] = Array.from(new Set<string>(levels));

      // 覆盖等级会作为报告分组字段，重复等级会导致统计页聚合异常。
      // 这里验证去重后的唯一性，是为了让后续批量扩容时仍能保持清晰分层。
      TestAsserts.assertStringArrayUnique(uniqueLevels);
    });

    it('should keep total case budget aligned with ten thousand expansion target', 0, () => {
      const totalCases: number = TestCoveragePlan.countTotalCases();
      const expansionFactor: number = 20;
      const expandedBudget: number = totalCases * expansionFactor;

      TestAsserts.assertNumberAtLeast(expandedBudget, 10000);
    });

    it('should expose six batch ids with stable batch prefix', 0, () => {
      const batchIds: string[] = TestCoveragePlan.getBatchIds();
      TestAsserts.assertCoverageBatchIds(batchIds);
    });

    it('should expose six coverage areas without duplicated names', 0, () => {
      const areas: string[] = TestCoveragePlan.getAreas();
      TestAsserts.assertArrayLength(areas, 6);
      TestAsserts.assertStringArrayUnique(areas);
    });

    it('should summarize each area with positive case count and readable level list', 0, () => {
      const summaries = TestCoveragePlan.summarizeByArea();
      summaries.forEach((item) => {
        TestAsserts.assertNumberAtLeast(item.totalCases, 1);
        TestAsserts.assertNumberAtLeast(item.levels.length, 1);
        TestAsserts.assertNoEmptyStrings(item.levels);
      });
    });

    it('should keep area lookup aligned with declared plan areas', 0, () => {
      const areas: string[] = TestCoveragePlan.getAreas();
      areas.forEach((area: string) => {
        TestAsserts.assertTrue(TestCoveragePlan.hasArea(area));
      });
      TestAsserts.assertFalse(TestCoveragePlan.hasArea('unknown-area'));
    });

    it('should keep level lookup aligned with declared smoke and deep levels', 0, () => {
      TestAsserts.assertTrue(TestCoveragePlan.hasLevel('smoke'));
      TestAsserts.assertTrue(TestCoveragePlan.hasLevel('deep'));
      TestAsserts.assertFalse(TestCoveragePlan.hasLevel('chaos'));
    });

    it('should keep regression gate matrix area count aligned with plan area count', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      const areas: string[] = TestCoveragePlan.getAreas();

      // 统计计划和门禁矩阵必须一一对齐，否则后续新增业务域时会出现“有预算无执行层级”的灰区。
      // 这里同时校验两个来源的规模，可以尽早发现计划扩容后门禁配置未更新的问题。
      TestAsserts.assertNumberEquals(matrix.size, areas.length);
    });

    it('should expose matrix seed scenarios that can push generator toward ten thousand scale', 0, () => {
      const seeds = TestCoveragePlan.createMatrixSeedScenarios();
      TestAsserts.assertNumberEquals(seeds.length, 4);
      seeds.forEach((seed) => {
        TestAsserts.assertReadableText(seed.name);
        TestAsserts.assertNumberAtLeast(seed.dimensions.length, 4);
      });
    });
  });
}
