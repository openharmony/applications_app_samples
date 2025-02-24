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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const DELAY_TIME = 1500; // 延时1.5秒
const TAG = '[Sample_ApplicationFile]';
const DOMAIN = 0xF811;
const BUNDLE = 'FileSample_';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function IndexTest() {
  describe('IndexTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * @tc.number fileAccessTest_001
     * @tc.name fileAccessTest_001
     * @tc.desc 文件的创建和读写
     */
    it(BUNDLE + 'fileAccessTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_001 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.createWriteReadfile'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_001 end');
    })
    /**
     * @tc.number fileAccessTest_002
     * @tc.name fileAccessTest_002
     * @tc.desc 文件内容复制test.txt => destFile.txt
     */
    it(BUNDLE + 'fileAccessTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_002 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.copyDocument'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_002 end');
    })
    /**
     * @tc.number fileAccessTest_003
     * @tc.name fileAccessTest_003
     * @tc.desc 读取文件内容
     */
    it(BUNDLE + 'fileAccessTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_003 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.ReadFile'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_003 end');
    })
    /**
     * @tc.number fileAccessTest_004
     * @tc.name fileAccessTest_004
     * @tc.desc 获取文件列表
     */
    it(BUNDLE + 'fileAccessTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_004 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.GetFileList'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_004 end');
    })
    /**
     * @tc.number fileAccessTest_005
     * @tc.name fileAccessTest_005
     * @tc.desc 获取文件系统数据分区剩余空间大小
     */
    it(BUNDLE + 'fileAccessTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_005 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.getFileSystemSize'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_005 end');
    })
    /**
     * @tc.number fileAccessTest_006
     * @tc.name fileAccessTest_006
     * @tc.desc 获取当前应用的存储空间大小
     */
    it(BUNDLE + 'fileAccessTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_006 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.appStorageSpaceSize'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_006 end');
    })
    /**
     * @tc.number fileAccessTest_007
     * @tc.name fileAccessTest_007
     * @tc.desc 文件哈希流计算
     */
    it(BUNDLE + 'fileAccessTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_007 begin');
      let driver: Driver = Driver.create();
      let str = await getResourceString($r('app.string.hash'));
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'fileAccessTest_007 end');
    })
  })
}