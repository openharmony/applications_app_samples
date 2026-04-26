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
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationGrayReleaseKeys,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
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
import { UIHomeInteractionHarness, UIPermissionHarness } from './UISceneHarness';

export default function uiPermissionAndLaunchFlowTest(): void {
  describe('UIPermissionAndLaunchFlowTest', () => {
    it('UIPermission_AllCorePermissionsGranted_001', 0, () => {
      const harness = new UIPermissionHarness();
      assertNumberEqual(harness.request('photo', true), 0);
      assertNumberEqual(harness.request('microphone', true), 0);
      assertNumberEqual(harness.request('floatWindow', true), 0);
      assertTrue(harness.isGranted('photo'));
      assertTrue(harness.isGranted('microphone'));
      assertTrue(harness.isGranted('floatWindow'));
      assertNumberEqual(harness.getGrantedCount(), 3);
    });

    it('UIPermission_RejectPathLeavesReadableAuditTrail_002', 0, () => {
      const harness = new UIPermissionHarness();
      harness.request('photo', true);
      harness.request('microphone', false);
      harness.request('floatWindow', true);
      const records = harness.getRecords();
      assertArrayLength(records, 3);
      assertStringEqual(records[1].name, 'microphone');
      assertTrue(records[1].granted === false);
    });

    it('UILaunch_StartStopMaintainsHomeStatusProjection_003', 0, () => {
      const home = new UIHomeInteractionHarness();
      assertNumberEqual(home.start(), 0);
      assertTrue(home.isStarted());
      assertStringEqual(home.getStatus().icon, 'recording');
      assertNumberEqual(home.stop(), 0);
      assertTrue(home.isStarted() === false);
      assertStringEqual(home.getLastToast(), 'saved-to-photo');
    });

    it('UILaunch_RepeatedStartProducesToastAndNoSecondSession_004', 0, () => {
      const home = new UIHomeInteractionHarness();
      assertNumberEqual(home.start(), 0);
      assertNumberEqual(home.start(), -1000);
      assertTrue(home.isStarted());
      assertStringEqual(home.getLastToast(), 'already-recording');
      assertArrayLength(home.getActions(), 2);
    });

    it('UILaunch_StopWithoutSessionProducesFriendlyGuard_005', 0, () => {
      const home = new UIHomeInteractionHarness();
      assertNumberEqual(home.stop(), -1001);
      assertStringEqual(home.getLastToast(), 'not-recording');
      assertTrue(home.isStarted() === false);
    });

    it('UILaunch_ResolutionDialogCanBeProjectedToHome_006', 0, () => {
      const home = new UIHomeInteractionHarness();
      home.showResolutionNotSupported();
      const actions = home.getActions();
      assertArrayLength(actions, 1);
      assertStringEqual(actions[0].type, 'dialog');
      assertStringEqual(home.getLastToast(), 'resolution-not-supported');
    });

    it('UIPermission_ProfileAndBucketReplayRemainDeterministic_007', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const permission = new UIPermissionHarness();
      for (let index = 0; index < profiles.length; index++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          const name = `${profiles[index]}_${buckets[bucketIndex]}`;
          const code = permission.request(name, (index + bucketIndex) % 4 !== 0);
          counter.record(code === 0 ? 'granted' : 'denied');
          checksum.appendText(name);
          checksum.appendNumber(code);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('UILaunch_GrayReleaseStorageKeepsPermissionSnapshots_008', 0, () => {
      const storage = new FoundationStorageEntity();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        storage.set(`${keys[index]}.photo`, index % 2 === 0 ? 'granted' : 'denied');
        storage.set(`${keys[index]}.microphone`, index % 3 === 0 ? 'granted' : 'pending');
      }
      assertNumberEqual(storage.getSize(), keys.length * 2);
      assertContains(storage.get<string>('foundation.mock.window.photo') ?? '', 'denied');
      assertContains(storage.get<string>('foundation.regression.matrix.microphone') ?? '', 'pending');
    });

    it('UILaunch_NetworkSwitchDuringSessionRemainsVisible_009', 0, () => {
      const home = new UIHomeInteractionHarness();
      home.start();
      home.switchNetwork('ethernet');
      assertStringEqual(home.getStatus().network, 'ethernet');
      assertStringEqual(home.getStatus().icon, 'recording');
    });

    it('UIPermission_BurstGrantAndRejectCoverage_010', 0, () => {
      const harness = new UIPermissionHarness();
      let granted = 0;
      for (let round = 0; round < 90; round++) {
        const code = harness.request(`permission_${round}`, round % 5 !== 0);
        if (code === 0) {
          granted += 1
        }
      }
      assertArrayLength(harness.getRecords(), 90);
      assertAtLeast(granted, 70);
    });
  });
}
