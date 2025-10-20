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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, Point, On } from '@ohos.UiTest';
import { router } from '@kit.ArkUI';

const TAG = '[Sample_ArkUI_Binding]';
const DOMAIN = 0xF811;
const DELAYTIME01 = 500;
const DELAYTIME02 = 2000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    let driver = Driver.create();
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegatorRegistry.startAbility({
        bundleName: 'com.samples.binding',
        abilityName: 'EntryAbility'
      });
      done();
    })
    afterAll(() => {
    })
    /**
     * 自定义组件间双向绑定
     */
    it('Binding_binding_001', 0, async (done: Function) => {
      await driver.delayMs(DELAYTIME01);
      await router.pushUrl({url:'pages/Binding_Star'});
      await driver.delayMs(DELAYTIME01);
      let button: Component = await driver.findComponent(ON.text('change value'));
      await button.click();
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text('1'));
      let button1: Component = await driver.findComponent(ON.id('aaa'));
      await button1.click();
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text('10'));
      done();
    })
    /**
     * 系统组件参数双向绑定
     */
    it('Binding_binding_002', 0, async (done: Function) => {
      await driver.delayMs(DELAYTIME01);
      await router.pushUrl({url:'pages/Sys_Binding'});
      await driver.delayMs(DELAYTIME01);
      let button: Component = await driver.findComponent(ON.text('Click'));
      await button.click();
      await driver.delayMs(DELAYTIME02);
      await driver.assertComponentExist(ON.text('isShow: true'));
      done();
    })
  })
}