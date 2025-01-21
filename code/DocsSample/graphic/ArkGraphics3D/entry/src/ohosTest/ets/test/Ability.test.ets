/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import Logger from '../utils/Logger';

const TAG = '[Sample_Graphics3D]';
const BUNDLE = 'MyApp_';
const DELAYMS_1S = 1000;
const DELAYMS_2S = 2000;

const bundleName = abilityDelegatorRegistry.getArguments().bundleName;


export default function abilityTest() {
  describe('abilityTest', () => {
    // Test to verify starting the EntryAbility within a specific bundle.
    // Logs test start/end and any startup errors. Signals completion.
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

    // Test to verify navigation through a series of UI components within a scene.
    // Interacts with various buttons and checks for their existence. Logs test entry.
    // In case of failure, marks the test as failed. Signals completion on success.
    it(BUNDLE + 'Scene_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'Scene_001' + 'in');
        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('scene'));
        let sceneButton = await driver.findComponent(ON.id('scene'));
        await sceneButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('init'));
        let initButton = await driver.findComponent(ON.id('init'));
        await initButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        let backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('camera'));
        let cameraButton = await driver.findComponent(ON.id('camera'));
        await cameraButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('light'));
        let lightButton = await driver.findComponent(ON.id('light'));
        await lightButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        done();
      } catch {
        expect().assertFail();
      }
    })

    // Test to verify the navigation and interaction with resource-related UI components.
    // Logs test entry, checks for the existence of resource buttons, and interacts with them.
    // Interacts with resource, material, shader, image, env, and back buttons in sequence.
    // In case of failure, marks the test as failed. Signals completion on success.
    it(BUNDLE + 'Resource_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'Resource_001' + 'in');
        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('resource'));
        let resourceButton = await driver.findComponent(ON.id('resource'));
        await resourceButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('material'));
        let materialButton = await driver.findComponent(ON.id('material'));
        await materialButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('shader'));
        let shaderButton = await driver.findComponent(ON.id('shader'));
        await shaderButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('image'));
        let imageButton = await driver.findComponent(ON.id('image'));
        await imageButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('env'));
        let envButton = await driver.findComponent(ON.id('env'));
        await envButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        let backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        done();
      } catch {
        expect().assertFail();
      }
    })

    // Test to verify the functionality of animation controls within an application.
    // Logs test entry and checks for the existence of various animation control buttons.
    // Interacts with the animation, start, pause, stop, finish, restart, seek, and back buttons in sequence.
    // In case of failure, marks the test as failed. Signals completion on success.
    it(BUNDLE + 'Animation_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'Animation_001' + 'in');
        let driver = Driver.create();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('animation'));
        let animationButton = await driver.findComponent(ON.id('animation'));
        await animationButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('start'));
        let startButton = await driver.findComponent(ON.id('start'));
        await startButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('pause'));
        let pauseButton = await driver.findComponent(ON.id('pause'));
        await pauseButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('stop'));
        let stopButton = await driver.findComponent(ON.id('stop'));
        await stopButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('finish'));
        let finishButton = await driver.findComponent(ON.id('finish'));
        await finishButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('restart'));
        let restartButton = await driver.findComponent(ON.id('restart'));
        await restartButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('seek'));
        let seekButton = await driver.findComponent(ON.id('seek'));
        await seekButton.click();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('back'));
        let backButton = await driver.findComponent(ON.id('back'));
        await backButton.click();
        await driver.delayMs(DELAYMS_1S);

        done();
      } catch {
        expect().assertFail();
      }
    })
  });
}