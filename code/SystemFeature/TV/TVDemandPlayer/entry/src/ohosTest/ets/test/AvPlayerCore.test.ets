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
import { media } from '@kit.MediaKit';
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { ItemsType } from '../../../main/ets/const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import { drm } from '@kit.DrmKit';

class MockAVPlayer extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  seekTimes: number[] = [];
  speedValue: number = 0;
  resetCalled: boolean = false;
  playCount: number = 0;
  pauseCount: number = 0;
  selectedTrackIndex: number = -1;
  triggerStateChange: boolean = false;
  emittedError: BusinessError | null = null;

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
    this.pauseCount++;
    return Promise.resolve();
  }

  reset(): Promise<void> {
    this.resetCalled = true;
    return Promise.resolve();
  }

  release(): Promise<void> {
    return Promise.resolve();
  }

  setSpeed(speed: number): void {
    this.speedValue = speed;
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.currentTime = time;
    this.seekTimes.push(time);
  }

  selectTrack(trackId: number, _mode: media.SwitchMode): Promise<void> {
    this.selectedTrackIndex = trackId;
    return Promise.resolve();
  }

  addSubtitleFromUrl(_url: string): Promise<void> {
    return Promise.resolve();
  }

  setDecryptionConfig(_session: drm.MediaKeySession, _svp: boolean): void {
  }
}

function createTrack(id: string, name: string, param: number): ItemsType {
  return { id, name, param };
}

function generateTrackList(count: number, unknownCount: number): ItemsType[] {
  const list: ItemsType[] = [];
  for (let i = 0; i < count - unknownCount; i++) {
    list.push(createTrack(`track_${i}`, `Language_${i}`, i));
  }
  for (let i = 0; i < unknownCount; i++) {
    list.push(createTrack(`unknown_${i}`, '??', count - unknownCount + i));
  }
  return list;
}

export default function AvPlayerCore001Test() {
  describe('AvPlayerCore001TestSuite', () => {
    it('DemandPlayer_AvPlayer_Seek_001', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.currentTime = 50000;
      mock.duration = 200000;
      player.avPlayer = mock;
      player.seekVideo(0);
      expect(mock.seekTimes[0]).assertEqual(60000);
    });

    it('DemandPlayer_AvPlayer_Seek_002', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.currentTime = 50000;
      mock.duration = 200000;
      player.avPlayer = mock;
      player.seekVideo(1);
      expect(mock.seekTimes[0]).assertEqual(40000);
    });

    it('DemandPlayer_AvPlayer_Seek_Boundary_001', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.currentTime = 195000;
      mock.duration = 200000;
      player.avPlayer = mock;
      player.seekVideo(0);
      expect(mock.seekTimes[0]).assertEqual(199950);
    });

    it('DemandPlayer_AvPlayer_Seek_Boundary_002', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.currentTime = 5000;
      mock.duration = 200000;
      player.avPlayer = mock;
      player.seekVideo(1);
      expect(mock.seekTimes[0]).assertEqual(0);
    });

    it('DemandPlayer_AvPlayer_Tracks_001', 0, () => {
      const player = new VideoAVPlayerClass();
      const rawTracks: ItemsType[] = [
        createTrack('1', 'Chinese', 1),
        createTrack('2', 'English', 3)
      ];
      const processed = player.processAudioTracks(rawTracks);
      expect(processed[0].name).assertEqual('Chinese');
      expect(processed[1].name).assertEqual('English');
    });

    it('DemandPlayer_AvPlayer_Tracks_002', 0, () => {
      const player = new VideoAVPlayerClass();
      expect(player.processAudioTracks([]).length).assertEqual(0);
    });

    it('DemandPlayer_AvPlayer_Tracks_003', 0, () => {
      const player = new VideoAVPlayerClass();
      const processed = player.processAudioTracks(generateTrackList(5, 2));
      expect(processed.length).assertEqual(5);
      expect(processed[0].name).assertEqual('Language_0');
    });

    it('DemandPlayer_AvPlayer_Speed_001', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      player.avPlayer = mock;
      player.setSpeed(createTrack('s1', '1.5X', 1.5));
      expect(mock.speedValue).assertEqual(1.5);
      expect(globalThis.videoSpeed).assertEqual(1.5);
    });

    it('DemandPlayer_AvPlayer_Stop_001', 0, () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      player.avPlayer = mock;
      player.stop();
      expect(mock.resetCalled).assertTrue();
      expect(AppStorage.get('hideXComponent')).assertTrue();
    });

    it('DemandPlayer_AvPlayer_Track_Switch_001', 0, async () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.state = 'playing';
      mock.currentTime = 100000;
      player.avPlayer = mock;
      await player.setAudioTracks(createTrack('t1', 'English', 1), 100000);
      expect(mock.selectedTrackIndex).assertEqual(1);
      expect(mock.seekTimes[0]).assertEqual(100040);
    });

    it('DemandPlayer_AvPlayer_Track_Switch_002', 0, async () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.state = 'idle';
      player.avPlayer = mock;
      await player.setAudioTracks(createTrack('t1', 'English', 1), 0);
      expect(mock.selectedTrackIndex).assertEqual(-1);
    });

    it('DemandPlayer_AvPlayer_PlaySource_002', 0, async () => {
      const player = new VideoAVPlayerClass();
      const mock = new MockAVPlayer();
      mock.state = 'idle';
      player.avPlayer = mock;
      const videoUrl = 'https://example.com/test.mp4';
      await player.play(videoUrl);
      expect(mock.url).assertEqual(videoUrl);
    });

    it('DemandPlayer_AvPlayer_Speed_Variation_001', 0, () => {
      const speeds: number[] = [0.75, 1.0, 1.25, 1.5, 2.0];
      for (let i = 0; i < speeds.length; i++) {
        const player = new VideoAVPlayerClass();
        const mock = new MockAVPlayer();
        player.avPlayer = mock;
        player.setSpeed(createTrack('s', speeds[i] + 'x', speeds[i]));
        expect(mock.speedValue).assertEqual(speeds[i]);
      }
    });
  });
}
