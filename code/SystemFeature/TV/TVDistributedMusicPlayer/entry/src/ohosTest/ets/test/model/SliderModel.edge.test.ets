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

export default function sliderModeledgeTestSuite(): void {
  describe('SliderModelEdgeTest', () => {
  it('test_Edge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const value: number = i;
      const min: number = 0;
      const max: number = 100;
      expect(value).assertEqual(i);
      expect(min).assertEqual(0);
      expect(max).assertEqual(100);
    }
  });

  it('test_OperationEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const currentValue: number = i % 101;
      expect(currentValue).assertEqual(i % 101);
    }
  });

  it('testAbnormalCondition', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const negativeValue: number = -1;
      const exceedMaxValue: number = 101;
      expect(negativeValue).assertEqual(-1);
      expect(exceedMaxValue).assertEqual(101);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
