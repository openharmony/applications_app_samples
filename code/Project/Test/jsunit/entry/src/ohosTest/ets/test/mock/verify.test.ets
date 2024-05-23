import { describe, it, MockKit } from '@ohos/hypium';

class ClassName {
  constructor() {
  }

  method_1(...arg: string[]) {
    return '888888';
  }

  method_2(...arg: string[]) {
    return '999999';
  }
}
export default function verifyTest() {
  describe('verifyTest', () => {
    it('testMockfunc', 0, () => {
      console.info("it1 begin");
      // 1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      // 2.然后创建一个对象claser
      let claser: ClassName = new ClassName();
      // 3.进行mock操作,比如需要对ClassName类的method_1和method_2两个函数进行mock
      mocker.mockFunc(claser, claser.method_1);
      mocker.mockFunc(claser, claser.method_2);
      // 4.方法调用如下
      claser.method_1('abc', 'ppp');
      claser.method_1('abc');
      claser.method_1('xyz');
      claser.method_1();
      claser.method_1('abc', 'xxx', 'yyy');
      claser.method_1();
      claser.method_2('111');
      claser.method_2('111', '222');
      // 5.现在对mock后的两个函数进行验证，验证method_2,参数为'111'执行过一次
      mocker.verify('method_2',['111']).once(); // 执行success
    })
  })
}