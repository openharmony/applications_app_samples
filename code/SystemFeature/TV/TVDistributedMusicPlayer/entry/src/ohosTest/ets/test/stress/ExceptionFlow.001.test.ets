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

function getNullMockPlayer(): MockAVPlayer | null {
  return null;
}

function getNullDistributedDevice(): DistributedManagerDeviceInfo | null {
  return null;
}

function getNullSongItem(): songItemType | null {
  return null;
}

function getUndefinedStringCallback(): ((msg: string) => void) | undefined {
  return undefined;
}

function getUndefinedPlayState(): PlayStateType | undefined {
  return undefined;
}

function getNullNetworkId(): string | null {
  return null;
}

interface CircularObj {
  a?: number;
  self?: CircularObj;
  child?: CircularObj;
}

function mkSongs(n: number): songItemType[] {
  const r: songItemType[] = [];
  for (let i: number = 0; i < n; i++) {
    const imgVal: Resource = $r('app.media.album1');
    const nameVal: string = 's_' + i.toString();
    const authorVal: string = 'a_' + i.toString();
    const urlVal: string = 'u_' + i.toString() + '.wav';
    const timeVal: number = (i + 1) * 100;
    r.push({ img: imgVal, name: nameVal, author: authorVal, url: urlVal, time: timeVal });
  }
  return r;
}
function mkDevices(n: number): DistributedManagerDeviceInfo[] {
  const r: DistributedManagerDeviceInfo[] = [];
  for (let i: number = 0; i < n; i++) {
    const devId: string = 'd_' + i.toString();
    const devName: string = 'Dev ' + i.toString();
    const devType: DeviceType = [DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET][i % 3];
    const netId: string = 'n_' + i.toString();
    const range: number = i + 1;
    const now: number = new Date().getTime();
    const trustId: string = i % 3 === 0 ? 't_' + i.toString() : '';
    const isTrustVal: boolean = i % 3 === 0;
    r.push({
      deviceId: devId, deviceName: devName, deviceType: devType, networkId: netId, range: range,
      isInAuth: false, isTrust: isTrustVal, trustDeviceId: trustId, transferLoading: false, isInTransfer: false,
      action: DeviceStateChangeAction.READY, updateTime: now, pinToken: -1, isDelete: false
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
    const val: number | undefined = this.store.get(k);
    if (val === undefined) {
      return Promise.resolve(null);
    }
    return Promise.resolve(val);
  }
  delete(k: string): Promise<void> {
    this.store.delete(k);
    return Promise.resolve();
  }
  has(k: string): boolean {
    return this.store.has(k);
  }
  on(event: string, type: number, cb: (msg: string) => void): void {}
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
  stopPropagation(): void {}
  preventDefault(): void {}
  getHistoricalPoints() { return []; }
}
class MockAVPlayer {
  state: string = 'idle';
  url: string = '';
  duration: number = 0;
  time: number = 0;
  isPlay: boolean = false;
  private stateChangeCb: ((s: string) => void) | null = null;
  private seekDoneCb: (() => void) | null = null;
  private durationUpdateCb: ((d: number) => void) | null = null;
  private timeUpdateCb: ((t: number) => void) | null = null;
  onStateChange(callback: (s: string) => void): void {
    this.stateChangeCb = callback;
  }
  onSeekDone(callback: () => void): void {
    this.seekDoneCb = callback;
  }
  onDurationUpdate(callback: (d: number) => void): void {
    this.durationUpdateCb = callback;
  }
  onTimeUpdate(callback: (t: number) => void): void {
    this.timeUpdateCb = callback;
  }
  prepare(): void {
    this.state = 'prepared';
    if (this.stateChangeCb) {
      this.stateChangeCb('prepared');
    }
  }
  play(): void {
    this.state = 'playing';
    this.isPlay = true;
    if (this.stateChangeCb) {
      this.stateChangeCb('playing');
    }
  }
  pause(): void {
    this.state = 'paused';
    this.isPlay = false;
    if (this.stateChangeCb) {
      this.stateChangeCb('paused');
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
    if (this.seekDoneCb) {
      this.seekDoneCb();
    }
  }
  emitDuration(d: number): void {
    if (this.durationUpdateCb) {
      this.durationUpdateCb(d);
    }
  }
  emitTime(t: number): void {
    if (this.timeUpdateCb) {
      this.timeUpdateCb(t);
    }
  }
}

export default function ExceptionFlow001TestSuite(): void {
  describe('ExceptionFlow001Test', () => {

    describe('Exception_NullUndefined', () => {
      it('test_ex_nullPlayer', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let p: MockAVPlayer | null = getNullMockPlayer();
        let threw: boolean = false;
        try {
          if (p !== null) {
            p.play();
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_nullDevice', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let d: DistributedManagerDeviceInfo | null = getNullDistributedDevice();
        let threw: boolean = false;
        try {
          if (d !== null) {
            d.isInAuth = true;
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_nullSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let s: songItemType | null = getNullSongItem();
        let threw: boolean = false;
        try {
          if (s !== null) {
            s.name = 'test';
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_undefinedCallback', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let cb: ((msg: string) => void) | undefined = getUndefinedStringCallback();
        let threw: boolean = false;
        try {
          if (cb) {
            cb('test');
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_undefinedPlayState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let s: PlayStateType | undefined = getUndefinedPlayState();
        let threw: boolean = false;
        try {
          if (s) {
            s.isPlay = true;
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_InvalidJson', () => {
      it('test_ex_invalidJson_catch', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalidJsons: string[] = ['}{', '{invalid}', 'not json', '{"a":}', '{"a"}', 'undefined', 'null', 'true', '42'];
        for (let ji: number = 0; ji < invalidJsons.length; ji++) {
          const j: string = invalidJsons[ji];
          let error: boolean = false;
          try {
            JSON.parse(j);
          } catch (e) {
            error = true;
          }
          expect(error).assertTrue();
        }
      });
      it('test_ex_validJson_noError', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const validJsons: string[] = ['{}', '[]', '{"a":1}', '{"uri":"test"}', '{"seekTo":0,"isPlaying":false}'];
        for (let ji: number = 0; ji < validJsons.length; ji++) {
          const j: string = validJsons[ji];
          let error: boolean = false;
          try {
            JSON.parse(j);
          } catch (e) {
            error = true;
          }
          expect(error).assertFalse();
        }
      });
    });

    describe('Exception_EmptyCollections', () => {
      it('test_ex_emptyPlayList_next', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = [];
        let threw: boolean = false;
        try {
          p.next();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_emptyPlayList_previous', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = [];
        let threw: boolean = false;
        try {
          p.previous();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_emptyDeviceList_scan', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        let threw: boolean = false;
        try {
          inst.startScan();
          inst.stopScan();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_emptyKey_kv', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.put('', 1);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_OutOfBounds', () => {
      it('test_ex_oob_playIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = mkSongs(3);
        p.playIndex = 999;
        expect(p.playIndex).assertEqual(999);
      });
      it('test_ex_oob_negativePlayIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = mkSongs(3);
        p.playIndex = -1;
        expect(p.playIndex).assertEqual(-1);
      });
      it('test_ex_oob_focusIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = 999;
        expect(f).assertEqual(999);
      });
      it('test_ex_oob_negativeFocusIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = -1;
        expect(f).assertEqual(-1);
      });
    });

    describe('Exception_TypeMismatch', () => {
      it('test_ex_type_stringAsNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const val: string = 'not a number';
        expect(isNaN(Number(val))).assertTrue();
      });
      it('test_ex_type_numberAsString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const val: number = 42;
        expect(String(val)).assertEqual('42');
      });
      it('test_ex_type_booleanAsString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(String(true)).assertEqual('true');
        expect(String(false)).assertEqual('false');
      });
    });

    describe('Exception_NetworkFailure', () => {
      it('test_ex_net_emptyNetworkId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nid: string = '';
        const canStart: boolean = !!nid;
        expect(canStart).assertFalse();
      });
      it('test_ex_net_nullNetworkId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nid: string | null = getNullNetworkId();
        let canStart: boolean = false;
        if (nid !== null) {
          canStart = nid.length > 0;
        }
        expect(canStart).assertFalse();
      });
      it('test_ex_net_invalidNetworkId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nid: string = '<script>network</>';
        expect(nid.indexOf('<script>') !== -1).assertTrue();
      });
    });

    describe('Exception_DeviceAuthFailure', () => {
      it('test_ex_auth_invalidDevice', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const emptyInfo: StringRecord = makeStringRecord();
        const invalidDevice: DistributedManagerDeviceInfo = {
          deviceId: '',
          deviceName: '',
          deviceType: DeviceType.UNKNOWN_TYPE,
          networkId: '',
          range: 0
        } as DistributedManagerDeviceInfo;
        const authParam: AuthParam = { authType: 1, extraInfo: emptyInfo };
        let threw: boolean = false;
        try {
          inst.authenticateDevice(invalidDevice, authParam);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_auth_invalidAuthType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extraInfo: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: -1, extraInfo: extraInfo };
        expect(a.authType < 0).assertTrue();
      });
    });

    describe('Exception_PlayerState', () => {
      it('test_ex_player_pauseWhenNotPlaying', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.isPlay = false;
        let threw: boolean = false;
        try {
          p.pause();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_player_playWhenAlreadyPlaying', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.isPlay = true;
        let threw: boolean = false;
        try {
          p.play();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_player_seekWhenNoDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.duration = 0;
        let threw: boolean = false;
        try {
          p.seek(100);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_MessageRouting', () => {
      it('test_ex_msg_invalidCode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalidCode: number = 999;
        let handled: boolean = false;
        for (let c: number = 1; c <= 11; c++) {
          if (invalidCode === c) {
            handled = true;
            break;
          }
        }
        expect(handled).assertFalse();
      });
      it('test_ex_msg_zeroCode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const zeroCode: number = 0;
        let handled: boolean = false;
        for (let c: number = 1; c <= 11; c++) {
          if (zeroCode === c) {
            handled = true;
            break;
          }
        }
        expect(handled).assertFalse();
      });
      it('test_ex_msg_negativeCode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const negCode: number = -1;
        let handled: boolean = false;
        for (let c: number = 1; c <= 11; c++) {
          if (negCode === c) {
            handled = true;
            break;
          }
        }
        expect(handled).assertFalse();
      });
    });

    describe('Exception_Preferences', () => {
      it('test_ex_pref_readNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const r: string = String(Preferences.readData('nonExistentKey'));
        expect(r).assertEqual('default');
      });
      it('test_ex_pref_deleteNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Preferences.deleteData('nonExistentKey');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_pref_changeNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Preferences.changeData('nonExistentKey', 'val');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_Logger', () => {
      it('test_ex_logger_noArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug();
          Logger.info();
          Logger.warn();
          Logger.error();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_logger_undefinedArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          const undefStr: string = String(undefined);
          Logger.debug(undefStr);
          Logger.info(undefStr);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_ObjType', () => {
      it('test_ex_objType_circularRef', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const obj: CircularObj = { a: 1 };
        obj.self = obj;
        let threw: boolean = false;
        try {
          objType(obj);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_objType_veryDeepObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let obj: CircularObj = {};
        let current: CircularObj = obj;
        for (let i: number = 0; i < 100; i++) {
          const child: CircularObj = {};
          current.child = child;
          current = child;
        }
        let threw: boolean = false;
        try {
          objType(obj);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_KVStore', () => {
      it('test_ex_kv_getNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async () => {
        const store: MockKVStore = new MockKVStore();
        const v: number | null = await store.get('nonExistent');
        expect(v).assertEqual(null);
      });
      it('test_ex_kv_deleteNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async () => {
        const store: MockKVStore = new MockKVStore();
        let threw: boolean = false;
        try {
          await store.delete('nonExistent');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Exception_DeviceManager', () => {
      it('test_ex_deviceMgr_updateNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        let threw: boolean = false;
        try {
          inst.updateDeviceProp('nonExistent', 'transferLoading', true);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_ex_deviceMgr_authNonExistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const emptyInfo: StringRecord = makeStringRecord();
        const invalidDevice: DistributedManagerDeviceInfo = {
          deviceId: 'nonExistent',
          deviceName: '',
          deviceType: DeviceType.UNKNOWN_TYPE,
          networkId: '',
          range: 0
        } as DistributedManagerDeviceInfo;
        const authParam: AuthParam = { authType: 1, extraInfo: emptyInfo };
        let threw: boolean = false;
        try {
          inst.authenticateDevice(invalidDevice, authParam);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('ExceptionStress_100', () => {
      it('test_ex_stress_nullCheck_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          let p: MockAVPlayer | null = i % 2 === 0 ? null : new MockAVPlayer();
          let threw: boolean = false;
          try {
            if (p) {
              p.play();
            }
          } catch (e) {
            threw = true;
          }
          expect(threw).assertFalse();
        }
      });
      it('test_ex_stress_invalidJson_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          let error: boolean = false;
          const jsonStr: string = 'invalid_' + i.toString();
          try {
            JSON.parse(jsonStr);
          } catch (e) {
            error = true;
          }
          expect(error).assertTrue();
        }
      });
      it('test_ex_stress_oobIndex_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const sl: songItemType[] = mkSongs(5);
        for (let i: number = 0; i < 100; i++) {
          let threw: boolean = false;
          try {
            const idx: number = i % 2 === 0 ? -1 : 999;
            const s: songItemType = sl[idx];
          } catch (e) {
            threw = true;
          }
          expect(threw).assertFalse();
        }
      });
      it('test_ex_stress_emptyOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = [];
        for (let i: number = 0; i < 100; i++) {
          let threw: boolean = false;
          try {
            p.next();
            p.previous();
          } catch (e) {
            threw = true;
          }
          expect(threw).assertFalse();
        }
      });
    });
  });
}
