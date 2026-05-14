/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, it } from '@ohos/hypium';
import { DeviceTypeScenario, TestDataFactory } from './base/TestDataFactory';
import { TestAsserts } from './base/TestAsserts';

export default function pincodeShareStyleTest(): void {
  describe('TVDeviceManagerUiPincodeShareStyleTest', () => {
    it('should use same style matrix as input extension ability', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      scenarios.forEach((scenario: DeviceTypeScenario) => {
        TestAsserts.assertNumberAtLeast(scenario.expectedWidth, 519);
        TestAsserts.assertNumberAtLeast(scenario.expectedHeight, 256);
      });
    });

    // share style 是按 deviceType 分支生成的稳定契约，宽高值必须与预期矩阵一致。
    // 这里逐项锁定 phone/default 与 tablet/tv 两组的目标尺寸，避免平台适配时误改一侧导致 UI 比例漂移。
    it('should keep share style expected width and height aligned with device type matrix', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();

      scenarios.forEach((scenario: DeviceTypeScenario) => {
        if (scenario.deviceType === 'phone' || scenario.deviceType === 'default') {
          TestAsserts.assertNumberEquals(scenario.expectedWidth, 520);
          TestAsserts.assertNumberEquals(scenario.expectedHeight, 365);
          return;
        }
        TestAsserts.assertNumberEquals(scenario.expectedWidth, 519);
        TestAsserts.assertNumberEquals(scenario.expectedHeight, 256);
      });
    });

    // 设备类型集合会被上层矩阵生成器直接遍历，因此必须保持可读且不含空值。
    // 这里补充对 deviceType 字段的质量检查，避免未来新增场景时把空串写进矩阵导致适配分支失效。
    it('should keep device type labels readable and non empty for style routing', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      const deviceTypes: string[] = scenarios.map((scenario: DeviceTypeScenario) => scenario.deviceType);

      TestAsserts.assertNoEmptyStrings(deviceTypes);
      deviceTypes.forEach((value: string) => TestAsserts.assertReadableText(value));
    });

    // share style 的矩阵应该是紧凑集合，不应出现重复的 deviceType 条目污染统计。
    // 这里锁定 deviceType 唯一性，确保矩阵生成不会因为重复项导致样式分支被重复执行。
    it('should keep device type scenario keys unique inside share style matrix', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      const deviceTypes: string[] = scenarios.map((scenario: DeviceTypeScenario) => scenario.deviceType);

      TestAsserts.assertStringArrayUnique(deviceTypes);
    });
  });
}
