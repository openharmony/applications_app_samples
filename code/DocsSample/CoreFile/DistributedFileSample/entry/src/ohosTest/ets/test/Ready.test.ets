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

import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON, Component, abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DELAY_TIME = 1500; // 延时1.5秒
const TAG = '[Sample_DistributedFileSamples]';
const DOMAIN = 0xF811;
const BUNDLE = 'DistributedFileSamples_';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function readyTest() {
  describe('readyTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      // start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      // check top display ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('TestAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');

    })
    /**
     * @tc.number ApplyPermission_001
     * @tc.name ApplyPermission_001
     * @tc.desc 权限申请
     */
    it(BUNDLE + 'ApplyPermission_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplyPermission_001 begin');
      let str = await getResourceString($r('app.string.ApplyPermission'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplyPermission_001 end');
    })
    /**
     * @tc.number ApplyPermission_002
     * @tc.name ApplyPermission_002
     * @tc.desc 允许权限
     */
    it(BUNDLE + 'ApplyPermission_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplyPermission_002 begin');
      let str = await getResourceString($r('app.string.permit'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplyPermission_002 end');
    })
    /**
     * @tc.number CreateFile_001
     * @tc.name CreateFile_001
     * @tc.desc 分布式目录下创建文件
     */
    it(BUNDLE + 'CreateFile_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFile_001 begin');
      let str = await getResourceString($r('app.string.CreateFile'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFile_001 end');
    })
    /**
     * @tc.number copySandFile_001
     * @tc.name copySandFile_001
     * @tc.desc 从沙箱路径复制文件到分布式路径
     */
    it(BUNDLE + 'copySandFile_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'copySandFile begin');
      let str = await getResourceString($r('app.string.CopySandToDistributed'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'copySandFile end');
    })

  })
}