/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, it, beforeAll, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../utils/Logger';

const TAG = '[Sample_DisplaySync]';
const DELAYMS_1S = 1000;
const DELAYMS_2S = 2000;
const DELAYMS_5S = 5000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.displaySync',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }

      Logger.info(TAG, 'beforeAll end');
      done();
    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0100
     * @tc.name:CustomDraw_001
     * @tc.desc:CustomDraw
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it('CustomDraw_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'CustomDraw_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('CustomDraw'));
        let customDrawButton = await driver.findComponent(ON.id('CustomDraw'));
        await customDrawButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('CustomDrawStart'));
        let startButton = await driver.findComponent(ON.id('CustomDrawStart'));
        await startButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('CustomDrawStop'));
        let stopButton = await driver.findComponent(ON.id('CustomDrawStop'));
        await stopButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('CustomDrawBack'));
        let backButton = await driver.findComponent(ON.id('CustomDrawBack'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        Logger.info(TAG, 'CustomDraw_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }

    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0200
     * @tc.name:PropertyAnimation_001
     * @tc.desc:PropertyAnimation
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it('PropertyAnimation_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'PropertyAnimation_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('PropertyAnimation'));
        let propertyAnimationButton = await driver.findComponent(ON.id('PropertyAnimation'));
        await propertyAnimationButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('PropertyAnimationStart'));
        let startButton = await driver.findComponent(ON.id('PropertyAnimationStart'));
        await startButton.click();
        await driver.delayMs(DELAYMS_5S);

        await driver.assertComponentExist(ON.id('PropertyAnimationBack'));
        let backButton = await driver.findComponent(ON.id('PropertyAnimationBack'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        Logger.info(TAG, 'PropertyAnimation_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }

    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0300
     * @tc.name:XComponent_001
     * @tc.desc:XComponent
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it('XComponent_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'XComponent_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('XComponent'));
        let xComponentButton = await driver.findComponent(ON.id('XComponent'));
        await xComponentButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('Start'));
        let startButton = await driver.findComponent(ON.id('Start'));
        await startButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('Stop'));
        let stopButton = await driver.findComponent(ON.id('Stop'));
        await stopButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('Back'));
        let backButton = await driver.findComponent(ON.id('Back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        Logger.info(TAG, 'XComponent_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }

    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0400
     * @tc.name:Animator_001
     * @tc.desc:Animator
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it('Animator_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'Animator_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('Animator'));
        let animatorButton = await driver.findComponent(ON.id('Animator'));
        await animatorButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('AnimatorCreate'));
        let startButton = await driver.findComponent(ON.id('AnimatorCreate'));
        await startButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('AnimatorPlay'));
        let stopButton = await driver.findComponent(ON.id('AnimatorPlay'));
        await stopButton.click();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('AnimatorBack'));
        let backButton = await driver.findComponent(ON.id('AnimatorBack'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        Logger.info(TAG, 'Animator_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }

    });
  })
}