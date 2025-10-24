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
import { abilityDelegatorRegistry, Component, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, expect, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';
import resource from '../../../main/ets/common/resource';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()

const driver = Driver.create();
const BUNDLE = 'Freeze_'
const TAG = '[Sample_Freeze]';
const DOMAIN = 0xF811

let aimComponent : Component

export function FreezeTest() {
  describe('Freeze_FreezeTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.reusablev2',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label"))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('ReusableV2'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('ReusableV2'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: Animation_FreezeTest_001
     * @tc.name: Animation_FreezeTest_001
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('changeBookName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('go to next page'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Back'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_001_end');
    })

    /*
     * @tc.number: Animation_FreezeTest_002
     * @tc.name: Custom Component Freeze Functionality
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change message'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('tab1'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('tab0'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_002_end');
    })

    /*
     * @tc.number: Animation_FreezeTest_003
     * @tc.name: Custom Component Freeze Functionality
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Next Page'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('change message'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Back Page'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_003_end');
    })

    /*
     * @tc.number: Animation_FreezeTest_004
     * @tc.name: Custom Component Freeze Functionality
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Reduce length to 5'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Change bgColor'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_004_end');
    })

    /*
     * @tc.number: Animation_FreezeTest_005
     * @tc.name: Custom Component Freeze Functionality
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Next Page'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Go to next page'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Back'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_005_end');
    })

    /*
     * @tc.number: Animation_FreezeTest_006
     * @tc.name: Custom Component Freeze Functionality
     * @tc.desc: Custom Component Freeze Functionality
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'FreezeTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.freeze_to_label6"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change BookName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_FreezeTest_006_end');
    })
  })
}