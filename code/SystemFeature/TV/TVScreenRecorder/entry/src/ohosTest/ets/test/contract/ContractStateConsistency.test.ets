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
  buildFoundationCompatibilityProfiles,
  buildFoundationGrayReleaseKeys,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual
} from '../foundation/TestAsserts';
import { SchemaContractHarness } from './ContractSecurityHarness';

export default function contractStateConsistencyTest(): void {
  describe('ContractStateConsistencyTest', () => {
    it('ContractState_CoreKeysRemainReadable_001', 0, () => {
      const harness = new SchemaContractHarness();
      assertNumberEqual(harness.setState('recorderState', 'idle'), 0);
      assertNumberEqual(harness.setState('timerPage', 'pages/ScreenRecorderTimer'), 0);
      assertNumberEqual(harness.setState('dialogPage', 'pages/ScreenRecorderDialog'), 0);
      assertNumberEqual(harness.requireKeys(['recorderState', 'timerPage', 'dialogPage']), 0);
      assertStringEqual(harness.getValue('recorderState'), 'idle');
    });

    it('ContractState_MissingRequiredKeyReturnsGuardCode_002', 0, () => {
      const harness = new SchemaContractHarness();
      harness.setState('recorderState', 'recording');
      assertNumberEqual(harness.requireKeys(['recorderState', 'recentState']), -2);
      assertArrayLength(harness.getRecords(), 2);
    });

    it('ContractState_GrayKeysFormStableSchemaSurface_003', 0, () => {
      const harness = new SchemaContractHarness();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        harness.setState(keys[index], `enabled_${index}`);
      }
      assertNumberEqual(harness.requireKeys(keys), 0);
      const snapshot = Array.from(harness.snapshot().keys()).join(',');
      assertContains(snapshot, 'foundation.mock.photo');
      assertContains(snapshot, 'foundation.regression.matrix');
    });

    it('ContractState_ProfileReplayMaintainsDistinctStateSamples_004', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const harness = new SchemaContractHarness();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < profiles.length; index++) {
        harness.setState(`profile.${index}`, profiles[index]);
        counter.record(profiles[index]);
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length);
    });

    it('ContractState_DualPassSnapshotFingerprintRemainsStable_005', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new SchemaContractHarness();
        for (let round = 0; round < 20; round++) {
          harness.setState(`state.${round}`, round % 2 === 0 ? 'recording' : 'idle');
        }
        const summary = Array.from(harness.snapshot().entries()).map((item) => `${item[0]}=${item[1]}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('ContractState_EmptyKeyOrValueIsRejected_006', 0, () => {
      const harness = new SchemaContractHarness();
      assertNumberEqual(harness.setState('', 'value'), -1);
      assertNumberEqual(harness.setState('key', ''), -1);
      assertArrayLength(harness.getRecords(), 2);
    });

    it('ContractState_LongRunStateReplayBuildsEnoughTelemetry_007', 0, () => {
      const harness = new SchemaContractHarness();
      for (let round = 0; round < 120; round++) {
        harness.setState(`long.${round}`, `value_${round}`);
      }
      assertAtLeast(harness.getRecords().length, 120);
      assertStringEqual(harness.getValue('long.119'), 'value_119');
    });
  });
}
