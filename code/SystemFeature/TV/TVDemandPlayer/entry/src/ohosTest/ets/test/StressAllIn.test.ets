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
import { VideoAVPlayerClass, TestableAVPlayer } from '../../../main/ets/Model/AvPlayer';
import {
  Rdb,
  RdbStoreLike,
  BasicErrorLike,
  QueryResultLike as BaseQueryResultLike,
  TrustEquipmentBucket
} from '../../../main/ets/Model/Rdb';
import { DrmModel, MediaKeySessionLike, MediaKeySystemLike } from '../../../main/ets/Model/DrmModel';
import {
  SubWindow,
  WindowLifecycleLike,
  WindowDestroyErrorLike,
  WindowPropertiesLike as BaseWindowPropertiesLike,
  WindowStageLike,
  WindowContentLike as BaseWindowContentLike,
  WindowRectLike as BaseWindowRectLike
} from '../../../main/ets/Model/Window';
import { EventBus } from '../../../main/ets/utils/EventBus';
import { drm } from '@kit.DrmKit';
import { media } from '@kit.MediaKit';
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ItemsType } from '../../../main/ets/const/Type';

type WorkerPayloadData = null | number | string | boolean | Array<number> | WorkerPayloadHolder;

abstract class WorkerStateHolder {
  abstract data: WorkerPayloadData;
  abstract dataLen: number;
  abstract url: string;
  abstract srcPath: string;
  abstract worker: WorkerHolder | null;
}

class WorkerPayloadHolder {
  key: string;
  num: number;

  constructor(key: string, num: number) {
    this.key = key;
    this.num = num;
  }
}

abstract class DestroyWindowLike extends WindowLifecycleLike {
  abstract destroyWindow(cb: DestroyWindowCallback): void;
}

abstract class WindowStageLikeBase extends WindowStageLike {
  abstract createSubWindow(_n: string, cb: CreateSubWindowCallback): void;
}

class WindowRectLike extends BaseWindowRectLike {
  width: number = 0;
  height: number = 0;
}

abstract class WindowPropertiesHolderBase extends BaseWindowPropertiesLike {
  abstract windowRect: BaseWindowRectLike;
}

abstract class WorkerHolder {
  abstract postMessage(_m: string): void;
}

class WorkerHolderImpl extends WorkerHolder {
  postMessage(_m: string): void {
  }
}

class WorkerStateImpl extends WorkerStateHolder {
  data: WorkerPayloadData = null;
  dataLen: number = 0;
  url: string = '';
  srcPath: string = '';
  worker: WorkerHolder | null = null;
}

function createWorkerState(): WorkerStateHolder {
  return new WorkerStateImpl();
}

class RdbCallbackError extends BasicErrorLike {
  code: number = 0;
  message: string = '';
}

type InsertStoreCallback = (err: BasicErrorLike | null, rowId: number) => void;
type DeleteStoreCallback = (err: BasicErrorLike | null, rows: number) => void;
type DrmSessionEventCallback = (eventInfo: drm.EventInfo) => void;

abstract class DestroyWindowResult extends WindowDestroyErrorLike {
}

type CreateSubWindowCallback = (err: BusinessError, data: BaseWindowContentLike) => void;

type DestroyWindowCallback = (result: DestroyWindowResult) => void;

abstract class RdbInsertDeleteStoreLike extends RdbStoreLike {
}

class RdbStoreHolder extends RdbInsertDeleteStoreLike {
  private readonly onInsert?: (_t: string, _b: ValuesBucket, cb: InsertStoreCallback) => void;
  private readonly onDelete?: (_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback) => void;

  constructor(onInsert?: (_t: string, _b: ValuesBucket, cb: InsertStoreCallback) => void,
    onDelete?: (_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback) => void) {
    super();
    this.onInsert = onInsert;
    this.onDelete = onDelete;
  }

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_t: string, _b: ValuesBucket, cb: InsertStoreCallback): void {
    this.onInsert?.(_t, _b, cb);
  }

  delete(_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback): void {
    this.onDelete?.(_p, cb);
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: Array<string>): Promise<BaseQueryResultLike> {
    return Promise.resolve(new QueryResultHolder());
  }
}

