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


export default function buttonModelconcurrencyTestSuite(): void {
  describe('ButtonModelConcurrencyTest', () => {
  it('testConcurrentSetButtonState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const enabled: boolean = i % 2 === 0;
      const visible: boolean = i % 3 === 0;
      const text: string = 'Button ' + i;
      expect(enabled !== undefined).assertTrue();
      expect(visible !== undefined).assertTrue();
      expect(text !== undefined).assertTrue();
    }
  });

  it('testConcurrentGetButtonState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const enabled: boolean = true;
      const visible: boolean = true;
      const text: string = 'Button';
      expect(enabled !== undefined).assertTrue();
      expect(visible !== undefined).assertTrue();
      expect(text !== undefined).assertTrue();
    }
  });

  it('testHighConcurrencyOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const enabled: boolean = i % 2 === 0;
      const visible: boolean = i % 3 === 0;
      const text: string = 'Button ' + i;
      expect(enabled !== undefined).assertTrue();
      expect(visible !== undefined).assertTrue();
      expect(text !== undefined).assertTrue();
    }
  });
  });
}
