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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_CustomNotification]';
const DOMAIN = 0xF811;
const BUNDLE = 'CustomNotification_';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}


export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001 begin', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.customnotification",
          abilityName: "MainAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * BringPowerManager
     */
    it(BUNDLE + 'CreateCustomNotificationFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateCustomNotificationFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击允许
      await driver.assertComponentExist(ON.type('Button'));
      let buttonClick = await driver.findComponent(ON.text(await getResourceString($r('app.string.allow_button'))));
      await buttonClick.click();
      // 获取按钮
      let btnBasic = await driver.findComponent(ON.text(await getResourceString($r('app.string.basic_notification'))));
      // 点击基本类型通知
      await btnBasic.click();
      // 下拉查看通知 (固定坐标只支持RK3568)
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // 点击长文本类型通知
      let btnLong = await driver.findComponent(ON.text(await getResourceString($r('app.string.long_text_notification'))));
      await btnLong.click();
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.assertComponentExist(ON.text('CustomNotification'));
      let textButton = await driver.findComponent(ON.text('CustomNotification'));
      await textButton.click();
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // 点击多行文本类型通知
      let btnMul = await driver.findComponent(ON.text(await getResourceString($r('app.string.multiline_notification'))));
      await btnMul.click();
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // // 点击图片类型通知
      let btnPic = await driver.findComponent(ON.text(await getResourceString($r('app.string.picture_notification'))));
      await btnPic.click();
      // // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // // 点击带按钮的通知
      let btnWith = await driver.findComponent(ON.text(await getResourceString($r('app.string.notification_with_buttons'))));
      await btnWith.click();
      // // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // // 点击可跳转的通知
      let btnClick = await driver.findComponent(ON.text(await getResourceString($r('app.string.clickable_notification'))));
      await btnClick.click();
      // // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await textButton.click();
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      // // 点击取消所有通知
      let btnCancel = await driver.findComponent(ON.text(await getResourceString($r('app.string.cancel_all_notifications'))));
      await btnCancel.click();
      // // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      await driver.click(207, 1245);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateCustomNotificationFunction_001 end');
    })
  })
}

