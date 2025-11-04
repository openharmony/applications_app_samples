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

// [Start watchOp_sample]
  import { describe, it, TestType, Size, Level, expect } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver } from '@kit.TestKit';
  // Error code when the device is not supported.
  const CapabilityCode = 801;

  export default function abilityTest() {
    describe('watchOp_sample', () => {
      // 手表场景，模拟表冠顺/逆时针旋转
      it('crownRotate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        try {
          // 顺时针旋转50格，旋转速度为30格/秒
          await driver.crownRotate(50, 30);
          // 逆时针旋转20格，旋转速度为30格/秒
          await driver.crownRotate(-20, 30);
        } catch (error) {
          // driver.crownRotate接口仅在智能表设备上生效，其他设备调用时将抛出801错误码
          expect(error.code).assertEqual(CapabilityCode);
        }
      })
    })
  }
  // [End watchOp_sample]