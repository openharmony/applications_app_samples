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

// [Start verifyTimes_sample]
import { describe, it, MockKit, when } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(...arg: string[]) {
    return '888888';
  }
}
export default function verifyTimesTest() {
  describe('verifyTimes_sample', () => {
    it('test_verify_times', 0, () => {
      // 创建一个Mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 初始化ClassName的对象claser
      let claser: ClassName = new ClassName();
      // 进行Mock操作对ClassName类的method_1函数进行Mock
      let func_1: Function = mocker.mockFunc(claser, claser.method_1);
      // 期望被Mock后的函数返回结果'4'
      when(func_1)('123').afterReturn('4');
      // 函数调用
      claser.method_1('123', 'ppp');
      claser.method_1('abc');
      claser.method_1('xyz');
      claser.method_1();
      claser.method_1('abc', 'xxx', 'yyy');
      claser.method_1('abc');
      claser.method_1();
      // 验证函数method_1且参数为'abc'时，执行过的次数是否为2
      mocker.verify('method_1', ['abc']).times(2);// 断言执行通过
       // 验证函数method_1且参数为空时，是否至少执行过2次
      mocker.verify('method_1', []).atLeast(2);// 断言执行通过
    })
  })
}
// [End verifyTimes_sample]