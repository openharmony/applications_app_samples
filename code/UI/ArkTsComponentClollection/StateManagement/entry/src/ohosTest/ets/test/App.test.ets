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

import { describe, it, } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../utils/Logger';

const BUNDLE = 'StateManagement';
const TAG = 'AppTestPage';

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + '_startAbility', 0, async function (done) {
      Logger.info(TAG, '_startAbility start')
      let want = {
        bundleName: "com.samples.statemanagement",
        abilityName: "EntryAbility"
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, '_startAbility end');
      })
    })
    /**
     * TarBar操作
     */
    it(`${BUNDLE}_tabbar`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 切换到应用级状态变量
      await driver.assertComponentExist(ON.id('tabBar1'));
      let applyLeval: Component = await driver.findComponent(ON.id('tabBar1'));
      await applyLeval.click();
      await driver.delayMs(500);
      // 切换到页面级状态变量
      await driver.assertComponentExist(ON.id('tabBar0'));
      let pageLeval: Component = await driver.findComponent(ON.id('tabBar0'));
      await pageLeval.click();
      await driver.delayMs(500);
    });
    /**
     * 打开折叠层
     */
    it(`${BUNDLE}_foldedlayer`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 打开修饰对象模块的折叠
      await driver.assertComponentExist(ON.id('secondLevelMenu00'));
      let decoratedOject: Component = await driver.findComponent(ON.id('secondLevelMenu00'));
      await decoratedOject.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('secondLevelMenu01'));
      let updatedBound: Component = await driver.findComponent(ON.id('secondLevelMenu01'));
      await updatedBound.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('secondLevelMenu10'));
      let multiComponentsSync: Component = await driver.findComponent(ON.id('secondLevelMenu10'));
      await multiComponentsSync.click();
      await driver.delayMs(500);
    });
    /**
     * 基础类型
     */
    it(`${BUNDLE}_baseType`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入基础类型页面
      await driver.assertComponentExist(ON.text('基础类型'));
      let enterPage: Component = await driver.findComponent(ON.text('基础类型'));
      await enterPage.click();
      await driver.delayMs(500);
      // 设置圆形颜色
      await driver.assertComponentExist(ON.id('circleColorBtn'));
      let setCircleColor: Component = await driver.findComponent(ON.id('circleColorBtn'));
      await setCircleColor.click();
      await driver.delayMs(500);
      // 再次设置圆形颜色
      await setCircleColor.click();
      await driver.delayMs(500);
      // 查看源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    });
    /**
     * 数组类型
     */
    it(`${BUNDLE}_arrayType`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入数组类型页面
      await driver.assertComponentExist(ON.text('数组类型'));
      let enterPage: Component = await driver.findComponent(ON.text('数组类型'));
      await enterPage.click();
      await driver.delayMs(500);
      // 点击删除元素
      await driver.assertComponentExist(ON.id('arrayTypeBtn1'));
      let arrayTypeDeleteBtn: Component = await driver.findComponent(ON.id('arrayTypeBtn1'));
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
      let arrayTypeAddBtn: Component = await driver.findComponent(ON.id('arrayTypeBtn0'));
      await arrayTypeAddBtn.click();
      await driver.delayMs(500);
      // 点击更新元素
      await driver.assertComponentExist(ON.id('arrayTypeBtn2'));
      let arrayTypeUpdateBtn: Component = await driver.findComponent(ON.id('arrayTypeBtn2'));
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
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    })
    /**
     * 类对象类型
     */
    it(`${BUNDLE}_objectType`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入类对象类型页面
      await driver.assertComponentExist(ON.text('类对象类型'));
      let enterPageText: Component = await driver.findComponent(ON.text('类对象类型'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击更新对象
      await driver.assertComponentExist(ON.id('updateObject'));
      let updateObjectBtn: Component = await driver.findComponent(ON.id('updateObject'));
      await updateObjectBtn.click();
      await driver.delayMs(500);
      await updateObjectBtn.click();
      await driver.delayMs(500);
      // 点击更新对象属性
      await driver.assertComponentExist(ON.id('updateObjectAttribute'));
      let updateObjectAttributeBtn: Component = await driver.findComponent(ON.id('updateObjectAttribute'));
      await updateObjectAttributeBtn.click();
      await driver.delayMs(500);
      await updateObjectAttributeBtn.click();
      await driver.delayMs(500);
      // 点击更新属性的属性
      await driver.assertComponentExist(ON.id('updateAttributeOfAttribute'));
      let updateAttributeOfAttributeBtn: Component = await driver.findComponent(ON.id('updateAttributeOfAttribute'));
      await updateAttributeOfAttributeBtn.click();
      await driver.delayMs(500);
      await updateAttributeOfAttributeBtn.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    });
    /**
     * 只更新所绑定的组件
     */
    it(`${BUNDLE}_updateBoundComponent`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入只更新所绑定的组件页面
      await driver.assertComponentExist(ON.text('只更新所绑定的组件'));
      let enterPageText: Component = await driver.findComponent(ON.text('只更新所绑定的组件'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击更新对象
      await driver.assertComponentExist(ON.id('titleAndContentBtn'));
      let updateTitleAndContent: Component = await driver.findComponent(ON.id('titleAndContentBtn'));
      await updateTitleAndContent.click();
      await driver.delayMs(500);
      await updateTitleAndContent.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    });
    /**
     * 单、双向同步
     */
    it(`${BUNDLE}_uniandbiDirectionSync`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入单双向同步页面
      await driver.assertComponentExist(ON.text('单、双向同步'));
      let enterPageText: Component = await driver.findComponent(ON.text('单、双向同步'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击设置粉色
      await driver.assertComponentExist(ON.id('pinkColorBtn'));
      let pinkColorBtn: Component = await driver.findComponent(ON.id('pinkColorBtn'));
      await pinkColorBtn.click();
      await driver.delayMs(500);
      // 设置蓝色
      await driver.assertComponentExist(ON.id('blueColorBtn'));
      let blueColorBtn: Component = await driver.findComponent(ON.id('blueColorBtn'));
      await blueColorBtn.click();
      await driver.delayMs(500);
      // 设置红色
      await driver.assertComponentExist(ON.id('redColorBtn'));
      let redColorBtn: Component = await driver.findComponent(ON.id('redColorBtn'));
      await redColorBtn.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    })
    /**
     * 子组件同步父组件的内容
     */
    it(`${BUNDLE}_parentChildPartialContentSync`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入单双向同步页面
      await driver.assertComponentExist(ON.text('子组件同步父组件部分内容'));
      let enterPageText: Component = await driver.findComponent(ON.text('子组件同步父组件部分内容'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击修改父组件第一个属性文本
      await driver.assertComponentExist(ON.id('attribute1'));
      let attributeOne: Component = await driver.findComponent(ON.id('attribute1'));
      await attributeOne.inputText('123');
      await driver.delayMs(500);
      // 点击修改子组件属性文本
      await driver.assertComponentExist(ON.id('childAttribute'));
      let childAttribute: Component = await driver.findComponent(ON.id('childAttribute'));
      await childAttribute.click();
      await driver.delayMs(500);
      await childAttribute.inputText('321');
      await driver.delayMs(500);
      // 点击修改父组件第二个属性文本
      await driver.assertComponentExist(ON.id('arrayElement1'));
      let arrayElementOne: Component = await driver.findComponent(ON.id('arrayElement1'));
      await arrayElementOne.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('attribute2'));
      let attributeTwo: Component = await driver.findComponent(ON.id('attribute2'));
      await attributeTwo.inputText('456');
      await driver.delayMs(500);
      // 点击修改父组件第三个属性文本
      await driver.assertComponentExist(ON.id('arrayElement2'));
      let arrayElementTwo: Component = await driver.findComponent(ON.id('arrayElement2'));
      await arrayElementTwo.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('attribute3'));
      let attributeThree: Component = await driver.findComponent(ON.id('attribute3'));
      await attributeThree.click();
      await driver.delayMs(500);
      await attributeThree.inputText('789');
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    })
    /**
     * 爷孙组件之间状态同步
     */
    it(`${BUNDLE}_deepNestComponentsSync`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入单双向同步页面
      await driver.assertComponentExist(ON.text('爷孙组件之间状态同步'));
      let enterPageText: Component = await driver.findComponent(ON.text('爷孙组件之间状态同步'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击孙组件select组件并选择颜色
      await driver.assertComponentExist(ON.id('grandsonCompA'));
      let grandsonA: Component = await driver.findComponent(ON.id('grandsonCompA'));
      await grandsonA.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('粉色'));
      let selectedPink: Component = await driver.findComponent(ON.text('粉色'));
      await selectedPink.click();
      await driver.delayMs(500);
      // 点击爷组件select组件并选择颜色
      await driver.assertComponentExist(ON.id('grandfatherCompA'));
      let grandfatherCompA: Component = await driver.findComponent(ON.id('grandfatherCompA'));
      await grandfatherCompA.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('蓝色'));
      let selectedBlueCompA: Component = await driver.findComponent(ON.text('蓝色'));
      await selectedBlueCompA.click();
      await driver.delayMs(500);
      // 点击孙组件select组件并选择颜色
      await driver.assertComponentExist(ON.id('grandsonCompB'));
      let grandsonCompB: Component = await driver.findComponent(ON.id('grandsonCompB'));
      await grandsonCompB.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('粉色'));
      let selectedPinkCompB: Component = await driver.findComponent(ON.text('粉色'));
      await selectedPinkCompB.click();
      await driver.delayMs(500);
      // 点击爷组件select组件并选择颜色
      await driver.assertComponentExist(ON.id('grandfatherCompB'));
      let grandfatherCompB: Component = await driver.findComponent(ON.id('grandfatherCompB'));
      await grandfatherCompB.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('蓝色'));
      let selectedBlueCompB: Component = await driver.findComponent(ON.text('蓝色'));
      await selectedBlueCompB.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    });
    /**
     * 兄弟组件之间状态同步
     */
    it(`${BUNDLE}_brotherComponentSync`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入单双向同步页面
      await driver.assertComponentExist(ON.text('兄弟组件之间状态同步'));
      let enterPageText: Component = await driver.findComponent(ON.text('兄弟组件之间状态同步'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击子组件B中的select组件并选择颜色
      await driver.assertComponentExist(ON.id('linkSelectCompB'));
      let linkSelectCompB: Component = await driver.findComponent(ON.id('linkSelectCompB'));
      await linkSelectCompB.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('粉色'));
      let linkselectedPinkB: Component = await driver.findComponent(ON.text('粉色'));
      await linkselectedPinkB.click();
      await driver.delayMs(500);
      // 点击子组件B中的select组件并选择颜色
      await driver.assertComponentExist(ON.id('linkSelectCompA'));
      let linkSelectCompA: Component = await driver.findComponent(ON.id('linkSelectCompA'));
      await linkSelectCompA.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('蓝色'));
      let linkselectedBlueA: Component = await driver.findComponent(ON.text('蓝色'));
      await linkselectedBlueA.click();
      await driver.delayMs(500);
      // 点击子组件B中的select组件并选择颜色
      await driver.assertComponentExist(ON.id('consumeSelectCompB'));
      let consumeSelectCompB: Component = await driver.findComponent(ON.id('consumeSelectCompB'));
      await consumeSelectCompB.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('粉色'));
      let consumeSelectedPinkB: Component = await driver.findComponent(ON.text('粉色'));
      await consumeSelectedPinkB.click();
      await driver.delayMs(500);
      // 点击子组件B中的select组件并选择颜色
      await driver.assertComponentExist(ON.id('consumeSelectCompA'));
      let consumeSelectCompA: Component = await driver.findComponent(ON.id('consumeSelectCompA'));
      await consumeSelectCompA.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('蓝色'));
      let consumeSelectedBlueA: Component = await driver.findComponent(ON.text('蓝色'));
      await consumeSelectedBlueA.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
    });
  /**
   * 应用内全局数据与UI之间的状态同步
   */
  it(`${BUNDLE}_applyGlobalDataSync`, 0, async () => {
    let driver: Driver = Driver.create();
    await driver.delayMs(500);
    // 切换到应用级状态变量
    await driver.assertComponentExist(ON.id('tabBar1'));
    let applyLeval: Component = await driver.findComponent(ON.id('tabBar1'));
    await applyLeval.click();
    await driver.delayMs(500);
    // 进入应用内全局数据与UI之间的状态同步
    await driver.assertComponentExist(ON.text('应用内全局数据与UI之间的状态同步'));
    let enterPageText: Component = await driver.findComponent(ON.text('应用内全局数据与UI之间的状态同步'));
    await enterPageText.click();
    await driver.delayMs(500);
    // 点击Toggle组件，控制夜间模式
    await driver.assertComponentExist(ON.id('nightModeSwitch'));
    let nightModeSwitch: Component = await driver.findComponent(ON.id('nightModeSwitch'));
    await nightModeSwitch.click();
    await driver.delayMs(500);
    await driver.drag(320,473,420,473,800)
    await driver.delayMs(500);
    // 进入Ability1
    await driver.assertComponentExist(ON.id('enterAbilityOne'));
    let enterAbilityOne: Component = await driver.findComponent(ON.id('enterAbilityOne'));
    await enterAbilityOne.click();
    await driver.delayMs(500);
    // 返回
    await driver.assertComponentExist(ON.id('backBtn'));
    let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
    await backBtn.click();
    await driver.delayMs(500);
    // 进入Ability2
    await driver.assertComponentExist(ON.id('enterAbilityTwo'));
    let enterAbilityTwo: Component = await driver.findComponent(ON.id('enterAbilityTwo'));
    await enterAbilityTwo.click();
    await driver.delayMs(500);
    // 返回
    await backBtn.click();
    await driver.delayMs(500);
    // 再次进入Ability1
    await enterAbilityOne.click();
    await driver.delayMs(500);
    // 点击控制夜间模式按钮
    await driver.assertComponentExist(ON.id('nightModeSwitchTwo'));
    let nightModeSwitchTwo: Component = await driver.findComponent(ON.id('nightModeSwitchTwo'));
    await nightModeSwitchTwo.click();
    await driver.delayMs(500);
    await driver.drag(320,745,420,745,800)
    await driver.delayMs(500);
    // 返回首页
    await backBtn.click();
    await driver.delayMs(500);
    // 进入Ability2
    await enterAbilityTwo.click();
    await driver.delayMs(500);
    // 点击控制夜间模式按钮
    await driver.assertComponentExist(ON.id('nightModeSwitchThree'));
    let nightModeSwitchThree: Component = await driver.findComponent(ON.id('nightModeSwitchThree'));
    await nightModeSwitchThree.click();
    await driver.delayMs(500);
    // 返回首页
    await backBtn.click();
    await driver.delayMs(500);
    // 再次进入Ability1
    await enterAbilityOne.click();
    await driver.delayMs(500);
    // 展示源码
    await driver.assertComponentExist(ON.id('viewSourceCode'));
    let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
    await viewSourceCode.click();
    await driver.delayMs(500);
    // 关闭web源码
    await driver.assertComponentExist(ON.id('close'));
    let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
    await closeWebBtn.click();
    await driver.delayMs(500);
    // 返回
    await backBtn.click();
    await driver.delayMs(500);
    await backBtn.click();
    await driver.delayMs(500);
  });
    /**
     * 应用内全局数据与UI之间的状态同步
     */
    it(`${BUNDLE}_abilityGlobalDataSync`, 0, async () => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('Ability内全局数据与UI之间的状态同步'));
      let enterPageText: Component = await driver.findComponent(ON.text('Ability内全局数据与UI之间的状态同步'));
      await enterPageText.click();
      await driver.delayMs(500);
      // 点击Toggle组件，控制夜间模式
      await driver.assertComponentExist(ON.id('nightModeSwitch'));
      let nightModeSwitch: Component = await driver.findComponent(ON.id('nightModeSwitch'));
      await nightModeSwitch.click();
      await driver.delayMs(500);
      await driver.drag(320,470,420,470,800)
      await driver.delayMs(500);
      // 进入Page1
      await driver.assertComponentExist(ON.id('enterPageOne'));
      let enterPageOne: Component = await driver.findComponent(ON.id('enterPageOne'));
      await enterPageOne.click();
      await driver.delayMs(500);
      // 返回
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn: Component = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
      // 进入Page2
      await driver.assertComponentExist(ON.id('enterPageTwo'));
      let enterPageTwo: Component = await driver.findComponent(ON.id('enterPageTwo'));
      await enterPageTwo.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 进入跨Ability页面
      await driver.assertComponentExist(ON.id('enterOutOfAbility'));
      let enterAbility: Component = await driver.findComponent(ON.id('enterOutOfAbility'));
      await enterAbility.click();
      await driver.delayMs(500);
      // 返回
      await backBtn.click();
      await driver.delayMs(500);
      // 进入Page1
      await enterPageOne.click();
      await driver.delayMs(500);
      // 点击控制夜间模式按钮
      await driver.assertComponentExist(ON.id('nightModeSwitchTwo'));
      let nightModeSwitchTwo: Component = await driver.findComponent(ON.id('nightModeSwitchTwo'));
      await nightModeSwitchTwo.click();
      await driver.delayMs(500);
      await driver.drag(320,745,380,745,800)
      await driver.delayMs(500);
      // 返回首页
      await backBtn.click();
      await driver.delayMs(500);
      // 进入Ability
      await enterAbility.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 进入Page2
      await enterPageTwo.click();
      await driver.delayMs(500);
      // 点击控制夜间模式按钮
      await driver.assertComponentExist(ON.id('nightModeSwitchThree'));
      let nightModeSwitchThree: Component = await driver.findComponent(ON.id('nightModeSwitchThree'));
      await nightModeSwitchThree.click();
      await driver.delayMs(500);
      // 返回首页
      await backBtn.click();
      await driver.delayMs(500);
      // 再次进入Page1
      await enterPageOne.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 再次进入Ability
      await enterAbility.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('nightModeSwitchFour'));
      let nightModeSwitchFour: Component = await driver.findComponent(ON.id('nightModeSwitchFour'));
      await nightModeSwitchFour.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 再次进入Page1
      await enterPageOne.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 进入Page2
      await enterPageTwo.click();
      await driver.delayMs(500);
      await backBtn.click();
      await driver.delayMs(500);
      // 展示源码
      await driver.assertComponentExist(ON.id('viewSourceCode'));
      let viewSourceCode: Component = await driver.findComponent(ON.id('viewSourceCode'));
      await viewSourceCode.click();
      await driver.delayMs(500);
      // 关闭web源码
      await driver.assertComponentExist(ON.id('close'));
      let closeWebBtn: Component = await driver.findComponent(ON.id('close'));
      await closeWebBtn.click();
      await driver.delayMs(500);
    });
  })
}