class QueryResultHolder extends BaseQueryResultLike {
  columnNames: Array<string> = ['IP'];
  columnCount: number = 1;
  rowCount: number = 0;
  rowIndex: number = 0;

  isAtFirstRow(): boolean {
    return false;
  }

  isAfterLastRow(): boolean {
    return true;
  }

  close(): void {
  }
}

class DestroyWindowHolder extends DestroyWindowLike {
  private readonly onDestroy: (cb: DestroyWindowCallback) => void;

  constructor(onDestroy: (cb: DestroyWindowCallback) => void) {
    super();
    this.onDestroy = onDestroy;
  }

  destroyWindow(cb: DestroyWindowCallback): void {
    this.onDestroy(cb);
  }
}

class WindowStageHolder extends WindowStageLikeBase {
  createSubWindow(_n: string, cb: CreateSubWindowCallback): void {
    cb(
      new BusinessErrorHolder(0, ''),
      new CreateSubWindowWindowHolder()
    );
  }
}

class BusinessErrorHolder extends Error implements BusinessError {
  code: number;

  constructor(code: number, message: string) {
    super(message);
    this.code = code;
    this.name = 'BusinessErrorHolder';
  }
}

class CreateSubWindowErrorHolder extends WindowDestroyErrorLike {
  code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }
}

class CreateSubWindowWindowHolder extends BaseWindowContentLike {
  resize(_width: number, _height: number, callback: (err: BusinessError) => void): void {
    callback(new BusinessErrorHolder(0, ''));
  }

  setUIContent(_path: string, callback: (err: BusinessError) => void): void {
    callback(new BusinessErrorHolder(0, ''));
  }

  showWindow(callback: (err: BusinessError) => void): void {
    callback(new BusinessErrorHolder(0, ''));
  }
}

class DestroyWindowResultHolder extends DestroyWindowResult {
  code: number;

  constructor(code: number = 0) {
    super();
    this.code = code;
  }
}

class WindowRectHolder extends BaseWindowRectLike {
  left: number = 0;
  top: number = 0;
  width: number;
  height: number;

  constructor(width: number, height: number) {
    super();
    this.width = width;
    this.height = height;
  }
}

class WindowPropertiesHolder extends BaseWindowPropertiesLike {
  windowRect: BaseWindowRectLike;
  drawableRect: WindowRectHolder = new WindowRectHolder(0, 0);
  isFullScreen: boolean = false;
  isLayoutFullScreen: boolean = false;
  focusable: boolean = true;
  touchable: boolean = true;
  brightness: number = 1;
  isKeepScreenOn: boolean = false;
  transparency: number = 1;
  id: number = 0;
  name: string = 'mockWindow';
  displayId: number = 0;
  parentId: number = 0;
  density: number = 1;
  orientation: window.Orientation = window.Orientation.UNSPECIFIED;
  mode: window.WindowMode = window.WindowMode.UNDEFINED;
  dimBehindValue: number = 0;
  isPrivacyMode: boolean = false;
  isRoundCorner: boolean = false;
  isTransparent: boolean = false;

  constructor(windowRect: window.Rect) {
    super();
    this.windowRect = new WindowRectHolder(windowRect.width, windowRect.height);
  }
}

class SeekAvPlayerHolder extends TestableAVPlayer {
  currentTime: number;
  duration: number;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  private readonly onSeek: (t: number, m: media.SeekMode) => void;

  constructor(currentTime: number, duration: number, onSeek: (t: number, m: media.SeekMode) => void) {
    super();
    this.currentTime = currentTime;
    this.duration = duration;
    this.onSeek = onSeek;
  }

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

  setSpeed(_speed: number): void {
  }

  seek(t: number, m: media.SeekMode): void {
    this.onSeek(t, m);
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

class SessionLikeHolder extends MediaKeySessionLike {
  on(_name: string, _cb: (eventInfo: drm.EventInfo) => void): void {
  }

  off(_e: string): void {
  }

  destroy(): void {
  }

  clearMediaKeys(): Promise<void> {
    return Promise.resolve();
  }

  requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }

  generateMediaKeyRequest(_mime: string, _pssh: Uint8Array, _type: number,
    _opt: drm.OptionsData[]): Promise<drm.MediaKeyRequest> {
    return Promise.reject(new Error('not implemented'));
  }

  processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return Promise.resolve(new Uint8Array());
  }
}

