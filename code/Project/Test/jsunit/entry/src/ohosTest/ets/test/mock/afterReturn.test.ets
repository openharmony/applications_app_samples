import { describe, expect, it, MockKit, when } from '@ohos/hypium';

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
export default function afterReturnTest() {
  describe('afterReturnTest', () => {
    it('afterReturnTest', 0, () => {
      console.info("it1 begin");
      // 1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 2.定类ClassName，里面两个函数，然后创建一个对象claser
      let claser: ClassName = new ClassName();
      // 3.进行mock操作,比如需要对ClassName类的method_1函数进行mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 4.期望claser.method_1函数被mock后, 以'test'为入参时调用函数返回结果'1'
      when(mockfunc)('test').afterReturn('1');
      // 5.对mock后的函数进行断言，看是否符合预期
      // 执行成功案例，参数为'test'
      expect(claser.method_1('test')).assertEqual('1'); // 执行通过
    })
  })
}