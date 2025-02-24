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
const TAG = '[Sample_FileBackupExtension]';
const DOMAIN = 0xF811;
const BUNDLE = 'FileBackupExtension_';

const DELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;
const ABILITYDELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = ABILITYDELEGATOR.getAppContext().resourceManager;
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
      // start tested ability
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility'
      };
      await DELEGATOR.startAbility(want);
      // check top display ability
      const ability: UIAbility = await DELEGATOR.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('TestAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * @tc.number FileBackupExtension_001
     * @tc.name FileBackupExtension_001
     * @tc.desc 文件的创建
     */
    it(BUNDLE + 'FileBackupExtension_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackupExtension_001 begin');
      let str = await getResourceString($r('app.string.CreateFiles'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Create the file');
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackupExtension_001 end');
    })
    /**
     * @tc.number FileBackupExtension_002
     * @tc.name FileBackupExtension_002
     * @tc.desc 文件删除
     */
    it(BUNDLE + 'FileBackupExtension_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackupExtension_002 begin');
      let str = await getResourceString($r('app.string.FileDelete'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Delete the file');
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackupExtension_002 end');
    })
  })
}