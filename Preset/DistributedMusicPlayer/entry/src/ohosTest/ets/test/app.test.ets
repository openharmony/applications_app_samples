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

const TAG = '[Sample_DistributedMusicPlayer]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributedMusicPlayer_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.etsdistributedmusicplayer",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      })
    })

    /**
     * 进入应用
     */
    it(BUNDLE + 'EnterFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(800)
      // enter
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 enter')
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnEnter = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnEnter.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 end')
    })

    /**
     * 相关信息弹出框
     */
    it(BUNDLE + 'DialogFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DialogFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(800)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DialogFunction_001 showDialogClick')
      await driver.assertComponentExist(BY.key('image1'))
      let showDialog = await driver.findComponent(BY.key('image1'))
      await showDialog.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DialogFunction_001 cancelClick')
      await driver.assertComponentExist(BY.text('取消', MatchPattern.CONTAINS))
      let btnCancel = await driver.findComponent(BY.text('取消', MatchPattern.CONTAINS))
      await btnCancel.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DialogFunction_001 end')
    })

    /**
     * 播放
     */
    it(BUNDLE + 'PlayFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PlayFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(800)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PlayFunction_001 onPlayClick')
      await driver.assertComponentExist(BY.key('image3'))
      let onPlay = await driver.findComponent(BY.key('image3'))
      await onPlay.click()
      await driver.delayMs(3000)
      await onPlay.click()
      await driver.delayMs(800)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PlayFunction_001 end')
    })

    /**
     * 上一首
     */
    it(BUNDLE + 'PreviousFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PreviousFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(800)
      // 点击上一首切换音乐
      hilog.info(DOMAIN, TAG, BUNDLE + 'PreviousFunction_001 onPreviousClick')
      await driver.assertComponentExist(BY.key('image2'))
      let onPrevious = await driver.findComponent(BY.key('image2'))
      await onPrevious.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PreviousFunction_001 end')
    })

    /**
     * 下一首
     */
    it(BUNDLE + 'NextFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NextFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(800)
      // 点击下一首切换音乐
      hilog.info(DOMAIN, TAG, BUNDLE + 'NextFunction_001 onNextClick')
      await driver.assertComponentExist(BY.key('image4'))
      let onNext = await driver.findComponent(BY.key('image4'))
      await onNext.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'NextFunction_001 end')
    })
  })
}