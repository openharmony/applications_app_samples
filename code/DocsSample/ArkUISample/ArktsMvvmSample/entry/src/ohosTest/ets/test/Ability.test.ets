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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Want } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { Driver, ON, Component, Point } from '@ohos.UiTest';

const DELAY_TIME01 = 1000; //异步等待1秒
const DELAY_TIME02 = 2000; //异步等待2秒

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

let driver = Driver.create();

async function getCenterPoint(comp: Component, offset: number): Promise<Point> {
  // 获取文件控件边框
  let rect = await comp.getBounds();
  // 计算文字控件高度
  let height = rect.bottom - rect.top;
  // 获取文字控件中心点
  let point: Point = await comp.getBoundsCenter();
  point = { x: point.x, y: point.y - height * offset };
  return point;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: "com.sample.arktsmvvmsample",
        abilityName: "EntryAbility",
        moduleName: "entry"
      };
      delegator.startAbility(want);
      await sleep(DELAY_TIME01);
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * @tc.number SUB_Arkui_Mvvm_Introduce_0100
     * @tc.name SUB_Arkui_Mvvm_Introduce_0100
     * @tc.desc To introduce the MVVM framework
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Arkui_Mvvm_Introduce_0100', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text("学习高数"));
        await box1.click();
        await sleep(DELAY_TIME01);
        await box1.click();
        await sleep(DELAY_TIME01);
        done();
      })

    /**
     * @tc.number SUB_Arkui_Mvvm_Introduce_0200
     * @tc.name SUB_Arkui_Mvvm_Introduce_0200
     * @tc.desc To introduce the MVVM framework
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Arkui_Mvvm_Introduce_0200', Level.LEVEL1,
      async (done: Function) => {
        router.pushUrl({ url: "pages/PropLinkIndex" });
        await sleep(DELAY_TIME01);
        let box: Component = await driver.findComponent(ON.text("学习高数"));
        await box.click();
        await sleep(DELAY_TIME01);
        await box.click();
        await sleep(DELAY_TIME01);
        let box1: Component = await driver.findComponent(ON.text('全选'));
        await box1.click();
        await sleep(DELAY_TIME01);
        await box1.click();
        await sleep(DELAY_TIME01);
        done();
      })

    /**
     * @tc.number SUB_Arkui_Mvvm_Introduce_0300
     * @tc.name SUB_Arkui_Mvvm_Introduce_0300
     * @tc.desc To introduce the MVVM framework
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Arkui_Mvvm_Introduce_0300', Level.LEVEL1,
      async (done: Function) => {
        router.pushUrl({ url: "pages/ForEachIndex" });
        await sleep(DELAY_TIME02);
        let box1: Component = await driver.findComponent(ON.id('7.30 起床'));
        let coordinate1 = await getCenterPoint(box1, 0);
        await box1.click();
        await sleep(DELAY_TIME01);
        await driver.click(coordinate1.x, coordinate1.y);
        await sleep(DELAY_TIME01);
        let box2: Component = await driver.findComponent(ON.id('8.30 早餐'));
        let coordinate2 = await getCenterPoint(box2, 0);
        await box2.click();
        await sleep(DELAY_TIME01);
        await driver.click(coordinate2.x, coordinate2.y);
        await sleep(DELAY_TIME01);
        let box3: Component = await driver.findComponent(ON.text('8.30 早餐'));
        await box3.click();
        await sleep(DELAY_TIME01);
        await box3.click();
        await sleep(DELAY_TIME01);
        let box4: Component = await driver.findComponent(ON.text('全选'));
        await box4.click();
        await sleep(DELAY_TIME01);
        await box4.click();
        await sleep(DELAY_TIME01);
        done();
      })

    /**
     * @tc.number SUB_Arkui_Mvvm_Introduce_0400
     * @tc.name SUB_Arkui_Mvvm_Introduce_0400
     * @tc.desc To introduce the MVVM framework
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Arkui_Mvvm_Introduce_0400', Level.LEVEL1,
      async (done: Function) => {
        router.pushUrl({ url: "pages/BuilderIndex" });
        await sleep(DELAY_TIME01);
        let box: Component = await driver.findComponent(ON.text('全选'));
        await box.click();
        await sleep(DELAY_TIME01);
        await box.click();
        await sleep(DELAY_TIME01);
        let box1: Component = await driver.findComponent(ON.id('7.30 起床'));
        let coordinate = await getCenterPoint(box1, 0);
        await box1.click();
        await sleep(DELAY_TIME01);
        await driver.click(coordinate.x, coordinate.y);
        await sleep(DELAY_TIME01);
        let box2: Component = await driver.findComponent(ON.text('7.30 起床'));
        await box2.click();
        await sleep(DELAY_TIME01);
        await box2.click();
        await sleep(DELAY_TIME01);
        let box3: Component = await driver.findComponent(ON.text('8.30 早餐'));
        await box3.click();
        await sleep(DELAY_TIME01);
        await box3.click();
        await sleep(DELAY_TIME01);
        done();
      })

    /**
     * @tc.number SUB_Arkui_Mvvm_Introduce_0500
     * @tc.name SUB_Arkui_Mvvm_Introduce_0500
     * @tc.desc To introduce the MVVM framework
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Arkui_Mvvm_Introduce_0500', Level.LEVEL1,
      async (done: Function) => {
        router.pushUrl({ url: "pages/Index" });
        await sleep(DELAY_TIME01);
        let box: Component = await driver.findComponent(ON.text('全选'));
        await box.click();
        await sleep(DELAY_TIME01);
        await box.click();
        await sleep(DELAY_TIME01);
        let box1: Component = await driver.findComponent(ON.id('7.30 起床'));
        let coordinate = await getCenterPoint(box1, 0);
        await box1.click();
        await sleep(DELAY_TIME01);
        await driver.click(coordinate.x, coordinate.y);
        await sleep(DELAY_TIME01);
        let box2: Component = await driver.findComponent(ON.text("7.30 起床"));
        await box2.click();
        await sleep(DELAY_TIME01);
        await box2.click();
        await sleep(DELAY_TIME01);
        done();
      })
  })
}