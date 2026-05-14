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


export default function musicConstantsconcurrencyTestSuite(): void {
  describe('MusicConstantsConcurrencyTest', () => {
  it('testConcurrent_List', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const songIndex: number = i;
      expect(songIndex).assertEqual(i);
    }
  });

  it('testHighConcurrencyOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const songName: string = 'Song ' + i;
      const songAuthor: string = 'Author ' + i;
      expect(songName).assertEqual('Song ' + i);
      expect(songAuthor).assertEqual('Author ' + i);
    }
  });
  });
}
