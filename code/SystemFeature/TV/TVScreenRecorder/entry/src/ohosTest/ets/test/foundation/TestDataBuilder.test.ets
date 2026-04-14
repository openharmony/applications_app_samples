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
  buildCanaryBuckets,
  buildCompatibilityDevices,
  buildConcurrencyRounds,
  buildFailureCodes,
  buildRecorderScenarioCases,
  buildResolutionMatrix,
  buildRotationMatrix,
  buildStressDurationsMs
} from './TestDataBuilder';
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertTrue } from './TestAsserts';
import { MockRecordingState } from './TestTypes';

export default function testDataBuilderTest(): void {
  describe('TestDataBuilderFoundationTest', () => {
    it('BuildRecorderScenarioCases_001', 0, () => {
      const cases = buildRecorderScenarioCases();
      assertAtLeast(cases.length, 6);
      assertContains(cases[0].name, 'idle');
      assertNumberEqual(cases[0].initialState, MockRecordingState.Idle);
    });

    it('BuildRecorderScenarioCases_ActionCoverage_002', 0, () => {
      const cases = buildRecorderScenarioCases();
      let hasStart = false;
      let hasStop = false;
      let hasQuery = false;
      for (let index = 0; index < cases.length; index++) {
        const action = cases[index].action;
        if (action === 'start') {
          hasStart = true;
        }
        if (action === 'stop') {
          hasStop = true;
        }
        if (action === 'query') {
          hasQuery = true;
        }
      }
      assertTrue(hasStart);
      assertTrue(hasStop);
      assertTrue(hasQuery);
    });

    it('BuildConcurrencyRounds_003', 0, () => {
      const rounds = buildConcurrencyRounds();
      assertArrayLength(rounds, 40);
      assertNumberEqual(rounds[0], 1);
      assertNumberEqual(rounds[39], 40);
    });

    it('BuildStressDurations_004', 0, () => {
      const durations = buildStressDurationsMs();
      assertAtLeast(durations.length, 9);
      assertNumberEqual(durations[0], 1);
      assertNumberEqual(durations[durations.length - 1], 1000);
    });

    it('BuildResolutionMatrix_005', 0, () => {
      const matrix = buildResolutionMatrix();
      assertArrayLength(matrix, 4);
      assertNumberEqual(matrix[0].width, 1280);
      assertNumberEqual(matrix[3].height, 2160);
    });

    it('BuildRotationMatrix_006', 0, () => {
      const matrix = buildRotationMatrix();
      assertArrayLength(matrix, 4);
      assertNumberEqual(matrix[0], 0);
      assertNumberEqual(matrix[1], 90);
      assertNumberEqual(matrix[2], 180);
      assertNumberEqual(matrix[3], 270);
    });

    it('BuildFailureCodes_007', 0, () => {
      const codes = buildFailureCodes();
      assertAtLeast(codes.length, 6);
      assertNumberEqual(codes[0], -1);
      assertNumberEqual(codes[codes.length - 1], -999);
    });

    it('BuildCanaryBuckets_008', 0, () => {
      const buckets = buildCanaryBuckets();
      assertArrayLength(buckets, 6);
      assertContains(buckets[0], 'gray');
      assertContains(buckets[5], 'full');
    });

    it('BuildCompatibilityDevices_009', 0, () => {
      const devices = buildCompatibilityDevices();
      assertAtLeast(devices.length, 5);
      assertContains(devices[0], 'default');
      assertContains(devices[2], 'ohtv');
    });

    it('BuildScenarioAndFailureCross_010', 0, () => {
      const cases = buildRecorderScenarioCases();
      const failureCodes = buildFailureCodes();
      let combined = 0;
      for (let i = 0; i < cases.length; i++) {
        for (let j = 0; j < failureCodes.length; j++) {
          if (cases[i].expectError) {
            combined += 1;
          }
        }
      }
      assertTrue(combined > 0);
      assertAtLeast(combined, 12);
    });

    it('BuildRotationResolutionCross_011', 0, () => {
      const rotations = buildRotationMatrix();
      const resolutions = buildResolutionMatrix();
      let pairCounter = 0;
      for (let i = 0; i < rotations.length; i++) {
        for (let j = 0; j < resolutions.length; j++) {
          const pairId = `${rotations[i]}_${resolutions[j].width}x${resolutions[j].height}`;
          assertContains(pairId, 'x');
          pairCounter += 1;
        }
      }
      assertNumberEqual(pairCounter, 16);
    });

    it('BuildDurationsAndRoundsCross_012', 0, () => {
      const rounds = buildConcurrencyRounds();
      const durations = buildStressDurationsMs();
      let score = 0;
      for (let i = 0; i < rounds.length; i++) {
        const round = rounds[i];
        if (round % 5 === 0) {
          for (let j = 0; j < durations.length; j++) {
            score += durations[j];
          }
        }
      }
      assertTrue(score > 0);
      assertAtLeast(score, 1000);
    });
  });
}
