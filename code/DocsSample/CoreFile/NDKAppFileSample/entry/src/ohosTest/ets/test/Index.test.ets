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
     * @tc.number NDKFileAccessTest_001
     * @tc.name NDkFileAccessTest_001
     * @tc.desc 文件的创建
     */
    it(BUNDLE + 'fileAccessTest_001', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_001 begin');
      let str = await getResourceString($r('app.string.createWriteReadfile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_001 end');
    })
    /**
     * @tc.number NDKFileAccessTest_002
     * @tc.name NDKFileAccessTest_002
     * @tc.desc 判断文件位置
     */
    it(BUNDLE + 'fileAccessTest_002', 0, async () => {
      Logger.info(BUNDLE + 'NDKFileAccessTest_002 begin');
      let str = await getResourceString($r('app.string.DetermineFileLocation'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'NDKFileAccessTest_002 end');
    })
  })
}