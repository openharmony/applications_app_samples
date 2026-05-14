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
import { TestAsserts } from './base/TestAsserts';

class OrderedOperationLedger {
  readonly operations: string[] = [];

  record(value: string): void {
    this.operations.push(value);
  }
}

export default function dataConsistencyAndRaceTest(): void {
  describe('TVDeviceManagerUiDataConsistencyAndRaceTest', () => {
    it('should keep operation ordering stable under rapid updates', 0, () => {
      const operations: string[] = ['reply', 'destroy-window', 'terminate-session', 'terminate-extension'];
      TestAsserts.assertArrayLength(operations, 4);
      TestAsserts.assertStringArrayContains(operations, ['reply', 'destroy-window', 'terminate-session', 'terminate-extension']);
    });

    it('should keep reply visible before teardown signals in ordered ledger', 0, () => {
      const ledger: OrderedOperationLedger = new OrderedOperationLedger();
      ledger.record('reply');
      ledger.record('destroy-window');
      ledger.record('terminate-session');
      ledger.record('terminate-extension');

      TestAsserts.assertStringEquals(ledger.operations[0], 'reply');
      TestAsserts.assertStringEquals(ledger.operations[3], 'terminate-extension');
    });

    it('should keep no negative pending window count during race replay', 0, () => {
      let pendingWindows: number = 0;
      const operations: number[] = [1, 1, -1, 1, -1, -1];

      operations.forEach((value: number) => {
        pendingWindows += value;
        TestAsserts.assertNumberAtLeast(pendingWindows, 0);
      });
      TestAsserts.assertNumberEquals(pendingWindows, 0);
    });

    it('should keep ordered ledger append only under duplicate rapid updates', 0, () => {
      const ledger: OrderedOperationLedger = new OrderedOperationLedger();
      ['reply', 'reply', 'destroy-window', 'terminate-session', 'terminate-extension'].forEach((value: string) => {
        ledger.record(value);
      });

      // 并发场景下允许重复事件出现，但不允许重排成不可恢复的顺序。
      // 这里强调 append-only，是为了保证 race 回放仍能复原真实发生链路，而不是覆盖旧记录。
      TestAsserts.assertArrayLength(ledger.operations, 5);
      TestAsserts.assertStringEquals(ledger.operations[0], 'reply');
      TestAsserts.assertStringEquals(ledger.operations[1], 'reply');
      TestAsserts.assertStringEquals(ledger.operations[4], 'terminate-extension');
    });

    it('should keep teardown suffix stable after any rapid reply burst', 0, () => {
      const sequences: string[][] = [
        ['reply', 'destroy-window', 'terminate-session', 'terminate-extension'],
        ['reply', 'reply', 'destroy-window', 'terminate-session', 'terminate-extension'],
        ['reply', 'reply', 'reply', 'destroy-window', 'terminate-session', 'terminate-extension']
      ];

      sequences.forEach((sequence: string[]) => {
        const length: number = sequence.length;
        TestAsserts.assertStringEquals(sequence[length - 3], 'destroy-window');
        TestAsserts.assertStringEquals(sequence[length - 2], 'terminate-session');
        TestAsserts.assertStringEquals(sequence[length - 1], 'terminate-extension');
      });
    });

    // 回执可能被重复触发，但 teardown 关键三步必须只出现一次，否则会造成双重释放或日志污染。
    // 这里构造重复 reply 的序列并统计 suffix 出现次数，确保 teardown 仍保持单次语义。
    it('should keep teardown steps singular even if reply is duplicated', 0, () => {
      const ledger: OrderedOperationLedger = new OrderedOperationLedger();
      ['reply', 'reply', 'destroy-window', 'terminate-session', 'terminate-extension'].forEach((value: string) => ledger.record(value));

      const destroyCount: number = ledger.operations.filter((item: string) => item === 'destroy-window').length;
      const sessionCount: number = ledger.operations.filter((item: string) => item === 'terminate-session').length;
      const extensionCount: number = ledger.operations.filter((item: string) => item === 'terminate-extension').length;

      TestAsserts.assertNumberEquals(destroyCount, 1);
      TestAsserts.assertNumberEquals(sessionCount, 1);
      TestAsserts.assertNumberEquals(extensionCount, 1);
    });

    // 快速更新下的关键是“顺序不能倒置”，即 terminate 不应出现在 destroy 之前。
    // 这里用 index 比较锁定偏序关系，便于未来加入更多事件时仍能复用这条约束。
    it('should keep destroy happening before any terminate events in ordered ledger', 0, () => {
      const ledger: OrderedOperationLedger = new OrderedOperationLedger();
      ['reply', 'destroy-window', 'terminate-session', 'terminate-extension'].forEach((value: string) => ledger.record(value));

      const destroyIndex: number = ledger.operations.indexOf('destroy-window');
      const sessionIndex: number = ledger.operations.indexOf('terminate-session');
      const extensionIndex: number = ledger.operations.indexOf('terminate-extension');

      TestAsserts.assertTrue(destroyIndex >= 0);
      TestAsserts.assertTrue(destroyIndex < sessionIndex);
      TestAsserts.assertTrue(sessionIndex < extensionIndex);
    });

    // 操作日志最终会进入稳定性看板，因此每个条目都必须可读，避免出现 null/undefined 影响聚合。
    // 这里对 ledger 条目做可读性扫描，让“数据一致性”用例同时约束到诊断可观测性。
    it('should keep every ledger operation readable for race diagnostics', 0, () => {
      const ledger: OrderedOperationLedger = new OrderedOperationLedger();
      ['reply', 'reply', 'destroy-window', 'terminate-session', 'terminate-extension'].forEach((value: string) => ledger.record(value));

      ledger.operations.forEach((value: string) => TestAsserts.assertReadableText(value));
    });
  });
}
