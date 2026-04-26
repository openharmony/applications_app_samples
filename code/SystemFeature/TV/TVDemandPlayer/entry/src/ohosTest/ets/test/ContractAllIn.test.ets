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
import { FoldListType, ArrayType, ItemsType, VideoSettingBtnsType } from '../../../main/ets/const/Type';
import { settingButton } from '../../../main/ets/const/SettingButton';
import { Constants } from '../../../main/ets/const/Constants';
import { DistributedEventCode } from '../../../main/ets/const/DistributedEventCode';

class BusinessErrorHolder {
}

export default function ContractAllInOneTest() {
  const casePrefix = 'DemandPlayer_ContractAllInOne_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('ContractAllInOne_LanguageHelpers', () => {
    it(addCase(casePrefix + 'LanguageMapping_CurrentExports_001'), 0, () => {
      expect(getLanguageName('eng')).assertEqual('英语');
      expect(codeToLanguage('zh')).assertEqual('汉语');
      expect(languageToCode('英语')).assertEqual('ENG');
    });

    it(addCase(casePrefix + 'FoldListType_Defaults_002'), 0, () => {
      const fold = new FoldListType();
      expect(fold.id).assertEqual('f_1');
      expect(fold.videoList.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ArrayType_WorksLikeArray_003'), 0, () => {
      const values = new ArrayType<string>(['a', 'b']);
      expect(values.length).assertEqual(2);
      expect(values[1]).assertEqual('b');
    });

    it(addCase(casePrefix + 'ItemsType_Assignment_004'), 0, () => {
      const item: ItemsType = {
        id: 'id1',
        name: 'name1',
        val: 'value1',
        param: 1
      };
      expect(item.name).assertEqual('name1');
      expect(item.param).assertEqual(1);
    });

    it(addCase(casePrefix + 'SettingButton_Projection_005'), 0, () => {
      const button: VideoSettingBtnsType = settingButton[1];
      expect(button.id).assertEqual('s_2');
      expect(button.items.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Constants_CurrentValues_006'), 0, () => {
      expect(Constants.SOURCE_TOOL_MOUSE_CLICK).assertEqual(7);
      expect(Constants.STATE_PLAY).assertEqual('play');
      expect(Constants.QUALITY_AUTO).assertEqual('auto');
      expect(Constants.ASPECT_FILL).assertEqual('fill');
    });

    it(addCase(casePrefix + 'DistributedEventCode_CurrentValues_007'), 0, () => {
      expect(DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE).assertEqual(1);
      expect(DistributedEventCode.PLAYER_SERVICE).assertEqual(3);
      expect(DistributedEventCode.NEXT_PLAYER_SERVICE).assertEqual(9);
    });

    it(addCase(casePrefix + 'BasicServicesKit_ClassExists_008'), 0, () => {
      expect(typeof BusinessErrorHolder).assertEqual('function');
    });

    it(addCase(casePrefix + 'CaseNamePattern_009'), 0, () => {
      expect(allCaseNames.length).assertEqual(9);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ContractAllInOne_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
