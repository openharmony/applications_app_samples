/*
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

import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { sleep } from '../Provider';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function registerForMonitoringAllAssetsTest(): void {
  describe('registerForMonitoringAllAssetsTest', () => {
    it('should work', 0, async () => {
      try {
        const want: Want = {
          bundleName: bundleName,
          abilityName: 'RegisterForMonitoringAllAssetsAbility'
        };
        await delegator.startAbility(want);
        await sleep(5000);
      } catch (err) {
        expect().assertFail();
      }
    })
  })
}