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
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import Base from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import delegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from 'ets/util/Logger';
import formManagerAbility from '@ohos.app.form.formHost';
import formInfo from '@ohos.app.form.formInfo';

const TAG = '[Sample_ArkTSCard]';
const BUNDLE = 'sub_';
let ability: UIAbility | null = null;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', () => {

    beforeAll(async (startAbility: Function) => {
      Logger.info(TAG, `${BUNDLE}beforeAll begin`)
      let delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: "com.samples.arktscard",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err: Base.BusinessError) => {
        Logger.info(TAG, `${BUNDLE}ArkTSCard_startAbility end err ${JSON.stringify(err)}`);
      });
      await driver.delayMs(5000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        ability = Ability;
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      });
      Logger.info(TAG, `${BUNDLE}ArkTSCard_StartAbility_0100 end`);
      startAbility();
    })

    afterAll(async (lockAbilityTerminateSelf: Function) => {
      Logger.info(TAG, `${BUNDLE}lockAbilityTerminateSelf begin`)
      let abilityDelegator = delegatorRegistry.getAbilityDelegator();
      let pkillCmd = 'aa force-stop com.samples.arktscard';
      abilityDelegator.executeShellCommand(pkillCmd, (err, data) => {
        console.log('Acts_CleanTempFiles_0201 pkillCmd err: '
        + JSON.stringify(err) + ' data: ' + JSON.stringify(data));
      })
      lockAbilityTerminateSelf()
    })


    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0100
     * @tc.name: FormDeepLink_0100
     * @tc.desc: Jump to the Music Static Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0100', 0, async (FormDeepLink_0100: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0100 begin 999`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[0] !== null).assertTrue();
      await JumpCard[0].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.StaticCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0100 end`);
      FormDeepLink_0100();
    })

    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0200
     * @tc.name: FormDeepLink_0200
     * @tc.desc: Jump to the Music Dynamic Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0200', 0, async (FormDeepLink_0200: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0200 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[1] !== null).assertTrue();
      await JumpCard[1].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.DynamicCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0200 end`);
      FormDeepLink_0200();
    })

    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0300
     * @tc.name: FormDeepLink_0300
     * @tc.desc: Jump to the Book Static Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0300', 0, async (FormDeepLink_0300: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0300 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[2] !== null).assertTrue();
      await JumpCard[2].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.BookPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.StaticCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0300 end`);
      FormDeepLink_0300();
    })

    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0400
     * @tc.name: FormDeepLink_0400
     * @tc.desc: Jump to the Book Dynamic Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0400', 0, async (FormDeepLink_0400: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0400 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[3] !== null).assertTrue();
      await JumpCard[3].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.BookPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.DynamicCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0400 end`);
      FormDeepLink_0400();
    })

    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0500
     * @tc.name: FormDeepLink_0500
     * @tc.desc: Jump to the Weather Static Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0500', 0, async (FormDeepLink_0500: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0500 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[4] !== null).assertTrue();
      await JumpCard[4].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.WeatherPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.StaticCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0500 end`);
      FormDeepLink_0500();
    })

    /**
     * @tc.number: sub_ArkTSCard_FormDeepLink_0600
     * @tc.name: FormDeepLink_0600
     * @tc.desc: Jump to the Weather Dynamic Card
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_FormDeepLink_0600', 0, async (FormDeepLink_0600: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0600 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let DeepLinkBtn = await driver.findComponent(ON.text(await resourceManager
        .getStringValue($r('app.string.DeepLink'))));
      expect(DeepLinkBtn !== null).assertTrue();
      await DeepLinkBtn.click();
      await driver.delayMs(2000);
      let JumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      expect(JumpCard[5] !== null).assertTrue();
      await JumpCard[5].click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.WeatherPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.DynamicCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_FormDeepLink_0600 end`);
      FormDeepLink_0600();
    })

    /**`
     * @tc.number: sub_ArkTSCard_LockCard_0100
     * @tc.name: sub_ArkTSCard_LockCard_0100
     * @tc.desc: Click on the 1*1 static card to jump to the music static page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_LockCard_0100', 0, async (sub_ArkTSCard_LockCard_0100: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0100 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let ToUnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLockPage')))
      )
      expect(ToUnlockBtn !== null).assertTrue();
      await ToUnlockBtn.click();
      await driver.delayMs(2000);

      let UnlockJumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      await UnlockJumpCard[0].click();
      await driver.delayMs(1000);
      let UnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLock')))
      )
      expect(UnlockBtn !== null).assertTrue();
      await UnlockBtn.click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.StaticCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0100 end`);
      sub_ArkTSCard_LockCard_0100();
    })

    /**
     * @tc.number: sub_ArkTSCard_LockCard_0200
     * @tc.name: sub_ArkTSCard_LockCard_0200
     * @tc.desc: Click on the 1*2 static card to jump to the music static page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_LockCard_0200', 0, async (sub_ArkTSCard_LockCard_0200: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0200 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let ToUnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLockPage')))
      )
      expect(ToUnlockBtn !== null).assertTrue();
      await ToUnlockBtn.click();
      await driver.delayMs(2000);
      let UnlockJumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      await UnlockJumpCard[3].click();
      await driver.delayMs(1000);
      let UnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLock')))
      )
      expect(UnlockBtn !== null).assertTrue();
      await UnlockBtn.click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.StaticCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0200 end`);
      sub_ArkTSCard_LockCard_0200();
    })

    /**
     * @tc.number: sub_ArkTSCard_LockCard_0300
     * @tc.name: sub_ArkTSCard_LockCard_0300
     * @tc.desc: Click on the 1*1 static card to jump to the music dynamic page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_LockCard_0300', 0, async (sub_ArkTSCard_LockCard_0300: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0300 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let ToUnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLockPage')))
      )
      expect(ToUnlockBtn !== null).assertTrue();
      await ToUnlockBtn.click();
      await driver.delayMs(2000);
      let UnlockJumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      await UnlockJumpCard[2].click();
      await driver.delayMs(1000);
      let UnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLock')))
      )
      expect(UnlockBtn !== null).assertTrue();
      await UnlockBtn.click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.DynamicCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0300 end`);
      sub_ArkTSCard_LockCard_0300();
    })

    /**
     * @tc.number: sub_ArkTSCard_LockCard_0400
     * @tc.name: sub_ArkTSCard_LockCard_0400
     * @tc.desc: Click on the 1*2 static card to jump to the music dynamic page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('sub_ArkTSCard_LockCard_0400', 0, async (sub_ArkTSCard_LockCard_0400: Function) => {
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0400 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let ToUnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLockPage')))
      )
      expect(ToUnlockBtn !== null).assertTrue();
      await ToUnlockBtn.click();
      await driver.delayMs(2000);
      let UnlockJumpCard = await driver.findComponents(
        ON.type('FormComponent')
      );
      await UnlockJumpCard[1].click();
      await driver.delayMs(1000);
      let UnlockBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.unLock')))
      );
      expect(UnlockBtn !== null).assertTrue();
      await UnlockBtn.click();
      await driver.delayMs(2500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.MusicPage'))))
      );
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.DynamicCard'))))
      );
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}ArkTSCard_LockCard_0400 end`);
      sub_ArkTSCard_LockCard_0400();
    })
  })
}
