/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { Driver, ON, Component } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'TransientTask_';
const TAG = '[Sample_TransientTask]';
const DOMAIN = 0xF811;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let resMgr = abilityDelegator.getAppContext().resourceManager;
  let text = await resMgr.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 进入应用
     */
    it(BUNDLE + 'StartAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility start');
      let want = {
        bundleName: 'ohos.samples.transienttask',
        abilityName: 'MainAbility'
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `_startAbility get err ${JSON.stringify(err)}`);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end');
      });
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility end');
    });

    /**
     * 升级应用
     */
    it(BUNDLE + 'UpgradeFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpgradeFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('check'));
      let checkBtn = await driver.findComponent(ON.id('check'));
      await checkBtn.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpgradeFunction_001 clickCheckButton');
      await driver.delayMs(1000);
      let test = await getResourceString($r('app.string.update'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'test111:' + test);
      await driver.assertComponentExist(ON.text(test));
      let okBtn = await driver.findComponent(ON.text(test));
      await okBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpgradeFunction_001 end');
    })

    /**
     * 后续需要手动关闭后台任务后重新进入应用
     */
  })
}