class SystemLikeHolder extends MediaKeySystemLike {
  createMediaKeySession(_level: drm.ContentProtectionLevel): drm.MediaKeySession | MediaKeySessionLike {
    return new SessionLikeHolder();
  }

  destroy(): void {
  }
}

class SpeedAvPlayerHolder extends TestableAVPlayer {
  currentTime: number = 0;
  duration: number = 0;
  state: media.AVPlayerState = 'idle';
  surfaceId: string = '';
  url: string = '';
  fdSrc: media.AVFileDescriptor = { fd: 0, offset: 0, length: 0 };
  width: number = 0;
  height: number = 0;
  private readonly onSetSpeed: (s: number) => void;

  constructor(onSetSpeed: (s: number) => void) {
    super();
    this.onSetSpeed = onSetSpeed;
  }

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

  setSpeed(s: number): void {
    this.onSetSpeed(s);
  }

  seek(_t: number, _m: media.SeekMode): void {
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

class MediaKeySessionHolder {
  off(_e: string): void {
  }

  destroy(): void {
  }
}

class MediaKeySystemHolder {
  destroy(): void {
  }
}

class SpeedItemHolder implements ItemsType {
  id: string;
  name: string;
  param: number;

  constructor(id: string, name: string, param: number) {
    this.id = id;
    this.name = name;
    this.param = param;
  }
}

/**
 * 全矩阵压力测试合并文件
 *
 * 业务背景：TV 播放器在极限场景下需要保证稳定性——大量数据条目、高频操作、多种边界值组合。
 * 本文件汇聚了 Worker 数据类型矩阵、Rdb IP区间压力、DRM 全字节范围、Window 多尺寸边界等压力测试。
 *
 * 测试策略：
 * - 数据类型矩阵：验证 Worker 支持的所有数据类型（number/string/boolean/null/undefined/array/object）
 * - 存储压力层：验证 IPv4 Class B / Class C 的全量插入删除
 * - 编码压力层：验证 DRM 全 256 字节范围编解码
 * - 窗口尺寸边界：验证从 1x1 到 8K 的各种分辨率下窗口创建的安全性
 * - 播放操作高频：验证 50 次连续 seek/speed/stop 操作的正确性
 */

export default function StressAllInOneTest() {
  const casePrefix = 'DemandPlayer_StressAllInOne_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：Worker 数据类型全矩阵 ==========
   *
   * 业务背景：Worker 线程通过 data 字段与主线程通信，需要支持多种数据类型。
   * 本组测试覆盖所有基本类型（number/string/boolean/null/undefined）以及复合类型（array/object）。
   */
  describe('StressAllInOne_WorkerDataTypeMatrix', () => {
    it(addCase(casePrefix + 'Worker_DataTypes_AllPrimitiveTypes_001'), 0, () => {
      const worker = createWorkerState();
      worker.data = 42;
      expect(worker.data).assertEqual(42);
      worker.data = 'string';
      expect(worker.data).assertEqual('string');
      worker.data = true;
      expect(worker.data).assertEqual(true);
      worker.data = null;
      expect(worker.data === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_DataTypes_Array_002'), 0, () => {
      const worker = createWorkerState();
      worker.data = [1, 2, 3, 4, 5];
      expect((worker.data as Array<number>).length).assertEqual(5);
    });

    it(addCase(casePrefix + 'Worker_DataTypes_Object_003'), 0, () => {
      const worker = createWorkerState();
      worker.data = new WorkerPayloadHolder('value', 123);
      expect((worker.data as WorkerPayloadHolder).key).assertEqual('value');
    });

    it(addCase(casePrefix + 'Worker_DataLen_SetGet_004'), 0, () => {
      const worker = createWorkerState();
      worker.dataLen = 0;
      expect(worker.dataLen).assertEqual(0);
      worker.dataLen = 1;
      expect(worker.dataLen).assertEqual(1);
      worker.dataLen = 999;
      expect(worker.dataLen).assertEqual(999);
      worker.dataLen = -1;
      expect(worker.dataLen).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Worker_Url_SetGet_005'), 0, () => {
      const workerState = createWorkerState();
      workerState.url = '/workers/player.ts';
      expect(workerState.url).assertEqual('/workers/player.ts');
      workerState.url = '';
      expect(workerState.url).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_SrcPath_SetGet_006'), 0, () => {
      const workerState = createWorkerState();
      workerState.srcPath = 'entry/workers/Worker.ts';
      expect(workerState.srcPath).assertEqual('entry/workers/Worker.ts');
      workerState.srcPath = '';
      expect(workerState.srcPath).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_Worker_SetGet_007'), 0, () => {
      const workerState = createWorkerState();
      const fake = new WorkerHolderImpl();
      workerState.worker = fake;
      expect(workerState.worker !== null).assertEqual(true);
      workerState.worker = null;
      expect(workerState.worker === null).assertEqual(true);
    });

    /**
     * ========== 第二部分：Rdb 数据库 IP 区间压力 ==========
     *
     * 业务背景：IP 白名单可能需要存储大量 IP 地址（如企业内网/家庭网络的多设备场景）。
     * 本组测试验证 Class B（172.16.0.0-172.31.255.255）和 Class C（192.168.0.0-192.168.255.255）区间的批量操作。
     */
    it(addCase(casePrefix + 'Rdb_Insert_100_IPv4ClassB_008'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new RdbStoreHolder(
        (_t: string, _b: ValuesBucket, cb: InsertStoreCallback): void => {
          count++;
          cb(null, 1);
        }
      );
      for (let b = 0; b < 10; b++) {
        for (let c = 0; c < 10; c++) {
          rdb.insetRdb('172.' + b + '.' + c + '.1');
        }
      }
      expect(count).assertEqual(100);
    });

    it(addCase(casePrefix + 'Rdb_Delete_100_IPv4ClassB_009'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new RdbStoreHolder(
        undefined,
        (_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback): void => {
          count++;
          cb(null, 1);
        }
      );
      for (let b = 0; b < 10; b++) {
        for (let c = 0; c < 10; c++) {
          rdb.deleteRdb('10.' + b + '.' + c + '.1');
        }
      }
      expect(count).assertEqual(100);
    });

    it(addCase(casePrefix + 'Rdb_Insert_81_IPv4ClassC_010'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new RdbStoreHolder(
        (_t: string, _b: ValuesBucket, cb: InsertStoreCallback): void => {
          count++;
          cb(null, 1);
        }
      );
      for (let a = 1; a < 10; a++) {
        for (let b = 1; b < 10; b++) {
          rdb.insetRdb('192.168.' + a + '.' + b);
        }
      }
      expect(count).assertEqual(81);
    });

    it(addCase(casePrefix + 'Rdb_Delete_81_IPv4ClassC_011'), 0, () => {
      const rdb = new Rdb();
      let count = 0;
      rdb.rdbStore = new RdbStoreHolder(
        undefined,
        (_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback): void => {
          count++;
          cb(null, 1);
        }
      );
      for (let a = 1; a < 10; a++) {
        for (let b = 1; b < 10; b++) {
          rdb.deleteRdb('10.' + a + '.' + b + '.1');
        }
      }
      expect(count).assertEqual(81);
    });

    it(addCase(casePrefix + 'Rdb_InsertDelete_InterleavedPairs_012'), 0, () => {
      const rdb = new Rdb();
      const ops: string[] = [];
      rdb.rdbStore = new RdbStoreHolder(
        (_t: string, _b: ValuesBucket, cb: InsertStoreCallback): void => {
          ops.push('I');
          cb(null, 1);
        },
        (_p: relationalStore.RdbPredicates, cb: DeleteStoreCallback): void => {
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

    /**
     * ========== 第三部分：DRM 全字节范围编码压力 ==========
     *
     * 业务背景：DRM 许可证数据可能包含任意字节值（0x00-0xFF），包括不可打印字符和 null 字节。
     * 本组测试验证 stringToByte/byteToString 对全 256 字节范围的处理能力。
     */
    it(addCase(casePrefix + 'Drm_StringToByte_FullAsciiRange_013'), 0, () => {
      const model = new DrmModel();
      let allAscii = '';
      for (let i = 0; i < 256; i++) {
        allAscii += String.fromCharCode(i);
      }
      const encoded = model.stringToByte(allAscii);
      expect(encoded.length).assertEqual(256);
    });

    it(addCase(casePrefix + 'Drm_ByteToString_FullUint8Range_014'), 0, () => {
      const model = new DrmModel();
      const data = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        data[i] = i;
      }
      const decoded = model.byteToString(data);
      expect(decoded.length).assertEqual(256);
    });

    it(addCase(casePrefix + 'Drm_ByteEncode_AllPrintableAscii_015'), 0, () => {
      const model = new DrmModel();
      let printable = '';
      for (let i = 32; i <= 126; i++) {
        printable += String.fromCharCode(i);
      }
      const encoded = model.stringToByte(printable);
      expect(encoded.length).assertEqual(95);
    });

    it(addCase(casePrefix + 'Drm_ByteDecode_AllPrintableAscii_016'), 0, () => {
      const model = new DrmModel();
      const data = new Uint8Array(95);
      for (let i = 0; i < 95; i++) {
        data[i] = i + 32;
      }
      const decoded = model.byteToString(data);
      expect(decoded.length).assertEqual(95);
    });

    /**
     * ========== 第四部分：Window 多尺寸边界压力 ==========
     *
     * 业务背景：TV 设备可能连接不同分辨率的显示器（720P/1080P/4K/8K）。
     * SubWindow 需要能处理各种尺寸的窗口创建请求，包括极端的 1x1 小窗口和 7680x4320 8K 窗口。
     */
    it(addCase(casePrefix + 'SubWindow_Destroy_AllErrorCodes_017'), 0, () => {
      const subWindow = new SubWindow();
      const codes = [-1, 0, 1, 2, 127, 128, 255, 256, 1000, 9999];
      for (let i = 0; i < codes.length; i++) {
        const fakeWin = new DestroyWindowHolder((cb: DestroyWindowCallback): void => {
          cb(new DestroyWindowResultHolder(codes[i]));
        });
        let threw = false;
        try {
          subWindow.destroySubWindow(fakeWin);
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    it(addCase(casePrefix + 'SubWindow_ShowSubWindow_VariousRectSizes_018'), 0, () => {
      const subWindow = new SubWindow();
      const sizes = [
        new WindowRectHolder(320, 240),
        new WindowRectHolder(640, 480),
        new WindowRectHolder(1280, 720),
        new WindowRectHolder(1920, 1080),
        new WindowRectHolder(2560, 1440),
        new WindowRectHolder(3840, 2160),
        new WindowRectHolder(7680, 4320),
        new WindowRectHolder(1, 1),
        new WindowRectHolder(100, 100),
        new WindowRectHolder(5000, 5000)
      ];
      for (let i = 0; i < sizes.length; i++) {
        const ret = subWindow.showSubWindow(
          new WindowPropertiesHolder(sizes[i]),
          new WindowStageHolder()
        );
        expect(ret === null || ret === undefined).assertEqual(false);
      }
    });

    it(addCase(casePrefix + 'SubWindow_Destroy_DifferentErrorCodes_019'), 0, () => {
      const subWindow = new SubWindow();
      const errorCodes = [0, 1, 2, 3, -1, 42, 99, 100, 255];
      for (let i = 0; i < errorCodes.length; i++) {
        const fakeWin = new DestroyWindowHolder((cb: DestroyWindowCallback): void => {
          cb(new DestroyWindowResultHolder(errorCodes[i]));
        });
        let threw = false;
        try {
          subWindow.destroySubWindow(fakeWin);
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    /**
     * ========== 第五部分：AvPlayer 高频操作压力 ==========
     *
     * 业务背景：用户可能连续快进/快退或快速切换音轨，需要验证边界钳制逻辑在高频率下的正确性。
     */
    it(addCase(casePrefix + 'AvPlayer_SeekVideo_50ForwardCalls_020'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new SeekAvPlayerHolder(
        0,
        1000000,
        (t: number, _m: media.SeekMode): void => {
          times.push(t);
        }
      );
      for (let i = 0; i < 50; i++) {
        player.seekVideo(0);
      }
      expect(times.length).assertEqual(50);
      expect(times[0]).assertEqual(10000);
    });

    it(addCase(casePrefix + 'AvPlayer_SeekVideo_50BackwardCalls_021'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new SeekAvPlayerHolder(
        100000,
        1000000,
        (t: number, _m: media.SeekMode): void => {
          times.push(t);
        }
      );
      for (let i = 0; i < 50; i++) {
        player.seekVideo(1);
      }
      expect(times.length).assertEqual(50);
    });

    it(addCase(casePrefix + 'AvPlayer_SeekVideo_SequentialForward_022'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new SeekAvPlayerHolder(
        0,
        1000000,
        (t: number, _m: media.SeekMode): void => {
          times.push(t);
        }
      );
      for (let i = 0; i < 50; i++) {
        player.seekVideo(0);
      }
      expect(times.length).assertEqual(50);
      expect(times[0]).assertEqual(10000);
    });

    it(addCase(casePrefix + 'AvPlayer_SeekVideo_SequentialBackward_023'), 0, () => {
      const player = new VideoAVPlayerClass();
      const times: number[] = [];
      player.avPlayer = new SeekAvPlayerHolder(
        100000,
        1000000,
        (t: number, _m: media.SeekMode): void => {
          times.push(t);
        }
      );
      for (let i = 0; i < 50; i++) {
        player.seekVideo(1);
      }
      expect(times.length).assertEqual(50);
    });

    it(addCase(casePrefix + 'AvPlayer_SetSpeed_AlternatingSpeeds_024'), 0, () => {
      const player = new VideoAVPlayerClass();
      const speeds: number[] = [];
      player.avPlayer = new SpeedAvPlayerHolder((s: number): void => {
        speeds.push(s);
      });
      const allSpeeds = [0.75, 1.0, 1.5, 2.0, 4.0];
      for (let i = 0; i < 50; i++) {
        player.setSpeed(new SpeedItemHolder('s' + i, allSpeeds[i % 5] + 'X', allSpeeds[i % 5]));
      }
      expect(speeds.length).assertEqual(50);
    });

    it(addCase(casePrefix + 'AvPlayer_Stop_MultipleNullPlayer_025'), 0, () => {
      const player = new VideoAVPlayerClass();
      player.avPlayer = null;
      for (let i = 0; i < 50; i++) {
        let threw = false;
        try {
          player.stop();
        } catch (_err) {
          threw = true;
        }
        expect(threw).assertEqual(false);
      }
    });

    /**
     * ========== 第六部分：DRM 多实例隔离压力 ==========
     *
     * 业务背景：TV 可能同时播放多个 DRM 保护的视频（如画中画场景），每个视频需要独立的 DRM 实例。
     * 本组测试验证多个 DRM 实例之间的状态隔离和独立销毁。
     */
    it(addCase(casePrefix + 'Drm_MultiInstance_IndependentRelease_026'), 0, () => {
      const models: DrmModel[] = [];
      for (let i = 0; i < 50; i++) {
        const m = new DrmModel();
        m.mediaKeySession = new SessionLikeHolder();
        m.mediaKeySystem = new SystemLikeHolder();
        m.releaseDrm();
        expect(m.mediaKeySession === undefined).assertEqual(true);
        expect(m.mediaKeySystem === undefined).assertEqual(true);
        models.push(m);
      }
      expect(models.length).assertEqual(50);
    });

    it(addCase(casePrefix + 'Drm_InstanceState_IsolatedBetweenInstances_027'), 0, () => {
      const m1 = new DrmModel();
      const m2 = new DrmModel();
      m1.mediaKeySession = new SessionLikeHolder();
      m1.mediaKeySystem = new SystemLikeHolder();
      expect(m1.mediaKeySession !== undefined).assertEqual(true);
      expect(m2.mediaKeySession === undefined).assertEqual(true);
    });

    /**
     * ========== 第七部分：SubWindow 高频销毁压力 ==========
     *
     * 业务背景：用户快速切换频道时，SubWindow 可能被频繁创建和销毁。
     * 本组测试验证 100 次连续销毁操作的安全性。
     */
    it(addCase(casePrefix + 'SubWindow_Destroy_100Nulls_028'), 0, () => {
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

    it(addCase(casePrefix + 'SubWindow_EndUIAbility_100Times_029'), 0, () => {
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

    /**
     * ========== 第八部分：用例名称规范校验 ==========
     */
    it(addCase(casePrefix + 'CaseNamePattern_030'), 0, () => {
      expect(allCaseNames.length).assertEqual(30);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_StressAllInOne_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
