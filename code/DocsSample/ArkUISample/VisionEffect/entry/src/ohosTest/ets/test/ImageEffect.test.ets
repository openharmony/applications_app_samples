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
const BUNDLE = 'VisionEffect_'
const TAG = '[Sample_VisionEffect_]';
const DOMAIN = 0xF811

const driver = Driver.create();

let aimComponent : Component
let resourceManager = delegator.getAppContext().resourceManager;

export function ImageEffectTest() {
  describe('VisionEffect_ImageEffectTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('VisionEffectIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('VisionEffectIndex'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_001
     * @tc.name: example_one_imageEffect
     * @tc.desc: example_one_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_one_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_001_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_002
     * @tc.name: example_two_imageEffect
     * @tc.desc: example_two_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_two_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_002_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_003
     * @tc.name: example_three_imageEffect
     * @tc.desc: example_three_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_three_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_003_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_004
     * @tc.name: example_four_imageEffect
     * @tc.desc: example_four_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_four_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_004_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_005
     * @tc.name: example_five_imageEffect
     * @tc.desc: example_five_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_five_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_005_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_006
     * @tc.name: example_six_imageEffect
     * @tc.desc: example_six_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_six_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_006_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_007
     * @tc.name: example_seven_imageEffect
     * @tc.desc: example_seven_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_seven_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_007_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_008
     * @tc.name: example_eight_imageEffect
     * @tc.desc: example_eight_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_008', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_008_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_eight_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_008_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_009
     * @tc.name: example_nine_imageEffect
     * @tc.desc: example_nine_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_009', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_009_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_nine_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_009_end');
    })

    /*
     * @tc.number: VisionEffect_ImageEffectTest_010
     * @tc.name: example_ten_imageEffect
     * @tc.desc: example_ten_imageEffect
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ImageEffectTest_010', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_010_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_ten_imageEffect'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ImageEffectTest_010_end');
    })

  })
}