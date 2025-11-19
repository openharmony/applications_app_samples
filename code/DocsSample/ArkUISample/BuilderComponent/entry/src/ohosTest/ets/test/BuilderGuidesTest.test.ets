/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Component, Driver, MatchPattern, On, ON, Point, Rect } from '@kit.TestKit';
import { buttonArray } from '../../../main/ets/pages/Index';

const TAG = '[Sample_Builder]';
const DOMAIN = 0xF811;
const BUNDLE = 'Builder_';
const KEYCODE_BACK: number = 2;

export default function BuilderGuidesTest() {
  const driver: Driver = Driver.create();
  let theScroll: Component;
  let theScrollPoint: Point;
  let currentCount: number = 0;
  let code: number = 0;
  let swiper = async (count: number) => {
    currentCount = count;
    if (count > 0) {
      await driver.mouseScroll(theScrollPoint, false, 3 * count);
      await sleep(100);
      await driver.mouseScroll(theScrollPoint, true, 2 * count);
      await sleep(100);
    }
    const theButton: Component = await driver.findComponent(ON.id(buttonArray[count]));
    await theButton.click();
    await sleep(250);
  }
  describe('BuilderGuidesTest', () => {
    beforeAll(async (done: Function) => {
      theScroll = await driver.findComponent(ON.id('rootScroll'));
      theScrollPoint = await theScroll.getBoundsCenter();
      done();
    })
    afterEach(async (done: Function) => {
      if (currentCount != 23) {
        await driver.triggerKey(KEYCODE_BACK);
        await sleep(250, done);
      }
      done();
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * 测试ButtonOne对应页面的代码片段
     */
    it('Builder_Button_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_001, begin');
      await swiper(0);
      // 寻找显示内容为'Hello @Builder'的私有自定义构建函数构建的文本组件
      let theComponent = await driver.findComponent(ON.text('Hello @Builder'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_001, code: ' + code);
      // 寻找显示内容为'Hello World'的私有自定义构建函数构建的文本组件
      theComponent = await driver.findComponent(ON.text('Hello World'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_001, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_001, end');
      done();
    })
    /**
     * 测试ButtonTwo对应页面的代码片段
     */
    it('Builder_Button_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_002, begin');
      await swiper(1);
      // 寻找显示内容为'Hello World'的全局自定义构建函数构建的文本组件
      let theComponent = await driver.findComponent(ON.text('Hello World'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_002, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_002, end');
      done();
    })
    /**
     * 测试ButtonThree对应页面的代码片段
     */
    it('Builder_Button_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_003, begin');
      await swiper(2);
      // 寻找显示内容以'UseStateVarByValue'开始的自定义构建函数构建的文本组件
      let theComponent = await driver.findComponent(ON.text('UseStateVarByValue', MatchPattern.STARTS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_003, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_003, end');
      done();
    })
    /**
     * 测试ButtonTwentyEight对应页面的代码片段
     */
    it('Builder_Button_028', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_028, begin');
      await swiper(3);
      // 寻找显示内容为'Click me'的自定义构建函数构建的按钮组件
      let theComponent = await driver.findComponent(ON.text('Click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_028, code: ' + code);
      // 寻找显示内容以'ArkUI'结尾的自定义构建函数构建的文本组件
      theComponent = await driver.findComponent(ON.text('UseStateVarByReference: ArkUI ', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_028, code: ' + code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_028, end');
      done();
    })
    /**
     * 测试ButtonTwentyNine对应页面的代码片段
     */
    it('Builder_Button_029', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_029, begin');
      await swiper(4);
      // 寻找显示内容为'only change number2'的自定义构建函数构建的按钮组件
      let theComponent = await driver.findComponent(ON.text('only change number2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_029, code: ' + code);
      // 寻找显示内容以'13'结尾的自定义构建函数构建的文本组件
      theComponent = await driver.findComponent(ON.text('13', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_029, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_029, end');
      done();
    })
    /**
     * 测试ButtonFour对应页面的代码片段
     */
    it('Builder_Button_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_004, begin');
      await swiper(5);
      await sleep(2050);
      let theComponent = await driver.findComponent(ON.text('Hello World', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_004, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Click to change the builderValue'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_004, code: ' + code);
      theComponent = await driver.findComponent(ON.text('builderValue was clicked', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_004, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_004, end');
      done();
    })
    /**
     * 测试ButtonFive对应页面的代码片段
     */
    it('Builder_Button_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, begin');
      await swiper(6);
      let theComponent = await driver.findComponent(ON.text('strValue: Hello', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('numValue: 0', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('tmpValue: 1', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 4;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('strValue: Hello World', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 5;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('numValue: 1', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 6;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('tmpValue: 8', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 7;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      theComponent = await driver.findComponent(ON.text('arrayTmpValue: 2', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 8;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_005, end');
      done();
    })
    /**
     * 测试ButtonSix对应页面的代码片段
     */
    it('Builder_Button_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, begin');
      await swiper(7);
      let theComponent = await driver.findComponent(ON.text('wrapBuilder strValue: Hello', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, code: ' + code);
      theComponent = await driver.findComponent(ON.text('wrapBuilder num: World', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, code: ' + code);
      theComponent = await driver.findComponent(ON.text('wrapBuilder strValue: strValue Hello World', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 4;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, code: ' + code);
      theComponent = await driver.findComponent(ON.text('wrapBuilder num: label Hello World', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 5;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_006, end');
      done();
    })
    /**
     * 测试ButtonSeven对应页面的代码片段
     */
    it('Builder_Button_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_007, begin');
      await swiper(8);
      const speed: number = 2000;
      let theComponent = await driver.findComponent(ON.text('0', MatchPattern.EQUALS));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        const theComponentRect: Rect = await theComponent.getBounds();
        const theComponentPointFrom: Point = await theComponent.getBoundsCenter();
        let theComponentPointTo: Point = {
          x: theComponentRect.left,
          y: theComponentPointFrom.y
        }
        await driver.swipe(theComponentPointFrom.x, theComponentPointFrom.y,
                           theComponentPointTo.x, theComponentPointTo.y, speed);
        hilog.info(DOMAIN, TAG, 'Builder_Button_007, code: ' + code);
        let theComponentBuilder = await driver.findComponent(ON.text('Private Builder', MatchPattern.EQUALS));
        // 组件不存在更新变量
        if (!theComponentBuilder) {
          code = 2;
        }
        hilog.info(DOMAIN, TAG, 'Builder_Button_007, code: ' + code);
        theComponentPointTo = {
          x: theComponentRect.right,
          y: theComponentPointFrom.y
        }
        theComponent = await driver.findComponent(ON.text('1', MatchPattern.EQUALS));
        await theComponent.click();
        await driver.delayMs(1000);
        await driver.swipe(theComponentPointFrom.x, theComponentPointFrom.y,
                           theComponentPointTo.x, theComponentPointTo.y, speed);
        theComponentBuilder = await driver.findComponent(ON.text('Global Builder', MatchPattern.EQUALS));
        // 组件不存在更新变量
        if (!theComponentBuilder) {
          code = 3;
        }
        hilog.info(DOMAIN, TAG, 'Builder_Button_007, code: ' + code);
      }
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_007, end');
      done();
    })
    /**
     * 测试ButtonEight对应页面的代码片段
     */
    it('Builder_Button_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_008, begin');
      await swiper(9);
      let theComponent = await driver.findComponent(ON.text('Hello', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_008, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_008, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Hello', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_008, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_008, end');
      done();
    })
    /**
     * 测试ButtonNine对应页面的代码片段
     */
    it('Builder_Button_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_009, begin');
      await swiper(10);
      // 条件1
      const On1: On = ON.text('Tom', MatchPattern.CONTAINS).text('25', MatchPattern.CONTAINS);
      let theComponent = await driver.findComponent(On1);
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_009, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change info1&info2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_009, code: ' + code);
      theComponent = await driver.findComponent(On1);
      // 组件存在更新变量
      if (theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_009, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_009, end');
      done();
    })
    /**
     * 测试ButtonTen对应页面的代码片段
     */
    it('Builder_Button_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_010, begin');
      await swiper(11);
      // 条件1
      const On1: On = ON.text('Tom', MatchPattern.CONTAINS).text('25', MatchPattern.CONTAINS);
      // 条件2
      const On2: On = ON.text('Cat', MatchPattern.CONTAINS).text('18', MatchPattern.CONTAINS);
      let theComponent = await driver.findComponent(On1);
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_010, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change LocalInfo1&LocalInfo2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_010, code: ' + code);
      theComponent = await driver.findComponent(On2);
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_010, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_010, end');
      done();
    })
    /**
     * 测试ButtonEleven对应页面的代码片段
     */
    it('Builder_Button_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, begin');
      await swiper(12);
      // 条件1
      const On1: On = ON.text('ChildTwo', MatchPattern.CONTAINS);
      let theComponent = await driver.findComponent(On1);
      // 组件存在更新变量
      if (theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      theComponent = await driver.findComponent(On1);
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, end');
      done();
    })
    /**
     * 测试ButtonTwelve对应页面的代码片段
     */
    it('Builder_Button_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_012, begin');
      await swiper(13);
      let theComponent = await driver.findComponent(ON.text('change both number1 and number2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_012, code: ' + code);
      theComponent = await driver.findComponent(ON.text('only change number2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_012, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change props'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_012, code: ' + code);
      theComponent = await driver.findComponent(ON.text('number1 === 6'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 4;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      theComponent = await driver.findComponent(ON.text('number2 === 15'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 5;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      theComponent = await driver.findComponent(ON.text('number1 === 6,  number2 === 15'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 6;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Hello', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 7;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_011, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_012, end');
      done();
    })
    /**
     * 测试ButtonThirteen对应页面的代码片段
     */
    it('Builder_Button_013', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_013, begin');
      await swiper(14);
      let theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_013, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Hello World', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_013, code: ' + code);
      theComponent = await driver.findComponent(ON.text('1', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_013, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_013, end');
      done();
    })
    /**
     * 测试ButtonFourteen对应页面的代码片段
     */
    it('Builder_Button_014', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_014, begin');
      await swiper(15);
      let theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_014, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Hello World', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_014, code: ' + code);
      theComponent = await driver.findComponent(ON.text('1', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_014, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_014, end');
      done();
    })
    /**
     * 测试ButtonFifteen对应页面的代码片段
     */
    it('Builder_Button_015', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_015, begin');
      await swiper(16);
      let theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_015, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Hello World', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_015, code: ' + code);
      theComponent = await driver.findComponent(ON.text('1', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_015, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_015, end');
      done();
    })
    /**
     * 测试ButtonSixteen对应页面的代码片段
     */
    it('Builder_Button_016', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_016, begin');
      await swiper(17);
      await sleep(600);
      let theComponent = await driver.findComponent(ON.text('paramNum : 0'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_016, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_016, end');
      done();
    })
    /**
     * 测试ButtonSeventeen对应页面的代码片段
     */
    it('Builder_Button_017', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_017, begin');
      await swiper(18);
      await sleep(2000);
      let theComponent = await driver.findComponent(ON.text('20', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_017, code: ' + code);
      theComponent = await driver.findComponent(ON.text('5', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_017, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_017, end');
      done();
    })
    /**
     * 测试ButtonEighteen对应页面的代码片段
     */
    it('Builder_Button_018', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_018, begin');
      await swiper(19);
      let theComponent = await driver.findComponent(ON.text('Click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_018, code: ' + code);
      theComponent = await driver.findComponent(ON.text('parentBuilder1===Li Si===20'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_018, code: ' + code);
      theComponent = await driver.findComponent(ON.text('HelloComponent1===Zhang San===18'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_018, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_018, end');
      done();
    })
    /**
     * 测试ButtonNineteen对应页面的代码片段
     */
    it('Builder_Button_019', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_019, begin');
      await swiper(20);
      let theComponent = await driver.findComponent(ON.text('Click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_019, code: ' + code);
      theComponent = await driver.findComponent(ON.text('Zhang San===18', MatchPattern.CONTAINS));
      // 组件存在更新变量
      if (theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_019, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_019, end');
      done();
    })
    /**
     * 测试ButtonTwenty对应页面的代码片段
     */
    it('Builder_Button_020', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_020, begin');
      await swiper(21);
      let theComponent = await driver.findComponent(ON.text('change'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_020, code: ' + code);
      theComponent = await driver.findComponent(ON.text('4-1'));
      // 组件存在更新变量
      if (theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_020, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_020, end');
      done();
    })
    /**
     * 测试ButtonTwentyOne对应页面的代码片段
     */
    it('Builder_Button_021', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_021, begin');
      await swiper(22);
      let theComponent = await driver.findComponent(ON.text('change'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_021, code: ' + code);
      theComponent = await driver.findComponent(ON.text('4-1'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_021, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_021, end');
      done();
    })
    /**
     * 测试ButtonTwentyThree对应页面的代码片段
     */
    it('Builder_Button_023', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_023, begin');
      await swiper(24);
      let theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_023, code: ' + code);
      theComponent = await driver.findComponent(ON.text('num: 1'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_023, code: ' + code);
      theComponent = await driver.findComponent(ON.text('num: 2'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_021, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_023, end');
      done();
    })
    /**
     * 测试ButtonTwentyFour对应页面的代码片段
     */
    it('Builder_Button_024', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_024, begin');
      await swiper(25);
      let theComponent = await driver.findComponent(ON.text('click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_024, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_024, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change trial', MatchPattern.ENDS_WITH));
      // 组件存在更新变量
      if (theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_024, end');
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_024, end');
      done();
    })
    /**
     * 测试ButtonTwentyFive对应页面的代码片段
     */
    it('Builder_Button_025', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_025, begin');
      await swiper(26);
      let theComponent = await driver.findComponent(ON.text('click me'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_025, code: ' + code);
      theComponent = await driver.findComponent(ON.text('change'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_025, code: ' + code);
      theComponent = await driver.findComponent(ON.text('trialOne', MatchPattern.ENDS_WITH));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 3;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_025, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_025, end');
      done();
    })
    /**
     * 测试ButtonTwentySix对应页面的代码片段
     */
    it('Builder_Button_026', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_026, begin');
      await swiper(27);
      let theComponent = await driver.findComponent(ON.text('content value: Index: hello world'));
      const theComponentPoint: Point = await theComponent.getBoundsCenter();
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await driver.clickAt(theComponentPoint);
        await sleep(250);
        await driver.clickAt(theComponentPoint);
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_026, code: ' + code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_026, code: ' + code);
      theComponent = await driver.findComponent(ON.text('content value: Index: hello world_world_world'));
      // 组件存在更新变量
      if (theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_026, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_026, end');
      done();
    })
    /**
     * 测试ButtonTwentySeven对应页面的代码片段
     */
    it('Builder_Button_027', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_027, begin');
      await swiper(28);
      let theComponent = await driver.findComponent(ON.text('content value: Index: hello world'));
      const theComponentPoint: Point = await theComponent.getBoundsCenter();
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await driver.clickAt(theComponentPoint);
        await sleep(250);
        await driver.clickAt(theComponentPoint);
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_027, code: ' + code);
      theComponent = await driver.findComponent(ON.text('content value: Index: hello world_world_world'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_027, code: ' + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_027, end');
      done();
    })
    /**
     * 测试ButtonTwentyTwo对应页面的代码片段，并且该场景为崩溃场景故放在最后的进行测试
     */
    it('Builder_Button_022', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Builder_Button_022, begin');
      await swiper(23);
      let theComponent = await driver.findComponent(ON.text('Update Values'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      } else {
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_022, code: ' + code);
      theComponent = await driver.findComponent(ON.text('num: 1'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      } else {
        expect(0).assertEqual(code);
        done();
        await theComponent.click();
        await sleep(250);
      }
      hilog.info(DOMAIN, TAG, 'Builder_Button_022, code: ' + code);
      hilog.info(DOMAIN, TAG, 'Builder_Button_022, end');
    })
  })
}

function sleep(time: number, done?: Function): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    setTimeout(() => {
      done?.();
      resolve('time over')
    }, time)
  })
}