/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

 // [Start touchScreen_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver, PointerMatrix, UiDirection } from '@kit.TestKit';

  export default function abilityTest() {
    describe('touchScreen_sample', () => {
      /**
       * 基于坐标的触摸屏手指操作
       */
      it("touchScreenOperation", TestType.FUNCTION, async () => {
        let driver: Driver = Driver.create();
        // 单击
        await driver.click(100,100);
        // 指定屏幕id进行单击
            await driver.clickAt({ x: 100, y: 100, displayId: 0 });
        // 滑动
        await driver.swipe(100, 100, 200, 200, 600);
        // 指定屏幕id进行滑动
        await driver.swipeBetween({x: 100, y: 100, displayId: 0}, {x: 1000, y: 1000, displayId: 0}, 800);
        // 抛滑
        await driver.fling({x: 100, y: 100},{x: 200, y: 200}, 5, 600);
        // 指定方向的抛滑
        await driver.fling(UiDirection.DOWN, 10000);
        // 拖拽
        await driver.drag(100, 100, 200, 200, 600);
        // 指定屏幕id和拖拽移动前的长按时间
        await driver.dragBetween( {x: 100, y: 100, displayId: 0}, {x: 1000, y: 1000, displayId: 0}, 800, 1500); 
        // 多指操作，指定使用两根手指，每根手指基于两个坐标点滑动
        let pointers: PointerMatrix = PointerMatrix.create(2, 2);
        pointers.setPoint(0, 0, {x: 100, y: 100});
        pointers.setPoint(0, 1, {x: 200, y: 100});
        pointers.setPoint(1, 0, {x: 100, y: 200});
        pointers.setPoint(1, 1, {x: 200, y: 200});
        await driver.injectMultiPointerAction(pointers);
      })
    })
  }
// [End touchScreen_sample]