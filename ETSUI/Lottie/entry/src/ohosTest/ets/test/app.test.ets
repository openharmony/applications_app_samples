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
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Lottie]'
const DOMAIN = 0xF811
const BUNDLE = 'Lottie_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "com.example.lottie",
          abilityName: "com.example.lottie.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击选择，选择动画资源
     */
    it(BUNDLE + 'SelectAnimationAssetFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectAnimationAssetFunction_001')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectAnimationAssetFunction_001 clickSelectAnimationBtn')
      // 点击请选择，选择动画资源
      await driver.assertComponentExist(BY.key('selectAnimationBtn'))
      let selectAnimation = await driver.findComponent(BY.key('selectAnimationBtn'))
      await selectAnimation.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectAnimationAssetFunction_001')
      // 选择grunt动画
      await driver.click(460, 695)
      await driver.delayMs(1000)
      console.log('Sample_Lottie 3')
      // 点击上面部分播放/暂停按钮暂停动画
      await driver.assertComponentExist(BY.key('controlAllPlayback'))
      let controlAllPlayback = await driver.findComponent(BY.key('controlAllPlayback'))
      await controlAllPlayback.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 4')
      // 再次点击播放动画
      await controlAllPlayback.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 5')
      // 点击下面部分播放/暂停
      await driver.assertComponentExist(BY.key('controlGruntPlayback'))
      let controlGruntPlayback = await driver.findComponent(BY.key('controlGruntPlayback'))
      await controlGruntPlayback.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 6')
      // 点击销毁动画
      await driver.assertComponentExist(BY.key('destroyAnimation'))
      let destroyAnimation = await driver.findComponent(BY.key('destroyAnimation'))
      await destroyAnimation.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 7')
      // 点击播放/暂停
      await controlAllPlayback.click()
      await driver.delayMs(1000)
      await controlGruntPlayback.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 8')
      // 重新选择动画资源
      await selectAnimation.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 9')
      // 选择grunt动画
      await driver.click(460, 695)
      await driver.delayMs(3000)
      console.log('Sample_Lottie 10')
      // 点击下面部分播放暂停
      await controlGruntPlayback.click()
      await driver.delayMs(1000)
      console.log('Sample_Lottie 11')
    })
  })
}