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

const DELAY_TIME = 1500; // 延时1.5秒
const TAG = '[Sample_AppFileBackup]';
const DOMAIN = 0xF811;
const BUNDLE = 'AppFileBackup_';

const DELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();
const BUNDLENAME = abilityDelegatorRegistry.getArguments().bundleName;
const ABILITYDELEGATOR = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = ABILITYDELEGATOR.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function FileBackupRestoreTest() {
  describe('FileBackupTest', () => {
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
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await DELEGATOR.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * @tc.number FileBackup_001
     * @tc.name FileBackup_001
     * @tc.desc 文件的备份
     */
    it(BUNDLE + 'FileBackup_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackup_001 begin');
      let str = await getResourceString($r('app.string.applicationTriggersDataBackup'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Apply to trigger file data backup');
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackup_001 end');
    })
    /**
     * @tc.number FileBackup_002
     * @tc.name FileBackup_002
     * @tc.desc 结束备份服务
     */
    it(BUNDLE + 'FileBackup_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackup_002 begin');
      let str = await getResourceString($r('app.string.releaseBackup'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'End backup service');
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileBackup_002 end');
    })
    /**
     * @tc.number FileRestore_001
     * @tc.name FileRestore_001
     * @tc.desc 启动备份应用
     */
    it(BUNDLE + 'FileRestore_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_001 begin');
      // start Restore ability
      const want: Want = {
        bundleName: 'com.samples.filebackupextension',
        abilityName: 'EntryAbility'
      };
      await DELEGATOR.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'Start fileBackupExtension ability');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_001 end');
    })
    /**
     * @tc.number FileRestore_002
     * @tc.name FileRestore_002
     * @tc.desc 删除数据文件
     */
    it(BUNDLE + 'FileRestore_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_002 begin');
       let str = await getResourceString($r('app.string.deleteFile'));
      let driver: Driver = Driver.create();
       await driver.assertComponentExist(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Apply to trigger file data backup');
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_002 end');
    })
    /**
     * @tc.number StartAbility_002
     * @tc.name StartAbility_002
     * @tc.desc 启动自身应用以触发数据恢复
     */
    it(BUNDLE + 'StartAbility_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002 begin');
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility'
      };
      await DELEGATOR.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await DELEGATOR.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002 end');
    })
    /**
     * @tc.number FileRestore_003
     * @tc.name FileRestore_003
     * @tc.desc 恢复数据文件
     */
    it(BUNDLE + 'FileRestore_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_003 begin');
      let str = await getResourceString($r('app.string.applicationTriggersDataReStore'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      hilog.info(DOMAIN, TAG, BUNDLE + 'Apply to trigger file data backup');
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FileRestore_003 end');
    })
    /**
     * @tc.number StartAbility_003
     * @tc.name StartAbility_003
     * @tc.desc
     */
    it(BUNDLE + 'StartAbility_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_003 begin');
      // start Restore ability
      const want: Want = {
        bundleName: 'com.samples.filebackupextension',
        abilityName: 'EntryAbility'
      };
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await DELEGATOR.startAbility(want);
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_003 end');
    })
  })
}