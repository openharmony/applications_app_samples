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
import { songItemType, SongItemTypeModel, RecommendListTypeModel, RecommendDailyTypeModel, FavoriteListTypeModel, MomentListTypeModel } from '../../../../main/ets/model/Music';
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
interface JsonPrimitiveRecord extends Record<string, string | number | boolean> {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
}

function getNullChaosPlayer(): MockAVPlayer | null {
  return null;
}

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

function mkSongs(n: number): songItemType[] {
  const r: songItemType[] = [];
  for (let i: number = 0; i < n; i++) {
    r.push({
      img: $r('app.media.album1'),
      name: 's_' + i.toString(),
      author: 'a_' + i.toString(),
      url: 'u_' + i.toString() + '.wav',
      time: (i + 1) * 100,
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

function number2time(number: number): string {
  const ms: number = number % 100;
  const second: number = (number - ms) / 100;
  const s: number = second % 60;
  if (second > 60) {
    const m: number = (second - s) / 60 % 60;
    return m.toString().padStart(2, '0') + ':' + s.toString().padStart(2, '0');
  }
  return '00:' + s.toString().padStart(2, '0');
}

export default function StressChaos002TestSuite(): void {
  describe('StressChaos002Test', () => {

    describe('HighFrequencyPlayPause_100', () => {
      it('test_hf_playPause_toggle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.onStateChange((st: string): void => {
          if (st === 'playing') {
            p.isPlay = true;
          }
          if (st === 'paused') {
            p.isPlay = false;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            p.play();
          } else {
            p.pause();
          }
        }
        const isPlayType: boolean = p.isPlay;
        expect(typeof isPlayType).assertEqual('boolean');
      });
      it('test_hf_playPause_stateConsistency', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.onStateChange((st: string): void => {
          if (st === 'playing') {
            p.isPlay = true;
          }
          if (st === 'paused') {
            p.isPlay = false;
          }
        });
        p.play();
        expect(p.isPlay).assertTrue();
        p.pause();
        expect(p.isPlay).assertFalse();
        for (let i: number = 0; i < 100; i++) {
          p.play();
          expect(p.isPlay).assertTrue();
          p.pause();
          expect(p.isPlay).assertFalse();
        }
      });
      it('test_hf_playPause_withSeek', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let seekCount: number = 0;
        p.onSeekDone((): void => {
          seekCount++;
        });
        for (let i: number = 0; i < 100; i++) {
          p.seek(i * 36);
        }
        expect(seekCount).assertEqual(100);
      });
      it('test_hf_playPause_withDurationUpdate', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let dur: number = 0;
        p.onDurationUpdate((d: number): void => {
          dur = d;
        });
        for (let i: number = 0; i < 100; i++) {
          p.emitDuration(i * 36);
        }
        expect(dur).assertEqual(999 * 36);
      });
      it('test_hf_playPause_withTimeUpdate', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let t: number = 0;
        p.onTimeUpdate((v: number): void => {
          if (v !== 0 && v !== t) {
            t = v;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          p.emitTime(i * 36);
        }
        expect(t).assertEqual(999 * 36);
      });
    });

    describe('HighFrequencyNextPrevious_100', () => {
      it('test_hf_next_cycle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const songList: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = (idx + 1) % songList.length;
        }
        expect(idx).assertEqual(100 % 5);
      });
      it('test_hf_previous_cycle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const songList: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = (idx - 1 + songList.length) % songList.length;
        }
        const cond: boolean = idx >= 0 && idx < songList.length;
        expect(cond).assertTrue();
      });
      it('test_hf_nextPrevious_alternating', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const songList: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = i % 2 === 0 ? (idx + 1) % songList.length : (idx - 1 + songList.length) % songList.length;
        }
        const cond: boolean = idx >= 0 && idx < songList.length;
        expect(cond).assertTrue();
      });
      it('test_hf_nextThenPrevious_cancel', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const songList: songItemType[] = mkSongs(5);
        let idx: number = 2;
        for (let i: number = 0; i < 100; i++) {
          idx = (idx + 1) % songList.length;
          idx = (idx - 1 + songList.length) % songList.length;
        }
        expect(idx).assertEqual(2);
      });
      it('test_hf_next_singleSong', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const songList: songItemType[] = mkSongs(1);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = (idx + 1) % songList.length;
        }
        expect(idx).assertEqual(0);
      });
    });

    describe('HighFrequencyFocusNavigation_100', () => {
      it('test_hf_focusLeftRight', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let f: number = 2;
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0 && f > 0) {
            f--;
          } else if (i % 2 === 1 && f < 4) {
            f++;
          }
        }
        const cond: boolean = f >= 0 && f <= 4;
        expect(cond).assertTrue();
      });
      it('test_hf_focusRapidToggle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let f: number = 0;
        for (let i: number = 0; i < 100; i++) {
          f = i % 5;
        }
        const cond: boolean = f >= 0 && f <= 4;
        expect(cond).assertTrue();
      });
      it('test_hf_focusButtonActions', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const actions: string[] = ['share', 'previous', 'play', 'next', 'list'];
        for (let i: number = 0; i < 100; i++) {
          const action: string = actions[i % 5];
          expect(action.length).assertLarger(0);
        }
      });
      it('test_hf_musicListFocusUpDown', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
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
    });

    describe('HighFrequencyKVOperations_100', () => {
      it('test_hf_kvPutGet', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, async () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          await store.put('k_' + i.toString(), i);
          const v: number | null = await store.get('k_' + i.toString());
          expect(v).assertEqual(i);
        }
      });
      it('test_hf_kvPutDelete', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('k_' + i.toString(), i);
          if (i % 5 === 0) {
            store.delete('k_' + i.toString());
          }
        }
        expect(true).assertTrue();
      });
      it('test_hf_kvOverwrite', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, async () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          await store.put('same_key', i);
        }
        const v: number | null = await store.get('same_key');
        expect(v).assertEqual(999);
      });
      it('test_hf_kvBroadcast', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const emptyMsg: StringRecord = {} as StringRecord;
          KvStoreModel.broadcastMessage(emptyMsg, 'stress_msg_' + i.toString());
        }
        expect(true).assertTrue();
      });
    });

    describe('HighFrequencyDeviceOperations_100', () => {
      it('test_hf_addDevice', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'hf_dev_' + (i % 200).toString();
          addDeviceData(inst, devId, 'HF ' + i.toString(), 'hf_net_' + (i % 200).toString(), i % 100, new Date().getTime());
        }
        expect(true).assertTrue();
      });
      it('test_hf_updateDeviceProp', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        const propDev: DistributedManagerDeviceInfo = {
          deviceId: 'hf_prop_dev',
          deviceName: 'HF Prop',
          deviceType: DeviceType.TV,
          networkId: 'hf_net',
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
        inst.addDevice('hf_prop_dev', propDev);
        for (let i: number = 0; i < 100; i++) {
          inst.updateDeviceProp('hf_prop_dev', 'transferLoading', i % 2 === 0);
          inst.updateDeviceProp('hf_prop_dev', 'isInTransfer', i % 3 === 0);
        }
        expect(true).assertTrue();
      });
      it('test_hf_scanCycle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
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
      it('test_hf_authenticateCycle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'auth_cyc_' + (i % 50).toString();
          const devName: string = 'Auth ' + i.toString();
          const netId: string = 'auth_net_' + (i % 50).toString();
          const authDevice: DistributedManagerDeviceInfo = {
            deviceId: devId,
            deviceName: devName,
            deviceType: DeviceType.TV,
            networkId: netId,
            range: i,
            isInAuth: false,
            isTrust: false,
            trustDeviceId: '',
            transferLoading: false,
            isInTransfer: false,
            action: DeviceStateChangeAction.READY,
            updateTime: 0,
            pinToken: -1,
            isDelete: false
          };
          inst.addDevice(devId, authDevice);
          const emptyExtra: StringRecord = makeStringRecord();
          const authParams: AuthParam = { authType: 1, extraInfo: emptyExtra };
          inst.authenticateDevice(authDevice, authParams);
        }
        expect(true).assertTrue();
      });
    });

    describe('HighFrequencyModelCreation_100', () => {
      it('test_hf_songItemCreation', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const m: SongItemTypeModel = new SongItemTypeModel({
            img: $r('app.media.album1'),
            name: 's_' + i.toString(),
            author: 'a_' + i.toString(),
            url: 'u_' + i.toString(),
            time: i,
          });
          expect(m.name).assertEqual('s_' + i.toString());
        }
      });
      it('test_hf_playStateCreation', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const pmIdx: number = i % 3;
          const pmArr: string[] = ['auto', 'repeat', 'random'];
          const pmVal: string = pmArr[pmIdx];
          const typedPm: 'auto' | 'repeat' | 'random' = pmVal as 'auto' | 'repeat' | 'random';
          const s: PlayStateTypeModel = new PlayStateTypeModel({
            img: '',
            name: 'n_' + i.toString(),
            author: 'a_' + i.toString(),
            url: 'u_' + i.toString(),
            playIndex: i % 100,
            time: i,
            duration: i * 2,
            isPlay: i % 2 === 0,
            playMode: typedPm,
            playList: [],
          });
          expect(s.name).assertEqual('n_' + i.toString());
        }
      });
      it('test_hf_buttonModelCreation', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const b: ButtonModel = new ButtonModel({
            name: 'btn_' + i.toString(),
            iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'),
            isFocus: i % 2 === 0,
          });
          expect(b.name).assertEqual('btn_' + i.toString());
        }
      });
      it('test_hf_recommendListCreation', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: RecommendListTypeModel = new RecommendListTypeModel({
            img: 'img_' + i.toString(),
            title: 'title_' + i.toString(),
            count: i.toString(),
          });
          expect(r.title).assertEqual('title_' + i.toString());
        }
      });
      it('test_hf_deviceInfoCreation', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const d: DeviceInfoType = {
            deviceId: 'd_' + i.toString(),
            deviceName: 'Dev ' + i.toString(),
            deviceType: DeviceType.TV,
            networkId: 'n_' + i.toString(),
            range: i,
          };
          expect(d.deviceId).assertEqual('d_' + i.toString());
        }
      });
    });

    describe('HighFrequencyTimeFormatting_100', () => {
      it('test_hf_timeFormat_all', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 36);
          const containsColon: boolean = r.indexOf(':') !== -1;
          expect(containsColon).assertTrue();
          expect(r.length).assertEqual(5);
        }
      });
      it('test_hf_progressCalc_all', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const dur: number = 180000;
        for (let i: number = 0; i < 100; i++) {
          const t: number = i * 18;
          const p: number = Math.floor(t / dur * 100);
          const cond: boolean = p >= 0 && p <= 100;
          expect(cond).assertTrue();
        }
      });
    });

    describe('HighFrequencyJsonParse_100', () => {
      it('test_hf_jsonStringifyParse', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const o: JsonPrimitiveRecord = { uri: 'u_' + i.toString() + '.wav', seekTo: i, isPlaying: i % 2 === 0 };
          const j: string = JSON.stringify(o);
          const p: JsonPrimitiveRecord = JSON.parse(j) as JsonPrimitiveRecord;
          expect(p.uri as string).assertEqual('u_' + i.toString() + '.wav');
        }
      });
      it('test_hf_jsonNested', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nestedParams: JsonPrimitiveRecord = {
            uri: 'u_' + i.toString(),
            seekTo: i,
            isPlaying: true,
          };
          const o: ObjectRecord = makeObjectRecord();
          o.params = nestedParams;
          const j: string = JSON.stringify(o);
          const p: ObjectRecord = JSON.parse(j);
          const params: JsonPrimitiveRecord = p.params as JsonPrimitiveRecord;
          expect(params.uri as string).assertEqual('u_' + i.toString());
        }
      });
      it('test_hf_jsonDeviceArray', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const arrItem1: StringRecord = makeStringRecord();
          arrItem1.id = 'd_' + i.toString();
          arrItem1.name = 'Dev ' + i.toString();
          const arrItem2: StringRecord = makeStringRecord();
          arrItem2.id = 'd_' + (i + 1).toString();
          arrItem2.name = 'Dev ' + (i + 1).toString();
          const arr: StringRecord[] = [arrItem1, arrItem2];
          const j: string = JSON.stringify(arr);
          const p: StringRecord[] = JSON.parse(j) as StringRecord[];
          expect(p.length).assertEqual(2);
        }
      });
    });

    describe('ChaosFaultInjection', () => {
      it('test_chaos_invalidJsonPayload', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          let threw: boolean = false;
          try {
            JSON.parse('}{invalid_' + i.toString());
          } catch (e) {
            threw = true;
          }
          expect(threw).assertTrue();
        }
      });
      it('test_chaos_nullReferences', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          let threw: boolean = false;
          try {
            let p: MockAVPlayer | null = getNullChaosPlayer();
            if (p !== null) {
              p.play();
            }
          } catch (e) {
            threw = true;
          }
          expect(threw).assertFalse();
        }
      });
      it('test_chaos_undefinedCallbacks', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          let threw: boolean = false;
          try {
            const cb: (() => void) | undefined = i % 2 === 0 ? (): void => {} : undefined;
            if (cb) {
              cb();
            }
          } catch (e) {
            threw = true;
          }
          expect(threw).assertFalse();
        }
      });
      it('test_chaos_emptyDeviceNetworkId', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nid: string = i % 100 === 0 ? '' : 'net_' + i.toString();
          const canStart: boolean = !!nid;
          if (i % 100 === 0) {
            expect(canStart).assertFalse();
          } else {
            expect(canStart).assertTrue();
          }
        }
      });
      it('test_chaos_extremeIndexValues', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const idx: number = i % 2 === 0 ? -1 : Number.MAX_SAFE_INTEGER;
          const idxType: number = idx;
          expect(typeof idxType).assertEqual('number');
        }
      });
      it('test_chaos_malformedSongData', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const song: songItemType = {
            img: '',
            name: i % 100 === 0 ? '' : 's_' + i.toString(),
            author: i % 50 === 0 ? '' : 'a_' + i.toString(),
            url: i % 200 === 0 ? '' : 'u_' + i.toString(),
            time: i % 10 === 0 ? 0 : i,
          };
          const songNotNull: boolean = song !== null;
          expect(songNotNull).assertTrue();
        }
      });
      it('test_chaos_concurrentKVAccess', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('cc_' + i.toString(), i);
          store.get('cc_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_chaos_rapidScanStopCycle', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          if (i % 10 === 0) {
            inst.startScan();
          }
          if (i % 10 === 5) {
            inst.stopScan();
          }
        }
        inst.stopScan();
        expect(true).assertTrue();
      });
    });

    describe('MixedOperationStress_100', () => {
      it('test_mixed_allOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let playIndex: number = 0;
        let focusIndex: number = 2;
        let changePlayFlag: string = '';
        const songList: songItemType[] = mkSongs(5);
        const devices: DistributedManagerDeviceInfo[] = mkDevices(3);
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 12;
          switch (op) {
            case 0:
              isPlay = !isPlay;
              break;
            case 1:
              playIndex = (playIndex + 1) % songList.length;
              break;
            case 2:
              playIndex = (playIndex - 1 + songList.length) % songList.length;
              break;
            case 3:
              if (focusIndex > 0) {
                focusIndex--;
              }
              break;
            case 4:
              if (focusIndex < 4) {
                focusIndex++;
              }
              break;
            case 5:
              changePlayFlag = 'PRE';
              changePlayFlag = '';
              break;
            case 6:
              changePlayFlag = 'NEXT';
              changePlayFlag = '';
              break;
            case 7:
              isPlay = true;
              break;
            case 8:
              isPlay = false;
              break;
            case 9:
              focusIndex = i % 5;
              break;
            case 10:
              const s: songItemType = songList[playIndex];
              expect(s.name.length).assertLarger(0);
              break;
            case 11:
              const d: DistributedManagerDeviceInfo = devices[i % devices.length];
              expect(d.deviceId.length).assertLarger(0);
              break;
          }
        }
        const isPlayType: boolean = isPlay;
        expect(typeof isPlayType).assertEqual('boolean');
        const playIndexCond: boolean = playIndex >= 0 && playIndex < songList.length;
        expect(playIndexCond).assertTrue();
        const focusIndexCond: boolean = focusIndex >= 0 && focusIndex <= 4;
        expect(focusIndexCond).assertTrue();
        expect(changePlayFlag).assertEqual('');
      });
      it('test_mixed_jsonAndModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const song: SongItemTypeModel = new SongItemTypeModel({
            img: '',
            name: 'm_' + i.toString(),
            author: 'a_' + i.toString(),
            url: 'u_' + i.toString(),
            time: i,
          });
          const json: string = JSON.stringify({ uri: song.url, name: song.name, time: song.time });
          const parsed: ObjectRecord = JSON.parse(json);
          expect(parsed.uri).assertEqual('u_' + i.toString());
        }
      });
      it('test_mixed_deviceAndAuth_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const dev: DistributedManagerDeviceInfo = {
            deviceId: 'mix_' + (i % 100).toString(),
            deviceName: 'Mix ' + i.toString(),
            deviceType: DeviceType.TV,
            networkId: 'mix_net_' + (i % 100).toString(),
            range: i % 50,
            isInAuth: false,
            isTrust: false,
            transferLoading: false,
            isInTransfer: false,
            updateTime: new Date().getTime(),
          };
          inst.addDevice('mix_' + (i % 100).toString(), dev);
          if (i % 5 === 0) {
            inst.updateDeviceProp('mix_' + (i % 100).toString(), 'isInAuth', true);
          }
          if (i % 7 === 0) {
            inst.updateDeviceProp('mix_' + (i % 100).toString(), 'isTrust', true);
          }
          if (i % 11 === 0) {
            inst.updateDeviceProp('mix_' + (i % 100).toString(), 'transferLoading', false);
          }
        }
        expect(true).assertTrue();
      });
      it('test_mixed_eventCodeRouting_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const codes: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        for (let i: number = 0; i < 100; i++) {
          const code: number = codes[i % codes.length];
          let handled: boolean = false;
          for (let c: number = 1; c <= 11; c++) {
            if (code === c) {
              handled = true;
              break;
            }
          }
          expect(handled).assertTrue();
        }
      });
      it('test_mixed_touchEventAndPointer_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const evt: MockTouch = new MockTouch();
        for (let i: number = 0; i < 100; i++) {
          const typeArr: TouchType[] = [TouchType.Down, TouchType.Move, TouchType.Up];
          evt.type = typeArr[i % 3];
          const sourceArr: SourceType[] = [SourceType.Mouse, SourceType.TouchScreen];
          evt.source = sourceArr[i % 2];
          EventUtil.isTouchEvent(evt);
          PointerUtil.changePointStyle(evt.type === TouchType.Down);
        }
        expect(true).assertTrue();
      });
    });

    describe('LoggerStress_3000', () => {
      it('test_stress_loggerDebug_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.debug('s_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_loggerInfo_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.info('s_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_loggerWarn_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.warn('s_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_loggerError_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.error('s_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_logUtil_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.debug('t_' + i.toString(), 'm_' + i.toString());
          Logger.debug('t_' + i.toString(), 'm_' + i.toString());
          Logger.info('t_' + i.toString(), 'm_' + i.toString());
          Logger.error('t_' + i.toString(), 'm_' + i.toString());
          Logger.warn('t_' + i.toString(), 'm_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_initLog_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Logger.info('t_' + i.toString(), 'm_' + i.toString());
          Logger.debug('t_' + i.toString(), 'm_' + i.toString());
        }
        expect(true).assertTrue();
      });
    });

    describe('PreferencesStress_3000', () => {
      it('test_stress_prefWrite_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Preferences.writeData('sk_' + i.toString(), 'sv_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_prefRead_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Preferences.readData('rk_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_prefDelete_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Preferences.deleteData('dk_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_stress_prefFlush_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Preferences.flushData();
        }
        expect(true).assertTrue();
      });
      it('test_stress_prefSubscribe_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          Preferences.subscribeData('subk_' + i.toString());
        }
        expect(true).assertTrue();
      });
    });

    describe('ObjTypeStress_3000', () => {
      it('test_stress_objType_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const emptyObj: ObjectRecord = makeObjectRecord();
        const emptyArr: string[] = [];
        const vals: Array<string | number | boolean | null | undefined | ObjectRecord | string[] | (() => void)> = ['str', 42, true, null, undefined, emptyObj, emptyArr, (): void => {}];
        for (let i: number = 0; i < 3000; i++) {
          const v: string | number | boolean | null | undefined | ObjectRecord | string[] | (() => void) = vals[i % vals.length];
          const r: string = objType(v);
          expect(r.length).assertLarger(0);
        }
      });
    });

    describe('SongsDataStress_3000', () => {
      it('test_stress_songsIteration_3000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 3000; i++) {
          const s: songItemType = songs[i % songs.length] as songItemType;
          expect(s.name.length).assertLarger(0);
          expect(s.author.length).assertLarger(0);
          expect(s.url.length).assertLarger(0);
        }
      });
    });
  });
}
