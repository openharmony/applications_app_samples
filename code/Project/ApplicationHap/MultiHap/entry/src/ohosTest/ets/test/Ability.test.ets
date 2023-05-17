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
import Logger from '../utils/Logger';

const TAG = '[Sample_MultiHap]'
const DOMAIN = 0xF811
const BUNDLE = 'MultiHap_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /*
     * 创建Driver对象
     * */
    async function createDriver() {
      let driver = Driver.create();
      await driver.delayMs(1000);
      return driver;
    }
    /*
     * 点击相关组件
     * @param driver:uitest测试框架的Driver对象
     * @param on :uitest测试框架的On对象
     * */
    async function operationComponent(driver: Driver, on) {
      // 判断是否存在组件
      await driver.assertComponentExist(on);
      // 点击组件
      let component = await driver.findComponent(on);
      await component.click();
    }
    /*
     * 日志打印
     * */
    function logInfo(str: String, type: String='info') {
      switch (type) {
        case 'debug':
          Logger.debug(TAG, BUNDLE + str)
          break;
        case 'info':
          Logger.info(TAG, BUNDLE + str)
          break;
        case 'warn':
          Logger.warn(TAG, BUNDLE + str)
          break;
        case 'error':
          Logger.error(TAG, BUNDLE + str)
          break;
        default:
          break;
      }
    }
    /*
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logInfo('StartAbility_001, begin')
      let want = {
        bundleName: 'com.samples.multihap',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility(want);
        done();
        expect(true).assertTrue();
      }
      catch (expection) {
        logInfo(`StartAbility_001, end ${JSON.stringify(expection)}`, 'error')
        expect().assertFail();
      }
      logInfo('StartAbility_001, end')
    })
    /**
     * 打开音频播放应用
     * input：点击audio按钮
     * output：跳转到audio播放页面
     */
    it(BUNDLE + 'ClickBtnAudio_001', 0, async function () {
      logInfo('ClickBtnAudio_001, begin')
      let driver = await createDriver();
      // 点击audio按钮
      await operationComponent(driver, ON.id('btnAudio'));
      logInfo('ClickBtnAudio_001, clickBtnAudio_001')
      await driver.delayMs(1000);
      logInfo('ClickBtnAudio_001, over')
    })
    /**
     * 测试音频应用中的功能，包括播放和暂停
     * input：
     * 1、播点击播放按钮
     * 2、点击暂停按钮
     * output：
     * 1、音频文件正常播放
     * 2、音频文件正常暂停
     */
    it(BUNDLE + 'ClickBtnInAudio_001', 0, async function () {
      logInfo('ClickBtnInAudio_001, begin')
      let driver = await createDriver();
      await driver.delayMs(1000);
      // 点击audio播放按钮
      await operationComponent(driver, ON.id('btnAudioPlay'));
      logInfo('ClickBtnInAudio_001, clickBtnAudioPlay')
      // 点击audio暂停按钮
      await operationComponent(driver, ON.id('btnAudioStop'));
      logInfo('ClickBtnInAudio_001, clickBtnAudioStop')
      logInfo('ClickBtnInAudio_001, over')
    })

    /**
     * 跳转回主应用
     * input：
     * output：
     */
    it(BUNDLE + 'StartAbility_002', 0, async function (done) {
      logInfo('StartAbility_002, begin')
      let want = {
        bundleName: 'com.samples.multihap',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility(want);
        done();
        expect(true).assertTrue();
      }
      catch (expection) {
        logInfo(`StartAbility_002, end ${JSON.stringify(expection)}`, 'error')
        expect().assertFail();
      }
      logInfo('StartAbility_002, end')
    })
    /**
     * 打开视频播放应用
     * input：点击video按钮
     * output：跳转到video播放页面
     */
    it(BUNDLE + 'ClickBtnVideo_001', 0, async function () {
      logInfo('ClickBtnVideo_001, begin')
      let driver = await createDriver();
      //点击audio按钮
      await operationComponent(driver, ON.id('btnVideo'));
      logInfo('ClickBtnVideo_001, ClickBtnVideo_001')
      logInfo('ClickBtnVideo_001, over')
    })
    /**
     * 测试视频应用中的功能，包括播放、暂停、滑动进度条、全屏
     * input："1、播点击播放按钮
     * 2、点击暂停按钮
     * 3、滑动进度条
     * 4、点击全屏按钮
     * 5、点击全屏状态下的全屏按钮
     * output：
     * 1、视频文件正常播放
     * 2、视频文件正常暂停
     * 3、视频文件进度变化
     * 4、视频占满全屏
     * 5、视频变为正常大小
     */
    it(BUNDLE + 'ClickBtnInVideo_001', 0, async function () {
      logInfo('ClickBtnInVideo_001, begin')
      let driver = await createDriver();

      let video = await driver.findComponent(ON.id('videoCard'));
      let rect = await video.getBounds();
      logInfo(`ClickBtnInVideo_001, getBoundsRect1 ${JSON.stringify(rect)}`)
      // 播放
      await driver.click(10, (rect.bottom - 10));
      await driver.delayMs(1000);
      logInfo('ClickBtnInVideo_001, VideoPlay')
      // 播放
      await driver.click(10, (rect.bottom - 10));
      await driver.delayMs(1000);
      logInfo('ClickBtnInVideo_001, VideoStop')
      // 拖动进度条
      await driver.swipe(250, (rect.bottom - 10), 450, (rect.bottom - 10), 600);
      await driver.delayMs(1000);
      logInfo('ClickBtnInVideo_001, VideoSwipe')
      // 全屏
      await driver.click((rect.right - 10), (rect.bottom - 10));
      await driver.delayMs(1000)
      logInfo('ClickBtnInVideo_001, VideoOpenFull')
      rect = await video.getBounds();
      logInfo(`ClickBtnInVideo_001, getBoundsRect2 ${JSON.stringify(rect)}`)
      // 取消全屏
      await driver.click((rect.right - 10), (rect.bottom - 10));
      await driver.delayMs(1000)
      logInfo('ClickBtnInVideo_001, VideoColseFull')
      logInfo('ClickBtnInVideo_001, over')
    })
  })
}