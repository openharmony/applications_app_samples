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

// [Start returnPromise_sample]
import { describe, expect, it, MockKit, when } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  async method_1(arg: string) {
    return new Promise<string>((resolve: Function, reject: Function) => {
      setTimeout(() => {
        console.log('执行');
        resolve('数据传递');
      }, 2000);
    });
  }
}
export default function mockPromiseTest() {
  describe('returnPromise_sample', () => {
    it('testMockfunc', 0, async (done: Function) => {
      console.info("it1 begin");
      // 创建一个Mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 初始化ClassName的对象claser
      let claser: ClassName = new ClassName();
      // 进行Mock操作对ClassName类的method_1函数进行Mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 期望claser.method_1函数被Mock后, 以'test'为参数调用函数时返回一个Promise对象
      when(mockfunc)('test').afterReturn(new Promise<string>((resolve: Function, reject: Function) => {
        console.log("do something");
        resolve('success something');
      }));
      // 执行Mock后的函数，即对定义的Promise进行后续执行
      let result = await claser.method_1('test');
      expect(result).assertEqual("success something");// 断言执行通过
      done();
    })
  })
}
// [End returnPromise_sample]