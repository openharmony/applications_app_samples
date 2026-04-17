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

function createTrack(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

export default function AvPlayerLightContractTest() {
  const casePrefix = 'DemandPlayer_AvPlayerLightContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerLightContractTestSuite', () => {
    it(addCase(casePrefix + 'InitialFields_Defaults_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      expect(player.avPlayer === null).assertEqual(true);
      expect(player.time).assertEqual(0);
      expect(player.duration).assertEqual(0);
      expect(player.isCompleted).assertEqual(false);
      expect(player.vWidth).assertEqual(0);
      expect(player.vHeight).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_NullPlayerSafe_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.seekVideo(0);
      player.seekVideo(1);
      expect(player.avPlayer === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SetSpeed_NullPlayerUpdatesGlobal_003'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.setSpeed(createTrack('speed', '1.0X', 1));
      expect(globalThis.videoSpeed).assertEqual(1);
    });

    it(addCase(casePrefix + 'Stop_NullPlayerSafe_004'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.stop();
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SetAudioTracks_NullPlayerSafe_005'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      await player.setAudioTracks(createTrack('audio', '中文', 0), 0, false);
      expect(player.avPlayer === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_KnownFirst_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [
        createTrack('1', '未知', 0),
        createTrack('2', '英语', 1),
        createTrack('3', '未知', 2)
      ];
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(3);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('音轨2');
      expect(result[2].name).assertEqual('音轨3');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_EmptyList_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([]);
      expect(result.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'CaseNamePattern_008'), 0, () => {
      expect(allCaseNames.length).assertEqual(8);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AvPlayerLightContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
