/*
* Copyright (c) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start mockPrivateFunc_sample]
import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

class ClassName {
  constructor() {
  }
  method(arg: number):number {
    return this.method_1(arg);
  }
  private method_1(arg: number) {
    return arg;
  }
}

export default function staticTest() {
  describe('privateTest', () => {
    it('private_001', 0, () => {
      let claser: ClassName = new ClassName(); 
      let really_result = claser.method(123);
      expect(really_result).assertEqual(123);
      // 1.创建MockKit对象
      let mocker: MockKit = new MockKit();
      // 2.Mock类ClassName对象的私有方法，比如method_1
      let func_1: Function = mocker.mockPrivateFunc(claser, "method_1");
      // 3.期望被Mock后的函数返回结果为456
      when(func_1)(ArgumentMatchers.any).afterReturn(456);
      let mock_result = claser.method(123);
      expect(mock_result).assertEqual(456);
      // 清除Mock能力
      mocker.clear(claser);
      let really_result1 = claser.method(123);
      expect(really_result1).assertEqual(123);
    })
  })
}

// [End mockPrivateFunc_sample]