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
  speedHistory: number[] = [];
  seekHistory: number[] = [];

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
    this.speedHistory.push(speed);
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.currentTime = time;
    this.seekHistory.push(time);
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
  const speedItem: ItemsType = { id: id, name: name, param: param };
  return speedItem;
}

export default function AvPlayerSeekSpeedContract001Test() {
  const casePrefix = 'DemandPlayer_AvPlayerSeekSpeedContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerSeekSpeedContract001TestSuite', () => {
    it(addCase(casePrefix + 'SeekVideo_ForwardNearEnd_ClampedToDurationMinus50_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 9990;
      mock.duration = 10000;
      player.avPlayer = mock;
      player.seekVideo(0);
      expect(mock.seekHistory[0]).assertEqual(9950);
    });

    it(addCase(casePrefix + 'SeekVideo_ForwardFarFromEnd_LessThanDuration_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 5000;
      mock.duration = 20000;
      player.avPlayer = mock;
      player.seekVideo(0);
      expect(mock.seekHistory[0]).assertEqual(15000);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardNearZero_ClampedToZero_003'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 50;
      mock.duration = 10000;
      player.avPlayer = mock;
      player.seekVideo(1);
      expect(mock.seekHistory[0]).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardMidpoint_NegativeOffset_004'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 7000;
      mock.duration = 20000;
      player.avPlayer = mock;
      player.seekVideo(1);
      expect(mock.seekHistory[0]).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_NoPlayer_NullGuard_005'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        player.seekVideo(0);
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SeekVideo_DurationZero_PreventsNaN_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 0;
      mock.duration = 0;
      player.avPlayer = mock;
      player.seekVideo(0);
      expect(mock.seekHistory[0]).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardAtZero_NoNegative_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 0;
      mock.duration = 10000;
      player.avPlayer = mock;
      player.seekVideo(1);
      expect(mock.seekHistory[0]).assertEqual(0);
    });

    it(addCase(casePrefix + 'SetSpeed_Speed2X_PropagatesToKernel_008'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      player.avPlayer = mock;
      player.setSpeed(createItem('s1', '2.0X', 2));
      expect(mock.speedHistory[0]).assertEqual(2);
      expect(globalThis.videoSpeed).assertEqual(2);
    });

    it(addCase(casePrefix + 'SetSpeed_Speed0_5X_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      player.avPlayer = mock;
      player.setSpeed(createItem('s2', '0.5X', 0.5));
      expect(mock.speedHistory[0]).assertEqual(0.5);
    });

    it(addCase(casePrefix + 'SetSpeed_NoPlayer_GlobalStateOnly_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.setSpeed(createItem('s3', '1.5X', 1.5));
      expect(globalThis.videoSpeed).assertEqual(1.5);
    });

    it(addCase(casePrefix + 'SeekVideo_MultipleCalls_AccumulatesOffset_011'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      mock.currentTime = 5000;
      mock.duration = 100000;
      player.avPlayer = mock;
      player.seekVideo(0);
      player.seekVideo(0);
      player.seekVideo(0);
      expect(mock.seekHistory.length).assertEqual(3);
      expect(mock.seekHistory[0]).assertEqual(15000);
      expect(mock.seekHistory[1]).assertEqual(25000);
      expect(mock.seekHistory[2]).assertEqual(35000);
    });

    it(addCase(casePrefix + 'SetSpeed_DifferentSpeeds_Overwrite_012'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockPlayer();
      player.avPlayer = mock;
      player.setSpeed(createItem('s4', '0.75X', 0.75));
      player.setSpeed(createItem('s5', '1.0X', 1));
      player.setSpeed(createItem('s6', '2.0X', 2));
      expect(mock.speedHistory.length).assertEqual(3);
      expect(mock.speedHistory[2]).assertEqual(2);
    });

    it(addCase(casePrefix + 'CaseNamePattern_013'), 0, () => {
      expect(allCaseNames.length).assertEqual(13);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AvPlayerSeekSpeedContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
