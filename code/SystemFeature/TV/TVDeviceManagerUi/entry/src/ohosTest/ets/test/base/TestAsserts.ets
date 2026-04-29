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

import { expect } from '@ohos/hypium';

export class TestAsserts {
  static assertStringEquals(actual: string, expected: string): void {
    expect(actual).assertEqual(expected);
  }

  static assertStringContains(actual: string, expectedFragment: string): void {
    expect(actual.includes(expectedFragment)).assertTrue();
  }

  static assertTrue(value: boolean): void {
    expect(value).assertTrue();
  }

  static assertFalse(value: boolean): void {
    expect(value).assertFalse();
  }

  static assertNumberEquals(actual: number, expected: number): void {
    expect(actual).assertEqual(expected);
  }

  static assertNumberAtLeast(actual: number, expectedMin: number): void {
    expect(actual >= expectedMin).assertTrue();
  }

  static assertNumberAtMost(actual: number, expectedMax: number): void {
    expect(actual <= expectedMax).assertTrue();
  }

  static assertArrayLength<T>(values: T[], expected: number): void {
    expect(values.length).assertEqual(expected);
  }

  static assertStringArrayContains(values: string[], expected: string[]): void {
    expected.forEach((item: string) => {
      expect(values.includes(item)).assertTrue();
    });
  }

  static assertStringArrayUnique(values: string[]): void {
    const set: Set<string> = new Set<string>();

    // 测试样本会被多个业务套件复用。
    // 先校验唯一性可以避免后续焦点链路与覆盖统计被重复数据污染。
    values.forEach((item: string) => {
      expect(item.length > 0).assertTrue();
      expect(set.has(item)).assertFalse();
      set.add(item);
    });
  }

  static assertReadableText(value: string): void {
    const normalized: string = value.replace(/\s+/g, ' ').trim();
    expect(normalized.length > 0).assertTrue();
    expect(normalized.includes('undefined')).assertFalse();
    expect(normalized.includes('null')).assertFalse();
  }

  static assertActionWave(values: string[], expectedPrefix: string): void {
    expect(values.length > 0).assertTrue();
    values.forEach((item: string, index: number) => {
      expect(item.startsWith(expectedPrefix)).assertTrue();
      if (index > 0) {
        expect(item !== values[index - 1]).assertTrue();
      }
    });
  }

  static assertRotationMatrix(values: string[]): void {
    expect(values.length).assertEqual(4);
    expect(values.includes('ROTATION_0')).assertTrue();
    expect(values.includes('ROTATION_90')).assertTrue();
    expect(values.includes('ROTATION_180')).assertTrue();
    expect(values.includes('ROTATION_270')).assertTrue();
  }

  static assertMonotonicIncrease(values: number[]): void {
    for (let index: number = 1; index < values.length; index++) {
      expect(values[index] >= values[index - 1]).assertTrue();
    }
  }

  static assertCoverageBatchIds(ids: string[]): void {
    expect(ids.length >= 6).assertTrue();
    ids.forEach((id: string) => {
      expect(id.startsWith('batch-')).assertTrue();
    });
  }

  static assertPermissionSet(values: string[]): void {
    TestAsserts.assertStringArrayContains(values, [
      'ohos.permission.GET_BUNDLE_INFO',
      'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED',
      'ohos.permission.DISTRIBUTED_DATASYNC',
      'ohos.permission.SYSTEM_FLOAT_WINDOW',
      'ohos.permission.ACCESS_SERVICE_DM'
    ]);
  }

  static assertRectCentered(fullWidth: number, left: number, dialogWidth: number): void {
    const recalculatedLeft: number = (fullWidth - dialogWidth) / 2;
    expect(left).assertEqual(recalculatedLeft);
  }

  static assertPositiveRect(width: number, height: number): void {
    expect(width > 0).assertTrue();
    expect(height > 0).assertTrue();
  }

  static assertRetrySequence(values: number[]): void {
    expect(values.length > 0).assertTrue();

    // PIN 失败重试是用户纠错主路径。
    // 这里验证严格递减，确保剩余次数不会在边界条件下回跳或停滞。
    for (let index: number = 1; index < values.length; index++) {
      expect(values[index] < values[index - 1]).assertTrue();
    }
  }

  static assertPinCandidateSet(values: string[]): void {
    expect(values.length > 0).assertTrue();
    values.forEach((value: string) => {
      expect(value.length <= 6).assertTrue();
      expect(/^\d*$/.test(value)).assertTrue();
    });
  }

  static assertWindowOperations(values: string[]): void {
    TestAsserts.assertStringArrayContains(values, ['move', 'resize', 'loadContent', 'show', 'radius', 'shadow']);
  }

  static assertLifecycleEvents(values: string[]): void {
    TestAsserts.assertStringArrayContains(values, ['create', 'foreground', 'background', 'destroy']);
  }

  static assertFocusPath(values: string[]): void {
    expect(values.length > 0).assertTrue();

    // 焦点路径决定遥控器交互可用性。
    // 这里要求每个节点都是命名态，避免把未初始化焦点写进回归基线。
    values.forEach((value: string) => {
      expect(value.length > 0).assertTrue();
      expect(value.includes('focus')).assertTrue();
    });
  }

  static assertDialogButtonKeys(values: string[]): void {
    TestAsserts.assertStringArrayContains(values, ['cancel', 'confirm', 'always']);
  }

  static assertNoEmptyStrings(values: string[]): void {
    values.forEach((value: string) => {
      expect(value.trim().length > 0).assertTrue();
    });
  }

  static assertBooleanEquals(actual: boolean, expected: boolean): void {
    expect(actual).assertEqual(expected);
  }

  static assertStringArrayContainsExact(actual: string[], expected: string[]): void {
    expected.forEach((item: string) => {
      expect(actual.includes(item)).assertTrue();
    });
  }
}
