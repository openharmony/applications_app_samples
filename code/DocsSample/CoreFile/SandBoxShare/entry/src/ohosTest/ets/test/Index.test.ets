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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DELAY_TIME = 1200; // 延时1.2秒
const TAG = '[Sample_SandBoxShare]';
const DOMAIN = 0xF811;
const BUNDLE = 'SandBoxShare_';

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
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin"');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * @tc.number SandBoxShare_001
     * @tc.name SandBoxShare_001
     * @tc.desc 文件的创建
     */
    it(BUNDLE + 'SandBoxShare_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_001 begin');
      let str = await getResourceString($r('app.string.CreateFileTest'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_001 end');
    })
    /**
     * @tc.number SandBoxShare_002
     * @tc.name SandBoxShare_002
     * @tc.desc 获取文件列表
     */
    it(BUNDLE + 'SandBoxShare_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_002 begin');
      let str = await getResourceString($r('app.string.getFileList'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_002 end');
    })
    /**
     * @tc.number SandBoxShare_003
     * @tc.name SandBoxShare_003
     * @tc.desc 读取文件内容
     */
    it(BUNDLE + 'SandBoxShare_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_003 begin');
      let str = await getResourceString($r('app.string.ReadFile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_003 end');
    })
    /**
     * @tc.number fileAccessTest_004
     * @tc.name fileAccessTest_004
     * @tc.desc 分享文件
     */
    it(BUNDLE + 'SandBoxShare_004', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_004 begin');
      let str = await getResourceString($r('app.string.FileShare'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_004 end');
    })
    /**
     * @tc.number fileAccessTest_005
     * @tc.name fileAccessTest_005
     * @tc.desc 在另一个应用查看分享的数据  FileManagement
     */
    it(BUNDLE + 'SandBoxShare_005', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_005 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.text('FileManagement'));
      let button: Component = await driver.findComponent(ON.text('FileManagement'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_005 end');
    })
    /**
     * @tc.number fileAccessTest_006
     * @tc.name fileAccessTest_006
     * @tc.desc 在另一个应用查看分享的数据
     */
    it(BUNDLE + 'SandBoxShare_006', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_006 begin');
      let str = await getResourceString($r('app.string.getShareFile'));
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandBoxShare_006 end');
    })
  })
}