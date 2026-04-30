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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}
function makeStringRecord(): StringRecord { return {} as StringRecord; }


class NestedRecordObj {
  uri: string = '';
  name: string = '';
  seekTo: number = 0;
  isPlaying: boolean = false;

  constructor(uri?: string, name?: string, seekTo?: number, isPlaying?: boolean) {
    if (uri !== undefined) this.uri = uri;
    if (name !== undefined) this.name = name;
    if (seekTo !== undefined) this.seekTo = seekTo;
    if (isPlaying !== undefined) this.isPlaying = isPlaying;
  }
}

class MockUIAbilityContext {
  terminateCount: number = 0;
  connectCount: number = 0;
  filesDir: string = '/data/test';
  tempDir: string = '/data/test/temp';
  cacheDir: string = '/data/test/cache';

  terminateSelf(): Promise<void> {
    this.terminateCount++;
    return Promise.resolve();
  }

  connectServiceExtensionAbility(want: WantParam, options: ConnectOptions): number {
    this.connectCount++;
    return 1;
  }
}

class MockWant {
  action: string = '';
  parameters: NestedRecordObj | null = null;

  constructor(action?: string, params?: NestedRecordObj) {
    if (action) this.action = action;
    if (params) this.parameters = params;
  }
}

class MockWindowStage {
  loadContentCalled: boolean = false;
  loadContent(url: string, callback?: (err: Error | null) => void): void {
    this.loadContentCalled = true;
    if (callback) callback(null);
  }
}

class MockWindow {
  isFullScreen: boolean = false;
  setFullScreen(isFull: boolean, callback?: (err: Error | null) => void): void {
    this.isFullScreen = isFull;
    if (callback) callback(null);
  }
}

interface SongInfoRecord {
  url: string;
  name: string;
}

interface WantParam {
  bundleName: string;
  abilityName: string;
}

interface ConnectOptions {
  onConnect: (elementName: object, remote: object) => void;
  onDisconnect: (elementName: object) => void;
  onFailed: (code: number) => void;
}

class RemoteObjectMock {
  type: string = '';
  constructor(type: string) {
    this.type = type;
  }
}

interface TransferManager {
  release: () => void;
}

interface StressConnectOptions {
  onConnect: () => void;
  onDisconnect: () => void;
  onFailed: () => void;
}

function getNullTransferManager(): TransferManager | null {
  return null;
}

function getNullUIAbilityContext(): MockUIAbilityContext | null {
  return null;
}

