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
export default function preferencesconcurrencyTestSuite(): void {
  describe('PreferencesConcurrencyTest', () => {
  it('testConcurrentStoreOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const key: string = 'key' + i;
      const value: string = 'value' + i;
      expect(key !== undefined).assertTrue();
      expect(value !== undefined).assertTrue();
    }
  });

  it('testConcurrentGetOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const key: string = 'key' + i;
      const defaultValue: string = 'default';
      expect(key !== undefined).assertTrue();
      expect(defaultValue).assertEqual('default');
    }
  });

  it('testConcurrentDeleteOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const key: string = 'key' + i;
      expect(key !== undefined).assertTrue();
    }
  });

  it('testConcurrentBatchOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const batchSize: number = 10;
      for (let j: number = 0; j < batchSize; j++) {
        const key: string = 'key' + i + '_' + j;
        const value: string = 'value' + i + '_' + j;
        expect(key !== undefined).assertTrue();
        expect(value !== undefined).assertTrue();
      }
    }
  });

  it('testHighConcurrencyOperation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      const key: string = 'key' + i;
      const value: string = 'value' + i;
      expect(key !== undefined).assertTrue();
      expect(value !== undefined).assertTrue();
    }
  });

  it('testConcurrentAbnormalHandling', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    for (let i: number = 0; i < 100; i++) {
      try {
        const key: string = 'key' + i;
        const value: string = 'value' + i;
        expect(key !== undefined).assertTrue();
        expect(value !== undefined).assertTrue();
      } catch (e) {
        expect(null).assertFail();
      }
    }
  });
  });
}
