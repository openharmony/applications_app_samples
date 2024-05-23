import { describe, Assert, beforeAll, expect, Hypium, it } from '@ohos/hypium';

// custom.ets
interface customAssert extends Assert {
  // 自定义断言声明
  myAssertEqual(expectValue: boolean): void;
}

//自定义断言实现
let myAssertEqual = (actualValue: boolean, expectValue: boolean) => {
  interface R {
    pass: boolean,
    message: string
  }

  let result: R = {
    pass: true,
    message: 'just is a msg'
  }

  let compare = () => {
    if (expectValue === actualValue) {
      result.pass = true;
      result.message = '';
    } else {
      result.pass = false;
      result.message = 'expectValue !== actualValue!';
    }
    return result;
  }
  result = compare();
  return result;
}

export default function customAssertTest() {
  describe('customAssertTest', () => {
    beforeAll(() => {
      //注册自定义断言，只有先注册才可以使用
      Hypium.registerAssert(myAssertEqual);
    })
    it('assertContain1', 0, () => {
      let a = true;
      let b = true;
      (expect(a) as customAssert).myAssertEqual(b);
      Hypium.unregisterAssert(myAssertEqual);
    })
    it('assertContain2', 0, () => {
      Hypium.registerAssert(myAssertEqual);
      let a = true;
      let b = true;
      (expect(a) as customAssert).myAssertEqual(b);
      // 注销自定义断言，注销以后就无法使用
      Hypium.unregisterAssert(myAssertEqual);
      try {
        (expect(a) as customAssert).myAssertEqual(b);
      }catch(e) {
        expect(e.message).assertEqual("myAssertEqual is unregistered");
      }
    })
  })
}