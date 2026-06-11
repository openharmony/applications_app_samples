/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { Driver, ON, Component, abilityDelegatorRegistry, } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

import Logger from '../common/Logger';

const DELAY_TIME = 1500; // 延时1.5秒
const BUNDLE = 'NDKAppFileAccess_';

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
     * @tc.number NDKCompressTest_001
     * @tc.name NDKCompressTest_001
     * @tc.desc zip压缩
     */
    it(BUNDLE + 'CompressTest_001', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_001 begin');
      let str = "Zip File Compress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_001 end');
    })
    /**
     * @tc.number NDKCompressTest_002
     * @tc.name NDKCompressTest_002
     * @tc.desc zip解压
     */
    it(BUNDLE + 'CompressTest_002', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_002 begin');
      let str = "Zip File Decompress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_002 end');
    })
    /**
     * @tc.number NDKCompressTest_003
     * @tc.name NDKCompressTest_003
     * @tc.desc buffer压缩
     */
    it(BUNDLE + 'CompressTest_003', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_003 begin');
      let str = "Buffer Compress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_003 end');
    })
    /**
     * @tc.number NDKCompressTest_004
     * @tc.name NDKCompressTest_004
     * @tc.desc buffer解压
     */
    it(BUNDLE + 'CompressTest_004', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_004 begin');
      let str = "Buffer Decompress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_004 end');
    })
    /**
     * @tc.number NDKCompressTest_005
     * @tc.name NDKCompressTest_005
     * @tc.desc 流式压缩
     */
    it(BUNDLE + 'CompressTest_005', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_005 begin');
      let str = "Stream Compress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_005 end');
    })
    /**
     * @tc.number NDKCompressTest_006
     * @tc.name NDKCompressTest_006
     * @tc.desc 流式解压
     */
    it(BUNDLE + 'CompressTest_006', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_006 begin');
      let str = "Stream Decompress"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_006 end');
    })
    /**
     * @tc.number NDKCompressTest_007
     * @tc.name NDKCompressTest_007
     * @tc.desc 流式压缩取消
     */
    it(BUNDLE + 'CompressTest_007', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_007 begin');
      let str = "Stream Compress Cancel"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_007 end');
    })
    /**
     * @tc.number NDKCompressTest_008
     * @tc.name NDKCompressTest_008
     * @tc.desc 流式解压取消
     */
    it(BUNDLE + 'CompressTest_008', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_008 begin');
      let str = "Stream Decompress Cancel"
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_008 end');
    })
  })
}