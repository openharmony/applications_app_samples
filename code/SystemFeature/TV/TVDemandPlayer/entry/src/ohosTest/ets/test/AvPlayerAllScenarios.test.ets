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
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { drm } from '@kit.DrmKit';
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { DrmModel, MediaKeySessionLike, MediaKeySystemLike } from '../../../main/ets/Model/DrmModel';
import { ItemsType } from '../../../main/ets/const/Type';
import { Rdb, RdbStoreLike, QueryResultLike } from '../../../main/ets/Model/Rdb';
import { SubWindow } from '../../../main/ets/Model/Window';

class MockQueryResult extends QueryResultLike {
  columnNames: string[] = ['IP'];
  columnCount: number = 1;
  rowCount: number = 0;
  rowIndex: number = 0;

  isAtFirstRow(): boolean {
    return true;
  }

  isAfterLastRow(): boolean {
    return false;
  }

  close(): void {
  }
}

class MockRdbStore extends RdbStoreLike {
  insertCount: number = 0;
  deleteCount: number = 0;
  queryResult: QueryResultLike = new MockQueryResult();

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_table: string, _bucket: relationalStore.ValuesBucket,
    callback: (err: BusinessError | null, rowId: number) => void): void {
    this.insertCount++;
    callback(null, 1);
  }

  delete(_predicates: relationalStore.RdbPredicates,
    callback: (err: BusinessError | null, rows: number) => void): void {
    this.deleteCount++;
    callback(null, 1);
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: string[]): Promise<QueryResultLike> {
    return Promise.resolve(this.queryResult);
  }
}

class MockMediaKeySession extends MediaKeySessionLike {
  on(_name: string, _cb: (eventInfo: drm.EventInfo) => void): void {
  }

  off(_event: string): void {
  }

  destroy(): void {
  }

  generateMediaKeyRequest(_mime: string, _pssh: Uint8Array, _type: number,
    _opt: drm.OptionsData[]): Promise<drm.MediaKeyRequest> {
    return Promise.reject(new Error('Not implemented'));
  }

  processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return Promise.resolve(new Uint8Array(0));
  }

  requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }
}

class MockMediaKeySystem extends MediaKeySystemLike {
  createMediaKeySession(_level: drm.ContentProtectionLevel): MediaKeySessionLike {
    return new MockMediaKeySession();
  }

  destroy(): void {
  }
}

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
  selectedTrackIndexes: number[] = [];
  resetCount: number = 0;
  lastSpeed: number = 0;

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

  setSpeed(speed: number): void {
    this.lastSpeed = speed;
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.currentTime = time;
    this.seekTimes.push(time);
  }

  selectTrack(trackId: number, _mode: media.SwitchMode): Promise<void> {
    this.selectedTrackIndexes.push(trackId);
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
  intentionCode: number = 0;
  timestamp: number = 0;

  constructor(keyCode: number, type: number) {
    this.keyCode = keyCode;
    this.type = type;
  }

  stopPropagation(): void {
  }
}

function item(id: string, name: string, param: number): ItemsType {
  const trackItem: ItemsType = { id: id, name: name, param: param };
  return trackItem;
}

