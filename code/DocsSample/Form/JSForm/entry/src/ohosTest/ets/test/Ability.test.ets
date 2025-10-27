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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, Point, On } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_JSForm]';
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

const START_SLIDING_X = 839;
const FINISH_SLIDING_X = 250;
const SLIDING_COORDINATE_Y = 1422;

async function addForm(point: Point, index:number) {
  hilog.info(DOMAIN, TAG, 'addForm start');
  // 长按指定位置的应用图标
  await driver.longClick(point.x, point.y);
  // 点击卡片选项
  await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
  let serviceCard: Component =
    await driver.findComponent(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
  await serviceCard.click();
  await driver.delayMs(DELAYTIME02);
  for (let i = 0; i < index; i++) {
    await driver.swipe(START_SLIDING_X, SLIDING_COORDINATE_Y, FINISH_SLIDING_X, SLIDING_COORDINATE_Y, DELAYTIME02);
    hilog.info(DOMAIN, TAG, `swipernumber:${i+1}`);
    await driver.delayMs(DELAYTIME01);
  }
  // 点击添加至桌面
  let addCard: Component =
    await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
  await driver.delayMs(DELAYTIME01);
  await addCard.click();
  hilog.info(DOMAIN, TAG, 'addForm finish');
}

async function onRemoveForm(point: Point) {
  hilog.info(DOMAIN, TAG, 'removeForm start');
  // 长按指定位置的应用图标
  await driver.longClick(point.x, point.y);
  // 点击卡片选项
  await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.remove_form_to_desktop'))));
  let serviceCard: Component =
    await driver.findComponent(ON.text(await getResourceString($r('app.string.remove_form_to_desktop'))));
  await serviceCard.click();
  await driver.delayMs(DELAYTIME01);
  let deleteCard: Component =
    await driver.findComponent(ON.originalText(await getResourceString($r('app.string.remove_form_to_desktop'))));
  await deleteCard.click();
  await driver.delayMs(DELAYTIME01);
  hilog.info(DOMAIN, TAG, 'removeForm finish');
}
export default function abilityTest() {
  describe('JSFormTest', () => {
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, 'Back to desktop and add form end');
    });
    afterEach(async () => {
      let formComponent: Component = await driver.findComponent(ON.type('FormComponent'));
      if(formComponent != null){
        let point1: Point = await getCenterPoint(formComponent, 0);
        await onRemoveForm(point1);
      }
    });
    /**
     * 添加具有事件的卡片
     */
    it('JSForm_addform_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'JSForm_addform_001 test start');
      await driver.delayMs(DELAYTIME01);
      await driver.pressBack();
      await driver.delayMs(DELAYTIME01);
      // 找到应用位置
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')));
      let formEditDemoIcon: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')));
      let point: Point = await getCenterPoint(formEditDemoIcon, 2);
      await addForm(point, 0);
      // 找到卡片是否存在
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.type('FormComponent'));
      hilog.info(DOMAIN, TAG, 'JSForm_addform_001 test end');
      done();
    });

    /**
     * 添加卡片
     */
    it('JSForm_addform_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'JSForm_addform_002 test start');
      await driver.delayMs(DELAYTIME01);
      await driver.pressBack();
      await driver.delayMs(DELAYTIME01);
      // 找到应用位置
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')));
      let formEditDemoIcon: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')));
      let point: Point = await getCenterPoint(formEditDemoIcon, 2);
      await addForm(point, 1);
      // 找到卡片是否存在
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.type('FormComponent'));
      hilog.info(DOMAIN, TAG, 'JSForm_addform_002 test end');
      done();
    });
  })
}
