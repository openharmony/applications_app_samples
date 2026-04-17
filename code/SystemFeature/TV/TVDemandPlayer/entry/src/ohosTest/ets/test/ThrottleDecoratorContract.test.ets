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

import { describe, it, expect } from '@ohos/hypium';
import { Throttle, ThrottleFn } from '../../../main/ets/Model/Throttle';

class CountHolder {
  value: number = 0;
}

function createThrottle(callCount: CountHolder, wait: number, trailing: boolean = false,
  leading: boolean = false): ThrottleFn {
  return Throttle((): void => {
    callCount.value++;
  }, wait, trailing, leading) as ThrottleFn;
}

export default function ThrottleDecoratorContract001Test() {
  const casePrefix = 'DemandPlayer_ThrottleDecoratorContract001_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('ThrottleDecoratorContract001TestSuite', () => {
    it(addCase(casePrefix + 'InitialCallExecutes_001'), 0, () => {
      const callCount = new CountHolder();
      const throttled = createThrottle(callCount, 100);
      throttled.call();
      expect(callCount.value).assertEqual(1);
    });

    it(addCase(casePrefix + 'RapidCallsThrottled_002'), 0, () => {
      const callCount = new CountHolder();
      const throttled = createThrottle(callCount, 100);
      throttled.call();
      throttled.call();
      throttled.call();
      expect(callCount.value).assertEqual(1);
    });

    it(addCase(casePrefix + 'ZeroDelayAlwaysExecutes_003'), 0, () => {
      const callCount = new CountHolder();
      const throttled = createThrottle(callCount, 0);
      throttled.call();
      throttled.call();
      throttled.call();
      expect(callCount.value).assertEqual(3);
    });

    it(addCase(casePrefix + 'NegativeDelayAlwaysExecutes_004'), 0, () => {
      const callCount = new CountHolder();
      const throttled = createThrottle(callCount, -1);
      throttled.call();
      throttled.call();
      expect(callCount.value).assertEqual(2);
    });

    it(addCase(casePrefix + 'CancelSafe_005'), 0, () => {
      const callCount = new CountHolder();
      const throttled = createThrottle(callCount, 100, true);
      throttled.call();
      throttled.cancel();
      throttled.cancel();
      expect(callCount.value).assertEqual(1);
    });

    it(addCase(casePrefix + 'LeadingFieldMirrorsInput_006'), 0, () => {
      const throttled = Throttle((): void => {
      }, 100, false, true) as ThrottleFn;
      expect(throttled.immediate).assertEqual(true);
    });

    it(addCase(casePrefix + 'FunctionReferenceStored_007'), 0, () => {
      const handler = (): void => {
      };
      const throttled = Throttle(handler, 100) as ThrottleFn;
      expect(throttled.fun === handler).assertEqual(true);
    });

    it(addCase(casePrefix + 'DecoratorShapeReturned_008'), 0, () => {
      const decorator = Throttle(100);
      expect(decorator !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'TwoWrappersIndependent_009'), 0, () => {
      const left = new CountHolder();
      const right = new CountHolder();
      const t1 = createThrottle(left, 100);
      const t2 = createThrottle(right, 100);
      t1.call();
      t1.call();
      t2.call();
      expect(left.value).assertEqual(1);
      expect(right.value).assertEqual(1);
    });

    it(addCase(casePrefix + 'CaseNamePattern_010'), 0, () => {
      expect(allCaseNames.length).assertEqual(10);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ThrottleDecoratorContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
