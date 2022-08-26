/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import hilog from '@ohos.hilog'

const TAG = '[Sample_AdaptiveCapabilities]'
const DOMAIN = 0xF811
const BUNDLE = 'AdaptiveCapabilities_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.etsadaptivecapabilities",
        abilityName: "MainAbility"
      }
      globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击资源限定词，展示字符串和图片资源
     */
    it(BUNDLE + 'ClickResourceQualifierFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResourceQualifierFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResourceQualifierFunction_001 clickResourceQualifierBtn')
      // 点击资源限定词
      await driver.assertComponentExist(BY.text('资源限定词', MatchPattern.CONTAINS))
      let resourceQualifier = await driver.findComponent(BY.text('资源限定词', MatchPattern.CONTAINS))
      await resourceQualifier.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResourceQualifierFunction_001 end')
    })
    /**
     * 点击原子布局能力，展示原子布局的各项能力
     */
    it(BUNDLE + 'ClickAtomicLayoutFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickAtomicLayoutBtn')
      // 点击原子布局能力
      await driver.assertComponentExist(BY.text('原子布局能力', MatchPattern.CONTAINS))
      let atomicLayout = await driver.findComponent(BY.text('原子布局能力', MatchPattern.CONTAINS))
      await atomicLayout.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickFlexCapabilityFirstBtn')
      // 点击拉伸能力1
      await driver.assertComponentExist(BY.text('拉伸能力1', MatchPattern.CONTAINS))
      let flexCapabilityFirst = await driver.findComponent(BY.text('拉伸能力1', MatchPattern.CONTAINS))
      await flexCapabilityFirst.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickFlexCapabilitySecondBtn')
      // 点击拉伸能力2
      await driver.assertComponentExist(BY.text('拉伸能力2', MatchPattern.CONTAINS))
      let flexCapabilitySecond = await driver.findComponent(BY.text('拉伸能力2', MatchPattern.CONTAINS))
      await flexCapabilitySecond.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickScalingCapabilityBtn')
      // 点击缩放能力
      await driver.assertComponentExist(BY.text('缩放能力', MatchPattern.CONTAINS))
      let scalingCapability = await driver.findComponent(BY.text('缩放能力', MatchPattern.CONTAINS))
      await scalingCapability.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickHiddenCapabilityBtn')
      // 点击隐藏能力
      await driver.assertComponentExist(BY.text('隐藏能力', MatchPattern.CONTAINS))
      let hiddenCapability = await driver.findComponent(BY.text('隐藏能力', MatchPattern.CONTAINS))
      await hiddenCapability.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickWrapCapabilityBtn')
      // 点击折行能力
      await driver.assertComponentExist(BY.text('折行能力', MatchPattern.CONTAINS))
      let wrapCapability = await driver.findComponent(BY.text('折行能力', MatchPattern.CONTAINS))
      await wrapCapability.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickEquallyCapabilityBtn')
      // 点击均分能力
      await driver.assertComponentExist(BY.text('均分能力', MatchPattern.CONTAINS))
      let equallyCapability = await driver.findComponent(BY.text('均分能力', MatchPattern.CONTAINS))
      await equallyCapability.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickPercentageCapabilityBtn')
      // 点击占比能力
      await driver.assertComponentExist(BY.text('占比能力', MatchPattern.CONTAINS))
      let percentageCapability = await driver.findComponent(BY.text('占比能力', MatchPattern.CONTAINS))
      await percentageCapability.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 clickExtensionCapabilityFirstBtn')
      // 点击延伸能力1
      await driver.assertComponentExist(BY.text('延伸能力1', MatchPattern.CONTAINS))
      let extensionCapabilityFirst = await driver.findComponent(BY.text('延伸能力1', MatchPattern.CONTAINS))
      await extensionCapabilityFirst.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAtomicLayoutFunction_001 end')
    })
    /**
     * 点击响应式布局，展示媒体查询、栅格布局、典型场景三类响应式布局能力
     */
    it(BUNDLE + 'ClickResponsiveLayoutFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickResponsiveLayoutBtn')
      // 点击响应式布局
      await driver.assertComponentExist(BY.text('响应式布局', MatchPattern.CONTAINS))
      let responsiveLayout = await driver.findComponent(BY.text('响应式布局', MatchPattern.CONTAINS))
      await responsiveLayout.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickMediaQueryBtn')
      // 点击媒体查询
      await driver.assertComponentExist(BY.text('媒体查询', MatchPattern.CONTAINS))
      let mediaQuery = await driver.findComponent(BY.text('媒体查询', MatchPattern.CONTAINS))
      await mediaQuery.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickGridLayoutBtn')
      // 点击栅格布局
      await driver.assertComponentExist(BY.text('栅格布局', MatchPattern.CONTAINS))
      let gridLayout = await driver.findComponent(BY.text('栅格布局', MatchPattern.CONTAINS))
      await gridLayout.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickTypicalSceneBtn')
      // 点击典型场景
      await driver.assertComponentExist(BY.text('典型场景', MatchPattern.CONTAINS))
      let typicalScene = await driver.findComponent(BY.text('典型场景', MatchPattern.CONTAINS))
      await typicalScene.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickMoveLayoutBtn')
      // 点击挪移布局
      await driver.assertComponentExist(BY.text('挪移布局', MatchPattern.CONTAINS))
      let moveLayout = await driver.findComponent(BY.text('挪移布局', MatchPattern.CONTAINS))
      await moveLayout.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickRepeatLayoutBtn')
      // 点击重复布局
      await driver.assertComponentExist(BY.text('重复布局', MatchPattern.CONTAINS))
      let repeatLayout = await driver.findComponent(BY.text('重复布局', MatchPattern.CONTAINS))
      await repeatLayout.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 clickIndentLayoutBtn')
      // 点击缩进布局
      await driver.assertComponentExist(BY.text('缩进布局', MatchPattern.CONTAINS))
      let indentLayout = await driver.findComponent(BY.text('缩进布局', MatchPattern.CONTAINS))
      await indentLayout.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResponsiveLayoutFunction_001 end')
    })
  })
}