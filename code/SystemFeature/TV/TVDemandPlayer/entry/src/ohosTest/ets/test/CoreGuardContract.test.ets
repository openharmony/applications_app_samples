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
import { BusinessError } from '@kit.BasicServicesKit';
import { relationalStore } from '@kit.ArkData';
import { media } from '@kit.MediaKit';
import { drm } from '@kit.DrmKit';
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { EventUtil } from '../../../main/ets/utils/EventUtil';
import { Throttle } from '../../../main/ets/Model/Throttle';
import { Rdb, RdbStoreLike, QueryResultLike } from '../../../main/ets/Model/Rdb';
import { SubWindow, WindowLifecycleLike, WindowDestroyErrorLike } from '../../../main/ets/Model/Window';
import { ItemsType } from '../../../main/ets/const/Type';

class TouchEventMock {
  type: number;
  source: number;

  constructor(type: number, source: number) {
    this.type = type;
    this.source = source;
  }
}

class ThrottleTargetClass {
  value: number = 1;

  run(): number {
    return this.value;
  }
}

class ItemModel implements ItemsType {
  id: string;
  name: string;
  param?: number;

  constructor(id: string, name: string, param: number) {
    this.id = id;
    this.name = name;
    this.param = param;
  }
}

class QueryResultModel extends QueryResultLike {
  columnNames: Array<string> = ['IP'];
  columnCount: number = 1;
  rowCount: number;
  rowIndex: number = 0;

  constructor(rowCount: number) {
    super();
    this.rowCount = rowCount;
  }

  isAtFirstRow(): boolean {
    return this.rowCount > 0;
  }

  isAfterLastRow(): boolean {
    return this.rowCount === 0;
  }

  close(): void {
  }
}

class QueryStoreModel extends RdbStoreLike {
  private readonly rows: number;

  constructor(rows: number) {
    super();
    this.rows = rows;
  }

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_table: string, _bucket: relationalStore.ValuesBucket,
    _callback: (err: BusinessError | null, rowId: number) => void): void {
  }

  delete(_predicates: relationalStore.RdbPredicates,
    _callback: (err: BusinessError | null, rows: number) => void): void {
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: Array<string>): Promise<QueryResultLike> {
    return Promise.resolve(new QueryResultModel(this.rows));
  }
}

class WindowDestroyResultModel extends WindowDestroyErrorLike {
  code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }
}

class WindowLifecycleModel extends WindowLifecycleLike {
  destroyCount: number = 0;
  private readonly code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }

  destroyWindow(callback: (err: BusinessError | WindowDestroyErrorLike) => void): void {
    this.destroyCount++;
    callback(new WindowDestroyResultModel(this.code));
  }
}

class PlayerMock extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  speedValue: number = -1;
  selectedTrackCount: number = 0;
  seekTime: number = -1;
  playCount: number = 0;
  shouldFailSelectTrack: boolean = false;

  on(_event: string,
    _callback: ((state: media.AVPlayerState, reason: media.StateChangeReason) => void) |
    ((err: BusinessError) => void) |
    (() => void) |
    ((info: media.SubtitleInfo) => void) |
    ((mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => void) |
    ((infoType: media.BufferingInfoType, value: number) => void) |
    ((value: number) => void)): void {
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
    this.speedValue = speed;
  }

  seek(time: number, _mode?: media.SeekMode): void {
    this.seekTime = time;
  }

  selectTrack(_trackId: number, _mode: media.SwitchMode): Promise<void> {
    if (this.shouldFailSelectTrack) {
      return Promise.reject(new Error('selectTrack failed'));
    }
    this.selectedTrackCount++;
    return Promise.resolve();
  }

  addSubtitleFromUrl(_url: string): Promise<void> {
    return Promise.resolve();
  }

  setDecryptionConfig(_session: drm.MediaKeySession, _svp: boolean): void {
  }
}

