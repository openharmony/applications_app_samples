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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Level, Size } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { router } from '@kit.ArkUI';
import { Driver, ON, Component, Point, On } from '@ohos.UiTest';

let driver = Driver.create();

const DELAY_TIME01 = 1000; //异步等待1秒

async function sleep(time: number): Promise<void> {
  return new Promise((re, je) => {
    setTimeout(() => {
      re()
    }, time)
  })
}

async function getCenterPoint(comp: Component, offset: number): Promise<Point> {
  // 获取文件控件边框
  let rect = await comp.getBounds();
  // 计算文字控件高度
  let height = rect.bottom - rect.top;
  // 获取文字控件中心点
  let point: Point = await comp.getBoundsCenter();
  point = {x: point.x, y:point.y - height*offset};
  return point;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want:Want = {
        bundleName:"com.sample.arktsnewonce",
        abilityName:"EntryAbility",
        moduleName:"entry"
      }
      delegator.startAbility(want)
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
     * @tc.number  : SUB_ARKUI_DECORATOR_ONCE_0100
     * @tc.name    : SUB_ARKUI_DECORATOR_ONCE_0100
     * @tc.desc    : Testing DestroyChildProcessConfigs returns an invalid parameter error code.
     * @tc.level   : Level1
     * @tc.size    : MediumTest
     * @tc.type    : Function
     */
    it('SUB_ARKUI_DECORATOR_ONCE_0100',
      TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
        let changeLocalNumCom :Component = await driver.findComponent(ON.text("changeLocalNum"));
        let coordinate1 = await getCenterPoint(changeLocalNumCom,0);
        await driver.click(coordinate1.x,coordinate1.y);
        await sleep(DELAY_TIME01);
        let changeLocalInfoCom :Component = await driver.findComponent(ON.text("changeLocalInfo"));
        let coordinate2 = await getCenterPoint(changeLocalInfoCom,0);
        await driver.click(coordinate2.x,coordinate2.y);
        await sleep(DELAY_TIME01);
        let changeOnceParamNumCom :Component = await driver.findComponent(ON.text("changeOnceParamNum"));
        let coordinate3 = await getCenterPoint(changeOnceParamNumCom,0);
        await driver.click(coordinate3.x,coordinate3.y);
        await sleep(DELAY_TIME01);
        let changeParamInfoCom :Component = await driver.findComponent(ON.text("changeParamInfo"));
        let coordinate4 = await getCenterPoint(changeParamInfoCom,0);
        await driver.click(coordinate4.x,coordinate4.y);
        await sleep(DELAY_TIME01);
        done();
      })

    /**
     * @tc.number  : SUB_ARKUI_DECORATOR_ONCE_0200
     * @tc.name    : SUB_ARKUI_DECORATOR_ONCE_0200
     * @tc.desc    : Testing DestroyChildProcessConfigs returns an invalid parameter error code.
     * @tc.level   : Level1
     * @tc.size    : MediumTest
     * @tc.type    : Function
     */
    it('SUB_ARKUI_DECORATOR_ONCE_0200',
      TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      router.push({url:"pages/MyComponent"});
        await sleep(DELAY_TIME01);
        let changeMessageCom :Component = await driver.findComponent(ON.text("change message"));
        let coordinate1 = await getCenterPoint(changeMessageCom,0);
        await driver.click(coordinate1.x,coordinate1.y);
        await sleep(DELAY_TIME01);
        done();
      })
  })
}