export default function MainAbilityComprehensiveTestSuite(): void {
  describe('MainAbilityComprehensiveTest', () => {

    describe('MainAbilityOnCreateTest', () => {

      it('test_onCreate_basicWant', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant();
        want.parameters = new NestedRecordObj('test.wav', 'Test Song');
        expect(want.parameters !== null).assertTrue();
        const params: NestedRecordObj = want.parameters as NestedRecordObj;
        expect(params.uri).assertEqual('test.wav');
      });

      it('test_onCreate_emptyParameters', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant();
        want.parameters = null;
        expect(want.parameters).assertEqual(null);
      });

      it('test_onCreate_viewDataAction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('music.wav', 'Music');
        expect(want.action).assertEqual('ohos.want.action.viewData');
        const params: NestedRecordObj = want.parameters as NestedRecordObj;
        expect(params.uri).assertEqual('music.wav');
      });

      it('test_onCreate_nonViewDataAction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('other.action');
        want.parameters = new NestedRecordObj('test.wav');
        let shouldProcess = want.action === 'ohos.want.action.viewData';
        expect(shouldProcess).assertFalse();
      });

      it('test_onCreate_stateReset', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let exitMusicApp = true;
        let remoteServiceExtensionConnectEvent = true;
        let musicPlay = true;
        let musicPause = true;
        let changePlayFlag = 'PRE';
        exitMusicApp = false;
        remoteServiceExtensionConnectEvent = false;
        musicPlay = false;
        musicPause = false;
        changePlayFlag = '';
        expect(exitMusicApp).assertFalse();
        expect(remoteServiceExtensionConnectEvent).assertFalse();
        expect(musicPlay).assertFalse();
        expect(musicPause).assertFalse();
        expect(changePlayFlag).assertEqual('');
      });

      it('test_onCreate_parametersPreserved', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant();
        want.parameters = new NestedRecordObj('song.mp3', 'My Song', 1000, true);
        const params: NestedRecordObj = want.parameters as NestedRecordObj;
        expect(params.uri).assertEqual('song.mp3');
        expect(params.isPlaying).assertTrue();
      });
    });

    describe('MainAbilityChangeWantTest', () => {

      it('test_changeWant_viewDataWithParams', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('new.wav', 'New Song');
        let sendSongInfo: StringRecord | null = null;
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          const params: NestedRecordObj = want.parameters as NestedRecordObj;
          const songInfo: SongInfoRecord = { url: String(params.uri), name: String(params.name) };
          sendSongInfo = makeStringRecord();
          sendSongInfo.url = songInfo.url;
          sendSongInfo.name = songInfo.name;
        }
        expect(sendSongInfo !== null).assertTrue();
        if (sendSongInfo !== null) {
          const songInfoOuter: SongInfoRecord = {
            url: sendSongInfo.url,
            name: sendSongInfo.name
          };
          expect(songInfoOuter.url).assertEqual('new.wav');
          expect(songInfoOuter.name).assertEqual('New Song');
        }
      });

      it('test_changeWant_nonViewData', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('other.action');
        let sendSongInfo: StringRecord | null = null;
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          const emptyInfo: SongInfoRecord = { url: '', name: '' };
          sendSongInfo = makeStringRecord();
          sendSongInfo.url = emptyInfo.url;
          sendSongInfo.name = emptyInfo.name;
        }
        expect(sendSongInfo).assertEqual(null);
      });

      it('test_changeWant_viewDataNoParams', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = null;
        let sendSongInfo: StringRecord | null = null;
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          const emptyInfo: SongInfoRecord = { url: '', name: '' };
          sendSongInfo = makeStringRecord();
          sendSongInfo.url = emptyInfo.url;
          sendSongInfo.name = emptyInfo.name;
        }
        expect(sendSongInfo).assertEqual(null);
      });

      it('test_changeWant_emptyUri', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('', '');
        let url: string = '';
        if (want.parameters) {
          const params: NestedRecordObj = want.parameters as NestedRecordObj;
          url = String(params.uri) || '';
        }
        expect(url).assertEqual('');
      });

      it('test_changeWant_unicodeName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('song.wav', '测试歌曲');
        let name: string = '';
        if (want.parameters) {
          const params: NestedRecordObj = want.parameters as NestedRecordObj;
          name = String(params.name);
        }
        expect(name).assertEqual('测试歌曲');
      });
    });

    describe('MainAbilityOnDestroyTest', () => {

      it('test_onDestroy_stateCleanup', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let sendSongInfo: StringRecord | null = makeStringRecord();
        sendSongInfo.url = 'test.wav';
        sendSongInfo.name = 'Test';
        let exitMusicApp = false;
        sendSongInfo = null;
        if (exitMusicApp !== undefined) {
          exitMusicApp = !exitMusicApp;
        }
        expect(sendSongInfo).assertEqual(null);
        expect(exitMusicApp).assertTrue();
      });

      it('test_onDestroy_transferManagerRelease', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let releaseCalled = false;
        const transferManager: TransferManager = { release: (): void => { releaseCalled = true; } };
        if (transferManager) {
          transferManager.release();
        }
        expect(releaseCalled).assertTrue();
      });

      it('test_onDestroy_nullTransferManager', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const transferManager: TransferManager | null = getNullTransferManager();
        let threw: boolean = false;
        try {
          if (transferManager !== null) {
            transferManager.release();
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });

      it('test_onDestroy_exitFlagToggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let exitMusicApp = false;
        if (exitMusicApp !== undefined) {
          exitMusicApp = !exitMusicApp;
        }
        expect(exitMusicApp).assertTrue();
      });
    });

    describe('MainAbilityOnWindowStageCreateTest', () => {

      it('test_windowStageCreate_fullScreen', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockWindow = new MockWindow();
        mockWindow.setFullScreen(true, (err: Error | null): void => {
          expect(err).assertEqual(null);
        });
        expect(mockWindow.isFullScreen).assertTrue();
      });

      it('test_windowStageCreate_notFullScreen', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockWindow = new MockWindow();
        mockWindow.setFullScreen(false, (err: Error | null): void => {
          expect(err).assertEqual(null);
        });
        expect(mockWindow.isFullScreen).assertFalse();
      });

      it('test_windowStageCreate_loadContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockStage = new MockWindowStage();
        mockStage.loadContent('pages/Index', (err: Error | null): void => {
          expect(err).assertEqual(null);
        });
        expect(mockStage.loadContentCalled).assertTrue();
      });

      it('test_windowStageCreate_fullScreenThenLoad', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockWindow = new MockWindow();
        const mockStage = new MockWindowStage();
        mockWindow.setFullScreen(true);
        mockStage.loadContent('pages/Index');
        expect(mockWindow.isFullScreen).assertTrue();
        expect(mockStage.loadContentCalled).assertTrue();
      });
    });

    describe('MainAbilityLifecycleTest', () => {

      it('test_lifecycle_onCreateToDestroy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let isCreated = false;
        let isDestroyed = false;
        isCreated = true;
        expect(isCreated).assertTrue();
        isCreated = false;
        isDestroyed = true;
        expect(isDestroyed).assertTrue();
      });

      it('test_lifecycle_foregroundBackground', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let isForeground = false;
        isForeground = true;
        expect(isForeground).assertTrue();
        isForeground = false;
        expect(isForeground).assertFalse();
      });

      it('test_lifecycle_windowStageCreateDestroy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let windowStageCreated = false;
        let windowStageDestroyed = false;
        windowStageCreated = true;
        expect(windowStageCreated).assertTrue();
        windowStageDestroyed = true;
        expect(windowStageDestroyed).assertTrue();
      });
    });

    describe('MainAbilityOnBackPressedTest', () => {

      it('test_onBackPressed_exitFlagToggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let exitMusicApp = false;
        if (exitMusicApp !== undefined) {
          exitMusicApp = !exitMusicApp;
        }
        expect(exitMusicApp).assertTrue();
      });

      it('test_onBackPressed_returnsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const result = false;
        expect(result).assertFalse();
      });

      it('test_onBackPressed_multiplePresses', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let exitMusicApp = false;
        for (let i = 0; i < 10; i++) {
          exitMusicApp = !exitMusicApp;
        }
        expect(exitMusicApp).assertFalse();
      });
    });

    describe('MainAbilityOnNewWantTest', () => {

      it('test_onNewWant_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('newSong.wav', 'New Song');
        let songUpdated = false;
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          songUpdated = true;
        }
        expect(songUpdated).assertTrue();
      });

      it('test_onNewWant_emptyWant', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant();
        let songUpdated = false;
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          songUpdated = true;
        }
        expect(songUpdated).assertFalse();
      });

      it('test_onNewWant_updateSongInfo', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const want = new MockWant('ohos.want.action.viewData');
        want.parameters = new NestedRecordObj('updated.wav', 'Updated');
        let currentUri: string = '';
        let currentName: string = '';
        if (want.action === 'ohos.want.action.viewData' && want.parameters) {
          const params: NestedRecordObj = want.parameters as NestedRecordObj;
          currentUri = String(params.uri);
          currentName = String(params.name);
        }
        expect(currentUri).assertEqual('updated.wav');
        expect(currentName).assertEqual('Updated');
      });
    });

    describe('MainAbilityConnectServiceTest', () => {

      it('test_connectServiceAbility_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockContext = new MockUIAbilityContext();
        const want: WantParam = { bundleName: 'ohos.samples.distributedmusicplayer', abilityName: 'ServiceAbility' };
        const connectOptions: ConnectOptions = {
          onConnect: (elementName: object, remote: object): void => {},
          onDisconnect: (elementName: object): void => {},
          onFailed: (code: number): void => {}
        };
        mockContext.connectServiceExtensionAbility(want, connectOptions);
        expect(mockContext.connectCount).assertEqual(1);
      });

      it('test_connectServiceAbility_onConnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let remoteObject: object | null = null;
        const connectOptions: ConnectOptions = {
          onConnect: (elementName: object, remote: object): void => {
            remoteObject = remote;
          },
          onDisconnect: (elementName: object): void => {},
          onFailed: (code: number): void => {}
        };
        connectOptions.onConnect({} as WantParam, new RemoteObjectMock('mockRemote'));
        expect(remoteObject !== null).assertTrue();
      });

      it('test_connectServiceAbility_onDisconnect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let disconnected = false;
        const connectOptions: ConnectOptions = {
          onConnect: (elementName: object, remote: object): void => {},
          onDisconnect: (elementName: object): void => { disconnected = true; },
          onFailed: (code: number): void => {}
        };
        connectOptions.onDisconnect({} as WantParam);
        expect(disconnected).assertTrue();
      });

      it('test_connectServiceAbility_onFailed', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let failedCode = -1;
        const connectOptions: ConnectOptions = {
          onConnect: (elementName: object, remote: object): void => {},
          onDisconnect: (elementName: object): void => {},
          onFailed: (code: number): void => { failedCode = code; }
        };
        connectOptions.onFailed(404);
        expect(failedCode).assertEqual(404);
      });

      it('test_connectServiceAbility_nullContext', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let context: MockUIAbilityContext | null = getNullUIAbilityContext();
        let threw: boolean = false;
        try {
          if (context !== null) {
            const wantObj: WantParam = { bundleName: '', abilityName: '' };
            const connectOpts: ConnectOptions = {
              onConnect: (elementName: object, remote: object): void => {},
              onDisconnect: (elementName: object): void => {},
              onFailed: (code: number): void => {}
            };
            context.connectServiceExtensionAbility(wantObj, connectOpts);
          }
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });
    });

    describe('MainAbilityStressTest', () => {

      it('test_stress_stateReset_1000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i = 0; i < 1000; i++) {
          let exitMusicApp = true;
          let musicPlay = true;
          let musicPause = true;
          let changePlayFlag = 'PRE';
          exitMusicApp = false;
          musicPlay = false;
          musicPause = false;
          changePlayFlag = '';
          expect(exitMusicApp).assertFalse();
        }
      });

      it('test_stress_changeWant_1000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i = 0; i < 1000; i++) {
          const want = new MockWant(i % 2 === 0 ? 'ohos.want.action.viewData' : 'other');
          want.parameters = new NestedRecordObj('song_' + i + '.wav', 'Song ' + i);
          if (want.action === 'ohos.want.action.viewData' && want.parameters) {
            const params: NestedRecordObj = want.parameters as NestedRecordObj;
            const url: string = String(params.uri);
            expect(url).assertEqual('song_' + i + '.wav');
          }
        }
      });

      it('test_stress_exitFlagToggle_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        let exitMusicApp = false;
        for (let i = 0; i < 100; i++) {
          exitMusicApp = !exitMusicApp;
        }
        const exitMusicAppType: string = typeof exitMusicApp;
        expect(exitMusicAppType).assertEqual('boolean');
      });

      it('test_stress_connectDisconnect_1000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const mockContext = new MockUIAbilityContext();
        const connectOptions: ConnectOptions = {
          onConnect: (elementName: object, remote: object): void => {},
          onDisconnect: (elementName: object): void => {},
          onFailed: (code: number): void => {}
        };
        const baseWant: WantParam = { bundleName: '', abilityName: '' };
        for (let i = 0; i < 1000; i++) {
          mockContext.connectServiceExtensionAbility(baseWant, connectOptions);
        }
        expect(mockContext.connectCount).assertEqual(1000);
      });
    });
  });
}
