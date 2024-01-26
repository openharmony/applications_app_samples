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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../utils/Logger';
const TAG = '[Sample_StorageStatistic_Test]';
const BUNDLE = 'StorageStatistic_';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
const DRIVER = Driver.create();

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE +  'StartAbility_001 begin');
      try {
        await delegator.startAbility({
          bundleName: 'ohos.samples.storagestaistic',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    it('getPermission_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'getPermission_001 begin');
      await DRIVER.delayMs(2000);
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.allow'))));
      let allowBtn = await DRIVER.findComponent(ON.text(await getResourceString($r('app.string.allow'))));
      await allowBtn.click();
      Logger.info(TAG, BUNDLE + 'getPermission_001 end');
    })

    /**
     * 检查首页
     */
    it('CheckIndex_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'CheckIndex_001 begin');
      // 等待数据刷新
      await DRIVER.delayMs(5000);
      // 断言界面UI
      await DRIVER.assertComponentExist(ON.id('dataPanel'));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_application'))));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_audio'))));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_video'))));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_image'))));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_file'))));
      await DRIVER.assertComponentExist(ON.text(await getResourceString($r('app.string.query_data_system'))));
      Logger.info(TAG, BUNDLE + 'CheckIndex_001 end');
    })

    /**
     * 检查应用列表
     */
    it('CheckAppInfo_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'CheckAppInfo_001 end');
      // 等待数据刷新
      let appInfo = await DRIVER.findComponent(ON.text(await getResourceString($r('app.string.query_data_application'))));
      await appInfo.click();
      await DRIVER.delayMs(1000);
      // 断言界面UI
      await DRIVER.assertComponentExist(ON.id('appInfo'));
      Logger.info(TAG, BUNDLE + 'CheckAppInfo_001 end');
    })
  })
}