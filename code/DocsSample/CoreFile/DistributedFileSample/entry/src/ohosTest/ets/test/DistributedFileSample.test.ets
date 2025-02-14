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

export default function DistributedFileSampleTest() {
  describe('DistributedFileSampleTest', () => {
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
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
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
     * @tc.desc 权限申请
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
     * @tc.number mountPublicDir_001
     * @tc.name mountPublicDir_001
     * @tc.desc 建链并访问文件
     */
    it(BUNDLE + 'mountPublicDir_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'mountPublicDir_001 begin');
      let str = await getResourceString($r('app.string.AccessPublicFileDir'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'mountPublicDir_001 end');
    })
    /**
     * @tc.number copyDistributedFile_001
     * @tc.name copyDistributedFile_001
     * @tc.desc 跨设备拷贝文件
     */
    it(BUNDLE + 'copyDistributedFile_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'copyDistributedFile begin');
      let str = await getResourceString($r('app.string.CopyDistributedToSand'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'copyDistributedFile_001 end');
    })
    /**
     * @tc.number disMountPublicDir_001
     * @tc.name disMountPublicDir_001
     * @tc.desc 关闭建链
     */
    it(BUNDLE + 'disMountPublicDir_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'disMountPublicDir_001 begin');
      let str = await getResourceString($r('app.string.DisconnectingLink'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'disMountPublicDir_001 end');
    })
  })
}