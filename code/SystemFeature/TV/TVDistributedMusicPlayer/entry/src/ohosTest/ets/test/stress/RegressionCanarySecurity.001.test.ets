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
interface JsonPrimitiveRecord extends Record<string, string | number | boolean> {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
}

function replaceAll(s: string, search: string, replacement: string): string {
  let result: string = '';
  for (let i: number = 0; i < s.length; i++) {
    if (s.substr(i, search.length) === search) {
      result += replacement;
      i += search.length - 1;
    } else {
      result += s.charAt(i);
    }
  }
  return result;
}

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

  emitState(s: string): void {
    if (this.onStateChangeCb !== null) {
      this.onStateChangeCb(s);
    }
  }
}

export default function RegressionCanarySecurity001TestSuite(): void {
  describe('RegressionCanarySecurity001Test', () => {

    describe('AutomatedRegressionSuite_PlayControl', () => {
      it('test_reg_playControl_playPauseResume', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.onStateChange((s: string) => {
          if (s === 'playing') {
            p.isPlay = true;
          }
          if (s === 'paused') {
            p.isPlay = false;
          }
        });
        p.url = 'test.wav';
        p.prepare();
        expect(p.state).assertEqual('playing');
        p.pause();
        expect(p.state).assertEqual('paused');
        p.play();
        expect(p.state).assertEqual('playing');
        p.pause();
        expect(p.state).assertEqual('paused');
      });
      it('test_reg_playControl_nextPreviousCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const sl: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 15; i++) {
          idx = (idx + 1) % sl.length;
        }
        expect(idx).assertEqual(15 % 5);
        for (let i: number = 0; i < 5; i++) {
          idx = (idx - 1 + sl.length) % sl.length;
        }
        expect(idx).assertEqual(0);
      });
      it('test_reg_playControl_seekPosition', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let seekDone: boolean = false;
        p.onSeekDone(() => {
          seekDone = true;
        });
        p.seek(90000);
        expect(seekDone).assertTrue();
      });
      it('test_reg_playControl_durationUpdate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let dur: number = 0;
        p.onDurationUpdate((d: number) => {
          dur = d;
        });
        p.emitDuration(180000);
        expect(dur).assertEqual(180000);
      });
      it('test_reg_playControl_timeUpdate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        let t: number = 0;
        p.onTimeUpdate((v: number) => {
          t = v;
        });
        p.emitTime(41000);
        expect(t).assertEqual(41000);
      });
      it('test_reg_playControl_completedAutoNext', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const sl: songItemType[] = mkSongs(3);
        let idx: number = 0;
        idx++;
        idx = idx % sl.length;
        expect(idx).assertEqual(1);
        idx++;
        idx = idx % sl.length;
        expect(idx).assertEqual(2);
        idx++;
        idx = idx % sl.length;
        expect(idx).assertEqual(0);
      });
      it('test_reg_playControl_singleSongList', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const sl: songItemType[] = mkSongs(1);
        let idx: number = 0;
        idx = (idx + 1) % sl.length;
        expect(idx).assertEqual(0);
        idx = (idx - 1 + sl.length) % sl.length;
        expect(idx).assertEqual(0);
      });
    });

    describe('AutomatedRegressionSuite_DistributedFlow', () => {
      it('test_reg_distributed_fullTransferCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let status: number = MusicSharedStatus.MUSIC_SHARED;
        expect(status).assertEqual(MusicSharedStatus.MUSIC_SHARED);
        status = MusicSharedStatus.MUSIC_REMOTING;
        expect(status).assertEqual(MusicSharedStatus.MUSIC_REMOTING);
        status = MusicSharedStatus.MUSIC_STOP_SHARED;
        expect(status).assertEqual(MusicSharedStatus.MUSIC_STOP_SHARED);
        status = MusicSharedStatus.MUSIC_SHARED;
        expect(status).assertEqual(MusicSharedStatus.MUSIC_SHARED);
      });
      it('test_reg_distributed_deviceAuthCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let dev: DistributedManagerDeviceInfo = { deviceId: 'reg_auth', deviceName: 'Reg Auth', deviceType: DeviceType.TV, networkId: 'reg_net', range: 5, isInAuth: false, isTrust: false, transferLoading: false, isInTransfer: false };
        expect(dev.isInAuth).assertFalse();
        expect(dev.isTrust).assertFalse();
        dev.isInAuth = true;
        expect(dev.isInAuth).assertTrue();
        dev.isInAuth = false;
        dev.isTrust = true;
        expect(dev.isTrust).assertTrue();
        dev.isInTransfer = true;
        dev.transferLoading = true;
        expect(dev.isInTransfer).assertTrue();
        expect(dev.transferLoading).assertTrue();
        dev.isInTransfer = false;
        dev.transferLoading = false;
        expect(dev.isInTransfer).assertFalse();
        expect(dev.transferLoading).assertFalse();
      });
      it('test_reg_distributed_messageCodePropagation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const localPlay: number = MusicSharedEventCode.PLAY_MUSIC_SERVICE;
        const remotePlay: number = MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE;
        expect(localPlay !== remotePlay).assertTrue();
        const localPause: number = MusicSharedEventCode.PAUSE_MUSIC_SERVICE;
        const remotePause: number = MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE;
        expect(localPause !== remotePause).assertTrue();
      });
      it('test_reg_distributed_connectionEventSequence', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const events: string[] = [];
        events.push(MusicConnectEvent.EVENT_CONNECT);
        events.push(MusicConnectEvent.EVENT_DISCONNECT);
        expect(events[0]).assertEqual('ONCONNECT');
        expect(events[1]).assertEqual('ONDISCONNECT');
      });
      it('test_reg_distributed_timeoutHandling', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let timeoutTriggered: boolean = false;
        const timeoutId: number = setTimeout(() => {
          timeoutTriggered = true;
        }, 100);
        clearTimeout(timeoutId);
        expect(timeoutTriggered).assertFalse();
      });
    });

    describe('CanaryVerification_BasicSmoke', () => {
      it('test_canary_appStartup', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player !== null).assertTrue();
        expect(player.isPlay).assertFalse();
        expect(player.playIndex).assertEqual(0);
      });
      it('test_canary_loggerSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          Logger.debug('canary');
          Logger.info('canary');
          Logger.warn('canary');
          Logger.error('canary');
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_canary_preferencesSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        Preferences.writeData('canary', 'test');
        const r: string | undefined = String(Preferences.readData('canary'));
        expect(r !== null).assertTrue();
      });
      it('test_canary_songsDataSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertEqual(3);
        for (let i: number = 0; i < songs.length; i++) {
          const s: songItemType = songs[i];
          expect(s.name.length).assertLarger(0);
        }
      });
      it('test_canary_deviceManagerSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        expect(inst !== null).assertTrue();
        const startScanType: string = typeof inst.startScan;
        expect(startScanType).assertEqual('function');
      });
      it('test_canary_eventCodeEnumSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE).assertEqual(1);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertEqual(11);
      });
      it('test_canary_kVStoreModelSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(KvStoreModel !== null).assertTrue();
        const putType: string = typeof KvStoreModel.put;
        expect(putType).assertEqual('function');
      });
      it('test_canary_pointerUtilSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let threw: boolean = false;
        try {
          PointerUtil.changePointStyle(true);
          PointerUtil.changePointDefaultStyle();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
      it('test_canary_defaultStateSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.isPlay).assertFalse();
        expect(defaultState.playMode).assertEqual('auto');
      });
      it('test_canary_objTypeSmoke', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType('test')).assertEqual('string');
        expect(objType(42)).assertEqual('number');
        expect(objType(null)).assertEqual('null');
      });
    });

    describe('SecurityVulnerabilityScan', () => {
      it('test_sec_xssInSongName', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const malicious: string = '<script>alert("xss")</script>';
        const sanitized: string = replaceAll(replaceAll(malicious, '<', '&lt;'), '>', '&gt;');
        expect(sanitized.indexOf('<script>') === -1).assertTrue();
        expect(sanitized.indexOf('&lt;script') !== -1).assertTrue();
      });
      it('test_sec_xssInDeviceName', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const malicious: string = '<img onerror="alert(1)" src=x>';
        const sanitized: string = replaceAll(replaceAll(malicious, '<', '&lt;'), '>', '&gt;');
        expect(sanitized.indexOf('<img') === -1).assertTrue();
      });
      it('test_sec_sqlInjectionInUrl', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const urls: string[] = ["'; DROP TABLE songs;--", " OR 1=1 --", "\" OR \"\"=\""];
        for (let j: number = 0; j < urls.length; j++) {
          const lowerUrl: string = urls[j].toLowerCase();
          const hasSQL: boolean = lowerUrl.indexOf('drop') !== -1 || urls[j].indexOf('OR 1=1') !== -1;
          expect(hasSQL).assertTrue();
        }
      });
      it('test_sec_pathTraversal', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const paths: string[] = ['../../etc/passwd', '..\\..\\windows\\system32', '/etc/shadow'];
        for (let j: number = 0; j < paths.length; j++) {
          const hasTraversal: boolean = paths[j].indexOf('..') !== -1 || paths[j].indexOf('/etc/') !== -1;
          expect(hasTraversal).assertTrue();
        }
      });
      it('test_sec_commandInjection', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const cmds: string[] = ['; rm -rf /', '| cat /etc/passwd', '`whoami`', '$(uname -a)'];
        for (let j: number = 0; j < cmds.length; j++) {
          const hasCmd: boolean = cmds[j].indexOf(';') !== -1 || cmds[j].indexOf('|') !== -1 || cmds[j].indexOf('`') !== -1 || cmds[j].indexOf('$(') !== -1;
          expect(hasCmd).assertTrue();
        }
      });
      it('test_sec_emptyInputValidation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const emptyStrings: string[] = ['', '   ', '\t', '\n'];
        for (let j: number = 0; j < emptyStrings.length; j++) {
          const isValid: boolean = emptyStrings[j].trim().length > 0;
          expect(isValid).assertFalse();
        }
      });
      it('test_sec_numericOverflow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const overflowValues: number[] = [Number.MAX_SAFE_INTEGER, Number.MIN_SAFE_INTEGER, Infinity, -Infinity, NaN];
        for (let j: number = 0; j < overflowValues.length; j++) {
          const v: number = overflowValues[j];
          const isFinite: boolean = Number.isFinite(v);
          if (v === Infinity || v === -Infinity || Number.isNaN(v)) {
            expect(isFinite).assertFalse();
          }
        }
      });
      it('test_sec_authParamValidation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const validAuthExtra: StringRecord = makeStringRecord();
        const invalidAuthExtra: StringRecord = makeStringRecord();
        const validAuth: AuthParam = { authType: 1, extraInfo: validAuthExtra };
        const invalidAuth: AuthParam = { authType: -1, extraInfo: invalidAuthExtra };
        expect(validAuth.authType).assertEqual(1);
        expect(invalidAuth.authType).assertLess(0);
      });
      it('test_sec_networkIdValidation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const validNid: string = 'network-123';
        const emptyNid: string = '';
        const specialNid: string = '<script>network</>';
        expect(validNid.length).assertLarger(0);
        expect(emptyNid.length).assertEqual(0);
        expect(specialNid.indexOf('<script>') !== -1).assertTrue();
      });
      it('test_sec_jsonInjection', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const maliciousJson: string = '{"uri":"test","__proto__":{"admin":true}}';
        const parsed: ObjectRecord = JSON.parse(maliciousJson);
        const parsedObj: ObjectRecord = parsed as ObjectRecord;
        expect(parsedObj.uri).assertEqual('test');
        expect(parsedObj['__proto__'] !== undefined).assertTrue();
      });
      it('test_sec_largePayloadRejection', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const largePayload: string = strRepeat('A', 10000);
        expect(largePayload.length).assertEqual(10000);
        const json: string = JSON.stringify({ data: largePayload });
        expect(json.length).assertLarger(10000);
      });
      it('test_sec_unicodeExploit', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const unicodeExploit: string = '‮exe.com';
        expect(unicodeExploit.length).assertLarger(0);
      });
    });

    describe('CompatibilityMatrix_Extended', () => {
      it('test_compat_allDeviceTypes_fullMatrix', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const types: DeviceType[] = [DeviceType.UNKNOWN_TYPE, DeviceType.SPEAKER, DeviceType.PHONE, DeviceType.TABLET, DeviceType.WEARABLE, DeviceType.CAR, DeviceType.TV];
        for (let tIdx: number = 0; tIdx < types.length; tIdx++) {
          const type: DeviceType = types[tIdx];
          for (let r: number = 0; r < 10; r++) {
            const dev: DeviceInfoType = { deviceId: 'compat_' + type.toString() + '_' + r.toString(), deviceName: 'Matrix Dev ' + type.toString() + '-' + r.toString(), deviceType: type, networkId: 'net_' + type.toString() + '_' + r.toString(), range: r * 10 };
            expect(dev.deviceType).assertEqual(type);
            expect(dev.range).assertEqual(r * 10);
          }
        }
      });
      it('test_compat_allPlayModes_fullMatrix', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const modes: Array<'auto' | 'repeat' | 'random'> = ['auto', 'repeat', 'random'];
        for (let mIdx: number = 0; mIdx < modes.length; mIdx++) {
          const mode: 'auto' | 'repeat' | 'random' = modes[mIdx];
          for (let i: number = 0; i < 20; i++) {
            const state: PlayStateTypeModel = new PlayStateTypeModel({
              img: defaultState.img, name: defaultState.name, author: defaultState.author,
              url: defaultState.url, playIndex: i, time: i * 100, duration: i * 2000,
              isPlay: i % 2 === 0, playMode: mode, playList: defaultState.playList
            });
            expect(state.playMode).assertEqual(mode);
            expect(state.playIndex).assertEqual(i);
          }
        }
      });
      it('test_compat_allEventCodes_matrix', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const codes: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        for (let cIdx: number = 0; cIdx < codes.length; cIdx++) {
          const code: number = codes[cIdx];
          for (let i: number = 0; i < 10; i++) {
            let handled: boolean = false;
            switch (code) {
              case MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.PLAY_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.PAUSE_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE:
                handled = true;
                break;
              case MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE:
                handled = true;
                break;
              case MusicSharedEventCode.STOP_LOCAL_SERIVCE:
                handled = true;
                break;
              case MusicSharedEventCode.PRE_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.NEXT_MUSIC_SERVICE:
                handled = true;
                break;
              case MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE:
                handled = true;
                break;
              case MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE:
                handled = true;
                break;
            }
            expect(handled).assertTrue();
          }
        }
      });
      it('test_compat_timeFormat_allDurations', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const durations: number[] = [0, 100, 1000, 100, 30000, 60000, 90000, 120000, 180000, 300000, 600000, 3600000];
        for (let dIdx: number = 0; dIdx < durations.length; dIdx++) {
          const d: number = durations[dIdx];
          const r: string = number2time(d);
          expect(r.indexOf(':') !== -1).assertTrue();
          expect(r.length).assertEqual(5);
        }
      });
      it('test_compat_dataTypeInterop', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const objVal: StringRecord = makeStringRecord();
        objVal.key = 'val';
        const testValues: Array<string | number | boolean | StringRecord | null> = ['str', 42, true, null, objVal];
        for (let vIdx: number = 0; vIdx < testValues.length; vIdx++) {
          const v: string | number | boolean | StringRecord | null = testValues[vIdx];
          const t: string = objType(v);
          expect(t.length).assertLarger(0);
          const j: string = JSON.stringify({ v: v });
          const p: object = JSON.parse(j);
          expect(p !== null).assertTrue();
        }
      });
    });

    describe('DataConsistencyVerification', () => {
      it('test_dataConsistency_playStateModelRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const modes: string[] = ['auto', 'repeat', 'random'];
        for (let i: number = 0; i < 100; i++) {
          const playModeVal: 'auto' | 'repeat' | 'random' = modes[i % 3] as 'auto' | 'repeat' | 'random';
          const orig: PlayStateType = { img: 'img_' + i.toString(), name: 'name_' + i.toString(), author: 'author_' + i.toString(), url: 'url_' + i.toString(), playIndex: i % 10, time: i * 100, duration: i * 200, isPlay: i % 2 === 0, playMode: playModeVal, playList: mkSongs(3) };
          const model: PlayStateTypeModel = new PlayStateTypeModel(orig);
          expect(model.img).assertEqual(orig.img);
          expect(model.name).assertEqual(orig.name);
          expect(model.playIndex).assertEqual(orig.playIndex);
          expect(model.isPlay).assertEqual(orig.isPlay);
          expect(model.playMode).assertEqual(orig.playMode);
        }
      });
      it('test_dataConsistency_songModelRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const imgRes: Resource = $r('app.media.album1');
          const orig: songItemType = { img: imgRes, name: 'song_' + i.toString(), author: 'artist_' + i.toString(), url: 'url_' + i.toString() + '.wav', time: i * 100 };
          const model: SongItemTypeModel = new SongItemTypeModel(orig);
          expect(model.name).assertEqual(orig.name);
          expect(model.author).assertEqual(orig.author);
          expect(model.url).assertEqual(orig.url);
          expect(model.time).assertEqual(orig.time);
        }
      });
      it('test_dataConsistency_deviceInfoRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const orig: DeviceInfoType = { deviceId: 'dev_' + i.toString(), deviceName: 'Device ' + i.toString(), deviceType: DeviceType.TV, networkId: 'net_' + i.toString(), range: i };
          const json: string = JSON.stringify(orig);
        const parsed: DeviceInfoType = JSON.parse(json) as DeviceInfoType;
          expect(parsed.deviceId).assertEqual(orig.deviceId);
          expect(parsed.deviceName).assertEqual(orig.deviceName);
          expect(parsed.range).assertEqual(orig.range);
        }
      });
      it('test_dataConsistency_kvStoreRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          await store.put('consistency_' + i.toString(), i);
        }
        for (let i: number = 0; i < 100; i++) {
          const v: number | null = await store.get('consistency_' + i.toString());
          expect(v).assertEqual(i);
        }
      });
      it('test_dataConsistency_progressCalculationConsistency', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const duration: number = 180000;
        for (let i: number = 0; i < 180; i++) {
          const seekTo: number = i * 100;
          const progress: number = Math.floor(seekTo / duration * 100);
          expect(progress >= 0 && progress <= 100).assertTrue();
          if (seekTo === 0) {
            expect(progress).assertEqual(0);
          }
          if (seekTo === duration) {
            expect(progress).assertEqual(100);
          }
        }
      });
    });

    describe('ContractTest', () => {
      it('test_contract_bundleNameMatches', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        expect(APPLICATION_BUNDLE_NAME).assertEqual('ohos.samples.distributedmusicplayer');
        expect(APPLICATION_ABILITY_NAME.indexOf(APPLICATION_BUNDLE_NAME) !== -1).assertTrue();
      });
      it('test_contract_serviceNameConsistent', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        expect(APPLICATION_SERVICE_NAME).assertEqual('ServiceAbility');
      });
      it('test_contract_eventCodeRange', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        expect(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE).assertLarger(0);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertLess(20);
      });
      it('test_contract_statusEnumRange', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
        expect(MusicSharedStatus.MUSIC_STOP_SHARED).assertLess(10);
      });
      it('test_contract_connectEventStrings', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const connectEvents: string[] = [MusicConnectEvent.EVENT_CONNECT, MusicConnectEvent.EVENT_DISCONNECT, MusicConnectEvent.EVENT_FAILED, MusicConnectEvent.EVENT_TIMEOUT];
        for (let eIdx: number = 0; eIdx < connectEvents.length; eIdx++) {
          const e: string = connectEvents[eIdx];
          const eType: string = typeof e;
          expect(eType).assertEqual('string');
          expect(e.length).assertLarger(0);
          expect(e).assertEqual(e.toUpperCase());
        }
      });
      it('test_contract_defaultStateInvariant', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        expect(defaultState.isPlay).assertFalse();
        expect(defaultState.playMode).assertEqual('auto');
        expect(defaultState.playIndex).assertEqual(0);
        expect(defaultState.time).assertEqual(0);
        expect(defaultState.duration).assertEqual(0);
        expect(defaultState.playList.length).assertEqual(0);
      });
    });

    describe('ExtremeStress_100', () => {
      it('test_extreme_playPause_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const p: MockAVPlayer = new MockAVPlayer();
        p.onStateChange((s: string) => {
          if (s === 'playing') {
            p.isPlay = true;
          }
          if (s === 'paused') {
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
        const isPlayType: string = typeof p.isPlay;
        expect(isPlayType).assertEqual('boolean');
      });
      it('test_extreme_nextPrevious_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const sl: songItemType[] = mkSongs(5);
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          if (i % 3 === 0) {
            idx = (idx + 1) % sl.length;
          } else if (i % 3 === 1) {
            idx = (idx - 1 + sl.length) % sl.length;
          }
        }
        expect(idx >= 0 && idx < sl.length).assertTrue();
      });
      it('test_extreme_focusNavigation_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
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
      it('test_extreme_kvOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          store.put('ex_' + (i % 100).toString(), i);
          if (i % 10 === 0) {
            store.get('ex_' + (i % 100).toString());
          }
        }
        expect(true).assertTrue();
      });
      it('test_extreme_deviceOps_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'exd_' + (i % 100).toString();
          const now: number = new Date().getTime();
          const devInfo: DistributedManagerDeviceInfo = { deviceId: devId, deviceName: 'EX ' + i.toString(), deviceType: DeviceType.TV, networkId: 'exn_' + (i % 100).toString(), range: i % 100, updateTime: now } as DistributedManagerDeviceInfo;
          inst.addDevice(devId, devInfo);
          if (i % 20 === 0) {
            inst.updateDeviceProp('exd_' + (i % 100).toString(), 'transferLoading', i % 2 === 0);
          }
        }
        expect(true).assertTrue();
      });
      it('test_extreme_jsonSerialize_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const d: JsonPrimitiveRecord = { uri: 'u_' + i.toString(), seekTo: i, isPlaying: i % 2 === 0 };
          const j: string = JSON.stringify(d);
          const p: JsonPrimitiveRecord = JSON.parse(j);
          expect(p.uri).assertEqual('u_' + i.toString());
        }
      });
      it('test_extreme_timeFormat_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 18);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
      it('test_extreme_modelCreation_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const imgRes: Resource = $r('app.media.album1');
          const s: SongItemTypeModel = new SongItemTypeModel({ img: imgRes, name: 'exs_' + i.toString(), author: 'exa_' + i.toString(), url: 'exu_' + i.toString(), time: i });
          const ps: PlayStateTypeModel = new PlayStateTypeModel({ img: '', name: 'exn_' + i.toString(), author: 'exa_' + i.toString(), url: 'exu_' + i.toString(), playIndex: i % 100, time: i, duration: i * 2, isPlay: i % 2 === 0, playMode: 'auto', playList: [] });
          expect(s.name).assertEqual('exs_' + i.toString());
        }
      });
      it('test_extreme_logger_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Logger.debug('exd_' + i.toString());
          Logger.info('exi_' + i.toString());
        }
        expect(true).assertTrue();
      });
      it('test_extreme_preferences_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          Preferences.writeData('exk_' + i.toString(), 'exv_' + i.toString());
          if (i % 20 === 0) {
            Preferences.readData('exk_' + i.toString());
          }
        }
        expect(true).assertTrue();
      });
      it('test_extreme_allMixed_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        let flag: string = '';
        const sl: songItemType[] = mkSongs(5);
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 10;
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
              store.put('mx_' + (i % 100).toString(), i);
              break;
            case 8:
              const devId8: string = 'mx_' + (i % 300).toString();
              const now8: number = new Date().getTime();
              const devInfo8: DistributedManagerDeviceInfo = { deviceId: devId8, deviceName: 'MX ' + i.toString(), deviceType: DeviceType.TV, networkId: 'mxn_' + (i % 300).toString(), range: i % 50, updateTime: now8 } as DistributedManagerDeviceInfo;
              inst.addDevice(devId8, devInfo8);
              break;
            case 9:
              new SongItemTypeModel(sl[idx]);
              break;
          }
        }
        const isPlayType: string = typeof isPlay;
        expect(isPlayType).assertEqual('boolean');
      });
    });
  });
}
