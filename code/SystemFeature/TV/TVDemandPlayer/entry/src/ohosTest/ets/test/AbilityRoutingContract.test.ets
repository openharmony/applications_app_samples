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

interface UrlTypeLike {
  uri?: string;
  url?: string;
  type?: string;
  displayName?: string;
  name?: string;
  resolution?: string;
  resolutions?: string[];
  createTime?: string;
  deviceType?: number;
}

interface WantLikeParameters {
  startBy?: string;
  videoIndex?: number | string;
  currentTime?: number | string;
  isPlay?: boolean;
  sourceDeviceId?: string;
  videoList?: string | UrlTypeLike[];
  subtitles?: string[];
  startByLauncher?: boolean;
  startByOther?: boolean;
  uri?: string;
  url?: string;
  type?: string;
  name?: string;
}

interface WantLike {
  action?: string;
  type?: string;
  parameters?: WantLikeParameters;
}

interface StartStateLike {
  isTransferData: boolean;
  startByLauncher: boolean;
  startByOther: boolean;
  startByFileMgr: boolean;
  isPlay: boolean;
  videoIndex: number;
  currentTime: number;
  sourceDeviceId: string;
  videoList: UrlTypeLike[];
  subtitleUrl: string;
  fdPath: string;
  videoUri: string;
}

interface AbilityLifecycleSnapshot {
  videoPlayInitialized: boolean;
  videoPauseInitialized: boolean;
  deviceType: string;
  videoIndex: number;
  playCounter: number;
}

interface LoadContentDecision {
  loadContentUrl: string;
  shouldStartScan: boolean;
  shouldGrantPermission: boolean;
}

const FILE_MANAGER_ACTION = 'ohos.want.action.viewData';
const BUNDLE_NAME = 'com.ohos.demandplayer';

function createDefaultStartState(): StartStateLike {
  return {
    isTransferData: false,
    startByLauncher: false,
    startByOther: false,
    startByFileMgr: false,
    isPlay: true,
    videoIndex: 0,
    currentTime: 0,
    sourceDeviceId: '',
    videoList: [],
    subtitleUrl: '',
    fdPath: '',
    videoUri: ''
  };
}

function parseStartWant(want: WantLike): StartStateLike {
  const state = createDefaultStartState();
  const params = want.parameters;
  if (params === undefined) {
    return state;
  }

  if (params.startBy === BUNDLE_NAME) {
    state.isTransferData = true;
    state.videoIndex = Number(params.videoIndex || 0);
    state.currentTime = Number(params.currentTime || 0);
    state.isPlay = params.isPlay === false ? false : true;
    state.sourceDeviceId = String(params.sourceDeviceId || '');
    const videoListText = String(params.videoList || '[]');
    state.videoList = JSON.parse(videoListText) as UrlTypeLike[];
  }

  if (params.startByLauncher) {
    state.startByLauncher = true;
    state.videoIndex = Number(params.videoIndex || 0);
    state.videoList = [{
      uri: String(params.uri || ''),
      url: String(params.url || ''),
      type: String(params.type || 'http'),
      displayName: String(params.name || ''),
      resolution: '1080P',
      resolutions: []
    }];
  }

  if (params.startByOther && Array.isArray(params.videoList)) {
    state.startByOther = true;
    state.videoList = params.videoList.map((item: UrlTypeLike): UrlTypeLike => {
      const filePath = String(item.url || '');
      return {
        uri: 'fd://' + filePath,
        url: 'fd://' + filePath,
        displayName: item.name || '',
        resolution: '1080P',
        resolutions: [],
        createTime: '',
        type: 'local',
        deviceType: 1
      };
    });
  }

  const fileUri = String(params.uri || '');
  if (want.action === FILE_MANAGER_ACTION && fileUri !== '') {
    state.startByFileMgr = true;
    state.videoUri = fileUri;
    state.fdPath = 'fd://' + fileUri;
    state.videoList = [{
      uri: state.fdPath,
      url: state.fdPath,
      displayName: String(params.name || ''),
      resolution: '1080P',
      resolutions: [],
      createTime: '',
      type: 'local'
    }];
  }

  if (params.subtitles !== undefined && params.subtitles.length > 0) {
    state.subtitleUrl = params.subtitles[0];
  }
  return state;
}

