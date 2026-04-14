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
  assertArrayLength,
  assertAtLeast,
  assertBetween,
  assertContains,
  assertFalse,
  assertIncreasing,
  assertNonEmpty,
  assertNotContains,
  assertNumberEqual,
  assertStateEqual,
  assertStateIn,
  assertStringEqual,
  assertThrows,
  assertTrue
} from './TestAsserts';
import { MockRecordingState } from './TestTypes';

export default function testAssertsTest(): void {
  describe('TestAssertsFoundationTest', () => {
    it('Assert_Boolean_001', 0, () => {
      assertTrue(true);
      assertFalse(false);
    });

    it('Assert_NumberAndString_002', 0, () => {
      assertNumberEqual(100, 100);
      assertStringEqual('screen', 'screen');
    });

    it('Assert_ArrayLength_003', 0, () => {
      const items = [1, 2, 3, 4, 5];
      assertArrayLength(items, 5);
    });

    it('Assert_StateEqual_004', 0, () => {
      assertStateEqual(MockRecordingState.Idle, MockRecordingState.Idle);
      assertStateEqual(MockRecordingState.Error, MockRecordingState.Error);
    });

    it('Assert_StateIn_005', 0, () => {
      const candidates = [MockRecordingState.Idle, MockRecordingState.Recording, MockRecordingState.Stopped];
      assertStateIn(MockRecordingState.Recording, candidates);
    });

    it('Assert_Increasing_006', 0, () => {
      assertIncreasing([1, 1, 2, 3, 5, 8, 13]);
      assertIncreasing([100]);
      assertIncreasing([]);
    });

    it('Assert_AtLeast_007', 0, () => {
      assertAtLeast(10, 5);
      assertAtLeast(5, 5);
    });

    it('Assert_Between_008', 0, () => {
      assertBetween(10, 0, 10);
      assertBetween(5, 1, 9);
      assertBetween(1, 1, 9);
    });

    it('Assert_StringContains_009', 0, () => {
      assertContains('fd://100', 'fd://');
      assertContains('REC_20260324_121212.mp4', 'REC_');
      assertContains('REC_20260324_121212.mp4', '.mp4');
    });

    it('Assert_StringNotContains_010', 0, () => {
      assertNotContains('screen-recorder', 'camera');
      assertNotContains('ability-service', 'video');
    });

    it('Assert_NonEmpty_011', 0, () => {
      assertNonEmpty('a');
      assertNonEmpty('screen');
      assertNonEmpty('123456');
    });

    it('Assert_Throws_012', 0, () => {
      assertThrows(() => {
        throw new Error('expected');
      });
    });

    it('Assert_ComposeUsage_013', 0, () => {
      const sampleStates: MockRecordingState[] = [];
      sampleStates.push(MockRecordingState.Idle);
      sampleStates.push(MockRecordingState.Recording);
      sampleStates.push(MockRecordingState.Stopped);
      assertArrayLength(sampleStates, 3);
      assertStateEqual(sampleStates[1], MockRecordingState.Recording);
      assertStateIn(sampleStates[2], [MockRecordingState.Stopped, MockRecordingState.Error]);
    });

    it('Assert_NumericMatrix_014', 0, () => {
      const matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ];
      assertArrayLength(matrix, 3);
      assertArrayLength(matrix[0], 3);
      assertNumberEqual(matrix[2][2], 9);
    });

    it('Assert_RangeBatch_015', 0, () => {
      for (let i = 0; i <= 20; i++) {
        assertBetween(i, 0, 20);
      }
      for (let i = 10; i <= 20; i++) {
        assertAtLeast(i, 10);
      }
    });

    it('Assert_StringBatch_016', 0, () => {
      const lines = [
        'screen recorder service',
        'window manager open',
        'state callback recording',
        'state callback stopped'
      ];
      assertArrayLength(lines, 4);
      for (let i = 0; i < lines.length; i++) {
        assertNonEmpty(lines[i]);
        assertNotContains(lines[i], 'undefined');
      }
      assertContains(lines[0], 'service');
      assertContains(lines[1], 'window');
    });

    it('Assert_StressLoop_017', 0, () => {
      const values: number[] = [];
      for (let i = 0; i < 100; i++) {
        values.push(i);
      }
      assertArrayLength(values, 100);
      assertIncreasing(values);
      assertNumberEqual(values[0], 0);
      assertNumberEqual(values[99], 99);
    });
  });
}
