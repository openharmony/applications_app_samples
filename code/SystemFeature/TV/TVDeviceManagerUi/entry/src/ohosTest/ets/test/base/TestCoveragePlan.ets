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

import { CoverageBatchScenario, TestDataFactory } from './TestDataFactory';

export class CoverageAreaSummary {
  area: string;
  totalCases: number;
  levels: string[];

  constructor(area: string, totalCases: number, levels: string[]) {
    this.area = area;
    this.totalCases = totalCases;
    this.levels = levels;
  }
}

export class TestCoveragePlan {
  static createBatchPlan(): CoverageBatchScenario[] {
    return TestDataFactory.createCoveragePlan();
  }

  static createMatrixSeedScenarios() {
    return TestDataFactory.createMatrixSeedScenarios();
  }

  static getBatchIds(): string[] {
    return TestCoveragePlan.createBatchPlan().map((item: CoverageBatchScenario) => item.id);
  }

  static getAreas(): string[] {
    return TestCoveragePlan.createBatchPlan().map((item: CoverageBatchScenario) => item.area);
  }

  static getLevels(): string[] {
    return TestCoveragePlan.createBatchPlan().map((item: CoverageBatchScenario) => item.level);
  }

  static countTotalCases(): number {
    let total: number = 0;
    TestCoveragePlan.createBatchPlan().forEach((item: CoverageBatchScenario) => {
      total += item.expectedCases;
    });
    return total;
  }

  static summarizeByArea(): CoverageAreaSummary[] {
    const plan: CoverageBatchScenario[] = TestCoveragePlan.createBatchPlan();
    const areas: string[] = [];

    plan.forEach((item: CoverageBatchScenario) => {
      if (!areas.includes(item.area)) {
        areas.push(item.area);
      }
    });

    return areas.map((area: string) => {
      let totalCases: number = 0;
      const levels: string[] = [];

      plan.forEach((item: CoverageBatchScenario) => {
        if (item.area === area) {
          totalCases += item.expectedCases;
          if (!levels.includes(item.level)) {
            levels.push(item.level);
          }
        }
      });

      return new CoverageAreaSummary(area, totalCases, levels);
    });
  }

  static hasArea(area: string): boolean {
    return TestCoveragePlan.getAreas().includes(area);
  }

  static hasLevel(level: string): boolean {
    return TestCoveragePlan.getLevels().includes(level);
  }

  static createRegressionGateMatrix(): Map<string, string[]> {
    const matrix: Map<string, string[]> = new Map<string, string[]>();

    // 回归门禁不只是统计总数，更重要的是把业务域和执行层级绑定起来。
    // 这样后续拆分 smoke / deep 套件时，可以复用同一张矩阵而不必重写策略常量。
    matrix.set('foundation', ['smoke']);
    matrix.set('confirm', ['deep']);
    matrix.set('inputpin', ['deep']);
    matrix.set('pincode', ['deep']);
    matrix.set('scenarios', ['deep']);
    matrix.set('regression', ['smoke']);
    return matrix;
  }

  static getMinimumExpectedCasesByArea(area: string): number {
    const summary: CoverageAreaSummary | undefined =
      TestCoveragePlan.summarizeByArea().find((item: CoverageAreaSummary) => item.area === area);
    if (!summary) {
      return 0;
    }
    return summary.totalCases;
  }
}
