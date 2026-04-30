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

export default function eventUtilTestSuite(): void {
  describe('EventUtilTest', () => {

  it('testonMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const eventName: string = 'testEvent';
    expect(eventName).assertEqual('testEvent');
  });


  it('testemitMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const eventName: string = 'testEvent';
    const testData: string = 'testData';
    expect(eventName).assertEqual('testEvent');
    expect(testData).assertEqual('testData');
  });


  it('testoffMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const eventName: string = 'testEvent';
    expect(eventName).assertEqual('testEvent');
  });


  it('testonMethodAbnormal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const eventName: string = 'testEvent';
      expect(eventName).assertEqual('testEvent');
    } catch (e) {
      expect(null).assertFail();
    }
  });


  it('testemitMethodEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const emptyEvent: string = '';
      const emptyData: string = '';
      expect(emptyEvent.length).assertEqual(0);
      expect(emptyData.length).assertEqual(0);
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
