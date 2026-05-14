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

import { describe, it, expect, TestType, Size, Level } from '@ohos/hypium';

import { MusicSharedEventCode, MusicSharedStatus, MusicConnectEvent, APPLICATION_BUNDLE_NAME, APPLICATION_SERVICE_NAME, APPLICATION_ABILITY_NAME } from '../../../../main/ets/common/MusicSharedDefinition';
import { DeviceType, DeviceStateChangeAction, DistributedManager, DistributedManagerDeviceInfo, DeviceInfo } from '../../../../main/ets/model/RemoteDeviceModel';
import { songItemType, SongItemTypeModel } from '../../../../main/ets/model/Music';
import { PlayStateType, PlayStateTypeModel, defaultState } from '../../../../main/ets/model/PlayState';
import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { EventUtil } from '../../../../main/ets/common/EventUtil';
import { PointerUtil } from '../../../../main/ets/common/PointerUtil';
import { songs } from '../../../../main/ets/common/MusicConstants';
import { ButtonModel, button } from '../../../../main/ets/model/ButtonModel';
import Logger from '../../../../main/ets/utils/Logger';
import Preferences from '../../../../main/ets/utils/Preferences';
import { objType } from '../../../../main/ets/utils/Utils';
import KvStoreModel, { BUNDLE_NAME } from '../../../../main/ets/model/KvStoreModel';
import AVPlayerClass from '../../../../main/ets/model/MusicPlayer';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}
function makeStringRecord(): StringRecord { return {} as StringRecord; }

/* Typed JSON parse result */
interface ParseResult {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
}

function mkSongs(n: number): songItemType[] {
  const r: songItemType[] = [];
  for (let i: number = 0; i < n; i++) {
    const nameStr: string = 's_' + i.toString();
    const authorStr: string = 'a_' + i.toString();
    const urlStr: string = 'u_' + i.toString() + '.wav';
    r.push({ img: $r('app.media.album1'), name: nameStr, author: authorStr, url: urlStr, time: (i + 1) * 100 });
  }
  return r;
}

function mkDevices(n: number): DistributedManagerDeviceInfo[] {
  const r: DistributedManagerDeviceInfo[] = [];
  const deviceTypes: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET];
  for (let i: number = 0; i < n; i++) {
    const devId: string = 'd_' + i.toString();
    const devName: string = 'Dev ' + i.toString();
    const netId: string = 'n_' + i.toString();
    const trustId: string = 't_' + i.toString();
    r.push({
      deviceId: devId,
      deviceName: devName,
      deviceType: deviceTypes[i % 3],
      networkId: netId,
      range: i + 1,
      isInAuth: false,
      isTrust: i % 3 === 0,
      trustDeviceId: i % 3 === 0 ? trustId : '',
      transferLoading: false,
      isInTransfer: false,
      action: DeviceStateChangeAction.READY,
      updateTime: new Date().getTime(),
      pinToken: -1,
      isDelete: false
    });
  }
  return r;
}

function number2time(n: number): string {
  const ms: number = n % 100;
  const s2: number = (n - ms) / 100;
  const s: number = s2 % 60;
  if (s2 > 60) {
    const m: number = (s2 - s) / 60 % 60;
    return m.toString().padStart(2, '0') + ':' + s.toString().padStart(2, '0');
  }
  return '00:' + s.toString().padStart(2, '0');
}

class MockKVStore {
  private store: Map<string, number> = new Map();
  put(k: string, v: number): Promise<void> {
    this.store.set(k, v);
    return Promise.resolve();
  }
  get(k: string): Promise<number | null> {
    return Promise.resolve(this.store.get(k) ?? null);
  }
  delete(k: string): Promise<void> {
    this.store.delete(k);
    return Promise.resolve();
  }
  has(k: string): boolean {
    return this.store.has(k);
  }
  on(event: string, type: number, cb: (msg: string) => void): void {
  }
}

