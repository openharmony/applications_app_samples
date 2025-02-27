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
import { abilityDelegatorRegistry, Driver, ON, Component } from '@kit.TestKit';
import { describe, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_SavingUserFiles]';
const DOMAIN = 0xF811;
const BUNDLE = 'SavingUserFiles_';
const DELAY_TIME_1S = 1000;
const DELAY_TIME_2S = 2000;
const DELAY_TIME_3S = 3000;
const DELAY_TIME_4S = 4000;

const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('SaveUserFilesTest', () => {
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

      const ability: UIAbility = await DELEGATOR.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,end');
    })
    /**
     * @tc.number CoreFileKit_SavingDocumentFile_001
     * @tc.name CoreFileKit_SavingDocumentFile_001
     * @tc.desc 测试在设备保存文档类文件并读取文件功能
     */
    it(BUNDLE + 'SavingDocumentFile_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SavingDocumentFile_001, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const selectingDocumentButton = await driver.findComponent(ON.text('SaveDocument'));
      // 点击按钮
      await selectingDocumentButton.click();
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_3S);

      let pathClick: Driver = Driver.create();
      // 点击按钮
      await pathClick.click(200, 470);
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      let saveClick: Driver = Driver.create();
      // 点击按钮
      await saveClick.click(660, 100);
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_2S);

      // 查找按钮组件
      const selectingSaveDocumentButton = await driver.findComponent(ON.text('ReadFiles'));
      // 点击按钮
      await selectingSaveDocumentButton.click();
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_2S);

      let downloadclick: Driver = Driver.create();
      // 点击按钮
      await downloadclick.click(400, 300);
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      let selectclick: Driver = Driver.create();
      // 点击按钮
      await selectclick.click(400, 300);
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Successfully read the file'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'SavingDocumentFile_001, end');
      done();
    })
    /**
     * @tc.number 测试在设备保存音频类文件功能_SavingAudioFile_002
     * @tc.name 测试在设备保存音频类文件功能_SavingAudioFile_002
     * @tc.desc 测试在设备保存音频类文件功能
     */
    it(BUNDLE + 'SavingAudioFile_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SavingAudioFile_002, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const confirmButton = await driver.findComponent(ON.text('SaveAudioFiles'));
      // 点击按钮
      await confirmButton.click();
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_4S);

      let saveClick: Driver = Driver.create();
      // 点击按钮
      await saveClick.click(680, 80);
      // 等待，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_2S);

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('Successfully saved audio files'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'SavingAudioFile_002, end');
      done();
    })
  })
}