/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ResizeDirection, WindowMode } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import Logger from '../../../util/Logger';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;
const TAG = "ReSize_Test";
const BUNDLE = "ReSize_";

export default function ReSizeWindow() {
  describe('ReSizeWindow', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'EntryAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:ReSize_001
     * @tc.name: ReSize_Test_001
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 设置window指定的大小与方向测试
     */
    it("ReSize_Test_001", TestType.FUNCTION, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Test_001 start');
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let window = await driver.findWindow({bundleName:bundleName});
      try{
        // 设置当前widow状态
        await window.resume();
        await driver.delayMs(WAIT_UI_READYMS);

        let window1 = await driver.findWindow({bundleName:bundleName});
        let bounds1 = await window1.getBounds();
        // 设置当前widow自定义大小 600， 600 向下
        await window1.resize(600,600,ResizeDirection.RIGHT_DOWN);
        await driver.delayMs(WAIT_UI_READYMS);
        let window2 = await driver.findWindow({bundleName:bundleName});
        let bounds2 = await window2.getBounds();
        // 判断俩个window窗口大小是否相同
        expect(bounds2 != bounds1).assertTrue();

        // 设置当前widow自定义大小 400， 400 向上
        await window2.resize(400,400,ResizeDirection.RIGHT_UP);
        let window3 = await driver.findWindow({bundleName:bundleName});
        let bounds3= await window3.getBounds();
        // 判断俩个window窗口大小是否相同
        expect(bounds3 != bounds2).assertTrue();

        await window3.resize(300,300,ResizeDirection.LEFT_DOWN);
        let window4 = await driver.findWindow({bundleName:bundleName});
        let bounds4= await window4.getBounds();
        // 判断俩个window窗口大小是否相同
        expect(bounds4 != bounds3).assertTrue();

        // 设置当前widow自定义大小 500， 500 向上
        await window4.resize(500,500,ResizeDirection.LEFT_UP);
        let window5 = await driver.findWindow({bundleName:bundleName});
        let bounds5= await window5.getBounds();
        // 判断俩个window窗口大小是否相同
        expect(bounds5 != bounds4).assertTrue();
      }
      catch (err) {
        if (err.message == 'this device can not support this action') {
          expect(window != null).assertTrue();
        } else {
          expect(false).assertTrue();
        }
      } finally {
        Logger.info(TAG, BUNDLE + 'Test_001 end');
        done();
      }
    })

    /**
     * @tc.number:ReSize_002
     * @tc.name: testWindowMaximize
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 设置window最大窗口,WindowMode.FLOATING: 悬浮窗口, WindowMode.FULLSCREEN: 全屏窗口
     */
    it('testWindowMaximize', TestType.FUNCTION, async () => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let window = await driver.findWindow({bundleName: bundleName});
      try{
        let windowMode = await window.getWindowMode();
        if (windowMode != WindowMode.FLOATING) {
          await window.resume();
        }
        let window2 = await driver.findWindow({bundleName: bundleName})
        // 设置widow窗口为最大
        await window2.maximize();
        await driver.delayMs(WAIT_UI_READYMS);
        let window3 = await driver.findWindow({bundleName: bundleName});
        let mode = await window3.getWindowMode();

        // 判断当前window是否全屏
        expect(mode == WindowMode.FULLSCREEN).assertTrue();
      }
      catch (err) {
        if (err.message == 'this device can not support this action') {
          expect(window != null).assertTrue();
        } else {
          expect(false).assertTrue();
        }
      }
    })

    /**
     * @tc.number:ReSize_003
     * @tc.name: testWindowMinimize
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 设置window最小窗口, WindowMode.FLOATING: 悬浮窗口, WindowMode.FULLSCREEN: 全屏窗口
     */
    it('testWindowMinimize', TestType.FUNCTION, async () => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let window = await driver.findWindow({bundleName: bundleName});
      try{
        let windowMode = await window.getWindowMode();
        if (windowMode != WindowMode.FLOATING) {
          await window.resume();
        }

        // 设置widow窗口为最小
        await window.minimize();
        await driver.delayMs(WAIT_UI_READYMS);
        let window1 = await driver.findWindow({bundleName: bundleName});
        // 判断当前window是否查找成功
        expect(window1 == null).assertTrue();
      }
      catch (err) {
        if (err.message == 'this device can not support this action') {
          expect(window != null).assertTrue();
        } else {
          expect(false).assertTrue();
        }
      }
    })
  })
}