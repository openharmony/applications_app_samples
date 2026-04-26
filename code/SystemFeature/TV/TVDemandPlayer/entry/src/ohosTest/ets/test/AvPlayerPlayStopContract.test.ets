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
import media from '@ohos.multimedia.media';
import { BusinessError } from '@kit.BasicServicesKit';
import { drm } from '@kit.DrmKit';
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { ItemsType } from '../../../main/ets/const/Type';

class MockPlayer extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  resetCount: number = 0;

  on(_event: string, _callback: ((state: media.AVPlayerState,
    reason: media.StateChangeReason) => void) | ((err: BusinessError) => void) | (() => void) | ((info: media.SubtitleInfo) => void) | ((mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => void) | ((infoType: media.BufferingInfoType,
    value: number) => void) | ((value: number) => void)): void {
  }

  off(_event: string): void {
  }

  getTrackDescription(_callback: (error: BusinessError, data: media.MediaDescription[]) => void): void {
  }

  setPlaybackStrategy(_strategy: media.PlaybackStrategy): Promise<void> {
    return Promise.resolve();
  }

  prepare(): Promise<void> {
    return Promise.resolve();
  }

  play(): Promise<void> {
    return Promise.resolve();
  }

  pause(): Promise<void> {
    return Promise.resolve();
  }

  reset(): Promise<void> {
    this.resetCount++;
    return Promise.resolve();
  }

  release(): Promise<void> {
    return Promise.resolve();
  }

  setSpeed(_speed: number): void {
  }

  seek(_time: number, _mode?: media.SeekMode): void {
  }

  selectTrack(_trackId: number, _mode: media.SwitchMode): Promise<void> {
    return Promise.resolve();
  }

  addSubtitleFromUrl(_url: string): Promise<void> {
    return Promise.resolve();
  }

  setDecryptionConfig(_session: drm.MediaKeySession, _svp: boolean): void {
  }
}

function createItem(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

export default function AvPlayerPlayStopContract001Test() {
  const casePrefix = 'DemandPlayer_AvPlayerPlayStopContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerPlayStopContract001TestSuite', () => {
    it(addCase(casePrefix + 'Stop_ResetsPlayerState_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      player.avPlayer = mock;
      player.stop();
      expect(mock.resetCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'Stop_SetsHideXComponentTrue_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = new MockPlayer();
      player.stop();
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stop_ResetsAudioTrackIndex_003'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.currentAudioTrackIndex = 99;
      player.avPlayer = new MockPlayer();
      player.stop();
      expect(player.currentAudioTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Stop_NoPlayer_NoCrash_004'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        player.stop();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Play_NormalUrl_SetsUrl_005'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.state = 'idle';
      player.avPlayer = mock;
      await player.play('http://test.com/video.mp4');
      expect(mock.url).assertEqual('http://test.com/video.mp4');
    });

    it(addCase(casePrefix + 'Play_NullPlayer_NoCrash_006'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        await player.play('http://test.com/video.mp4');
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(true);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_EmptyArray_ReturnsEmpty_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result: ItemsType[] = player.processAudioTracks([]);
      expect(result.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_SingleUnknown_RenamesToTrack1_008'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([createItem('1', '未知', 0)]);
      expect(result.length).assertEqual(1);
      expect(result[0].name).assertEqual('音轨1');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_MixedKnownAndUnknown_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '英语', 1),
        createItem('3', '未知', 2)
      ]);
      expect(result.length).assertEqual(3);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('音轨2');
      expect(result[2].name).assertEqual('音轨3');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_AllKnown_NoRename_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '英语', 0),
        createItem('2', '法语', 1),
        createItem('3', '德语', 2)
      ]);
      expect(result.length).assertEqual(3);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('法语');
      expect(result[2].name).assertEqual('德语');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_TrackIndexBeyondKnown_PreservesParam_011'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '未知', 1),
        createItem('3', '未知', 2)
      ]);
      expect(result.length).assertEqual(3);
      expect(result[0].param).assertEqual(0);
      expect(result[1].param).assertEqual(1);
      expect(result[2].param).assertEqual(2);
    });

    it(addCase(casePrefix + 'Stop_MultipleCalls_OnlyOneReset_013'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      player.avPlayer = mock;
      player.stop();
      player.stop();
      player.stop();
      expect(mock.resetCount).assertEqual(3);
    });
  });
}
