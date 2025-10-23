/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

/*
* | No.  | API                | 功能说明                                                     |
* | :--- | :------------------| ------------------------------------------------------------|
* | 1    | assertClose        | 检验actualvalue和expectvalue(0)的接近程度是否是expectValue(1)。 |
* | 2    | assertContain      | 检验actualvalue中是否包含expectvalue。                       |
* | 3    | assertEqual        | 检验actualvalue是否等于expectvalue[0]。                      |
* | 4    | assertFail         | 抛出一个错误。                                               |
* | 5    | assertFalse        | 检验actualvalue是否是false。                                 |
* | 6    | assertTrue         | 检验actualvalue是否是true。                                  |
* | 7    | assertInstanceOf   | 检验actualvalue是否是expectvalue类型。                       |
* | 8    | assertLarger       | 检验actualvalue是否大于expectvalue。                         |
* | 9    | assertLess         | 检验actualvalue是否小于expectvalue。                         |
* | 10   | assertNull         | 检验actualvalue是否是null。                                  |
* | 11   | assertThrowError   | 检验actualvalue抛出Error内容是否是expectValue。              |
* | 12   | assertUndefined    | 检验actualvalue是否是undefined。                             |
* | 13   | assertNaN          | @since1.0.4 检验actualvalue是否是NaN                        |
* | 14   | assertNegUnlimited | @since1.0.4 检验actualvalue是否等于Number.NEGATIVE_INFINITY             |
* | 15   | assertPosUnlimited | @since1.0.4 检验actualvalue是否等于Number.POSITIVE_INFINITY            |
* | 16   | assertDeepEquals   | @since1.0.4 检验actualvalue和expectvalue(0)是否是同一个对象               |
* | 17   | assertPromiseIsPending | @since1.0.4 判断promise是否处于Pending状态。                         |
* | 18   | assertPromiseIsRejected | @since1.0.4 判断promise是否处于Rejected状态。                       |
* | 19   | assertPromiseIsRejectedWith | @since1.0.4 判断promise是否处于Rejected状态，并且比较执行的结果值。|
* | 20   | assertPromiseIsRejectedWithError | @since1.0.4 判断promise是否处于Rejected状态并有异常，同时比较异常的类型和message值。                   |
* | 21   | assertPromiseIsResolved | @since1.0.4 判断promise是否处于Resolved状态。                       |
* | 22   | assertPromiseIsResolvedWith | @since1.0.4 判断promise是否处于Resolved状态，并且比较执行的结果值。|
* | 23   | not                | @since1.0.4 断言取反,支持上面所有的断言功能                                 |
*
 */

// [Start assert_sample]
import { describe, it, expect, Level } from '@ohos/hypium';

