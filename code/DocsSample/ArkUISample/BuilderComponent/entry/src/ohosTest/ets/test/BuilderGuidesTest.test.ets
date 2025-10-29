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
import { Component, Driver, ON } from '@kit.TestKit';
import { buttonArray } from '../../../main/ets/pages/Index';

const TAG = '[Sample_Builder]';
const DOMAIN = 0xF811;
const BUNDLE = 'Builder_';
const KEYCODE_BACK: number = 2;

export default function BuilderGuidesTest() {
  const driver: Driver = Driver.create();
  let count: number = 0;
  let code: number = 0;
  describe('BuilderGuidesTest', () => {
    beforeEach(async (done: Function) => {
      if (count == 17) {
        const theScroll: Component = await driver.findComponent(ON.id('rootScroll'));
        const speed: number = 3000;
        await theScroll.scrollToBottom(speed);
      }
      const theButton: Component = await driver.findComponent(ON.id(buttonArray[count]));
      await theButton.click();
      setTimeout(() => {
        done();
      }, 250);
    })
    afterEach(async (done: Function) => {
      await driver.triggerKey(KEYCODE_BACK);
      setTimeout(() => {
        count++;
        done();
      }, 250);
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * 测试ButtonOne对应页面的代码片段
     */
    it("Builder_Button_001", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_001, begin");
      // 寻找显示内容为'Hello @Builder'的私有自定义构建函数构建的文本组件
      let theComponent = await driver.findComponent(ON.text('Hello @Builder'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, "Builder_Button_001, code: " + code);
      // 寻找显示内容为'Hello World'的私有自定义构建函数构建的文本组件
      theComponent = await driver.findComponent(ON.text('Hello World'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 2;
      }
      hilog.info(DOMAIN, TAG, "Builder_Button_001, code: " + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, "Builder_Button_001, end");
      done();
    })
    /**
     * 测试ButtonTwo对应页面的代码片段
     */
    it("Builder_Button_002", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_002, begin");
      // 寻找显示内容为'Hello World'的全局自定义构建函数构建的文本组件
      let theComponent = await driver.findComponent(ON.text('Hello World'));
      // 组件不存在更新变量
      if (!theComponent) {
        code = 1;
      }
      hilog.info(DOMAIN, TAG, "Builder_Button_002, code: " + code);
      expect(0).assertEqual(code);
      hilog.info(DOMAIN, TAG, "Builder_Button_002, end");
      done();
    })
    /**
     * 测试ButtonThree对应页面的代码片段
     */
    it("Builder_Button_003", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_003, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_003, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_003, end");
      done();
    })
    /**
     * 测试ButtonFour对应页面的代码片段
     */
    it("Builder_Button_004", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_004, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_004, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_004, end");
      done();
    })
    /**
     * 测试ButtonFive对应页面的代码片段
     */
    it("Builder_Button_005", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_005, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_005, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_005, end");
      done();
    })
    /**
     * 测试ButtonSix对应页面的代码片段
     */
    it("Builder_Button_006", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_006, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_006, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_006, end");
      done();
    })
    /**
     * 测试ButtonSeven对应页面的代码片段
     */
    it("Builder_Button_007", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_007, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_007, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_007, end");
      done();
    })
    /**
     * 测试ButtonEight对应页面的代码片段
     */
    it("Builder_Button_008", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_008, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_008, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_008, end");
      done();
    })
    /**
     * 测试ButtonNine对应页面的代码片段
     */
    it("Builder_Button_009", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_009, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_009, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_009, end");
      done();
    })
    /**
     * 测试ButtonTen对应页面的代码片段
     */
    it("Builder_Button_010", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_010, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_010, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_010, end");
      done();
    })
    /**
     * 测试ButtonEleven对应页面的代码片段
     */
    it("Builder_Button_011", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_011, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_011, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_011, end");
      done();
    })
    /**
     * 测试ButtonTwelve对应页面的代码片段
     */
    it("Builder_Button_012", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_012, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_012, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_012, end");
      done();
    })
    /**
     * 测试ButtonThirteen对应页面的代码片段
     */
    it("Builder_Button_013", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_013, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_013, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_013, end");
      done();
    })
    /**
     * 测试ButtonFourteen对应页面的代码片段
     */
    it("Builder_Button_014", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_014, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_014, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_014, end");
      done();
    })
    /**
     * 测试ButtonFifteen对应页面的代码片段
     */
    it("Builder_Button_015", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_015, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_015, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_015, end");
      done();
    })
    /**
     * 测试ButtonSixteen对应页面的代码片段
     */
    it("Builder_Button_016", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_016, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_016, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_016, end");
      done();
    })
    /**
     * 测试ButtonSeventeen对应页面的代码片段
     */
    it("Builder_Button_017", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_017, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_017, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_017, end");
      done();
    })
    /**
     * 测试ButtonEighteen对应页面的代码片段
     */
    it("Builder_Button_018", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_018, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_018, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_018, end");
      done();
    })
    /**
     * 测试ButtonNineteen对应页面的代码片段
     */
    it("Builder_Button_019", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_019, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_019, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_019, end");
      done();
    })
    /**
     * 测试ButtonTwenty对应页面的代码片段
     */
    it("Builder_Button_020", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_020, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_020, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_020, end");
      done();
    })
    /**
     * 测试ButtonTwentyOne对应页面的代码片段
     */
    it("Builder_Button_021", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_021, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_021, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_021, end");
      done();
    })
    /**
     * 测试ButtonTwentyTwo对应页面的代码片段
     */
    it("Builder_Button_022", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_022, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_022, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_022, end");
      done();
    })
    /**
     * 测试ButtonTwentyThree对应页面的代码片段
     */
    it("Builder_Button_023", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_023, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_023, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_023, end");
      done();
    })
    /**
     * 测试ButtonTwentyFour对应页面的代码片段
     */
    it("Builder_Button_024", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_024, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_024, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_024, end");
      done();
    })
    /**
     * 测试ButtonTwentyFive对应页面的代码片段
     */
    it("Builder_Button_025", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_025, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_025, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_025, end");
      done();
    })
    /**
     * 测试ButtonTwentySix对应页面的代码片段
     */
    it("Builder_Button_026", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_026, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_026, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_026, end");
      done();
    })
    /**
     * 测试ButtonTwentySeven对应页面的代码片段
     */
    it("Builder_Button_027", 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, "Builder_Button_027, begin");
      hilog.info(DOMAIN, TAG, "Builder_Button_027, code: " + code);
      hilog.info(DOMAIN, TAG, "Builder_Button_027, end");
      done();
    })

  })
}