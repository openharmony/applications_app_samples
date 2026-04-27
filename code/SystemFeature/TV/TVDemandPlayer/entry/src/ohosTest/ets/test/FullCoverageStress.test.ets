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
import { drm } from '@kit.DrmKit';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import { Rdb, RdbStoreLike, BasicErrorLike, QueryResultLike, TrustEquipmentBucket } from '../../../main/ets/Model/Rdb';
import {
  DrmModel,
  DrmSystemInfoLike,
  MediaKeySessionLike,
  MediaKeySystemLike,
  DecryptionAvPlayerLike,
  MediaKeyRequestResultLike
} from '../../../main/ets/Model/DrmModel';
import {
  SubWindow,
  WindowLifecycleLike,
  WindowDestroyErrorLike,
  WindowPropertiesLike as ModelWindowPropertiesLike,
  WindowRectLike as ModelWindowRectLike,
  WindowStageLike as ModelWindowStageLike,
  WindowContentLike as ModelWindowContentLike
} from '../../../main/ets/Model/Window';
import { EventBus, EventBusPayloadLike } from '../../../main/ets/utils/EventBus';
import { ItemsType } from '../../../main/ets/const/Type';

class WindowRectRecord extends ModelWindowRectLike {
  width: number;
  height: number;

  constructor(width: number, height: number) {
    super();
    this.width = width;
    this.height = height;
  }
}

class QueryCallbackError extends BasicErrorLike {
  code: number = 0;
  message: string = '';
  name: string = '';
}

type InsertCallbackLike = (err: QueryCallbackError | null, rowId: number) => void;
type DeleteCallbackLike = (err: QueryCallbackError | null, rows: number) => void;

class QueryResultLikeImpl extends QueryResultLike {
  columnNames: Array<string>;
  columnCount: number;
  rowCount: number;
  rowIndex: number;

  constructor(rowCount: number) {
    super();
    this.columnNames = ['IP'];
    this.columnCount = 1;
    this.rowCount = rowCount;
    this.rowIndex = 0;
  }

  isAtFirstRow(): boolean {
    return true;
  }

  isAfterLastRow(): boolean {
    return false;
  }

  close(): void {
  }
}

class StressRdbStore extends RdbStoreLike {
  private readonly onInsert?: (table: string, bucket: TrustEquipmentBucket, cb: InsertCallbackLike) => void;
  private readonly onDelete?: (predicates: relationalStore.RdbPredicates, cb: DeleteCallbackLike) => void;
  private readonly rowCount: number;

  constructor(
    rowCount: number = 0,
    onInsert?: (table: string, bucket: TrustEquipmentBucket, cb: InsertCallbackLike) => void,
    onDelete?: (predicates: relationalStore.RdbPredicates, cb: DeleteCallbackLike) => void
  ) {
    super();
    this.rowCount = rowCount;
    this.onInsert = onInsert;
    this.onDelete = onDelete;
  }

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(table: string, bucket: relationalStore.ValuesBucket,
    callback: (err: BusinessError | BasicErrorLike | null, rowId: number) => void): void {
    if (this.onInsert !== undefined) {
      const trustBucket = new TrustEquipmentBucket(String(bucket['IP']));
      this.onInsert(table, trustBucket, callback as InsertCallbackLike);
      return;
    }
    callback(null, 1);
  }

  delete(predicates: relationalStore.RdbPredicates,
    callback: (err: BusinessError | BasicErrorLike | null, rows: number) => void): void {
    if (this.onDelete !== undefined) {
      this.onDelete(predicates, callback as DeleteCallbackLike);
      return;
    }
    callback(null, 1);
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: Array<string>): Promise<QueryResultLike> {
    return Promise.resolve(new QueryResultLikeImpl(this.rowCount));
  }
}

class TrackItem implements ItemsType {
  id: string;
  name: string;
  param?: number;

  constructor(id: string, name: string, param: number) {
    this.id = id;
    this.name = name;
    this.param = param;
  }
}

class EventIndexPayload extends EventBusPayloadLike {
  i: number;

  constructor(i: number) {
    super();
    this.i = i;
  }
}