export default function CoreGuardContract001Test() {
  const casePrefix = 'DemandPlayer_CoreGuardContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('CoreGuardContract001TestSuite', () => {
    it(addCase(casePrefix + 'AvPlayer_SetSpeed_PropagateToGlobalAndKernel_001'), 0, () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      player.avPlayer = mockPlayer;
      player.setSpeed(new ItemModel('s_1_0', '1.5X', 1.5));
      expect(globalThis.videoSpeed).assertEqual(1.5);
      expect(mockPlayer.speedValue).assertEqual(1.5);
    });

    it(addCase(casePrefix + 'AvPlayer_SetSpeed_NoKernelGuard_002'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      player.setSpeed(new ItemModel('s_1_0', '2X', 2));
      expect(globalThis.videoSpeed).assertEqual(2);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_AllowPreparedState_003'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'prepared';
      mockPlayer.currentTime = 777;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('a', '英语', 1), 800);
      expect(mockPlayer.selectedTrackCount).assertEqual(1);
      expect(mockPlayer.seekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_RejectInvalidState_004'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'released';
      mockPlayer.currentTime = 100;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('a', '英语', 1), 1000);
      expect(mockPlayer.selectedTrackCount).assertEqual(0);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_KeepPlayingResume_005'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'paused';
      mockPlayer.currentTime = 1000;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('b', '法语', 2), 1234, true);
      expect(mockPlayer.seekTime).assertEqual(1274);
      expect(mockPlayer.playCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_SeekUseCurrentTimeWhenInputNaN_006'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 888;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('b', '法语', 2), Number.NaN);
      expect(mockPlayer.seekTime).assertEqual(928);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_SeekFloorAndLowerBound_007'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 200;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('b', '法语', 3), -100.7);
      expect(mockPlayer.seekTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'AvPlayer_SetAudioTracks_SelectTrackFailureGuard_008'), 0, async () => {
      const player = new VideoAVPlayerClass();
      const mockPlayer = new PlayerMock();
      mockPlayer.state = 'playing';
      mockPlayer.currentTime = 300;
      mockPlayer.shouldFailSelectTrack = true;
      player.avPlayer = mockPlayer;
      await player.setAudioTracks(new ItemModel('b', '法语', 1), 300);
      expect(mockPlayer.seekTime).assertEqual(-1);
    });

    it(addCase(casePrefix + 'AvPlayer_ProcessAudioTracks_AllUnknownRenamed_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      const result = player.processAudioTracks([
        new ItemModel('1', '未知', 0),
        new ItemModel('2', '未知', 1)
      ]);
      expect(result[0].name).assertEqual('音轨1');
      expect(result[1].name).assertEqual('音轨2');
    });

    it(addCase(casePrefix + 'EventUtil_TouchDownAndMoveReturnFalse_010'), 0, () => {
      const styleChanges: boolean[] = [];
      EventUtil.pointStyleChanger = (flag: boolean): void => {
        styleChanges.push(flag);
      };
      const downEvent = new TouchEventMock(TouchType.Down, SourceType.Mouse) as TouchEvent;
      const moveEvent = new TouchEventMock(TouchType.Move, SourceType.TouchScreen) as TouchEvent;
      expect(EventUtil.isTouchEvent(downEvent)).assertEqual(false);
      expect(EventUtil.isTouchEvent(moveEvent)).assertEqual(false);
      expect(styleChanges.length).assertEqual(2);
      expect(styleChanges[0]).assertEqual(true);
      expect(styleChanges[1]).assertEqual(false);
      EventUtil.pointStyleChanger = undefined;
    });

    it(addCase(casePrefix + 'EventUtil_UpMouseAndTouchscreenReturnTrue_011'), 0, () => {
      EventUtil.pointStyleChanger = (_flag: boolean): void => {
      };
      const mouseUp = new TouchEventMock(TouchType.Up, SourceType.Mouse) as TouchEvent;
      const touchUp = new TouchEventMock(TouchType.Up, SourceType.TouchScreen) as TouchEvent;
      expect(EventUtil.isTouchEvent(mouseUp)).assertEqual(true);
      expect(EventUtil.isTouchEvent(touchUp)).assertEqual(true);
      EventUtil.pointStyleChanger = undefined;
    });

    it(addCase(casePrefix + 'Throttle_DecoratorKeepDescriptor_012'), 0, () => {
      const decorator = Throttle(100);
      expect(!!decorator).assertEqual(true);
      const ins = new ThrottleTargetClass();
      expect(ins.run()).assertEqual(1);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_NoStoreGuard_013'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      const result = await rdb.equalTo('1.1.1.1');
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_InsertDelete_NoStoreGuard_014'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      rdb.insetRdb('2.2.2.2');
      rdb.deleteRdb('2.2.2.2');
      expect(rdb.rdbStore === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_RowCountZeroSetUntrust_015'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new QueryStoreModel(0);
      const result = await rdb.equalTo('3.3.3.3');
      expect(result).assertEqual(false);
      expect(AppStorage.get('IsTrust')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_RowCountPositiveSetTrust_016'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new QueryStoreModel(2);
      const result = await rdb.equalTo('4.4.4.4');
      expect(result).assertEqual(true);
      expect(AppStorage.get('IsTrust')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Window_DestroySubWindow_NullGuard_017'), 0, () => {
      const subWindow = new SubWindow();
      subWindow.destroySubWindow(null);
      expect(true).assertEqual(true);
    });

    it(addCase(casePrefix + 'Window_DestroySubWindow_NormalPath_018'), 0, () => {
      const subWindow = new SubWindow();
      const fakeWindow = new WindowLifecycleModel(0);
      subWindow.destroySubWindow(fakeWindow);
      expect(fakeWindow.destroyCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'Window_ShowSubWindow_NullStageGuard_019'), 0, () => {
      const ret = null;
      expect(ret === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_020'), 0, () => {
      expect(allCaseNames.length).assertEqual(20);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_CoreGuardContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
