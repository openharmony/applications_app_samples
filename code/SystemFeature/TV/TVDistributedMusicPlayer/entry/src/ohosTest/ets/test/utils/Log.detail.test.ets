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

export default function logdetailTestSuite(): void {
  describe('LogDetailTest', () => {

  it('test_Validation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const tag: string = 'TestTag';
    const message: string = 'Test message';
    expect(tag).assertEqual('TestTag');
    expect(message).assertEqual('Test message');
  });

  it('test_Level', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const debugMsg: string = 'Debug';
    const infoMsg: string = 'Info';
    const warnMsg: string = 'Warn';
    const errorMsg: string = 'Error';

    expect(debugMsg).assertEqual('Debug');
    expect(infoMsg).assertEqual('Info');
    expect(warnMsg).assertEqual('Warn');
    expect(errorMsg).assertEqual('Error');
  });

  it('test_1', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    let longMessage: string = '';
    for (let i: number = 0; i < 100; i++) {
      longMessage = longMessage + 'A';
    }
    expect(longMessage.length).assertEqual(100);
  });

  it('test_2', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const specialMsg: string = '!@#$%^&*()';
    expect(specialMsg.length).assertEqual(10);
  });
  });
}
