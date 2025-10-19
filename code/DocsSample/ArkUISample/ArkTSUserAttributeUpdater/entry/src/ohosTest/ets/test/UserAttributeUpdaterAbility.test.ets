/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import { router } from '@kit.ArkUI';

const TAG = '[Sample_ArkTSUserAttributeUpdater]';
const DOMAIN = 0xF811
const BUNDLE = 'ArkTSUserAttributeUpdater_'

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /*
     * @tc.number: ArkTSUserAttributeUpdater_StartUserAttribute_001
     * @tc.name: example_one_UserAttributeUpdater
     * @tc.desc: example_one_UserAttributeUpdater
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'StartUserAttribute_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.attributeupdater',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartUserAttribute_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('attribute modifier'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartUserAttribute_001 end')
    })

    /*
     * @tc.number: ArkTSUserAttributeUpdater_AttributeModifier_001
     * @tc.name: example_one_UserAttributeUpdater
     * @tc.desc: example_one_UserAttributeUpdater
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AttributeModifier_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AttModifier_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.attributeupdater',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `AttributeModifier_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('attribute modifier'));
      let drawPathBtn = await driver.findComponent(ON.text('attribute modifier'));
      // 点击'CustomNode'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'AttributeModifier_001 end')
      router.back();
    })

    /*
     * @tc.number: ArkTSUserAttributeUpdater_AttributeUpdate_001
     * @tc.name: example_one_UserAttributeUpdater
     * @tc.desc: example_one_UserAttributeUpdater
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AttributeUpdate_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AttUpdate_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await driver.delayMs(1000);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.attributeupdater',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `AttributeUpdate_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('attribute update'));
      let drawPathBtn = await driver.findComponent(ON.text('attribute update'));
      // 点击'LayoutDiff'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'AttributeUpdate_001 end')
    })
  })
}