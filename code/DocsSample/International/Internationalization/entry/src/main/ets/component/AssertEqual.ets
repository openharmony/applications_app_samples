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

export function assertEqual<T>(actual: T, expected: T, description: Resource): string {
  if (actual === expected) {
    return `${getContext().resourceManager.getStringSync(description)}${expected} --passed`;
  } else {
    return `${getContext().resourceManager
      .getStringSync(description)} --failed: expected ${expected}, but got ${actual}`;
  }
}

export function assertEqualLong(actual: string, expected: string[], description: Resource): string {
  if (expected.every(expected => actual.includes(expected))) {
    return `${getContext().resourceManager.getStringSync(description)}passed`;
  } else {
    return `${getContext().resourceManager.getStringSync(description)}failed: expected ${expected}, but got ${actual}`;
  }
}

export function assertEqualFuzzy(actual: string, expected: string[], description: Resource): string {
  if (expected.every(expected => actual.includes(expected))) {
    return `${getContext().resourceManager.getStringSync(description)}${actual} --passed`;
  } else {
    return `${getContext().resourceManager.getStringSync(description)}failed: expected ${expected}, but got ${actual}`;
  }
}