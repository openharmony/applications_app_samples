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

import { describe, it, expect } from '@ohos/hypium';
import { Constants } from '../../../main/ets/const/Constants';
import { DistributedEventCode } from '../../../main/ets/const/DistributedEventCode';

export default function ConstantsContractTest() {
  const casePrefix = 'DemandPlayer_ConstantsContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('ConstantsContract_SourceTool', () => {
    it(addCase(casePrefix + 'SourceToolValues_001'), 0, () => {
      expect(Constants.SOURCE_TOOL_REMOTE_CLICK).assertEqual(6);
      expect(Constants.SOURCE_TOOL_MOUSE_CLICK).assertEqual(7);
      expect(Constants.SOURCE_TOOL_TOUCH_CLICK).assertEqual(8);
      expect(Constants.SOURCE_TOOL_KEYBOARD_CLICK).assertEqual(9);
    });

    it(addCase(casePrefix + 'SourceToolPositive_002'), 0, () => {
      expect(Constants.SOURCE_TOOL_SYSTEM > 0).assertEqual(true);
      expect(Constants.SOURCE_TOOL_PROJ > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'PlayerStateValues_003'), 0, () => {
      expect(Constants.STATE_IDLE).assertEqual('idle');
      expect(Constants.STATE_LOADING).assertEqual('loading');
      expect(Constants.STATE_PLAY).assertEqual('play');
      expect(Constants.STATE_PAUSE).assertEqual('pause');
      expect(Constants.STATE_STOP).assertEqual('stop');
      expect(Constants.STATE_ERROR).assertEqual('error');
      expect(Constants.STATE_BUFFERING).assertEqual('buffering');
    });

    it(addCase(casePrefix + 'QualityValues_004'), 0, () => {
      expect(Constants.QUALITY_AUTO).assertEqual('auto');
      expect(Constants.QUALITY_1080P).assertEqual('1080p');
      expect(Constants.QUALITY_720P).assertEqual('720p');
      expect(Constants.QUALITY_480P).assertEqual('480p');
      expect(Constants.QUALITY_360P).assertEqual('360p');
      expect(Constants.QUALITY_SD).assertEqual('sd');
    });

    it(addCase(casePrefix + 'AspectValues_005'), 0, () => {
      expect(Constants.ASPECT_FIT).assertEqual('fit');
      expect(Constants.ASPECT_FILL).assertEqual('fill');
      expect(Constants.ASPECT_RATIO_16V9).assertEqual('16:9');
      expect(Constants.ASPECT_RATIO_4V3).assertEqual('4:3');
    });

    it(addCase(casePrefix + 'DistributedAliases_006'), 0, () => {
      expect(DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE).assertEqual(1);
      expect(DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE).assertEqual(2);
      expect(DistributedEventCode.PLAYER_SERVICE).assertEqual(3);
      expect(DistributedEventCode.PAUSE_PLAYER_SERVICE).assertEqual(4);
      expect(DistributedEventCode.PRE_PLAYER_SERVICE).assertEqual(8);
      expect(DistributedEventCode.NEXT_PLAYER_SERVICE).assertEqual(9);
      expect(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE).assertEqual(12);
      expect(DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE).assertEqual(16);
    });

    it(addCase(casePrefix + 'DistributedCompatibilityAliases_007'), 0, () => {
      expect(DistributedEventCode.START_DISTRIBUTED_PLAYER).assertEqual(1);
      expect(DistributedEventCode.STOP_DISTRIBUTED_PLAYER).assertEqual(2);
      expect(DistributedEventCode.PLAY_PLAYER_SERVICE).assertEqual(3);
    });

    it(addCase(casePrefix + 'CaseNamePattern_008'), 0, () => {
      expect(allCaseNames.length).assertEqual(8);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ConstantsContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
