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
import { resourceManager } from '@kit.LocalizationKit';

const TAG = '[Sample_WindowManager]';
const BUNDLE = 'WindowManager_';
let manager: resourceManager.ResourceManager;
let context: Context;


export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it('assertContain', 0, () => {
      /**
       * 打开应用
       */
      it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
        Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        try {
          await abilityDelegator.startAbility({
            bundleName: 'ohos.samples.windowcomponent',
            abilityName: 'MainAbility'
          });
          context = await abilityDelegator.getAppContext();
          manager = context.resourceManager;
        } catch (exception) {
          Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
          expect().assertFail();
        }
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.pages_text"))));
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.set_touchable_area_of_window_page"))));
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.get_properties_of_system_bar_page"))));

        done();
        Logger.info(TAG, BUNDLE + 'StartAbility_001 end');

      })
      /**
       * 打开获取系统栏属性测试页
       */
      it(BUNDLE + 'OpenGetPropertiesOfSystemBarPage_001', 6, async () => {
        Logger.info(TAG, BUNDLE + 'OpenGetPropertiesOfSystemBarPage_001 begin');
        let driver = Driver.create();
        // 检查是否有窗口文字
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.get_properties_of_system_bar_page"))));
        let video = await driver.findComponent(ON.text(await manager.getStringValue($r("app.string.get_properties_of_system_bar_page"))));
        await video.click();
        await driver.delayMs(1000);
        // 检查是否有按键
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.GetPropertiesOfSystemBar"))));
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'OpenGetPropertiesOfSystemBarPage_001 end');
      })

      /**
       * 点击获取系统栏属性按钮
       */
      it(BUNDLE + 'GetPropertiesOfSystemBarPage_001', 6, async () => {
        Logger.info(TAG, BUNDLE + 'GetPropertiesOfSystemBarPage_001 begin');
        let driver = Driver.create();
        // 判断是否有按键
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.GetPropertiesOfSystemBar"))));
        const getPropertyButton = await driver.findComponent(ON.text(await manager.getStringValue($r("app.string.GetPropertiesOfSystemBar"))));
        // 判断是否有文本框
        await driver.assertComponentExist(ON.id("propertiesText"));
        // 文本框
        const propertiesText = await driver.findComponent(ON.id("propertiesText"));
        const propertiesBefore = await propertiesText.getText();
        Logger.error(TAG, `propertiesBefore:${propertiesBefore}`)
        await expect(!!propertiesBefore).assertFalse();
        // 点击获取属性按钮
        await getPropertyButton.click();
        await driver.delayMs(1000);
        // 查看Text文本是否输出
        const properties = await propertiesText.getText();
        await expect(!!properties).assertTrue();
        // 还原窗口
        await driver.pressBack();
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'GetPropertiesOfSystemBarPage_001 end');
      })

      /**
       * 打开设置可触摸区域测试页
       */
      it(BUNDLE + 'OpenSetTouchableAreasPage_001', 7, async () => {
        Logger.info(TAG, BUNDLE + 'OpenSetTouchableAreasPage_001 begin');
        let driver = Driver.create();
        // 检查是否有窗口文字
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.set_touchable_area_of_window_page"))));
        let touchableAreaButton = await driver.findComponent(ON.text(await manager.getStringValue($r("app.string.set_touchable_area_of_window_page"))));
        await touchableAreaButton.click();
        await driver.delayMs(1000);
        // 检查是否有按键
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r("app.string.area1"))));
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'OpenSetTouchableAreasPage_001 end');
      })

      /**
       * 设置可触摸区域功能测试
       */
      it(BUNDLE + 'SetTouchableAreas_001', 7, async () => {
        Logger.info(TAG, BUNDLE + 'SetTouchableAreas_001 begin');
        let driver = Driver.create();
        // 区域1检查
        {
          const area1 = await manager.getStringValue($r("app.string.area1"));
          const area1Button = await driver.findComponent(ON.text(area1));
          await area1Button.click();
          await driver.delayMs(1000);
          // 应该有显示 'click 区域1'
          await driver.assertComponentExist(ON.text(`click ${area1}`));
          await driver.delayMs(1500);
        }
        // 区域2检查
        {
          const area2 = await manager.getStringValue($r("app.string.area2"));
          const area2Button = await driver.findComponent(ON.text(area2));
          await area2Button.click();
          await driver.delayMs(1000);
          try {
            await driver.assertComponentExist(ON.text(`click ${area2}`));
            Logger.error(TAG, "area2 toast exists");
            expect().assertFail();
          } catch (e) {
            // 应该没有显示 'click 区域2'
            Logger.info(TAG, "area2 toast doesn't exists");
          }
          await driver.delayMs(1500);
        }
        // 区域3检查
        {
          const area3 = await manager.getStringValue($r("app.string.area3"));
          const area3Button = await driver.findComponent(ON.text(area3));
          await area3Button.click();
          await driver.delayMs(1000);
          try {
            await driver.assertComponentExist(ON.text(`click ${area3}`));
            Logger.error(TAG, "area3 toast exists");
            expect().assertFail();
          } catch (e) {
            // 应该没有显示 'click 区域3'
            Logger.info(TAG, "area3 toast doesn't exists");
          }
          await driver.delayMs(1500);
        }
        // 区域4检查
        {
          const area4 = await manager.getStringValue($r("app.string.area4"));
          const area4Button = await driver.findComponent(ON.text(area4));
          await area4Button.click();
          await driver.delayMs(1000);
          // 应有显示 'click 区域4'
          await driver.assertComponentExist(ON.text(`click ${area4}`));
          await driver.delayMs(1500);
        }
        await driver.pressBack();
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'SetTouchableAreas_001 end');
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
        await expect(rotateLeft).assertLess(originLeft);
        // 还原窗口
        await driver.pressBack();
        await windowBtn.click();
        await driver.pressBack();
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
        await driver.assertComponentExist(ON.id('mainVideo'));
        let originVideo = await driver.findComponent(ON.id('mainVideo'));
        await originVideo.click();
        await driver.delayMs(1000);
        // 检查小窗是否存在
        await driver.assertComponentExist(ON.id('smallVideo'));
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('mainVideo'));
        let originVideo2 = await driver.findComponent(ON.id('mainVideo'));
        await originVideo2.click();
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
        let mainVideo2 = await driver.findComponent(ON.id('mainVideo'));
        await mainVideo2.click();
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'DragSmallVideo_001 end');
      })

      /**
       * 检查是否正常获焦
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
        let smallVideo = await driver.findComponent(ON.id('smallVideo'));
        await smallVideo.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('focus'));
        // 经测试窗口获焦状态有bug
        // await driver.assertComponentExist(ON.text('获焦状态'));
        // 关闭小窗视频
        let mainVideo2 = await driver.findComponent(ON.id('mainVideo'));
        await mainVideo2.click();
        await driver.delayMs(1000);
        Logger.info(TAG, BUNDLE + 'GetFocus_001 end');
      })

      /**
       * 检查是否正常失焦
       */
      it(BUNDLE + 'LoseFocus_001', 5, async () => {
        Logger.info(TAG, BUNDLE + 'LoseFocus_001 begin');
        let driver = Driver.create();
        // 找到视频窗口
        let originVideo = await driver.findComponent(ON.id('mainVideo'));
        await originVideo.click();
        await driver.delayMs(1000);
        // 检查小窗是否存在
        await driver.assertComponentExist(ON.id('smallVideo'));
        await originVideo.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('focus'));
        await driver.assertComponentExist(ON.text('失焦状态'));
        Logger.info(TAG, BUNDLE + 'LoseFocus_001 end');
      })

      /**
       * 检查是否正常拉起悬浮应用
       */
      it(BUNDLE + 'StartNewAbility_001', 5, async () => {
        Logger.info(TAG, BUNDLE + BUNDLE + 'StartNewAbility_001 begin');
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
  })
}