import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

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
export default function ignoreMockTest() {
  describe('ignoreMockTest', () => {
    it('testMockfunc', 0, () => {
      console.info("it1 begin");
      // 1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 2.创建一个对象claser
      let claser: ClassName = new ClassName();
      // 3.进行mock操作,比如需要对ClassName类的method_1和method_2两个函数进行mock
      let func_1: Function = mocker.mockFunc(claser, claser.method_1);
      let func_2: Function = mocker.mockFunc(claser, claser.method_2);
      // 4.期望claser.method_1函数被mock后, 以number类型为入参时调用函数返回结果'4'
      when(func_1)(ArgumentMatchers.anyNumber).afterReturn('4');
      // 4.期望claser.method_2函数被mock后, 以number类型为入参时调用函数返回结果'5'
      when(func_2)(ArgumentMatchers.anyNumber).afterReturn('5');
      // 5.方法调用如下
      expect(claser.method_1(123)).assertEqual("4");
      expect(claser.method_2(456)).assertEqual("5");
      // 6.现在对mock后的两个函数的其中一个函数method_1进行忽略处理（原理是就是还原）
      mocker.ignoreMock(claser, claser.method_1);
      // 7.然后再去调用 claser.method_1函数，用断言测试結果
      expect(claser.method_1(123)).assertEqual('888888');
    })
  })
}