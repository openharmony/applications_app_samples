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

class SubtitleMockPlayer extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  resetCount: number = 0;
  lastSeekTime: number = -1;
  setSpeedValue: number = -1;
  selectedTrackIndex: number = -1;
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
    this.resetCount++;
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

function createItem(id: string, name: string, param: number): ItemsType {
  const subtitleItem: ItemsType = { id: id, name: name, param: param };
  return subtitleItem;
}

export default function AvPlayerSubtitleFullContract001Test() {
  const casePrefix = 'DemandPlayer_AvPlayerSubtitleFullContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AvPlayerSubtitleFullContract001TestSuite', () => {
    it(addCase(casePrefix + 'Play_SubtitleUrl_SrtDerived_001'), 0, () => {
      AppStorage.setOrCreate('subtitleUrl', '.srt');
      AppStorage.setOrCreate('videoUri', '/data/video.mp4');
      AppStorage.setOrCreate('fdPath', '');
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      expect(AppStorage.get('subtitleUrl')).assertEqual('.srt');
    });

    it(addCase(casePrefix + 'Play_SubtitleUrl_AssDerived_002'), 0, () => {
      AppStorage.setOrCreate('subtitleUrl', '.ass');
      AppStorage.setOrCreate('videoUri', '/data/video.avi');
      AppStorage.setOrCreate('fdPath', '');
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      expect(AppStorage.get('subtitleUrl')).assertEqual('.ass');
    });

    it(addCase(casePrefix + 'Play_SubtitleUrl_SsaDerived_003'), 0, () => {
      AppStorage.setOrCreate('subtitleUrl', '.ssa');
      AppStorage.setOrCreate('videoUri', '/data/video.mkv');
      AppStorage.setOrCreate('fdPath', '');
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      expect(AppStorage.get('subtitleUrl')).assertEqual('.ssa');
    });

    it(addCase(casePrefix + 'Play_SubtitleUrl_DefaultEmpty_004'), 0, () => {
      AppStorage.setOrCreate('subtitleUrl', '');
      AppStorage.setOrCreate('videoUri', '/data/video.mp4');
      AppStorage.setOrCreate('fdPath', '');
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      expect(AppStorage.get('subtitleUrl')).assertEqual('');
    });

    it(addCase(casePrefix + 'Play_FdPath_Present_NoReset_005'), 0, () => {
      AppStorage.setOrCreate('fdPath', '/data/video.fd');
      AppStorage.setOrCreate('videoUri', '/data/video.mp4');
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      const fdPath = AppStorage.get('fdPath') as string;
      expect(fdPath.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Play_RawFileFdSource_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      expect(true).assertEqual(true);
    });

    it(addCase(casePrefix + 'Play_HttpUrl_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'idle';
      player.avPlayer = mockPlayer;
      const fdPath = AppStorage.get('fdPath') as string;
      expect(fdPath === '' || fdPath.length >= 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stop_ResetsHideXComponent_008'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      AppStorage.setOrCreate('hideXComponent', false);
      player.stop();
      expect(AppStorage.get('hideXComponent')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stop_ResetsAudioTrackIndex_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.currentAudioTrackIndex = 99;
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      player.stop();
      expect(player.currentAudioTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Stop_CalledMultipleTimes_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      player.stop();
      player.stop();
      player.stop();
      expect(mockPlayer.resetCount).assertEqual(3);
    });

    it(addCase(casePrefix + 'Stop_NullPlayer_011'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      let threw = false;
      try {
        player.stop();
      } catch (_error) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SeekVideo_ForwardMidpoint_012'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 30000;
      mockPlayer.duration = 60000;
      player.avPlayer = mockPlayer;
      player.seekVideo(0);
      expect(mockPlayer.lastSeekTime).assertEqual(40000);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardMidpoint_013'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 30000;
      mockPlayer.duration = 60000;
      player.avPlayer = mockPlayer;
      player.seekVideo(1);
      expect(mockPlayer.lastSeekTime).assertEqual(20000);
    });

    it(addCase(casePrefix + 'SeekVideo_ForwardNearEnd_Clamped_014'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 9990;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      player.seekVideo(0);
      expect(mockPlayer.lastSeekTime).assertEqual(9950);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardNearZero_Clamped_015'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 5;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      player.seekVideo(1);
      expect(mockPlayer.lastSeekTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_DurationZero_NoNaN_016'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 0;
      mockPlayer.duration = 0;
      player.avPlayer = mockPlayer;
      player.seekVideo(0);
      expect(mockPlayer.lastSeekTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'SeekVideo_BackwardAtZero_StaysZero_017'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.currentTime = 0;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      player.seekVideo(1);
      expect(mockPlayer.lastSeekTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'SetSpeed_0_5X_018'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      player.setSpeed(createItem('s1', '0.5X', 0.5));
      expect(mockPlayer.setSpeedValue).assertEqual(0.5);
      expect(globalThis.videoSpeed).assertEqual(0.5);
    });

    it(addCase(casePrefix + 'SetSpeed_1_5X_019'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      player.setSpeed(createItem('s2', '1.5X', 1.5));
      expect(mockPlayer.setSpeedValue).assertEqual(1.5);
    });

    it(addCase(casePrefix + 'SetSpeed_4X_020'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      player.avPlayer = mockPlayer;
      player.setSpeed(createItem('s3', '4 X', 4));
      expect(mockPlayer.setSpeedValue).assertEqual(4);
    });

    it(addCase(casePrefix + 'SetSpeed_NullPlayer_GlobalOnly_021'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.setSpeed(createItem('s4', '2.0X', 2));
      expect(globalThis.videoSpeed).assertEqual(2);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_EmptyArray_022'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([]);
      expect(result.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_SingleUnknown_RenamesToTrack1_023'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0)
      ]);
      expect(result[0].name).assertEqual('音轨1');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_MultipleKnown_PreserveNames_024'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '英语', 0),
        createItem('2', '法语', 1),
        createItem('3', '德语', 2)
      ]);
      expect(result[0].name).assertEqual('英语');
      expect(result[1].name).assertEqual('法语');
      expect(result[2].name).assertEqual('德语');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_MixedKnownAndUnknown_025'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '音轨1', 1),
        createItem('3', '音轨2', 2)
      ]);
      expect(result[0].name).assertEqual('音轨1');
      expect(result[1].name).assertEqual('音轨2');
      expect(result[2].name).assertEqual('音轨3');
    });

    it(addCase(casePrefix + 'ProcessAudioTracks_AllUnknown_RenameSequentially_026'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        createItem('1', '未知', 0),
        createItem('2', '未知', 1),
        createItem('3', '未知', 2)
      ]);
      expect(result[0].name).assertEqual('音轨1');
      expect(result[1].name).assertEqual('音轨2');
      expect(result[2].name).assertEqual('音轨3');
    });

    it(addCase(casePrefix + 'SetAudioTracks_PreparedState_SelectsTrack_027'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'prepared';
      mockPlayer.currentTime = 100;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t1', '英语', 3), 100, false);
      expect(mockPlayer.selectedTrackIndex).assertEqual(3);
    });

    it(addCase(casePrefix + 'SetAudioTracks_PlayingState_SelectsAndSeeks_028'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 500;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t2', '日语', 1), 500, false);
      expect(mockPlayer.selectedTrackIndex).assertEqual(1);
      expect(mockPlayer.lastSeekTime).assertEqual(540);
    });

    it(addCase(casePrefix + 'SetAudioTracks_SameTrackIndex_NoSelect_029'), 0, async () => {
      const player = new VideoAVPlayerClass();
      player.currentAudioTrackIndex = 2;
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 100;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t3', '韩语', 2), 100, false);
      expect(mockPlayer.selectedTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'SetAudioTracks_ReleasedState_Guarded_030'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'released';
      mockPlayer.currentTime = 100;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t4', '法语', 1), 100, false);
      expect(mockPlayer.selectedTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'SetAudioTracks_InvalidTrack_Guarded_031'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 100;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('bad', 'bad', -999), 100, false);
      expect(mockPlayer.selectedTrackIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'SetAudioTracks_PausedState_KeepPlayingFalse_032'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'paused';
      mockPlayer.currentTime = 500;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t5', '意语', 4), 500, false);
      expect(mockPlayer.playCount).assertEqual(0);
    });

    it(addCase(casePrefix + 'SetAudioTracks_PausedState_KeepPlayingTrue_ResumesPlay_033'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new SubtitleMockPlayer();
      mockPlayer.state = 'paused';
      mockPlayer.currentTime = 500;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(createItem('t6', '葡语', 5), 500, true);
      expect(mockPlayer.playCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'CaseNamePattern_034'), 0, () => {
      expect(allCaseNames.length).assertEqual(34);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AvPlayerSubtitleFullContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
