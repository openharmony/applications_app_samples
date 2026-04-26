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

/**
 * Worker data flow contract tests.
 * Verifies folder aggregation, playable list projection, and navigation guards.
 */
interface LocalVideoRecord {
  uri?: string;
  url?: string;
  displayName?: string | Resource;
  createTime?: string;
  type?: string;
  defResolution?: string;
  deviceType?: number;
}

interface FolderCard {
  id: string;
  name: string;
  num: number;
  videoList: Array<LocalVideoRecord>;
}

interface UrlListLike {
  uri: string;
  url: string;
  type: string;
  displayName: string;
  defResolution: string;
  deviceType: number;
}

function normalizeLocalFolderPayload(videoList: Array<LocalVideoRecord>): Array<UrlListLike> {
  const urlList: Array<UrlListLike> = [];

  for (let i = 0; i < videoList.length; i++) {
    const item = videoList[i];
    urlList.push({
      uri: item.uri || '',
      url: typeof item.url === 'string' ? item.url : '',
      type: 'local',
      displayName: String(item.displayName || ''),
      defResolution: '720P',
      deviceType: item.deviceType || 0
    });
  }
  return urlList;
}

function mergeFolderCard(id: string, name: string, videoList: Array<LocalVideoRecord>): FolderCard {
  return {
    id,
    name,
    num: videoList.length,
    videoList
  };
}

function computeNextFocus(currentFocus: number, folderList: Array<FolderCard>): number {
  if (folderList.length === 0) {
    return 0;
  }
  if (currentFocus < 0 || currentFocus >= folderList.length) {
    return 0;
  }
  if (!folderList[currentFocus] || folderList[currentFocus].num === 0) {
    return 0;
  }
  return currentFocus;
}

/**
 * Playback preconditions after list aggregation.
 */
interface VideoAssetLike {
  uri?: string;
  url?: string;
  displayName?: string | Resource;
  deviceType?: number;
  licenseUri?: string;
  name?: string;
}

interface LocalPlayableLike {
  uri: string;
  url: string;
  type: string;
  displayName: string;
  defResolution: string;
  deviceType: number;
  resolutions: Array<string>;
}

interface HttpPlayableLike {
  uri: string;
  url: string;
  type: string;
  displayName: string;
  resolution: string;
  resolutions: Array<string>;
  licenseUri: string;
}

function normalizePlayableLocalList(videoList: Array<VideoAssetLike>): Array<LocalPlayableLike> {
  const result: Array<LocalPlayableLike> = [];
  for (let i = 0; i < videoList.length; i++) {
    const item = videoList[i];
    result.push({
      uri: item.uri || '',
      url: item.url || '',
      type: 'local',
      displayName: String(item.displayName || ''),
      defResolution: '720P',
      deviceType: item.deviceType || 0,
      resolutions: []
    });
  }
  return result;
}

function normalizePlayableHttpList(videoList: Array<VideoAssetLike>): Array<HttpPlayableLike> {
  const result: Array<HttpPlayableLike> = [];
  for (let i = 0; i < videoList.length; i++) {
    const item = videoList[i];
    result.push({
      uri: item.uri || '',
      url: item.url || '',
      type: 'http',
      displayName: String(item.name || ''),
      resolution: '1080P',
      resolutions: [],
      licenseUri: item.licenseUri || ''
    });
  }
  return result;
}

function canOpenFolder(isLoading: boolean, folderNum: number, isUSBEnable: boolean, focusId: number): boolean {
  if (!isUSBEnable && focusId === 1) {
    return false;
  }
  if (isLoading) {
    return false;
  }
  return folderNum > 0;
}

function canNavigateToPlayer(isNavigating: boolean, clickNow: number, now: number): boolean {
  if (isNavigating) {
    return false;
  }
  return now - clickNow >= 800;
}

