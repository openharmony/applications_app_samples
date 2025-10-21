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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ArkTSPointerAPI]';
const DOMAIN = 0xF811;
const BUNDLE = 'ArkTSPointerAPI_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it('ArkTSPointerAPI_StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktspointer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to hide pointer'));
      await driver.assertComponentExist(ON.text('Click to display pointer'));
      await driver.assertComponentExist(ON.text('Click to set the mouse pointer style to the color picker style'));
      await driver.assertComponentExist(ON.text('点击设置设置鼠标光标样式为默认样式'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 隐藏光标
     */
    it('ArkTSPointerAPI_setPointerVisible_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerVisible_001, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktspointer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `setPointerVisible_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to hide pointer'));
      let button = await driver.findComponent(ON.text('Click to hide pointer'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerVisible_001 end')
    })

    /**
     * 显示光标
     */
    it('ArkTSPointerAPI_setPointerVisible_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerVisible_002, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktspointer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `setPointerVisible_002 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to display pointer'));
      let button = await driver.findComponent(ON.text('Click to display pointer'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerVisible_002 end')
    })

    /**
     * 设置鼠标光标样式为取色器样式
     */
    it('ArkTSPointerAPI_setPointerStyle_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerStyle_001, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktspointer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `setPointerStyle_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Click to set the mouse pointer style to the color picker style'));
      let button = await driver.findComponent(ON.text('Click to set the mouse pointer style to the color picker style'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerStyle_001 end')
    })

    /**
     * 设置设置鼠标光标样式为默认样式
     */
    it('ArkTSPointerAPI_setPointerStyle_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerStyle_002, begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.arktspointer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `setPointerStyle_002 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('点击设置设置鼠标光标样式为默认样式'));
      let button = await driver.findComponent(ON.text('点击设置设置鼠标光标样式为默认样式'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'setPointerStyle_002 end')
    })
  })
}