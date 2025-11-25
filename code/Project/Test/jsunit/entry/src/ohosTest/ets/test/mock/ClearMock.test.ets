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

// [Start clearMock_sample]
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(...arg: number[]) {
    return '888888';
  }

  method_2(...arg: number[]) {
    return '999999';
  }
}

export default function clearTest() {
  describe('clearMock_sample', () => {
    it('testMockfunc', 0, () => {
      // 创建一个Mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 初始化ClassName的对象claser
      let claser: ClassName = new ClassName();
      // 进行Mock操作，对ClassName类的method_1和method_2两个函数进行Mock
      let func_1: Function = mocker.mockFunc(claser, claser.method_1);
      let func_2: Function = mocker.mockFunc(claser, claser.method_2);
      // 期望claser.method_1函数被Mock后, 以任何number类型为参数调用函数时返回结果'4'
      when(func_1)(ArgumentMatchers.anyNumber).afterReturn('4');
      // 期望claser.method_2函数被Mock后, 以任何number类型为参数调用函数时返回结果'5'
      when(func_2)(ArgumentMatchers.anyNumber).afterReturn('5');
      // 函数调用
      expect(claser.method_1(123)).assertEqual('4');
      expect(claser.method_2(123)).assertEqual('5');
      // 还原obj上所有的Mock能力
      mocker.clear(claser);
      // 调用claser.method_1,claser.method_2函数，测试结果
      expect(claser.method_1(123)).assertEqual('888888'); // 断言执行通过
      expect(claser.method_2(123)).assertEqual('999999'); // 断言执行通过
    })
  })
}

// [End clearMock_sample]