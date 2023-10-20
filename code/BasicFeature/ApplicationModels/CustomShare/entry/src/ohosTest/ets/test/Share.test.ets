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

import { describe, beforeEach, it, beforeAll, expect } from '@ohos/hypium';
import { Driver, ON, } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_Share_Test]';
const DOMAIN = 0xF811;
const BUNDLE = 'Share_';
let delegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = delegator.getAppContext().resourceManager;
let driver = Driver.create();
let buttonId = 'shareLinkResource';

export default function shareTest() {
  describe('ActsShareTest', () => {
    beforeAll(async () => {
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      try {
        await delegator.startAbility({
          bundleName: 'ohos.samples.customshare',
          abilityName: 'MainAbility'
        });
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection));
      }
      await driver.delayMs(1500);
      let btnAccept = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      while (btnAccept !== null) {
        await btnAccept.click();
        await driver.delayMs(500);
        btnAccept = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
        hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate accept click success');
      }
    })

    /*
     * @tc.number: Acts_ShareTemplate_0100
     * @tc.name: Test the ability to provide shared templates
     * @tc.desc: Click the share button to jump to the interface, and then click the cancel button
     */
    it('Acts_ShareTemplate_0100', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0100 start');
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id(buttonId));
      await button.click();
      await driver.delayMs(500);
      let buttons = await driver.findComponent(ON.id('cancellation'));
      await buttons.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0100 assert button exist by id: ' + buttonId);
      await driver.assertComponentExist(ON.id(buttonId));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0100 end');
      done();
    })

    /*
    * @tc.number: Acts_ShareTemplate_0200
    * @tc.name: Test the ability to provide shared templates
    * @tc.desc: Click on the share button to jump to the interface, then click on the share demo to jump to the
    *           interface, and then click on the return to share button
    */
    it('Acts_ShareTemplate_0200', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0200 start');
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.id(buttonId));
      await button.click();
      await driver.delayMs(1000);

      let textShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.text'))));
      let rect = await textShare.getBounds();
      let height =rect.bottom - rect.top;
      let point = await textShare.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      await driver.delayMs(1000);

      let turnBack = await driver.findComponent(ON.id('return'));
      await turnBack.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0100 assert button exist by id: ' + buttonId);
      await driver.assertComponentExist(ON.id(buttonId));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0200 end');
      done();
    })

    /*
    * @tc.number: Acts_ShareTemplate_0300
    * @tc.name: Test the ability to provide shared templates
    * @tc.desc: Click the share button to jump to the interface, then click the share demonstration to jump to
    *           the interface, and then click to stay in the shared text
    */
    it('Acts_ShareTemplate_0300', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0300 start');
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.id(buttonId));
      await button.click();
      await driver.delayMs(1000);

      let textShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.text'))));
      let rect = await textShare.getBounds();
      let height =rect.bottom - rect.top;
      let point = await textShare.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      await driver.delayMs(1000);

      let stay = await driver.findComponent(ON.id('stay'));
      await stay.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0300 assert message exist: It is a shared message');
      await driver.assertComponentExist(ON.id('messages'));
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0300 end');
      done();
    })

    it('Acts_ShareTemplate_0400', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0400 start');
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.id(buttonId));
      await button.click();
      await driver.delayMs(1000);
      // 点击文本编辑
      let textShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.edit'))));
      let rect = await textShare.getBounds();
      let height = rect.bottom - rect.top;
      let point = await textShare.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      await driver.delayMs(3000);
      // 点击返回
      let turnBack = await driver.findComponent(ON.id('returnShare'));
      await turnBack.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0400 assert button exist by id: ' + buttonId);
      await driver.assertComponentExist(ON.id(buttonId));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0400 end');
      done();
    })

    /*
    * @tc.number: Acts_ShareTemplate_0400
    * @tc.name: Test the ability to provide shared templates
    * @tc.desc: Click the share button to jump to the interface, then click the share demonstration to jump to
    *           the interface, and then click to stay in the share editing mode
    */
    it('Acts_ShareTemplate_0500', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0500 start');
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.id(buttonId));
      await button.click();
      await driver.delayMs(1000);

      let textShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.edit'))));
      let rect = await textShare.getBounds();
      let height =rect.bottom - rect.top;
      let point = await textShare.getBoundsCenter();
      await driver.click(point.x, point.y - height);
      await driver.delayMs(1000);

      let stay = await driver.findComponent(ON.id('stay'));
      await stay.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0500 assert messagesTextArea exist by id: messagesTextArea');
      await driver.assertComponentExist(ON.id('messagesTextArea'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Acts_ShareTemplate_0500 end');
      done();
    })
  })
}