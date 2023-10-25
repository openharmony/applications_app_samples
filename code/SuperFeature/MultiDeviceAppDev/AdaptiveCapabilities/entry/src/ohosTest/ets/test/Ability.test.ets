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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'
import resmgr from '@ohos.resourceManager';

const TAG = '[Sample_AdaptiveCapabilities]'
const DOMAIN = 0xF811
const BUNDLE = 'AdaptiveCapabilities_'

let driver: Driver = Driver.create()
//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let idName = text
  await driver.assertComponentExist(ON.id(idName))
  let button = await driver.findComponent(ON.id(idName))
  await button.click()
  await driver.delayMs(1000)
}
//通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let textName = text
  await driver.assertComponentExist(ON.text(textName))
  let button = await driver.findComponent(ON.text(textName))
  await button.click()
  await driver.delayMs(1000)
}

// 获取AbilityDelegator
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
// 启动后获取app上下文
let context: Context;
// 启动后获取resourceManager
let manager: resmgr.ResourceManager;

async function checkRadioAndClickWithID(text: string) {
  await driver.assertComponentExist(ON.id(text));
  let component = await driver.findComponent(ON.id(text));
  await component.click();
}

async function checkRadioAndClickWithText(text: string) {
  await driver.assertComponentExist(ON.text(text));
  let component = await driver.findComponent(ON.text(text));
  await component.click();
}

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function appTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001 begin', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.AdaptiveCapabilities',
          abilityName: 'MainAbility'
        });
        context = abilityDelegatorRegistry.getAppContext();
        manager = context.resourceManager;
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 自适应布局 (目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesOneFunction_001', 0, async  ()=> {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesOneFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击自适应布局
      await checkButtonAndClickWithID('AtomicLayoutCapabilityIndex')
      // 点击拉伸能力1
      await checkButtonAndClickWithID('FlexibleCapability1')
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击拉伸能力2
      await checkButtonAndClickWithID('FlexibleCapability2')
      // 打开switch
      await driver.assertComponentExist(ON.type('Toggle'))
      let toggle = await driver.findComponent(ON.type('Toggle'))
      await toggle.click()
      await driver.delayMs(1000)
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击缩放能力
      await checkButtonAndClickWithID('ScaleCapability')
      // slider1滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      // slider2滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击隐藏能力
      await checkButtonAndClickWithID('HiddenCapability')
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击折行能力
      await checkButtonAndClickWithID('WrapCapability')
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击均分能力
      await checkButtonAndClickWithID('EquipartitionCapability')
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 向下滑动
      await driver.swipe(100, 500, 20, 20)
      await driver.delayMs(1000)
      // 点击占比能力
      await checkButtonAndClickWithID('ProportionCapability')
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击延伸能力1
      await checkButtonAndClickWithID('ExtensionCapability1')
      // scroll 应用滑动
      await driver.swipe(360, 639, 0, 639, 200)
      await driver.delayMs(1000)
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击延伸能力2
      await checkButtonAndClickWithID('ExtensionCapability2')
      // scroll 应用滑动
      await driver.swipe(360, 639, 0, 639, 200)
      await driver.delayMs(1000)
      // slider滑动
      await driver.swipe(410, 1017, 360, 1017, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesOneFunction_001 end')
    })

    /**
     * 响应式布局 (目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesTwoFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesTwoFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击响应式布局
      await checkButtonAndClickWithID('ResponsiveLayoutIndex')
      // 点击断点
      await checkButtonAndClickWithID('BreakpointSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击媒体查询
      await checkButtonAndClickWithID('MediaQuerySample')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格布局
      await checkButtonAndClickWithID('GridRowLayoutIndex')
      // 点击栅格断点1
      await checkButtonAndClickWithID('GridRowSample1')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格断点2
      await checkButtonAndClickWithID('GridRowSample2')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格columns和gutter
      await checkButtonAndClickWithID('GridRowSample3')
      let checkBtn = await driver.findComponent(ON.type('GridCol'));
      await checkBtn.click();
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格margin
      await checkButtonAndClickWithID('GridRowSample4')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格span
      await checkButtonAndClickWithID('GridRowSample5')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格offset
      await checkButtonAndClickWithID('GridRowSample6')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格order
      await checkButtonAndClickWithID('GridRowSample7')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 向下滑动
      await driver.swipe(100, 500, 20, 20)
      await driver.delayMs(1000)
      // 点击栅格span/offset/order继承性
      await checkButtonAndClickWithID('GridRowSample8')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格嵌套
      await checkButtonAndClickWithID('GridRowSample9')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击栅格对齐
      await checkButtonAndClickWithID('GridRowSample10');
      await checkRadioAndClickWithID('rdo11');
      await checkRadioAndClickWithID('rdo22');
      await checkRadioAndClickWithID('rdo33');
      await checkRadioAndClickWithID('rdo41');
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesTwoFunction_001 end')
    })

    /**
     * 典型布局场景 (目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesThreeFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesThreeFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击典型布局场景
      await checkButtonAndClickWithID('TypicalSceneIndex')
      // 点击挪移布局
      await checkButtonAndClickWithID('DiversionSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击重复布局
      await checkButtonAndClickWithID('RepeatSample')
      // scroll 滑动
      await driver.swipe(360, 640, 360, 0, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击缩进布局
      await checkButtonAndClickWithID('IndentationSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击顶部布局
      await checkButtonAndClickWithID('HeaderSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击广告栏
      await checkButtonAndClickWithID('BannerSample')
      // swiper滑动
      await driver.swipe(360, 222, 0, 222, 1000)
      await driver.swipe(360, 222, 0, 222, 1000)
      await driver.swipe(360, 222, 0, 222, 1000)
      await driver.swipe(360, 222, 0, 222, 1000)
      await driver.swipe(360, 222, 0, 222, 1000)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击操作入口
      await checkButtonAndClickWithID('OperationEntriesSample')
      await driver.swipe(360, 150, 0, 150, 200)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 向下滑动
      await driver.swipe(100, 500, 20, 20)
      await driver.delayMs(1000)
      // 点击页签布局
      await checkButtonAndClickWithID('TabsSample')
      // 点击排行榜
      await checkButtonAndClickWithText(await getResourceString($r('app.string.tabBar2')))
      // 点击我的
      await checkButtonAndClickWithText(await getResourceString($r('app.string.tabBar3')))
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击大图浏览
      await checkButtonAndClickWithID('BigImageSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击多列列表
      await checkButtonAndClickWithID('MultiLaneListSample')
      // 向下滑动
      await driver.swipe(100, 500, 20, 20)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击网格视图
      await checkButtonAndClickWithID('ResponsiveGridSample')
      // 向下滑动
      await driver.swipe(100, 500, 20, 20)
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      // 点击侧边栏
      await checkButtonAndClickWithID('SidebarSample')
      await driver.pressBack()
      await driver.delayMs(1000)
      //向下下滑
      await driver.swipe(360, 900, 360, 200, 2000)
      //点击一多典型场景
      await checkButtonAndClickWithID('multiScene')
      //上下滑动list
      await driver.swipe(360, 1100, 360, 900, 200)
      //左右滑动swiper
      await driver.swipe(700, 300, 20, 300, 1000)
      await checkButtonAndClickWithText(await getResourceString($r('app.string.multiScene_tabs_app')))
      //上下滑动应用列表
      await driver.swipe(360, 1100, 360, 900, 200)
      await checkButtonAndClickWithText(await getResourceString($r('app.string.multiScene_tabs_play')))
      await checkButtonAndClickWithText(await getResourceString($r('app.string.multiScene_tabs_me')))
      await driver.swipe(20, 300, 700, 300, 1000)
      await driver.swipe(20, 300, 700, 300, 1000)
      await driver.swipe(20, 300, 700, 300, 1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesThreeFunction_001 end')
    })

    /**
     * 资源文件使用
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击资源文件使用
      await checkButtonAndClickWithID('ResourceQualifier')
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001 end')
    })

    /**
     * 交互归一能力
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesFiveFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFiveFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击交互归一能力
      await checkButtonAndClickWithID('InteractionNormCapability')
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFiveFunction_001 end')
    })
  })
}

