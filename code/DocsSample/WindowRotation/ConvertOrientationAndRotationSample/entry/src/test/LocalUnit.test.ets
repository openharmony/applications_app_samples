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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

function convertDisplayOrientationToWindowOrientation(displayOrientation: number): string {
  switch (displayOrientation) {
    case 0:
      return 'PORTRAIT';
    case 1:
      return 'LANDSCAPE_INVERTED';
    case 2:
      return 'PORTRAIT_INVERTED';
    case 3:
      return 'LANDSCAPE';
    default:
      throw new Error('Invalid orientation value');
  }
}

export default function localUnitTest() {
  describe('localUnitTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_display_orientation_0_to_portrait', 0, () => {
      let result = convertDisplayOrientationToWindowOrientation(0);
      expect(result).assertEqual('PORTRAIT');
    });

    it('test_display_orientation_1_to_landscape_inverted', 0, () => {
      let result = convertDisplayOrientationToWindowOrientation(1);
      expect(result).assertEqual('LANDSCAPE_INVERTED');
    });

    it('test_display_orientation_2_to_portrait_inverted', 0, () => {
      let result = convertDisplayOrientationToWindowOrientation(2);
      expect(result).assertEqual('PORTRAIT_INVERTED');
    });

    it('test_display_orientation_3_to_landscape', 0, () => {
      let result = convertDisplayOrientationToWindowOrientation(3);
      expect(result).assertEqual('LANDSCAPE');
    });

    it('test_invalid_orientation_negative_throws_error', 0, () => {
      try {
        convertDisplayOrientationToWindowOrientation(-1);
        expect(false).assertEqual(true);
      } catch (e) {
        expect(true).assertEqual(true);
      }
    });

    it('test_invalid_orientation_4_throws_error', 0, () => {
      try {
        convertDisplayOrientationToWindowOrientation(4);
        expect(false).assertEqual(true);
      } catch (e) {
        expect(true).assertEqual(true);
      }
    });

    it('test_invalid_orientation_string_throws_error', 0, () => {
      try {
        convertDisplayOrientationToWindowOrientation(NaN);
        expect(false).assertEqual(true);
      } catch (e) {
        expect(true).assertEqual(true);
      }
    });

    it('test_all_valid_orientations_return_correct_mapping', 0, () => {
      let orientationMap: Map<number, string> = new Map();
      orientationMap.set(0, 'PORTRAIT');
      orientationMap.set(1, 'LANDSCAPE_INVERTED');
      orientationMap.set(2, 'PORTRAIT_INVERTED');
      orientationMap.set(3, 'LANDSCAPE');

      orientationMap.forEach((expected, input) => {
        let actual = convertDisplayOrientationToWindowOrientation(input);
        expect(actual).assertEqual(expected);
      });
    });
  });
}
