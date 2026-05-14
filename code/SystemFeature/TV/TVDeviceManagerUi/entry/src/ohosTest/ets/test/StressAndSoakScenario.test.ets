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
import { TestDataFactory } from './base/TestDataFactory';
import { TestAsserts } from './base/TestAsserts';

export default function stressAndSoakScenarioTest(): void {
  describe('TVDeviceManagerUiStressAndSoakScenarioTest', () => {
    it('should provide long pin input wave for stress replay', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();
      TestAsserts.assertArrayLength(values, 10);
      TestAsserts.assertPinCandidateSet(values);
    });

    it('should preserve unique replay samples inside stress wave', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();
      TestAsserts.assertStringArrayUnique(values);
    });

    it('should keep each stress pin sample at six digits', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();
      values.forEach((value: string) => {
        TestAsserts.assertNumberEquals(value.length, 6);
      });
    });

    it('should keep stress replay samples free from empty placeholders', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();
      TestAsserts.assertNoEmptyStrings(values);
    });

    it('should keep first and last stress samples readable for log replay', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();

      // 压力回放的样本会被直接打进日志和诊断工具，首尾样本最容易成为人工排障时的锚点。
      // 因此这里要求它们可读且稳定，避免未来有人把测试数据替换成难以识别的随机串。
      TestAsserts.assertReadableText(values[0]);
      TestAsserts.assertReadableText(values[values.length - 1]);
      TestAsserts.assertStringEquals(values[0], '000000');
      TestAsserts.assertStringEquals(values[values.length - 1], '777777');
    });

    it('should keep total stress character budget aligned with soak replay depth', 0, () => {
      const values: string[] = TestDataFactory.createLongStressPinWave();
      const totalCharacters: number = values.reduce((sum: number, value: string) => sum + value.length, 0);
      TestAsserts.assertNumberEquals(totalCharacters, 60);
    });
  });
}
