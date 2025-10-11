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

import { abilityDelegatorRegistry, Component, Driver, ON, } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../common/Logger';

const DELAY_TIME = 1500; // 延时1.5秒
const BUNDLE = 'FileApiFileTest_';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info('StartAbility_001 begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };

      await delegator.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      Logger.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      Logger.info('StartAbility_001 end');
    })

    /**
     * @tc.number FileApiFileTest_001
     * @tc.name FileApiFileTest_001
     * @tc.desc 设置分布式文件数据等级
     */
    it(BUNDLE + 'FileApiFileTest_001', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_001 begin');
      let str = await getResourceString($r('app.string.setSecurityLabel'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_001 End');
    })

    /**
     * @tc.number FileApiFileTest_002
     * @tc.name FileApiFileTest_002
     * @tc.desc 新建并读写一个文件
     */
    it(BUNDLE + 'FileApiFileTest_002', 0, async () => {
      Logger.info(BUNDLE + 'EnvironmentTest_002 begin');
      let str = await getResourceString($r('app.string.createFile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_002 end');
    })

    /**
     * @tc.number FileApiFileTest_003
     * @tc.name FileApiFileTest_003
     * @tc.desc 读取文件内容并写入到另一个文件
     */
    it(BUNDLE + 'FileApiFileTest_003', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_003 begin');
      let str = await getResourceString($r('app.string.readWriteFile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_003 end');
    })


    /**
     * @tc.number FileApiFileTest_004
     * @tc.name FileApiFileTest_004
     * @tc.desc 以流的形式读写文件
     */
    it(BUNDLE + 'FileApiFileTest_004', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_004 begin');
      let str = await getResourceString($r('app.string.readWriteFileWithStream'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_004 end');
    })


    /**
     * @tc.number FileApiFileTest_005
     * @tc.name FileApiFileTest_005
     * @tc.desc 查看文件列表
     */
    it(BUNDLE + 'FileApiFileTest_005', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_005 begin');
      let str = await getResourceString($r('app.string.getListFile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_005 end');
    })

    /**
     * @tc.number FileApiFileTest_006
     * @tc.name FileApiFileTest_006
     * @tc.desc 使用文件流暂停模式拷贝文件
     */
    it(BUNDLE + 'FileApiFileTest_006', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_006 begin');
      let str = await getResourceString($r('app.string.copyFileWithReadable'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_006 end');
    })

    /**
     * @tc.number FileApiFileTest_007
     * @tc.name FileApiFileTest_007
     * @tc.desc 使用文件流流动模式拷贝文件
     */
    it(BUNDLE + 'FileApiFileTest_007', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_007 begin');
      let str = await getResourceString($r('app.string.copyFileWithData'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_007 end');
    })

    /**
     * @tc.number FileApiFileTest_008
     * @tc.name FileApiFileTest_008
     * @tc.desc 使用文件哈希流
     */
    it(BUNDLE + 'FileApiFileTest_008', 0, async () => {
      Logger.info(BUNDLE + 'FileApiFileTest_008 begin');
      let str = await getResourceString($r('app.string.hashFileWithStream'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'FileApiFileTest_008 end');
    })
  })
}