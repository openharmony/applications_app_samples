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
import { hilog } from '@kit.PerformanceAnalysisKit';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()

const driver = Driver.create();
const BUNDLE = 'BindSheet_'
const TAG = '[Sample_BindSheet_]';
const DOMAIN = 0xF811
let resourceManager = delegator.getAppContext().resourceManager;

let aimComponent : Component

export function BindContentCoverTest() {
  describe('BindSheet_BindContentCoverTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.bindsheet',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label'))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('Index'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('Index'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_001
     * @tc.name: example_one_BindContentCover
     * @tc.desc: example_one_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_001_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_002
     * @tc.name: example_two_BindContentCover
     * @tc.desc: example_two_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label2'))));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_002_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_003
     * @tc.name: example_three_BindContentCover
     * @tc.desc: example_three_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label3'))));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_003_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_004
     * @tc.name: example_four_BindContentCover
     * @tc.desc: example_four_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label4'))));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_004_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_005
     * @tc.name: example_five_BindContentCover
     * @tc.desc: example_five_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label5'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Transition Modal 1'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Transition Modal 2'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Close Modal 2'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Close Modal 1'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_005_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_006
     * @tc.name: example_six_BindContentCover
     * @tc.desc: example_six_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label6'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.MySheetBuilder_text2'))))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.MySheetBuilder_text1'))))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.MyContentCoverBuilder_text4'))))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_006_end');
    })

    /*
     * @tc.number: BindSheet_BindContentCoverTest_007
     * @tc.name: example_seven_BindContentCover
     * @tc.desc: example_seven_BindContentCover
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindContentCoverTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindContentCover_label7'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.MyContentCoverBuilder_text2'))))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.MyContentCoverBuilder_text4'))))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindContentCoverTest_007_end');
    })
  })
}