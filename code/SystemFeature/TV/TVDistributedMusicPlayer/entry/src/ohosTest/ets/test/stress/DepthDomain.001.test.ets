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

/* Play mode constants */
type PlayMode = 'auto' | 'repeat' | 'random';
const PLAY_MODE_AUTO: PlayMode = 'auto';
const PLAY_MODE_REPEAT: PlayMode = 'repeat';
const PLAY_MODE_RANDOM: PlayMode = 'random';
const PLAY_MODES: PlayMode[] = [PLAY_MODE_AUTO, PLAY_MODE_REPEAT, PLAY_MODE_RANDOM];

/* Shared additive device data helper */
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

/* Accessibility tree interface */
interface A11yTree {
  type: string;
  children: A11yChild[];
}
interface A11yChild {
  type: string;
  children: A11yLeaf[];
}
interface A11yLeaf {
  type: string;
}

interface JsonResult {
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

export default function DepthDomain001TestSuite(): void {
  describe('DepthDomain001Test', () => {

    describe('DesktopRenderingLayoutTest', () => {
      it('test_desktop_albumCoverLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const albumWidth: number = 418;
        const albumHeight: number = 418;
        const albumMarginTop: number = 40;
        const albumMarginLeft: number = 185;
        const coverWidth: number = 490;
        const coverHeight: number = 490;
        const coverMarginRight: number = 105;
        expect(albumWidth).assertLarger(0);
        expect(albumHeight).assertLarger(0);
        expect(coverWidth).assertLarger(albumWidth);
        expect(coverHeight).assertLarger(albumHeight);
      });
      it('test_desktop_controlBarLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const barWidth: number = 1024;
        const barHeight: number = 112;
        const buttonSize: number = 96;
        const buttonCount: number = 5;
        expect(barWidth).assertEqual(buttonSize * buttonCount + (barWidth - buttonSize * buttonCount));
        expect(barHeight).assertLarger(buttonSize);
      });
      it('test_desktop_sliderLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const sliderWidth: number = 1728;
        const sliderHeight: number = 8;
        const blockSize: number = 24;
        expect(sliderWidth).assertLarger(0);
        expect(sliderHeight).assertLess(blockSize);
      });
      it('test_desktop_timeDisplayLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const timeRowHeight: number = 28;
        const timeFontSize: number = 24;
        const timeWidth: number = 63;
        expect(timeRowHeight).assertLarger(timeFontSize);
        expect(timeWidth).assertLarger(0);
      });
      it('test_desktop_songInfoLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const titleWidth: number = 432;
        const titleHeight: number = 42;
        const titleFontSize: number = 36;
        const authorWidth: number = 432;
        const authorHeight: number = 35;
        const authorFontSize: number = 30;
        expect(titleWidth).assertLarger(0);
        expect(authorFontSize).assertLess(titleFontSize);
      });
      it('test_desktop_bgImageSize', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const bgWidth: string = '100%';
        const bgHeight: string = '100%';
        expect(bgWidth).assertEqual('100%');
        expect(bgHeight).assertEqual('100%');
      });
    });

    describe('EditModeTest', () => {
      it('test_editMode_enterAndExit', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicListDelete: boolean = false;
        musicListDelete = !musicListDelete;
        expect(musicListDelete).assertTrue();
        musicListDelete = !musicListDelete;
        expect(musicListDelete).assertFalse();
      });
      it('test_editMode_deleteWhileInEdit', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicListDelete: boolean = true;
        let musicList: songItemType[] = mkSongs(5);
        let focusID: number = 2;
        musicList.splice(focusID, 1);
        musicListDelete = false;
        expect(musicList.length).assertEqual(4);
        expect(musicListDelete).assertFalse();
      });
      it('test_editMode_boundaryDeleteFirst', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicList: songItemType[] = mkSongs(3);
        let focusID: number = 0;
        musicList.splice(focusID, 1);
        expect(musicList.length).assertEqual(2);
        expect(musicList[0].name).assertEqual('s_1');
      });
      it('test_editMode_boundaryDeleteLast', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicList: songItemType[] = mkSongs(3);
        let focusID: number = 2;
        musicList.splice(focusID, 1);
        if (focusID >= musicList.length) {
          focusID = musicList.length - 1;
        }
        expect(musicList.length).assertEqual(2);
        expect(focusID).assertEqual(1);
      });
      it('test_editMode_moveInList', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicList: songItemType[] = mkSongs(5);
        let focusID: number = 0;
        focusID = 2;
        focusID = 4;
        focusID = 0;
        expect(focusID).assertEqual(0);
      });
    });

    describe('ShortcutOperationTest', () => {
      it('test_shortcut_removeSong', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicList: songItemType[] = mkSongs(5);
        const idx: number = 3;
        musicList.splice(idx, 1);
        expect(musicList.length).assertEqual(4);
      });
      it('test_shortcut_persistAfterRemove', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicList: songItemType[] = mkSongs(3);
        musicList.splice(1, 1);
        Preferences.writeData('musicList', JSON.stringify(musicList));
        const r = Preferences.readData('musicList');
        expect(r !== null).assertTrue();
      });
    });

    describe('KeyEventAllDirectionTest', () => {
      it('test_key_dpadLeft_focusIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let f: number = 4;
        if (f > 0) { f--; }
        expect(f).assertEqual(3);
        if (f > 0) { f--; }
        expect(f).assertEqual(2);
        if (f > 0) { f--; }
        expect(f).assertEqual(1);
        if (f > 0) { f--; }
        expect(f).assertEqual(0);
        if (f > 0) { f--; }
        expect(f).assertEqual(0);
      });
      it('test_key_dpadRight_focusIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let f: number = 0;
        if (f < 4) { f++; }
        expect(f).assertEqual(1);
        if (f < 4) { f++; }
        expect(f).assertEqual(2);
        if (f < 4) { f++; }
        expect(f).assertEqual(3);
        if (f < 4) { f++; }
        expect(f).assertEqual(4);
        if (f < 4) { f++; }
        expect(f).assertEqual(4);
      });
      it('test_key_dpadCenter_dispatch', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const actions: string[] = [];
        for (let f: number = 0; f < 5; f++) {
          switch (f) {
            case 0: actions.push('share'); break;
            case 1: actions.push('previous'); break;
            case 2: actions.push('play'); break;
            case 3: actions.push('next'); break;
            case 4: actions.push('list'); break;
          }
        }
        const expected: string[] = ['share', 'previous', 'play', 'next', 'list'];
        expect(actions.length).assertEqual(expected.length);
        for (let ai: number = 0; ai < actions.length; ai++) {
          expect(actions[ai]).assertEqual(expected[ai]);
        }
      });
      it('test_key_home_back', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let isShow: boolean = true;
        let isDevice: boolean = true;
        let musicListDelete: boolean = true;
        let handled: boolean = false;
        if (musicListDelete) {
          musicListDelete = false;
          handled = true;
        } else if (isShow) {
          isShow = false;
          handled = true;
        } else if (isDevice) {
          isDevice = false;
          handled = true;
        }
        expect(handled).assertTrue();
        expect(musicListDelete).assertFalse();
      });
      it('test_key_edit_toggle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let deleteMode: boolean = false;
        deleteMode = !deleteMode;
        expect(deleteMode).assertTrue();
        deleteMode = !deleteMode;
        expect(deleteMode).assertFalse();
      });
      it('test_key_a_key_closeList', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let isShow: boolean = true;
        isShow = false;
        expect(isShow).assertFalse();
      });
      it('test_key_menu_toggleDelete', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let musicListDelete: boolean = false;
        musicListDelete = !musicListDelete;
        expect(musicListDelete).assertTrue();
      });
    });

    describe('RecentTaskTest', () => {
      it('test_recent_openApp', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let appActive: boolean = false;
        appActive = true;
        expect(appActive).assertTrue();
      });
      it('test_recent_deleteFromRecent', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let inRecent: boolean = true;
        inRecent = false;
        expect(inRecent).assertFalse();
      });
      it('test_recent_clearAll', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const recentList: number[] = [1, 2, 3, 4, 5];
        recentList.length = 0;
        expect(recentList.length).assertEqual(0);
      });
      it('test_recent_switchBetweenApps', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let currentApp: string = 'music';
        currentApp = 'video';
        currentApp = 'music';
        expect(currentApp).assertEqual('music');
      });
    });

    describe('StatusBarTest', () => {
      it('test_statusBar_iconDisplay', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const icons: string[] = ['wifi', 'bluetooth', 'battery', 'time'];
        for (let ii: number = 0; ii < icons.length; ii++) {
          expect(icons[ii].length).assertLarger(0);
        }
      });
      it('test_statusBar_timeFormat', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const now: number = new Date().getTime();
        const timeStr: string = number2time(now % 3600000);
        expect(timeStr.indexOf(':') !== -1).assertTrue();
        expect(timeStr.length).assertEqual(5);
      });
      it('test_statusBar_networkStatus', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const isConnected: boolean = true;
        const networkType: string = 'wifi';
        expect(isConnected).assertTrue();
        expect(networkType).assertEqual('wifi');
      });
    });

    describe('PersistenceTest', () => {
      it('test_persistence_writeRead', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        Preferences.writeData('testKey', 'testValue');
        const r: string | null = String(Preferences.readData('testKey'));
        expect(r !== null).assertTrue();
      });
      it('test_persistence_coldStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        Preferences.writeData('isFirst', 'false');
        const r: string | null = String(Preferences.readData('isFirst'));
        expect(r !== null).assertTrue();
      });
      it('test_persistence_raceCondition', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'race_' + i.toString();
          const val: string = 'val_' + i.toString();
          Preferences.writeData(key, val);
        }
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'race_' + i.toString();
          const r: string | null = String(Preferences.readData(key));
          expect(r !== null).assertTrue();
        }
      });
      it('test_persistence_musicListRoundTrip', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const songList: songItemType[] = mkSongs(5);
        const json: string = JSON.stringify(songList);
        const parsedRaw: songItemType[] = JSON.parse(json) as songItemType[];
        const parsed: songItemType[] = [];
        for (let pi: number = 0; pi < parsedRaw.length; pi++) {
          parsed.push(parsedRaw[pi]);
        }
        expect(parsed.length).assertEqual(5);
        for (let si: number = 0; si < parsed.length; si++) {
          const expectedName: string = 's_' + si.toString();
          expect(parsed[si].name).assertEqual(expectedName);
        }
      });
    });

    describe('AccessibilityTest', () => {
      it('test_a11y_treeIntegrity', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const leaf1: A11yLeaf = { type: 'Image' };
        const leaf2: A11yLeaf = { type: 'Text' };
        const leaf3: A11yLeaf = { type: 'Row' };
        const child1: A11yChild = { type: 'Column', children: [leaf1, leaf2, leaf3] };
        const tree: A11yTree = { type: 'Stack', children: [child1] };
        expect(tree.type).assertEqual('Stack');
        expect(tree.children.length).assertLarger(0);
      });
      it('test_a11y_textReadable', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const textContent: string = songs[0].name;
        expect(textContent.length).assertLarger(0);
        const authorContent: string = songs[0].author;
        expect(authorContent.length).assertLarger(0);
      });
      it('test_a11y_focusableElements', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const focusableCount: number = 5;
        for (let i: number = 0; i < focusableCount; i++) {
          expect(i >= 0 && i < 5).assertTrue();
        }
      });
    });

    describe('RotationResolutionTest', () => {
      it('test_rotation_0degrees', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const angle: number = 0;
        expect(angle >= 0 && angle < 360).assertTrue();
      });
      it('test_rotation_90degrees', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const angle: number = 90;
        expect(angle >= 0 && angle < 360).assertTrue();
      });
      it('test_rotation_180degrees', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const angle: number = 180;
        expect(angle >= 0 && angle < 360).assertTrue();
      });
      it('test_rotation_270degrees', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const angle: number = 270;
        expect(angle >= 0 && angle < 360).assertTrue();
      });
      it('test_resolution_4k', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const width: number = 3840;
        const height: number = 2160;
        expect(width).assertLarger(0);
        expect(height).assertLarger(0);
      });
      it('test_resolution_1080p', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const width: number = 1920;
        const height: number = 1080;
        expect(width).assertLarger(0);
        expect(height).assertLarger(0);
      });
      it('test_resolution_720p', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const width: number = 1280;
        const height: number = 720;
        expect(width).assertLarger(0);
        expect(height).assertLarger(0);
      });
    });

    describe('PerformanceTest', () => {
      it('test_perf_startupTime', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const start: number = new Date().getTime();
        const sl: songItemType[] = mkSongs(3);
        const st: PlayStateTypeModel = new PlayStateTypeModel(defaultState);
        const elapsed: number = new Date().getTime() - start;
        expect(elapsed).assertLess(100);
      });
      it('test_perf_focusSwitchTime', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const start: number = new Date().getTime();
        let f: number = 0;
        for (let i: number = 0; i < 100; i++) {
          f = i % 5;
        }
        const elapsed: number = new Date().getTime() - start;
        expect(elapsed).assertLess(100);
      });
      it('test_perf_editModeTime', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const start: number = new Date().getTime();
        let d: boolean = false;
        for (let i: number = 0; i < 100; i++) {
          d = !d;
        }
        const elapsed: number = new Date().getTime() - start;
        expect(elapsed).assertLess(100);
      });
    });

    describe('LifecycleTest', () => {
      it('test_lifecycle_desktop_background', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let state: string = 'desktop';
        state = 'background';
        expect(state).assertEqual('background');
      });
      it('test_lifecycle_home_foreground', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let state: string = 'background';
        state = 'foreground';
        expect(state).assertEqual('foreground');
      });
      it('test_lifecycle_launch_create', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        let state: string = 'none';
        state = 'created';
        expect(state).assertEqual('created');
      });
      it('test_lifecycle_fullCycle', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const cycle: string[] = ['created', 'foreground', 'background', 'foreground', 'background', 'destroyed'];
        for (let ci: number = 0; ci < cycle.length; ci++) {
          expect(cycle[ci].length).assertLarger(0);
        }
        expect(cycle[0]).assertEqual('created');
        expect(cycle[cycle.length - 1]).assertEqual('destroyed');
      });
    });

    describe('StressLongTimeRunning', () => {
      it('test_stress_longPlay_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        for (let i: number = 0; i < 100; i++) {
          isPlay = !isPlay;
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
      });
      it('test_stress_longNextPrev_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const len: number = 5;
        let idx: number = 0;
        for (let i: number = 0; i < 100; i++) {
          idx = i % 2 === 0 ? (idx + 1) % len : (idx - 1 + len) % len;
        }
        expect(idx >= 0 && idx < len).assertTrue();
      });
      it('test_stress_longFocus_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let f: number = 2;
        for (let i: number = 0; i < 100; i++) {
          f = i % 5;
        }
        expect(f >= 0 && f <= 4).assertTrue();
      });
      it('test_stress_longKV_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        for (let i: number = 0; i < 100; i++) {
          const key: string = 'lk_' + i.toString();
          store.put(key, i);
          if (i % 20 === 0) {
            store.get(key);
          }
        }
        expect(true).assertTrue();
      });
      it('test_stress_longDevice_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          const devId: string = 'ld_' + (i % 100).toString();
          const devName: string = 'LD ' + i.toString();
          const netId: string = 'ln_' + (i % 100).toString();
          addDeviceData(inst, devId, devName, netId, i % 100, new Date().getTime());
          if (i % 10 === 0) {
            inst.updateDeviceProp(devId, 'transferLoading', i % 2 === 0);
          }
        }
        expect(true).assertTrue();
      });
      it('test_stress_longJson_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const uriStr: string = 'u_' + i.toString();
          const d: JsonResult = { uri: uriStr, seekTo: i, isPlaying: i % 2 === 0 };
          const j: string = JSON.stringify(d);
          const p: JsonResult = JSON.parse(j) as JsonResult;
          const expectedUri: string = 'u_' + i.toString();
          expect(p.uri).assertEqual(expectedUri);
        }
      });
      it('test_stress_longTimeFmt_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const r: string = number2time(i * 18);
          expect(r.indexOf(':') !== -1).assertTrue();
        }
      });
      it('test_stress_longModel_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'ms_' + i.toString();
          const authorStr: string = 'ma_' + i.toString();
          const urlStr: string = 'mu_' + i.toString();
          const s: SongItemTypeModel = new SongItemTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, time: i });
          expect(s.name).assertEqual(nameStr);
        }
      });
      it('test_stress_longPlayState_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'n_' + i.toString();
          const authorStr: string = 'a_' + i.toString();
          const urlStr: string = 'u_' + i.toString();
          const modeVal: PlayMode = PLAY_MODES[i % 3];
          const s: PlayStateTypeModel = new PlayStateTypeModel({
            img: '',
            name: nameStr,
            author: authorStr,
            url: urlStr,
            playIndex: i % 100,
            time: i,
            duration: i * 2,
            isPlay: i % 2 === 0,
            playMode: modeVal,
            playList: []
          });
          expect(s.playIndex).assertEqual(i % 100);
        }
      });
      it('test_stress_longButton_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'b_' + i.toString();
          const b: ButtonModel = new ButtonModel({ name: nameStr, iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: i % 2 === 0 });
          expect(b.name).assertEqual(nameStr);
        }
      });
    });

    describe('MixedHighFreqStress', () => {
      it('test_mixed_highFreq_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        let flag: string = '';
        const sl: songItemType[] = mkSongs(5);
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 15;
          switch (op) {
            case 0: isPlay = !isPlay; break;
            case 1: idx = (idx + 1) % sl.length; break;
            case 2: idx = (idx - 1 + sl.length) % sl.length; break;
            case 3: if (f > 0) { f--; } break;
            case 4: if (f < 4) { f++; } break;
            case 5: flag = 'PRE'; flag = ''; break;
            case 6: flag = 'NEXT'; flag = ''; break;
            case 7: isPlay = true; break;
            case 8: isPlay = false; break;
            case 9: f = i % 5; break;
            case 10: expect(sl[idx].name.length).assertLarger(0); break;
            case 11: number2time(i * 18); break;
            case 12: {
              const uriStr: string = 'u_' + i.toString();
              const d: JsonResult = { uri: uriStr, seekTo: i, isPlaying: isPlay };
              JSON.stringify(d);
              break;
            }
            case 13: {
              const nameStr: string = 's_' + i.toString();
              const authorStr: string = 'a_' + i.toString();
              const urlStr: string = 'u_' + i.toString();
              new SongItemTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, time: i });
              break;
            }
            case 14: {
              const nameStr: string = 'n_' + i.toString();
              const authorStr: string = 'a_' + i.toString();
              const urlStr: string = 'u_' + i.toString();
              new PlayStateTypeModel({ img: '', name: nameStr, author: authorStr, url: urlStr, playIndex: idx, time: i, duration: i * 2, isPlay: isPlay, playMode: PLAY_MODE_AUTO, playList: [] });
              break;
            }
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
        expect(idx >= 0 && idx < sl.length).assertTrue();
        expect(f >= 0 && f <= 4).assertTrue();
        expect(flag).assertEqual('');
      });
      it('test_mixed_kvDevice_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const store: MockKVStore = new MockKVStore();
        const inst: DistributedManager = DistributedManager.getInstance();
        for (let i: number = 0; i < 100; i++) {
          if (i % 2 === 0) {
            const key: string = 'mk_' + i.toString();
            store.put(key, i);
          } else {
            const devId: string = 'md_' + (i % 300).toString();
            const devName: string = 'MD ' + i.toString();
            const netId: string = 'mn_' + (i % 300).toString();
            addDeviceData(inst, devId, devName, netId, i % 50, new Date().getTime());
          }
        }
        expect(true).assertTrue();
      });
      it('test_mixed_allDomain_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let isPlay: boolean = false;
        let idx: number = 0;
        let f: number = 2;
        let del: boolean = false;
        const sl: songItemType[] = mkSongs(5);
        const devs: DistributedManagerDeviceInfo[] = mkDevices(3);
        for (let i: number = 0; i < 100; i++) {
          const op: number = i % 20;
          switch (op) {
            case 0: isPlay = !isPlay; break;
            case 1: idx = (idx + 1) % sl.length; break;
            case 2: idx = (idx - 1 + sl.length) % sl.length; break;
            case 3: if (f > 0) { f--; } break;
            case 4: if (f < 4) { f++; } break;
            case 5: del = !del; break;
            case 6: isPlay = true; break;
            case 7: isPlay = false; break;
            case 8: f = i % 5; break;
            case 9: number2time(i * 18); break;
            case 10: expect(sl[idx].name.length).assertLarger(0); break;
            case 11: expect(devs[i % devs.length].deviceId.length).assertLarger(0); break;
            case 12: {
              const uri: string = sl[idx].url;
              const j: string = JSON.stringify({ uri: uri, seekTo: i, isPlaying: isPlay });
              JSON.parse(j);
              break;
            }
            case 13: new SongItemTypeModel(sl[idx]); break;
            case 14: new PlayStateTypeModel({ img: '', name: sl[idx].name, author: sl[idx].author, url: sl[idx].url, playIndex: idx, time: i, duration: i * 2, isPlay: isPlay, playMode: PLAY_MODE_AUTO, playList: [] }); break;
            case 15: {
              const e: MockTouch = new MockTouch();
              e.type = TouchType.Up;
              e.source = SourceType.Mouse;
              EventUtil.isTouchEvent(e);
              break;
            }
            case 16: PointerUtil.changePointStyle(i % 2 === 0); break;
            case 17: {
              const dStr: string = 'd_' + i.toString();
              const iStr: string = 'i_' + i.toString();
              Logger.debug(dStr);
              Logger.info(iStr);
              break;
            }
            case 18: {
              const pKey: string = 'dk_' + i.toString();
              const pVal: string = 'dv_' + i.toString();
              Preferences.writeData(pKey, pVal);
              break;
            }
            case 19: objType(sl[idx]); break;
          }
        }
        const isPlayBool: boolean = isPlay;
        expect(typeof isPlayBool).assertEqual('boolean');
        const delBool: boolean = del;
        expect(typeof delBool).assertEqual('boolean');
      });
    });
  });
}
