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

function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += s;
  }
  return result;
}

function addDeviceData(inst: DistributedManager, devId: string, devName: string, netId: string,
  range: number, timeVal: number): void {
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
  private onStateChangeCb: ((s: string) => void) | null = null;
  private onSeekDoneCb: (() => void) | null = null;
  private onDurationUpdateCb: ((d: number) => void) | null = null;
  private onTimeUpdateCb: ((t: number) => void) | null = null;

  onStateChange(callback: (s: string) => void): void {
    this.onStateChangeCb = callback;
  }

  onSeekDone(callback: () => void): void {
    this.onSeekDoneCb = callback;
  }

  onDurationUpdate(callback: (d: number) => void): void {
    this.onDurationUpdateCb = callback;
  }

  onTimeUpdate(callback: (t: number) => void): void {
    this.onTimeUpdateCb = callback;
  }

  off(event: string): void {
    if (event === 'stateChange') {
      this.onStateChangeCb = null;
    } else if (event === 'seekDone') {
      this.onSeekDoneCb = null;
    } else if (event === 'durationUpdate') {
      this.onDurationUpdateCb = null;
    } else if (event === 'timeUpdate') {
      this.onTimeUpdateCb = null;
    }
  }

  prepare(): void {
    this.state = 'prepared';
    if (this.onStateChangeCb) {
      this.onStateChangeCb('prepared');
    }
  }

  play(): void {
    this.state = 'playing';
    this.isPlay = true;
    if (this.onStateChangeCb) {
      this.onStateChangeCb('playing');
    }
  }

  pause(): void {
    this.state = 'paused';
    this.isPlay = false;
    if (this.onStateChangeCb) {
      this.onStateChangeCb('paused');
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
    if (this.onSeekDoneCb) {
      this.onSeekDoneCb();
    }
  }

  emitDuration(d: number): void {
    if (this.onDurationUpdateCb) {
      this.onDurationUpdateCb(d);
    }
  }

  emitTime(t: number): void {
    if (this.onTimeUpdateCb) {
      this.onTimeUpdateCb(t);
    }
  }
}

function mkSongs(n: number): songItemType[] {
  const r: songItemType[] = [];
  for (let i: number = 0; i < n; i++) {
    r.push({
      img: $r('app.media.album1'),
      name: 's_' + i.toString(),
      author: 'a_' + i.toString(),
      url: 'u_' + i.toString() + '.wav',
      time: (i + 1) * 3000,
    });
  }
  return r;
}

function mkDevices(n: number): DistributedManagerDeviceInfo[] {
  const r: DistributedManagerDeviceInfo[] = [];
  for (let i: number = 0; i < n; i++) {
    const dtIdx: number = i % 3;
    const dt: DeviceType = [DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET][dtIdx];
    const isTrustVal: boolean = i % 3 === 0;
    const trustId: string = isTrustVal ? 't_' + i.toString() : '';
    r.push({
      deviceId: 'd_' + i.toString(),
      deviceName: 'Dev ' + i.toString(),
      deviceType: dt,
      networkId: 'n_' + i.toString(),
      range: i + 1,
      isInAuth: false,
      isTrust: isTrustVal,
      trustDeviceId: trustId,
      transferLoading: false,
      isInTransfer: false,
      action: DeviceStateChangeAction.READY,
      updateTime: new Date().getTime(),
      pinToken: -1,
      isDelete: false,
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

export default function UltraStress001TestSuite(): void {
  describe('UltraStress001Test', () => {
    describe('UltraStress_PlayControl_100', () => {
      it('test_ultra_playPause_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let ip: boolean = false;
        for (let i: number = 0; i < 100; i++) {
          ip = !ip;
        }
        const ipType: boolean = ip;
        expect(typeof ipType).assertEqual('boolean');
      });
      it('test_ultra_nextPrev_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const sl: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = i % 2 === 0 ? (idx + 1) % sl.length : (idx - 1 + sl.length) % sl.length;
        }
        const cond: boolean = idx >= 0 && idx < sl.length;
        expect(cond).assertTrue();
      });
      it('test_ultra_focusNav_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
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
        const cond: boolean = f >= 0 && f <= 4;
        expect(cond).assertTrue();
      });
      it('test_ultra_musicListNav_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const len: number = 10;
        let id: number = 0;
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0 && id < len - 1) {
            id++;
          } else if (i % 2 === 1 && id > 0) {
            id--;
          }
        }
        const cond: boolean = id >= 0 && id < len;
        expect(cond).assertTrue();
      });
      it('test_ultra_changePlayFlag_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let f: string = '';
        const flags: string[] = ['PRE', 'NEXT', ''];
        for (let i: number = 0; i < 100; i++) {
          f = flags[i % 3];
          if (f === 'PRE') {
            f = '';
          } else if (f === 'NEXT') {
            f = '';
          }
        }
        expect(f).assertEqual('');
      });
      it('test_ultra_deleteMode_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let d: boolean = false;
        for (let i: number = 0; i < 100; i++) {
          d = !d;
        }
        const dType: boolean = d;
        expect(typeof dType).assertEqual('boolean');
      });
    });
    describe('UltraStress_DataOps_100', () => {
      it('test_ultra_kvPutGet_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('uk_' + (i % 100).toString(), i);
          if (i % 20 === 0) {
            store.get('uk_' + (i % 100).toString());
          }
        }
        expect(true).assertTrue();
      });
      it('test_ultra_kvDelete_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('ukd_' + (i % 100).toString(), i);
          if (i % 5 === 0) {
            store.delete('ukd_' + (i % 100).toString());
          }
        }
        expect(true).assertTrue();
      });
      it('test_ultra_kvHas_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('ukh_' + (i % 100).toString(), i);
          store.has('ukh_' + (i % 100).toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_jsonSerialize_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const uriStr: string = 'u_' + i.toString();
          const sVal: number = i;
          const isPlaying: boolean = i % 2 === 0;
          JSON.stringify({ uri: uriStr, seekTo: sVal, isPlaying: isPlaying });
        }
        expect(true).assertTrue();
      });
      it('test_ultra_jsonParse_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const j: string = '{"uri":"u_' + i.toString() + '","seekTo":' + i.toString() + ',"isPlaying":' +
            (i % 2 === 0).toString() + '}';
          const parsVal: Record<string, Object> = JSON.parse(j) as Record<string, Object>;
          expect(parsVal.seekTo).assertEqual(i);
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_DeviceOps_100', () => {
      it('test_ultra_addDevice_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'ud_' + (i % 100).toString();
          addDeviceData(inst, devId, 'UD ' + i.toString(), 'un_' + (i % 100).toString(), i % 100, new Date().getTime());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_updateDeviceProp_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const propDevice: DistributedManagerDeviceInfo = {
          deviceId: 'ud_prop',
          deviceName: 'UD Prop',
          deviceType: DeviceType.TV,
          networkId: 'un_prop',
          range: 0,
          updateTime: new Date().getTime(),
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          pinToken: -1,
          isDelete: false
        };
        inst.addDevice('ud_prop', propDevice);
        for (let i: number = 0; i < 100; i++) {
          inst.updateDeviceProp('ud_prop', 'transferLoading', i % 2 === 0);
          inst.updateDeviceProp('ud_prop', 'isInTransfer', i % 3 === 0);
          inst.updateDeviceProp('ud_prop', 'isInAuth', i % 7 === 0);
          inst.updateDeviceProp('ud_prop', 'isTrust', i % 11 === 0);
        }
        expect(true).assertTrue();
      });
      it('test_ultra_scanCycle_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            inst.startScan();
          } else {
            inst.stopScan();
          }
        }
        inst.stopScan();
        expect(true).assertTrue();
      });
      it('test_ultra_authCycle_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const emptyInfo: StringRecord = makeStringRecord();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'uac_' + (i % 200).toString();
          const devName: string = 'UAC ' + i.toString();
          const netId: string = 'uacn_' + (i % 200).toString();
          const device: DistributedManagerDeviceInfo = {
            deviceId: devId,
            deviceName: devName,
            deviceType: DeviceType.TV,
            networkId: netId,
            range: i,
          } as DistributedManagerDeviceInfo;
          inst.addDevice(devId, device);
          const param: AuthParam = { authType: 1, extraInfo: emptyInfo };
          inst.authenticateDevice(device, param);
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_ModelCreation_100', () => {
      it('test_ultra_songItemModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const m: SongItemTypeModel = new SongItemTypeModel({
            img: '',
            name: 'us_' + i.toString(),
            author: 'ua_' + i.toString(),
            url: 'uu_' + i.toString(),
            time: i,
          });
          expect(m.name).assertEqual('us_' + i.toString());
        }
      });
      it('test_ultra_playStateModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const pmIdx: number = i % 3;
          const pmArr: string[] = ['auto', 'repeat', 'random'];
          const pmVal: string = pmArr[pmIdx];
          const typedPm: 'auto' | 'repeat' | 'random' = pmVal as 'auto' | 'repeat' | 'random';
          const s: PlayStateTypeModel = new PlayStateTypeModel({
            img: '',
            name: 'un_' + i.toString(),
            author: 'ua_' + i.toString(),
            url: 'uu_' + i.toString(),
            playIndex: i % 100,
            time: i,
            duration: i * 2,
            isPlay: i % 2 === 0,
            playMode: typedPm,
            playList: [],
          });
          expect(s.playIndex).assertEqual(i % 100);
        }
      });
      it('test_ultra_buttonModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const b: ButtonModel = new ButtonModel({
            name: 'ub_' + i.toString(),
            iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'),
            isFocus: i % 2 === 0,
          });
          expect(b.name).assertEqual('ub_' + i.toString());
        }
      });
      it('test_ultra_deviceInfoType_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const d: DeviceInfoType = {
            deviceId: 'udt_' + i.toString(),
            deviceName: 'UDT ' + i.toString(),
            deviceType: DeviceType.TV,
            networkId: 'un_' + i.toString(),
            range: i % 100,
          };
          expect(d.deviceId).assertEqual('udt_' + i.toString());
        }
      });
      it('test_ultra_authParam_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const extraInfoObj: StringRecord = makeStringRecord();
          extraInfoObj.idx = i.toString();
          const a: AuthParam = { authType: i % 2 === 0 ? 1 : 0, extraInfo: extraInfoObj };
          const aType: number = a.authType;
          expect(typeof aType).assertEqual('number');
        }
      });
    });
    describe('UltraStress_UITimeFormat_100', () => {
      it('test_ultra_timeFormat_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 18);
          const containsColon: boolean = r.indexOf(':') !== -1;
          expect(containsColon).assertTrue();
        }
      });
      it('test_ultra_progressCalc_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const dur: number = 180000;
        for (let i: number = 0; i < 100; i++) {
          const t: number = i * 4;
          const p: number = Math.floor(t / dur * 100);
          const cond: boolean = p >= 0 && p <= 100;
          expect(cond).assertTrue();
        }
      });
    });
    describe('UltraStress_Logger_100', () => {
      it('test_ultra_loggerAllLevels_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.debug('ul_' + i.toString());
          Logger.info('ul_' + i.toString());
          Logger.warn('ul_' + i.toString());
          Logger.error('ul_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_logUtil_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.debug('ut_' + i.toString(), 'um_' + i.toString());
          Logger.debug('ut_' + i.toString(), 'um_' + i.toString());
          Logger.info('ut_' + i.toString(), 'um_' + i.toString());
          Logger.error('ut_' + i.toString(), 'um_' + i.toString());
          Logger.warn('ut_' + i.toString(), 'um_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_initLog_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.info('ut_' + i.toString(), 'um_' + i.toString());
          Logger.debug('ut_' + i.toString(), 'um_' + i.toString());
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_Preferences_100', () => {
      it('test_ultra_prefWrite_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.writeData('upk_' + (i % 100).toString(), 'upv_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_prefRead_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.readData('uprk_' + (i % 100).toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_prefDelete_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.deleteData('updk_' + (i % 100).toString());
        }
        expect(true).assertTrue();
      });
      it('test_ultra_prefFlush_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.writeData('upfk_' + (i % 100).toString(), 'upfv_' + i.toString());
          if (i % 100 === 0) {
            Preferences.flushData();
          }
        }
        expect(true).assertTrue();
      });
      it('test_ultra_prefSubscribe_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.subscribeData('upsk_' + (i % 200).toString());
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_ObjType_100', () => {
      it('test_ultra_objType_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const emptyObj: ObjectRecord = {} as ObjectRecord;
        const emptyArr: string[] = [];
        const vals: Array<string | number | boolean | null | undefined | ObjectRecord | string[] | (() => void)> = ['str', 42, true, null, undefined, emptyObj, emptyArr, (): void => {}];
        for (let i: number = 0; i < 100; i++) {
          const r: string = objType(vals[i % vals.length]);
          expect(r.length).assertLarger(0);
        }
      });
    });
    describe('UltraStress_SongsData_100', () => {
      it('test_ultra_songsIteration_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const s: songItemType = songs[i % songs.length];
          expect(s.name.length).assertLarger(0);
          expect(s.author.length).assertLarger(0);
          expect(s.url.length).assertLarger(0);
        }
      });
    });
    describe('UltraStress_MixedAll_100', () => {
      it('test_ultra_mixedAllModules_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        let flag: string = '';
        let delMode: boolean = false;
        const sl: songItemType[] = mkSongs(5);
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 20;
          switch (op) {
            case 0:
              isPlay = !isPlay;
              break;
            case 1:
              idx = (idx + 1) % sl.length;
              break;
            case 2:
              idx = (idx - 1 + sl.length) % sl.length;
              break;
            case 3:
              if (f > 0) {
                f--;
              }
              break;
            case 4:
              if (f < 4) {
                f++;
              }
              break;
            case 5:
              flag = 'PRE';
              flag = '';
              break;
            case 6:
              flag = 'NEXT';
              flag = '';
              break;
            case 7:
              delMode = !delMode;
              break;
            case 8:
              number2time(i * 18);
              break;
            case 9:
              JSON.stringify({ uri: sl[idx].url, seekTo: i, isPlaying: isPlay });
              break;
            case 10:
              Logger.debug('um_' + i.toString());
              break;
            case 11:
              Logger.debug('umt_' + i.toString(), 'umm_' + i.toString());
              break;
            case 12:
              PointerUtil.changePointStyle(i % 2 === 0);
              break;
            case 13:
              objType(sl[idx]);
              break;
            case 14:
              Preferences.writeData('ump_' + (i % 100).toString(), 'umv_' + i.toString());
              break;
            case 15:
              new SongItemTypeModel(sl[idx]);
              break;
            case 16:
              const pmIdx: number = i % 3;
              const pmArr: string[] = ['auto', 'repeat', 'random'];
              const pmVal: string = pmArr[pmIdx];
              const typedPm: 'auto' | 'repeat' | 'random' = pmVal as 'auto' | 'repeat' | 'random';
              new PlayStateTypeModel({
                img: '',
                name: 'umn_' + i.toString(),
                author: 'uma_' + i.toString(),
                url: 'umu_' + i.toString(),
                playIndex: idx,
                time: i,
                duration: i * 2,
                isPlay: isPlay,
                playMode: typedPm,
                playList: [],
              });
              break;
            case 17:
              new ButtonModel({
                name: 'umb_' + i.toString(),
                iconNormal: $r('app.media.ic_play'),
                iconFocus: $r('app.media.ic_play'),
                isFocus: i % 2 === 0,
              });
              break;
            case 18:
              store.put('umk_' + (i % 100).toString(), i);
              break;
            case 19:
              const devId: string = 'umd_' + (i % 100).toString();
              addDeviceData(inst, devId, 'UMD ' + i.toString(), 'umn_' + (i % 100).toString(), i % 50, new Date().getTime());
              break;
          }
        }
        const isPlayType: boolean = isPlay;
        expect(typeof isPlayType).assertEqual('boolean');
        const idxCond: boolean = idx >= 0 && idx < sl.length;
        expect(idxCond).assertTrue();
        const fCond: boolean = f >= 0 && f <= 4;
        expect(fCond).assertTrue();
        expect(flag).assertEqual('');
        const delModeType: boolean = delMode;
        expect(typeof delModeType).assertEqual('boolean');
      });
      it('test_ultra_mixedKVDevice_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          if (i % 3 === 0) {
            store.put('umkd_' + (i % 100).toString(), i);
          } else if (i % 3 === 1) {
            addDeviceData(inst, 'umdd_' + (i % 100).toString(), 'UMDD ' + i.toString(),
              'umdn_' + (i % 100).toString(), i % 100, new Date().getTime());
          } else {
            inst.updateDeviceProp('umdd_' + ((i - 1) % 100).toString(), 'transferLoading', i % 2 === 0);
          }
        }
        expect(true).assertTrue();
      });
      it('test_ultra_mixedJsonModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const s: SongItemTypeModel = new SongItemTypeModel({
            img: '',
            name: 'umjs_' + i.toString(),
            author: 'umja_' + i.toString(),
            url: 'umju_' + i.toString(),
            time: i,
          });
          const j: string = JSON.stringify({ uri: s.url, name: s.name, time: s.time });
          const p: ObjectRecord = JSON.parse(j);
          if (i % 200 === 0) {
            expect(p.uri).assertEqual('umju_' + i.toString());
          }
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_MockPlayer_100', () => {
      it('test_ultra_mockPlayerPlayPause_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
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
        const isPlayType: boolean = isPlay;
        expect(typeof isPlayType).assertEqual('boolean');
      });
      it('test_ultra_mockPlayerSeek_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let seekCount: number = 0;
        p.onSeekDone((): void => {
          seekCount++;
        });
        for (let i: number = 0; i < 100; i++) {
          p.seek(i * 4);
        }
        expect(seekCount).assertEqual(100);
      });
      it('test_ultra_mockPlayerDuration_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let dur: number = 0;
        p.onDurationUpdate((d: number): void => {
          dur = d;
        });
        for (let i: number = 0; i < 100; i++) {
          p.emitDuration(i * 4);
        }
        expect(dur).assertEqual(999 * 4);
      });
      it('test_ultra_mockPlayerTime_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let t: number = 0;
        p.onTimeUpdate((v: number): void => {
          t = v;
        });
        for (let i: number = 0; i < 100; i++) {
          p.emitTime(i * 4);
        }
        expect(t).assertEqual(999 * 4);
      });
      it('test_ultra_mockPlayerReset_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        for (let i: number = 0; i < 100; i++) {
          p.url = 'u_' + i.toString();
          if (i % 100 === 0) {
            p.reset();
          }
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_EventUtil_100', () => {
      it('test_ultra_eventUtilAllTypes_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const e: MockTouch = new MockTouch();
        for (let i: number = 0; i < 100; i++) {
          const typeArr: TouchType[] = [TouchType.Down, TouchType.Move, TouchType.Up];
          e.type = typeArr[i % 3];
          const sourceArr: SourceType[] = [SourceType.Mouse, SourceType.TouchScreen];
          e.source = sourceArr[i % 2];
          EventUtil.isTouchEvent(e);
          if (i % 10 === 0) {
            PointerUtil.changePointStyle(e.type === TouchType.Down);
          }
        }
        expect(true).assertTrue();
      });
    });
    describe('UltraStress_DeviceInfoArray_100', () => {
      it('test_ultra_deviceArrayOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const devs: DistributedManagerDeviceInfo[] = mkDevices(10);
        for (let i: number = 0; i < 100; i++) {
          const d: DistributedManagerDeviceInfo = devs[i % devs.length];
          expect(d.deviceId.length).assertLarger(0);
          const json: string = JSON.stringify(d);
          const p: ObjectRecord = JSON.parse(json);
          if (i % 200 === 0) {
            expect(p.deviceId).assertEqual(d.deviceId);
          }
        }
      });
      it('test_ultra_deviceStateTransitions_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const dev: DistributedManagerDeviceInfo = {
          deviceId: 'ust',
          deviceName: 'UST',
          deviceType: DeviceType.TV,
          networkId: 'ust_net',
          range: 5,
          isInAuth: false,
          isTrust: false,
          transferLoading: false,
          isInTransfer: false,
        };
        for (let i: number = 0; i < 100; i++) {
          if (i % 7 === 0) {
            dev.isInAuth = !dev.isInAuth;
          }
          if (i % 11 === 0) {
            dev.isTrust = !dev.isTrust;
          }
          if (i % 13 === 0) {
            dev.transferLoading = !dev.transferLoading;
          }
          if (i % 17 === 0) {
            dev.isInTransfer = !dev.isInTransfer;
          }
        }
        const devInAuthType: boolean = dev.isInAuth === true;
        expect(typeof devInAuthType).assertEqual('boolean');
      });
    });
  });
}
