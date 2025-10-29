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
const DOMAIN = 0xF811;

let aimComponent: Component

export function ModalTransitionTest() {
  describe('Animation_ModalTransitionTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);
      await driver.swipe(500, 800, 500, 20);
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label"))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      } while (aimComponent === null)
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_001
      * @tc.name: Animation_ModalTransitionTest_001
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_001_begin');
      await driver.swipe(500, 800, 500, 1);
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_text13"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_text8"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_001_end');
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_002
      * @tc.name: Animation_ModalTransitionTest_002
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_002_begin');
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_text22"))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_002_end');
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_003
      * @tc.name: Animation_ModalTransitionTest_003
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_003_begin');
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('click'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_003_end');
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_004
      * @tc.name: Animation_ModalTransitionTest_004
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_004_begin');
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.longClick();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_004_end');
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_005
      * @tc.name: Animation_ModalTransitionTest_005
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_005_begin');
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('click'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_005_end');
    })

    /*
      * @tc.number: Animation_ModalTransitionTest_006
      * @tc.name: Animation_ModalTransitionTest_006
      * @tc.desc: Set modalTransition
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ModalTransitionTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_006_begin');
      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_label6"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent =
        await driver.findComponent(ON.text(resource.resourceToString($r("app.string.modal_transition_text31"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Row'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Animation_ModalTransitionTest_006_end');
    })
  })
}