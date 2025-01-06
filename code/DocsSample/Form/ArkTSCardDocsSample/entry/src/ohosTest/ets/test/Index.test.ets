/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ArkTSCardDemo]'
const DOMAIN = 0xF811
const BUNDLE = 'ArkTSCard';
const DELAYTIME01 = 500;
const DELAYTIME02 = 1000;

export default function IndexTest() {
  let driver = Driver.create();
  const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

  let getResourceString: (resource: Resource) => Promise<string> =
    // 资源本地化
    async (resource: Resource): Promise<string> => {
      let manage = delegator.getAppContext().resourceManager;
      let text = await manage.getStringValue(resource);
      return text;
    };

  describe('IndexTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      // 回到桌面并进入测试应用的服务卡片预览界面
      hilog.info(DOMAIN, TAG, 'Back to desktop start');
      await driver.delayMs(DELAYTIME01);
      await driver.pressHome();
      await driver.delayMs(DELAYTIME01);
      hilog.info(DOMAIN, TAG, 'Back to desktop finish');
    });
    beforeEach(async () => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      hilog.info(DOMAIN, TAG, 'Enter Card preview page start');
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      let ArkTSCardDemo: Component = await driver.findComponent(ON.text('ArkTSCardDemo'));
      // 获取文件控件边框
      let rect = await ArkTSCardDemo.getBounds();
      // 计算文字控件高度
      let height = rect.bottom - rect.top;
      // 获取文字控件中心点
      let point = await ArkTSCardDemo.getBoundsCenter();
      await driver.longClick(point.x, point.y - height * 2);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
      let serviceCard: Component =
        await driver.findComponent(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
      await serviceCard.click();
      await driver.delayMs(DELAYTIME01);
      hilog.info(DOMAIN, TAG, 'Enter Card preview page finish');
    });
    afterEach(async () => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      hilog.info(DOMAIN, TAG, 'Back to first page start');
      await driver.delayMs(DELAYTIME02);
      await driver.swipe(70, 870, 670, 870, 600);
      await driver.delayMs(DELAYTIME02);
      await driver.swipe(70, 870, 670, 870, 600);
      await driver.delayMs(DELAYTIME02);
      hilog.info(DOMAIN, TAG, 'Back to first page finish');
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it(BUNDLE + '_HelloWorld_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_HelloWorld test start');
      await driver.assertComponentExist(ON.text('widget', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component =
        await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(500);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_HelloWorld test start');
    });
    it(BUNDLE + '_Animation_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Animation test start');
      await driver.delayMs(DELAYTIME02);
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text('animation', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component =
        await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(DELAYTIME02);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Animation test start');
    });
    it(BUNDLE + '_Canvas_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Canvas test start');
      await driver.delayMs(DELAYTIME02);
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(1000);
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text('canvas', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component =
        await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(DELAYTIME01);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Canvas test finish');
    });
  })
}