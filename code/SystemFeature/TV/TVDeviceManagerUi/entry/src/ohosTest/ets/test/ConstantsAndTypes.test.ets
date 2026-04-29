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

import { describe, it } from '@ohos/hypium';
import { StyleConstants } from '../../../main/ets/common/constants/StyleConstants';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import { TestAsserts } from './base/TestAsserts';

export default function constantsAndTypesTest(): void {
  describe('TVDeviceManagerUiConstantsAndTypesTest', () => {
    it('should keep style constants stable for tv dialog baseline', 0, () => {
      TestAsserts.assertStringEquals(StyleConstants.DEFAULT_BG_COLOR, '#404040');
      TestAsserts.assertStringEquals(StyleConstants.DEFAULT_BUTTON_COLOR, '#666666');
      TestAsserts.assertNumberEquals(StyleConstants.DEFAULT_DESIGN_WIDTH, 1920);
      TestAsserts.assertNumberEquals(StyleConstants.DEFAULT_DIALOG_WIDTH, 692);
      TestAsserts.assertNumberEquals(StyleConstants.DEFAULT_DIALOG_HEIGHT, 332);
    });

    it('should expose tv remote key codes used by dialogs', 0, () => {
      TestAsserts.assertNumberEquals(KeyCode.KEY_BACK, 2);
      TestAsserts.assertNumberEquals(KeyCode.KEY_DPAD_UP, 2012);
      TestAsserts.assertNumberEquals(KeyCode.KEY_DPAD_DOWN, 2013);
      TestAsserts.assertNumberEquals(KeyCode.KEY_DPAD_LEFT, 2014);
      TestAsserts.assertNumberEquals(KeyCode.KEY_DPAD_RIGHT, 2015);
      TestAsserts.assertNumberEquals(KeyCode.KEY_ENTER, 2054);
    });

    it('should expose contiguous number key codes for numeric input', 0, () => {
      const codes: number[] = [
        KeyCode.KEY_0,
        KeyCode.KEY_1,
        KeyCode.KEY_2,
        KeyCode.KEY_3,
        KeyCode.KEY_4,
        KeyCode.KEY_5,
        KeyCode.KEY_6,
        KeyCode.KEY_7,
        KeyCode.KEY_8,
        KeyCode.KEY_9
      ];
      TestAsserts.assertMonotonicIncrease(codes);
      TestAsserts.assertNumberEquals(codes[0], 2000);
      TestAsserts.assertNumberEquals(codes[9], 2009);
    });
  });
}