function resolveLoadContentUrl(state: StartStateLike): string {
  if (state.isTransferData || state.startByLauncher || state.startByOther || state.startByFileMgr) {
    return 'pages/VideoPlayer';
  }
  return 'pages/Index';
}

function shouldTreatAsNewVideoRequest(want: WantLike): boolean {
  const params = want.parameters;
  if (params === undefined) {
    return false;
  }
  return params.videoList !== undefined || want.type === 'video/*' || params.uri !== undefined;
}

function createAbilityLifecycleSnapshot(softwareModel: string): AbilityLifecycleSnapshot {
  return {
    videoPlayInitialized: true,
    videoPauseInitialized: true,
    deviceType: softwareModel.toLowerCase().startsWith('tv') ? 'tv' : 'default',
    videoIndex: 0,
    playCounter: 0
  };
}

function decideWindowStageLoad(
  isTransferData: boolean,
  startByLauncher: boolean,
  startByOther: boolean,
  startByFileMgr: boolean,
  deviceType: string,
  hasTransferManager: boolean
): LoadContentDecision {
  return {
    loadContentUrl: (isTransferData || startByLauncher || startByOther || startByFileMgr) ? 'pages/VideoPlayer' :
      'pages/Index',
    shouldStartScan: hasTransferManager,
    shouldGrantPermission: deviceType === 'default'
  };
}

export default function AbilityRoutingContractTest() {
  const casePrefix = 'DemandPlayer_AbilityRoutingContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('AbilityRoutingContract_CoreRules', () => {
    it(addCase(casePrefix + 'ParseTransferWant_001'), 0, () => {
      const state = parseStartWant({
        parameters: {
          startBy: BUNDLE_NAME,
          videoIndex: 2,
          currentTime: 8800,
          isPlay: false,
          sourceDeviceId: 'remote-1',
          videoList: '[{"url":"https://example.com/a.mp4","displayName":"A"}]'
        }
      });
      expect(state.isTransferData).assertEqual(true);
      expect(state.videoIndex).assertEqual(2);
      expect(state.isPlay).assertEqual(false);
      expect(state.videoList.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'ParseLauncherWant_002'), 0, () => {
      const state = parseStartWant({
        parameters: {
          startByLauncher: true,
          url: 'https://example.com/b.mp4',
          name: 'B.mp4'
        }
      });
      expect(state.startByLauncher).assertEqual(true);
      expect(state.videoList[0].url).assertEqual('https://example.com/b.mp4');
      expect(state.videoList[0].displayName).assertEqual('B.mp4');
    });

    it(addCase(casePrefix + 'ParseOtherWant_003'), 0, () => {
      const state = parseStartWant({
        parameters: {
          startByOther: true,
          videoList: [{ url: '/data/video/c.mp4', name: 'C.mp4' }]
        }
      });
      expect(state.startByOther).assertEqual(true);
      expect(state.videoList[0].uri).assertEqual('fd:///data/video/c.mp4');
    });

    it(addCase(casePrefix + 'ParseFileManagerWant_004'), 0, () => {
      const state = parseStartWant({
        action: FILE_MANAGER_ACTION,
        parameters: { uri: '/data/video/d.mp4', name: 'D.mp4' }
      });
      expect(state.startByFileMgr).assertEqual(true);
      expect(state.fdPath).assertEqual('fd:///data/video/d.mp4');
    });

    it(addCase(casePrefix + 'ResolveLoadContentUrl_005'), 0, () => {
      const state = parseStartWant({ parameters: { startByLauncher: true } });
      expect(resolveLoadContentUrl(state)).assertEqual('pages/VideoPlayer');
      expect(resolveLoadContentUrl(createDefaultStartState())).assertEqual('pages/Index');
    });

    it(addCase(casePrefix + 'LifecycleSnapshot_007'), 0, () => {
      const snapshot = createAbilityLifecycleSnapshot('tv-model');
      expect(snapshot.deviceType).assertEqual('tv');
      expect(snapshot.playCounter).assertEqual(0);
    });

    it(addCase(casePrefix + 'WindowStageDecision_008'), 0, () => {
      const decision = decideWindowStageLoad(true, false, false, false, 'default', true);
      expect(decision.loadContentUrl).assertEqual('pages/VideoPlayer');
      expect(decision.shouldStartScan).assertEqual(true);
      expect(decision.shouldGrantPermission).assertEqual(true);
    });
  });
}
