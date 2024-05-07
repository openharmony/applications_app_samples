/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { getString } from '../utils/ResourceUtil';
import hilog from '@ohos.hilog';

const TAG = '[Sample_VideoPlay]';
const DOMAIN = 0xF811;
const driver = Driver.create();
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, 'StartAbility_001 begin');

      try {
        await abilityDelegator.startAbility({
          bundleName: 'net.openvally.videoplay',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(3000);
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 点击多音轨轨道:1
     */
    it('Select_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Select_001 begin');

      // 拉起操作界面
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await driver.delayMs(1000);
      await stack.click();

      // 点击多音轨
      await driver.assertComponentExist(ON.id('Select'));
      let btnPlay = await driver.findComponent(ON.id('Select'));
      await btnPlay.click();

      // 点击轨道:1
      const str = await getString($r('app.string.track_name_1'));
      await driver.assertComponentExist(ON.text(str));
      let button = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, 'Select_001 end');
    })

    /**
     * 切换pre_download_network.mp4视频
     */
    it('Choose_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Choose_002 begin');

      // 拉起操作界面
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await driver.delayMs(1000);
      await stack.click();
      // 点击视频列表
      await driver.assertComponentExist(ON.id('Choose'));
      let btnPlay = await driver.findComponent(ON.id('Choose'));
      await btnPlay.click();

      // 点击pre_download_network.mp4
      const str = await getString($r('app.string.video_res_4'));
      await driver.assertComponentExist(ON.text(str));
      let button = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(5000);
      done();
      hilog.info(DOMAIN, TAG, 'Choose_002 end');
    })

    /**
     * 切换test2.mp4视频
     */
    it('Choose_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Choose_001 begin');

      // 拉起操作界面
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await driver.delayMs(1000);
      await stack.click();
      // 点击视频列表
      await driver.assertComponentExist(ON.id('Choose'));
      let btnPlay = await driver.findComponent(ON.id('Choose'));
      await btnPlay.click();

      // 点击test2.mp4
      const str = await getString($r('app.string.video_res_2'));
      await driver.assertComponentExist(ON.text(str));
      let button = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, 'Choose_001 end');
    })

    /**
     * 调节倍速2.0X
     */
    it('Speed_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Speed_001 begin');

      // 拉起操作界面、等待倒计时介绍
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await driver.delayMs(1000);
      await stack.click();

      // 点击倍速
      await driver.assertComponentExist(ON.id('Speed'));
      let btnPlay = await driver.findComponent(ON.id('Speed'));
      await btnPlay.click();

      // 点击2.0X
      const str = await getString($r('app.string.video_speed_2_0X'));
      await driver.assertComponentExist(ON.text(str));
      let button = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, 'Speed_001 end');
    })

    /**
     * 进度条测试
     */
    it('Slider_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Slider_001 begin');

      // 拉起操作界面
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await stack.click();
      await driver.delayMs(1000);
      // 滑动滑块
      await driver.assertComponentExist(ON.id('Slider'));
      let Slider = await driver.findComponent(ON.id('Slider'));
      let point = await Slider.getBoundsCenter();
      await driver.drag(point.x - 50, point.y, point.x + 50, point.y, 800);
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, 'Slider_001 end');
    })

    /**
     * 点击暂停
     */
    it('PlayPause_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PlayPause_001 begin');

      // 拉起操作界面
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await stack.click();
      // 点击暂停
      await driver.assertComponentExist(ON.id('play'));
      let btnPlay = await driver.findComponent(ON.id('play'));
      await btnPlay.click();
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, 'PlayPause_001 end');
    })

    /**
     * 点击播放
     */
    it('PlayPause_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'PlayPause_002 begin');

      // 拉起操作界面
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await stack.click();
      // 点击播放
      await driver.assertComponentExist(ON.id('play'));
      let btnPlay = await driver.findComponent(ON.id('play'));
      await btnPlay.click();
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, 'PlayPause_002 end');
    })

    /**
     * 退出测试
     */
    it('Exit_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Exit_001 begin');

      // 拉起操作界面
      await driver.delayMs(8000);
      await driver.assertComponentExist(ON.id('Video'));
      let stack = await driver.findComponent(ON.id('Video'));
      await stack.click();
      await driver.delayMs(1000);
      // 点击退出
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Exit'));
      let Exit = await driver.findComponent(ON.id('Exit'));
      await Exit.click();
      done();
      hilog.info(DOMAIN, TAG, 'Exit_001 end');
    })
  })
}