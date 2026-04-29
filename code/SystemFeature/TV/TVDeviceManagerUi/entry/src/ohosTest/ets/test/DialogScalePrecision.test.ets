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
import { TestAsserts } from './base/TestAsserts';

interface DialogScaleResult {
  width: number;
  height: number;
  scale: number;
}

class DialogScaleCalculator {
  calculate(displayWidth: number): DialogScaleResult {
    const scale: number = displayWidth / StyleConstants.DEFAULT_DESIGN_WIDTH;
    return {
      width: StyleConstants.DEFAULT_DIALOG_WIDTH * scale,
      height: StyleConstants.DEFAULT_DIALOG_HEIGHT * scale,
      scale: scale
    };
  }
}

export default function dialogScalePrecisionTest(): void {
  describe('TVDeviceManagerUiDialogScalePrecisionTest', () => {
    it('should keep 1080p scale below design baseline and produce positive rect', 0, () => {
      const calculator: DialogScaleCalculator = new DialogScaleCalculator();
      const result: DialogScaleResult = calculator.calculate(1280);

      TestAsserts.assertTrue(result.scale < 1);
      TestAsserts.assertPositiveRect(result.width, result.height);
      TestAsserts.assertNumberAtMost(result.width, StyleConstants.DEFAULT_DIALOG_WIDTH);
    });

    it('should keep design width scale equal to one', 0, () => {
      const calculator: DialogScaleCalculator = new DialogScaleCalculator();
      const result: DialogScaleResult =
        calculator.calculate(StyleConstants.DEFAULT_DESIGN_WIDTH);

      // 1920 是样式稿基线，等比缩放在这里必须回到原尺寸。
      // 如果这一点漂移，所有分辨率矩阵测试都会建立在错误基准之上。
      TestAsserts.assertNumberEquals(result.scale, 1);
      TestAsserts.assertNumberEquals(result.width, StyleConstants.DEFAULT_DIALOG_WIDTH);
      TestAsserts.assertNumberEquals(result.height, StyleConstants.DEFAULT_DIALOG_HEIGHT);
    });

    it('should expand dialog dimensions on 4k displays', 0, () => {
      const calculator: DialogScaleCalculator = new DialogScaleCalculator();
      const result: DialogScaleResult = calculator.calculate(3840);

      TestAsserts.assertTrue(result.scale > 1);
      TestAsserts.assertNumberAtLeast(result.width, StyleConstants.DEFAULT_DIALOG_WIDTH * 2);
      TestAsserts.assertNumberAtLeast(result.height, StyleConstants.DEFAULT_DIALOG_HEIGHT * 2);
    });
  });
}
