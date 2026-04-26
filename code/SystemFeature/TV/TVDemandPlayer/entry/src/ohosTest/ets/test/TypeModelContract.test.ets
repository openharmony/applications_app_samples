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
import {
  FoldListType,
  ArrayType,
  UrlType,
  ItemsType,
  VideoSettingBtnsType,
  VideoSize
} from '../../../main/ets/const/Type';
import { settingButton } from '../../../main/ets/const/SettingButton';
import { Constants } from '../../../main/ets/const/Constants';
import { DistributedEventCode } from '../../../main/ets/const/DistributedEventCode';

export default function TypeModelContract001Test() {
  const casePrefix = 'DemandPlayer_TypeModelContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('TypeModelContract001TestSuite', () => {
    it(addCase(casePrefix + 'FoldListType_DefaultFields_001'), 0, () => {
      const fold = new FoldListType();
      expect(fold.id).assertEqual('f_1');
      expect(fold.name).assertEqual('本地视频');
      expect(fold.num).assertEqual(0);
      expect(fold.videoList instanceof Array).assertEqual(true);
      expect(fold.videoList.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'FoldListType_MutableFields_002'), 0, () => {
      const fold = new FoldListType();
      fold.id = 'f_custom';
      fold.name = '在线视频';
      fold.num = 99;
      fold.videoList.push({ uri: 'test-uri', url: 'http://test', displayName: 'test.mp4' } as UrlType);
      expect(fold.id).assertEqual('f_custom');
      expect(fold.name).assertEqual('在线视频');
      expect(fold.num).assertEqual(99);
      expect(fold.videoList.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'ArrayType_GenericNumber_003'), 0, () => {
      const nums = new ArrayType<number>([1, 2, 3, 4, 5]);
      expect(nums.length).assertEqual(5);
      expect(nums[0]).assertEqual(1);
      expect(nums[4]).assertEqual(5);
      expect(nums instanceof Array).assertEqual(true);
    });

    it(addCase(casePrefix + 'ArrayType_GenericString_004'), 0, () => {
      const strs = new ArrayType<string>(['a', 'b', 'c']);
      expect(strs.length).assertEqual(3);
      expect(strs[1]).assertEqual('b');
      strs.push('d');
      expect(strs.length).assertEqual(4);
    });

    it(addCase(casePrefix + 'ArrayType_GenericObject_005'), 0, () => {
      const items: ItemsType[] = new ArrayType<ItemsType>([
        { id: 'i1', name: 'item-1', param: 1 },
        { id: 'i2', name: 'item-2', param: 2 }
      ]);
      expect(items.length).assertEqual(2);
      expect(items[0].name).assertEqual('item-1');
      expect(items[1].param).assertEqual(2);
    });

    it(addCase(casePrefix + 'UrlType_PartialInit_OptionalFields_006'), 0, () => {
      const url: UrlType = {};
      expect(url.uri).assertEqual(undefined);
      expect(url.url).assertEqual(undefined);
      expect(url.displayName).assertEqual(undefined);
      expect(url.resolution).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'UrlType_FullInit_AllFields_007'), 0, () => {
      const url: UrlType = {
        uri: 'media://video-123',
        url: 'http://cdn.example.com/video.mp4',
        type: 'video/mp4',
        name: 'BigBuckBunny',
        displayName: '大兔兔.mp4',
        resolution: '1920x1080',
        resolutions: [],
        licenseUri: 'http://license.example.com',
        createTime: '2024-01-01 10:00:00',
        deviceType: 1,
        intro: 'A sample video',
        img: $r('app.media.app_icon'),
        description: 'Test video description'
      };
      expect(url.uri).assertEqual('media://video-123');
      expect(url.deviceType).assertEqual(1);
      expect(url.intro).assertEqual('A sample video');
    });

    it(addCase(casePrefix + 'ItemsType_ThreeProperties_008'), 0, () => {
      const item: ItemsType = {
        id: 'setting-speed-2x',
        name: '2.0 X',
        val: '2.0',
        param: 2
      };
      expect(item.id).assertEqual('setting-speed-2x');
      expect(item.name).assertEqual('2.0 X');
      expect(item.val).assertEqual('2.0');
      expect(item.param).assertEqual(2);
    });

    it(addCase(casePrefix + 'ItemsType_OptionalVal_009'), 0, () => {
      const item: ItemsType = { id: 'minimal', name: 'minimal-name' };
      expect(item.id).assertEqual('minimal');
      expect(item.val).assertEqual(undefined);
      expect(item.param).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'VideoSettingBtnsType_Structure_010'), 0, () => {
      const btn: VideoSettingBtnsType = {
        id: 'resolution-btn',
        name: '分辨率',
        disable: false,
        items: [
          {
            id: 'r1',
            name: '4K',
            val: '3840x2160',
            param: 0
          },
          {
            id: 'r2',
            name: '1080P',
            val: '1920x1080',
            param: 1
          }
        ]
      };
      expect(btn.disable).assertEqual(false);
      expect(btn.items.length).assertEqual(2);
      expect(btn.items[0].name).assertEqual('4K');
    });

    it(addCase(casePrefix + 'VideoSettingBtnsType_DisabledFlag_011'), 0, () => {
      const btn: VideoSettingBtnsType = {
        id: 'audio-track-btn',
        name: '音轨',
        disable: true,
        items: []
      };
      expect(btn.disable).assertEqual(true);
      expect(btn.items.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'VideoSize_WidthHeight_012'), 0, () => {
      const size: VideoSize = { width: 1920, height: 1080 };
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'Constants_MouseClick_013'), 0, () => {
      expect(Constants.SOURCE_TOOL_MOUSE_CLICK).assertEqual(7);
    });

    it(addCase(casePrefix + 'SettingButton_LengthMatches_014'), 0, () => {
      expect(settingButton.length).assertEqual(5);
    });

    it(addCase(casePrefix + 'SettingButton_ResolutionItems_015'), 0, () => {
      const resolution = settingButton[0];
      expect(resolution.disable).assertEqual(false);
      expect(resolution.items.length).assertEqual(3);
      expect(resolution.items[0].name).assertEqual('4K');
      expect(resolution.items[0].val).assertEqual('3840x2160');
      expect(resolution.items[2].name).assertEqual('1080P');
    });

    it(addCase(casePrefix + 'SettingButton_SpeedItems_016'), 0, () => {
      const speed = settingButton[1];
      expect(speed.items.length).assertEqual(5);
      expect(speed.items[0].param).assertEqual(4);
      expect(speed.items[3].val).assertEqual('1.0');
      expect(speed.items[4].name).assertEqual('0.75 X');
    });

    it(addCase(casePrefix + 'SettingButton_AudioTrackItems_017'), 0, () => {
      const audioTrack = settingButton[3];
      expect(audioTrack.items.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'DistributedEventCode_StartCode_018'), 0, () => {
      expect(DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE).assertEqual(1);
    });

    it(addCase(casePrefix + 'DistributedEventCode_StopCode_019'), 0, () => {
      expect(DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE).assertEqual(16);
    });

    it(addCase(casePrefix + 'DistributedEventCode_TimeSyncCode_020'), 0, () => {
      expect(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_SET_TIME).assertEqual(15);
    });

    it(addCase(casePrefix + 'DistributedEventCode_PauseCode_021'), 0, () => {
      expect(DistributedEventCode.PAUSE_PLAYER_SERVICE).assertEqual(4);
    });

    it(addCase(casePrefix + 'ArrayType_InstanceofCheck_022'), 0, () => {
      const nums = new ArrayType<number>([10, 20]);
      expect(nums instanceof Array).assertEqual(true);
      expect(Array.isArray(nums)).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_023'), 0, () => {
      expect(allCaseNames.length).assertEqual(23);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_TypeModelContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
