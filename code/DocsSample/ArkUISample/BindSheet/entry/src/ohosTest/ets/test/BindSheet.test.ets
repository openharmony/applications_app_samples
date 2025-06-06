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
const BUNDLE = 'BindSheet_'
const TAG = '[Sample_BindSheet_]';
const DOMAIN = 0xF811
let resourceManager = delegator.getAppContext().resourceManager;
const driver = Driver.create();

let aimComponent : Component

export function BindSheetTest() {
  describe('BindSheet_BindSheetTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.bindsheet',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label'))));
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
     * @tc.number: BindSheet_BindSheetTest_001
     * @tc.name: example_one_BindSheet
     * @tc.desc: example_one_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Set Illegal height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_001_end');

    })

    /*
     * @tc.number: BindSheet_BindSheetTest_002
     * @tc.name: example_two_BindSheet
     * @tc.desc: example_two_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label2'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.565)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.21186)

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(endX, endY, startX, Math.floor(size.y * 0.53));
      await driver.delayMs(1000);

      await driver.swipe(endX, endY, startX, Math.floor(size.y * 0.883));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_002_end');
    })

    /*
     * @tc.number: BindSheet_BindSheetTest_003
     * @tc.name: example_three_BindSheet
     * @tc.desc: example_three_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label3'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_003_end');

    })

    /*
     * @tc.number: BindSheet_BindSheetTest_004
     * @tc.name: example_four_BindSheet
     * @tc.desc: example_four_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label4'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('NoRegisterSpringback'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.5)
      await driver.swipe(x, Math.floor(size.y * 0.4125), x, Math.floor(size.y * 0.95));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_004_end');
    })


    /*
     * @tc.number: BindSheet_BindSheetTest_005
     * @tc.name: example_five_BindSheet
     * @tc.desc: example_five_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label5'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('BindSheet'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.5)

      await driver.swipe(x, Math.floor(size.y * 0.706), x, Math.floor(size.y * 0.353));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_005_end');
    })

    /*
     * @tc.number: BindSheet_BindSheetTest_006
     * @tc.name: example_six_BindSheet
     * @tc.desc: example_six_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label6'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('TextInput'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_006_end');

    })

    /*
     * @tc.number: BindSheet_BindSheetTest_007
     * @tc.name: example_seven_BindSheet
     * @tc.desc: example_seven_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label7'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_007_end');
    })

   /*
    * @tc.number: BindSheet_BindSheetTest_008
    * @tc.name: example_eight_BindSheet
    * @tc.desc: example_eight_BindSheet
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it(BUNDLE + 'BindSheetTest_008', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_008_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label8'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.sideBuilder_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_008_end');
    })


   /*
    * @tc.number: BindSheet_BindSheetTest_009
    * @tc.name: example_nine_BindSheet
    * @tc.desc: example_nine_BindSheet
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it(BUNDLE + 'BindSheetTest_009', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_009_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label9'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.temp9string_text9'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_009_end');
    })

    /*
     * @tc.number: BindSheet_BindSheetTest_0010
     * @tc.name: example_ten_BindSheet
     * @tc.desc: example_ten_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BindSheetTest_0010', 0, async () => {
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_010_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.bindSheet_label10'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Open Sheet'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.353)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.106)

      await driver.swipe(startX, Math.floor(size.y * 0.6356), endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, Math.floor(size.y * 0.282), endX, Math.floor(size.y * 0.6356));
      await driver.delayMs(1000);

      await driver.swipe(startX, Math.floor(size.y * 0.53), endX, Math.floor(size.y * 0.8828));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'BindSheet_BindSheetTest_010_end');
    })

  })

}