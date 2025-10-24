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

// [Start displayOp_sample]
import { describe, it, TestType, Size, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { DisplayRotation, Driver, Point } from '@kit.TestKit';

export default function abilityTest() {
  describe('displayOp_sample', () => {
    // 屏幕属性获取和屏幕操作
    it('displayOperation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      let driver = Driver.create();
      // 获取屏幕大小
      let size: Point = await driver.getDisplaySize();
      // 获取屏幕清晰度
      let density: Point = await driver.getDisplayDensity();
      // 唤醒屏幕
      await driver.wakeUpDisplay();
      // 屏幕顺时针旋转90度
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
    })
  })
}
// [End displayOp_sample]