export default function AvPlayerAllScenarios002Test() {
  const casePrefix = 'DemandPlayer_AvPlayerAllScenarios002_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  describe('AvPlayerAllScenarios002TestSuite', () => {
    it(addCase(casePrefix + 'SeekVideo_BatchForward_Boundary0_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 0;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 50; i++) {
        player.seekVideo(0);
      }
      expect(mockPlayer.seekTimes[49]).assertEqual(9950);
    });
    it(addCase(casePrefix + 'SeekVideo_BatchBackward_Boundary0_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 10000;
      mockPlayer.duration = 10000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 50; i++) {
        player.seekVideo(1);
      }
      expect(mockPlayer.seekTimes.length).assertEqual(50);
    });
    it(addCase(casePrefix + 'SetSpeed_AllSpeeds_CalledSequentially_003'), 0, () => {
      const speeds: number[] = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0];
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      player.avPlayer = mockPlayer;
      for (let i = 0; i < speeds.length; i++) {
        player.setSpeed(item('s' + i, speeds[i] + 'X', speeds[i]));
      }
      expect(mockPlayer.lastSpeed).assertEqual(4);
    });
    it(addCase(casePrefix + 'ProcessAudioTracks_100Tracks_004'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [];
      for (let i = 0; i < 100; i++) {
        tracks.push(item(String(i), '未知', i));
      }
      expect(player.processAudioTracks(tracks).length).assertEqual(100);
    });
    it(addCase(casePrefix + 'ProcessAudioTracks_100Known_005'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [];
      for (let i = 0; i < 100; i++) {
        tracks.push(item(String(i), '音轨' + (i + 1), i));
      }
      expect(player.processAudioTracks(tracks).length).assertEqual(100);
    });
    it(addCase(casePrefix + 'ProcessAudioTracks_100Mixed_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: ItemsType[] = [];
      for (let i = 0; i < 100; i++) {
        tracks.push(item(String(i), i % 3 === 0 ? '未知' : '音轨' + i, i));
      }
      expect(player.processAudioTracks(tracks).length).assertEqual(100);
    });
    it(addCase(casePrefix + 'SetAudioTracks_100Tracks_SelectEach_007'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'prepared';
      mockPlayer.currentTime = 100;
      mockPlayer.duration = 1000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 100; i++) {
        await player.setAudioTracks(item('t' + i, '音轨' + i, i), 100, false);
      }
      expect(mockPlayer.selectedTrackIndexes.length).assertEqual(100);
    });
    it(addCase(casePrefix + 'Stop_100Times_008'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 100; i++) {
        player.stop();
      }
      expect(mockPlayer.resetCount).assertEqual(100);
    });
    it(addCase(casePrefix + 'Stop_NullPlayer_100Times_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 100; i++) {
        let threw = false;
        try {
          player.stop();
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'SetSpeed_NullPlayer_100Times_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 100; i++) {
        let threw = false;
        try {
          player.setSpeed(item('s' + i, '1X', 1));
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'SeekVideo_NullPlayer_100Times_011'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 100; i++) {
        let threw = false;
        try {
          player.seekVideo(0);
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'Rdb_Insert_100UniqueIPs_012'), 0, () => {
      const rdb = new Rdb();
      const store = new MockRdbStore();
      rdb.rdbStore = store;
      for (let i = 0; i < 100; i++) {
        rdb.insetRdb('192.168.' + i + '.1');
      }
      expect(store.insertCount).assertEqual(100);
    });
    it(addCase(casePrefix + 'Rdb_Delete_100UniqueIPs_013'), 0, () => {
      const rdb = new Rdb();
      const store = new MockRdbStore();
      rdb.rdbStore = store;
      for (let i = 0; i < 100; i++) {
        rdb.deleteRdb('10.0.' + i + '.1');
      }
      expect(store.deleteCount).assertEqual(100);
    });
    it(addCase(casePrefix + 'Rdb_InsertDelete_50Pairs_014'), 0, () => {
      const rdb = new Rdb();
      const store = new MockRdbStore();
      rdb.rdbStore = store;
      for (let i = 0; i < 50; i++) {
        rdb.insetRdb('172.16.' + i + '.1');
        rdb.deleteRdb('172.16.' + i + '.1');
      }
      expect(store.insertCount + store.deleteCount).assertEqual(100);
    });
    it(addCase(casePrefix + 'Rdb_EqualTo_100Queries_015'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new MockRdbStore();
      for (let i = 0; i < 100; i++) {
        expect(await rdb.equalTo('0.0.0.' + i)).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'Drm_StringToByte_50Payloads_016'), 0, () => {
      const model = new DrmModel();
      for (let size = 100; size <= 5000; size += 100) {
        const encoded = model.stringToByte('A'.repeat(size));
        expect(encoded.length).assertEqual(size);
      }
    });
    it(addCase(casePrefix + 'Drm_ByteToString_50Payloads_017'), 0, () => {
      const model = new DrmModel();
      for (let size = 100; size <= 5000; size += 100) {
        const data = new Uint8Array(size);
        for (let i = 0; i < size; i++) {
          data[i] = i % 256;
        }
        expect(model.byteToString(data).length).assertEqual(size);
      }
    });
    it(addCase(casePrefix + 'Drm_ReleaseDrm_100Instances_018'), 0, () => {
      for (let i = 0; i < 100; i++) {
        const model = new DrmModel();
        model.mediaKeySession = new MockMediaKeySession();
        model.mediaKeySystem = new MockMediaKeySystem();
        model.releaseDrm();
        expect(model.mediaKeySession === undefined).assertEqual(true);
      }
    });
    it(addCase(casePrefix + 'SubWindow_Destroy_100Nulls_019'), 0, () => {
      const subWindow = new SubWindow();
      for (let i = 0; i < 100; i++) {
        let threw = false;
        try {
          subWindow.destroySubWindow(null);
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'SubWindow_EndUIAbility_100Times_020'), 0, () => {
      const subWindow = new SubWindow();
      for (let i = 0; i < 100; i++) {
        let threw = false;
        try {
          subWindow.endUIAbility();
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });
    it(addCase(casePrefix + 'KeyEventLeftRight_50LeftKeys_021'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 50000;
      mockPlayer.duration = 100000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 50; i++) {
        await player.keyEventLeftRight(new MockKeyEvent(212, 1));
      }
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });
    it(addCase(casePrefix + 'KeyEventLeftRight_50RightKeys_022'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new MockPlayer();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 50000;
      mockPlayer.duration = 100000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < 50; i++) {
        await player.keyEventLeftRight(new MockKeyEvent(213, 1));
      }
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });
    it(addCase(casePrefix + 'KeyEventLeftRight_NonPlaying_NoSeek_023'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const states: media.AVPlayerState[] = ['idle', 'paused', 'stopped', 'released', 'prepared'];
      const mockPlayer = new MockPlayer();
      mockPlayer.currentTime = 50000;
      mockPlayer.duration = 100000;
      player.avPlayer = mockPlayer;
      for (let i = 0; i < states.length; i++) {
        mockPlayer.state = states[i];
        await player.keyEventLeftRight(new MockKeyEvent(212, 1));
        await player.keyEventLeftRight(new MockKeyEvent(213, 1));
      }
      expect(mockPlayer.seekTimes.length).assertEqual(0);
    });
    it(addCase(casePrefix + 'CaseNamePattern_024'), 0, () => {
      expect(allCaseNames.length).assertEqual(24);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_AvPlayerAllScenarios002_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
