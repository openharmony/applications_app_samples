/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Logger from '../utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
// @ts-ignore
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import audio from '@ohos.multimedia.audio'

export default function abilityTest() {
  const TAG = '[Sample_Audio]'
  const BUNDLE = 'audio_'
  let driver;

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
     * StartAbility
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.audio',
          abilityName: 'EntryAbility'
        })
        done()
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * [Index]
     * Display two entry card
     * Click select_output_device_card
     */
    it(BUNDLE + 'IndexShow_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin')
      try {
        driver = await Driver.create()
        await driver.delayMs(1000)
        await driver.assertComponentExist(ON.id('select_output_device_card'))
        await driver.assertComponentExist(ON.id('audio_focus_card'))
        let selectOutputDeviceCardComponent = await driver.findComponent(ON.id('select_output_device_card'))
        await selectOutputDeviceCardComponent.click()
        await driver.delayMs(1000)
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_001 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_001 end')
      done()
    })

    /**
     * [PreferOutputDevice]
     * Display  current prefer output device
     * Back to index page
     */
    it(BUNDLE + 'PreferOutputDevice_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'PreferOutputDevice_001 begin')
      try {
        await driver.delayMs(1000)
        await driver.assertComponentExist(ON.id('back_btn'))
        let backComponent = await driver.findComponent(ON.id('back_btn'))
        let deviceNameComponent = await driver.findComponent(ON.id('device_name_text'))
        let deviceNameText = await deviceNameComponent.getText()
        expect(deviceNameText !== 'Invalid').assertTrue()
        await driver.delayMs(1000)
        await backComponent.click()
        await driver.delayMs(1000)
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'PreferOutputDevice_001 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'PreferOutputDevice_001 end')
      done()
    })

    /**
     * [Index]
     * Display two entry card
     * Click select_output_device_card
     */
    it(BUNDLE + 'IndexShow_002', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'IndexShow_001 begin')
      try {
        await driver.delayMs(1000)
        await driver.assertComponentExist(ON.id('select_output_device_card'))
        await driver.assertComponentExist(ON.id('audio_focus_card'))
        let audioFocusCardComponent = await driver.findComponent(ON.id('audio_focus_card'))
        await audioFocusCardComponent.click()
        await driver.delayMs(1000)
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'IndexShow_002 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'IndexShow_002 end')
      done()
    })

    /**
     * [Focus]
     * Click 'audio_focus_card'
     * Display Focus Page
     */
    it(BUNDLE + 'Focus_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'Focus_001 begin')
      try {
        await driver.delayMs(1000)
        await driver.assertComponentExist(ON.id('back_btn_focus'))
        await driver.assertComponentExist(ON.id('music_player_item'))
        await driver.assertComponentExist(ON.id('ringtone_player_item'))
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_001 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'Focus_001 end')
      done()
    })

    /**
     * [Focus] Click musicplayer item
     * Click musicplayer item,expect it's state is playing and is't clickable
     */
    it(BUNDLE + 'Focus_002', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'Focus_002 begin')
      try {
        await driver.delayMs(1000)
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'))
        expect('ic_pause').assertEqual(await musicStateTextComponent.getText())
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'))
        expect('ic_pause_no').assertEqual(await ringtoneStateTextComponent.getText())
        let musicPlayerComponent = await driver.findComponent(ON.id('music_player_item'))

        await musicPlayerComponent.click()
        await driver.delayMs(500)
        expect('ic_play_no').assertEqual(await musicStateTextComponent.getText())
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_002 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'Focus_002 end')
      done()
    })

    /**
     * [Focus] Click ringtoneplayer item
     * Click ringtoneplayer item,expect it's state is playing and is clickable
     * musicplayer item,expect it's state is paused and is't clickable
     */
    it(BUNDLE + 'Focus_003', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'Focus_003 begin')
      try {
        await driver.delayMs(1000)
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'))
        expect('ic_pause').assertEqual(await ringtoneStateTextComponent.getText())

        let ringtonePlayerComponent = await driver.findComponent(ON.id('ringtone_player_item'))
        await ringtonePlayerComponent.click()
        await driver.delayMs(500)
        expect('ic_play').assertEqual(await ringtoneStateTextComponent.getText())

        await driver.delayMs(500)
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'))
        expect('ic_pause_no').assertEqual(await musicStateTextComponent.getText())
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_003 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'Focus_003 end')
      done()
    })

    /**
     * [Focus] musicplayer resume
     * Click ringtoneplayer item,expect it's state is paused and is't clickable
     * musicplayer item,expect it's state is playing and is't clickable
     */
    it(BUNDLE + 'Focus_004', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'Focus_004 begin')
      try {
        await driver.delayMs(1000)
        let ringtoneStateTextComponent = await driver.findComponent(ON.id('ringtone_state_text'))
        expect('ic_play').assertEqual(await ringtoneStateTextComponent.getText())

        let ringtoneStateImgComponent = await driver.findComponent(ON.id('ringtone_state_img'))
        await ringtoneStateImgComponent.click()
        await driver.delayMs(500)
        expect('ic_pause_no').assertEqual(await ringtoneStateTextComponent.getText())

        await driver.delayMs(500)
        let musicStateTextComponent = await driver.findComponent(ON.id('music_state_text'))
        expect('ic_play_no').assertEqual(await musicStateTextComponent.getText())
      } catch (err) {
        Logger.error(TAG, BUNDLE + 'Focus_004 err:' + JSON.stringify(err))
        expect(false).assertTrue()
      }
      Logger.info(TAG, BUNDLE + 'Focus_004 end')
      done()
    })
  })
}