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
import { Driver, ON, Component, Point } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_FormStandaloneDemo]'
const DOMAIN = 0xF811
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

export default function abilityTest() {
  describe('FormStandaloneTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
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
    afterAll(async () => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      // hilog.info(DOMAIN, TAG, 'Back to first page start');
    })

    /**
     * 应用添加卡片后触发场景动效
     */
    it('FormStandaloneDemo_createStandaloneForm_001', 0, async () => {
      // 回到桌面并进入测试应用的服务卡片预览界面
      hilog.info(DOMAIN, TAG, 'Back to desktop and add form start');
      await driver.delayMs(DELAYTIME01);
      await driver.pressBack();
      await driver.delayMs(DELAYTIME01);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')))
      let formEditDemoIcon: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.EntryAbility_label'))).within(ON.type('GridItem')));
      let point: Point = await getCenterPoint(formEditDemoIcon, 2);
      hilog.info(DOMAIN, TAG, 'addForm start');
      // 长按指定位置的应用图标
      await driver.longClick(point.x, point.y);
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.app_to_delele'))).within(ON.type('Flex'))).then(()=>{
        hilog.info(DOMAIN, TAG, 'beforeAll find component');
      })
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Back to desktop and add form end');
    });
  })
}