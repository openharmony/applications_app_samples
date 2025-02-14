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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/util/resource';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    /**
     * 点击按钮，进入使用TaskPool进行频繁数据库操作页面，点击Hello World执行
     */
    it('testUsingTaskPool', 0, async (done: Function) => {
      console.log('uitest: UsingUsingTaskPool begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Using_taskpool'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingUsingTaskPool end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入使用Sendable进行大容量数据库操作页面，点击Hello World执行
     */
    it('testUsingSendable', 0, async (done: Function) => {
      console.log('uitest: UsingUsingSendable begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Using_sendable'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingUsingSendable end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入业务模块并发加载场景页面，点击calculate add,show history,countdown执行
     */
    it('testConcurrentLoadingModulesGuide', 0, async (done: Function) => {
      console.log('uitest: UsingConcurrentLoadingModulesGuide begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Concurrent_loading_modules_guide'))));
      await text.click();
      await driver.delayMs(1000);
      const calculateAdd = await driver.findComponent(ON.id('add'));
      await calculateAdd.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('add').text('success'));

      await driver.delayMs(1000);
      const showHistory = await driver.findComponent(ON.id('show'));
      await showHistory.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('show').text('success'));

      await driver.delayMs(1000);
      const countdown = await driver.findComponent(ON.id('get'));
      await countdown.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('get').text('success'));
      console.log('uitest: UsingConcurrentLoadingModulesGuide end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入ArkUI数据更新场景页面，点击change name,task执行
     */
    it('testMakeobservedSendable', 0, async (done: Function) => {
      console.log('uitest: UsingMakeobservedSendable begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Makeobserved_sendable'))));
      await text.click();
      await driver.delayMs(1000);
      const changeName = await driver.findComponent(ON.id('change name'));
      await changeName.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Tom0'));

      await driver.delayMs(1000);
      const sendable = await driver.findComponent(ON.id('task'));
      await sendable.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Tom0-o'));
      console.log('uitest: UsingMakeobservedSendable end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入ArkUI瀑布流渲染场景页面，滑动屏幕执行
     */
    it('testWaterfallRendering', 0, async (done: Function) => {
      console.log('uitest: UsingWaterfallRendering begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Waterfall_rendering'))));
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('N0'));
      const waterFlow = await driver.findComponent(ON.type('WaterFlow'));
      await waterFlow.scrollSearch(ON.text('N20'));
      console.log('uitest: UsingWaterfallRendering end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入全局配置项功能场景页面，点击wifi on,download,在输入框输入信息,点击login显示信息,点击not login清除信息执行
     */
    it('testGlobalConfigurationGuide', 0, async (done: Function) => {
      console.log('uitest: UsingGlobalConfigurationGuide begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Global_configuration_guide'))));
      await text.click();
      await driver.delayMs(1000);
      const toggle = await driver.findComponent(ON.type('Toggle'));
      await toggle.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('wifi on'));

      const download = await driver.findComponent(ON.text('download'));
      await driver.delayMs(1000);
      await download.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('download fail'));

      const textInput = await driver.findComponent(ON.id('textInput'));
      await driver.delayMs(1000);
      await textInput.inputText('abc');

      const login = await driver.findComponent(ON.text('login'));
      await driver.delayMs(1000);
      await login.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('login: abc'));

      const logout = await driver.findComponent(ON.text('logout'));
      await driver.delayMs(1000);
      await logout.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('not login'));
      console.log('uitest: UsingGlobalConfigurationGuide end');
      await driver.pressBack();
      done();
    })
  })
}