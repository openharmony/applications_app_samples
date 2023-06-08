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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import Logger from '../utils/Logger';

const TAG = '[Sample_WindowManager]';
const BUNDLE = 'WindowManager_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.windowcomponent',
          abilityName: 'MainAbility'
        });
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('窗口视频'));
      done();
    })

    /**
     * 跳转窗口视频播放页
     */
    it(BUNDLE + 'OpenVideoPage_001', 1, async () => {
      Logger.info(TAG, BUNDLE + 'OpenVideoPage_001 begin');
      let driver = Driver.create();
      // 检查是否有窗口文字
      await driver.assertComponentExist(ON.text('窗口视频'));
      let video = await driver.findComponent(ON.text('窗口视频'));
      await video.click();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('windowBtn'));
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'OpenVideoPage_001 end');
    })


    /**
     * 点击按钮切换窗口方向
     */
    it(BUNDLE + 'VideoPage_001', 2, async () => {
      Logger.info(TAG, BUNDLE + 'VideoPage_001 begin');
      let driver = Driver.create();
      // 判断是否有按键
      await driver.assertComponentExist(ON.id('windowBtn'));
      let windowBtn = await driver.findComponent(ON.id('windowBtn'));
      let originVideo = await driver.findComponent(ON.id('mainVideo'));
      // 记录旋转窗口前的left信息
      let originLeft = (await originVideo.getBounds()).left;
      // 点击按钮选装窗口
      await windowBtn.click();
      await driver.delayMs(1000);
      let rotateVideo = await driver.findComponent(ON.id('mainVideo'));
      // 记录旋转窗口后的left信息
      let rotateLeft = (await rotateVideo.getBounds()).left;
      Logger.info(TAG, `originLeft: ${originLeft}, rotateLeft: ${rotateLeft}`);
      // 竖屏旋转后，video组件的left坐标变大
      await expect(originLeft).assertLess(rotateLeft);
      // 还原窗口
      await windowBtn.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'VideoPage_001 end');
    })

    /**
     * 检查视频小窗是否正常显示与隐藏
     */
    it(BUNDLE + 'SmallVideo_001', 3, async () => {
      Logger.info(TAG, BUNDLE + 'SmallVideo_001 begin');
      let driver = Driver.create();
      // 找到视频窗口
      let originVideo = await driver.findComponent(ON.id('mainVideo'));
      await originVideo.click();
      await driver.delayMs(1000);
      // 检查小窗是否存在
      await driver.assertComponentExist(ON.id('smallVideo'));
      await driver.delayMs(1000);
      await originVideo.click();
      await driver.delayMs(1000);
      // 检查小窗是否已经正常关闭
      let smallVideo = await driver.findComponent(ON.id('smallVideo'));
      await expect(smallVideo).assertNull();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'SmallVideo_001 end');
    })

    /**
     * 检查视频小窗是否能正常拖拽
     */
    it(BUNDLE + 'DragSmallVideo_001', 4, async () => {
      Logger.info(TAG, BUNDLE + 'DragSmallVideo_001 begin');
      let driver = Driver.create();
      // 找到视频窗口
      let mainVideo = await driver.findComponent(ON.id('mainVideo'));
      await mainVideo.click();
      await driver.delayMs(1000);
      // 找到视频窗口
      let smallVideo = await driver.findComponent(ON.id('smallVideo'));
      // 获取小窗中心
      let centerStart = await smallVideo.getBoundsCenter();
      await driver.fling({
        x: centerStart.x, y: centerStart.y
      }, {
        x: centerStart.x + 100, y: centerStart.y - 150
      }, 5, 300);
      await driver.delayMs(1000);
      smallVideo = await driver.findComponent(ON.id('smallVideo'));
      // 获取小窗中心
      let centerEnd = await smallVideo.getBoundsCenter();
      // 检查拖动后的坐标是否与拖动方向相同
      await expect(centerStart.x).assertLess(centerEnd.x);
      await expect(centerStart.y).assertLarger(centerEnd.y);
      Logger.info(TAG, `startX:${centerStart.x}, startY:${centerStart.y}`);
      Logger.info(TAG, `endX:${centerEnd.x}, endY:${centerEnd.y}`);
      // 关闭小窗视频
      await mainVideo.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'DragSmallVideo_001 end');
    })

    /**
     * 检查是否正常获得焦点状态
     */
    it(BUNDLE + 'GetFocus_001', 5, async () => {
      Logger.info(TAG, BUNDLE + 'GetFocus_001 begin');
      let driver = Driver.create();
      // 找到视频窗口
      let originVideo = await driver.findComponent(ON.id('mainVideo'));
      await originVideo.click();
      await driver.delayMs(1000);
      // 检查小窗是否存在
      await driver.assertComponentExist(ON.id('smallVideo'));
      await driver.assertComponentExist(ON.text('获焦状态'));
      await originVideo.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('失焦状态'));
      Logger.info(TAG, BUNDLE + 'GetFocus_001 end');
    })

    /**
     * 检查是否正常拉起悬浮应用
     */
    it(BUNDLE + 'StartNewAbility_001', 5, async () => {
      Logger.info(TAG, BUNDLE + 'GetFocus_001 begin');
      let driver = Driver.create();
      // 找到视频窗口
      let originVideo = await driver.findComponent(ON.id('mainVideo'));
      await originVideo.click();
      await driver.delayMs(1000);
      // 检查小窗是否存在
      await driver.assertComponentExist(ON.id('smallVideo'));
      await driver.assertComponentExist(ON.id('startAbility'));
      let startNewAbility = await driver.findComponent(ON.id('startAbility'));
      await startNewAbility.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'StartNewAbility_001 end');
    })
  })
}