class DurationList extends Array<number> {
}

class SpeedList extends Array<number> {
}

class WindowRectRange {
  width: number;
  height: number;

  constructor(width: number, height: number) {
    this.width = width;
    this.height = height;
  }
}

class WindowRectRangeList extends Array<WindowRectRange> {
}

class WindowContentStub extends ModelWindowContentLike {
  resize(_width: number, _height: number, callback: (err: BusinessError) => void): void {
    callback(new QueryCallbackError());
  }

  setUIContent(_path: string, callback: (err: BusinessError) => void): void {
    callback(new QueryCallbackError());
  }

  showWindow(callback: (err: BusinessError) => void): void {
    callback(new QueryCallbackError());
  }
}

class WindowStageStub extends ModelWindowStageLike {
  createSubWindow(_name: string, callback: (err: BusinessError, data: ModelWindowContentLike) => void): void {
    callback(new QueryCallbackError(), new WindowContentStub());
  }
}

class RegisterCounter {
  count: number = 0;

  increment(): void {
    this.count++;
  }
}

class UnregisterCounter {
  count: number = 0;

  increment(): void {
    this.count++;
  }
}

class WindowPropertiesRecord extends ModelWindowPropertiesLike {
  windowRect: ModelWindowRectLike;

  constructor(width: number, height: number) {
    super();
    this.windowRect = new WindowRectRecord(width, height);
  }
}

class CreateSubWindowErrorLike extends WindowDestroyErrorLike {
  code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }
}

class MockDestroyWindow extends WindowLifecycleLike {
  private readonly code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }

  destroyWindow(callback: (err: BusinessError | WindowDestroyErrorLike) => void): void {
    callback(new CreateSubWindowErrorLike(this.code));
  }
}

class MockWindowStage {
  createSubWindow(_name: string, _cb: (err: CreateSubWindowErrorLike, data: ModelWindowContentLike) => void): void {
  }
}

class NullableTerminateContext {
  terminateSelf(): Promise<void> {
    return Promise.resolve();
  }
}

class NullableContextSubWindow extends SubWindow {
  private contextValue: NullableTerminateContext | null = null;

  setContextValue(context: NullableTerminateContext | null): void {
    this.contextValue = context;
  }

  getContextValue(): NullableTerminateContext | null {
    return this.contextValue;
  }
}

class MockAVPlayer extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  private readonly onSeekAction?: (time: number) => void;
  private readonly onSpeedAction?: (speed: number) => void;
  private readonly onResetAction?: () => void;

  constructor(currentTime: number = 0, duration: number = 0, onSeekAction?: (time: number) => void,
    onSpeedAction?: (speed: number) => void, onResetAction?: () => void) {
    super();
    this.currentTime = currentTime;
    this.duration = duration;
    this.onSeekAction = onSeekAction;
    this.onSpeedAction = onSpeedAction;
    this.onResetAction = onResetAction;
  }

  on(_event: string, _callback: ((state: media.AVPlayerState, reason: media.StateChangeReason) => void) |
  ((err: BusinessError) => void) | (() => void) | ((info: media.SubtitleInfo) => void) |
  ((mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => void) | ((infoType: media.BufferingInfoType,
    value: number) => void) |
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
    return Promise.resolve();
  }

  pause(): Promise<void> {
    return Promise.resolve();
  }

  reset(): Promise<void> {
    if (this.onResetAction !== undefined) {
      this.onResetAction();
    }
    return Promise.resolve();
  }

  release(): Promise<void> {
    return Promise.resolve();
  }

  setSpeed(speed: number): void {
    if (this.onSpeedAction !== undefined) {
      this.onSpeedAction(speed);
    }
  }

  seek(time: number, _mode?: media.SeekMode): void {
    if (this.onSeekAction !== undefined) {
      this.onSeekAction(time);
    }
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

class MediaKeyRequestResultHolder extends MediaKeyRequestResultLike {
  data: Uint8Array;

  constructor(data: Uint8Array) {
    super();
    this.data = data;
  }
}

class MockMediaKeySession extends MediaKeySessionLike {
  private readonly onRegister?: () => void;
  private readonly onUnregister?: () => void;
  private readonly onDestroyAction?: () => void;

  constructor(onRegister?: () => void, onUnregister?: () => void, onDestroyAction?: () => void) {
    super();
    this.onRegister = onRegister;
    this.onUnregister = onUnregister;
    this.onDestroyAction = onDestroyAction;
  }

  on(_name: string, _cb: (eventInfo: drm.EventInfo) => void): void {
    if (this.onRegister !== undefined) {
      this.onRegister();
    }
  }

  off(_name: string): void {
    if (this.onUnregister !== undefined) {
      this.onUnregister();
    }
  }

  destroy(): void {
    if (this.onDestroyAction !== undefined) {
      this.onDestroyAction();
    }
  }

  generateMediaKeyRequest(_mime: string, _pssh: Uint8Array, _type: number,
    _opt: drm.OptionsData[]): Promise<drm.MediaKeyRequest | MediaKeyRequestResultLike> {
    return Promise.resolve(new MediaKeyRequestResultHolder(new Uint8Array([1])));
  }

  processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return Promise.resolve(new Uint8Array([1]));
  }

  requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }
}