export default function exampleTest() {
  describe('ExampleTest', () =>{
    it('assertCloseTest', Level.LEVEL1, () => {
      let a: number = 100;
      let b: number = 0.1;
      expect(a).assertClose(99, b);
    })

    it('assertContain_1', Level.LEVEL1, () => {
      let a = "abc";
      expect(a).assertContain('b');
    })

    it('assertContain_2', Level.LEVEL1, () => {
      let a = [1, 2, 3];
      expect(a).assertContain(1);
    })

    it('assertEqualTest', Level.LEVEL1, () => {
      expect(3).assertEqual(3);
    })

    it('assertFailTest', Level.LEVEL1, () => {
      expect().assertFail(); // 用例失败
    })

    it('assertFalseTest', Level.LEVEL1, () => {
      expect(false).assertFalse();
    })

    it('assertTrueTest', Level.LEVEL1, () => {
      expect(true).assertTrue();
    })

    it('assertInstanceOfTest', Level.LEVEL1, () => {
      let a: string = 'strTest';
      expect(a).assertInstanceOf('String');
    })

    it('assertLargerTest', Level.LEVEL1, () => {
      expect(3).assertLarger(2);
    })

    it('assertLessTest', Level.LEVEL1, () => {
      expect(2).assertLess(3);
    })

    it('assertNullTest', Level.LEVEL1, () => {
      expect(null).assertNull();
    })

    it('assertThrowErrorTest', Level.LEVEL1, () => {
      expect(() => {
        throw new Error('test');
      }).assertThrowError('test');
    })

    it('assertUndefinedTest', Level.LEVEL1, () => {
      expect(undefined).assertUndefined();
    })

    it('assertLargerOrEqualTest', Level.LEVEL1, () => {
      expect(3).assertLargerOrEqual(3);
    })

    it('assertLessOrEqualTest', Level.LEVEL1, () => {
      expect(3).assertLessOrEqual(3);
    })

    it('assertNaNTest', Level.LEVEL1, () => {
      expect(Number.NaN).assertNaN(); // true
    })

    it('assertNegUnlimitedTest', Level.LEVEL1, () => {
      expect(Number.NEGATIVE_INFINITY).assertNegUnlimited(); // true
    })

    it('assertPosUnlimitedTest', Level.LEVEL1, () => {
      expect(Number.POSITIVE_INFINITY).assertPosUnlimited(); // true
    })

    it('deepEquals_null_true', Level.LEVEL1, () => {
      expect(null).assertDeepEquals(null);
    })

    it('deepEquals_array_not_have_true', Level.LEVEL1, () => {
      const a: Array<number> = [];
      const b: Array<number> = [];
      expect(a).assertDeepEquals(b);
    })

    it('deepEquals_map_equal_length_success', Level.LEVEL1, () => {
      const a: Map<number, number> = new Map();
      const b: Map<number, number> = new Map();
      a.set(1, 100);
      a.set(2, 200);
      b.set(1, 100);
      b.set(2, 200);
      expect(a).assertDeepEquals(b);
    })

    it("deepEquals_obj_success_1", Level.LEVEL1, () => {
      const a: SampleTest = {x: 1};
      const b: SampleTest = {x: 1};
      expect(a).assertDeepEquals(b);
    })

    it("deepEquals_regExp_success_0", Level.LEVEL1, () => {
      const a: RegExp = new RegExp("/test/");
      const b: RegExp = new RegExp("/test/");
      expect(a).assertDeepEquals(b);
    })

    it('assertPromiseIsPendingTest', Level.LEVEL1, async () => {
      let p: Promise<void> = new Promise<void>(() => {});
      await expect(p).assertPromiseIsPending();
    })

    it('assertPromiseIsRejectedTest', Level.LEVEL1, async () => {
      let info: PromiseInfo = {res: "no"};
      let p: Promise<PromiseInfo> = Promise.reject(info);
      await expect(p).assertPromiseIsRejected();
    })

    it('assertPromiseIsRejectedWithTest', Level.LEVEL1, async () => {
      let info: PromiseInfo = {res: "reject value"};
      let p: Promise<PromiseInfo> = Promise.reject(info);
      await expect(p).assertPromiseIsRejectedWith(info);
    })

    it('assertPromiseIsRejectedWithErrorTest', Level.LEVEL1, async () => {
      let p1: Promise<TypeError> = Promise.reject(new TypeError('number'));
      await expect(p1).assertPromiseIsRejectedWithError(TypeError);
    })
    
    it('assertPromiseIsResolvedTest', Level.LEVEL1, async () => {
      let info: PromiseInfo = {res: "result value"};
      let p: Promise<PromiseInfo> = Promise.resolve(info);
      await expect(p).assertPromiseIsResolved();
    })

    it('assertPromiseIsResolvedWithTest', Level.LEVEL1, async () => {
      let info: PromiseInfo = {res: "result value"};
      let p: Promise<PromiseInfo> = Promise.resolve(info);
      await expect(p).assertPromiseIsResolvedWith(info);
    })

    it("test_message", Level.LEVEL1, () => {
      expect(1).message('1 is not equal 2!').assertEqual(2); // fail
    })
  })
}

interface SampleTest {
  x: number;
}

interface PromiseInfo {
  res: string;
}
// [End assert_sample]