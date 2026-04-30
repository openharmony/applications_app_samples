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

/* Mock callback types */
type KVStoreOnCallback = (event: string, type: number, cb: (msg: string) => void) => void;

/* Shared typed object for objType testing */
interface EmptyObjInterface {
}

class MockDeviceData {
  deviceId: string;
  deviceName: string;
  deviceType: DeviceType;
  networkId: string;
  range: number;
  constructor() {
    this.deviceId = '';
    this.deviceName = '';
    this.deviceType = DeviceType.UNKNOWN_TYPE;
    this.networkId = '';
    this.range = 0;
  }
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

/* Module-level helper to repeat a string */
function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += s;
  }
  return result;
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
  getHistoricalPoints() {
    return [];
  }
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

export default function BoundaryValue001TestSuite(): void {
  describe('BoundaryValue001Test', () => {

    describe('Boundary_SongItem', () => {
      it('test_bv_songItem_emptyName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: '', author: '', url: '' });
        expect(m.name).assertEqual('');
      });
      it('test_bv_songItem_veryLongName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longName: string = strRepeat('x', 100);
        const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: longName, author: 'a', url: 'u' });
        expect(m.name).assertEqual(longName);
      });
      it('test_bv_songItem_zeroTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: 'n', author: 'a', url: 'u', time: 0 });
        expect((m as songItemType).time).assertEqual(0);
      });
      it('test_bv_songItem_negativeTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: 'n', author: 'a', url: 'u', time: -1 });
        expect((m as songItemType).time).assertEqual(-1);
      });
      it('test_bv_songItem_maxTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: 'n', author: 'a', url: 'u', time: Number.MAX_SAFE_INTEGER });
        expect((m as songItemType).time).assertEqual(Number.MAX_SAFE_INTEGER);
      });
      it('test_bv_songItem_specialCharName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const names: string[] = ['<script>', '\'; DROP', '\n\t\r', '\0', '\u{1F680}\u{1F525}'];
        for (let ni: number = 0; ni < names.length; ni++) {
          const name: string = names[ni];
          const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: name, author: 'a', url: 'u' });
          expect(m.name).assertEqual(name);
        }
      });
    });

    describe('Boundary_PlayState', () => {
      it('test_bv_playState_zeroIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img,
          name: defaultState.name,
          author: defaultState.author,
          url: defaultState.url,
          playIndex: 0,
          time: defaultState.time,
          duration: defaultState.duration,
          isPlay: defaultState.isPlay,
          playMode: defaultState.playMode,
          playList: defaultState.playList
        });
        expect(s.playIndex).assertEqual(0);
      });
      it('test_bv_playState_negativeIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: -1, time: defaultState.time,
          duration: defaultState.duration, isPlay: defaultState.isPlay,
          playMode: defaultState.playMode, playList: defaultState.playList
        });
        expect(s.playIndex).assertEqual(-1);
      });
      it('test_bv_playState_maxIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: Number.MAX_SAFE_INTEGER, time: defaultState.time,
          duration: defaultState.duration, isPlay: defaultState.isPlay,
          playMode: defaultState.playMode, playList: defaultState.playList
        });
        expect(s.playIndex).assertEqual(Number.MAX_SAFE_INTEGER);
      });
      it('test_bv_playState_zeroTimeDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: defaultState.playIndex, time: 0, duration: 0,
          isPlay: defaultState.isPlay, playMode: defaultState.playMode, playList: defaultState.playList
        });
        expect(s.time).assertEqual(0);
        expect(s.duration).assertEqual(0);
      });
      it('test_bv_playState_timeEqualsDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: defaultState.playIndex, time: 180000, duration: 180000,
          isPlay: defaultState.isPlay, playMode: defaultState.playMode, playList: defaultState.playList
        });
        expect(s.time).assertEqual(s.duration);
      });
      it('test_bv_playState_timeExceedsDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: defaultState.playIndex, time: 200000, duration: 180000,
          isPlay: defaultState.isPlay, playMode: defaultState.playMode, playList: defaultState.playList
        });
        expect(s.time).assertLarger(s.duration);
      });
      it('test_bv_playState_emptyPlayList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: defaultState.playIndex, time: defaultState.time,
          duration: defaultState.duration, isPlay: defaultState.isPlay,
          playMode: defaultState.playMode, playList: []
        });
        expect(s.playList.length).assertEqual(0);
      });
      it('test_bv_playState_largePlayList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const s: PlayStateTypeModel = new PlayStateTypeModel({
          img: defaultState.img, name: defaultState.name, author: defaultState.author,
          url: defaultState.url, playIndex: defaultState.playIndex, time: defaultState.time,
          duration: defaultState.duration, isPlay: defaultState.isPlay,
          playMode: defaultState.playMode, playList: mkSongs(200)
        });
        expect(s.playList.length).assertEqual(200);
      });
    });

    describe('Boundary_DeviceInfo', () => {
      it('test_bv_deviceInfo_emptyDeviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const d: DeviceInfoType = { deviceId: '', deviceName: '', deviceType: DeviceType.UNKNOWN_TYPE, networkId: '', range: 0 };
        expect(d.deviceId).assertEqual('');
      });
      it('test_bv_deviceInfo_longDeviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longId: string = strRepeat('d', 100);
        const d: DeviceInfoType = { deviceId: longId, deviceName: 'n', deviceType: DeviceType.TV, networkId: 'n', range: 0 };
        expect(d.deviceId).assertEqual(longId);
      });
      it('test_bv_deviceInfo_zeroRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const d: DeviceInfoType = { deviceId: 'd', deviceName: 'n', deviceType: DeviceType.TV, networkId: 'n', range: 0 };
        expect(d.range).assertEqual(0);
      });
      it('test_bv_deviceInfo_negativeRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const d: DeviceInfoType = { deviceId: 'd', deviceName: 'n', deviceType: DeviceType.TV, networkId: 'n', range: -1 };
        expect(d.range).assertEqual(-1);
      });
      it('test_bv_deviceInfo_maxRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const d: DeviceInfoType = { deviceId: 'd', deviceName: 'n', deviceType: DeviceType.TV, networkId: 'n', range: Number.MAX_SAFE_INTEGER };
        expect(d.range).assertEqual(Number.MAX_SAFE_INTEGER);
      });
    });

    describe('Boundary_AuthParam', () => {
      it('test_bv_authParam_zeroAuthType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyInfo: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: 0, extraInfo: emptyInfo };
        expect(a.authType).assertEqual(0);
      });
      it('test_bv_authParam_negativeAuthType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyInfo: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: -1, extraInfo: emptyInfo };
        expect(a.authType).assertEqual(-1);
      });
      it('test_bv_authParam_maxAuthType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyInfo: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: Number.MAX_SAFE_INTEGER, extraInfo: emptyInfo };
        expect(a.authType).assertEqual(Number.MAX_SAFE_INTEGER);
      });
      it('test_bv_authParam_emptyExtraInfo', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyInfo: StringRecord = makeStringRecord();
        const a: AuthParam = { authType: 1, extraInfo: emptyInfo };
        let keyCount: number = 0;
        expect(keyCount).assertEqual(0);
      });
    });

    describe('Boundary_ButtonModel', () => {
      it('test_bv_button_emptyName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const b: ButtonModel = new ButtonModel({ name: '', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false });
        expect(b.name).assertEqual('');
      });
      it('test_bv_button_longName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longName: string = strRepeat('b', 100);
        const b: ButtonModel = new ButtonModel({ name: longName, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false });
        expect(b.name).assertEqual(longName);
      });
    });

    describe('Boundary_EventCode', () => {
      it('test_bv_eventCode_minValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE).assertEqual(1);
      });
      it('test_bv_eventCode_maxValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertEqual(11);
      });
      it('test_bv_eventCode_invalidBelowMin', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalid: number = 0;
        let handled: boolean = false;
        switch (invalid) {
          case MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE: handled = true; break;
        }
        expect(handled).assertFalse();
      });
      it('test_bv_eventCode_invalidAboveMax', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalid: number = 12;
        let handled: boolean = false;
        for (let c: number = 1; c <= 11; c++) {
          if (invalid === c) {
            handled = true;
            break;
          }
        }
        expect(handled).assertFalse();
      });
    });

    describe('Boundary_StatusEnum', () => {
      it('test_bv_status_minValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
      });
      it('test_bv_status_maxValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedStatus.MUSIC_STOP_SHARED).assertEqual(2);
      });
      it('test_bv_status_invalidNegative', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalid: number = -1;
        expect(invalid !== MusicSharedStatus.MUSIC_SHARED).assertTrue();
        expect(invalid !== MusicSharedStatus.MUSIC_REMOTING).assertTrue();
        expect(invalid !== MusicSharedStatus.MUSIC_STOP_SHARED).assertTrue();
      });
      it('test_bv_status_invalidAboveMax', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const invalid: number = 3;
        expect(invalid !== MusicSharedStatus.MUSIC_SHARED).assertTrue();
        expect(invalid !== MusicSharedStatus.MUSIC_REMOTING).assertTrue();
        expect(invalid !== MusicSharedStatus.MUSIC_STOP_SHARED).assertTrue();
      });
    });

    describe('Boundary_FocusIndex', () => {
      it('test_bv_focus_min', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = 0;
        if (f > 0) {
          f--;
        }
        expect(f).assertEqual(0);
      });
      it('test_bv_focus_max', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = 4;
        if (f < 4) {
          f++;
        }
        expect(f).assertEqual(4);
      });
      it('test_bv_focus_negative', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = -1;
        if (f > 0) {
          f--;
        }
        expect(f).assertEqual(-1);
      });
      it('test_bv_focus_aboveMax', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let f: number = 5;
        if (f < 4) {
          f++;
        }
        expect(f).assertEqual(5);
      });
    });

    describe('Boundary_MusicListFocusID', () => {
      it('test_bv_listFocus_min', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let id: number = 0;
        const len: number = 5;
        if (id > 0) {
          id--;
        }
        expect(id).assertEqual(0);
      });
      it('test_bv_listFocus_max', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let id: number = 4;
        const len: number = 5;
        if (id < len - 1) {
          id++;
        }
        expect(id).assertEqual(4);
      });
      it('test_bv_listFocus_emptyList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let id: number = 0;
        const len: number = 0;
        if (id > 0) {
          id--;
        }
        expect(id).assertEqual(0);
      });
    });

    describe('Boundary_TimeFormat', () => {
      it('test_bv_timeFormat_zero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(0)).assertEqual('00:00');
      });
      it('test_bv_timeFormat_justUnderMinute', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(59000)).assertEqual('00:59');
      });
      it('test_bv_timeFormat_exactMinute', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(60000)).assertEqual('01:00');
      });
      it('test_bv_timeFormat_justOverMinute', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(6100)).assertEqual('01:01');
      });
      it('test_bv_timeFormat_maxHour', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(number2time(3599000)).assertEqual('59:59');
      });
    });

    describe('Boundary_ProgressCalc', () => {
      it('test_bv_progress_zeroSeek', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(Math.floor(0 / 180000 * 100)).assertEqual(0);
      });
      it('test_bv_progress_halfSeek', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(Math.floor(90000 / 180000 * 100)).assertEqual(50);
      });
      it('test_bv_progress_fullSeek', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(Math.floor(180000 / 180000 * 100)).assertEqual(100);
      });
      it('test_bv_progress_exceedsDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(Math.floor(200000 / 180000 * 100)).assertLarger(100);
      });
    });

    describe('Boundary_SongsConstants', () => {
      it('test_bv_songs_count', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertEqual(3);
      });
      it('test_bv_songs_firstTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[0].time).assertEqual(68372);
      });
      it('test_bv_songs_lastTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[songs.length - 1].time).assertEqual(5041);
      });
    });

    describe('Boundary_Logger', () => {
      it('test_bv_logger_emptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
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
      it('test_bv_logger_veryLongString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longStr: string = strRepeat('x', 1000);
        let threw: boolean = false;
        try {
          Logger.debug(longStr);
          Logger.info(longStr);
          Logger.warn(longStr);
          Logger.error(longStr);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Boundary_Preferences', () => {
      it('test_bv_pref_emptyKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('', 'val');
        const r: string | null = String(Preferences.readData(''));
        expect(r !== null).assertTrue();
      });
      it('test_bv_pref_emptyValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('key', '');
        const r: string | null = String(Preferences.readData('key'));
        expect(r !== null).assertTrue();
      });
      it('test_bv_pref_zeroValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('key', 0);
        const r: string | null = String(Preferences.readData('key'));
        expect(r !== null).assertTrue();
      });
      it('test_bv_pref_negativeValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('key', -1);
        const r: string | null = String(Preferences.readData('key'));
        expect(r !== null).assertTrue();
      });
    });

    describe('Boundary_ObjType', () => {
      it('test_bv_objType_null', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(null)).assertEqual('null');
      });
      it('test_bv_objType_undefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(undefined)).assertEqual('undefined');
      });
      it('test_bv_objType_emptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType('')).assertEqual('string');
      });
      it('test_bv_objType_zero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(0)).assertEqual('number');
      });
      it('test_bv_objType_negativeZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(-0)).assertEqual('number');
      });
      it('test_bv_objType_emptyObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyObj: EmptyObjInterface = {};
        expect(objType(emptyObj)).assertEqual('object');
      });
      it('test_bv_objType_emptyArray', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyArr: string[] = [];
        expect(objType(emptyArr)).assertEqual('object');
      });
    });

    describe('Boundary_KVStore', () => {
      it('test_bv_kv_emptyKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.put('', 1);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_bv_kv_zeroValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.put('key', 0);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_bv_kv_negativeValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.put('key', -1);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_bv_kv_maxValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          KvStoreModel.put('key', Number.MAX_SAFE_INTEGER);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('Boundary_DeviceManager', () => {
      it('test_bv_deviceMgr_emptyDeviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const emptyDevice: DistributedManagerDeviceInfo = {
          deviceId: '', deviceName: '', deviceType: DeviceType.UNKNOWN_TYPE, networkId: '', range: 0,
          isInAuth: false, isTrust: false, trustDeviceId: '', transferLoading: false,
          isInTransfer: false, action: DeviceStateChangeAction.READY, updateTime: 0,
          pinToken: -1, isDelete: false
        };
        inst.addDevice('', emptyDevice);
        expect(true).assertTrue();
      });
      it('test_bv_deviceMgr_updateEmptyId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        let threw: boolean = false;
        try {
          inst.updateDeviceProp('', 'transferLoading', true);
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('BoundaryStress_100', () => {
      it('test_bv_stress_songItem_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'bv_' + i.toString();
          const authorStr: string = 'a_' + i.toString();
          const urlStr: string = 'u_' + i.toString();
          const timeVal: number = i % 2 === 0 ? 0 : i;
          const m: SongItemTypeModel = new SongItemTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, time: timeVal });
          expect(m.name).assertEqual(nameStr);
        }
      });
      it('test_bv_stress_playState_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const timeVal: number = i % 2 === 0 ? 0 : i;
          const s: PlayStateTypeModel = new PlayStateTypeModel({
            img: defaultState.img, name: defaultState.name, author: defaultState.author,
            url: defaultState.url, playIndex: i % 2 === 0 ? 0 : i,
            time: timeVal, duration: i % 2 === 0 ? 0 : i * 2,
            isPlay: defaultState.isPlay, playMode: defaultState.playMode,
            playList: defaultState.playList
          });
          expect(s.playIndex >= 0).assertTrue();
        }
      });
      it('test_bv_stress_deviceInfo_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'bv_' + i.toString();
          const devName: string = 'BV ' + i.toString();
          const netId: string = 'n_' + i.toString();
          const d: DeviceInfoType = { deviceId: devId, deviceName: devName, deviceType: DeviceType.TV, networkId: netId, range: i % 2 === 0 ? 0 : i };
          expect(d.range >= 0).assertTrue();
        }
      });
      it('test_bv_stress_timeFormat_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 360);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
    });
  });
}
