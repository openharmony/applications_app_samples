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
const BUNDLE = 'VisionEffect_'
const TAG = '[Sample_VisionEffect_]';
const DOMAIN = 0xF811
let aimComponent : Component
let resourceManager = delegator.getAppContext().resourceManager;

export function BackgroundTest() {
  describe('VisionEffect_BackgroundTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.background'))));
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
     * @tc.number: VisionEffect_BackgroundTest_001
     * @tc.name: example_one_background
     * @tc.desc: example_one_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_one_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_001_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_002
     * @tc.name: example_two_background
     * @tc.desc: example_two_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_two_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_002_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_003
     * @tc.name: example_three_background
     * @tc.desc: example_three_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_three_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_003_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_004
     * @tc.name: example_four_background
     * @tc.desc: example_four_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_four_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_004_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_005
     * @tc.name: example_five_background
     * @tc.desc: example_five_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_five_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_005_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_006
     * @tc.name: example_six_background
     * @tc.desc: example_six_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_six_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_006_end');
    })

    /*
     * @tc.number: VisionEffect_BackgroundTest_007
     * @tc.name: example_seven_background
     * @tc.desc: example_seven_background
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'BackgroundTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_seven_background'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_BackgroundTest_007_end');
    })

  })
}