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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

const driver = Driver.create();
const BUNDLE = 'Animation_';
const TAG = '[Sample_Animation]';
const DOMAIN = 0xF811;

let aimComponent : Component;

export function ShareTransitionTest() {
  describe('Animation_ShareTransitionTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label"))));
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
      * @tc.number: Animation_ShareTransitionTest_001
      * @tc.name: Set share transition animate
      * @tc.desc: Set share transition animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_001_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_002
      * @tc.name: Animation_ShareTransitionTest_002
      * @tc.desc: The scenario where a new container is not created and the original container is directly modified
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Alice'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Bob'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Carl'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_002_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_003
      * @tc.name: Animation_ShareTransitionTest_003
      * @tc.desc: Create a new container and migrate components across containers with stack
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_text12"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_text13"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(500, 800, 500, 20);
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_text14"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_003_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_004
      * @tc.name: Animation_ShareTransitionTest_004
      * @tc.desc: Create a new container and migrate components across containers with navigation
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_004_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_005
      * @tc.name: Animation_ShareTransitionTest_005
      * @tc.desc: Set share transition animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_005_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_006
      * @tc.name: Animation_ShareTransitionTest_006
      * @tc.desc: Set share transition animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label6"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_006_end');
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_007
      * @tc.name: Animation_ShareTransitionTest_007
      * @tc.desc: Set share transition animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label7"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Image'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_007_end');
    })
  })
}