class MockMediaKeySystem extends MediaKeySystemLike {
  private readonly onDestroyAction?: () => void;

  constructor(onDestroyAction?: () => void) {
    super();
    this.onDestroyAction = onDestroyAction;
  }

  createMediaKeySession(_level: drm.ContentProtectionLevel): MediaKeySessionLike {
    return new MockMediaKeySession();
  }

  destroy(): void {
    if (this.onDestroyAction !== undefined) {
      this.onDestroyAction();
    }
  }
}

class EmptyDecryptionPlayer extends DecryptionAvPlayerLike {
  setDecryptionConfig(_session: drm.MediaKeySession | MediaKeySessionLike, _svp: boolean): void {
  }
}

class MockDrmSystemInfo extends DrmSystemInfoLike {
  uuid: string = '';
  pssh: Uint8Array = new Uint8Array();
}


export default function FullCoverageStress001Test() {
  const casePrefixPart1 = 'DemandPlayer_FullCoverageStress001_';
  const casePrefixPart2 = 'DemandPlayer_FullCoverageStress002_';
  const part1CaseNames: Array<string> = [];
  const part2CaseNames: Array<string> = [];
  const addPart1Case = (name: string): string => {
    part1CaseNames.push(name);
    return name;
  };
  const addPart2Case = (name: string): string => {
    part2CaseNames.push(name);
    return name;
  };

  describe('FullCoverageStress001TestSuite', () => {
    it(addPart1Case(casePrefixPart1 + 'Rdb_Insert_IPv4FullRange_001'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new StressRdbStore(0, (_t: string, _b: TrustEquipmentBucket, cb: InsertCallbackLike) => {
        count++;
        cb(null, 1);
      });
      for (let a = 1; a < 10; a++) {
        for (let b = 1; b < 10; b++) {
          rdb.insetRdb('192.168.' + a + '.' + b);
        }
      }
      expect(count).assertEqual(81);
    });

    it(addPart1Case(casePrefixPart1 + 'Rdb_Delete_IPv4FullRange_002'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new StressRdbStore(0, undefined, (_p: relationalStore.RdbPredicates, cb: DeleteCallbackLike) => {
        count++;
        cb(null, 1);
      });
      for (let a = 1; a < 10; a++) {
        for (let b = 1; b < 10; b++) {
          rdb.deleteRdb('10.' + a + '.' + b + '.1');
        }
      }
      expect(count).assertEqual(81);
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_ByteEncode_AllPrintableAscii_003'), 0, () => {
      const model = new DrmModel();
      let printable = '';
      for (let i = 32; i <= 126; i++) {
        printable += String.fromCharCode(i);
      }
      const encoded = model.stringToByte(printable);
      expect(encoded.length).assertEqual(95);
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_ByteDecode_AllPrintableAscii_004'), 0, () => {
      const model = new DrmModel();
      const data = new Uint8Array(95);
      for (let i = 0; i < 95; i++) {
        data[i] = i + 32;
      }
      const decoded = model.byteToString(data);
      expect(decoded.length).assertEqual(95);
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SeekVideo_SequentialForward_005'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new MockAVPlayer(0, 1000000, (t: number) => {
        times.push(t);
      });
      for (let i = 0; i < 50; i++) {
        player.seekVideo(0);
      }
      expect(times.length).assertEqual(50);
      expect(times[0]).assertEqual(10000);
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SeekVideo_SequentialBackward_006'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new MockAVPlayer(100000, 1000000, (t: number) => {
        times.push(t);
      });
      for (let i = 0; i < 50; i++) {
        player.seekVideo(1);
      }
      expect(times.length).assertEqual(50);
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SetSpeed_AlternatingSpeeds_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      const speeds: number[] = [];
      player.avPlayer = new MockAVPlayer(0, 0, undefined, (s: number) => {
        speeds.push(s);
      });
      const allSpeeds: number[] = [0.75, 1.0, 1.5, 2.0, 4.0];
      for (let i = 0; i < 50; i++) {
        player.setSpeed(new TrackItem('s' + i, allSpeeds[i % 5] + 'X', allSpeeds[i % 5]));
      }
      expect(speeds.length).assertEqual(50);
    });

    it(addPart1Case(casePrefixPart1 + 'SubWindow_Destroy_DifferentErrorCodes_008'), 0, () => {
      const subWindow = new SubWindow();
      const errorCodes = [0, 1, 2, 3, -1, 42, 99, 100, 255];
      for (let i = 0; i < errorCodes.length; i++) {
        const fakeWin: WindowLifecycleLike = new MockDestroyWindow(errorCodes[i]);
        let threw = false;
        try {
          subWindow.destroySubWindow(fakeWin);
        } catch (_e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Rdb_InsertDelete_InterleavedPairs_009'), 0, () => {
      const rdb = new Rdb();
      const ops: string[] = [];
      rdb.rdbStore = new StressRdbStore(0,
        (_t: string, _b: TrustEquipmentBucket, cb: InsertCallbackLike) => {
          ops.push('I');
          cb(null, 1);
        },
        (_p: relationalStore.RdbPredicates, cb: DeleteCallbackLike) => {
          ops.push('D');
          cb(null, 1);
        }
      );
      for (let i = 0; i < 30; i++) {
        rdb.insetRdb('172.16.' + i + '.1');
        rdb.deleteRdb('172.16.' + i + '.1');
      }
      expect(ops.length).assertEqual(60);
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_Stop_MultipleNullPlayer_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          player.stop();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_MultiInstance_IndependentRelease_011'), 0, () => {
      const models: DrmModel[] = [];
      for (let i = 0; i < 50; i++) {
        const m = new DrmModel();
        m.mediaKeySession = new MockMediaKeySession(undefined, undefined, () => {
        });
        m.mediaKeySystem = new MockMediaKeySystem(() => {
        });
        m.releaseDrm();
        models.push(m);
      }
      for (let i = 0; i < 50; i++) {
        expect(models[i].mediaKeySession === undefined).assertEqual(true);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Rdb_EqualTo_100Queries_012'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new StressRdbStore(0);
      for (let i = 0; i < 100; i++) {
        const result = await rdb.equalTo('0.0.0.' + i);
        expect(result).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_StringToByte_LongPayload_013'), 0, () => {
      const model = new DrmModel();
      for (let size = 100; size <= 5000; size += 100) {
        const str = 'X'.repeat(size);
        const encoded = model.stringToByte(str);
        expect(encoded.length).assertEqual(size);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_ByteToString_LongArray_014'), 0, () => {
      const model = new DrmModel();
      for (let size = 100; size <= 5000; size += 100) {
        const data = new Uint8Array(size);
        for (let i = 0; i < size; i++) {
          data[i] = i % 256;
        }
        const decoded = model.byteToString(data);
        expect(decoded.length).assertEqual(size);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'SubWindow_EndUIAbility_50Times_015'), 0, () => {
      const subWindow = new SubWindow();
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          subWindow.endUIAbility();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_ProcessAudioTracks_20Tracks_016'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: Array<ItemsType> = [];
      for (let i = 0; i < 20; i++) {
        tracks.push(new TrackItem(String(i), '未知', i));
      }
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(20);
      expect(result[0].name).assertEqual('音轨1');
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SeekVideo_DurationBoundaries_017'), 0, () => {
      const player = new VideoAVPlayerClass();
      const durationList = new DurationList(0, 1, 10, 50, 100, 500, 1000, 5000, 10000, 100000);
      for (let i = 0; i < durationList.length; i++) {
        let lastSeek = -1;
        player.avPlayer = new MockAVPlayer(durationList[i], durationList[i], (t: number) => {
          lastSeek = t;
        });
        player.seekVideo(0);
        expect(lastSeek >= 0).assertEqual(true);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Rdb_CreateRdb_WithoutStore_50Times_018'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          rdb.createRdb();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(true);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'SubWindow_ShowSubWindow_VariousRects_019'), 0, () => {
      const subWindow = new SubWindow();
      const rects = new WindowRectRangeList(
        new WindowRectRange(0, 0),
        new WindowRectRange(-1, -1),
        new WindowRectRange(1920, 1080),
        new WindowRectRange(3840, 2160),
        new WindowRectRange(99999, 99999)
      );
      for (let i = 0; i < rects.length; i++) {
        const ret =
          subWindow.showSubWindow(new WindowPropertiesRecord(rects[i].width, rects[i].height), new WindowStageStub());
        expect(ret === null || ret === undefined).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SetSpeed_AllSpeeds_FullRange_020'), 0, () => {
      const player = new VideoAVPlayerClass();
      const speedList = new SpeedList(0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0);
      for (let i = 0; i < speedList.length; i++) {
        let kernelSpeed = -1;
        player.avPlayer = new MockAVPlayer(0, 0, undefined, (s: number) => {
          kernelSpeed = s;
        });
        player.setSpeed(new TrackItem('s' + i, speedList[i] + 'X', speedList[i]));
        expect(kernelSpeed).assertEqual(speedList[i]);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'Rdb_Insert_WithoutStore_50Times_021'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          rdb.insetRdb('8.8.8.' + i);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart1Case(casePrefixPart1 + 'AvPlayer_SeekVideo_AlternatingFB_022'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new MockAVPlayer(50000, 100000, (t: number) => {
        times.push(t);
      });
      for (let i = 0; i < 30; i++) {
        player.seekVideo(i % 2);
      }
      expect(times.length).assertEqual(30);
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_RegisterCallback_50Calls_023'), 0, () => {
      const model = new DrmModel();
      const registerCounter = new RegisterCounter();
      model.mediaKeySession = new MockMediaKeySession(() => {
        registerCounter.increment();
      });
      for (let i = 0; i < 50; i++) {
        model.registerDrmCallback();
      }
      expect(registerCounter.count).assertEqual(150);
    });

    it(addPart1Case(casePrefixPart1 + 'Drm_UnregisterCallback_50Calls_024'), 0, () => {
      const model = new DrmModel();
      const unregisterCounter = new UnregisterCounter();
      model.mediaKeySession = new MockMediaKeySession(undefined, () => {
        unregisterCounter.increment();
      });
      for (let i = 0; i < 50; i++) {
        model.unregisterDrmCallback();
      }
      expect(unregisterCounter.count).assertEqual(150);
    });

    it(addPart1Case(casePrefixPart1 + 'CaseNamePattern_025'), 0, () => {
      expect(part1CaseNames.length).assertEqual(25);
      for (let i = 0; i < part1CaseNames.length; i++) {
        expect(/^DemandPlayer_FullCoverageStress001_[A-Za-z0-9_]+_[0-9]{3}$/.test(part1CaseNames[i])).assertEqual(true);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'EventBus_100Events_001'), 0, () => {
      for (let i = 0; i < 100; i++) {
        let count = 0;
        EventBus.listen<EventIndexPayload>('EB_Perf' + i, (_payload?: EventIndexPayload) => {
          count++;
        });
        EventBus.send('EB_Perf' + i, new EventIndexPayload(i));
        expect(count).assertEqual(1);
        EventBus.cancel('EB_Perf' + i);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'EventBus_100MultiListeners_002'), 0, () => {
      EventBus.listen<EventIndexPayload>('EB_MultiPerf', (_payload?: EventIndexPayload) => {
      });
      EventBus.listen<EventIndexPayload>('EB_MultiPerf', (_payload?: EventIndexPayload) => {
      });
      EventBus.listen<EventIndexPayload>('EB_MultiPerf', (_payload?: EventIndexPayload) => {
      });
      let count = 0;
      EventBus.listen<EventIndexPayload>('EB_MultiPerf', (_payload?: EventIndexPayload) => {
        count++;
      });
      for (let i = 0; i < 50; i++) {
        EventBus.send('EB_MultiPerf', new EventIndexPayload(i));
      }
      expect(count).assertEqual(50);
      EventBus.cancel('EB_MultiPerf');
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_ByteRoundtrip_50Payloads_003'), 0, () => {
      const model = new DrmModel();
      for (let size = 50; size <= 5000; size += 100) {
        const str: string = 'D'.repeat(size);
        const encoded = model.stringToByte(str);
        const decoded = model.byteToString(encoded);
        expect(decoded).assertEqual(str);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_HandleMediaKeySystemInfo_EmptyArray_004'), 0, async () => {
      const model = new DrmModel();
      const emptyInfo: DrmSystemInfoLike[] = [];
      const result = await model.handleMediaKeySystemInfo(new EmptyDecryptionPlayer(), emptyInfo, undefined);
      expect(result).assertEqual(false);
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_ExecLicenseProcess_EmptyArray_005'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = new MockMediaKeySession();
      const emptyInfo: DrmSystemInfoLike[] = [];
      const result = await model.execLicenseProcess(undefined, emptyInfo);
      expect(result).assertEqual(true);
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_NoSession_FalseResponses_006'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      const fakeInfo: Array<DrmSystemInfoLike> = [new MockDrmSystemInfo()];
      fakeInfo[0].uuid = 'uuid-1';
      fakeInfo[0].pssh = Uint8Array.from([4, 5, 6]);
      const result = await model.handleMediaKeySystemInfo(new EmptyDecryptionPlayer(), fakeInfo, undefined);
      expect(result).assertEqual(false);
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SeekBoundary_Seek0At0_007'), 0, () => {
      const player = new VideoAVPlayerClass();
      let seekT = -1;
      player.avPlayer = new MockAVPlayer(0, 100, (t: number) => {
        seekT = t;
      });
      player.seekVideo(0);
      expect(seekT).assertEqual(50);
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SeekBoundary_Seek1At0_008'), 0, () => {
      const player = new VideoAVPlayerClass();
      let seekT = -1;
      player.avPlayer = new MockAVPlayer(0, 100, (t: number) => {
        seekT = t;
      });
      player.seekVideo(1);
      expect(seekT).assertEqual(0);
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SeekBoundary_Seek0At99_009'), 0, () => {
      const player = new VideoAVPlayerClass();
      let seekT = -1;
      player.avPlayer = new MockAVPlayer(99, 100, (t: number) => {
        seekT = t;
      });
      player.seekVideo(0);
      expect(seekT).assertEqual(50);
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SeekBoundary_Seek1At99_010'), 0, () => {
      const player = new VideoAVPlayerClass();
      let seekT = -1;
      player.avPlayer = new MockAVPlayer(99, 100, (t: number) => {
        seekT = t;
      });
      player.seekVideo(1);
      expect(seekT).assertEqual(0);
    });

    it(addPart2Case(casePrefixPart2 + 'Rdb_Insert_50UniqueIPs_011'), 0, () => {
      const rdb = new Rdb();
      const ips: string[] = [];
      rdb.rdbStore = new StressRdbStore(0, (_t: string, bucket: TrustEquipmentBucket, cb: InsertCallbackLike) => {
        ips.push(bucket.IP);
        cb(null, 1);
      });
      for (let i = 0; i < 50; i++) {
        rdb.insetRdb('192.168.1.' + i);
      }
      expect(ips.length).assertEqual(50);
    });

    it(addPart2Case(casePrefixPart2 + 'Rdb_Delete_50UniqueIPs_012'), 0, () => {
      const rdb = new Rdb();
      const ips: string[] = [];
      rdb.rdbStore =
        new StressRdbStore(0, undefined, (_pred: relationalStore.RdbPredicates, cb: DeleteCallbackLike) => {
          ips.push('deleted');
          cb(null, 1);
        });
      for (let i = 0; i < 50; i++) {
        rdb.deleteRdb('192.168.1.' + i);
      }
      expect(ips.length).assertEqual(50);
    });

    it(addPart2Case(casePrefixPart2 + 'SubWindow_DestroySubWindow_50Nulls_013'), 0, () => {
      const subWindow = new SubWindow();
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          subWindow.destroySubWindow(null);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_ProcessAudioTracks_50Tracks_014'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: Array<ItemsType> = [];
      for (let i = 0; i < 50; i++) {
        tracks.push(new TrackItem(String(i), '未知', i));
      }
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(50);
      expect(result[0].name).assertEqual('音轨1');
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_ProcessAudioTracks_50Known_015'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: Array<ItemsType> = [];
      for (let i = 0; i < 50; i++) {
        tracks.push(new TrackItem(String(i), '音轨' + (i + 1), i));
      }
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(50);
      for (let i = 0; i < 50; i++) {
        expect(result[i].name).assertEqual('音轨' + (i + 1));
      }
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_ProcessAudioTracks_50Mixed_016'), 0, () => {
      const player = new VideoAVPlayerClass();
      const tracks: Array<ItemsType> = [];
      for (let i = 0; i < 50; i++) {
        tracks.push(new TrackItem(String(i), i % 2 === 0 ? '未知' : ('音轨' + i), i));
      }
      const result = player.processAudioTracks(tracks);
      expect(result.length).assertEqual(50);
    });

    it(addPart2Case(casePrefixPart2 + 'SubWindow_EndUIAbility_50NullContext_017'), 0, () => {
      const subWindow = new NullableContextSubWindow();
      subWindow.setContextValue(null);
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          subWindow.endUIAbility();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_GetHttpLicense_EmptyUrl_018'), 0, async () => {
      const model = new DrmModel();
      const result = await model.getHttpLicense('', 'extra');
      expect(result).assertEqual('');
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_GetHttpLicense_UndefinedUrl_019'), 0, async () => {
      const model = new DrmModel();
      const result = await model.getHttpLicense(undefined, 'extra');
      expect(result).assertEqual('');
    });

    it(addPart2Case(casePrefixPart2 + 'Drm_ReleaseDrm_TwicePerInstance_020'), 0, () => {
      for (let i = 0; i < 20; i++) {
        const model = new DrmModel();
        model.mediaKeySession = new MockMediaKeySession(undefined, undefined, () => {
        });
        model.mediaKeySystem = new MockMediaKeySystem(() => {
        });
        model.releaseDrm();
        model.releaseDrm();
        expect(model.mediaKeySession === undefined).assertEqual(true);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'Rdb_EqualTo_50Queries_021'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new StressRdbStore(0);
      for (let i = 0; i < 50; i++) {
        const result = await rdb.equalTo('1.1.1.' + i);
        expect(result).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SetSpeed_NullPlayer_50Times_022'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          player.setSpeed(new TrackItem('s' + i, '1X', 1));
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_SeekVideo_NullPlayer_50Times_023'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          player.seekVideo(0);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'AvPlayer_Stop_NullPlayer_50Times_024'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          player.stop();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addPart2Case(casePrefixPart2 + 'CaseNamePattern_025'), 0, () => {
      expect(part2CaseNames.length).assertEqual(25);
      for (let i = 0; i < part2CaseNames.length; i++) {
        expect(/^DemandPlayer_FullCoverageStress002_[A-Za-z0-9_]+_[0-9]{3}$/.test(part2CaseNames[i])).assertEqual(true);
      }
    });
  });
}


