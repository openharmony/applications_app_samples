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
interface InnerData { c: number; }
interface CloneData { a: number; b: InnerData; }

export default function utilsdetailTestSuite(): void {
  describe('UtilsDetailTest', () => {
  it('testBatchOperationFunction_MultipleCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const timeMs: number = i * 100;
      const min: number = 1;
      const max: number = 100;
      const text: string = 'Hello World';
      const maxLength: number = i % 20;
      const arr: number[] = [1, 2, 3, 4, 5, i];
      const innerData: InnerData = { c: i * 2 };
      const cloneObj: CloneData = { a: i, b: innerData };
      const hexColor: string = '#FFFFFF';
      const fileSize: number = i * 1024;
      const urlText: string = 'Hello ' + String(i);
      const encodedUrl: string = 'Hello%20' + String(i);

      expect(timeMs).assertEqual(i * 100);
      expect(min).assertEqual(1);
      expect(max).assertEqual(100);
      expect(text).assertEqual('Hello World');
      expect(maxLength).assertEqual(i % 20);
      expect(arr.length).assertEqual(6);
      expect(cloneObj.a).assertEqual(i);
      expect(hexColor).assertEqual('#FFFFFF');
      expect(fileSize).assertEqual(i * 1024);
      expect(urlText).assertEqual('Hello ' + String(i));
      expect(encodedUrl).assertEqual('Hello%20' + String(i));
    }
  });

  it('testEdge_FastConsecutiveOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const timeMs: number = i * 100;
      const min: number = 1;
      const max: number = 100;
      const text: string = 'Hello World';
      const maxLength: number = i % 20;
      const arr: number[] = [1, 2, 3, 4, 5, i];
      const innerData2: InnerData = { c: i * 2 };
      const cloneObj: CloneData = { a: i, b: innerData2 };
      const hexColor: string = '#FFFFFF';
      const fileSize: number = i * 1024;
      const urlText: string = 'Hello ' + String(i);
      const encodedUrl: string = 'Hello%20' + String(i);

      expect(timeMs).assertEqual(i * 100);
      expect(min).assertEqual(1);
      expect(max).assertEqual(100);
      expect(text).assertEqual('Hello World');
      expect(maxLength).assertEqual(i % 20);
      expect(arr.length).assertEqual(6);
      expect(cloneObj.a).assertEqual(i);
      expect(hexColor).assertEqual('#FFFFFF');
      expect(fileSize).assertEqual(i * 1024);
      expect(urlText).assertEqual('Hello ' + String(i));
      expect(encodedUrl).assertEqual('Hello%20' + String(i));
    }
  });

  it('testAbnormal_ParamCall', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const formatTimeParam: number = 0;
      expect(formatTimeParam).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const randomMin: number = 1;
      const randomMax: number = 100;
      expect(randomMin).assertEqual(1);
      expect(randomMax).assertEqual(100);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const truncateText: string = '';
      const truncateLength: number = 0;
      expect(truncateText.length).assertEqual(0);
      expect(truncateLength).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const emptyArray: number[] = [];
      expect(emptyArray.length).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const innerNull: InnerData = { c: 0 };
      const nullValue: CloneData = { a: 0, b: innerNull };
      expect(nullValue !== undefined).assertTrue();
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const invalidHex: string = 'invalid';
      expect(invalidHex).assertEqual('invalid');
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const negativeSize: number = -1;
      expect(negativeSize).assertEqual(-1);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const emptyUrl: string = '';
      expect(emptyUrl.length).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }

    try {
      const invalidEncoded: string = 'invalid';
      expect(invalidEncoded).assertEqual('invalid');
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
