/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import Logger from '../utils/Logger';

const TAG = '[Sample_DisplaySync]';
const BUNDLE = 'MyApp_'
const DELAYMS_1S = 1000;
const DELAYMS_2S = 2000;
const DELAYMS_5S = 5000;

const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('AbilityTest', () => {
    it(BUNDLE + 'StartAbility_001, begin', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001');
      let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }

      Logger.info(TAG, BUNDLE + 'StartAbility_001, end');
      done();
    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0200
     * @tc.name:PropertyAnimation_001
     * @tc.desc:PropertyAnimation
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it(BUNDLE + 'PropertyAnimation_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'PropertyAnimation_001 beg' +
          'in');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('AnimationFpsRequest'));
        let propertyAnimationButton = await driver.findComponent(ON.id('AnimationFpsRequest'));
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

        Logger.info(TAG, BUNDLE + 'PropertyAnimation_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }
    });

    it(BUNDLE + 'UiFpsRequest_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'UiFpsRequest_001, begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('UiFpsRequest'));
        let customDrawButton = await driver.findComponent(ON.id('UiFpsRequest'));

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

        Logger.info(TAG, BUNDLE + 'UiFpsRequest_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }
    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSYNC_0100
     * @tc.name:CustomDraw_001
     * @tc.desc:CustomDraw
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it(BUNDLE + 'CustomDraw_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'CustomDraw_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('XComponent'));

        let customDrawButton = await driver.findComponent(ON.id('XComponent'));

        await customDrawButton.click();
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

        Logger.info(TAG, BUNDLE + 'CustomDraw_001 end');
        done();
      } catch (error) {
        expect().assertFail();
      }
    });
  })
}