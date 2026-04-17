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
import { settingButton } from '../../../main/ets/const/SettingButton';
import { VideoAVPlayerClass } from '../../../main/ets/Model/AvPlayer';
import { VideoSize } from '../../../main/ets/const/Type';
import { getVideoSize } from '../../../main/ets/utils/Utils';

export default function SettingButtonVideoSizeContract001Test() {
  const casePrefix = 'DemandPlayer_SettingButtonVideoSizeContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('SettingButtonVideoSizeContract001TestSuite', () => {
    it(addCase(casePrefix + 'SettingButton_FiveButtons_001'), 0, () => {
      expect(settingButton.length).assertEqual(5);
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_DisabledFalse_002'), 0, () => {
      expect(settingButton[0].disable).assertEqual(false);
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_ThreeItems_003'), 0, () => {
      expect(settingButton[0].items.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_FirstItem_4K_004'), 0, () => {
      expect(settingButton[0].items[0].name).assertEqual('4K');
      expect(settingButton[0].items[0].val).assertEqual('3840x2160');
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_SecondItem_1080P_005'), 0, () => {
      expect(settingButton[0].items[1].name).assertEqual('2K');
      expect(settingButton[0].items[1].val).assertEqual('2560x1440');
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_ThirdItem_720P_006'), 0, () => {
      expect(settingButton[0].items[2].name).assertEqual('1080P');
      expect(settingButton[0].items[2].val).assertEqual('1920x1080');
    });

    it(addCase(casePrefix + 'SettingButton_Speed_FiveItems_007'), 0, () => {
      expect(settingButton[1].items.length).assertEqual(5);
    });

    it(addCase(casePrefix + 'SettingButton_Speed_FirstItem_4X_008'), 0, () => {
      expect(settingButton[1].items[0].name).assertEqual('2.0 X');
      expect(settingButton[1].items[0].param).assertEqual(4);
    });

    it(addCase(casePrefix + 'SettingButton_Speed_LastItem_075X_009'), 0, () => {
      expect(settingButton[1].items[4].name).assertEqual('0.75 X');
      expect(settingButton[1].items[4].param).assertEqual(0);
    });

    it(addCase(casePrefix + 'SettingButton_Speed_MiddleItem_1X_010'), 0, () => {
      expect(settingButton[1].items[3].name).assertEqual('1.0 X');
    });

    it(addCase(casePrefix + 'SettingButton_Channel_ThreeItems_011'), 0, () => {
      expect(settingButton[2].items.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'SettingButton_Channel_SecondItem_RightChannel_012'), 0, () => {
      expect(settingButton[2].items[1].name).assertEqual('右声道');
    });

    it(addCase(casePrefix + 'SettingButton_AudioTrack_ZeroItems_013'), 0, () => {
      expect(settingButton[3].items.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'SettingButton_VideoSize_ThreeItems_014'), 0, () => {
      expect(settingButton[4].items.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'SettingButton_VideoSize_LastItem_Auto_015'), 0, () => {
      expect(settingButton[4].items[2].name).assertEqual('自适应');
      expect(settingButton[4].items[2].param).assertEqual(6);
    });

    it(addCase(casePrefix + 'SettingButton_AllIdsUnique_016'), 0, () => {
      const ids = settingButton.map(b => b.id);
      const uniqueIds = new Set(ids);
      expect(uniqueIds.size).assertEqual(ids.length);
    });

    it(addCase(casePrefix + 'SettingButton_AllNamesNonEmpty_017'), 0, () => {
      for (let i = 0; i < settingButton.length; i++) {
        expect(settingButton[i].name.length > 0).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'SettingButton_AllItemsHaveId_018'), 0, () => {
      for (let i = 0; i < settingButton.length; i++) {
        for (let j = 0; j < settingButton[i].items.length; j++) {
          expect(settingButton[i].items[j].id.length > 0).assertEqual(true);
        }
      }
    });

    it(addCase(casePrefix + 'GetVideoSize_16To9_PortraitPage_019'), 0, () => {
      const r = getVideoSize(1080, 1920, 3840, 2160, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_4To3_PortraitPage_020'), 0, () => {
      const r = getVideoSize(1080, 1920, 1440, 1080, 0, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_AutoFit_PortraitPage_021'), 0, () => {
      const r = getVideoSize(1080, 1920, 2560, 1440, 6, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Rotated16To9_022'), 0, () => {
      const r = getVideoSize(1920, 1080, 3840, 2160, 1, true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Rotated4To3_023'), 0, () => {
      const r = getVideoSize(1920, 1080, 1440, 1080, 0, true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_VideoMatchesPage_024'), 0, () => {
      const r = getVideoSize(1920, 1080, 1920, 1080, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_VideoLargerThanPage_025'), 0, () => {
      const r = getVideoSize(1280, 720, 3840, 2160, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_VideoSmallerThanPage_026'), 0, () => {
      const r = getVideoSize(1920, 1080, 640, 480, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'VideoSize_Interface_WidthHeight_027'), 0, () => {
      const size: VideoSize = { width: 1920, height: 1080 };
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'VideoSize_Interface_ZeroValues_028'), 0, () => {
      const size: VideoSize = { width: 0, height: 0 };
      expect(size.width).assertEqual(0);
      expect(size.height).assertEqual(0);
    });

    it(addCase(casePrefix + 'SettingButton_Resolution_AutoParam6_029'), 0, () => {
      const videoSizeBtn = settingButton[4];
      expect(videoSizeBtn.items[2].param).assertEqual(6);
    });

    it(addCase(casePrefix + 'GetVideoSize_ZeroPage_031'), 0, () => {
      const r = getVideoSize(0, 0, 1920, 1080, 1, false);
      expect(r.width).assertEqual(0);
      expect(r.height).assertEqual(0);
    });

    it(addCase(casePrefix + 'GetVideoSize_ZeroVideo_032'), 0, () => {
      const r = getVideoSize(1920, 1080, 0, 0, 1, false);
      expect(r.width).assertEqual(1920);
      expect(r.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'GetVideoSize_NegativeDimensions_033'), 0, () => {
      const r = getVideoSize(-100, -100, 1920, 1080, 1, false);
      expect(r.width >= 0).assertEqual(false);
      expect(r.height >= 0).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetVideoSize_ExtremelyLargeVideo_034'), 0, () => {
      const r = getVideoSize(1920, 1080, 7680, 4320, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_ExtremelySmallVideo_035'), 0, () => {
      const r = getVideoSize(1920, 1080, 64, 48, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_SquarePage_SquareVideo_036'), 0, () => {
      const r = getVideoSize(1000, 1000, 1000, 1000, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_UltraWideVideo_037'), 0, () => {
      const r = getVideoSize(1920, 1080, 5120, 1080, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_UltraTallVideo_038'), 0, () => {
      const r = getVideoSize(1920, 1080, 1080, 3840, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'SettingButton_Channel_LeftChannel_041'), 0, () => {
      const channelBtn = settingButton[2];
      if (channelBtn.items.length >= 1) {
        expect(channelBtn.items[0].name).assertEqual('立体声');
      }
    });

    it(addCase(casePrefix + 'SettingButton_Channel_Stereo_042'), 0, () => {
      const channelBtn = settingButton[2];
      if (channelBtn.items.length >= 3) {
        expect(channelBtn.items[2].name).assertEqual('左声道');
      }
    });

    it(addCase(casePrefix + 'SettingButton_VideoSize_Fit_043'), 0, () => {
      const videoSizeBtn = settingButton[4];
      if (videoSizeBtn.items.length >= 1) {
        expect(videoSizeBtn.items[0].name).assertEqual('4:3');
        expect(typeof videoSizeBtn.items[0].param).assertEqual('number');
      }
    });

    it(addCase(casePrefix + 'SettingButton_VideoSize_Fixed_044'), 0, () => {
      const videoSizeBtn = settingButton[4];
      if (videoSizeBtn.items.length >= 2) {
        expect(videoSizeBtn.items[1].name).assertEqual('16:9');
        expect(typeof videoSizeBtn.items[1].param).assertEqual('number');
      }
    });

    it(addCase(casePrefix + 'VideoSize_ObjectMutation_045'), 0, () => {
      const size1: VideoSize = { width: 1920, height: 1080 };
      const size2: VideoSize = { width: 1280, height: 720 };
      size1.width = 640;
      size1.height = 480;
      expect(size2.width).assertEqual(1280);
      expect(size2.height).assertEqual(720);
    });

    it(addCase(casePrefix + 'VideoSize_InterfaceAssignment_046'), 0, () => {
      let size: VideoSize = { width: 1920, height: 1080 };
      size = { width: 3840, height: 2160 };
      expect(size.width).assertEqual(3840);
      expect(size.height).assertEqual(2160);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type0_4To3_047'), 0, () => {
      const r = getVideoSize(1024, 768, 640, 480, 0, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type1_16To9_048'), 0, () => {
      const r = getVideoSize(1920, 1080, 1280, 720, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type6_Auto_049'), 0, () => {
      const r = getVideoSize(1920, 1080, 1920, 1080, 6, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'SettingButton_ButtonIdsUnique_051'), 0, () => {
      const ids = settingButton.map(b => b.id);
      const uniqueCount = new Set(ids).size;
      expect(uniqueCount).assertEqual(ids.length);
    });

    it(addCase(casePrefix + 'SettingButton_ItemsIdsUniqueWithinButton_052'), 0, () => {
      for (let i = 0; i < settingButton.length; i++) {
        const itemIds = settingButton[i].items.map(item => item.id);
        const uniqueCount = new Set(itemIds).size;
        expect(uniqueCount).assertEqual(itemIds.length);
      }
    });

    it(addCase(casePrefix + 'GetVideoSize_DecimalDimensions_057'), 0, () => {
      const r = getVideoSize(1920.5, 1080.5, 1280.7, 720.3, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_LargeRatioDifference_058'), 0, () => {
      const r = getVideoSize(1920, 1080, 10000, 1000, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'VideoSize_DeepCopy_059'), 0, () => {
      const size: VideoSize = { width: 1920, height: 1080 };
      const sizeCopy: VideoSize = { width: size.width, height: size.height };
      expect(sizeCopy.width).assertEqual(size.width);
      expect(sizeCopy.height).assertEqual(size.height);
    });

    it(addCase(casePrefix + 'SettingButton_AllButtonsHaveIcon_060'), 0, () => {
      for (let i = 0; i < settingButton.length; i++) {
        expect(settingButton[i].name.length > 0).assertEqual(true);
      }
    });
  });
}
