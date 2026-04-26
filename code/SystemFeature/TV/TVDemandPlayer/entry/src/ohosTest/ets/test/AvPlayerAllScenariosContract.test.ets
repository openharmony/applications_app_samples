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
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { ItemsType } from '../../../main/ets/const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import { drm } from '@kit.DrmKit';

class MockPlayer extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  seekTimes: number[] = [];
  currentSpeed: number = 0;

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
    return Promise.resolve();
  }

  release(): Promise<void> {
    return Promise.resolve();
  }

  setSpeed(speed: number): void {
    this.currentSpeed = speed;
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.currentTime = time;
    this.seekTimes.push(time);
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

class MockKeyEvent implements KeyEvent {
  keyCode: number;
  type: number;
  keyText: string = '';
  keySource: number = 0;
  deviceId: number = 0;
  metaKey: number = 0;
  unicodeChar: number = 0;
  timestamp: number = 0;
  intentionCode: number = 0;

  constructor(keyCode: number, type: number) {
    this.keyCode = keyCode;
    this.type = type;
  }

  stopPropagation(): void {
  }
}

function makeItem(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

export default function AvPlayerAllScenariosContract001Test() {
  const casePrefix = 'DemandPlayer_AvPlayerAllScenariosContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerAllScenariosContract001TestSuite', () => {
    it(addCase(casePrefix + 'KeyEventLeftRight_DPadLeft_Up_NoSeek_003'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 0));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_DPadRight_Up_NoSeek_004'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(213, 0));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_UpDown_NoIntercept_005'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(210, 1));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_BackKey_NoIntercept_006'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(4, 1));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_HomeKey_NoIntercept_007'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(36, 1));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_PausedState_NoSeek_008'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'paused';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_StoppedState_NoSeek_009'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'stopped';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_NullPlayer_NoCrash_010'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stop_ResetsAudioTrackIndex_Minus1_013'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.currentAudioTrackIndex = 99;
      player.avPlayer = new MockPlayer();
      player.stop();
      expect(player.currentAudioTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Stop_SetsHideXComponentTrue_014'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = new MockPlayer();
      AppStorage.setOrCreate('hideXComponent', false);
      player.stop();
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SetSpeed_AllSpeeds_Propagate_015'), 0, () => {
      const speeds = [0.75, 1.0, 1.5, 2.0, 4.0];
      for (let i = 0; i < speeds.length; i++) {
        const player = new VideoAVPlayerClass();
        const mockPlayer = new MockPlayer();
        player.avPlayer = mockPlayer;
        player.setSpeed(makeItem('s' + i, speeds[i] + 'X', speeds[i]));
        expect(mockPlayer.currentSpeed).assertEqual(speeds[i]);
      }
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_KnownName_Preserved_016'), 0, () => {
      const player = new VideoAVPlayerClass();
      const known = ['英语', '法语', '德语', '日语', '韩语', '西班牙语'];
      const trackItems: ItemsType[] = known.map((name: string, i: number) => makeItem(String(i), name, i));
      const result = player.processAudioTracks(trackItems);
      for (let i = 0; i < known.length; i++) {
        expect(result[i].name).assertEqual(known[i]);
      }
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_UnknownRename_017'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([makeItem('1', '未知', 0), makeItem('2', '未知', 1)]);
      expect(result[0].name).assertEqual('音轨1');
      expect(result[1].name).assertEqual('音轨2');
    });

    it(addCase(casePrefix + 'SeekVideo_ForwardBoundary_9950_018'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 9990;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      player.seekVideo(0);
      expect(mockPlayer.seekTimes[0]).assertEqual(9950);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardBoundary_0_019'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 5;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      player.seekVideo(1);
      expect(mockPlayer.seekTimes[0]).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_MultipleForwardCalls_020'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 100000;
      player.avPlayer = mockPlayer;
      player.seekVideo(0);
      player.seekVideo(0);
      player.seekVideo(0);
      expect(mockPlayer.seekTimes.length).assertEqual(3);
      expect(mockPlayer.seekTimes[0]).assertEqual(15000);
      expect(mockPlayer.seekTimes[1]).assertEqual(25000);
      expect(mockPlayer.seekTimes[2]).assertEqual(35000);
    });
  });
}