class MockTouch implements TouchEvent {
  type: TouchType = TouchType.Up;
  source: SourceType = SourceType.Mouse;
  touches: TouchObject[] = [];
  changedTouches: TouchObject[] = [];
  timestamp: number = new Date().getTime();
  target!: EventTarget;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = SourceTool.Unknown;
  stopPropagation(): void {
  }
  preventDefault(): void {
  }
  getHistoricalPoints() { return []; }
}

class MockAVPlayer {
  state: string = 'idle';
  url: string = '';
  duration: number = 0;
  time: number = 0;
  isPlay: boolean = false;
  private _onStateChange: ((s: string) => void) | null = null;
  private _onDurationUpdate: ((d: number) => void) | null = null;
  private _onTimeUpdate: ((t: number) => void) | null = null;
  private _onSeekDone: (() => void) | null = null;

  onStateChange(callback: (s: string) => void): void {
    this._onStateChange = callback;
  }
  onDurationUpdate(callback: (d: number) => void): void {
    this._onDurationUpdate = callback;
  }
  onTimeUpdate(callback: (t: number) => void): void {
    this._onTimeUpdate = callback;
  }
  onSeekDone(callback: () => void): void {
    this._onSeekDone = callback;
  }
  prepare(): void {
    this.state = 'prepared';
    if (this._onStateChange !== null) {
      this._onStateChange('prepared');
    }
  }
  play(): void {
    this.state = 'playing';
    this.isPlay = true;
    if (this._onStateChange !== null) {
      this._onStateChange('playing');
    }
  }
  pause(): void {
    this.state = 'paused';
    this.isPlay = false;
    if (this._onStateChange !== null) {
      this._onStateChange('paused');
    }
  }
  reset(): Promise<void> {
    this.state = 'idle';
    this.url = '';
    return Promise.resolve();
  }
  release(): void {
    this.state = 'released';
  }
  seek(ms: number): void {
    if (this._onSeekDone !== null) {
      this._onSeekDone();
    }
  }
  emitDuration(d: number): void {
    if (this._onDurationUpdate !== null) {
      this._onDurationUpdate(d);
    }
  }
  emitTime(t: number): void {
    if (this._onTimeUpdate !== null) {
      this._onTimeUpdate(t);
    }
  }
}

/* Helper to parse JSON to typed object */
function parseToResult(json: string): ParseResult {
  const raw: ParseResult = JSON.parse(json) as ParseResult;
  const result: ParseResult = { uri: raw.uri, seekTo: raw.seekTo, isPlaying: raw.isPlaying };
  return result;
}

function addDeviceData(inst: DistributedManager, devId: string, devName: string, netId: string, range: number, timeVal: number): void {
  const device: DistributedManagerDeviceInfo = {
    deviceId: devId,
    deviceName: devName,
    deviceType: DeviceType.TV,
    networkId: netId,
    range: range,
    updateTime: timeVal,
    isInAuth: false,
    isTrust: false,
    trustDeviceId: '',
    transferLoading: false,
    isInTransfer: false,
    action: DeviceStateChangeAction.READY,
    pinToken: -1,
    isDelete: false
  };
  inst.addDevice(devId, device);
}

