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
  buildFoundationKeySequenceCases,
  FoundationRollingChecksum,
  FoundationStorageEntity
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { UIEditModeHarness } from './UISceneHarness';

function buildEditHarness(count: number): UIEditModeHarness {
  return new UIEditModeHarness(buildFoundationAssetNames('edit_item', count));
}

export default function uiEditShortcutRegressionTest(): void {
  describe('UIEditShortcutRegressionTest', () => {
    it('UIEdit_MoveRightAndLeftChangesFocus_001', 0, () => {
      const harness = buildEditHarness(6);
      harness.moveRight();
      harness.moveRight();
      harness.moveLeft();
      assertNumberEqual(harness.getFocusIndex(), 1);
      assertArrayLength(harness.getActions(), 3);
    });

    it('UIEdit_LeftBoundaryDoesNotUnderflow_002', 0, () => {
      const harness = buildEditHarness(4);
      harness.moveLeft();
      const actions = harness.getActions();
      assertArrayLength(actions, 1);
      assertStringEqual(actions[0].target, 'left-boundary');
      assertNumberEqual(harness.getFocusIndex(), 0);
    });

    it('UIEdit_RightBoundaryDoesNotOverflow_003', 0, () => {
      const harness = buildEditHarness(3);
      harness.moveRight();
      harness.moveRight();
      harness.moveRight();
      const actions = harness.getActions();
      assertStringEqual(actions[2].target, 'right-boundary');
      assertNumberEqual(harness.getFocusIndex(), 2);
    });

    it('UIEdit_RemoveFocusedKeepsRemainingOrder_004', 0, () => {
      const harness = buildEditHarness(5);
      harness.moveRight();
      const removed = harness.removeFocused();
      const items = harness.getItems();
      assertStringEqual(removed, 'edit_item_001.mp4');
      assertArrayLength(items, 4);
      assertStringEqual(items[1], 'edit_item_002.mp4');
    });

    it('UIEdit_PersistWritesItemsAndRemovedSet_005', 0, () => {
      const harness = buildEditHarness(4);
      const storage = new FoundationStorageEntity();
      harness.moveRight();
      harness.removeFocused();
      harness.persist(storage);
      assertContains(storage.get<string>('edit.items.0') ?? '', 'edit_item_000');
      assertContains(storage.get<string>('edit.items.1') ?? '', 'edit_item_002');
      assertContains(storage.get<string>('edit.removed.0') ?? '', 'edit_item_001');
    });

    it('UIEdit_RemoveAllItemsResetsFocusToZero_006', 0, () => {
      const harness = buildEditHarness(2);
      harness.removeFocused();
      harness.removeFocused();
      assertArrayLength(harness.getItems(), 0);
      assertNumberEqual(harness.getFocusIndex(), 0);
      assertArrayLength(harness.getRemoved(), 2);
    });

    it('UIShortcut_KeySequenceCasesDriveExpectedTriggerDistribution_007', 0, () => {
      const cases = buildFoundationKeySequenceCases();
      const checksum = new FoundationRollingChecksum();
      let totalExpected = 0;
      for (let index = 0; index < cases.length; index++) {
        checksum.appendText(cases[index].name);
        checksum.appendNumber(cases[index].expectedTriggerCount);
        totalExpected += cases[index].expectedTriggerCount
      }
      assertArrayLength(cases, 4);
      assertAtLeast(totalExpected, 5);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('UIEdit_LongMoveReplayAccumulatesStableFingerprint_008', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = buildEditHarness(10);
        for (let round = 0; round < 12; round++) {
          if (round % 3 === 0) {
            harness.moveLeft();
          } else {
            harness.moveRight();
          }
        }
        const summary = harness.getActions().map((action) => `${action.type}_${action.target}_${action.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('UIEdit_BulkRemovalLeavesExpectedTailSet_009', 0, () => {
      const harness = buildEditHarness(8);
      for (let round = 0; round < 3; round++) {
        harness.moveRight();
        harness.removeFocused();
      }
      const items = harness.getItems();
      assertArrayLength(items, 5);
      assertContains(items.join(','), 'edit_item_000.mp4');
      assertContains(harness.getRemoved().join(','), 'edit_item_003.mp4');
    });

    it('UIEdit_MassPersistenceSupportsRegressionReplay_010', 0, () => {
      const harness = buildEditHarness(14);
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 18; round++) {
        if (round % 4 === 0) {
          harness.removeFocused();
        } else {
          harness.moveRight();
        }
      }
      harness.persist(storage);
      assertAtLeast(storage.getSize(), 12);
      assertTrue((storage.get<number>('edit.focusIndex') ?? -1) >= 0);
    });
  });
}
