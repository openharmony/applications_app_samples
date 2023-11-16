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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../utils/Logger';
import inputMethod from '@ohos.inputMethod';

const TAG = '[Sample_StateManagement]'
const BUNDLE = 'StateManagement_'

const DELAY_TIME = 1000
let driver: Driver = Driver.create()

//通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.text(atom))
  let button = await driver.findComponent(ON.text(atom))
  await button.click()
  await driver.delayMs(DELAY_TIME)
  Logger.info(TAG, BUNDLE + atom)
}

//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.id(atom))
  let button = await driver.findComponent(ON.id(atom))
  await button.click()
  await driver.delayMs(DELAY_TIME)
  Logger.info(TAG, BUNDLE + atom)
}

//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndLongClickWithID(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.id(atom))
  let button = await driver.findComponent(ON.id(atom))
  await button.longClick()
  await driver.delayMs(DELAY_TIME)
  Logger.info(TAG, BUNDLE + atom)
}

async function clickSelectIDAndSelectText(toggleId: string, selectText: string) {
  { //展开
    let atom = toggleId
    await checkButtonAndClickWithID(atom)
  }
  { //选择
    let atom = selectText
    await checkButtonAndClickWithText(atom)
  }
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, function () {

      Logger.info("Sample_StateManagement test start")
      /**
       * 打开应用
       */
      it(BUNDLE + 'StartAbility_001', 0, async function (done) {
        Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
        try {
          await abilityDelegator.startAbility({
            bundleName: 'com.samples.statemanagement',
            abilityName: 'EntryAbility'
          })
          done()
        } catch (exception) {
          Logger.info(TAG, `StartAbility_001 end ${JSON.stringify(exception)}`)
          expect(0).assertEqual(exception.code)
          done()
        }
        Logger.info(TAG, BUNDLE + 'StartAbility_001' + ' end')
      })

      /**
       * 打开折叠层
       */
      it(BUNDLE + 'FolderLayerFunction_001', 0, async function () {
        let testName = 'FolderLayerFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let driver = Driver.create();
        await driver.delayMs(500);
        // 打开修饰对象模块的折叠
        await driver.assertComponentExist(ON.id('secondLevelMenu00'));
        let decoratedOject = await driver.findComponent(ON.id('secondLevelMenu00'));
        await decoratedOject.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('secondLevelMenu01'));
        let updatedBound = await driver.findComponent(ON.id('secondLevelMenu01'));
        await updatedBound.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('secondLevelMenu10'));
        let multiComponentsSync = await driver.findComponent(ON.id('secondLevelMenu10'));
        await multiComponentsSync.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 测试基础类型状态管理
       */
      it(BUNDLE + 'BaseTypeFunction_001', 0, async function () {
        let testName = 'BaseTypeFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入基础类型页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.base_type'))));
        let enterPage = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.base_type'))));
        await enterPage.click();
        await driver.delayMs(500);
        // 设置圆形颜色
        await driver.assertComponentExist(ON.id('circleColorBtn'));
        let setCircleColor = await driver.findComponent(ON.id('circleColorBtn'));
        await setCircleColor.click();
        await driver.delayMs(500);
        // 再次设置圆形颜色
        await setCircleColor.click();
        await driver.delayMs(500);
        // 查看源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 测试数组类型状态管理
       */
      it(BUNDLE + 'ArrayTypeFunction_001', 0, async function () {
        let testName = 'ArrayTypeFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入数组类型页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.array_type'))));
        let enterPage = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.array_type'))));
        await enterPage.click();
        await driver.delayMs(500);
        // 点击删除元素
        await driver.assertComponentExist(ON.id('arrayTypeBtn1'));
        let arrayTypeDeleteBtn = await driver.findComponent(ON.id('arrayTypeBtn1'));
        await arrayTypeDeleteBtn.click();
        await driver.delayMs(500);
        await arrayTypeDeleteBtn.click();
        await driver.delayMs(500);
        await arrayTypeDeleteBtn.click();
        await driver.delayMs(500);
        await arrayTypeDeleteBtn.click();
        await driver.delayMs(500);
        // 点击添加元素
        await driver.assertComponentExist(ON.id('arrayTypeBtn0'));
        let arrayTypeAddBtn = await driver.findComponent(ON.id('arrayTypeBtn0'));
        await arrayTypeAddBtn.click();
        await driver.delayMs(500);
        // 点击更新元素
        await driver.assertComponentExist(ON.id('arrayTypeBtn2'));
        let arrayTypeUpdateBtn = await driver.findComponent(ON.id('arrayTypeBtn2'));
        await arrayTypeUpdateBtn.click();
        await driver.delayMs(500);
        await arrayTypeDeleteBtn.click();
        await driver.delayMs(500);
        await arrayTypeUpdateBtn.click();
        await driver.delayMs(500);
        await arrayTypeAddBtn.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      })

      /**
       * 测试类对象类型状态管理
       */
      it(BUNDLE + 'ObjectTypeFunction_001', 0, async function () {
        let testName = 'ObjectTypeFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入类对象类型页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.class_type'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.class_type'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击更新对象
        await driver.assertComponentExist(ON.id('updateObject'));
        let updateObjectBtn = await driver.findComponent(ON.id('updateObject'));
        await updateObjectBtn.click();
        await driver.delayMs(500);
        await updateObjectBtn.click();
        await driver.delayMs(500);
        // 点击更新对象属性
        await driver.assertComponentExist(ON.id('updateObjectAttribute'));
        let updateObjectAttributeBtn = await driver.findComponent(ON.id('updateObjectAttribute'));
        await updateObjectAttributeBtn.click();
        await driver.delayMs(500);
        await updateObjectAttributeBtn.click();
        await driver.delayMs(500);
        // 点击更新属性的属性
        await driver.assertComponentExist(ON.id('updateAttributeOfAttribute'));
        let updateAttributeOfAttributeBtn = await driver.findComponent(ON.id('updateAttributeOfAttribute'));
        await updateAttributeOfAttributeBtn.click();
        await driver.delayMs(500);
        await updateAttributeOfAttributeBtn.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 测试只更新所绑定的组件
       */
      it(BUNDLE + 'UpdateBindComponentFunction_001', 0, async function () {
        let testName = 'UpdateBindComponentFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入只更新所绑定的组件页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.only_update_bound_components'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.only_update_bound_components'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击更新对象
        await driver.assertComponentExist(ON.id('titleAndContentBtn'));
        let updateTitleAndContent = await driver.findComponent(ON.id('titleAndContentBtn'));
        await updateTitleAndContent.click();
        await driver.delayMs(500);
        await updateTitleAndContent.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 测试单、双向同步
       */
      it(BUNDLE + 'SingleBindFunction_001', 0, async function () {
        let testName = 'SingleBindFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入单双向同步页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.single_and_two_way_sync'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.single_and_two_way_sync'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击设置粉色
        await driver.assertComponentExist(ON.id('pinkColorBtn'));
        let pinkColorBtn = await driver.findComponent(ON.id('pinkColorBtn'));
        await pinkColorBtn.click();
        await driver.delayMs(500);
        // 设置蓝色
        await driver.assertComponentExist(ON.id('blueColorBtn'));
        let blueColorBtn = await driver.findComponent(ON.id('blueColorBtn'));
        await blueColorBtn.click();
        await driver.delayMs(500);
        // 设置红色
        await driver.assertComponentExist(ON.id('redColorBtn'));
        let redColorBtn = await driver.findComponent(ON.id('redColorBtn'));
        await redColorBtn.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      })

      /**
       * 测试子组件同步父组件的内容
       */
      it(BUNDLE + 'ChildParentFunction_001', 0, async function () {
        let testName = 'ChildParentFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入单双向同步页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.partial_sync'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.partial_sync'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击修改父组件第一个属性文本
        let inputMethodController = inputMethod.getController();
        await driver.assertComponentExist(ON.id('attribute1'));
        let attributeOne = await driver.findComponent(ON.id('attribute1'));
        await attributeOne.inputText('123');
        inputMethodController.stopInputSession();
        await driver.delayMs(500);
        // 点击修改子组件属性文本
        await driver.assertComponentExist(ON.id('childAttribute'));
        let childAttribute = await driver.findComponent(ON.id('childAttribute'));
        await childAttribute.click();
        await driver.delayMs(500);
        await childAttribute.inputText('321');
        inputMethodController.stopInputSession();
        await driver.delayMs(500);
        // 点击修改父组件第二个属性文本
        await driver.assertComponentExist(ON.id('arrayElement1'));
        let arrayElementOne = await driver.findComponent(ON.id('arrayElement1'));
        await arrayElementOne.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('attribute2'));
        let attributeTwo = await driver.findComponent(ON.id('attribute2'));
        await attributeTwo.inputText('456');
        inputMethodController.stopInputSession();
        await driver.delayMs(500);
        // 点击修改父组件第三个属性文本
        await driver.assertComponentExist(ON.id('arrayElement2'));
        let arrayElementTwo = await driver.findComponent(ON.id('arrayElement2'));
        await arrayElementTwo.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('attribute3'));
        let attributeThree = await driver.findComponent(ON.id('attribute3'));
        await attributeThree.click();
        await driver.delayMs(500);
        await attributeThree.inputText('789');
        inputMethodController.stopInputSession();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      })

      /**
       * 测试爷孙组件之间状态同步
       */
      it(BUNDLE + 'DeepBindFunction_001', 0, async function () {
        let testName = 'DeepBindFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入单双向同步页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.parent_descendent_sync'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.parent_descendent_sync'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击孙组件select组件并选择颜色
        await driver.assertComponentExist(ON.id('grandsonCompA'));
        let grandsonA = await driver.findComponent(ON.id('grandsonCompA'));
        await grandsonA.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        let selectedPink = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        await selectedPink.click();
        await driver.delayMs(500);
        // 点击爷组件select组件并选择颜色
        await driver.assertComponentExist(ON.id('grandfatherCompA'));
        let grandfatherCompA = await driver.findComponent(ON.id('grandfatherCompA'));
        await grandfatherCompA.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        let selectedBlueCompA = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        await selectedBlueCompA.click();
        await driver.delayMs(500);
        // 点击孙组件select组件并选择颜色
        await driver.assertComponentExist(ON.id('grandsonCompB'));
        let grandsonCompB = await driver.findComponent(ON.id('grandsonCompB'));
        await grandsonCompB.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        let selectedPinkCompB = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        await selectedPinkCompB.click();
        await driver.delayMs(500);
        // 点击爷组件select组件并选择颜色
        await driver.assertComponentExist(ON.id('grandfatherCompB'));
        let grandfatherCompB = await driver.findComponent(ON.id('grandfatherCompB'));
        await grandfatherCompB.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        let selectedBlueCompB = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        await selectedBlueCompB.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500)

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 测试兄弟组件之间状态同步
       */
      it(BUNDLE + 'BrotherBindFunction_001', 0, async function () {
        let testName = 'BrotherBindFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 进入单双向同步页面
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.brother_sync'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.brother_sync'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击子组件B中的select组件并选择颜色
        await driver.assertComponentExist(ON.id('linkSelectCompB'));
        let linkSelectCompB = await driver.findComponent(ON.id('linkSelectCompB'));
        await linkSelectCompB.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        let linkselectedPinkB = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        await linkselectedPinkB.click();
        await driver.delayMs(500);
        // 点击子组件B中的select组件并选择颜色
        await driver.assertComponentExist(ON.id('linkSelectCompA'));
        let linkSelectCompA = await driver.findComponent(ON.id('linkSelectCompA'));
        await linkSelectCompA.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        let linkselectedBlueA = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        await linkselectedBlueA.click();
        await driver.delayMs(500);
        // 点击子组件B中的select组件并选择颜色
        await driver.assertComponentExist(ON.id('consumeSelectCompB'));
        let consumeSelectCompB = await driver.findComponent(ON.id('consumeSelectCompB'));
        await consumeSelectCompB.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        let consumeSelectedPinkB = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorpink'))));
        await consumeSelectedPinkB.click();
        await driver.delayMs(500);
        // 点击子组件B中的select组件并选择颜色
        await driver.assertComponentExist(ON.id('consumeSelectCompA'));
        let consumeSelectCompA = await driver.findComponent(ON.id('consumeSelectCompA'));
        await consumeSelectCompA.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        let consumeSelectedBlueA = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.select_colorblue'))));
        await consumeSelectedBlueA.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 应用内全局数据与UI之间的状态同步
       */
      it(BUNDLE + 'GlobalSynFunction_001', 0, async function () {
        let testName = 'GlobalSynFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        // 切换到应用级状态变量
        await driver.assertComponentExist(ON.id('tabBar1'));
        let applyLeval = await driver.findComponent(ON.id('tabBar1'));
        await applyLeval.click();
        await driver.delayMs(500);
        // 进入应用内全局数据与UI之间的状态同步
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.application_storage_ui'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.application_storage_ui'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击Toggle组件，控制夜间模式
        await driver.assertComponentExist(ON.id('nightModeSwitch'));
        let nightModeSwitch = await driver.findComponent(ON.id('nightModeSwitch'));
        await nightModeSwitch.click();
        await driver.delayMs(500);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(320, 473, 420, 473, 800)
        await driver.delayMs(500);
        // 进入Ability1
        await driver.assertComponentExist(ON.id('enterAbilityOne'));
        let enterAbilityOne = await driver.findComponent(ON.id('enterAbilityOne'));
        await enterAbilityOne.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        // 进入Ability2
        await driver.assertComponentExist(ON.id('enterAbilityTwo'));
        let enterAbilityTwo = await driver.findComponent(ON.id('enterAbilityTwo'));
        await enterAbilityTwo.click();
        await driver.delayMs(500);
        // 返回
        await driver.pressBack();
        await driver.delayMs(500);
        // 再次进入Ability1
        await enterAbilityOne.click();
        await driver.delayMs(500);
        // 点击控制夜间模式按钮
        await driver.assertComponentExist(ON.id('nightModeSwitchTwo'));
        let nightModeSwitchTwo = await driver.findComponent(ON.id('nightModeSwitchTwo'));
        await nightModeSwitchTwo.click();
        await driver.delayMs(500);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(320, 745, 420, 745, 800)
        await driver.delayMs(500);
        // 返回首页
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入Ability2
        await enterAbilityTwo.click();
        await driver.delayMs(500);
        // 点击控制夜间模式按钮
        await driver.assertComponentExist(ON.id('nightModeSwitchThree'));
        let nightModeSwitchThree = await driver.findComponent(ON.id('nightModeSwitchThree'));
        await nightModeSwitchThree.click();
        await driver.delayMs(500);
        // 返回首页
        await driver.pressBack();
        await driver.delayMs(500);
        // 再次进入Ability1
        await enterAbilityOne.click();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);
        // 返回
        await driver.pressBack();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500)

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 应用内全局数据与UI之间的状态同步
       */
      it(BUNDLE + 'AbilitySynFunction_001', 0, async function () {
        let testName = 'AbilitySynFunction'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        let context = await abilityDelegatorRegistry.getAppContext();
        let manager = context.resourceManager;

        let driver: Driver = Driver.create();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.ability_storage_ui'))));
        let enterPageText = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.ability_storage_ui'))));
        await enterPageText.click();
        await driver.delayMs(500);
        // 点击Toggle组件，控制夜间模式
        await driver.assertComponentExist(ON.id('nightModeSwitch'));
        let nightModeSwitch = await driver.findComponent(ON.id('nightModeSwitch'));
        await nightModeSwitch.click();
        await driver.delayMs(500);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(320, 470, 420, 470, 800)
        await driver.delayMs(500);
        // 进入Page1
        await driver.assertComponentExist(ON.id('enterPageOne'));
        let enterPageOne = await driver.findComponent(ON.id('enterPageOne'));
        await enterPageOne.click();
        await driver.delayMs(500);
        // 返回
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        // 进入Page2
        await driver.assertComponentExist(ON.id('enterPageTwo'));
        let enterPageTwo = await driver.findComponent(ON.id('enterPageTwo'));
        await enterPageTwo.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入跨Ability页面
        await driver.assertComponentExist(ON.id('enterOutOfAbility'));
        let enterAbility = await driver.findComponent(ON.id('enterOutOfAbility'));
        await enterAbility.click();
        await driver.delayMs(500);
        // 返回
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入Page1
        await enterPageOne.click();
        await driver.delayMs(500);
        // 点击控制夜间模式按钮
        await driver.assertComponentExist(ON.id('nightModeSwitchTwo'));
        let nightModeSwitchTwo = await driver.findComponent(ON.id('nightModeSwitchTwo'));
        await nightModeSwitchTwo.click();
        await driver.delayMs(500);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(320, 745, 380, 745, 800)
        await driver.delayMs(500);
        // 返回首页
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入Ability
        await enterAbility.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入Page2
        await enterPageTwo.click();
        await driver.delayMs(500);
        // 点击控制夜间模式按钮
        await driver.assertComponentExist(ON.id('nightModeSwitchThree'));
        let nightModeSwitchThree = await driver.findComponent(ON.id('nightModeSwitchThree'));
        await nightModeSwitchThree.click();
        await driver.delayMs(500);
        // 返回首页
        await driver.pressBack();
        await driver.delayMs(500);
        // 再次进入Page1
        await enterPageOne.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 再次进入Ability
        await enterAbility.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('nightModeSwitchFour'));
        let nightModeSwitchFour = await driver.findComponent(ON.id('nightModeSwitchFour'));
        await nightModeSwitchFour.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 再次进入Page1
        await enterPageOne.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 进入Page2
        await enterPageTwo.click();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
        // 展示源码
        await driver.assertComponentExist(ON.id('viewSourceCode'));
        let viewSourceCode = await driver.findComponent(ON.id('viewSourceCode'));
        await viewSourceCode.click();
        await driver.delayMs(500);
        // 关闭web源码
        await driver.assertComponentExist(ON.id('close'));
        let closeWebBtn = await driver.findComponent(ON.id('close'));
        await closeWebBtn.click();
        await driver.delayMs(500);

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      Logger.info("Sample_StateManagement test end")
    })
  })
}