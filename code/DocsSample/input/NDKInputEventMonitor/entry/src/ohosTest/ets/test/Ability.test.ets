/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
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

const TAG = '[Sample_NDKInputEventMonitor]';
const DOMAIN = 0xF811
const BUNDLE = 'NDKInputEventMonitor'


export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 打开应用
     */
    it('NDKInputEventMonitorAPI_StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加按键事件监听'));
      await driver.assertComponentExist(ON.text('移除按键事件监听'));
      await driver.assertComponentExist(ON.text('添加鼠标事件监听'));
      await driver.assertComponentExist(ON.text('移除鼠标事件监听'));
      await driver.assertComponentExist(ON.text('添加触摸事件监听'));
      await driver.assertComponentExist(ON.text('移除触摸事件监听'));
      await driver.assertComponentExist(ON.text('添加轴事件监听'));
      await driver.assertComponentExist(ON.text('移除轴事件监听'));
      await driver.assertComponentExist(ON.text('添加捏合轴事件监听'));
      await driver.assertComponentExist(ON.text('移除捏合轴事件监听'));
      await driver.assertComponentExist(ON.text('添加滚轮轴事件监听'));
      await driver.assertComponentExist(ON.text('移除滚轮轴事件监听'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 添加按键事件监听
     */
    it('NDKInputEventMonitorAPI_addKeyEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addKeyEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addKeyEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加按键事件监听'));
      let button = await driver.findComponent(ON.text('添加按键事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addKeyEventMonitor_001 end')
    })

    /**
     * 移除按键事件监听
     */
    it('NDKInputEventMonitorAPI_removeKeyEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removeKeyEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removeKeyEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加按键事件监听'));
      let button = await driver.findComponent(ON.text('添加按键事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removeKeyEventMonitor_001 end')
    })

    /**
     * 添加鼠标事件监听
     */
    it('NDKInputEventMonitorAPI_addMouseEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addMouseEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addMouseEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加鼠标事件监听'));
      let button = await driver.findComponent(ON.text('添加鼠标事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addMouseEventMonitor_001 end')
    })

    /**
     * 移除鼠标事件监听
     */
    it('NDKInputEventMonitorAPI_removeMouseEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removeMouseEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removeMouseEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('移除鼠标事件监听'));
      let button = await driver.findComponent(ON.text('移除鼠标事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removeMouseEventMonitor_001 end')
    })

    /**
     * 添加触摸事件监听
     */
    it('NDKInputEventMonitorAPI_addTouchEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addTouchEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addTouchEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加触摸事件监听'));
      let button = await driver.findComponent(ON.text('添加触摸事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addTouchEventMonitor_001 end')
    })

    /**
     * 移除触摸事件监听
     */
    it('NDKInputEventMonitorAPI_removeTouchEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removeTouchEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removeTouchEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('移除触摸事件监听'));
      let button = await driver.findComponent(ON.text('移除触摸事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removeTouchEventMonitor_001 end')
    })

    /**
     * 添加轴事件监听
     */
    it('NDKInputEventMonitorAPI_addAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加轴事件监听'));
      let button = await driver.findComponent(ON.text('添加轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addAxisEventMonitor_001 end')
    })

    /**
     * 移除轴事件监听
     */
    it('NDKInputEventMonitorAPI_removeAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removeAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removeAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('移除轴事件监听'));
      let button = await driver.findComponent(ON.text('移除轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removeAxisEventMonitor_001 end')
    })

    /**
     * 添加捏合轴事件监听
     */
    it('NDKInputEventMonitorAPI_addPinchAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addPinchAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addPinchAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加捏合轴事件监听'));
      let button = await driver.findComponent(ON.text('添加捏合轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addPinchAxisEventMonitor_001 end')
    })

    /**
     * 移除捏合轴事件监听
     */
    it('NDKInputEventMonitorAPI_removePinchAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removePinchAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removePinchAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('移除捏合轴事件监听'));
      let button = await driver.findComponent(ON.text('移除捏合轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removePinchAxisEventMonitor_001 end')
    })

    /**
     * 添加滚轮轴事件监听
     */
    it('NDKInputEventMonitorAPI_addScrollAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "addScrollAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `addScrollAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('添加滚轮轴事件监听'));
      let button = await driver.findComponent(ON.text('添加滚轮轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'addScrollhAxisEventMonitor_001 end')
    })

    /**
     * 移除滚轮轴事件监听
     */
    it('NDKInputEventMonitorAPI_removeScrollAxisEventMonitor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "removeScrollAxisEventMonitor_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.ndkinputeventmonitor',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `removeScrollAxisEventMonitor_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('移除滚轮轴事件监听'));
      let button = await driver.findComponent(ON.text('移除滚轮轴事件监听'));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'removeScrollhAxisEventMonitor_001 end')
    })

  })
}