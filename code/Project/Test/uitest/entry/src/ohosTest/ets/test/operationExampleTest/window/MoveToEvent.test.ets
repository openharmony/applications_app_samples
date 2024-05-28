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
import { abilityDelegatorRegistry, DisplayRotation, Driver } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import Logger from '../../../util/Logger';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;
const TAG = "MoveTo_Test";
const BUNDLE = "MoveTo_";
export default function MoveToEventTest() {
  describe('MoveToEventTest', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'EntryAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:MoveToEventTest_001
     * @tc.name: testWindowMoveTo
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 window1.moveTo 功能
     */
    it("MoveTo_Test_001", TestType.FUNCTION, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Test_001 start');
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let window = await driver.findWindow({bundleName: bundleName});
      try{
        // 设置window状态
        await window.resume();
        await driver.delayMs(WAIT_UI_READYMS);
        let window1 = await driver.findWindow({bundleName: bundleName});
        let bounds1 = await window1.getBounds();

        // 设置window移动 100， 100
        await window1.moveTo(100,100);
        await driver.delayMs(WAIT_UI_READYMS);
        let window2 = await driver.findWindow({bundleName: bundleName});
        let bounds2 = await window2.getBounds();
        // 判断俩个window窗口大小是否相同
        expect(bounds1 != bounds2).assertTrue();
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
     * @tc.number:MoveToEventTest_002
     * @tc.name: testDisplayRotation
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 获取、切换屏幕显示方向
     */
    it('testDisplayRotation', TestType.FUNCTION, async () => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(WAIT_UI_READYMS);
      let rotation = await driver.getDisplayRotation();
      // 屏幕垂直显示
      if (rotation == DisplayRotation.ROTATION_90) {
        console.info('The device is displayed in horizontal on default');
        // 屏幕旋转90 degrees
        await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation1 = await driver.getDisplayRotation();
        // 屏幕水平位置
        expect(rotation1 == DisplayRotation.ROTATION_0);

        // 屏幕旋转180 degrees
        await driver.setDisplayRotation(DisplayRotation.ROTATION_180);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation2 = await driver.getDisplayRotation();
        expect(rotation2 == DisplayRotation.ROTATION_270);

        // 屏幕旋转270 degrees
        await driver.setDisplayRotation(DisplayRotation.ROTATION_270);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation3 = await driver.getDisplayRotation();
        expect(rotation3 == DisplayRotation.ROTATION_180);
        await driver.setDisplayRotation(DisplayRotation.ROTATION_90);

      } else if (rotation == DisplayRotation.ROTATION_0) { // 屏幕水平显示
        console.info('The device is displayed in vertical on default');
        // 屏幕旋转90 degrees
        await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation1 = await driver.getDisplayRotation();
        expect(rotation1 == DisplayRotation.ROTATION_90);

        await driver.setDisplayRotation(DisplayRotation.ROTATION_180);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation2 = await driver.getDisplayRotation();
        expect(rotation2 == DisplayRotation.ROTATION_180);

        await driver.setDisplayRotation(DisplayRotation.ROTATION_270);
        await driver.delayMs(WAIT_UI_READYMS);
        let rotation3 = await driver.getDisplayRotation();
        expect(rotation3 == DisplayRotation.ROTATION_270);
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      }
    })

    /**
     * @tc.number:MoveToEventTest_003
     * @tc.name: testWakeUpDisplay
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 唤醒屏幕
     */
    it('testWakeUpDisplay', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.wakeUpDisplay();
    })
  })
}