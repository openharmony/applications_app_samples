/* Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern, UiDriver, BY} from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'DeviceManager_';
const TAG = '[Sample_DeviceManager]';
const DOMAIN = 0xF811;

export default function IndexTest() {
  describe('IndexTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertEqual', 0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    });
    hilog.info(DOMAIN, TAG, BUNDLE + 'appTest start');
    /**
     * 启动Ability
     */
    it(BUNDLE + 'startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startAbility start');
      let want = {
        bundleName: 'com.samples.devicemanager',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        expect(null).assertEqual(err);
        done();
      });
    });
    /**
     * 进入首页
     */
    it(BUNDLE + 'IndexPage_Enter', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPage_Enter start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('分布式设备发现与连接', MatchPattern.CONTAINS));
      let titleComponent = await driver.findComponent(ON.text('分布式设备发现与连接', MatchPattern.CONTAINS));
      let titleContent = await titleComponent.getText();
      await driver.delayMs(200);
      expect('分布式设备发现与连接').assertEqual(titleContent);
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPage_Enter end');
    });
    /**
     * 获取本机设备信息
     */
    it(BUNDLE + 'Get_Local_Device_Info', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Get_Local_Device_Info start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('OpenHarmony', MatchPattern.CONTAINS));
      let localDeviceComponent = await driver.findComponent(ON.text('OpenHarmony', MatchPattern.CONTAINS));
      let deviceName = await localDeviceComponent.getText();
      await driver.delayMs(200);
      expect(deviceName).assertContain('OpenHarmony');
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Get_Local_Device_Info end');
    });
    /**
     * 支持距离上报和允许被发现
     */
    it(BUNDLE + 'NotAllow_Discovered', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllow_Discovered start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('Toggle'));
      let toggleList:Array<Component> = await driver.findComponents(ON.type('Toggle'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllow_Discovered end toggleList.length = ' + toggleList.length);
      await driver.delayMs(500);
      await toggleList[0].click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllow_Discovered end');
    });
    /**
     * 导入凭据
     */
    it(BUNDLE + 'Import_Credential', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Import_Credential start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('登录', MatchPattern.CONTAINS));
      let importCredential = await driver.findComponent(ON.text('登录', MatchPattern.CONTAINS));
      await importCredential.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.text('确定', MatchPattern.CONTAINS));
      let confirm = await driver.findComponent(ON.text('确定', MatchPattern.CONTAINS));
      await confirm.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Import_Credential end');
    });
    /**
     * 获取可信设备列表
     */
    it(BUNDLE + 'Get_TrustedDeviceList', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Get_TrustedDeviceList start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('刷新', MatchPattern.CONTAINS));
      let refresh = await driver.findComponent(ON.text('刷新', MatchPattern.CONTAINS));
      await refresh.click();
      await driver.delayMs(200);
      let credible = await driver.findComponent((ON.text('已认证', MatchPattern.CONTAINS)));
      await driver.delayMs(200);
      let trustedDeviceName = await credible.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Get_TrustedDeviceList trustedDeviceName = ' + trustedDeviceName);
      expect(trustedDeviceName).assertContain('已认证');
      hilog.info(DOMAIN, TAG, BUNDLE + 'Get_TrustedDeviceList end');
    });
    /**
     * 发现可用设备
     */
    it(BUNDLE + 'Discovery_Devices', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Discovery_Devices start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('发现', MatchPattern.CONTAINS));
      let discover = await driver.findComponents(ON.text('发现', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await discover[2].click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Discovery_Devices end');
    });
    /**
     * 删除凭据
     */
    it(BUNDLE + 'Delete_Credential', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Delete_Credential start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('注销', MatchPattern.CONTAINS));
      let deleteCredential = await driver.findComponent(ON.text('注销', MatchPattern.CONTAINS));
      await deleteCredential.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.text('确定', MatchPattern.CONTAINS));
      let confirm = await driver.findComponent(ON.text('确定', MatchPattern.CONTAINS));
      await confirm.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Delete_Credential end');
    });
    /**
     * 进入过滤条件页面
     */
    it(BUNDLE + 'Filter_Options', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Filter_Options start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('过滤条件', MatchPattern.CONTAINS));
      let filterOption = await driver.findComponent(ON.text('过滤条件', MatchPattern.CONTAINS));
      await filterOption.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Filter_Options end');
    });
    /**
     * 停止发现可用设备
     */
    it(BUNDLE + 'Stop_Discovery_Devices', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Stop_Discovery_Devices start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('停止', MatchPattern.CONTAINS));
      let stop = await driver.findComponent(ON.text('停止', MatchPattern.CONTAINS));
      await stop.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Stop_Discovery_Devices end');
    });
  });
}