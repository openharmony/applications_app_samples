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
import { ItemsType } from '../../../main/ets/const/Type';

function createItem(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

export default function AvPlayerAllInOneTest() {
  const casePrefix = 'DemandPlayer_AvPlayerAllInOne_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerAllInOne_SafeGuards', () => {
    it(addCase(casePrefix + 'SeekVideo_RepeatedNullPlayerSafe_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      for (let i = 0; i < 50; i++) {
        player.seekVideo(i % 2);
      }
      expect(player.avPlayer === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SetSpeed_RepeatedNullPlayerSafe_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      for (let i = 0; i < 10; i++) {
        player.setSpeed(createItem('speed_' + i, 'speed', i));
      }
      expect(globalThis.videoSpeed).assertEqual(9);
    });

    it(addCase(casePrefix + 'Stop_RepeatedSafe_003'), 0, () => {
      const player = new VideoAVPlayerClass();
      for (let i = 0; i < 20; i++) {
        player.stop();
      }
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SetAudioTracks_InvalidParamSafe_004'), 0, async () => {
      const player = new VideoAVPlayerClass();
      await player.setAudioTracks({ id: 'invalid', name: 'invalid' }, 0, false);
      expect(player.avPlayer === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_ReordersUnknown_005'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '英语', 1),
        createItem('3', '法语', 2),
        createItem('4', '未知', 3)
      ]);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('法语');
      expect(result[2].name).assertEqual('音轨3');
      expect(result[3].name).assertEqual('音轨4');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_AllKnownPreserved_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '英语', 0),
        createItem('2', '法语', 1)
      ]);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('法语');
    });

    it(addCase(casePrefix + 'CaseNamePattern_007'), 0, () => {
      expect(allCaseNames.length).assertEqual(7);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AvPlayerAllInOne_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
