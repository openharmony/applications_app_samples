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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_TransitionAnimation]'
const DOMAIN = 0xF811
const BUNDLE = 'TransitionAnimation_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.transitionanimation",
        abilityName: "MainAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 页面间转场：底部滑入
     */
    it(BUNDLE + 'PageTransitionBottomFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionBottomFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // PageTransitionBottom
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionBottomFunction_001 PageTransitionBottom')
      await driver.assertComponentExist(BY.text('底部滑入', MatchPattern.CONTAINS))
      let bottom = await driver.findComponent(BY.text('底部滑入', MatchPattern.CONTAINS))
      await bottom.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionBottomFunction_001 back')
      await driver.assertComponentExist(BY.key('backImg'))
      let backImg = await driver.findComponent(BY.key('backImg'))
      await backImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionBottomFunction_001 end')
    })

    /**
     * 页面间转场：自定义1
     */
    it(BUNDLE + 'PageTransitionCustomFirstFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomFirstFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // PageTransitionCustomFirst
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomFirstFunction_001 PageTransitionCustomFirst')
      await driver.assertComponentExist(BY.text('自定义1', MatchPattern.CONTAINS))
      let customFirst = await driver.findComponent(BY.text('自定义1', MatchPattern.CONTAINS))
      await customFirst.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomFirstFunction_001 back')
      await driver.assertComponentExist(BY.key('backImg'))
      let backImg = await driver.findComponent(BY.key('backImg'))
      await backImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomFirstFunction_001 end')
    })

    /**
     * 页面间转场：自定义2
     */
    it(BUNDLE + 'PageTransitionCustomSecondFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomSecondFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // PageTransitionCustomFirst
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomSecondFunction_001 PageTransitionCustomFirst')
      await driver.assertComponentExist(BY.text('自定义2', MatchPattern.CONTAINS))
      let customSecond = await driver.findComponent(BY.text('自定义2', MatchPattern.CONTAINS))
      await customSecond.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomSecondFunction_001 back')
      await driver.assertComponentExist(BY.key('backImg'))
      let backImg = await driver.findComponent(BY.key('backImg'))
      await backImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTransitionCustomSecondFunction_001 end')
    })

    /**
     * 组件内转场
     */
    it(BUNDLE + 'ComponentTransitionFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // ComponentTransition
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 ComponentTransition')
      await driver.assertComponentExist(BY.text('组件内转场', MatchPattern.CONTAINS))
      let componentTransition = await driver.findComponent(BY.text('组件内转场', MatchPattern.CONTAINS))
      await componentTransition.click()
      await driver.delayMs(1000)
      // show
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 show')
      await driver.assertComponentExist(BY.key('show'))
      let showBtn = await driver.findComponent(BY.key('show'))
      await showBtn.click()
      await driver.delayMs(1000)
      // hide
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 hide')
      await showBtn.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 back')
      await driver.assertComponentExist(BY.key('backImg'))
      let backImg = await driver.findComponent(BY.key('backImg'))
      await backImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentTransitionFunction_001 end')
    })

    /**
     * 共享元素转场
     */
    it(BUNDLE + 'ShareTransitionFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // ComponentTransition
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 ComponentTransition')
      await driver.assertComponentExist(BY.text('共享元素转场', MatchPattern.CONTAINS))
      let shareTransition = await driver.findComponent(BY.text('共享元素转场', MatchPattern.CONTAINS))
      await shareTransition.click()
      await driver.delayMs(1000)
      // shareItem1
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 shareItem1')
      await driver.assertComponentExist(BY.key('shareItem1'))
      let shareItem1 = await driver.findComponent(BY.key('shareItem1'))
      await shareItem1.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 back1')
      await driver.assertComponentExist(BY.key('backImg'))
      let backImg = await driver.findComponent(BY.key('backImg'))
      await backImg.click()
      await driver.delayMs(1000)
      // shareItem2
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 shareItem2')
      await driver.assertComponentExist(BY.key('shareItem2'))
      let shareItem2 = await driver.findComponent(BY.key('shareItem2'))
      await shareItem2.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 back2')
      await backImg.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 back3')
      await backImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShareTransitionFunction_001 end')
    })
  })
}