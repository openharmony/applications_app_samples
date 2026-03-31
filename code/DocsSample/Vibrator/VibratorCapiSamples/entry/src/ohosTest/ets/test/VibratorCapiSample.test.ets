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
import hilog from '@ohos.hilog';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';

const TAG = 'Sample_Vibrator_Capi';
const DOMAIN = 0xD002701;
const BUNDLE = 'VibratorCapiSample';

export default function vibratorCapiSampleTest() {
  describe('vibratorCapiSampleTest', () => {
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

    /**
     * 测试设备正常运行
     */
    it(BUNDLE + 'VibratorCapiTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_001 begin');
      // 启动应用
      try {
        let want: Want = {
          bundleName: "com.example.vibratorcapisamples",
          abilityName: "EntryAbility"
        };

        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        abilityDelegator.startAbility(want, (err) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_001,err.code:' + err.code);
          expect(0).assertEqual(err.code);
        });
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_001,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_001 end');
      done();
    });

    /**
     * 测试马达在指定时间内持续振动和停止马达振动接口
     */
    it(BUNDLE + 'VibratorCapiTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_002 begin');
      try {
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('playVibrationInDurationId'));
        let statusChangeButton = await driver.findComponent(ON.id('playVibrationInDurationId'));
        await statusChangeButton.click();
        await driver.delayMs(1500);
        const statusDisplay = await driver.findComponent(ON.id('vibratorCapiResultId'));
        await driver.delayMs(1000);
        const statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('playVibrationInDuration:success');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_002,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_002 end');
      done();
    });

    /**
     * 测试播放自定义振动序列接口
     */
    it(BUNDLE + 'VibratorCapiTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_003 begin');
      try {
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('playVibrationCustomId'));
        let statusChangeButton = await driver.findComponent(ON.id('playVibrationCustomId'));
        await statusChangeButton.click();
        await driver.delayMs(1500);
        const statusDisplay = await driver.findComponent(ON.id('vibratorCapiResultId'));
        await driver.delayMs(1000);
        const statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('playVibrationCustom:success');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_003,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'VibratorCapiTest_003 end');
      done();
    });
  });

}