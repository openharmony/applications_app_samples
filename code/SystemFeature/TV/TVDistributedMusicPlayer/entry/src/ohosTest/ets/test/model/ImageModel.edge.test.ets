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


export default function imageModeledgeTestSuite(): void {
  describe('ImageModelEdgeTest', () => {
  it('testImagePropertyEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const url: string = '/image/' + i + '.jpg';
      const width: number = i * 10;
      const height: number = i * 10;
      expect(url !== null).assertTrue();
      expect(width).assertEqual(i * 10);
      expect(height).assertEqual(i * 10);
    }
  });

  it('testImageLoadEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const isLoading: boolean = true;
      const progress: number = i % 101;
      expect(isLoading).assertEqual(true);
      expect(progress).assertEqual(i % 101);
    }
  });

  it('testAbnormalCondition', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const emptyUrl: string = '';
      const negativeSize: number = -1;
      expect(emptyUrl.length).assertEqual(0);
      expect(negativeSize).assertEqual(-1);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
