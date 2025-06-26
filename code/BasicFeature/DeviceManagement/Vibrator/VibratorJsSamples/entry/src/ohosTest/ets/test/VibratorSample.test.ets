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
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

const TAG = 'Sample_Vibrator';
const DOMAIN = 0xF811;
const BUNDLE = 'VibratorSample'

export default function vibratorSample() {
  describe('vibratorSample', () => {
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
     * 启动应用
     */
    it(BUNDLE + 'DeviceNormalOperation_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001 begin');
      try {
        let want: Want = {
          bundleName: "com.samples.vibrator",
          abilityName: "EntryAbility"
        };
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await new Promise<void>((resolve, reject) => {
          abilityDelegator.startAbility(want, (err: Error) => {
            if (err) {
              const errorMsg = `Failed to start application: ${err.message}`;
              hilog.error(DOMAIN, TAG, errorMsg);
              reject(new Error(errorMsg));
            } else {
              hilog.info(DOMAIN, TAG, 'Application started successfully');
              resolve();
            }
          });
        });
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001 test complete');
        done();
      }
    });

    /**
     *file类型震动
     */
    it(BUNDLE + 'FileTypeVibration_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileTypeVibration_002 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('file'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击file按钮
        let button = await driver.findComponent(ON.text('file'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'FileTypeVibration_002 test complete');
        done();
      }
    });


    /**
     *preset类型震动
     */
    it(BUNDLE + 'PresetTypeVibration_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PresetTypeVibration_003 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(3000);
        await driver.assertComponentExist(ON.id('Please select effectId'));
        await driver.assertComponentExist(ON.id('preset'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        let button = await driver.findComponent(ON.id('preset'));
        let textInput = await driver.findComponent(ON.id('Please select effectId'));
        //点击获取effectId列表,选择一个类型
        await textInput.click();
        hilog.info(DOMAIN, TAG, 'Click TextInput and wait for the option list to load');
        let option = await driver.findComponent(ON.text('haptic.notice.success'))
        await option.click();
        let confirmButton = await driver.findComponent(ON.text('确定'));
        await confirmButton.click();
        await driver.delayMs(1000);
        let text = await textInput.getText();
        //点击preset按钮
        await button.click();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'text:' + text);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'PresetTypeVibration_003 test complete');
        done();
      }
    });


    /**
     * time类型震动
     */
    it(BUNDLE + 'TimeTypeVibration_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimeTypeVibration_004 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('time'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击time按钮
        let button = await driver.findComponent(ON.text('time'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'TimeTypeVibration_004 test complete');
        done();
      }
    });


    /**
     *  短事件类型震动
     */
    it(BUNDLE + 'ShortEventTypeVibration_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShortEventTypeVibration_005 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('pattern:addTransientEvent'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击短事件按钮
        let button = await driver.findComponent(ON.text('pattern:addTransientEvent'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'ShortEventTypeVibration_005 test complete');
        done();
      }
    });


    /**
     *  长事件类型震动
     */
    it(BUNDLE + 'LongEventTypeVibration_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LongEventTypeVibration_006 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('pattern:addContinuousEvent'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击长事件按钮
        let button = await driver.findComponent(ON.text('pattern:addContinuousEvent'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'LongEventTypeVibration_006 test complete');
        done();
      }
    });


    /**
     *  停止震动
     */
    it(BUNDLE + 'StopVibration_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopVibration_007 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('stopVibration'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击按钮停止震动
        let button = await driver.findComponent(ON.text('stopVibration'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StopVibration_007 test complete');
        done();
      }
    });


    /**
     *  订阅扩展设备热插拔事件
     */
    it(BUNDLE + 'SubscribeToExtendedEvents_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeToExtendedEvents_008 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('on'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击on订阅
        let button = await driver.findComponent(ON.text('on'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeToExtendedEvents_008 test complete');
        done();
      }
    });


    /**
     *  去订阅扩展设备热插拔事件
     */
    it(BUNDLE + 'UnSubscribeToExtendedEvents_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnSubscribeToExtendedEvents_009 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('off'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击off去订阅
        let button = await driver.findComponent(ON.text('off'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'UnSubscribeToExtendedEvents_009 test complete');
        done();
      }
    });


    /**
     *  获取本设备及扩展设备马达信息列表
     */
    it(BUNDLE + 'GetMotorInformationList_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetMotorInformationList_010 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.text('getVibratorInfoSync'));
        hilog.info(DOMAIN, TAG, 'Button exists');
        //点击按钮获取马达信息列表
        let button = await driver.findComponent(ON.text('getVibratorInfoSync'));
        await button.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, BUNDLE + 'GetMotorInformationList_010 test complete');
        done()
      }
    });
  })
}