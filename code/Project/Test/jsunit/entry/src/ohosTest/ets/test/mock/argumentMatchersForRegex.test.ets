/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start argumentMatchersForRegex_sample]
import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(arg: string) {
    return '888888';
  }
}
export default function matchRegexsTest() {
  describe('argumentMatchersForRegex_sample', () => {
    it('testMockfunc', 0, () => {
      console.info("it1 begin");
      // 创建一个Mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 初始化ClassName的对象claser
      let claser: ClassName = new ClassName();
      // 进行Mock操作，对ClassName类的method_1函数进行Mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 期望claser.method_1函数被Mock后, 以"test"为入参调用函数时返回结果'1'
      when(mockfunc)(ArgumentMatchers.matchRegexs(new RegExp("test"))).afterReturn('1');
      // 传入test参数后验证是否符合预期
      expect(claser.method_1('test')).assertEqual('1'); // 断言执行通过
    })
  })
}
// [End argumentMatchersForRegex_sample]