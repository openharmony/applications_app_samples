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
  lastSeekTime: number = -1;
  setSpeedValue: number = -1;
  selectTrackCount: number = 0;
  playCount: number = 0;

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
    this.playCount++;
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
    this.setSpeedValue = speed;
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.lastSeekTime = time;
  }

  selectTrack(_trackId: number, _mode: media.SwitchMode): Promise<void> {
    this.selectTrackCount++;
    return Promise.resolve();
  }

  addSubtitleFromUrl(_url: string): Promise<void> {
    return Promise.resolve();
  }

  setDecryptionConfig(_session: drm.MediaKeySession, _svp: boolean): void {
  }
}

class CountingTrackPlayer extends MockPlayer {
  selectedTrackIndex: number = -1;

  override async selectTrack(trackId: number, _mode: media.SwitchMode): Promise<void> {
    this.selectTrackCount++;
    this.selectedTrackIndex = trackId;
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
  private readonly stopPropagationCallback: (() => void) | null;

  constructor(keyCode: number, type: number, stopPropagationCallback: (() => void) | null = null) {
    this.keyCode = keyCode;
    this.type = type;
    this.stopPropagationCallback = stopPropagationCallback;
  }

  stopPropagation(): void {
    if (this.stopPropagationCallback !== null) {
      this.stopPropagationCallback();
    }
  }
}

function createItem(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

export default function AvPlayerStateMachineContract001Test() {
  const casePrefix = 'DemandPlayer_AvPlayerStateMachineContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerStateMachineContract001TestSuite', () => {
    it(addCase(casePrefix + 'KeyEventLeftRight_LeftKey_StopPropagation_001'), 0, async () => {
      const player = new VideoAVPlayerClass();
      let propagated = true;
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 1, () => {
        propagated = false;
      }));
      expect(propagated).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_RightKey_StopPropagation_002'), 0, async () => {
      const player = new VideoAVPlayerClass();
      let propagated = true;
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(213, 1, () => {
        propagated = false;
      }));
      expect(propagated).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_LeftKey_NotPlaying_NoSeek_005'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'paused';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_RightKey_NotPlaying_NoSeek_006'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'stopped';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(213, 1));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_NullPlayer_NoCrash_007'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      } catch (_e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_UpKey_NotIntercepted_008'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(210, 1));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_DownKey_NotIntercepted_009'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(211, 1));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_BackKey_NotIntercepted_010'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(4, 1));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyEventLeftRight_LeftKeyUp_NoSeek_011'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 5000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      await player.keyEventLeftRight(new MockKeyEvent(212, 0));
      expect(mockPlayer.lastSeekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_LargeKnownList_013'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [
        createItem('1', '英语', 0),
        createItem('2', '法语', 1),
        createItem('3', '德语', 2),
        createItem('4', '日语', 3),
        createItem('5', '韩语', 4)
      ];
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(5);
      expect(result[0].name).assertEqual('英语');
      expect(result[4].name).assertEqual('韩语');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_AllUnknownRenamedSequentially_014'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [
        createItem('1', '未知', 0),
        createItem('2', '未知', 1),
        createItem('3', '未知', 2)
      ];
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(3);
      expect(result[0].name).assertEqual('音轨1');
      expect(result[1].name).assertEqual('音轨2');
      expect(result[2].name).assertEqual('音轨3');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_InputOrderPreservedForKnown_015'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [
        createItem('2', '法语', 1),
        createItem('0', '英语', 0),
        createItem('4', '日语', 3)
      ];
      const result = player.processAudioTracks(tracks);
      expect(result[0].name).assertEqual('法语');
      expect(result[1].name).assertEqual('英语');
      expect(result[2].name).assertEqual('日语');
    });
  });
}
