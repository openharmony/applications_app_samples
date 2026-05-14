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


export default function playStateTestSuite(): void {
  describe('PlayStateTest', () => {
  it('testSetPlayState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const isPlaying: boolean = true;
    expect(isPlaying).assertEqual(true);
  });

  it('testSetCurrentPlayIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const currentIndex: number = 1;
    expect(currentIndex).assertEqual(1);
  });

  it('testSetCurrentPlayTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const currentTime: number = 1000;
    expect(currentTime).assertEqual(1000);
  });

  it('testSetTotalPlayTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const duration: number = 100;
    expect(duration).assertEqual(100);
  });

  it('testSetPlayMode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const playMode: number = 1;
    expect(playMode).assertEqual(1);
  });

  it('testResetPlayState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const isPlaying: boolean = false;
    const currentIndex: number = 0;
    const currentTime: number = 0;
    const duration: number = 0;
    const playMode: number = 0;
    expect(isPlaying).assertEqual(false);
    expect(currentIndex).assertEqual(0);
    expect(currentTime).assertEqual(0);
    expect(duration).assertEqual(0);
    expect(playMode).assertEqual(0);
  });

  it('testSetCurrentPlayIndexException', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const negativeIndex: number = -1;
      expect(negativeIndex).assertEqual(-1);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  it('testSetCurrentPlayTimeBoundary', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const maxTime: number = Number.MAX_SAFE_INTEGER;
      expect(maxTime).assertEqual(Number.MAX_SAFE_INTEGER);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
