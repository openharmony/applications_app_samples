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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import router from '@ohos.router';


const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function SyncMonitorTest() {
  describe('SyncMonitorTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /*
     * @tc.number     : SyncMonitor_001
     * @tc.name       : testCompareSyncMonitorWithMonitor
     * @tc.desc       : 测试Monitor和SyncMonitor监听状态变量差异
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCompareSyncMonitorWithMonitor', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/CompareSyncMonitorWithMonitor' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_002
     * @tc.name       : testMonitorMultipleVariables
     * @tc.desc       : 测试SyncMonitor监听多个状态变量场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorMultipleVariables', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorMultipleVariables' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_003
     * @tc.name       : testMonitorObjectVariable
     * @tc.desc       : 测试SyncMonitor监听对象属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorObjectVariable', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorObjectVariable' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_004
     * @tc.name       : testMonitorVariablesInObservedV2Class
     * @tc.desc       : 测试@SyncMonitor中监听@ObservedV2中属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorVariablesInObservedV2Class', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorVariablesInObservedV2Class' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_005
     * @tc.name       : testMonitorTwoLayerVariablesInObservedV2Class
     * @tc.desc       : 测试SyncMonitor监听嵌套对象属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorTwoLayerVariablesInObservedV2Class', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorTwoLayerVariablesInObservedV2Class' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_006
     * @tc.name       : testMonitorVariableInBaseDerivedClass
     * @tc.desc       : 测试基类和继承类中监听变量属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorVariableInBaseDerivedClass', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorVariableInBaseDerivedClass' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });
    /*
     * @tc.number     : SyncMonitor_007
     * @tc.name       : testMonitorEntireObjectChangeButPropertyNoChange
     * @tc.desc       : 测试监听对象变化，属性未变化的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorEntireObjectChangeButPropertyNoChange', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorEntireObjectChangeButPropertyNoChange' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });
    /*
     * @tc.number     : SyncMonitor_008
     * @tc.name       : testSyncMonitorBehavesDifferentlyFromMonitor
     * @tc.desc       : 测试SyncMonitor跟Monitor行为不一样的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testSyncMonitorBehavesDifferentlyFromMonitor', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/SyncMonitorBehavesDifferentlyFromMonitor' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_009
     * @tc.name       : testWildcardMonitorObjectPropertyChange
     * @tc.desc       : 测试使用通配符监听对象属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testWildcardMonitorObjectPropertyChange', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/WildcardMonitorObjectPropertyChange' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_010
     * @tc.name       : testWildcardMonitorArrayItemChange
     * @tc.desc       : 测试使用通配符监听数组项的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testWildcardMonitorArrayItemChange', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/WildcardMonitorArrayItemChange' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_011
     * @tc.name       : testWildcardMonitorNestedObjectPropertyChange
     * @tc.desc       : 测试使用通配符监听嵌套对象属性的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testWildcardMonitorNestedObjectPropertyChange', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/WildcardMonitorNestedObjectPropertyChange' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_012
     * @tc.name       : testWildcardMonitorArrayFirstItemChange
     * @tc.desc       : 测试使用通配符监听数组第1项对象属性变化的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testWildcardMonitorArrayFirstItemChange', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/WildcardMonitorArrayFirstItemChange' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_014
     * @tc.name       : testMonitorTheSameVariableTwoTimes
     * @tc.desc       : 测试使用SyncMonitor监听变量两次的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorTheSameVariableTwoTimes', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorTheSameVariableTwoTimes' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_015
     * @tc.name       : testEffectiveAndIneffectiveTimesOfVariableMonitoring
     * @tc.desc       : 测试使用SyncMonitor监听失效时机场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testEffectiveAndIneffectiveTimesOfVariableMonitoring', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/EffectiveAndIneffectiveTimesOfVariableMonitoring' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_016
     * @tc.name       : testMonitorComputedVariable
     * @tc.desc       : 测试使用SyncMonitor监听Computed变量场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorComputedVariable', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorComputedVariable' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : SyncMonitor_017
     * @tc.name       : testMonitorVariableFromAccessibleToInaccessible
     * @tc.desc       : 测试使用SyncMonitor监听变量从可访问到不可访问场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testMonitorVariableFromAccessibleToInaccessible', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/MonitorVariableFromAccessibleToInaccessible' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });
  })
}
