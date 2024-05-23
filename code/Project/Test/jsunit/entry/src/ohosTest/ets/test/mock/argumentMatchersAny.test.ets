import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(arg: string) {
    return '888888';
  }

  method_2(arg: string) {
    return '999999';
  }
}
export default function argumentMatchersAnyTest() {
  describe('argumentMatchersAnyTest', () => {
    it('testMockfunc', 0, () => {
      console.info("it1 begin");
      // 1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 2.定类ClassName，里面两个函数，然后创建一个对象claser
      let claser: ClassName = new ClassName();
      // 3.进行mock操作,比如需要对ClassName类的method_1函数进行mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 4.期望claser.method_1函数被mock后, 以任何参数调用函数时返回结果'1'
      when(mockfunc)(ArgumentMatchers.any).afterReturn('1');
      // 5.对mock后的函数进行断言，看是否符合预期，注意选择跟第4步中对应的断言方法
      // 执行成功的案例1，传参为字符串类型
      expect(claser.method_1('test')).assertEqual('1'); // 用例执行通过。
      // 执行成功的案例2，传参为数字类型123
      expect(claser.method_1("123")).assertEqual('1');// 用例执行通过。
      // 执行成功的案例3，传参为boolean类型true
      expect(claser.method_1("true")).assertEqual('1');// 用例执行通过。
    })
  })
}