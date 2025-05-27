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
const BUNDLE = 'Animation_'
const TAG = '[Sample_Animation]';
const DOMAIN = 0xF811

let aimComponent : Component

export function ParticleTest() {
  describe('Animation_ParticleTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_label"))));
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
      * @tc.number: Animation_ParticleTest_001
      * @tc.name: Set circle particle
      * @tc.desc: Set circle particle
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_001_end');
    })

    /*
      * @tc.number: Animation_ParticleTest_002
      * @tc.name: Set image particle
      * @tc.desc: Set image particle
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_002_end');
    })

    /*
      * @tc.number: Animation_ParticleTest_003
      * @tc.name: Set particle animate
      * @tc.desc: Set particle animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_003_end');
    })

    /*
      * @tc.number: Animation_ParticleTest_004
      * @tc.name: Set particle position
      * @tc.desc: Set particle position
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_004_end');
    })

    /*
      * @tc.number: Animation_ParticleTest_005
      * @tc.name: Create circle launcher
      * @tc.desc: Create circle launcher
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_005_end');
    })

    /*
      * @tc.number: Animation_ParticleTest_006
      * @tc.name: Update circle launcher
      * @tc.desc: Update circle launcher
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ParticleTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.particle_temp_label6"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
      hilog.info(DOMAIN, TAG, 'Animation_ParticleTest_006_end');
    })

  })
}