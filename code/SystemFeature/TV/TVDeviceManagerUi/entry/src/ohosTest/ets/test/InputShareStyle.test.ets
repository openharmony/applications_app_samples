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

export default function inputShareStyleTest(): void {
  describe('TVDeviceManagerUiInputShareStyleTest', () => {
    it('should expose expected share width and height per device type', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      TestAsserts.assertArrayLength(scenarios, 4);
      scenarios.forEach((scenario: DeviceTypeScenario) => {
        if (scenario.deviceType === 'phone' || scenario.deviceType === 'default') {
          TestAsserts.assertNumberEquals(scenario.expectedWidth, 520);
          TestAsserts.assertNumberEquals(scenario.expectedHeight, 365);
        } else {
          TestAsserts.assertNumberEquals(scenario.expectedWidth, 519);
          TestAsserts.assertNumberEquals(scenario.expectedHeight, 256);
        }
      });
    });

    it('should keep phone and default style dimensions fully aligned', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      const phoneScenario: DeviceTypeScenario = scenarios[0];
      const defaultScenario: DeviceTypeScenario = scenarios[1];

      // phone 与 default 走同一套分享样式分支。
      // 如果两个设备类型的尺寸漂移，说明分支约束已被破坏，UI 回归会变得不可预测。
      TestAsserts.assertNumberEquals(phoneScenario.expectedWidth, defaultScenario.expectedWidth);
      TestAsserts.assertNumberEquals(phoneScenario.expectedHeight, defaultScenario.expectedHeight);
    });

    it('should keep tablet and tv style dimensions fully aligned', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      const tabletScenario: DeviceTypeScenario = scenarios[2];
      const tvScenario: DeviceTypeScenario = scenarios[3];

      TestAsserts.assertNumberEquals(tabletScenario.expectedWidth, tvScenario.expectedWidth);
      TestAsserts.assertNumberEquals(tabletScenario.expectedHeight, tvScenario.expectedHeight);
    });

    it('should maintain compact layout branch narrower than phone branch', 0, () => {
      const scenarios: DeviceTypeScenario[] = TestDataFactory.createDeviceTypeScenarios();
      const phoneScenario: DeviceTypeScenario = scenarios[0];
      const tabletScenario: DeviceTypeScenario = scenarios[2];

      TestAsserts.assertTrue(tabletScenario.expectedWidth < phoneScenario.expectedWidth);
      TestAsserts.assertTrue(tabletScenario.expectedHeight < phoneScenario.expectedHeight);
    });
  });
}
