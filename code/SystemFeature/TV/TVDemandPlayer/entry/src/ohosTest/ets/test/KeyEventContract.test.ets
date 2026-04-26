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
import { KeyCode } from '@kit.InputKit';

enum KeyType {
  Cancel = 0,
  Down = 1,
  Up = 2,
}

export default function KeyEventContract001Test() {
  const casePrefix = 'DemandPlayer_KeyEventContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('KeyEventContract001TestSuite', () => {
    it(addCase(casePrefix + 'KeyCode_Tab_IsTabKey_001'), 0, () => {
      expect(KeyCode.KEYCODE_TAB).assertEqual(2049);
    });

    it(addCase(casePrefix + 'KeyCode_DPadLeft_IsLeft_002'), 0, () => {
      expect(KeyCode.KEYCODE_DPAD_LEFT).assertEqual(2014);
    });

    it(addCase(casePrefix + 'KeyCode_DPadRight_IsRight_003'), 0, () => {
      expect(KeyCode.KEYCODE_DPAD_RIGHT).assertEqual(2015);
    });

    it(addCase(casePrefix + 'KeyCode_DPadUp_IsUp_004'), 0, () => {
      expect(KeyCode.KEYCODE_DPAD_UP).assertEqual(2012);
    });

    it(addCase(casePrefix + 'KeyCode_DPadDown_IsDown_005'), 0, () => {
      expect(KeyCode.KEYCODE_DPAD_DOWN).assertEqual(2013);
    });

    it(addCase(casePrefix + 'KeyCode_Unknown_IsDefined_006'), 0, () => {
      expect(KeyCode.KEYCODE_UNKNOWN).assertEqual(-1);
    });

    it(addCase(casePrefix + 'KeyCode_Back_IsBackKey_007'), 0, () => {
      expect(KeyCode.KEYCODE_BACK).assertEqual(2);
    });

    it(addCase(casePrefix + 'KeyCode_Home_IsHomeKey_008'), 0, () => {
      expect(KeyCode.KEYCODE_HOME).assertEqual(1);
    });

    it(addCase(casePrefix + 'KeyCode_VolumeUp_009'), 0, () => {
      expect(KeyCode.KEYCODE_VOLUME_UP >= 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyCode_VolumeDown_010'), 0, () => {
      expect(KeyCode.KEYCODE_VOLUME_DOWN >= 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyCode_MediaPlay_011'), 0, () => {
      expect(KeyCode.KEYCODE_MEDIA_PLAY >= 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyCode_MediaPause_012'), 0, () => {
      expect(KeyCode.KEYCODE_MEDIA_PAUSE >= 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'KeyType_Down_Exists_013'), 0, () => {
      expect(KeyType.Down).assertEqual(1);
    });

    it(addCase(casePrefix + 'KeyType_Up_Exists_014'), 0, () => {
      expect(KeyType.Up).assertEqual(2);
    });

    it(addCase(casePrefix + 'KeyType_Cancel_Exists_015'), 0, () => {
      expect(KeyType.Cancel).assertEqual(0);
    });

    it(addCase(casePrefix + 'CaseNamePattern_016'), 0, () => {
      expect(allCaseNames.length).assertEqual(16);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_KeyEventContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
