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
import { BusinessScenarioCatalog } from './base/BusinessScenarioCatalog';
import { TestAsserts } from './base/TestAsserts';

export default function businessScenarioCatalogTest(): void {
  describe('TVDeviceManagerUiBusinessScenarioCatalogTest', () => {
    it('should expose complete business scenario catalog', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      TestAsserts.assertNumberAtLeast(scenarios.length, 12);
      TestAsserts.assertNoEmptyStrings(scenarios.map((item) => item.id));
    });

    it('should keep scenario ids unique across all business domains', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      const ids: string[] = scenarios.map((item) => item.id);

      // 业务目录会被覆盖率统计和回归矩阵同时消费。
      // ID 唯一性是后续聚合的基础，否则同名用例会让覆盖率被重复计算。
      TestAsserts.assertStringArrayUnique(ids);
    });

    it('should cover foundation confirm input pincode and scenario domains', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      const domains: string[] = scenarios.map((item) => item.domain);

      TestAsserts.assertTrue(domains.includes('foundation'));
      TestAsserts.assertTrue(domains.includes('confirm'));
      TestAsserts.assertTrue(domains.includes('inputpin'));
      TestAsserts.assertTrue(domains.includes('pincode'));
      TestAsserts.assertTrue(domains.includes('scenario'));
    });

    it('should keep every scenario title readable for business review and matrix generation', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      scenarios.forEach((item) => {
        TestAsserts.assertReadableText(item.title);
      });
    });

    it('should keep each scenario equipped with at least one expected signal', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      scenarios.forEach((item) => {
        TestAsserts.assertNumberAtLeast(item.expectedSignals.length, 1);
      });
    });

    it('should keep confirm domain scenario count aligned with four core authorization paths', 0, () => {
      const scenarios = BusinessScenarioCatalog.createConfirmScenarios();

      // 确认弹窗真正的核心路径就是允许一次、拒绝、始终允许、超时。
      // 把数量锁定为 4，可以避免后续矩阵拆解时遗漏关键决策分支。
      TestAsserts.assertArrayLength(scenarios, 4);
    });

    it('should keep inputpin domain scenario ids unique inside retry and submit matrix', 0, () => {
      const scenarios = BusinessScenarioCatalog.createInputScenarios();
      const ids: string[] = scenarios.map((item) => item.id);

      TestAsserts.assertStringArrayUnique(ids);
    });

    it('should keep foundation scenarios locked to smoke level for startup confidence', 0, () => {
      const scenarios = BusinessScenarioCatalog.createFoundationScenarios();
      const levels: string[] = scenarios.map((item) => item.level);

      TestAsserts.assertArrayLength(scenarios, 2);
      TestAsserts.assertStringArrayContains(levels, ['smoke']);
    });

    it('should keep pincode scenarios limited to display and cancel branches', 0, () => {
      const scenarios = BusinessScenarioCatalog.createPinDisplayScenarios();
      const ids: string[] = scenarios.map((item) => item.id);

      TestAsserts.assertArrayLength(scenarios, 2);
      TestAsserts.assertStringArrayContains(ids, ['pincode-display-from-want', 'pincode-cancel-display']);
    });

    it('should keep scenario suite focused on concurrency rotation fault and accessibility', 0, () => {
      const scenarios = BusinessScenarioCatalog.createScenarioSuites();
      const ids: string[] = scenarios.map((item) => item.id);

      // 场景套件承担系统级回归职责，维度过少会让后续并发和容错矩阵失去锚点。
      // 这里显式锁定四类系统场景，保证生成器始终覆盖窗口、旋转、故障和可读性主路径。
      TestAsserts.assertArrayLength(scenarios, 4);
      TestAsserts.assertStringArrayContains(ids, [
        'scenario-concurrent-window',
        'scenario-rotation-resolution',
        'scenario-fault-injection',
        'scenario-accessibility'
      ]);
    });

    it('should keep expected signal identifiers unique inside every scenario', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      scenarios.forEach((item) => {
        TestAsserts.assertStringArrayUnique(item.expectedSignals);
      });
    });

    it('should expose regression scenarios as independent generation domain', 0, () => {
      const scenarios = BusinessScenarioCatalog.createRegressionScenarios();
      const ids: string[] = scenarios.map((item) => item.id);
      const domains: string[] = scenarios.map((item) => item.domain);

      TestAsserts.assertArrayLength(scenarios, 3);
      TestAsserts.assertStringArrayContains(ids, [
        'regression-gate-foundation',
        'regression-gate-confirm',
        'regression-gate-inputpin'
      ]);
      TestAsserts.assertStringArrayContains(domains, ['regression']);
    });

    it('should keep all catalog domains unique after deduplicated view', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      const domains: string[] = [];
      scenarios.forEach((item) => {
        if (!domains.includes(item.domain)) {
          domains.push(item.domain);
        }
      });

      // 随着 catalog 继续扩张，domain 集合会直接影响矩阵分桶和报告分组。
      // 这里锁定去重后的唯一集合，可以避免后续有人拼错 domain 导致报告被拆成碎片桶。
      TestAsserts.assertStringArrayUnique(domains);
      TestAsserts.assertStringArrayContains(domains, ['foundation', 'confirm', 'inputpin', 'pincode', 'scenario', 'regression']);
    });

    // 目录里的 level 会直接驱动 smoke / deep 分层执行，因此值域必须稳定可枚举。
    // 这里按全量场景去重后校验 level 集合，避免后续误拼写出新的等级把执行器路由打散。
    it('should keep scenario levels constrained to smoke and deep only', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      const levels: string[] = [];

      scenarios.forEach((item) => {
        if (!levels.includes(item.level)) {
          levels.push(item.level);
        }
      });

      TestAsserts.assertStringArrayUnique(levels);
      TestAsserts.assertArrayLength(levels, 2);
      TestAsserts.assertStringArrayContains(levels, ['smoke', 'deep']);
    });

    // 回归域虽然是聚合入口，但每条 scenario 仍应绑定实际可观察信号，而不是抽象口号。
    // 锁定 regression 场景每项都有 3 个 signal，能防止后续把回归目录退化成只写标题的空壳条目。
    it('should keep regression scenarios equipped with complete signal triples', 0, () => {
      const scenarios = BusinessScenarioCatalog.createRegressionScenarios();

      scenarios.forEach((item) => {
        TestAsserts.assertArrayLength(item.expectedSignals, 3);
      });
    });

    // confirm 与 inputpin 是设备配对主链路的前后两段，二者都必须维持 deep 级别。
    // 这里跨域比对等级，是为了避免某一侧在矩阵裁剪时被意外降到 smoke，导致真实问题漏检。
    it('should keep confirm and inputpin domains fully routed to deep level scenarios', 0, () => {
      const confirmLevels: string[] = BusinessScenarioCatalog.createConfirmScenarios().map((item) => item.level);
      const inputLevels: string[] = BusinessScenarioCatalog.createInputScenarios().map((item) => item.level);

      confirmLevels.forEach((level: string) => {
        TestAsserts.assertStringEquals(level, 'deep');
      });
      inputLevels.forEach((level: string) => {
        TestAsserts.assertStringEquals(level, 'deep');
      });
    });

    // 每个 domain 至少要有一个场景，否则报告里会出现存在域名但无实际用例的假覆盖。
    // 这里统计域频次而不是只看 includes，可以更早暴露目录拼装时的丢项问题。
    it('should keep every domain backed by at least one concrete scenario entry', 0, () => {
      const scenarios = BusinessScenarioCatalog.createAllScenarios();
      const domainCounts: Map<string, number> = new Map<string, number>();

      scenarios.forEach((item) => {
        const current: number = domainCounts.get(item.domain) ?? 0;
        domainCounts.set(item.domain, current + 1);
      });

      domainCounts.forEach((count: number) => {
        TestAsserts.assertNumberAtLeast(count, 1);
      });
      TestAsserts.assertArrayLength(Array.from(domainCounts.keys()), 6);
    });
  });
}
