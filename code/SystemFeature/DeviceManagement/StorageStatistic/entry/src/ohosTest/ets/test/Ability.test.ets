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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const DRIVER = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.storagestaistic',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 检查首页
     */
    it('CheckIndex_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'CheckIndex_001 begin');
      // 等待数据刷新
      await DRIVER.delayMs(5000);
      // 断言界面UI
      await DRIVER.assertComponentExist(ON.id('dataPanel'));
      await DRIVER.assertComponentExist(ON.text('应用'));
      await DRIVER.assertComponentExist(ON.text('音频'));
      await DRIVER.assertComponentExist(ON.text('视频'));
      await DRIVER.assertComponentExist(ON.text('图片'));
      await DRIVER.assertComponentExist(ON.text('文件'));
      await DRIVER.assertComponentExist(ON.text('系统'));
      hilog.info(0x0000, 'testTag', 'CheckIndex_001 end');
    })

    /**
     * 检查应用列表
     */
    it('CheckAppInfo_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'CheckAppInfo_001 end');
      // 等待数据刷新
      let appInfo = await DRIVER.findComponent(ON.text('应用'));
      await appInfo.click();
      await DRIVER.delayMs(1000);
      // 断言界面UI
      await DRIVER.assertComponentExist(ON.id('appInfo'));
      hilog.info(0x0000, 'testTag', 'CheckAppInfo_001 end');
    })
  })
}