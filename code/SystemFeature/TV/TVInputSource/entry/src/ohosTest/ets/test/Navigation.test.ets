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
import { resolveNoSignalBackAction } from '../../../main/ets/pages/NoSignal';

/**
 * Registers tests for no-signal back-navigation decisions.
 *
 * @returns void.
 */
export default function NavigationTest(): void {
  describe('Navigation_real', () => {
    it('should_route_back_to_launcher_with_router_when_launched_from_launcher', 0, () => {
      const action = resolveNoSignalBackAction('com.ohos.launcher', 6);

      // Launcher-originated flows should simply unwind the router stack instead
      // of jumping to another mission and disrupting the home experience.
      expect(action.action).assertEqual('routerBack');
      expect(action.missionId).assertEqual(6);
    });

    it('should_route_back_with_router_when_pull_bundle_name_is_empty', 0, () => {
      const action = resolveNoSignalBackAction(undefined, 9);

      expect(action.action).assertEqual('routerBack');
      expect(action.missionId).assertEqual(9);
    });

    it('should_resume_previous_mission_for_external_callers', 0, () => {
      const action = resolveNoSignalBackAction('com.example.video', 12);

      // External callers expect focus to return to their foreground mission once
      // the no-signal page exits, so the mission id must be preserved.
      expect(action.action).assertEqual('moveMissionToFront');
      expect(action.missionId).assertEqual(12);
    });
  });
}

