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

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function appTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001 begin', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.AdaptiveCapabilities",
          abilityName: "MainAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 自适应布局 (目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesOneFunction_001', 0, async function () {
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
    it(BUNDLE + 'CreateAdaptiveCapabilitiesTwoFunction_001', 0, async function () {
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
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesTwoFunction_001 end')
    })

    /**
     * 典型布局场景 (目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesThreeFunction_001', 0, async function () {
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
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesThreeFunction_001 end')
    })

    /**
     * 资源文件使用
     */
    it(BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击资源文件使用
      await checkButtonAndClickWithID('ResourceQualifier')
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateAdaptiveCapabilitiesFourFunction_001 end')
    })
  })
}

