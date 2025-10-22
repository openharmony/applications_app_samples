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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, Point } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_FormManagerDemo]';
const DOMAIN = 0xF811;
const BUNDLE = 'FormManagerDemo_';
const DELAYTIME01 = 500;
const DELAYTIME02 = 2000;

let driver = Driver.create();
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

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
  describe('FormManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await driver.delayMs(DELAYTIME02);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
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
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      hilog.info(DOMAIN, TAG, 'Back to first page start');
      await driver.delayMs(DELAYTIME02);
      await driver.pressBack();
    });
    it('FormManagerDemo_001', Level.LEVEL1, async () => {
      hilog.info(DOMAIN, TAG, 'FormManager test start');
      // 找到卡片是否存在
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_card_to_desktop')))).then(()=>{
        hilog.info(DOMAIN, TAG, '_FormManager_001 find component');
      });
      let formManager: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_card_to_desktop'))));
      let pointManager: Point = await getCenterPoint(formManager, 0);
      await driver.click(pointManager.x, pointManager.y);

      await driver.delayMs(DELAYTIME02);

      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))).within(ON.type('Button'))).then(()=>{
        hilog.info(DOMAIN, TAG, '_FormManager_001 find component');
      });
      let formComponent: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))).within(ON.type('Button')));
      let point: Point = await getCenterPoint(formComponent, 0);
      await driver.click(point.x, point.y);
      await driver.delayMs(DELAYTIME02);
      hilog.info(DOMAIN, TAG, 'FormManager test end');
    });
  })
}
