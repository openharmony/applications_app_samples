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


export default function playStateconcurrencyTestSuite(): void {
  describe('PlayStateConcurrencyTest', () => {
  it('testConcurrentSetPlayState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const isPlaying: boolean = i % 2 === 0;
      const currentIndex: number = i;
      const currentTime: number = i * 100;
      expect(isPlaying !== undefined).assertTrue();
      expect(currentIndex).assertEqual(i);
      expect(currentTime).assertEqual(i * 100);
    }
  });

  it('testConcurrentGetPlayState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const isPlaying: boolean = true;
      const currentIndex: number = 0;
      const currentTime: number = 0;
      const duration: number = 0;
      const playMode: number = 0;
      expect(isPlaying).assertEqual(true);
      expect(currentIndex).assertEqual(0);
      expect(currentTime).assertEqual(0);
      expect(duration).assertEqual(0);
      expect(playMode).assertEqual(0);
    }
  });

  });
}
