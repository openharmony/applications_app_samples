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

// [Start penOp_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver } from '@kit.TestKit';

  export default function abilityTest() {
    describe('penOp_sample', () => {
      // 模拟手写笔单击、双击、长按、滑动操作
      it('penOperation', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        // 手写笔单击
        await driver.penClick({x: 100, y: 100});
        // 手写笔双击
        await driver.penDoubleClick({x: 100, y: 100});
        // 手写笔长按
        await driver.penLongClick({x: 100, y: 100}, 0.5);
        // 手写笔滑动
        await driver.penSwipe({x: 100, y: 100}, {x: 100, y: 500}, 600, 0.5);
      })
    })
  }
  // [End penOp_sample]