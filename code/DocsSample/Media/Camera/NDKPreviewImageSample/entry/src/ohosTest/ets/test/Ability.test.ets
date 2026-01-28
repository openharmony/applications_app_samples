/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import Base from '@ohos.base';
import { Driver, ON, MatchPattern, Component } from '@ohos.UiTest';
import Want from '@ohos.app.ability.Want';

const TAG = 'abilityTest';
const domain: number = 0x0000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('captureTest', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        let want: Want = {
          bundleName: 'com.samples.NdkRotationDemo',
          abilityName: 'EntryAbility'
        };
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
          hilog.info(domain, TAG, 'StartAbility get err ' + JSON.stringify(err));
          // expect(err).assertNull();
        })

        let driver = Driver.create();
        await driver.delayMs(1000);
        let permissionButton: Component | null = null;
        for (let i = 0; i < 3; i++) {
          permissionButton = await driver.waitForComponent(ON.text('允许', MatchPattern.EQUALS), 1000);
          if (permissionButton != null) {
            await permissionButton.click();
            console.info('  after permissionButton.click ');
            await driver.delayMs(300); // 等待下一个权限请求弹窗出现
          }
      }

        await driver.delayMs(300);
        console.info('%{public}s', '  beforeAll 6');
        let btn1 = await driver.findComponent(ON.text('拍照', MatchPattern.EQUALS));
        console.info('captureTest btn1' + JSON.stringify(btn1));
        await btn1.click();
        await driver.delayMs(300);
        console.info('%{public}s', '  beforeAll 8');
        let btn2 = await driver.findComponent(ON.type('Button').id('TakePicture'));
        console.info('captureTest btn2' + JSON.stringify(btn2));
        await btn2.click();
        console.info('%{public}s', '  beforeAll 10');
        await driver.delayMs(3000);
        let btn3 = await driver.findComponent(ON.text('保存', MatchPattern.EQUALS));
        console.info('captureTest btn3' + JSON.stringify(btn3));
        await btn3.click();
        await driver.delayMs(1000);
        let editPage = await driver.findComponent(ON.type('Column').id('EditPageView'));
        console.info('captureTest editPage' + JSON.stringify(btn3));
        expect(editPage == null).assertFalse();
        await driver.delayMs(1000);
        let btn4 = await driver.findComponent(ON.type('Image').id('back'));
        console.info('captureTest btn4' + JSON.stringify(btn4));
        await btn4.click();
        await driver.delayMs(1000);
    } catch (err) {
        console.info('  captureTest failed, err: ' + err);
    }
    })

    it('record', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        let driver = Driver.create();
        await driver.delayMs(300);
        let btn1 = await driver.findComponent(ON.text('录像', MatchPattern.EQUALS));
        console.info('record btn1' + JSON.stringify(btn1));
        await btn1.click();
        await driver.delayMs(300);
        console.info('%{public}s', '  record 8');
        let btn2 = await driver.findComponent(ON.type('Button').id('TakePicture'));
        console.info('record btn2' + JSON.stringify(btn2));
        await btn2.click();
        console.info('%{public}s', '  record 10');
        await driver.delayMs(3000);
        let btn3 = await driver.findComponent(ON.type('Button').id('StopVideo'));
        console.info('record btn3' + JSON.stringify(btn3));
        await btn3.click();
        await driver.delayMs(500);
        let btn4 = await driver.findComponent(ON.type('SaveButton'));
        console.info('record btn4' + JSON.stringify(btn4));
        await btn4.click();
        await driver.delayMs(500);
        let allow = await driver.findComponent(ON.text('允许', MatchPattern.EQUALS));
        console.info('record allow' + JSON.stringify(allow));
        await allow.click();
        await driver.delayMs(500);
        let video = await driver.findComponent(ON.type('Video'));
        console.info('record video' + JSON.stringify(video));
        await video.click();
        await driver.delayMs(500);
        await video.click();
        let editPage = await driver.findComponent(ON.type('Column').id('EditPageView'));
        console.info('record editPage' + JSON.stringify(editPage));
        expect(editPage == null).assertFalse();
        await driver.delayMs(500);
        let btn5 = await driver.findComponent(ON.type('Image').id('back'));
        console.info('record btn5' + JSON.stringify(btn5));
        await btn5.click();
        await driver.delayMs(500);
      } catch (err) {
        console.info('  record failed, err: ' + err);
      }
    })
  })
}