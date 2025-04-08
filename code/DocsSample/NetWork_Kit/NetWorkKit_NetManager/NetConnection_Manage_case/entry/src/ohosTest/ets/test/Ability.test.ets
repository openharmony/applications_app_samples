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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const DOMAIN = 0xF811;
const TAG = 'NetConnection_Manage';
const BUNDLE = 'NetConnectionManage_'
const BUNDLENAME = 'com.samples.NetConnection_Manage';
const INITIAL_DELAY = 2000; // 初始延迟
const FIRST_CLICK_DELAY = 1000; // 第一次点击延迟
const SECOND_CLICK_DELAY = 2000; // 第二次点击延迟
const DELAY_TIME = 500; // 延迟时间

let driver: Driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc Start the Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility',
      };
      await delegator.startAbility(want);
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    });

    /**
     * @tc.number NetConnection_Connect_001
     * @tc.name NetConnection_Connect_001
     * @tc.desc Test the connect network button
     */
    it(BUNDLE + 'NetConnection_Connect_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Connect_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('Connect_Network'));
      let stack = await driver.findComponent(ON.id('Connect_Network'));
      await stack.click();
      await driver.delayMs(FIRST_CLICK_DELAY);
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      let resultText = await driver.findComponent(ON.id('connectStatus'));
      let result = await resultText.getText();
      expect(result).assertContain('Network available');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Connect_001 end');
      done();
    });

    /**
     * @tc.number NetConnection_Disconnect_001
     * @tc.name NetConnection_Disconnect_001
     * @tc.desc Test the disconnect network button
     */
    it(BUNDLE + 'NetConnection_Disconnect_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Disconnect_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('Disconnect_Network'));
      let stack = await driver.findComponent(ON.id('Disconnect_Network'));
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      let resultText = await driver.findComponent(ON.id('disconnectStatus'));
      let result = await resultText.getText();
      expect(result).assertContain('Network disconnected');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Disconnect_001 end');
      done();
    });

    /**
     * @tc.number NetConnection_SocketConnect_001
     * @tc.name NetConnection_SocketConnect_001
     * @tc.desc Test the SocketConnect button
     */
    it(BUNDLE + 'NetConnection_SocketConnect_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_SocketConnect_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('SocketConnect_Network'));
      let stack = await driver.findComponent(ON.id('SocketConnect_Network'));
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_SocketConnect_001 end');
      done();
    });

    /**
     * @tc.number NetConnection_Acquisition_Connected_001
     * @tc.name NetConnection_Acquisition_001
     * @tc.desc Test the button to acquire connected network
     */
    it(BUNDLE + 'NetConnection_Acquisition_Connected_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Acquisition_Connected_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('Get_Connected_Network'));
      let stack = await driver.findComponent(ON.id('Get_Connected_Network'));
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      let resultText = await driver.findComponent(ON.id('allNetworksStatus'));
      let result = await resultText.getText();
      expect(result).assertContain('Retrieved successfully');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Acquisition_Connected_001 end');
      done();
    });

    /**
     * @tc.number NetConnection_Acquisition_Default_001
     * @tc.name NetConnection_Acquisition_Default_001
     * @tc.desc Test the button to acquire default network
     */
    it(BUNDLE + 'NetConnection_Acquisition_Default_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Acquisition_Default_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('Get_Default_Network'));
      let stack = await driver.findComponent(ON.id('Get_Default_Network'));
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      let resultText = await driver.findComponent(ON.id('defaultNetworkStatus'));
      let result = await resultText.getText();
      expect(result).assertContain('Retrieved successfully');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_Acquisition_Default_001 end');
      done();
    });

    /**
     * @tc.number NetConnection_AcquisitionIP_Default_001
     * @tc.name NetConnection_AcquisitionIP_Default_001
     * @tc.desc Test the button to acquire default network IP
     */
    it(BUNDLE + 'NetConnection_AcquisitionIP_Default_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_AcquisitionIP_Default_001 begin');
      let driver = Driver.create();
      await driver.delayMs(INITIAL_DELAY);
      await driver.assertComponentExist(ON.id('Get_Default_Network_IP'));
      let stack = await driver.findComponent(ON.id('Get_Default_Network_IP'));
      await stack.click();
      await driver.delayMs(SECOND_CLICK_DELAY);
      let resultText = await driver.findComponent(ON.id('defaultNetworkIPStatus'));
      let result = await resultText.getText();
      expect(result).assertContain('Retrieved successfully');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'NetConnection_AcquisitionIP_Default_001 end');
      done();
    });

  })
}
