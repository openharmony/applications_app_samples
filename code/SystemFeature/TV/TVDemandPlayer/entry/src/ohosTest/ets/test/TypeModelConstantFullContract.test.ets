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
import { getLanguageName, languageToCode, codeToLanguage } from '../../../main/ets/utils/LanguageCodeUtil';
import { FoldListType, ArrayType, ItemsType, VideoSettingBtnsType, VideoSize } from '../../../main/ets/const/Type';
import { settingButton } from '../../../main/ets/const/SettingButton';
import { Constants } from '../../../main/ets/const/Constants';
import { DistributedEventCode } from '../../../main/ets/const/DistributedEventCode';
import { secToStr, getTimeStr, getVideoSize, objType, isVideoFile } from '../../../main/ets/utils/Utils';

export default function TypeModelConstantFullContract001Test() {
  const casePrefix = 'DemandPlayer_TypeModelConstantFullContract001_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('TypeModelConstantFullContract001TestSuite', () => {
    it(addCase(casePrefix + 'FoldListType_DefaultValues_001'), 0, () => {
      const fold = new FoldListType();
      expect(fold.id).assertEqual('f_1');
      expect(fold.name).assertEqual('本地视频');
      expect(fold.num).assertEqual(0);
      expect(fold.videoList.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ArrayType_NumberAccess_002'), 0, () => {
      const arr = new ArrayType<number>([1, 2, 3]);
      expect(arr.length).assertEqual(3);
      expect(arr[0]).assertEqual(1);
      expect(arr[2]).assertEqual(3);
    });

    it(addCase(casePrefix + 'ItemsType_Assignment_003'), 0, () => {
      const item: ItemsType = {
        id: 'i1',
        name: '速度',
        val: '1.0',
        param: 1
      };
      expect(item.id).assertEqual('i1');
      expect(item.name).assertEqual('速度');
      expect(item.param).assertEqual(1);
    });

    it(addCase(casePrefix + 'VideoSettingBtnsType_FromSettingButton_004'), 0, () => {
      const button: VideoSettingBtnsType = settingButton[0];
      expect(button.id).assertEqual('s_1');
      expect(button.disable).assertEqual(false);
      expect(button.items.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'VideoSize_CanBeAssigned_005'), 0, () => {
      const size: VideoSize = { width: 1920, height: 1080 };
      expect(size.width).assertEqual(1920);
      expect(size.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'LanguageHelpers_CurrentImplementation_006'), 0, () => {
      expect(getLanguageName('eng')).assertEqual('英语');
      expect(codeToLanguage('zh')).assertEqual('汉语');
      expect(languageToCode('英语')).assertEqual('ENG');
    });

    it(addCase(casePrefix + 'GetVideoSize_ReturnsPositive_008'), 0, () => {
      const size = getVideoSize(1920, 1080, 1920, 1080, 1, false);
      expect(size.width > 0).assertEqual(true);
      expect(size.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Constants_CurrentExports_009'), 0, () => {
      expect(Constants.STATE_IDLE).assertEqual('idle');
      expect(Constants.QUALITY_AUTO).assertEqual('auto');
      expect(Constants.ASPECT_FIT).assertEqual('fit');
      expect(Constants.SOURCE_TOOL_REMOTE_CLICK).assertEqual(6);
    });

    it(addCase(casePrefix + 'DistributedEventCode_CurrentExports_010'), 0, () => {
      expect(DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE).assertEqual(1);
      expect(DistributedEventCode.PLAYER_SERVICE).assertEqual(3);
      expect(DistributedEventCode.PRE_PLAYER_SERVICE).assertEqual(8);
      expect(DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE).assertEqual(16);
    });

    it(addCase(casePrefix + 'CaseNamePattern_011'), 0, () => {
      expect(allCaseNames.length).assertEqual(10);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_TypeModelConstantFullContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
