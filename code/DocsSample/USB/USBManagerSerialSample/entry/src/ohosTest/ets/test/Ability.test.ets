/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import deviceInfo from '@ohos.deviceInfo';

const TAG = '[Sample_USBManagerSerialSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'USBManagerSerialSample';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.samples.usbmanagerserialsample',
        abilityName: 'EntryAbility'
      });
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
    it('USBManagerSerialSample_GetPortList_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetPortList_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('获取设备列表'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetPortList_001, end`);
    })
    it('USBManagerSerialSample_RequestSerialRight_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `RequestSerialRight_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('获取设备操作权限'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      try {
        let btnAllow = await driver.findComponent(ON.text('允许'))
        if (btnAllow !== undefined) {
          await btnAllow.click();
          await driver.delayMs(3000);
        }
      } catch (e) {
        hilog.info(DOMAIN, TAG, BUNDLE + `already request right`);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `RequestSerialRight_001, end`);
    })
    it('USBManagerSerialSample_OpenSerialDevice_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `OpenSerialDevice_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('打开串口设备'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `OpenSerialDevice_001, end`);
    })
    it('USBManagerSerialSample_SerialRead_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SerialRead_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('读取数据'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SerialRead_001, end`);
    })
    it('USBManagerSerialSample_SerialWrite_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SerialWrite_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('写入数据'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SerialWrite_001, end`);
    })
    it('USBManagerSerialSample_GetSerialConfig_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetSerialConfig_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('获取串口配置'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetSerialConfig_001, end`);
    })
    it('USBManagerSerialSample_SetSerialConfig_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SetSerialConfig_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('修改串口配置'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SetSerialConfig_001, end`);
    })
    it('USBManagerSerialSample_CloseSerialDevice_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CloseSerialDevice_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('关闭串口设备'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CloseSerialDevice_001, end`);
    })
  })
}