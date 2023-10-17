/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG: string = '[Sample_CustomShare]';
const DOMAIN = 0xF811;
const BUNDLE = 'CustomShare_';
let ability: UIAbility;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.customshare',
          abilityName: 'MainAbility'
        });
        done();
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection));
        done();
      }
      ability = await abilityDelegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 获取允许
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      let btnAccept = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      while (btnAccept !== null) {
        await btnAccept.click();
        await driver.delayMs(500);
        btnAccept = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 点击文本+链接分享
     */
    it(BUNDLE + 'ShareLinkFunction_001', 0, async () => {
      let resourceManager = ability.context.resourceManager;
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击文本+链接分享按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 clickShareLinkButton');
      await driver.assertComponentExist(ON.id('shareLinkResource'));
      let shareLink = await driver.findComponent(ON.id('shareLinkResource'));
      await shareLink.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击Chat
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 clickChatButton');
      await driver.assertComponentExist(ON.text('Chat'));
      let chatBtn = await driver.findComponent(ON.text('Chat'));
      await chatBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      // 点击朋友0分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 chatShare');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      let chatShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      await chatShare.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.title'))));
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 pressBack');
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareLinkResource'));
      // 再次点击文本+链接分享按钮
      await shareLink.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击生成海报
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 clickGeneratePoster');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      let generatePoster = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      await generatePoster.click();
      await driver.delayMs(1000);
      // 点击截图并分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 clickShot');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      let shot = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      await shot.click();
      await driver.delayMs(400);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot_prompt'))));
      // 返回
      await driver.delayMs(3000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareLinkResource'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareLinkFunction_001 end');
    })

    /**
     * 点击应用内文件分享
     */
    it(BUNDLE + 'ShareFileFunction_001', 0, async () => {
      let resourceManager = ability.context.resourceManager;
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击应用内文件分享按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 clickShareFileButton');
      await driver.assertComponentExist(ON.id('shareFileResource'));
      let shareFile = await driver.findComponent(ON.id('shareFileResource'));
      await shareFile.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击Chat
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 clickChatButton');
      await driver.assertComponentExist(ON.text('Chat'));
      let chatBtn = await driver.findComponent(ON.text('Chat'));
      await chatBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      // 点击朋友0分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 chatShare');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      let chatShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      await chatShare.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.title'))));
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 pressBack');
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareFileResource'));
      // 再次点击应用内文件分享按钮
      await shareFile.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击生成海报
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 clickGeneratePoster');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      let generatePoster = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      await generatePoster.click();
      await driver.delayMs(1000);
      // 点击截图并分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 clickShot');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      let shot = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      await shot.click();
      await driver.delayMs(400);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot_prompt'))));
      // 返回
      await driver.delayMs(3000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareFileResource'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareFileFunction_001 end');
    })

    /**
     * 点击其他应用分享
     */
    it(BUNDLE + 'ShareOtherFunction_001', 0, async () => {
      let resourceManager = ability.context.resourceManager;
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击应用内文件分享按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 clickShareOtherButton');
      await driver.assertComponentExist(ON.id('shareOtherResource'));
      let shareOther = await driver.findComponent(ON.id('shareOtherResource'));
      await shareOther.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击Chat
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 clickChatButton');
      await driver.assertComponentExist(ON.text('Chat'));
      let chatBtn = await driver.findComponent(ON.text('Chat'));
      await chatBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      // 点击朋友0分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 chatShare');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      let chatShare = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.friend'))));
      await chatShare.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.title'))));
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 pressBack');
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.chatAPP'))));
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareOtherResource'));
      // 再次点击其他应用分享按钮
      await shareOther.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toShare'));
      // 点击生成海报
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 clickGeneratePoster');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      let generatePoster = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.img_share'))));
      await generatePoster.click();
      await driver.delayMs(1000);
      // 点击截图并分享
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 clickShot');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      let shot = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.shot'))));
      await shot.click();
      await driver.delayMs(400);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shot_prompt'))));
      // 返回
      await driver.delayMs(3000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('shareOtherResource'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareOtherFunction_001 end');
    })
  })
}