export default function WorkerDataFlow001Test() {
  const casePrefixPart1 = 'DemandPlayer_WorkerDataFlow001_';
  const casePrefixPart2 = 'DemandPlayer_WorkerDataFlow002_';
  const part1CaseNames: Array<string> = [];
  const part2CaseNames: Array<string> = [];
  const addPart1Case = (name: string): string => {
    part1CaseNames.push(name);
    return name;
  };
  const addPart2Case = (name: string): string => {
    part2CaseNames.push(name);
    return name;
  };

  describe('WorkerDataFlow001TestSuite', () => {
    it(addPart1Case(casePrefixPart1 + 'FolderCard_CountMatchesVideos_001'), 0, () => {
      const videos: Array<LocalVideoRecord> = [
        { uri: 'file://a.mp4', displayName: 'a.mp4' },
        { uri: 'file://b.mp4', displayName: 'b.mp4' }
      ];
      const folder = mergeFolderCard('f_1', '????', videos);
      expect(folder.id).assertEqual('f_1');
      expect(folder.name).assertEqual('????');
      expect(folder.num).assertEqual(2);
      expect(folder.videoList.length).assertEqual(2);
    });

    it(addPart1Case(casePrefixPart1 + 'FolderCard_EmptyListSupported_002'), 0, () => {
      const folder = mergeFolderCard('f_3', 'USB??', []);
      expect(folder.num).assertEqual(0);
      expect(folder.videoList.length).assertEqual(0);
    });

    it(addPart1Case(casePrefixPart1 + 'NormalizeLocalFolderPayload_DefaultFields_003'), 0, () => {
      const payload = normalizeLocalFolderPayload([
        {
          uri: 'file://movie.mp4',
          url: 'file://movie.mp4',
          displayName: 'movie.mp4',
          deviceType: 1
        }
      ]);
      expect(payload.length).assertEqual(1);
      expect(payload[0].uri).assertEqual('file://movie.mp4');
      expect(payload[0].type).assertEqual('local');
      expect(payload[0].defResolution).assertEqual('720P');
      expect(payload[0].deviceType).assertEqual(1);
    });

    it(addPart1Case(casePrefixPart1 + 'NormalizeLocalFolderPayload_EmptyFallback_004'), 0, () => {
      const payload = normalizeLocalFolderPayload([
        {
          displayName: '',
          deviceType: undefined
        }
      ]);
      expect(payload[0].uri).assertEqual('');
      expect(payload[0].url).assertEqual('');
      expect(payload[0].displayName).assertEqual('');
      expect(payload[0].deviceType).assertEqual(0);
    });

    it(addPart1Case(casePrefixPart1 + 'ComputeNextFocus_ValidFocusPreserved_005'), 0, () => {
      const folderList: Array<FolderCard> = [
        mergeFolderCard('f_1', '????', [{ uri: '1' }]),
        mergeFolderCard('f_3', 'USB??', [{ uri: '2' }])
      ];
      expect(computeNextFocus(1, folderList)).assertEqual(1);
    });

    it(addPart1Case(casePrefixPart1 + 'ComputeNextFocus_NegativeReset_006'), 0, () => {
      const folderList: Array<FolderCard> = [
        mergeFolderCard('f_1', '????', [{ uri: '1' }])
      ];
      expect(computeNextFocus(-1, folderList)).assertEqual(0);
    });

    it(addPart1Case(casePrefixPart1 + 'ComputeNextFocus_OutOfRangeReset_007'), 0, () => {
      const folderList: Array<FolderCard> = [
        mergeFolderCard('f_1', '????', [{ uri: '1' }])
      ];
      expect(computeNextFocus(3, folderList)).assertEqual(0);
    });

    it(addPart1Case(casePrefixPart1 + 'ComputeNextFocus_EmptyTargetReset_008'), 0, () => {
      const folderList: Array<FolderCard> = [
        mergeFolderCard('f_1', '????', []),
        mergeFolderCard('f_3', 'USB??', [{ uri: '2' }])
      ];
      expect(computeNextFocus(0, folderList)).assertEqual(0);
    });

    it(addPart1Case(casePrefixPart1 + 'CaseNamePattern_009'), 0, () => {
      expect(part1CaseNames.length).assertEqual(9);
      for (let i = 0; i < part1CaseNames.length; i++) {
        expect(/^DemandPlayer_WorkerDataFlow001_[A-Za-z0-9_]+_[0-9]{3}$/.test(part1CaseNames[i])).assertEqual(true);
      }
    });
    it(addPart2Case(casePrefixPart2 + 'NormalizePlayableLocalList_FieldProjection_001'), 0, () => {
      const list = normalizePlayableLocalList([
        {
          uri: 'fd://10',
          url: 'fd://10',
          displayName: 'sample.mp4',
          deviceType: 6
        }
      ]);
      expect(list.length).assertEqual(1);
      expect(list[0].type).assertEqual('local');
      expect(list[0].displayName).assertEqual('sample.mp4');
      expect(list[0].defResolution).assertEqual('720P');
      expect(list[0].resolutions.length).assertEqual(0);
    });

    it(addPart2Case(casePrefixPart2 + 'NormalizePlayableLocalList_DefaultFallback_002'), 0, () => {
      const list = normalizePlayableLocalList([{}]);
      expect(list[0].uri).assertEqual('');
      expect(list[0].url).assertEqual('');
      expect(list[0].displayName).assertEqual('');
      expect(list[0].deviceType).assertEqual(0);
    });

    it(addPart2Case(casePrefixPart2 + 'NormalizePlayableHttpList_FieldProjection_003'), 0, () => {
      const list = normalizePlayableHttpList([
        {
          uri: 'net://a',
          url: 'https://example.com/a.mp4',
          name: '????',
          licenseUri: 'https://example.com/license'
        }
      ]);
      expect(list.length).assertEqual(1);
      expect(list[0].type).assertEqual('http');
      expect(list[0].displayName).assertEqual('????');
      expect(list[0].resolution).assertEqual('1080P');
      expect(list[0].licenseUri).assertEqual('https://example.com/license');
    });

    it(addPart2Case(casePrefixPart2 + 'NormalizePlayableHttpList_EmptyLicenseFallback_004'), 0, () => {
      const list = normalizePlayableHttpList([
        {
          name: 'NoLicense',
          url: 'https://example.com/no-license.mp4'
        }
      ]);
      expect(list[0].licenseUri).assertEqual('');
      expect(list[0].resolutions.length).assertEqual(0);
    });

    it(addPart2Case(casePrefixPart2 + 'CanOpenFolder_UsbDisabledBlocked_005'), 0, () => {
      expect(canOpenFolder(false, 10, false, 1)).assertEqual(false);
    });

    it(addPart2Case(casePrefixPart2 + 'CanOpenFolder_LoadingBlocked_006'), 0, () => {
      expect(canOpenFolder(true, 10, true, 0)).assertEqual(false);
    });

    it(addPart2Case(casePrefixPart2 + 'CanOpenFolder_EmptyFolderBlocked_007'), 0, () => {
      expect(canOpenFolder(false, 0, true, 0)).assertEqual(false);
    });

    it(addPart2Case(casePrefixPart2 + 'CanNavigateToPlayer_ThrottleAndBusyGuard_008'), 0, () => {
      expect(canNavigateToPlayer(true, 0, 900)).assertEqual(false);
      expect(canNavigateToPlayer(false, 1000, 1500)).assertEqual(false);
      expect(canNavigateToPlayer(false, 1000, 1800)).assertEqual(true);
    });

    it(addPart2Case(casePrefixPart2 + 'CaseNamePattern_009'), 0, () => {
      expect(part2CaseNames.length).assertEqual(9);
      for (let i = 0; i < part2CaseNames.length; i++) {
        expect(/^DemandPlayer_WorkerDataFlow002_[A-Za-z0-9_]+_[0-9]{3}$/.test(part2CaseNames[i])).assertEqual(true);
      }
    });
  });
}


