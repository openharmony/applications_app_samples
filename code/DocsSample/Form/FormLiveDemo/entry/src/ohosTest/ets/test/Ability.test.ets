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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, Point } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_FormLiveDemo]';
const DOMAIN = 0xF811;
const DELAYTIME01 = 500;
const DELAYTIME02 = 2000;

let driver = Driver.create();
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
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

async function addForm(point: Point) {
  hilog.info(DOMAIN, TAG, 'addForm start');
  // 长按指定位置的应用图标
  await driver.longClick(point.x, point.y);
  // 点击卡片选项
  await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
  let serviceCard: Component =
    await driver.findComponent(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
  await serviceCard.click();
  await driver.delayMs(DELAYTIME01);
  // 点击添加至桌面
  // await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
  let addCard: Component =
    await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
  await driver.delayMs(DELAYTIME01);
  await addCard.click();
  hilog.info(DOMAIN, TAG, 'addForm finish');
}
export default function abilityTest() {
  describe('FormLiveTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      // 回到桌面并进入测试应用的服务卡片预览界面
      hilog.info(DOMAIN, TAG, 'Back to desktop and add form start');
      await driver.delayMs(DELAYTIME01);
      await driver.pressBack();
      await driver.delayMs(DELAYTIME01);
      // 找到应用位置
      await driver.assertComponentExist(ON.text('FormLiveDemo').within(ON.type('GridItem')))
      let formEditDemoIcon: Component = await driver.findComponent(ON.text('FormLiveDemo').within(ON.type('GridItem')));
      let point: Point = await getCenterPoint(formEditDemoIcon, 2);
      await addForm(point);
      await driver.delayMs(DELAYTIME02);
      // 确认是否存在卡片
      await driver.assertComponentExist(ON.text('FormLiveDemo').within(ON.type('Flex'))).then(()=>{
        hilog.info(DOMAIN, TAG, 'beforeAll find component');
      })
      hilog.info(DOMAIN, TAG, 'Back to desktop and add form end');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(async () => {
    });
    /**
     * 应用添加卡片后触发场景动效
     */
    it('FormLiveDemo_liveform_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'FormLiveDemo_liveform_001 test start');
      // 找到卡片是否存在
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.liveform_click'))).within(ON.type('FormComponent'))).then(()=>{
        hilog.info(DOMAIN, TAG, 'FormLiveDemo_liveform_001 find component');
      });
      let formComponent: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.liveform_click'))).within(ON.type('FormComponent')));
      let point: Point = await getCenterPoint(formComponent, 0);
      await driver.click(point.x, point.y);
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.button_cancle'))));
      hilog.info(DOMAIN, TAG, 'FormLiveDemo_liveform_001 test end');
      done();
    });
  })
}
