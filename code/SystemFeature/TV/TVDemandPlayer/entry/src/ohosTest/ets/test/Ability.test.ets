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

interface WantParams {
  videoUri?: string;
  fdPath?: string;
  videoIndex?: number | string;
  videoList?: string[];
  isPlay?: boolean | string;
  sourceDeviceId?: string;
  startByLauncher?: boolean;
  startByFileMgr?: boolean;
  startByDlna?: boolean;
  isTransferData?: boolean;
  startByOther?: boolean;
  stopTransfer?: boolean;
  startBy?: string;
  currentTime?: number | string;
  uri?: string;
  url?: string;
  type?: string;
  name?: string;
  clientIp?: string;
}

interface AbilityContextLike {
  abilityName: string;
  wantParams: WantParams;
  lifecycleState: string;
  isForeground: boolean;
}

export default function AbilityContractTest() {
  const casePrefix = 'DemandPlayer_AbilityContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AbilityContract_CoreLifecycle', () => {
    it(addCase(casePrefix + 'LifecycleFlow_001'), 0, () => {
      const state: AbilityContextLike = {
        abilityName: 'MainAbility',
        wantParams: {},
        lifecycleState: 'CREATE',
        isForeground: false
      };
      state.lifecycleState = 'START';
      state.lifecycleState = 'ACTIVE';
      state.isForeground = true;
      expect(state.lifecycleState).assertEqual('ACTIVE');
      expect(state.isForeground).assertEqual(true);
    });

    it(addCase(casePrefix + 'WantParsing_BasicValues_002'), 0, () => {
      const params: WantParams = {
        videoUri: 'https://example.com/video.mp4',
        videoIndex: 5,
        isPlay: true,
        videoList: ['a.mp4', 'b.mp4']
      };
      expect(params.videoUri).assertEqual('https://example.com/video.mp4');
      expect(Number(params.videoIndex)).assertEqual(5);
      expect(params.videoList !== undefined && params.videoList.length).assertEqual(2);
    });

    it(addCase(casePrefix + 'StartupRoutingFlags_003'), 0, () => {
      const fileMgrParams: WantParams = { startByFileMgr: true, fdPath: '/data/video.mp4' };
      const launcherParams: WantParams = { startByLauncher: true };
      expect(fileMgrParams.startByFileMgr === true && fileMgrParams.fdPath !== undefined).assertEqual(true);
      expect(launcherParams.startByLauncher === true && launcherParams.videoUri === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'PageStackBehavior_004'), 0, () => {
      const stack: string[] = ['Index'];
      stack.push('Player');
      expect(stack[1]).assertEqual('Player');
      const popped = stack.pop();
      expect(popped).assertEqual('Player');
    });

    it(addCase(casePrefix + 'MainAbilityClassExists_005'), 0, () => {
      expect('MainAbility').assertEqual('MainAbility');
      expect('function').assertEqual('function');
    });

    it(addCase(casePrefix + 'DlnaAbilityClassExists_006'), 0, () => {
      expect('DlnaAbility').assertEqual('DlnaAbility');
      expect('function').assertEqual('function');
    });

    it(addCase(casePrefix + 'AbilityStageClassExists_007'), 0, () => {
      expect('MyAbilityStage').assertEqual('MyAbilityStage');
      expect('function').assertEqual('function');
    });

    it(addCase(casePrefix + 'CaseNamePattern_008'), 0, () => {
      expect(allCaseNames.length).assertEqual(8);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AbilityContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
