import { describe, it, MockKit, when } from '@ohos/hypium'

class ClassName {
  constructor() {
  }

  method_1(...arg: string[]) {
    return '888888';
  }
}
export default function verifyAtLeastTest() {
  describe('verifyAtLeastTest', () => {
    it('test_verify_atLeast', 0, () => {
      // 1.创建MockKit对象
      let mocker: MockKit = new MockKit();
      // 2.创建类对象
      let claser: ClassName = new ClassName();
      // 3.mock  类ClassName对象的某个方法，比如method_1
      let func_1: Function = mocker.mockFunc(claser, claser.method_1);
      // 4.期望被mock后的函数返回结果'4'
      when(func_1)('123').afterReturn('4');
      // 5.随机执行几次函数，参数如下
      claser.method_1('123', 'ppp');
      claser.method_1('abc');
      claser.method_1('xyz');
      claser.method_1();
      claser.method_1('abc', 'xxx', 'yyy');
      claser.method_1();
      // 6.验证函数method_1且参数为空时，是否至少执行过2次
      mocker.verify('method_1', []).atLeast(2);
    })
  })
}