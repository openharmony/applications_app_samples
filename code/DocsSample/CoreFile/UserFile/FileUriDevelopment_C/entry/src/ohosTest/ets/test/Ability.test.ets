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

const TAG = '[Sample_FileUriDevelopment_c]';
const DOMAIN = 0xF811;
const BUNDLE = 'FileUriDevelopment_c_';
const DELAY_TIME_1S = 1000;

const DELEGATOR: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('FileUriDevelopment_cTest', () => {
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
     * @tc.number CoreFileKit_InterfaceTest_001
     * @tc.name CoreFileKit_InterfaceTest_001
     * @tc.desc 测试接口OH_FileUri_GetUriFromPath
     */
    it(BUNDLE + 'InterfaceTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_001, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const getUriFromPathButton = await driver.findComponent(ON.text('GetUriFromPath'));
      // 点击按钮
      await getUriFromPathButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(
        ON.text('file://' + BUNDLENAME + '/data/storage/el2/base/haps/entry/files/test.txt')
      );

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_001, end');
      done();
    })
    /**
     * @tc.number CoreFileKit_InterfaceTest_002
     * @tc.name CoreFileKit_InterfaceTest_002
     * @tc.desc 测试接口OH_FileUri_GetPathFromUri
     */
    it(BUNDLE + 'InterfaceTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_002, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const getPathFromUriButton = await driver.findComponent(ON.text('GetPathFromUri'));
      // 点击按钮
      await getPathFromUriButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('/data/storage/el2/base/haps/entry/files/test.txt'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_002, end');
      done();
    })
    /**
     * @tc.number CoreFileKit_InterfaceTest_003
     * @tc.name CoreFileKit_InterfaceTest_003
     * @tc.desc 测试接口OH_FileUri_GetFullDirectoryUri
     */
    it(BUNDLE + 'InterfaceTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_003, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const getFullDirectoryUriButton = await driver.findComponent(ON.text('GetFullDirectoryUri'));
      // 点击按钮
      await getFullDirectoryUriButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('file://' + BUNDLENAME + '/data/storage/el2/base/haps/entry/files'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_003, end');
      done();
    })
    /**
     * @tc.number CoreFileKit_InterfaceTest_004
     * @tc.name CoreFileKit_InterfaceTest_004
     * @tc.desc 测试接口OH_FileUri_IsValidUri
     */
    it(BUNDLE + 'InterfaceTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_004, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const isValidUriButton = await driver.findComponent(ON.text('IsValidUri'));
      // 点击按钮
      await isValidUriButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('UriIsTrue'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_004, end');
      done();
    })
    /**
     * @tc.number CoreFileKit_InterfaceTest_005
     * @tc.name CoreFileKit_InterfaceTest_005
     * @tc.desc 测试接口OH_FileUri_GetFileName
     */
    it(BUNDLE + 'InterfaceTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_005, begin');
      // 初始化 Driver，用于 UI 操作
      const driver = Driver.create();
      // 等待 1000 毫秒，确保 UI 渲染完成
      await driver.delayMs(DELAY_TIME_1S);

      // 查找按钮组件
      const getFileNameButton = await driver.findComponent(ON.text('GetFileName'));
      // 点击按钮
      await getFileNameButton.click();
      // 等待 1000 毫秒，确保点击后的操作完成
      await driver.delayMs(DELAY_TIME_1S);
      // 检查文本组件是否改变
      await driver.assertComponentExist(ON.text('test.txt'));

      // 标记测试用例完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'InterfaceTest_005, end');
      done();
    })
  })
}