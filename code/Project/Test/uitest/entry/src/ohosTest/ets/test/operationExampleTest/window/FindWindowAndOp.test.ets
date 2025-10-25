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

// [Start findWindowAndOp_sample]
  import { describe, it, TestType, expect } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver } from '@kit.TestKit';
  // Error code when the device is not supported.
  const DeviceErrorCode = 17000005;

  export default function abilityTest() {
    describe('findWindowAndOp_sample', () => {
      // 根据指定条件查找活跃窗口，并对其进行窗口最小化操作
      it("windowSearchAndOperation", TestType.FUNCTION, async () => {
        let driver = Driver.create();
        try {
          let window = await driver.findWindow({active: true});
          await window.minimize();
        } catch (error) {
          // 在不支持窗口操作的设备上调用minimize接口操作窗口时，将抛出17000005错误码
          expect(error.code).assertEqual(DeviceErrorCode);
        }
      })
    })
  }
// [End findWindowAndOp_sample]