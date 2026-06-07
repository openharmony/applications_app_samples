/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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

const TAG = '[Sample_SerialManagerSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'SerialManagerSample';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.serialmanagersample',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('SerialManagerSample_GetSerialPortList_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetSerialPortList_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('getSerialPortList'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetSerialPortList_001, end`);
    })
    it('SerialManagerSample_PortInfo_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `PortInfo_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('portInfo'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `PortInfo_001, end`);
    })
    it('SerialManagerSample_Open_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Open_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('open'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `Open_001, end`);
    })
    it('SerialManagerSample_Write_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Write_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('write'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `Write_001, end`);
    })
    it('SerialManagerSample_OnDataRead_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `OnDataRead_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('onDataRead'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `OnDataRead_001, end`);
    })
    it('SerialManagerSample_OffDataRead_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `OffDataRead_001, begin`);
      let btnAccept = await driver.findComponent(ON.text('offDataRead'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `OffDataRead_001, end`);
    })
    it('SerialManagerSample_Flush_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Flush_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('flush'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `Flush_001, end`);
    })
    it('SerialManagerSample_Drain_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Drain_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('drain'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `Drain_001, end`);
    })
    it('SerialManagerSample_SetRts_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SetRts_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('setRts'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SetRts_001, end`);
    })
    it('SerialManagerSample_GetCts_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetCts_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('getCts'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetCts_001, end`);
    })
    it('SerialManagerSample_SetDtr_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SetDtr_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('setDtr'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SetDtr_001, end`);
    })
    it('SerialManagerSample_GetDsr_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetDsr_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('getDsr'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetDsr_001, end`);
    })
    it('SerialManagerSample_SendBrk_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SendBrk_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('sendBrk'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SendBrk_001, end`);
    })
    it('SerialManagerSample_Close_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Close_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('close'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `Close_001, end`);
    })
    it('SerialManagerSample_OnDisconnect_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `OnDisconnect_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('onDisconnect'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `OnDisconnect_001, end`);
    })
    it('SerialManagerSample_OffDisconnect_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + `OffDisconnect_001, begin`);
      await driver.swipe(400, 1200, 400, 400, 500);
      let btnAccept = await driver.findComponent(ON.text('offDisconnect'))
      if (btnAccept !== null && btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(500);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `OffDisconnect_001, end`);
    })
  })
}
