/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ArkTSCardDemo]'
const DOMAIN = 0xF811

export default function IndexTest() {
  let driver = Driver.create();
  const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

  // 资源本地化
  async function getResourceString(resource: Resource): Promise<string> {
    let manage = delegator.getAppContext().resourceManager
    let text = await manage.getStringValue(resource)
    return text
  }

  describe('IndexTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      // 回到桌面并进入测试应用的服务卡片预览界面
      hilog.info(DOMAIN, TAG, 'Back to desktop start');
      await driver.delayMs(500);
      await driver.pressHome();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, 'Back to desktop finish');
    })
    beforeEach(async function () {
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
      let serviceCard: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_form_to_desktop'))));
      await serviceCard.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, 'Enter Card preview page finish');
    })
    afterEach(async function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      hilog.info(DOMAIN, TAG, 'Back to first page start');
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(70, 870, 670, 870, 600);
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(70, 870, 670, 870, 600);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Back to first page finish');
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('ArkTSCard_HelloWorld', 0, async function () {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_HelloWorld test start');
      await driver.assertComponentExist(ON.text('This is a service widget.'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(500);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_HelloWorld test start');
    })
    it('ArkTSCard_Animation', 0, async function () {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Animation test start');
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('This is a service widget for animation.'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(500);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Animation test start');
    })
    it('ArkTSCard_Canvas', 0, async function () {
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Canvas test start');
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(670, 870, 70, 870, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('This is a service widget for canvas.'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      let addCard: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.add_to_desktop'))));
      await addCard.click();
      await driver.delayMs(500);
      // 校验是否添加成功
      await driver.assertComponentExist(ON.text('ArkTSCardDemo'));
      hilog.info(DOMAIN, TAG, 'ArkTSCard_Canvas test finish');
    })
  })
}