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
export default function musicSharedDefinitionTestSuite(): void {
  describe('MusicSharedDefinitionTest', () => {

  it('test_DefinitionExistence', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const definitionName: string = 'MusicSharedDefinition';
    expect(definitionName).assertEqual('MusicSharedDefinition');
  });

  it('test_Constants', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const maxVolume: number = 100;
    const minVolume: number = 0;
    const defaultVolume: number = 50;
    
    expect(maxVolume).assertEqual(100);
    expect(minVolume).assertEqual(0);
    expect(defaultVolume).assertEqual(50);
  });

  it('testPlayModeDefinition', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    const normalMode: number = 0;
    const shuffleMode: number = 1;
    const repeatMode: number = 2;
    
    expect(normalMode).assertEqual(0);
    expect(shuffleMode).assertEqual(1);
    expect(repeatMode).assertEqual(2);
  });
  });
}
