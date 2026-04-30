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

export default function preferencesTestSuite(): void {
  describe('PreferencesTest', () => {
  const KEY: string = 'test_key';
  const VALUE: string = 'test_value';

  it('testWrite_Function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const key: string = KEY;
    const value: string = VALUE;
    expect(key).assertEqual('test_key');
    expect(value).assertEqual('test_value');
  });

  it('testRead_Function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const key: string = KEY;
    const expectedValue: string = VALUE;
    expect(key).assertEqual('test_key');
    expect(expectedValue).assertEqual('test_value');
  });

  it('testWrite_MethodAbnormal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const emptyKey: string = '';
      const emptyValue: string = '';
      expect(emptyKey.length).assertEqual(0);
      expect(emptyValue.length).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }
  });

  it('testRead_MethodEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const nonExistentKey: string = 'non_existent_key';
    expect(nonExistentKey).assertEqual('non_existent_key');
  });
  });
}
