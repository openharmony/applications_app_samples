import { describe, expect, it, MockKit, when } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(arg: string) {
    return '888888';
  }
}
export default function afterThrowTest() {
  describe('afterThrowTest', () => {
    it('testMockfunc', 0, () => {
      console.info("it1 begin");
      // 1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 2.创建一个对象claser
      let claser: ClassName = new ClassName();
      // 3.进行mock操作,比如需要对ClassName类的method_1函数进行mock
      let mockfunc: Function = mocker.mockFunc(claser, claser.method_1);
      // 4.期望claser.method_1函数被mock后, 以'test'为参数调用函数时抛出error xxx异常
      when(mockfunc)('test').afterThrow('error xxx');
      // 5.执行mock后的函数，捕捉异常并使用assertEqual对比msg否符合预期
      try {
        claser.method_1('test');
      } catch (e) {
        expect(e).assertEqual('error xxx'); // 执行通过
      }
    })
  })
}