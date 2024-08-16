/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, it, expect, beforeAll } from '@ohos/hypium';

const TAG = '[Sample_PublicAbility]';
const DOMAIN = 0xF811;
const BUNDLE = 'PublicAbility_';
const TIME = 1500;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.UIExtension',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility end');
    })

    /**
     * @tc.number     : PublicAbility_AbilityStartCallback_001
     * @tc.name       : PublicAbility_AbilityStartCallback_001
     * @tc.desc       : Test the interface in AbilityStartCallback
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_AbilityStartCallback_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_AbilityStartCallback_001 begin');

      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('AbilityStartCallback'));
      let abilityStartCallback = await driver.findComponent(ON.id('AbilityStartCallback'));
      await abilityStartCallback.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('onResult'));
      let onResult = await driver.findComponent(ON.id('onResult'));
      await onResult.click();
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('onError'));
      let onError = await driver.findComponent(ON.id('onError'));
      await onError.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_AbilityStartCallback_001 end');
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      done()
    })

    /**
     * @tc.number     : PublicAbility_UIAbilityContext_001
     * @tc.name       : PublicAbility_UIAbilityContext_001
     * @tc.desc       : Test the interface in UIAbilityContext
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_UIAbilityContext_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIAbilityContext_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('UIExtensionContext'));
      let uiExtensionContext = await driver.findComponent(ON.id('UIExtensionContext'));
      await uiExtensionContext.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('openLink'));
      let openLink = await driver.findComponent(ON.id('openLink'));
      await openLink.click();
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionFirst = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionFirst.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('reportDrawnCompleted'));
      let reportDrawnCompleted = await driver.findComponent(ON.id('reportDrawnCompleted'));
      await reportDrawnCompleted.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfCallback'));
      let terminateSelfCallback = await driver.findComponent(ON.id('terminateSelfCallback'));
      await terminateSelfCallback.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionSecond = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionSecond.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIAbilityContext_001 end');
      done()
    })

    /**
     * @tc.number     : PublicAbility_UIAbilityContext_002
     * @tc.name       : PublicAbility_UIAbilityContext_002
     * @tc.desc       : Test the interface in UIAbilityContext
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_UIAbilityContext_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIAbilityContext_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfPromise'));
      let terminateSelfPromise = await driver.findComponent(ON.id('terminateSelfPromise'));
      await terminateSelfPromise.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionThird = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionThird.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfWithResultCallback'));
      let terminateSelfWithResultCallback = await driver.findComponent(ON.id('terminateSelfWithResultCallback'));
      await terminateSelfWithResultCallback.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionFourth = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionFourth.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfWithResultPromise'));
      let terminateSelfWithResultPromise = await driver.findComponent(ON.id('terminateSelfWithResultPromise'));
      await terminateSelfWithResultPromise.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIAbilityContext_002 end');
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      done()
    })

    /**
     * @tc.number     : PublicAbility_UIExtensionContentSession_001
     * @tc.name       : PublicAbility_UIExtensionContentSession_001
     * @tc.desc       : Test the interface in UIExtensionContentSession
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_UIExtensionContentSession_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIExtensionContentSession_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('UIExtensionContentSession'));
      let uiExtensionContentSession = await driver.findComponent(ON.id('UIExtensionContentSession'));
      await uiExtensionContentSession.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionFirst = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionFirst.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfWithResultCallback'));
      let terminateSelfWithResultCallback = await driver.findComponent(ON.id('terminateSelfWithResultCallback'));
      await terminateSelfWithResultCallback.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionSecond = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionSecond.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIExtensionContentSession_001 end');
      done()
    })

    /**
     * @tc.number     : PublicAbility_UIExtensionContentSession_002
     * @tc.name       : PublicAbility_UIExtensionContentSession_002
     * @tc.desc       : Test the interface in UIExtensionContentSession
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_UIExtensionContentSession_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIExtensionContentSession_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('terminateSelfWithResultPromise'));
      let terminateSelfWithResultPromise = await driver.findComponent(ON.id('terminateSelfWithResultPromise'));
      await terminateSelfWithResultPromise.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('startUIExtensionAbility'));
      let startUIExtensionThird = await driver.findComponent(ON.id('startUIExtensionAbility'));
      await startUIExtensionThird.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('setWindowPrivacyModeCallback'));
      let setWindowPrivacyModeCallback = await driver.findComponent(ON.id('setWindowPrivacyModeCallback'));
      await setWindowPrivacyModeCallback.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('setWindowPrivacyModePromise'));
      let setWindowPrivacyModePromise = await driver.findComponent(ON.id('setWindowPrivacyModePromise'));
      await setWindowPrivacyModePromise.click();
      await driver.delayMs(TIME);

      await driver.assertComponentExist(ON.id('getUIExtensionWindowProxy'));
      let getUIExtensionWindowProxy = await driver.findComponent(ON.id('getUIExtensionWindowProxy'));
      await getUIExtensionWindowProxy.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'PublicAbility_UIExtensionContentSession_002 end');
      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      done()
    })

  })
}