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
import {
  buildFoundationAssetNames,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { AccessibilityTreeHarness } from './AccessibilityLayoutHarness';

export default function accessibilityTreeIntegrityTest(): void {
  describe('AccessibilityTreeIntegrityTest', () => {
    it('AccessibilityTree_CorePageNodesBuildValidRootedTree_001', 0, () => {
      const harness = new AccessibilityTreeHarness();
      harness.addNode('root', 'page', '录屏主页');
      harness.addNode('start', 'button', '开始录屏', 'root');
      harness.addNode('recent', 'list', '最近任务', 'root');
      harness.addNode('status', 'text', '状态栏', 'root');
      assertNumberEqual(harness.validateTree(), 0);
      assertNumberEqual(harness.getNodeCount(), 4);
    });

    it('AccessibilityTree_MissingParentFailsValidation_002', 0, () => {
      const harness = new AccessibilityTreeHarness();
      harness.addNode('start', 'button', '开始录屏', 'root');
      assertNumberEqual(harness.validateTree(), -1);
      assertArrayLength(harness.getNodes(), 1);
    });

    it('AccessibilityTree_UnreadableNodeReducesReadableCount_003', 0, () => {
      const harness = new AccessibilityTreeHarness();
      harness.addNode('root', 'page', '录屏主页');
      harness.addNode('timer', 'text', '00:01', 'root');
      harness.addNode('hint', 'text', '同时按下菜单键与音量减键，即可结束录屏', 'root');
      harness.markUnreadable('hint');
      assertNumberEqual(harness.getReadableCount(), 2);
      assertContains(harness.flattenReadableText(), '录屏主页');
      assertContains(harness.flattenReadableText(), '00:01');
    });

    it('AccessibilityTree_BulkNodeReplayBuildsDistinctRoleCoverage_004', 0, () => {
      const harness = new AccessibilityTreeHarness();
      const counter = new FoundationScenarioCounter();
      harness.addNode('root', 'page', '录屏');
      const roles = ['button', 'text', 'image', 'list', 'dialog'];
      for (let index = 0; index < 40; index++) {
        const role = roles[index % roles.length];
        harness.addNode(`node_${index}`, role, `文本_${index}`, 'root');
        counter.record(role);
      }
      assertNumberEqual(counter.getDistinctCount(), roles.length);
      assertAtLeast(harness.getNodeCount(), 41);
    });

    it('AccessibilityTree_DualPassFlattenFingerprintRemainsStable_005', 0, () => {
      const names = buildFoundationAssetNames('a11y', 18);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new AccessibilityTreeHarness();
        harness.addNode('root', 'page', '录屏主页');
        for (let index = 0; index < names.length; index++) {
          harness.addNode(`asset_${index}`, 'text', names[index], 'root');
        }
        const summary = harness.flattenReadableText();
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('AccessibilityTree_LongRunAppendKeepsReadableTrailGrowing_006', 0, () => {
      const harness = new AccessibilityTreeHarness();
      harness.addNode('root', 'page', '录屏主页');
      for (let round = 0; round < 120; round++) {
        harness.addNode(`long_${round}`, 'text', `节点_${round}`, 'root');
      }
      assertAtLeast(harness.getReadableCount(), 121);
      assertTrue(harness.flattenReadableText().length > 100);
    });
  });
}
