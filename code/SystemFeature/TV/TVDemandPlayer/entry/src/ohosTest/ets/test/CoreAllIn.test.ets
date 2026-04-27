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
import { VideoAVPlayerClass } from '../../../main/ets/Model/AvPlayer';
import { DrmModel } from '../../../main/ets/Model/DrmModel';
import { EventUtil } from '../../../main/ets/utils/EventUtil';
import { PointerUtil } from '../../../main/ets/utils/PointerUtil';
import { Throttle } from '../../../main/ets/Model/Throttle';
import { Rdb } from '../../../main/ets/Model/Rdb';
import { SubWindow } from '../../../main/ets/Model/Window';
import { ItemsType } from '../../../main/ets/const/Type';

interface MockTouchLike {
  type: number;
  source: number;
}

function createItem(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

function isTouchEventRule(event: MockTouchLike): boolean {
  if (event.type === 1 || event.type === 2) {
    return false;
  }
  return event.source === 1 || event.source === 2;
}

export default function CoreAllInOneTest() {
  const casePrefix = 'DemandPlayer_CoreAllInOne_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('CoreAllInOne_GuardContracts', () => {
    it(addCase(casePrefix + 'CoreClassesExist_001'), 0, () => {
      expect(VideoAVPlayerClass !== undefined).assertEqual(true);
      expect(DrmModel !== undefined).assertEqual(true);
      expect(EventUtil !== undefined).assertEqual(true);
      expect(PointerUtil !== undefined).assertEqual(true);
      expect(Rdb !== undefined).assertEqual(true);
      expect(SubWindow !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'AvPlayerNullGuards_002'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.seekVideo(0);
      player.setSpeed(createItem('s1', '1x', 1));
      await player.setAudioTracks(createItem('a1', '中文', 0), 0, false);
      player.stop();
      expect(player.avPlayer === null).assertEqual(true);
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'AudioTrackProcessing_003'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '英语', 1)
      ]);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('音轨2');
    });

    it(addCase(casePrefix + 'DrmDefaultFields_004'), 0, () => {
      const drmModel = new DrmModel();
      expect(drmModel.mediaKeySystem === undefined).assertEqual(true);
      expect(drmModel.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'ThrottleFunctionReturned_005'), 0, () => {
      const throttled = Throttle((): void => {
      }, 100);
      expect(throttled !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'RdbAndWindowSingletons_006'), 0, () => {
      expect(Rdb.rdb instanceof Rdb).assertEqual(true);
      expect(SubWindow.subWindow instanceof SubWindow).assertEqual(true);
    });

    it(addCase(casePrefix + 'TouchRuleProjection_007'), 0, () => {
      expect(isTouchEventRule({ type: 1, source: 1 })).assertEqual(false);
      expect(isTouchEventRule({ type: 3, source: 1 })).assertEqual(true);
      expect(isTouchEventRule({ type: 3, source: 0 })).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_008'), 0, () => {
      expect(allCaseNames.length).assertEqual(8);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_CoreAllInOne_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