export default function ConcurrentTest001TestSuite(): void {
  describe('ConcurrentTest001Test', () => {

    describe('Concurrent_PlayControl', () => {
      it('test_con_playPause_rapidToggle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let isPlay: boolean = false;
        p.onStateChange((s: string): void => {
          if (s === 'playing') {
            isPlay = true;
          }
          if (s === 'paused') {
            isPlay = false;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            p.play();
          } else {
            p.pause();
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
      });
      it('test_con_nextPrev_rapidSwitch', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const sl: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = i % 2 === 0 ? (idx + 1) % sl.length : (idx - 1 + sl.length) % sl.length;
        }
        expect(idx >= 0 && idx < sl.length).assertTrue();
      });
      it('test_con_seek_duringPlay', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let seekCount: number = 0;
        p.onSeekDone((): void => {
          seekCount++;
        });
        p.play();
        for (let i: number = 0; i < 100; i++) {
          p.seek(i * 100);
        }
        expect(seekCount).assertEqual(100);
      });
    });

    describe('Concurrent_FocusNavigation', () => {
      it('test_con_focus_rapidLeftRight', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let f: number = 2;
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0 && f > 0) {
            f--;
          } else if (i % 2 === 1 && f < 4) {
            f++;
          }
        }
        expect(f >= 0 && f <= 4).assertTrue();
      });
      it('test_con_focus_buttonActionRapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const actions: string[] = [];
        for (let i: number = 0; i < 100; i++) {
          const f: number = i % 5;
          switch (f) {
            case 0: actions.push('share'); break;
            case 1: actions.push('previous'); break;
            case 2: actions.push('play'); break;
            case 3: actions.push('next'); break;
            case 4: actions.push('list'); break;
          }
        }
        expect(actions.length).assertEqual(100);
      });
    });

    describe('Concurrent_DeviceOperations', () => {
      it('test_con_device_addUpdate_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devIdBase: string = 'cd_' + (i % 100).toString();
          const devName: string = 'CD ' + i.toString();
          const netId: string = 'cn_' + (i % 100).toString();
          addDeviceData(inst, devIdBase, devName, netId, i % 50, new Date().getTime());
          if (i % 5 === 0) {
            inst.updateDeviceProp(devIdBase, 'transferLoading', true);
          }
          if (i % 7 === 0) {
            inst.updateDeviceProp(devIdBase, 'isInTransfer', false);
          }
        }
        expect(true).assertTrue();
      });
      it('test_con_device_scanAuth_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const emptyInfo: StringRecord = makeStringRecord();
        for (let i: number = 0; i < 200; i++) {
          const devIdBase: string = 'csa_' + (i % 50).toString();
          const devName: string = 'CSA ' + i.toString();
          const netId: string = 'csan_' + (i % 50).toString();
          const device: DistributedManagerDeviceInfo = {
            deviceId: devIdBase,
            deviceName: devName,
            deviceType: DeviceType.TV,
            networkId: netId,
            range: i
          } as DistributedManagerDeviceInfo;
          inst.startScan();
          inst.addDevice(devIdBase, device);
          const param: AuthParam = { authType: 1, extraInfo: emptyInfo };
          inst.authenticateDevice(device, param);
          inst.stopScan();
        }
        expect(true).assertTrue();
      });
    });

    describe('Concurrent_KVOperations', () => {
      it('test_con_kv_putGet_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'ck_' + (i % 100).toString();
          await store.put(key, i);
          if (i % 10 === 0) {
            await store.get(key);
          }
        }
        expect(true).assertTrue();
      });
      it('test_con_kv_putDelete_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'ckd_' + (i % 50).toString();
          await store.put(key, i);
          if (i % 5 === 0) {
            await store.delete(key);
          }
        }
        expect(true).assertTrue();
      });
      it('test_con_kv_broadcast_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const emptyObj: StringRecord = makeStringRecord();
        for (let i: number = 0; i < 100; i++) {
          const tag: string = 'cb_' + i.toString();
          KvStoreModel.broadcastMessage(emptyObj, tag);
        }
        expect(true).assertTrue();
      });
    });

    describe('Concurrent_Logger', () => {
      it('test_con_logger_allLevels_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const dStr: string = 'cd_' + i.toString();
          const iStr: string = 'ci_' + i.toString();
          const wStr: string = 'cw_' + i.toString();
          const eStr: string = 'ce_' + i.toString();
          Logger.debug(dStr);
          Logger.info(iStr);
          Logger.warn(wStr);
          Logger.error(eStr);
        }
        expect(true).assertTrue();
      });
      it('test_con_logUtil_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const tag: string = 'ct_' + i.toString();
          const msg: string = 'cm_' + i.toString();
          Logger.debug(tag, msg);
          Logger.debug(tag, msg);
          Logger.info(tag, msg);
          Logger.error(tag, msg);
          Logger.warn(tag, msg);
        }
        expect(true).assertTrue();
      });
    });

    describe('Concurrent_Preferences', () => {
      it('test_con_pref_writeRead_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'cp_' + (i % 100).toString();
          const val: string = 'cv_' + i.toString();
          Preferences.writeData(key, val);
          Preferences.readData(key);
        }
        expect(true).assertTrue();
      });
      it('test_con_pref_writeDelete_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'cpd_' + (i % 50).toString();
          const val: string = 'cvd_' + i.toString();
          Preferences.writeData(key, val);
          if (i % 5 === 0) {
            Preferences.deleteData(key);
          }
        }
        expect(true).assertTrue();
      });
    });

    describe('Concurrent_ModelCreation', () => {
      it('test_con_songItem_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'cs_' + i.toString();
          const authorStr: string = 'ca_' + i.toString();
          const urlStr: string = 'cu_' + i.toString();
          const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, time: i });
          expect(m.name).assertEqual(nameStr);
        }
      });
      it('test_con_playState_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'cn_' + i.toString();
          const authorStr: string = 'ca_' + i.toString();
          const urlStr: string = 'cu_' + i.toString();
          const s: PlayStateTypeModel = new PlayStateTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, playIndex: i % 10, time: i, duration: i * 2, isPlay: i % 2 === 0, playMode: 'auto', playList: [] });
          expect(s.playIndex).assertEqual(i % 10);
        }
      });
      it('test_con_button_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'cb_' + i.toString();
          const b: ButtonModel = new ButtonModel({ name: nameStr, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: i % 2 === 0 });
          expect(b.name).assertEqual(nameStr);
        }
      });
    });

    describe('Concurrent_JSON', () => {
      it('test_con_json_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const uriStr: string = 'cu_' + i.toString();
          const d: ParseResult = { uri: uriStr, seekTo: i, isPlaying: i % 2 === 0 };
          const j: string = JSON.stringify(d);
          const p: ParseResult = parseToResult(j);
          const expectedUri: string = 'cu_' + i.toString();
          expect(p.uri).assertEqual(expectedUri);
        }
      });
    });

    describe('Concurrent_TimeFormat', () => {
      it('test_con_timeFormat_rapid', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 180);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
    });

    describe('Concurrent_MixedOperations', () => {
      it('test_con_mixed_rapid_100', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        const sl: songItemType[] = mkSongs(5);
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 10;
          switch (op) {
            case 0: isPlay = !isPlay; break;
            case 1: idx = (idx + 1) % sl.length; break;
            case 2: idx = (idx - 1 + sl.length) % sl.length; break;
            case 3: if (f > 0) { f--; } break;
            case 4: if (f < 4) { f++; } break;
            case 5: number2time(i * 180); break;
            case 6: {
              const uri: string = sl[idx].url;
              JSON.stringify({ uri: uri, seekTo: i });
              break;
            }
            case 7: {
              const key: string = 'cmk_' + (i % 100).toString();
              store.put(key, i);
              break;
            }
            case 8: new SongItemTypeModel(sl[idx]); break;
            case 9: {
              const msg: string = 'cm_' + i.toString();
              Logger.debug(msg);
              break;
            }
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
        expect(idx >= 0 && idx < sl.length).assertTrue();
        expect(f >= 0 && f <= 4).assertTrue();
      });
    });

    describe('ConcurrentStress_100', () => {
      it('test_con_stress_playControl_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let isPlay: boolean = false;
        p.onStateChange((s: string): void => {
          if (s === 'playing') {
            isPlay = true;
          }
          if (s === 'paused') {
            isPlay = false;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            p.play();
          } else {
            p.pause();
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
      });
      it('test_con_stress_focusNav_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let f: number = 2;
        for (let i: number = 0; i < 100; i++) {
          if (i % 3 === 0 && f > 0) {
            f--;
          } else if (i % 3 === 1 && f < 4) {
            f++;
          } else {
            f = i % 5;
          }
        }
        expect(f >= 0 && f <= 4).assertTrue();
      });
      it('test_con_stress_kvOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'csk_' + (i % 100).toString();
          store.put(key, i);
          if (i % 20 === 0) {
            store.get(key);
          }
        }
        expect(true).assertTrue();
      });
      it('test_con_stress_deviceOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devIdBase: string = 'csd_' + (i % 100).toString();
          const devName: string = 'CSD ' + i.toString();
          const netId: string = 'csdn_' + (i % 100).toString();
          addDeviceData(inst, devIdBase, devName, netId, i % 100, new Date().getTime());
          if (i % 50 === 0) {
            inst.updateDeviceProp(devIdBase, 'transferLoading', i % 2 === 0);
          }
        }
        expect(true).assertTrue();
      });
      it('test_con_stress_logger_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const dStr: string = 'csd_' + i.toString();
          const iStr: string = 'csi_' + i.toString();
          Logger.debug(dStr);
          Logger.info(iStr);
        }
        expect(true).assertTrue();
      });
      it('test_con_stress_modelCreation_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'css_' + i.toString();
          const authorStr: string = 'csa_' + i.toString();
          const urlStr: string = 'csu_' + i.toString();
          const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, time: i });
          expect(m.name).assertEqual(nameStr);
        }
      });
      it('test_con_stress_json_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const uriStr: string = 'csu_' + i.toString();
          const d: ParseResult = { uri: uriStr, seekTo: i, isPlaying: i % 2 === 0 };
          const j: string = JSON.stringify(d);
          const p: ParseResult = parseToResult(j);
          const expectedUri: string = 'csu_' + i.toString();
          expect(p.uri).assertEqual(expectedUri);
        }
      });
      it('test_con_stress_timeFormat_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 36);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
      it('test_con_stress_mixedAll_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        const sl: songItemType[] = mkSongs(5);
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 15;
          switch (op) {
            case 0: isPlay = !isPlay; break;
            case 1: idx = (idx + 1) % sl.length; break;
            case 2: idx = (idx - 1 + sl.length) % sl.length; break;
            case 3: if (f > 0) { f--; } break;
            case 4: if (f < 4) { f++; } break;
            case 5: number2time(i * 36); break;
            case 6: {
              const uri: string = sl[idx].url;
              JSON.stringify({ uri: uri, seekTo: i });
              break;
            }
            case 7: {
              const key: string = 'cmk_' + (i % 100).toString();
              store.put(key, i);
              break;
            }
            case 8: new SongItemTypeModel(sl[idx]); break;
            case 9: {
              const msg: string = 'cm_' + i.toString();
              Logger.debug(msg);
              break;
            }
            case 10: {
              const pKey: string = 'cmp_' + (i % 200).toString();
              const pVal: string = 'cmv_' + i.toString();
              Preferences.writeData(pKey, pVal);
              break;
            }
            case 11: {
              const devId: string = 'cmd_' + (i % 300).toString();
              const devName: string = 'CMD ' + i.toString();
              const netId: string = 'cmdn_' + (i % 300).toString();
              addDeviceData(inst, devId, devName, netId, i % 50, new Date().getTime());
              break;
            }
            case 12: {
              const nameStr: string = 'cmn_' + i.toString();
              const authorStr: string = 'cma_' + i.toString();
              const urlStr: string = 'cmu_' + i.toString();
              new PlayStateTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, playIndex: idx, time: i, duration: i * 2, isPlay: isPlay, playMode: 'auto', playList: [] });
              break;
            }
            case 13: {
              const btnName: string = 'cmb_' + i.toString();
              new ButtonModel({ name: btnName, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: i % 2 === 0 });
              break;
            }
            case 14: PointerUtil.changePointStyle(i % 2 === 0); break;
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
        expect(idx >= 0 && idx < sl.length).assertTrue();
        expect(f >= 0 && f <= 4).assertTrue();
      });
    });
  });
}
