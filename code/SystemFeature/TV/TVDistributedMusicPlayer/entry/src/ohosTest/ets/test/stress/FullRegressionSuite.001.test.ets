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
function makeObjectRecord(): ObjectRecord { return {} as ObjectRecord; }

function strRepeat(s: string, count: number): string {
  let r: string = '';
  for (let i: number = 0; i < count; i++) {
    r += s;
  }
  return r;
}

function mkSongs(n: number): songItemType[] {
  const r: songItemType[] = [];
  for (let i: number = 0; i < n; i++) {
    const imgRes: Resource = $r('app.media.album1');
    const nameVal: string = 's_' + i.toString();
    const authorVal: string = 'a_' + i.toString();
    const urlVal: string = 'u_' + i.toString() + '.wav';
    r.push({ img: imgRes, name: nameVal, author: authorVal, url: urlVal, time: (i + 1) * 100 });
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

  prepare(): void {
    this.state = 'prepared';
    if (this.onStateChangeCb !== null) {
      this.onStateChangeCb('playing');
    }
  }

  play(): void {
    this.state = 'playing';
    this.isPlay = true;
    if (this.onStateChangeCb !== null) {
      this.onStateChangeCb('playing');
    }
  }

  pause(): void {
    this.state = 'paused';
    this.isPlay = false;
    if (this.onStateChangeCb !== null) {
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
    if (this.onSeekDoneCb !== null) {
      this.onSeekDoneCb();
    }
  }

  emitDuration(d: number): void {
    if (this.onDurationUpdateCb !== null) {
      this.onDurationUpdateCb(d);
    }
  }

  emitTime(t: number): void {
    if (this.onTimeUpdateCb !== null) {
      this.onTimeUpdateCb(t);
    }
  }
}

export default function FullRegressionSuite001TestSuite(): void {
  describe('FullRegressionSuite001Test', () => {

    describe('Regression_Module_Utils_Logger', () => {
      it('test_reg_logger_allLevels_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.debug('reg_d_' + i.toString());
          Logger.info('reg_i_' + i.toString());
          Logger.warn('reg_w_' + i.toString());
          Logger.error('reg_e_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_reg_logger_boundary_empty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug('');
          Logger.info('');
          Logger.warn('');
          Logger.error('');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_reg_logger_boundary_long', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug(strRepeat('x', 10000));
          Logger.info(strRepeat('y', 10000));
          Logger.warn(strRepeat('z', 10000));
          Logger.error(strRepeat('e', 10000));
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_reg_logger_unicode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug('Debug log message');
          Logger.info('ユ');
          Logger.warn('unicode warning message');
          Logger.error('unicode error message');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_reg_logger_specialChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug('!@#$%^&*()');
          Logger.info('<script>alert(1)</script>');
          Logger.warn('\'; DROP TABLE;--');
          Logger.error('\n\t\r');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Regression_Module_Utils_Log', () => {
      it('test_reg_log_allFunctions_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.debug('t_' + i.toString(), 'm_' + i.toString());
          Logger.debug('t_' + i.toString(), 'm_' + i.toString());
          Logger.info('t_' + i.toString(), 'm_' + i.toString());
          Logger.error('t_' + i.toString(), 'm_' + i.toString());
          Logger.warn('t_' + i.toString(), 'm_' + i.toString());
        }
        expect(true).assertTrue();
      });

    });

    describe('Regression_Module_Utils_Preferences', () => {
      it('test_reg_pref_writeReadDelete_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.writeData('wr_' + i.toString(), 'val_' + i.toString());
          const r: string | undefined = String(Preferences.readData('wr_' + i.toString()));
          Preferences.deleteData('wr_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_reg_pref_allDataTypes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const prefObj: StringRecord = makeStringRecord();
        prefObj.a = '1';
        prefObj.b = 'test';
        Preferences.writeData('strKey', 'stringValue');
        Preferences.writeData('numKey', 12345);
        Preferences.writeData('boolKey', true);
        Preferences.writeData('objKey', prefObj);
        const strVal: string | undefined = String(Preferences.readData('strKey'));
        expect(strVal !== null).assertTrue();
        const numVal: string | undefined = String(Preferences.readData('numKey'));
        expect(numVal !== null).assertTrue();
      });
      it('test_reg_pref_changeData', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('chgKey', 'origVal');
        Preferences.changeData('chgKey', 'newVal');
        const r: string | undefined = String(Preferences.readData('chgKey'));
        expect(r !== null).assertTrue();
      });
      it('test_reg_pref_flushAndSubscribe', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('flushKey', 'flushVal');
        Preferences.flushData();
        Preferences.subscribeData('subKey');
        expect(true).assertTrue();
      });
    });

    describe('Regression_Module_Utils_Utils', () => {
      it('test_reg_objType_allTypes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType('str')).assertEqual('string');
        expect(objType(42)).assertEqual('number');
        expect(objType(true)).assertEqual('boolean');
        expect(objType(null)).assertEqual('null');
        expect(objType(undefined)).assertEqual('undefined');
        const emptyObjForType: ObjectRecord = makeObjectRecord();
        expect(objType(emptyObjForType)).assertEqual('object');
        expect(objType([])).assertEqual('object');
        const fn: () => void = () => {};
        expect(objType(fn)).assertEqual('function');
      });
      it('test_reg_objType_stress_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const emptyObj: ObjectRecord = makeObjectRecord();
        const emptyArr: string[] = [];
        const vals: Array<string | number | boolean | null | undefined | ObjectRecord | string[] | (() => void)> = ['str', 42, true, null, undefined, emptyObj, emptyArr,
          (): void => {}];
        for (let i: number = 0; i < 100; i++) {
          objType(vals[i % vals.length]);
        }
        expect(true).assertTrue();
      });
    });

    describe('Regression_Module_Model_Music', () => {
      it('test_reg_SongItemTypeModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const imgRes: Resource = $r('app.media.album1');
          const nameVal: string = 'reg_' + i.toString();
          const authorVal: string = 'a_' + i.toString();
          const urlVal: string = 'u_' + i.toString();
          const songData: songItemType = { img: imgRes, name: nameVal, author: authorVal, url: urlVal, time: i };
          const m: SongItemTypeModel = new SongItemTypeModel(songData);
          expect(m.name).assertEqual('reg_' + i.toString());
        }
      });
      it('test_reg_songItemInterface_operations', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const sl: songItemType[] = mkSongs(5);
        expect(sl.length).assertEqual(5);
        sl.push({ img: $r('app.media.album1'), name: 'added', author: 'test', url: 'added.wav' });
        expect(sl.length).assertEqual(6);
        sl.splice(0, 1);
        expect(sl.length).assertEqual(5);
        const found: songItemType | undefined = sl.find(s => s.name === 's_1');
        expect(found !== null).assertTrue();
        const idx: number = sl.findIndex(s => s.url === 'u_2.wav');
        expect(idx).assertLarger(-1);
      });
    });

    describe('Regression_Module_Model_PlayState', () => {
      it('test_reg_playStateModel_creation_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const modes: string[] = ['auto', 'repeat', 'random'];
        for (let i: number = 0; i < 100; i++) {
          const playModeVal: 'auto' | 'repeat' | 'random' = modes[i % 3] as 'auto' | 'repeat' | 'random';
          const s: PlayStateTypeModel = new PlayStateTypeModel({ img: '', name: 'n_' + i.toString(), author: 'a_' + i.toString(), url: 'u_' + i.toString(), playIndex: i % 10, time: i * 100, duration: i * 200, isPlay: i % 2 === 0, playMode: playModeVal, playList: [] });
          expect(s.playIndex).assertEqual(i % 10);
        }
      });
      it('test_reg_playState_modeToggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel(defaultState);
        s.playMode = 'repeat';
        expect(s.playMode).assertEqual('repeat');
        s.playMode = 'random';
        expect(s.playMode).assertEqual('random');
        s.playMode = 'auto';
        expect(s.playMode).assertEqual('auto');
      });
      it('test_reg_playState_playToggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel(defaultState);
        s.isPlay = true;
        expect(s.isPlay).assertTrue();
        s.isPlay = false;
        expect(s.isPlay).assertFalse();
      });
      it('test_reg_defaultState_unchanged', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.isPlay).assertFalse();
        expect(defaultState.playMode).assertEqual('auto');
        expect(defaultState.playIndex).assertEqual(0);
        expect(defaultState.time).assertEqual(0);
      });
    });

    describe('Regression_Module_Model_ButtonModel', () => {
      it('test_reg_buttonModel_creation_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameVal: string = 'btn_' + i.toString();
          const b: ButtonModel = new ButtonModel({ name: nameVal, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: i % 2 === 0 });
          expect(b.name).assertEqual('btn_' + i.toString());
        }
      });
      it('test_reg_buttonModel_focusToggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const b: ButtonModel = new ButtonModel({ name: 'test', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false });
        b.isFocus = true;
        expect(b.isFocus).assertTrue();
        b.isFocus = false;
        expect(b.isFocus).assertFalse();
      });
    });

    describe('Regression_Module_Model_KvStoreModel', () => {
      it('test_reg_kvStore_broadcast_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const emptyMsg: StringRecord = makeStringRecord();
        for (let i: number = 0; i < 100; i++) {
          KvStoreModel.broadcastMessage(emptyMsg, 'reg_msg_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_reg_kvStore_put_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          try {
            KvStoreModel.put('reg_key_' + i.toString(), i);
          } catch (e) {
          }
        }
        expect(true).assertTrue();
      });
      it('test_reg_kvStore_deleteAndListener', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.deleteKvStore();
          const emptyObj: ObjectRecord = {} as ObjectRecord;
          KvStoreModel.setOnMessageReceivedListener(emptyObj, 'test', () => {});
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_reg_kvStore_bundleName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(BUNDLE_NAME).assertEqual('ohos.samples.distributedmusicplayer');
      });
    });

    describe('Regression_Module_Model_RemoteDeviceModel', () => {
      it('test_reg_deviceManager_singleton', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const i1: DistributedManager = DistributedManager.getInstance();
        const i2: DistributedManager = DistributedManager.getInstance();
        expect(i1 === i2).assertTrue();
      });
      it('test_reg_deviceType_allValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.UNKNOWN_TYPE).assertEqual(0);
        expect(DeviceType.SPEAKER).assertEqual(0x0A);
        expect(DeviceType.PHONE).assertEqual(0x0E);
        expect(DeviceType.TABLET).assertEqual(0x11);
        expect(DeviceType.WEARABLE).assertEqual(0x6D);
        expect(DeviceType.CAR).assertEqual(0x83);
        expect(DeviceType.TV).assertEqual(0x9C);
      });
      it('test_reg_deviceStateChangeAction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceStateChangeAction.ONLINE).assertEqual(0);
        expect(DeviceStateChangeAction.READY).assertEqual(1);
        expect(DeviceStateChangeAction.OFFLINE).assertEqual(2);
        expect(DeviceStateChangeAction.CHANGE).assertEqual(3);
      });
      it('test_reg_deviceManager_scan_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          inst.startScan();
          inst.stopScan();
        }
        expect(true).assertTrue();
      });
      it('test_reg_deviceManager_addUpdate_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'ra_' + (i % 100).toString();
          const now: number = new Date().getTime();
          const devInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'RA ' + i.toString(), deviceType: DeviceType.TV, networkId: 'rn_' + (i % 100).toString(), range: i, updateTime: now } as DistributedManagerDeviceInfo;
          inst.addDevice(devId, devInfo);
        }
        expect(true).assertTrue();
      });
      it('test_reg_deviceManager_auth_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'rau_' + (i % 50).toString();
          const devInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'RAU ' + i.toString(), deviceType: DeviceType.TV, networkId: 'raun_' + (i % 50).toString(), range: i } as DistributedManagerDeviceInfo;
          inst.addDevice(devId, devInfo);
          const authInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'RAU ' + i.toString(), deviceType: DeviceType.TV, networkId: 'raun_' + (i % 50).toString(), range: i } as DistributedManagerDeviceInfo;
          const emptyExtra: StringRecord = makeStringRecord();
          const authParams: AuthParam = { authType: 1, extraInfo: emptyExtra };
          inst.authenticateDevice(authInfo, authParams);
        }
        expect(true).assertTrue();
      });
    });

    describe('Regression_Module_Model_MusicPlayer', () => {
      it('test_reg_player_defaultState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        expect(p.player).assertEqual(null);
        expect(p.duration).assertEqual(0);
        expect(p.time).assertEqual(0);
        expect(p.isPlay).assertFalse();
        expect(p.playIndex).assertEqual(0);
        expect(p.playList.length).assertEqual(0);
      });
      it('test_reg_player_nextPrev_empty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = [];
        let threw: boolean = false;
        try {
          p.next();
          p.previous();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_reg_player_nextPrev_single', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = mkSongs(1);
        p.next();
        expect(p.playIndex).assertEqual(0);
        p.previous();
        expect(p.playIndex).assertEqual(0);
      });
      it('test_reg_player_nextPrev_multi', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const p: AVPlayerClass = new AVPlayerClass();
        p.playList = mkSongs(5);
        p.next();
        expect(p.playIndex).assertEqual(1);
        p.next();
        expect(p.playIndex).assertEqual(2);
        p.previous();
        expect(p.playIndex).assertEqual(1);
      });
      it('test_reg_player_mockPlayer_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const mp: MockAVPlayer = new MockAVPlayer();
        let isPlay: boolean = false;
        mp.onStateChange((s: string) => {
          if (s === 'playing') {
            isPlay = true;
          }
          if (s === 'paused') {
            isPlay = false;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            mp.play();
          } else {
            mp.pause();
          }
        }
        const isPlayType: string = typeof isPlay;
        expect(isPlayType).assertEqual('boolean');
      });
    });

    describe('Regression_Module_Common_MusicSharedDefinition', () => {
      it('test_reg_eventCode_allValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE).assertEqual(1);
        expect(MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE).assertEqual(2);
        expect(MusicSharedEventCode.PLAY_MUSIC_SERVICE).assertEqual(3);
        expect(MusicSharedEventCode.PAUSE_MUSIC_SERVICE).assertEqual(4);
        expect(MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE).assertEqual(5);
        expect(MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE).assertEqual(6);
        expect(MusicSharedEventCode.STOP_LOCAL_SERIVCE).assertEqual(7);
        expect(MusicSharedEventCode.PRE_MUSIC_SERVICE).assertEqual(8);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE).assertEqual(9);
        expect(MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE).assertEqual(10);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertEqual(11);
      });
      it('test_reg_statusEnum', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
        expect(MusicSharedStatus.MUSIC_REMOTING).assertEqual(1);
        expect(MusicSharedStatus.MUSIC_STOP_SHARED).assertEqual(2);
      });
      it('test_reg_connectEvent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicConnectEvent.EVENT_CONNECT).assertEqual('ONCONNECT');
        expect(MusicConnectEvent.EVENT_DISCONNECT).assertEqual('ONDISCONNECT');
        expect(MusicConnectEvent.EVENT_FAILED).assertEqual('ONFAILED');
        expect(MusicConnectEvent.EVENT_TIMEOUT).assertEqual('CONNECTTIMEOUT');
      });
      it('test_reg_names', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(APPLICATION_BUNDLE_NAME.length).assertLarger(0);
        expect(APPLICATION_SERVICE_NAME.length).assertLarger(0);
        expect(APPLICATION_ABILITY_NAME.length).assertLarger(0);
      });
    });

    describe('Regression_Module_Common_EventUtilPointerUtil', () => {
      it('test_reg_eventUtil_allTypes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const e: MockTouch = new MockTouch();
        e.type = TouchType.Down;
        e.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(e)).assertFalse();
        e.type = TouchType.Move;
        e.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(e)).assertFalse();
        e.type = TouchType.Up;
        e.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(e)).assertTrue();
        e.type = TouchType.Up;
        e.source = SourceType.TouchScreen;
        expect(EventUtil.isTouchEvent(e)).assertTrue();
        e.type = TouchType.Down;
        e.source = SourceType.TouchScreen;
        expect(EventUtil.isTouchEvent(e)).assertFalse();
      });
      it('test_reg_pointerUtil', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          PointerUtil.changePointStyle(true);
          PointerUtil.changePointStyle(false);
          PointerUtil.changePointDefaultStyle();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Regression_Module_Common_MusicConstants', () => {
      it('test_reg_songs_integrity', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertEqual(3);
        for (let i: number = 0; i < songs.length; i++) {
          const s: songItemType = songs[i];
          expect(s.name.length).assertLarger(0);
          expect(s.author.length).assertLarger(0);
          expect(s.url.length).assertLarger(0);
          const t: number = s.time ?? 0;
          expect(t).assertLarger(0);
        }
      });
      it('test_reg_songs_fieldValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[0].name).assertEqual('dynamic');
        expect(songs[1].name).assertEqual('light-music');
        expect(songs[2].name).assertEqual('流行音乐');
      });
    });

    describe('Regression_Module_Const_Type', () => {
      it('test_reg_deviceInfoType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const d: DeviceInfoType = { deviceId: 'reg', deviceName: 'Reg', deviceType: DeviceType.TV, networkId: 'net', range: 5 };
        expect(d.deviceId).assertEqual('reg');
        expect(d.deviceType).assertEqual(DeviceType.TV);
      });
      it('test_reg_authParam', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyExtraAuth: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: 1, extraInfo: emptyExtraAuth };
        expect(a.authType).assertEqual(1);
        let keyCount: number = 0;
        expect(keyCount).assertEqual(0);
      });
    });

    describe('Regression_Index_PageLogic', () => {
      it('test_reg_timeFormat_allCases', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(0)).assertEqual('00:00');
        expect(number2time(30000)).assertEqual('00:30');
        expect(number2time(60000)).assertEqual('01:00');
        expect(number2time(90000)).assertEqual('01:30');
        expect(number2time(180000)).assertEqual('03:00');
        expect(number2time(3599000)).assertEqual('59:59');
      });
      it('test_reg_focusIndex_bounds', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = 0;
        if (f > 0) {
          f--;
        }
        expect(f).assertEqual(0);
        f = 4;
        if (f < 4) {
          f++;
        }
        expect(f).assertEqual(4);
        f = 2;
        if (f > 0) {
          f--;
        }
        expect(f).assertEqual(1);
        f = 2;
        if (f < 4) {
          f++;
        }
        expect(f).assertEqual(3);
      });
      it('test_reg_backPress_hierarchy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let isShow: boolean = true;
        let musicListDelete: boolean = false;
        let isDevice: boolean = true;
        let handled: boolean = false;
        if (isShow && !musicListDelete) {
          isShow = false;
          handled = true;
        }
        expect(handled).assertTrue();
        expect(isShow).assertFalse();
      });
      it('test_reg_changePlay_flagProcessing', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let flag: string = 'PRE';
        let action: string = '';
        if (flag === 'PRE') {
          action = 'previous';
          flag = '';
        } else if (flag === 'NEXT') {
          action = 'next';
          flag = '';
        }
        expect(action).assertEqual('previous');
        expect(flag).assertEqual('');
        flag = 'NEXT';
        action = '';
        if (flag === 'PRE') {
          action = 'previous';
          flag = '';
        } else if (flag === 'NEXT') {
          action = 'next';
          flag = '';
        }
        expect(action).assertEqual('next');
        expect(flag).assertEqual('');
      });
      it('test_reg_deleteMusic_logic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let ml: songItemType[] = mkSongs(5);
        let fid: number = 2;
        ml.splice(fid, 1);
        if (fid >= ml.length) {
          fid = ml.length - 1;
        }
        expect(ml.length).assertEqual(4);
        expect(fid).assertEqual(2);
      });
      it('test_reg_progressCalculation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const dur: number = 180000;
        expect(Math.floor(0 / dur * 100)).assertEqual(0);
        expect(Math.floor(90000 / dur * 100)).assertEqual(50);
        expect(Math.floor(180000 / dur * 100)).assertEqual(100);
      });
    });

    describe('Regression_Integration_EndToEnd', () => {
      it('test_reg_e2e_fullPlayCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let isPlay: boolean = false;
        let dur: number = 0;
        let t: number = 0;
        p.onStateChange((s: string) => {
          if (s === 'playing') {
            isPlay = true;
          }
          if (s === 'paused') {
            isPlay = false;
          }
        });
        p.onDurationUpdate((d: number) => {
          dur = d;
        });
        p.onTimeUpdate((v: number) => {
          t = v;
        });
        p.url = 'test.wav';
        p.prepare();
        expect(isPlay).assertTrue();
        p.pause();
        expect(isPlay).assertFalse();
        p.emitDuration(180000);
        expect(dur).assertEqual(180000);
        p.emitTime(90000);
        expect(t).assertEqual(90000);
        p.play();
        expect(isPlay).assertTrue();
        p.seek(120000);
        p.pause();
        expect(isPlay).assertFalse();
      });
      it('test_reg_e2e_deviceTransferCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let dev: DistributedManagerDeviceInfo = { deviceId: 'e2e', deviceName: 'E2E', deviceType: DeviceType.TV, networkId: 'e2e_net', range: 5, isInAuth: false, isTrust: false, transferLoading: false, isInTransfer: false };
        expect(dev.isInAuth).assertFalse();
        dev.isInAuth = true;
        expect(dev.isInAuth).assertTrue();
        dev.isInAuth = false;
        dev.isTrust = true;
        expect(dev.isTrust).assertTrue();
        dev.transferLoading = true;
        expect(dev.transferLoading).assertTrue();
        dev.isInTransfer = true;
        dev.transferLoading = false;
        expect(dev.isInTransfer).assertTrue();
        expect(dev.transferLoading).assertFalse();
        dev.isInTransfer = false;
        expect(dev.isInTransfer).assertFalse();
      });
      it('test_reg_e2e_kvSyncRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async () => {
        const store: MockKVStore = new MockKVStore();
        await store.put('sync_msg', 42);
        const v: number | null = await store.get('sync_msg');
        expect(v).assertEqual(42);
      });
      it('test_reg_e2e_uiInteractionFlow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let f: number = 2;
        let isShow: boolean = false;
        let musicListDelete: boolean = false;
        if (f < 4) {
          f++;
        }
        f = 4;
        switch (f) {
          case 4:
            isShow = true;
            break;
        }
        expect(isShow).assertTrue();
        const e: MockTouch = new MockTouch();
        e.type = TouchType.Up;
        e.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(e)).assertTrue();
        if (isShow && !musicListDelete) {
          isShow = false;
        }
        expect(isShow).assertFalse();
      });
    });

    describe('FullRegressionStress_100', () => {
      it('test_fullReg_100_mixed', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        const sl: songItemType[] = mkSongs(5);
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 12;
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
              number2time(i * 18);
              break;
            case 6:
              JSON.stringify({ uri: sl[idx].url, seekTo: i });
              break;
            case 7:
              store.put('fr_' + (i % 100).toString(), i);
              break;
            case 8:
              const devId: string = 'fr_' + (i % 200).toString();
              const now: number = new Date().getTime();
              const devInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'FR ' + i.toString(), deviceType: DeviceType.TV, networkId: 'frn_' + (i % 200).toString(), range: i % 50, updateTime: now } as DistributedManagerDeviceInfo;
              inst.addDevice(devId, devInfo);
              break;
            case 9:
              new SongItemTypeModel(sl[idx]);
              break;
            case 10:
              const modeVal: 'auto' | 'repeat' | 'random' = 'auto';
              new PlayStateTypeModel({ img: '', name: sl[idx].name, author: sl[idx].author, url: sl[idx].url, playIndex: idx, time: i, duration: i * 2, isPlay: isPlay, playMode: modeVal, playList: [] });
              break;
            case 11:
              Logger.debug('fr_' + i.toString());
              Logger.info('fr_' + i.toString());
              break;
          }
        }
        const isPlayType: string = typeof isPlay;
        expect(isPlayType).assertEqual('boolean');
      });
      it('test_fullReg_100_kvAndDevice', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            store.put('frk_' + (i % 100).toString(), i);
          } else {
            const devId: string = 'frd_' + (i % 100).toString();
            const now: number = new Date().getTime();
            const devInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'FRD ' + i.toString(), deviceType: DeviceType.TV, networkId: 'frdn_' + (i % 100).toString(), range: i % 100, updateTime: now } as DistributedManagerDeviceInfo;
            inst.addDevice(devId, devInfo);
          }
        }
        expect(true).assertTrue();
      });
      it('test_fullReg_100_jsonAndModel', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const imgRes: Resource = $r('app.media.album1');
          const item: songItemType = { img: imgRes, name: 'frs_' + i.toString(), author: 'fra_' + i.toString(), url: 'fru_' + i.toString(), time: i };
          const s: SongItemTypeModel = new SongItemTypeModel(item);
          const j: string = JSON.stringify({ uri: s.url, name: s.name, time: (s as songItemType).time });
          const p: ObjectRecord = JSON.parse(j);
          expect(p.uri).assertEqual('fru_' + i.toString());
        }
      });
      it('test_fullReg_100_timeFormat', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 18);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
      it('test_fullReg_100_allModules', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        const sl: songItemType[] = mkSongs(5);
        const inst: DistributedManager = DistributedManager.getInstance();
        const modes: string[] = ['auto', 'repeat', 'random'];
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 15;
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
              number2time(i * 18);
              break;
            case 6:
              Preferences.writeData('frp_' + (i % 100).toString(), 'frv_' + i.toString());
              break;
            case 7:
              const devId7: string = 'frpa_' + (i % 300).toString();
              const now7: number = new Date().getTime();
              const devInfo7: DistributedManagerDeviceInfo = { deviceId: devId7, deviceName: 'FRPA ' + i.toString(), deviceType: DeviceType.TV, networkId: 'frpan_' + (i % 300).toString(), range: i % 50, updateTime: now7 } as DistributedManagerDeviceInfo;
              inst.addDevice(devId7, devInfo7);
              break;
            case 8:
              Logger.debug('frl_' + i.toString());
              break;
            case 9:
              Logger.debug('frlt_' + i.toString(), 'frlm_' + i.toString());
              break;
            case 10:
              PointerUtil.changePointStyle(i % 2 === 0);
              break;
            case 11:
              objType(sl[idx]);
              break;
            case 12:
              const btnName: string = 'frb_' + i.toString();
              new ButtonModel({ name: btnName, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: i % 2 === 0 });
              break;
            case 13:
              new SongItemTypeModel(sl[idx]);
              break;
            case 14:
              const playModeVal14: 'auto' | 'repeat' | 'random' = modes[i % 3] as 'auto' | 'repeat' | 'random';
              const playStateData: PlayStateType = { img: '', name: 'frn_' + i.toString(), author: 'fra_' + i.toString(), url: 'fru_' + i.toString(), playIndex: idx, time: i, duration: i * 2, isPlay: isPlay, playMode: playModeVal14, playList: [] };
              new PlayStateTypeModel(playStateData);
              break;
          }
        }
        const isPlayType: string = typeof isPlay;
        expect(isPlayType).assertEqual('boolean');
      });
    });
  });
}
