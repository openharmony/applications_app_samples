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

const TAG = 'Sample_Sensor_Capi';
const DOMAIN = 0xD002700;
const BUNDLE = 'SensorCapiSample';

export default function sensorCapiSampleTest() {
  describe('sensorCapiSampleTest', () => {
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
    it(BUNDLE + 'SensorCapiTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_001 begin');
      // 启动应用
      try {
        let want: Want = {
          bundleName: "com.example.sensorcapisamples",
          abilityName: "EntryAbility"
        };

        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        abilityDelegator.startAbility(want, (err) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_001,err.code:' + err.code);
          expect(0).assertEqual(err.code);
        });
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_001,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_001 end');
      done();
    });

    /**
     * 测试获取设备上所有传感器的信息接口
     */
    it(BUNDLE + 'SensorCapiTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_002 begin');
      try {
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('getSensorInfosId'));
        let statusChangeButton = await driver.findComponent(ON.id('getSensorInfosId'));
        await statusChangeButton.click();
        await driver.delayMs(1500);
        const statusDisplay = await driver.findComponent(ON.id('sensorCapiResult'));
        await driver.delayMs(1000);
        const statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('getSensorInfos:success');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_002,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_002 end');
      done();
    });

    /**
     * 测试订阅和取消订阅传感器数据接口
     */
    it(BUNDLE + 'SensorCapiTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_003 begin');
      try {
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('subscriberId'));
        let statusChangeButton = await driver.findComponent(ON.id('subscriberId'));
        await statusChangeButton.click();
        await driver.delayMs(1500);
        const statusDisplay = await driver.findComponent(ON.id('sensorCapiResult'));
        await driver.delayMs(1000);
        const statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('subscriber:success');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_003,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'SensorCapiTest_003 end');
      done();
    });
  });

}