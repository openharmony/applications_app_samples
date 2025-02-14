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

import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_DevelopingFileManagerApplication]';
const DOMAIN = 0xF811;
const BUNDLE = 'DevelopingFileManagerApplication_';
const DELAY_TIME_1S = 1000;
const DELAY_TIME_3S = 3000;
const DELAY_TIME_7S = 7000;

const DELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('DevelopingFileManagerApplicationTest', () => {
    /**
     * @tc.number CoreFileKit_StartAbility_001
     * @tc.name CoreFileKit_StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,begin');
      // start tested ability
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility'
      };
      await DELEGATOR.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME_1S);
      // check top display ability
      const ability: UIAbility = await DELEGATOR.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,end');
    })
    /**
     * @tc.number CoreFileKit_DevelopingFileManagerApplication_001
     * @tc.name CoreFileKit_DevelopingFileManagerApplication_001
     * @tc.desc 测试在设备生成文件并读取文件uri功能
     */
    it(BUNDLE + 'DevelopingFileManagerApplication_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DevelopingFileManagerApplication_001, begin');

      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const switchPage1 = await driver.findComponent(ON.text('DevelopingFileManagerApplication'));
      await switchPage1.click();
      await driver.delayMs(DELAY_TIME_3S); // 延迟3秒，等待操作完成

      // 查找按钮组件
      const createFileButton = await driver.findComponent(ON.text('CreateFile'));
      await createFileButton.click();
      await driver.delayMs(DELAY_TIME_1S); // 延迟1秒，等待操作完成

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('CreateDocumentUriSuccess'));

      // 标记测试用例完成
      let backButton: Driver = Driver.create();
      await backButton.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DevelopingFileManagerApplication_001, end')
      done();
    })
    /**
     * @tc.number CoreFileKit_ListeningForDeviceOnline/OfflineStatus_002
     * @tc.name CoreFileKit_ListeningForDeviceOnline/OfflineStatus_002
     * @tc.desc 测试监听设备上下线功能
     */
    it(BUNDLE + 'ListeningForDeviceOnline/OfflineStatus_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListeningForDeviceOnline/OfflineStatus_002, begin');

      const driver = Driver.create();
      // 查找按钮组件
      const button = await driver.findComponent(ON.text('ListeningForDeviceOnline/OfflineStatus'));
      await button.click();
      await driver.delayMs(DELAY_TIME_3S); // 延迟3秒，等待操作完成

      // 查找按钮组件
      const registerButton = await driver.findComponent(ON.text('RegisterToMonitorTheDevice'));
      await registerButton.click();
      await driver.delayMs(DELAY_TIME_7S); // 延迟7秒，等待操作完成

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Monitoring succeeded'));

      // 查找按钮组件
      const cancelButton = await driver.findComponent(ON.text('CancelMonitoringTheDevice'));
      await cancelButton.click();
      await driver.delayMs(DELAY_TIME_1S); // 延迟1秒，等待操作完成

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListeningForDeviceOnline/OfflineStatus_002, end')
      done();
    })
  })
}