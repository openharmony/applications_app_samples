/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import { findReturnMissionId, MissionInfoLike } from '../../../main/ets/pages/NoSignal';

/**
 * Registers tests for mission selection logic used by no-signal style pages.
 *
 * @returns void.
 */
export default function PagesTest(): void {
  describe('Pages_real', () => {
    it('should_pick_matching_external_mission_and_skip_inputsource_self_task', 0, () => {
      const missions: MissionInfoLike[] = [
        {
          missionId: 1,
          want: {
            abilityName: 'EntryAbility',
            bundleName: 'com.ohos.inputsource'
          }
        },
        {
          missionId: 5,
          want: {
            abilityName: 'MainAbility',
            bundleName: 'com.example.caller'
          }
        }
      ];

      // The input source task must not resume itself; the page should instead
      // recover the original caller that launched the current flow.
      const missionId = findReturnMissionId(missions, 'com.example.caller');

      expect(missionId).assertEqual(5);
    });

    it('should_return_last_matching_mission_when_multiple_candidates_exist', 0, () => {
      const missions: MissionInfoLike[] = [
        {
          missionId: 3,
          want: {
            abilityName: 'MainAbility',
            bundleName: 'com.example.video'
          }
        },
        {
          missionId: 8,
          want: {
            abilityName: 'DetailAbility',
            bundleName: 'com.example.video'
          }
        }
      ];

      // The current implementation scans the full mission list and keeps the
      // latest match, so the test documents that observable behavior.
      const missionId = findReturnMissionId(missions, 'com.example.video');

      expect(missionId).assertEqual(8);
    });

    it('should_keep_default_mission_id_when_caller_bundle_is_missing', 0, () => {
      const missions: MissionInfoLike[] = [
        {
          missionId: 2,
          want: {
            abilityName: 'MainAbility',
            bundleName: 'com.example.video'
          }
        }
      ];

      const missionId = findReturnMissionId(missions, undefined);

      expect(missionId).assertEqual(-1);
    });
  });
}

