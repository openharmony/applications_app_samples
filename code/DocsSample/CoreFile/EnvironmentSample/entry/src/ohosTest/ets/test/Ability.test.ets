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
const BUNDLE = 'EnvironmentTest_';

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
      const allowButton: Component = await driver.findComponent(ON.text('允许'));
      await allowButton.click();
      await driver.delayMs(DELAY_TIME); // 等待2秒，确保弹窗已显示

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      Logger.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      Logger.info('StartAbility_001 end');
    })

    /**
     * @tc.number EnvironmentTest_001
     * @tc.name EnvironmentTest_001
     * @tc.desc 获取用户 Download 目录沙箱路径
     */
    it(BUNDLE + 'environmentTest_001', 0, async () => {
      Logger.info(BUNDLE + 'EnvironmentTest_001 begin');
      let str = await getResourceString($r('app.string.getUserDirExample'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'EnvironmentTest_001 end');
    })

    /**
     * @tc.number EnvironmentTest_002
     * @tc.name EnvironmentTest_002
     * @tc.desc 查看Download目录下的文件
     */
    it(BUNDLE + 'environmentTest_002', 0, async () => {
      Logger.info(BUNDLE + 'EnvironmentTest_002 begin');
      let str = await getResourceString($r('app.string.readUserDownloadDirExample'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'EnvironmentTest_002 end');
    })

    /**
     * @tc.number EnvironmentTest_003
     * @tc.name EnvironmentTest_003
     * @tc.desc 保存 temp.txt 到 Download 目录
     */
    it(BUNDLE + 'environmentTest_003', 0, async () => {
      Logger.info(BUNDLE + 'EnvironmentTest_003 begin');
      let str = await getResourceString($r('app.string.writeUserDownloadDirExample'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'EnvironmentTest_003 end');
    })
  })
}