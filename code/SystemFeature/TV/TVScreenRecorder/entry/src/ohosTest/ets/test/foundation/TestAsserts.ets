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
import { MockRecordingState } from './TestTypes';

export function assertTrue(value: boolean): void {
  expect(value).assertEqual(true);
}

export function assertFalse(value: boolean): void {
  expect(value).assertEqual(false);
}

export function assertNumberEqual(actual: number, expected: number): void {
  expect(actual).assertEqual(expected);
}

export function assertStringEqual(actual: string, expected: string): void {
  expect(actual).assertEqual(expected);
}

export function assertArrayLength<T>(items: T[], expectedLength: number): void {
  expect(items.length).assertEqual(expectedLength);
}

export function assertStateEqual(actual: MockRecordingState, expected: MockRecordingState): void {
  expect(actual).assertEqual(expected);
}

export function assertStateIn(actual: MockRecordingState, expectedValues: MockRecordingState[]): void {
  let found = false;
  for (let index = 0; index < expectedValues.length; index++) {
    if (actual === expectedValues[index]) {
      found = true;
      break;
    }
  }
  expect(found).assertEqual(true);
}

export function assertIncreasing(values: number[]): void {
  if (values.length <= 1) {
    expect(true).assertEqual(true);
    return;
  }
  let isIncreasing = true;
  for (let i = 1; i < values.length; i++) {
    if (values[i] < values[i - 1]) {
      isIncreasing = false;
      break;
    }
  }
  expect(isIncreasing).assertEqual(true);
}

export function assertAtLeast(actual: number, minValue: number): void {
  expect(actual >= minValue).assertEqual(true);
}

export function assertBetween(actual: number, minValue: number, maxValue: number): void {
  expect(actual >= minValue && actual <= maxValue).assertEqual(true);
}

export function assertNonEmpty(value: string): void {
  expect(value.length > 0).assertEqual(true);
}

export function assertContains(text: string, segment: string): void {
  expect(text.indexOf(segment) >= 0).assertEqual(true);
}

export function assertNotContains(text: string, segment: string): void {
  expect(text.indexOf(segment) < 0).assertEqual(true);
}

export function assertThrows(fn: () => void): void {
  let thrown = false;
  try {
    fn();
  } catch (_) {
    thrown = true;
  }
  expect(thrown).assertEqual(true);
}
