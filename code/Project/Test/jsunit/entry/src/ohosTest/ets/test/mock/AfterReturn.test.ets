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

// [Start afterReturn_sample]
import { describe, expect, it, MockKit, when } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(arg: string) {
    return '888888';
  }
}

export default function afterReturnTest() {
  describe('afterReturn_sample', () => {
    it('afterReturnTest', 0, () => {
      // 创建一个Mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 初始化ClassName的对象claser，作为被Mock的对象实例
      let claser: ClassName = new ClassName();
      // 进行Mock操作，对ClassName类的method_1函数进行Mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 期望claser.method_1函数被Mock后, 以'testA'为入参时调用函数返回结果'1',以'testB''为入参时调用函数返回结果undefined
      when(mockfunc)('testA').afterReturn('1');
      when(mockfunc)('testB').afterReturnNothing();
      // 对Mock后的函数进行断言，看是否符合预期。分别传入参数'testA'和'testB'时，应该返回自定义的预期结果1和undefined
      expect(claser.method_1('testA')).assertEqual('1'); // 断言执行通过
      expect(claser.method_1('testB')).assertUndefined(); // 断言执行通过
    })
  })
}

// [End afterReturn_sample]