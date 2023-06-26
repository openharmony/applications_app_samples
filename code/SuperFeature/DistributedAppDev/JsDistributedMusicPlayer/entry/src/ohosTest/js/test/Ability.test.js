/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required ON applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Component, Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_JsDistributedMusicPlayer]'
const DOMAIN = 0xF811
const BUNDLE = 'JsDistributedMusicPlayer_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, 'StartAbility_001 begin')
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.mydistributedmusicplayer',
          abilityName: 'ohos.samples.mydistributedmusicplayer.MainAbility'
        })
      } catch (err) {
        expect(0).assertEqual(err.code)
      }
      hilog.info(DOMAIN, TAG, 'StartAbility_001 end')
    })
    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 获取文件读写权限
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction requestPermission')
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'))
      await btnStart.click()
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction end')
    })
    /**
     * 分布式功能
     */
    it(BUNDLE + 'hopFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'hopFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 点击按钮
      hilog.info(DOMAIN, TAG, 'hopFunction click hop botton')
      await driver.assertComponentExist(ON.id('btn_hop'))
      let btnHop = await driver.findComponent(ON.id('btn_hop'))
      await btnHop.click()
      await driver.delayMs(2000)
      // 取消弹窗
      hilog.info(DOMAIN, TAG, 'hopFunction unpopup')
      await driver.assertComponentExist(ON.text('取消'))
      let btnCancel = await driver.findComponent(ON.text('取消'))
      await btnCancel.click()
      hilog.info(DOMAIN, TAG, 'hopFunction end')
    })
    /**
     * 音乐 播放&暂停
     */
    it(BUNDLE + 'playFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'playFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      await driver.assertComponentExist(ON.id('cur_time'))
      let timeComponent = await driver.findComponent(ON.id('cur_time'))
      let startTime = await timeComponent.getText()
      // 播放
      hilog.info(DOMAIN, TAG, 'playFunction paly')
      await driver.assertComponentExist(ON.id('btn_play'))
      let btnPlay = await driver.findComponent(ON.id('btn_play'))
      await btnPlay.click()
      await driver.delayMs(2000)
      let secTime = await timeComponent.getText()
      let isEq = startTime !== secTime ? true : false
      expect(isEq).assertTrue()
      // 暂停
      hilog.info(DOMAIN, TAG, 'playFunction stop')
      btnPlay = await driver.findComponent(ON.id('btn_play'))
      await btnPlay.click()
      await driver.delayMs(1000)
      let pauseStartTime = await timeComponent.getText()
      await driver.delayMs(2000)
      let pauseendTime = await timeComponent.getText()
      isEq = pauseStartTime === pauseendTime ? true : false
      expect(isEq).assertTrue()
      hilog.info(DOMAIN, TAG, 'playFunction end')
    })
    /**
     * 切歌 下一首
     */
    it(BUNDLE + 'nextMusicFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'nextMusicFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      await driver.assertComponentExist(ON.id('music_name'))
      let titleComponent = await driver.findComponent(ON.id('music_name'))
      let beforeName = await titleComponent.getText()
      // 下一首
      await driver.assertComponentExist(ON.id('btn_next'))
      let btnNext = await driver.findComponent(ON.id('btn_next'))
      await btnNext.click()
      await driver.delayMs(1000)
      let afterName = await titleComponent.getText()
      let isEq = beforeName !== afterName ? true : false
      expect(isEq).assertTrue()
      hilog.info(DOMAIN, TAG, 'nextMusicFunction end')
    })
    /**
     * 切歌 上一首
     */
    it(BUNDLE + 'preMusicFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'preMusicFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      await driver.assertComponentExist(ON.id('music_name'))
      let titleComponent = await driver.findComponent(ON.id('music_name'))
      let beforeName = await titleComponent.getText()
      // 上一首
      await driver.assertComponentExist(ON.id('btn_pre'))
      let btnPre = await driver.findComponent(ON.id('btn_pre'))
      await btnPre.click()
      await driver.delayMs(1000)
      let afterName = await titleComponent.getText()
      let isEq = beforeName !== afterName ? true : false
      expect(isEq).assertTrue()
      hilog.info(DOMAIN, TAG, 'preMusicFunction end')
    })
    /**
     * 进度条滑动
     */
    it(BUNDLE + 'sliderFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'sliderFunction begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('cur_time'))
      let timeComponent = await driver.findComponent(ON.id('cur_time'))
      let startTime = await timeComponent.getText()
      // 滑动
      await driver.swipe(125, 975, 550, 975, 600);
      let endTime = await timeComponent.getText()
      let isEq = startTime !== endTime ? true : false
      expect(isEq).assertTrue()
      hilog.info(DOMAIN, TAG, 'sliderFunction end')
    })
  })
}