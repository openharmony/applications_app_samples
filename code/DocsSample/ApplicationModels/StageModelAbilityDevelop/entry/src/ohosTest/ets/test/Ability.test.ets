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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, UIElementInfo, UIEventObserver } from '@ohos.UiTest';
import Logger from '../utils/Logger';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';

const BUNDLE = 'StageModelAbilityDevelop_';
const TAG = '[Sample_stagemodelabilitydevelop]';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('StageModelAbilityDevelopTest', () => {
    /*
     * @tc.number: StageModelAbilityDevelopTest_001
     * @tc.name: Start Ability
     * @tc.desc: Start Ability
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'EntryAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_001 begin');
      // 开启Stage模型开发指导
      let want: Want = {
        bundleName: 'com.samples.stagemodelabilitydevelop',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_001 end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_002
     * @tc.name: Start Model
     * @tc.desc: Start Model
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'StartModelTest', 1, async (done: Function) => {

      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_002 begin');

      // 跳转到UIAbility组件启动模式界面
      Logger.info(TAG, 'StartModel start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsStartModel'))));
      let StartModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsStartModel'))));
      await StartModel.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'StartModel end');

      // 跳转到单实例模式界面
      Logger.info(TAG, 'SingletonModel start');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.singleton'))));
      let singleton = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.singleton'))));
      await singleton.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'SingletonModel end');
      await driver.pressBack();

      // 跳转到多实例模式界面
      Logger.info(TAG, 'MultitonModel start');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.multiton'))));
      let multiton = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.multiton'))));
      await multiton.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'MultitonModel end');
      await driver.pressBack();

      // 跳转到指定实例A模式界面
      Logger.info(TAG, 'SpecifiedAModel start');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.SpecifiedA'))));
      let SpecifiedA = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SpecifiedA'))));
      await SpecifiedA.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'SpecifiedAModel end');
      await driver.pressBack();

      // 跳转到多实例模式界面
      Logger.info(TAG, 'SpecifiedBModel start');
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.SpecifiedB'))));
      let SpecifiedB = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SpecifiedB'))));
      await SpecifiedB.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'SpecifiedBModel end');
      await driver.pressBack();
      await driver.pressBack();
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_002 end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_003
     * @tc.name: Components Basic Usage
     * @tc.desc: Components Basic Usage
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UIAbilityComponentsBasicUsageTest', 2, async (done: Function) => {

      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_003 begin');
      // 跳转到UIAbility组件的基本用法界面
      Logger.info(TAG, 'UIAbilityComponentsBasicUsage start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsBasicUsage'))));
      let StartModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsBasicUsage'))));
      await StartModel.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'UIAbilityComponentsBasicUsage end');
      await driver.pressBack();
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_003 end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_004
     * @tc.name: EventHub Sync
     * @tc.desc: EventHub Sync
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'EventHubTest', 3, async (done: Function) => {

      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_004 begin');
      let observer: UIEventObserver = await driver.createUIEventObserver();
      let toastText: String = '';
      let callback = (UIElementInfo: UIElementInfo) => {
        Logger.info(TAG, 'toast:' + UIElementInfo.text);
        toastText = UIElementInfo.text;
      }

      // 跳转到UIAbility组件与UI数据同步界面
      Logger.info(TAG, 'EventHub start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.DataSynchronization'))));
      let StartModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.DataSynchronization'))));
      await StartModel.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'EventHub end');

      // 订阅事件
      Logger.info(TAG, 'EventHubFuncATest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EventHubFuncA'))));
      let EventHubFuncA = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EventHubFuncA'))));
      if (EventHubFuncA !== null) {
        observer.once('toastShow', callback);
        await EventHubFuncA.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.EventHubFuncA')));
      }
      Logger.info(TAG, 'EventHubFuncATest end');

      // 取消订阅
      Logger.info(TAG, 'EventHubFuncBTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.EventHubFuncB'))));
      let EventHubFuncB = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.EventHubFuncB'))));
      if (EventHubFuncB !== null) {
        observer.once('toastShow', callback);
        await EventHubFuncB.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.EventHubFuncB')));
      }
      Logger.info(TAG, 'EventHubFuncBTest end');

      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_004 end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_005
     * @tc.name: Components Interaction
     * @tc.desc: Components Interaction
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UIAbilityComponentsInteractionTest', 4, async (done: Function) => {

      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_005 begin');

      let observer: UIEventObserver = await driver.createUIEventObserver();
      let toastText: String = '';
      let callback = (UIElementInfo: UIElementInfo) => {
        Logger.info(TAG, 'toast:' + UIElementInfo.text);
        toastText = UIElementInfo.text;
      }

      // 跳转到UIAbility组件间交互（设备内）界面
      Logger.info(TAG, 'UIAbilityComponentsInteractionTest start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractive'))));
      let StartModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractive'))));
      await StartModel.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'UIAbilityComponentsInteractionTest end');

      // 冷启动
      Logger.info(TAG, 'UIAbilityComponentsInteractionOnCreate start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionOnCreate'))));
      let UIAbilityComponentsInteractionOnCreate = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionOnCreate'))));
      await UIAbilityComponentsInteractionOnCreate.click();
      await driver.delayMs(3000);

      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.FunctionA'))));
      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, 'UIAbilityComponentsInteractionOnCreate end');

      // 热启动
      // 启动热启动的Ability
      let want: Want = {
        bundleName: 'com.samples.stagemodelabilityinteraction',
        abilityName: 'EntryAbility'
      };
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      });
      await driver.delayMs(5000);
      await driver.pressHome();
      await driver.delayMs(1000);

      want = {
        bundleName: 'com.samples.stagemodelabilitydevelop',
        abilityName: 'EntryAbility'
      };
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);

      Logger.info(TAG, 'UIAbilityComponentsInteractionOnNewWant start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionOnNewWant'))));
      let UIAbilityComponentsInteractionOnNewWant = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionOnNewWant'))));
      await UIAbilityComponentsInteractionOnNewWant.click();
      await driver.delayMs(5000);

      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.FunctionB'))));
      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, 'UIAbilityComponentsInteractionOnCreate end');

      await driver.pressBack();
      await driver.delayMs(1000);

      // 启动应用内的UIAbility
      Logger.info(TAG, 'UIAbilityComponentsInteractionA start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionA'))));
      let UIAbilityComponentsInteractionA = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionA'))));
      await UIAbilityComponentsInteractionA.click();
      await driver.delayMs(3000);
      await driver.pressBack();
      Logger.info(TAG, 'UIAbilityComponentsInteractionA end');

      // 启动应用内的UIAbility并获取返回值
      Logger.info(TAG, 'UIAbilityComponentsInteractionB start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionB'))));
      let UIAbilityComponentsInteractionB = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionB'))));
      await UIAbilityComponentsInteractionB.click();
      await driver.delayMs(3000);

      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.CloseSpecifiedPageA'))));
      let CloseSpecifiedPageA = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CloseSpecifiedPageA'))));
      await CloseSpecifiedPageA.click();
      await driver.delayMs(3000);
      Logger.info(TAG, 'UIAbilityComponentsInteractionB end');

      // 启动其他应用的UIAbility
      Logger.info(TAG, 'UIAbilityComponentsInteractionC start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionC'))));
      let UIAbilityComponentsInteractionC = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionC'))));
      await UIAbilityComponentsInteractionC.click();
      await driver.delayMs(3000);

      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.CloseSpecifiedPage'))));
      let CloseSpecifiedPage = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CloseSpecifiedPage'))));
      await CloseSpecifiedPage.click();
      await driver.delayMs(3000);
      Logger.info(TAG, 'UIAbilityComponentsInteractionC end');


      // 启动UIAbility指定窗口模式
      Logger.info(TAG, 'UIAbilityComponentsInteractionE start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionE'))));
      let UIAbilityComponentsInteractionE = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionE'))));
      await UIAbilityComponentsInteractionE.click();
      await driver.delayMs(3000);
      await driver.pressBack();
      Logger.info(TAG, 'UIAbilityComponentsInteractionE end');

      // 启动UIAbility的指定界面
      Logger.info(TAG, 'UIAbilityComponentsInteractionF start');
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionF'))));
      let UIAbilityComponentsInteractionF = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.UIAbilityComponentsInteractionF'))));
      await UIAbilityComponentsInteractionF.click();
      await driver.delayMs(5000);

      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.FuncAbilityB'))));
      await driver.pressBack();
      await driver.delayMs(3000);

      // Caller交互
      Logger.info(TAG, 'CallerTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Caller'))));
      let Caller = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Caller'))));
      if (Caller !== null) {
        observer.once('toastShow', callback);
        await Caller.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.CallerSuccess')));
      }
      Logger.info(TAG, 'CallerSuccessTest end');
      await driver.delayMs(1000);


      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_005 end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_006
     * @tc.name: Context
     * @tc.desc: Context
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ContextTest', 5, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_006, begin');
      let observer: UIEventObserver = await driver.createUIEventObserver();
      let toastText: String = '';
      let callback = (UIElementInfo: UIElementInfo) => {
        Logger.info(TAG, 'toast:' + UIElementInfo.text);
        toastText = UIElementInfo.text;
      }
      // 跳转到应用上下文Context界面
      Logger.info(TAG, 'ContextTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Context'))));
      let Context = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Context'))));
      await Context.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'ContextTest end');

      Logger.info(TAG, 'MethodOneForObtainingApplicationFilePathTest start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.MethodOneForObtainingApplicationFilePath'))));
      let MethodOneForObtainingApplicationFilePath = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.MethodOneForObtainingApplicationFilePath'))));
      if (MethodOneForObtainingApplicationFilePath !== null) {
        observer.once('toastShow', callback);
        await MethodOneForObtainingApplicationFilePath.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.filePath01')));
      }
      Logger.info(TAG, 'MethodOneForObtainingApplicationFilePathTest end');

      Logger.info(TAG, 'MethodOneTwoObtainingApplicationFilePathTest start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.MethodOneTwoObtainingApplicationFilePath'))));
      let MethodOneTwoObtainingApplicationFilePath = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.MethodOneTwoObtainingApplicationFilePath'))));
      if (MethodOneTwoObtainingApplicationFilePath !== null) {
        observer.once('toastShow', callback);
        await MethodOneTwoObtainingApplicationFilePath.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.filePath02')));
      }
      await driver.delayMs(1000);
      Logger.info(TAG, 'MethodOneTwoObtainingApplicationFilePathTest end');

      // 切换到E1
      Logger.info(TAG, 'SwitchToEL1 start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.SwitchToEL1'))));
      let SwitchToEL1 = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SwitchToEL1'))));
      if (SwitchToEL1 !== null) {
        observer.once('toastShow', callback);
        await SwitchToEL1.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.SwitchToEL1')));
      }
      await driver.delayMs(1000);
      Logger.info(TAG, 'SwitchToEL1 end');

      // 切换到E2
      Logger.info(TAG, 'SwitchToEL2 start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.SwitchToEL2'))));
      let SwitchToEL2 = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.SwitchToEL2'))));
      if (SwitchToEL2 !== null) {
        observer.once('toastShow', callback);
        await SwitchToEL2.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.SwitchToEL2')));
      }
      await driver.delayMs(1000);
      Logger.info(TAG, 'SwitchToEL2 end');

      // 跳转到创建其他应用或其他Module的Context界面
      Logger.info(TAG, 'CreateContextMethodTest start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Context04'))));
      let Context04 = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Context04'))));
      await Context04.click();
      await driver.delayMs(3000);

      let CreateContextMethodOne = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CreateContextMethodOne'))));
      if (CreateContextMethodOne !== null) {
        observer.once('toastShow', callback);
        await CreateContextMethodOne.click();
        await driver.delayMs(500);
        expect(toastText)
          .assertEqual(await resourceManager.getStringValue($r('app.string.SuccessfullyObtainedContext')));
      }
      await driver.delayMs(1000);

      let CreateContextMethodTwo = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CreateContextMethodTwo'))));
      if (CreateContextMethodTwo !== null) {
        observer.once('toastShow', callback);
        await CreateContextMethodTwo.click();
        await driver.delayMs(500);
        expect(toastText)
          .assertEqual(await resourceManager.getStringValue($r('app.string.SuccessfullyObtainedContext')));
      }
      await driver.delayMs(1000);

      let CreateContextMethodThree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CreateContextMethodThree'))));
      if (CreateContextMethodThree !== null) {
        observer.once('toastShow', callback);
        await CreateContextMethodThree.click();
        await driver.delayMs(500);
        expect(toastText)
          .assertEqual(await resourceManager.getStringValue($r('app.string.SuccessfullyObtainedContext')));
      }
      await driver.delayMs(1000);

      Logger.info(TAG, 'CreateContextMethodTest end');
      await driver.pressBack();
      await driver.delayMs(3000);

      Logger.info(TAG, 'Context05Test start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Context05'))));
      let Context05 = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Context05'))));
      await Context05.click();
      await driver.delayMs(3000);

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.SpecifiedPageA'))));
      let CloseSpecifiedPageA = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CloseSpecifiedPageA'))));
      await CloseSpecifiedPageA.click();
      await driver.delayMs(3000);
      Logger.info(TAG, 'Context05Test end');
      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_006, end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_007
     * @tc.name: Device Cross Migration
     * @tc.desc: Device Cross Migration
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'DeviceCrossMigrationTest', 5, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_007, begin');
      let observer: UIEventObserver = await driver.createUIEventObserver();
      let toastText: String = '';
      let callback = (UIElementInfo: UIElementInfo) => {
        Logger.info(TAG, 'toast:' + UIElementInfo.text);
        toastText = UIElementInfo.text;
      }

      // 跳转到跨端迁移界面
      Logger.info(TAG, 'DeviceCrossMigrationTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.DeviceCrossMigration'))));
      let DeviceCrossMigration = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.DeviceCrossMigration'))));
      await DeviceCrossMigration.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'DeviceCrossMigrationTest end');

      // 允许申请权限
      Logger.info(TAG, 'permitTest start');
      driver = Driver.create();
      await driver.delayMs(1500);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.permit'))));
      let permit = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.permit'))));
      // await permit.click();
      // await driver.delayMs(1000);
      if (permit !== null) {
        observer.once('toastShow', callback);
        await permit.click();
      }
      Logger.info(TAG, 'permitTest end');

      // 跳转到跨端迁移第二页
      Logger.info(TAG, 'Page_MigrationAbilitySecondTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilitySecond'))));
      let Page_MigrationAbilitySecond = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilitySecond'))));
      await Page_MigrationAbilitySecond.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, 'Page_MigrationAbilitySecondTest end');

      // 跳转到跨端迁移第三页
      Logger.info(TAG, 'Page_MigrationAbilityThirdTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilityThird'))));
      let Page_MigrationAbilityThird = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilityThird'))));
      await Page_MigrationAbilityThird.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(TAG, 'Page_MigrationAbilityThirdTest end');

      // 将应用设置为可迁移状态
      Logger.info(TAG, 'Page_MigrationAbilityFourthTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilityFourth'))));
      let Page_MigrationAbilityFourth = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Page_MigrationAbilityFourth'))));
      // await Page_MigrationAbilityFourth.click();
      // await driver.delayMs(1000);
      if (Page_MigrationAbilityFourth !== null) {
        observer.once('toastShow', callback);
        await Page_MigrationAbilityFourth.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.Success')));
      }
      Logger.info(TAG, 'Page_MigrationAbilityFourthTest end');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_007, end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_008
     * @tc.name: Collaborate Ability
     * @tc.desc: Collaborate Ability
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'CollaborateAbilityTest', 5, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_008, begin');
      let observer: UIEventObserver = await driver.createUIEventObserver();
      let toastText: String = '';
      let callback = (UIElementInfo: UIElementInfo) => {
        Logger.info(TAG, 'toast:' + UIElementInfo.text);
        toastText = UIElementInfo.text;
      }

      // 跳转到跨端迁移界面
      Logger.info(TAG, 'CollaborateAbilityTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaboration'))));
      let MultiDeviceCollaboration = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaboration'))));
      await MultiDeviceCollaboration.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'CollaborateAbilityTest end');

      // 多设备协同初始化
      Logger.info(TAG, 'CollaborativeInitializationTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.CollaborativeInitialization'))));
      let CollaborativeInitialization = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.CollaborativeInitialization'))));
      if (CollaborativeInitialization !== null) {
        observer.once('toastShow', callback);
        await CollaborativeInitialization.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.InitializedSuccessfully')));
      }
      Logger.info(TAG, 'CollaborativeInitializationTest end');

      // 多端协同无返回数据
      Logger.info(TAG, 'MultiDeviceCollaborationWithoutReturningDataTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaborationWithoutReturningData'))));
      let MultiDeviceCollaborationWithoutReturningData = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaborationWithoutReturningData'))));
      await MultiDeviceCollaborationWithoutReturningData.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, 'CollaborativeInitializationTest end');

      // 多端协同有返回数据
      Logger.info(TAG, 'MultiDeviceCollaborationWithReturningDataTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaborationWithReturningData'))));
      let MultiDeviceCollaborationWithReturningData = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.MultiDeviceCollaborationWithReturningData'))));
      await MultiDeviceCollaborationWithReturningData.click();
      await driver.delayMs(1000);

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.ClosePage_CollaborateAbility'))));
      let ClosePage_CollaborateAbility = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.ClosePage_CollaborateAbility'))));
      await ClosePage_CollaborateAbility.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'MultiDeviceCollaborationWithReturningDataTest end');

      // Caller交互
      Logger.info(TAG, 'CallerTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.Caller'))));
      let Caller = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.Caller'))));
      if (Caller !== null) {
        observer.once('toastShow', callback);
        await Caller.click();
        await driver.delayMs(500);
        expect(toastText).assertEqual(await resourceManager.getStringValue($r('app.string.CallerSuccess')));
      }
      Logger.info(TAG, 'CallerSuccessTest end');
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_008, end');
      done();
    })

    /*
     * @tc.number: StageModelAbilityDevelopTest_009
     * @tc.name: Start FAModel
     * @tc.desc: Start FAModel
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'StartFAModelTest', 5, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_009, begin');

      // 跳转到Stage模型和FA模型交互
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.StageModelinteractiveWithFAModel'))));
      let StageModelinteractiveWithFAModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.StageModelinteractiveWithFAModel'))));
      await StageModelinteractiveWithFAModel.click();
      await driver.delayMs(1000);

      // Stage模型启动FA模型无返回值
      Logger.info(TAG, 'StartFAModelTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.StartFAModel'))));
      let StartFAModel = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.StartFAModel'))));
      await StartFAModel.click();
      await driver.delayMs(3000);
      await driver.pressBack();
      Logger.info(TAG, 'StartFAModelTest end');

      // Stage模型启动FA模型有返回值
      Logger.info(TAG, 'StartFAModelWithResultTest start');
      driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.StartFAModelWithResult'))));
      let StartFAModelWithResult = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.StartFAModelWithResult'))));
      await StartFAModelWithResult.click();
      await driver.delayMs(3000);
      await driver.pressBack();
      Logger.info(TAG, 'StartFAModelWithResultTest end');

      await driver.pressBack();
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + 'StageModelAbilityDevelopTest_009, end');
      done();
    })
  })
}