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
const BUNDLE = 'AnimationBlur_'
const TAG = '[Sample_AnimationBlur]';
const DOMAIN = 0xF811

let aimComponent : Component

export function AnimationBlurTest() {
  describe('Animation_AnimationBlurTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label"))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: Animation_AnimationBlurTest_001
     * @tc.name: Add background blur to components using backdropBlur
     * @tc.desc: Add background blur to components using backdropBlur
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationBlurTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_001_end');
    })

    /*
     * @tc.number: Animation_AnimationBlurTest_002
     * @tc.name: Add content blur to components using blur
     * @tc.desc: Add content blur to components using blur
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationBlurTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(500, 200, 500, 500)
      await driver.delayMs(1000);
      await driver.swipe(500, 500, 500, 200)
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_002_end');
    })

    /*
     * @tc.number: Animation_AnimationBlurTest_003
     * @tc.name: Add background blur effect to components using backgroundBlurStyle
     * @tc.desc: Add background blur effect to components using backgroundBlurStyle
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationBlurTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_003_end');
    })

    /*
     * @tc.number: Animation_AnimationBlurTest_004
     * @tc.name: Add content blurring effect to components using foregroundBlurStyle
     * @tc.desc: Add content blurring effect to components using foregroundBlurStyle
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationBlurTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_004_end');
    })

    /*
     * @tc.number: Animation_AnimationBlurTest_005
     * @tc.name: Add motion blur effects to components using motionBlur
     * @tc.desc: Add motion blur effects to components using motionBlur
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationBlurTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_blur_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Image'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationBlurTest_005_end');
    })

  })
}