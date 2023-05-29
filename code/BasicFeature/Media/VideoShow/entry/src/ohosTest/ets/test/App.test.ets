/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import Logger from '../utils/Logger'

const BUNDLE = 'VideoShow'
const TAG = '[Sample_VideoShow]'

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起一个ability
     */
    it(BUNDLE + 'StartAbility', 0, async (done) => {
      Logger.info(TAG, 'StartAbility start')
      let driver = await Driver.create()
      let want = {
        bundleName: 'com.example.videoshow',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      await driver.delayMs(1000)
      Logger.info(TAG, 'StartAbility end')
      done()
    })

    /**
     * 点击播放键，播放视频
     */
    it(BUNDLE + 'VideoPage_PlayVideo', 1, async (done) => {
      Logger.info(TAG, 'VideoPage_PlayVideo start')
      let driver = await Driver.create()
      await driver.assertComponentExist(ON.id('playBtn'))
      await driver.assertComponentExist(ON.id('previewImg'))
      let playBtn = await driver.findComponent(ON.id('playBtn'))
      await playBtn.click()
      await driver.delayMs(1000)
      // 开始播放，预览图消失
      let previewImg = await driver.findComponent(ON.id('previewImg'))
      await expect(previewImg).assertNull()
      Logger.info(TAG, 'VideoPage_PlayVideo end')
      done()
    })

    /**
     * 上滑触发小窗，检查小窗是否能关闭
     */
    it(BUNDLE + 'SmallVideo', 3, async (done) => {
      Logger.info(TAG, 'SmallVideo start')
      let driver = await Driver.create()
      await driver.fling({
        x: 500, y: 1000
      }, {
        x: 500, y: 200
      }, 50, 10000)
      await driver.assertComponentExist(ON.id('smallVideo'))
      await driver.assertComponentExist(ON.id('closeBtn'))
      // 点击按钮关闭小窗
      let closeBtn = await driver.findComponent(ON.id('closeBtn'))
      await closeBtn.click()
      // 检查是否已经关闭
      let smallVideo = await driver.findComponent(ON.id('smallVideo'))
      await expect(smallVideo).assertNull()
      // 归位
      await driver.fling({
        x: 500, y: 200
      }, {
        x: 500, y: 1000
      }, 60, 10000)
      Logger.info(TAG, 'SmallVideo end')
      done()
    })

    /**
     * 点击视频组件，进入全屏界面，检查播放与暂停功能
     */
    it(BUNDLE + 'FullPage_PlayVideo', 2, async (done) => {
      Logger.info(TAG, 'FullPage_PlayVideo start')
      let driver = await Driver.create()
      let startBtn = await driver.waitForComponent(ON.id('playBtn'), 13000)
      await startBtn.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('VideoPage'))
      let playBtn = await driver.findComponent(ON.id('VideoPage'))
      await playBtn.click()
      await driver.delayMs(500)
      // 点击界面暂停播放
      await driver.assertComponentExist(ON.id('fullVideo'))
      let fullVideo = await driver.findComponent(ON.id('fullVideo'))
      await fullVideo.click()
      await driver.delayMs(500)
      // 暂停后出现播放键
      await driver.assertComponentExist(ON.id('fullPlayBtn'))
      let fullPlayBtn = await driver.findComponent(ON.id('fullPlayBtn'))
      await fullPlayBtn.click()
      await driver.delayMs(500)
      let tempBtn = await driver.findComponent(ON.id('fullPlayBtn'))
      await expect(tempBtn).assertNull()
      await driver.pressBack()
      Logger.info(TAG, 'FullPage_PlayVideo end')
      done()
    })

    /**
     * 进入直播间
     */
    it(BUNDLE + 'OpenLivePage', 4, async (done) => {
      Logger.info(TAG, 'OpenLivePage start')
      let driver = await Driver.create()
      // 点击进入直播间
      await driver.assertComponentExist(ON.id('directVideo'))
      let enterVideoComp = await driver.findComponent(ON.id('directVideo'))
      await enterVideoComp.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('close'))
      await driver.assertComponentExist(ON.text('520', MatchPattern.CONTAINS))
      await driver.fling({
        x: 500, y: 800
      }, {
        x: 500, y: 200
      }, 50, 10000)
      await driver.delayMs(2000)
      // 检查切换后的直播间人数
      await driver.assertComponentExist(ON.text('360', MatchPattern.CONTAINS))
      let close = await driver.findComponent(ON.id('close'))
      await close.click()
      await driver.delayMs(500)
      // 检查是否回到首页
      await driver.assertComponentExist(ON.id('VideoPage'))
      Logger.info(TAG, 'OpenLivePage end')
      done()
    })

    /**
     * 检查首页轮播图
     */
    it(BUNDLE + 'TestSwiper', 5, async (done) => {
      Logger.info(TAG, 'TestSwiper start')
      let driver = await Driver.create()
      await driver.assertComponentExist(ON.id('VideoPage'))
      // 滑动切换轮播图
      let arrSwiper = [0, 1, 2, 3]
      for (let i in arrSwiper) {
        await driver.fling({
          x: 500, y: 300
        }, {
          x: 100, y: 300
        }, 5, 10000)
        await driver.assertComponentExist(ON.text(arrSwiper[i].toString()))
        await driver.delayMs(500)
      }
      await driver.fling({
        x: 500, y: 300
      }, {
        x: 100, y: 300
      }, 5, 10000)
      await driver.assertComponentExist(ON.id('VideoPage'))
      await driver.delayMs(1000)
      Logger.info(TAG, 'TestSwiper end')
      done()
    })
  })
}
