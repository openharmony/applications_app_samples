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

const TAG = 'Sample_Sensor';
const DOMAIN = 0xF811;
const BUNDLE = 'SensorSample'

export default function SensorSampleTest() {
  describe('SensorSampleTest', () => {
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
    it(BUNDLE + 'DeviceNormalOperation_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001 begin');
      // 启动应用
      try {
        let want: Want = {
          bundleName: "com.samples.sensor",
          abilityName: "EntryAbility"
        };

        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        abilityDelegator.startAbility(want, (err) => {
          hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001,err.code:' + err.code);
          expect(0).assertEqual(err.code);
        });
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceNormalOperation_001 end');
      done();
    });


    /**
     * 测试订阅传感器
     */
    it(BUNDLE + 'SubscribeSensor_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeSensor_002 begin');
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(1500);
        await driver.assertComponentExist(ON.id('sensor_type_selector'))
        let button: Component = await driver.findComponent(ON.id('sensor_type_selector'));
        await button.click();
        await driver.delayMs(1500);
        await driver.assertComponentExist(ON.text('确定'))
        let selectorButton: Component = await driver.findComponent(ON.text('确定'));
        await selectorButton.click();
        await driver.delayMs(1000);
        // 点击订阅按钮
        await driver.assertComponentExist(ON.id('subscribeId'))
        let accelerometerButton: Component = await driver.findComponent(ON.id('subscribeId'));
        await accelerometerButton.click();
        await driver.delayMs(1000);
        // 验证数据上报正常
        let dataDisplay = await driver.findComponent(ON.id('callbackText'));
        let dataText = await dataDisplay.getText();
        await driver.delayMs(1000);
        expect(dataText.length > 0).assertTrue();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'SubscribeSensor_002,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeSensor_002 end');
      done();
    });

    /**
     * 测试取消订阅传感器
     */
    it(BUNDLE + 'UnsubscribeSensor_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnsubscribeSensor_003 begin');
      try {
        let driver: Driver = Driver.create();
        //点击取消订阅
        await driver.assertComponentExist(ON.id('unSubscribeId'));
        let unSubscribeButton: Component = await driver.findComponent(ON.id('unSubscribeId'));
        await unSubscribeButton.click();
        await driver.delayMs(1500);
        let callbackTextDisplay = await driver.findComponent(ON.id('callbackText'));
        await driver.delayMs(1000);
        await callbackTextDisplay.getText();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'UnsubscribeSensor_003,err.message:' + (error as Error).message);
        expect(error.message.includes('null')).assertTrue();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnsubscribeSensor_003 end');
      done();
    });

    /**
     * 获取设备传感器信息列表
     */
    it(BUNDLE + 'GetSensorList_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSensorList_004 begin')
      try {
        let driver: Driver = Driver.create()
        // 点击获取传感器列表按钮
        await driver.assertComponentExist(ON.id('getSensorListByDeviceId'))
        let deviceListButton = await driver.findComponent(ON.id('getSensorListByDeviceId'));
        await deviceListButton.click();
        await driver.delayMs(1000);

        // 验证列表信息获取正常
        await driver.assertComponentExist(ON.id('deviceText'));
        let deviceText = await driver.findComponent(ON.id('deviceText'));
        await driver.delayMs(1000);
        let childCount = await deviceText.getText();
        expect(childCount.length > 0).assertTrue();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'GetSensorList_004,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSensorList_004 end');
      done();
    });

    /**
     * 获取指定设备指定类型传感器信息
     */
    it(BUNDLE + 'GetSingleSensor_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSingleSensor_005 begin');
      try {
        // 点击获取指定传感器按钮
        let driver: Driver = Driver.create();
        await driver.assertComponentExist(ON.id('getSingleDeviceId'));
        let deviceListButton = await driver.findComponent(ON.id('getSingleDeviceId'));
        await deviceListButton.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('sensor_test_0'));
        let singleDeviceText = await driver.findComponent(ON.text('sensor_test_0'));
        await singleDeviceText.click();
        await driver.delayMs(1000);
        // 验证信息获取正常
        let sensorInfo = await driver.findComponent(ON.id('deviceText'));
        let infoText = await sensorInfo.getText();
        expect(infoText.includes('sensor_test')).assertTrue();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'GetSingleSensor_005,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSingleSensor_005 end');
      done();
    });

    /**
     * 清除sensor信息列表
     */
    it(BUNDLE + 'CleanSensorList_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CleanSensorList_006 begin');
      try {
        // 点击清除按钮
        let driver: Driver = Driver.create()
        let cleanButton = await driver.findComponent(ON.id('cleanId'))
        await cleanButton.click();
        await driver.delayMs(1000);

        // 验证列表恢复默认
        let sensorInfo = await driver.findComponent(ON.id('deviceText'));
        await sensorInfo.getText();
        expect(true).assertFail();
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'CleanSensorList_006,err.message:' + (error as Error).message);
        expect(error.message.includes('null')).assertTrue();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'CleanSensorList_006 end');
      done();
    });

    /**
     * 订阅扩展设备热插拔事件
     */
    it(BUNDLE + 'SubscribeHotPlug_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeHotPlug_007 begin');
      try {
        // 点击订阅热插拔事件按钮
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('onSensorStatusId'));
        let statusChangeButton = await driver.findComponent(ON.id('onSensorStatusId'));
        await statusChangeButton.click();
        await driver.delayMs(1500);
        // 验证订阅状态
        const statusDisplay = await driver.findComponent(ON.id('callbackText'));
        await driver.delayMs(1000);
        const statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('on:sensorStatusChange');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'SubscribeHotPlug_007,err.message:' + (error as Error).message);
        expect(true).assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeHotPlug_007 end');
      done();
    });

    /**
     * 取消订阅扩展设备热插拔事件
     */
    it(BUNDLE + 'UnsubscribeHotPlug_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnsubscribeHotPlug_008 begin');
      try {
        // 点击取消订阅热插拔事件按钮
        let driver: Driver = Driver.create()
        await driver.assertComponentExist(ON.id('offSensorStatusId'));
        let statusChangeButton = await driver.findComponent(ON.id('offSensorStatusId'));
        await statusChangeButton.click();
        await driver.delayMs(1000);
        // 验证取消订阅状态
        let statusDisplay = await driver.findComponent(ON.id('callbackText'));
        let statusText = await statusDisplay.getText();
        expect(statusText).assertEqual('off:sensorStatusChange');
      } catch (error) {
        hilog.error(DOMAIN, TAG, BUNDLE + 'UnsubscribeHotPlug_008,err.message:' + (error as Error).message);
        expect(error.message.includes('null')).assertTrue();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnsubscribeHotPlug_008 end');
      done();
    });
  });

}