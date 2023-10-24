/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'DeviceManager_';
const TAG = '[Sample_DeviceManager]';
const DOMAIN = 0xF811;

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function IndexTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 启动Ability
     */
    it(BUNDLE + 'startAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startAbility_001 start');
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.devicemanager",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'startAbility_001 end');
    });

    /**
     * 进入首页
     */
    it(BUNDLE + 'IndexPageEnter_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageEnter_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.app_name')), MatchPattern.CONTAINS));
      let titleComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.app_name')), MatchPattern.CONTAINS));
      let titleContent = await titleComponent.getText();
      await driver.delayMs(200);
      expect(await getResourceString($r('app.string.app_name'))).assertEqual(titleContent);
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageEnter_001 end');
    });

    /**
     * 获取本机设备信息
     */
    it(BUNDLE + 'GetLocalDeviceInfo_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetLocalDeviceInfo_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('OpenHarmony', MatchPattern.CONTAINS));
      let localDeviceComponent = await driver.findComponent(ON.text('OpenHarmony', MatchPattern.CONTAINS));
      let deviceName = await localDeviceComponent.getText();
      await driver.delayMs(200);
      expect(deviceName).assertContain('OpenHarmony');
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetLocalDeviceInfo_001 end');
    });

    /**
     * 支持距离上报和允许被发现
     */
    it(BUNDLE + 'NotAllowDiscovered_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllowDiscovered_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('Toggle'));
      let toggleList: Array<Component> = await driver.findComponents(ON.type('Toggle'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllow_Discovered end toggleList.length = ' + toggleList.length);
      await driver.delayMs(500);
      await toggleList[0].click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'NotAllowDiscovered_001 end');
    });

    /**
     * 发现可用设备
     */
    it(BUNDLE + 'DiscoveryDevices_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DiscoveryDevices_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.discover')), MatchPattern.CONTAINS));
      let discover = await driver.findComponents(ON.text(await getResourceString($r('app.string.discover')), MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await discover[2].click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DiscoveryDevices_001 end');
    });

    /**
     * 进入过滤条件页面
     */
    it(BUNDLE + 'FilterOptions_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FilterOptions_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.filter_options')), MatchPattern.CONTAINS));
      let filterOption = await driver.findComponent(ON.text(await getResourceString($r('app.string.filter_options')), MatchPattern.CONTAINS));
      await filterOption.click();
      await driver.delayMs(500);
      // 点击设备类型
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.device_type')), MatchPattern.CONTAINS));
      let type = await driver.findComponent(ON.text(await getResourceString($r('app.string.device_type')), MatchPattern.CONTAINS));
      await type.click();
      let typeRadioList = await driver.findComponents(ON.type('Radio'));
      await typeRadioList[0].click();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      let typeConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      await typeConfirm.click();
      await driver.delayMs(500);
      // 点击是否上线
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.is_online')), MatchPattern.CONTAINS));
      let isLine = await driver.findComponent(ON.text(await getResourceString($r('app.string.is_online')), MatchPattern.CONTAINS));
      await isLine.click();
      let isLineRadioList = await driver.findComponents(ON.type('Radio'));
      await isLineRadioList[1].click();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      let isLineConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      await isLineConfirm.click();
      await driver.delayMs(500);
      // 点击是否可信
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.is_trusted')), MatchPattern.CONTAINS));
      let isTrue = await driver.findComponent(ON.text(await getResourceString($r('app.string.is_trusted')), MatchPattern.CONTAINS));
      await isTrue.click();
      let isTrueRadioList = await driver.findComponents(ON.type('Radio'));
      await isTrueRadioList[2].click();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      let isTrueConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      await isTrueConfirm.click();
      await driver.delayMs(500);
      // 点击认证类型
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.auth_form')), MatchPattern.CONTAINS));
      let authentication = await driver.findComponent(ON.text(await getResourceString($r('app.string.auth_form')), MatchPattern.CONTAINS));
      await authentication.click();
      let authenticationRadioList = await driver.findComponents(ON.type('Radio'));
      await authenticationRadioList[2].click();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      let authenticationConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      await authenticationConfirm.click();
      await driver.delayMs(500);
      // 点击距离
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.range')), MatchPattern.CONTAINS));
      let distance = await driver.findComponent(ON.text(await getResourceString($r('app.string.range')), MatchPattern.CONTAINS));
      await distance.click();
      let distanceRadioList = await driver.findComponents(ON.type('Radio'));
      await distanceRadioList[3].click();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      let distanceConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm')), MatchPattern.CONTAINS));
      await distanceConfirm.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FilterOptions_001 end');
    });

    /**
     * 停止发现可用设备
     */
    it(BUNDLE + 'StopDiscoveryDevices_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopDiscoveryDevices_001 start');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.stop')), MatchPattern.CONTAINS));
      let stop = await driver.findComponent(ON.text(await getResourceString($r('app.string.stop')), MatchPattern.CONTAINS));
      await stop.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopDiscoveryDevices_001 end');
    });
  });
}