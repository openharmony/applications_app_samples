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

// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { describe, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_ManagingExternalStorageDevices]';
const DOMAIN = 0xF811;
const BUNDLE = 'ManagingExternalStorageDevices_';
const DELAY_TIME_1S = 1000;
const DELAY_TIME_7S = 7000;

const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('ManagingExternalStorageDevicesTest', () => {
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
     * @tc.number CoreFileKit_FunctionalTest_001
     * @tc.name CoreFileKit_FunctionalTest_001
     * @tc.desc 测试感知外置存储设备插入功能
     */
    it(BUNDLE + 'FunctionalTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FunctionalTest_001, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();

      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const subscribeBroadcastButton = await driver.findComponent(ON.text('SubscribeBroadcastEvents'));
      // 点击按钮
      await subscribeBroadcastButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const receiveBroadcastButton = await driver.findComponent(ON.text('ReceiveBroadcastNotifications'));
      // 点击按钮
      await receiveBroadcastButton.click();
      // 等待 7000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_7S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Successfully obtained volume device information'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'FunctionalTest_001, end');
      done();
    })
  })
}