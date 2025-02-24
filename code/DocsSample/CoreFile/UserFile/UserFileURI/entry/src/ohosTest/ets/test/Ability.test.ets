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

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { describe, expect, it } from '@ohos/hypium';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_UserFileUri]';
const DOMAIN = 0xF811;
const BUNDLE = 'UserFileUri_';
const DELAY_TIME_1S = 1000;
const DELAY_TIME_2S = 2000;

const DELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;


export default function abilityTest() {
  describe('UserFileUriTest', () => {
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
     * @tc.number CoreFileKit_UserDocumentFileURI_001
     * @tc.name CoreFileKit_UserDocumentFileURI_001
     * @tc.desc 测试在设备生成文件并读取uri功能
     */
    it(BUNDLE + 'UserDocumentFileURI_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UserDocumentFileURI_001, begin');

      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      let applyPermission: Driver = Driver.create();
      await applyPermission.click(500, 700); // 点击屏幕坐标 (500, 700) 处
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      // 查找按钮组件
      const readButton = await driver.findComponent(ON.text('ReadDocumentUri'));
      await readButton.click();
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('ReadDocumentUriSuccess'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'UserDocumentFileURI_001, end')
      done();
    })
    /**
     * @tc.number CoreFileKit_UserMediaFileURI_002
     * @tc.name CoreFileKit_UserMediaFileURI_002
     * @tc.desc 测试在设备选择图片并读取图片uri功能
     */
    it(BUNDLE + 'UserMediaFileURI_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UserMediaFileURI_002, begin');

      const driver = Driver.create();
      // 查找按钮组件
      const button = await driver.findComponent(ON.text('ReadMediaUri'));
      await button.click();
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      let selectMedia: Driver = Driver.create();
      await selectMedia.click(200, 300); // 点击屏幕坐标 (200, 300) 处
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      await selectMedia.click(360, 1100); // 点击屏幕坐标 (360, 1100) 处
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      await selectMedia.click(680, 80); // 点击屏幕坐标 (680, 80) 处
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('ReadMediaUriSuccess'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'UserMediaFileURI_002, end')
      done();
    })
    /**
     * @tc.number CoreFileKit_CopyingFileByURI_003
     * @tc.name CoreFileKit_CopyingFileByURI_003
     * @tc.desc 测试通过uri复制文件功能
     */
    it(BUNDLE + 'CopyingFileByURI_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CopyingFileByURI_003, begin');

      const driver = Driver.create();
      // 查找按钮组件
      const copyButton = await driver.findComponent(ON.text('CopyAFile'));
      await copyButton.click();
      await driver.delayMs(DELAY_TIME_2S); // 延迟2秒，等待操作完成

      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('CopyAFileSuccess'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'CopyingFileByURI_003, end')
      done();
    })
  })
}