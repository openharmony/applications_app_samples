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

export function ForegroundColorTest() {
  describe('VisionEffect_ForegroundColorTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.foregroundColor'))));
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
     * @tc.number: VisionEffect_ForegroundColorTest_001
     * @tc.name: example_one_foregroundColor
     * @tc.desc: example_one_foregroundColor
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ForegroundColorTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_one_foregroundColor'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_001_end');
    })

    /*
     * @tc.number: VisionEffect_ForegroundColorTest_002
     * @tc.name: example_two_foregroundColor
     * @tc.desc: example_two_foregroundColor
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ForegroundColorTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_two_foregroundColor'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_002_end');
    })

    /*
     * @tc.number: VisionEffect_ForegroundColorTest_003
     * @tc.name: example_three_foregroundColor
     * @tc.desc: example_three_foregroundColor
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ForegroundColorTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.example_three_foregroundColor'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'VisionEffect_ForegroundColorTest_003_end');
    })

  })
}