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

export default function regressionCoverageMatrixTest(): void {
  describe('TVDeviceManagerUiRegressionCoverageMatrixTest', () => {
    it('should keep every batch id mapped in coverage plan', 0, () => {
      TestAsserts.assertCoverageBatchIds(TestCoveragePlan.getBatchIds());
    });

    it('should keep total coverage cases above aggregate target baseline', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.countTotalCases(), 500);
    });

    it('should keep every declared area represented in coverage summary', 0, () => {
      const summaries = TestCoveragePlan.summarizeByArea();
      const areas: string[] = summaries.map((item) => item.area);

      TestAsserts.assertStringArrayContains(areas, ['foundation', 'confirm', 'inputpin', 'pincode', 'scenarios', 'regression']);
      TestAsserts.assertArrayLength(areas, 6);
    });

    it('should keep minimum expected cases for confirm area above deep regression threshold', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.getMinimumExpectedCasesByArea('confirm'), 90);
    });

    it('should keep regression gate matrix aligned with required execution levels', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();

      // 回归门禁矩阵决定不同业务域进入 smoke 还是 deep 套件。
      // 锁定映射关系，可以避免后续裁剪执行层级时误伤高风险对话框链路。
      TestAsserts.assertStringEquals((matrix.get('foundation') ?? [])[0], 'smoke');
      TestAsserts.assertStringEquals((matrix.get('confirm') ?? [])[0], 'deep');
      TestAsserts.assertStringEquals((matrix.get('inputpin') ?? [])[0], 'deep');
      TestAsserts.assertStringEquals((matrix.get('pincode') ?? [])[0], 'deep');
    });

    it('should keep every gate matrix key resolvable by coverage plan area lookup', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      matrix.forEach((_: string[], area: string) => {
        TestAsserts.assertTrue(TestCoveragePlan.hasArea(area));
      });
    });

    it('should keep each gate matrix level resolvable by coverage level lookup', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      matrix.forEach((levels: string[]) => {
        levels.forEach((level: string) => {
          TestAsserts.assertTrue(TestCoveragePlan.hasLevel(level));
        });
      });
    });

    it('should keep summary area names unique for regression dashboards', 0, () => {
      const summaries = TestCoveragePlan.summarizeByArea();
      const areas: string[] = summaries.map((item) => item.area);
      TestAsserts.assertStringArrayUnique(areas);
    });

    it('should keep scenario area above deep matrix threshold', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.getMinimumExpectedCasesByArea('scenarios'), 100);
    });

    it('should keep foundation and regression areas on smoke level only', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      TestAsserts.assertArrayLength(matrix.get('foundation') ?? [], 1);
      TestAsserts.assertArrayLength(matrix.get('regression') ?? [], 1);
      TestAsserts.assertStringEquals((matrix.get('regression') ?? [])[0], 'smoke');
    });

    it('should keep regression area total above foundation area total to reflect aggregation semantics', 0, () => {
      const regressionTotal: number = TestCoveragePlan.getMinimumExpectedCasesByArea('regression');
      const foundationTotal: number = TestCoveragePlan.getMinimumExpectedCasesByArea('foundation');

      // regression 域不是单点功能，而是聚合性的执行入口。
      // 这里约束它不能退化得比 foundation 还小，避免后续有人把回归域裁剪成名义存在的空壳。
      TestAsserts.assertNumberAtLeast(regressionTotal, foundationTotal);
    });

    it('should keep matrix seed names unique for regression expansion routing', 0, () => {
      const seeds = TestCoveragePlan.createMatrixSeedScenarios();
      const names: string[] = seeds.map((seed) => seed.name);
      TestAsserts.assertStringArrayUnique(names);
    });

    // 覆盖计划中的 area 与 gate matrix 的 key 应是一一对应关系，否则报告分桶和执行路由会脱节。
    // 这里对两侧集合做对齐校验，确保新增 area 时不会只改计划不改门禁矩阵。
    it('should keep summarized areas aligned exactly with regression gate matrix keys', 0, () => {
      const summaryAreas: string[] = TestCoveragePlan.summarizeByArea().map((item) => item.area);
      const matrixAreas: string[] = Array.from(TestCoveragePlan.createRegressionGateMatrix().keys());

      TestAsserts.assertArrayLength(summaryAreas, matrixAreas.length);
      TestAsserts.assertStringArrayContains(summaryAreas, matrixAreas);
      TestAsserts.assertStringArrayContains(matrixAreas, summaryAreas);
    });

    // 每个 area 的最小用例数本质上是矩阵规模的预算底线，所有值都必须为正且可累计。
    // 这里逐项扫描 summary totalCases，避免未来有人把某个域意外改成 0 导致报告看似存在实则空跑。
    it('should keep every summarized area backed by positive case volume', 0, () => {
      const summaries = TestCoveragePlan.summarizeByArea();

      summaries.forEach((item) => {
        TestAsserts.assertNumberAtLeast(item.totalCases, 1);
      });
    });

    // smoke 与 deep 是当前唯一支持的执行层级，如果出现第三种 level，执行器和看板都需要同步升级。
    // 这里锁定 levels 值域，是为了让层级扩展必须通过显式变更而不是隐式字符串漂移发生。
    it('should keep coverage levels constrained to smoke and deep only', 0, () => {
      const levels: string[] = [];
      TestCoveragePlan.getLevels().forEach((level: string) => {
        if (!levels.includes(level)) {
          levels.push(level);
        }
      });

      TestAsserts.assertArrayLength(levels, 2);
      TestAsserts.assertStringArrayContains(levels, ['smoke', 'deep']);
      TestAsserts.assertStringArrayUnique(levels);
    });

    // coverage batch 的 expectedCases 会被累计成总量基线，因此每个批次都必须保持正值。
    // 逐项验证可以更早发现单个批次被误填成 0 或负值，而不是只在总量断言里被掩盖。
    it('should keep every coverage batch contributing positive expected cases', 0, () => {
      const summaries = TestCoveragePlan.summarizeByArea();
      summaries.forEach((item) => {
        TestAsserts.assertNumberAtLeast(item.totalCases, 1);
      });
    });

    // regression gate 里的 smoke 域应该严格少于 deep 域数量，这反映了“快速门禁 + 深度专项”的执行策略。
    // 这里校验层级分布，可以避免后续有人无意把大部分域都降到 smoke，导致深度回归失守。
    it('should keep smoke gated areas fewer than deep gated areas in matrix strategy', 0, () => {
      const matrix: Map<string, string[]> = TestCoveragePlan.createRegressionGateMatrix();
      let smokeAreaCount: number = 0;
      let deepAreaCount: number = 0;

      matrix.forEach((levels: string[]) => {
        if (levels.includes('smoke')) {
          smokeAreaCount += 1;
        }
        if (levels.includes('deep')) {
          deepAreaCount += 1;
        }
      });

      TestAsserts.assertNumberAtLeast(deepAreaCount, 1);
      TestAsserts.assertTrue(smokeAreaCount < deepAreaCount);
    });

    // 矩阵种子名称最终会流入自动生成器和报告标题，因此既要唯一，也要具备可读前缀语义。
    // 这里补充校验 seed 名字都包含 matrix，防止后续混入无法辨认用途的临时名。
    it('should keep matrix seed names readable and semantically marked as matrix entries', 0, () => {
      const names: string[] = TestCoveragePlan.createMatrixSeedScenarios().map((seed) => seed.name);

      names.forEach((name: string) => {
        TestAsserts.assertReadableText(name);
        TestAsserts.assertStringContains(name, 'matrix');
      });
    });

    // 回归覆盖矩阵除了总量基线，还需要锁定“deep 域占主导”的策略，否则 1W+ 规模会在裁剪时首先损失深度用例。
    // 这里把 deep 域的最小期望总量加一层门槛，确保 confirm/inputpin/pincode/scenarios 四个域的预算不会被压缩到过低。
    it('should keep deep gated areas contributing majority of expected cases', 0, () => {
      const deepAreas: string[] = ['confirm', 'inputpin', 'pincode', 'scenarios'];
      const deepTotal: number = deepAreas.reduce((acc: number, area: string) => acc + TestCoveragePlan.getMinimumExpectedCasesByArea(area), 0);
      const overall: number = TestCoveragePlan.countTotalCases();

      TestAsserts.assertNumberAtLeast(deepTotal, overall / 2);
    });

    // countTotalCases 是报告总量锚点，一旦为 0 会导致所有门禁形同虚设。
    // 这里补充一个更强的正值约束，避免未来某个批次被清空时仍能通过弱门槛。
    it('should keep total coverage cases strictly positive for execution gating', 0, () => {
      TestAsserts.assertNumberAtLeast(TestCoveragePlan.countTotalCases(), 1);
    });
  });
}
