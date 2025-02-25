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

const TAG = '[Sample_SelectingUserFiles]';
const DOMAIN = 0xF811;
const BUNDLE = 'SelectingUserFiles_';
const DELAY_TIME_1S = 1000;
const DELAY_TIME_2S = 2000;
const DELAY_TIME_3S = 3000;

const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('SelectingUserFilesTest', () => {
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
     * @tc.number CoreFileKit_SelectDocumentFileTest_001
     * @tc.name CoreFileKit_SelectDocumentFileTest_001
     * @tc.desc 测试选择文档类文件功能
     */
    it(BUNDLE + 'SelectDocumentFileTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectDocumentFileTest_001, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const selectingDocumentButton = await driver.findComponent(ON.text('SelectDocumentFile'));
      // 点击按钮
      await selectingDocumentButton.click();
      // 等待 2000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_2S);

      let downloadClick: Driver = Driver.create();
      // 点击屏幕坐标 (124, 428) 处
      await downloadClick.click(124, 328);
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      let selectClick: Driver = Driver.create();
      // 点击屏幕坐标 (176, 320) 处
      await selectClick.click(176, 320);
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Read Success'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectDocumentFileTest_001, end');
      done();
    })
    /**
     * @tc.number CoreFileKit_SelectAudioFileTest_002
     * @tc.name CoreFileKit_SelectAudioFileTest_002
     * @tc.desc 测试选择音频类文件功能
     */
    it(BUNDLE + 'SelectAudioFileTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectDocumentFileTest_002, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const selectingAudioButton = await driver.findComponent(ON.text('SelectAudioFile'));
      // 点击按钮
      await selectingAudioButton.click();
      // 等待 3000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_3S);

      let selectClick: Driver = Driver.create();
      // 点击屏幕坐标 (364, 764) 处
      await selectClick.click(364, 764);
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      let backDriver: Driver = Driver.create();
      await backDriver.pressBack(); // 模拟返回键操作
      // 等待 3000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_3S);

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Select Success'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectDocumentFileTest_002, end');
      done();
    })
  })
}