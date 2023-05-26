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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const DRIVER = Driver.create();
const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it('StartAbility_1', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_1 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.screenshot',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_1 end');
    })

    /**
     * 点击菜单栏，判断是否出现弹窗
     */
    it('GetDialog_1', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'GetDialog_1 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('menu'));
      let menu = await DRIVER.findComponent(ON.id('menu'));
      await menu.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('screenShot'));
      await DRIVER.assertComponentExist(ON.id('localScreenShot'));
      hilog.info(0x0000, 'testTag', 'GetDialog_1 end');
    })

    /**
     * 点击截屏，查看是否出现弹窗
     */
    it('ScreenShot_1', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'ScreenShot_1 begin');
      let screenShotBtn = await DRIVER.findComponent(ON.id('screenShot'));
      await screenShotBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('screenResult'));
      let screenResult1 = await DRIVER.findComponent(ON.id('screenResult'));
      await screenResult1.click();
      await DRIVER.delayMs(1000);
      let screenResult2 = await DRIVER.findComponent(ON.id('screenResult'));
      expect(screenResult2).assertNull();
      hilog.info(0x0000, 'testTag', 'ScreenShot_1 end');
    })

    /**
     * 点击局部截屏，点击确定，查看是否出现弹窗
     */
    it('LocalScreenShot_1', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'LocalScreenShot_1 begin');
      await DRIVER.assertComponentExist(ON.id('menu'));
      let menu = await DRIVER.findComponent(ON.id('menu'));
      await menu.click();
      await DRIVER.delayMs(1000);
      let localScreenShotBtn = await DRIVER.findComponent(ON.id('localScreenShot'));
      await localScreenShotBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('finish'));
      let finishBtn = await DRIVER.findComponent(ON.id('finish'));
      await finishBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('screenResult'));
      let screenResult1 = await DRIVER.findComponent(ON.id('screenResult'));
      await screenResult1.click();
      await DRIVER.delayMs(1000);
      let screenResult2 = await DRIVER.findComponent(ON.id('screenResult'));
      expect(screenResult2).assertNull();
      hilog.info(0x0000, 'testTag', 'LocalScreenShot_1 end');
    })

    /**
     * 打开隐私窗口，再次使用截屏，查看是否有警告弹窗
     */
    it('OpenPrivacy_1', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'OpenPrivacy_1 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('privacy'));
      // toggle无法监听状态
      let privacyBtn = await DRIVER.findComponent(ON.id('privacy'));
      await privacyBtn.click();
      await DRIVER.delayMs(1000);
      // 打开菜单
      await DRIVER.assertComponentExist(ON.id('menu'));
      let menu = await DRIVER.findComponent(ON.id('menu'));
      await menu.click();
      await DRIVER.delayMs(1000);
      // 开始截屏
      let screenShotBtn = await DRIVER.findComponent(ON.id('screenShot'));
      await screenShotBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.privacy'))))
      // 再次打开菜单
      await menu.click();
      await DRIVER.delayMs(1000);
      // 开始局部截屏
      let localScreenShotBtn = await DRIVER.findComponent(ON.id('localScreenShot'));
      await localScreenShotBtn.click();
      await DRIVER.delayMs(2000);
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.privacy'))));
      hilog.info(0x0000, 'testTag', 'OpenPrivacy_1 end');
    })
  })
}