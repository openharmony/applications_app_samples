/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import { router } from '@kit.ArkUI';

const TAG = '[Sample_ArkTSUserPlaceHolder]';
const DOMAIN = 0xF811
const BUNDLE = 'ArkTSUserPlaceHolder_'

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.placeholder',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CustomNode'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 点击按钮，打开挂在自定义节点页面
     */
    it(BUNDLE + 'CustomNode_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CustomNode_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.placeholder',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `CustomNode_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CustomNode'));
      let drawPathBtn = await driver.findComponent(ON.text('CustomNode'));
      // 点击'CustomNode'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CustomNode_001 end')
      router.back();
    })

    /**
     * 点击按钮，打开布局差异页面
     */
    it(BUNDLE + 'LayoutDiff_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LayoutDiff_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await driver.delayMs(1000);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.placeholder',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `LayoutDiff_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('LayoutDiff'));
      let drawPathBtn = await driver.findComponent(ON.text('LayoutDiff'));
      // 点击'LayoutDiff'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'LayoutDiff_001 end')
    })
  })
}