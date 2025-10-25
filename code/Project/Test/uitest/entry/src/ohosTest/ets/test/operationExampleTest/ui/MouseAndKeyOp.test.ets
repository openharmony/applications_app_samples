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

// [Start mouseAndKey_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver, MouseButton } from '@kit.TestKit';
  import { KeyCode } from '@ohos.multimodalInput.keyCode';

  export default function abilityTest() {
    describe('mouseAndKey_sample', () => {
      // 模拟键盘按键输入、组合键输入
      it('keyBoardOperation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        // 键盘按键输入（注入返回键）
        await driver.triggerKey(KeyCode.KEYCODE_BACK);
        // 键盘组合键输入（注入保存组合键）
        await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT,  KeyCode.KEYCODE_S);
      })

      // 模拟鼠标左键单击、鼠标移动、鼠标拖拽操作
      it('mouseOperation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        // 鼠标左键单击
        await driver.mouseClick({x: 100, y: 100}, MouseButton.MOUSE_BUTTON_LEFT); 
        // 鼠标移动
        await driver.mouseMoveTo({x: 100, y: 100});
        // 鼠标拖拽
        await driver.mouseDrag({x: 100, y: 100}, {x: 200, y: 200}, 600);
      })

      // 模拟键盘、鼠标组合操作
      it('combinedOperation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        // 按下左CTRL键，同时鼠标滚轮滚动
        await driver.mouseScroll({x:100, y:100}, true, 30, KeyCode.KEYCODE_CTRL_LEFT);
        // 按下左CTRL键，同时鼠标左键长按
        await driver.mouseLongClick({x:100, y:100}, MouseButton.MOUSE_BUTTON_LEFT, KeyCode.KEYCODE_CTRL_LEFT);
      })
    })
  }
  // [End mouseAndKey_sample]