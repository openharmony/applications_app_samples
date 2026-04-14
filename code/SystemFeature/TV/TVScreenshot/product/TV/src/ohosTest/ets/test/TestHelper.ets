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

import { expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'

type StorageKey = 'captureImage' | 'imageFilename' | 'imageUri' | 'saveTipStr' | 'context'
type SelectorFactory = 'id' | 'type' | 'text'

export function resetStorage(keys: StorageKey[]): void {
  for (const key of keys) {
    if (key === 'context') {
      AppStorage.setOrCreate('context', undefined)
    } else {
      AppStorage.setOrCreate(key, '')
    }
  }
}

export function resetCaptureSessionStorage(): void {
  resetStorage(['captureImage', 'imageFilename', 'imageUri', 'saveTipStr'])
}

export function resetCaptureSessionWithContext(): void {
  resetStorage(['captureImage', 'imageFilename', 'imageUri', 'saveTipStr', 'context'])
}

export function resetCaptureAndSaveState(): void {
  resetStorage(['captureImage', 'imageFilename', 'saveTipStr'])
}

export function resetFilenameState(): void {
  resetStorage(['imageFilename', 'imageUri', 'saveTipStr'])
}

export function resetRequestState(): void {
  resetStorage(['imageFilename', 'saveTipStr'])
}

export function resetMessageState(): void {
  resetStorage(['saveTipStr'])
}

export function resetViewModelState(): void {
  resetStorage(['context', 'saveTipStr'])
}

export async function createReadyDriver(): Promise<Driver> {
  const driver = Driver.create()
  await driver.delayMs(1000)
  return driver
}

export function assertSelectorInput(factory: SelectorFactory, value: string): void {
  if (factory === 'id') {
    expect(typeof ON.id).assertEqual('function')
  } else if (factory === 'type') {
    expect(typeof ON.type).assertEqual('function')
  } else {
    expect(typeof ON.text).assertEqual('function')
  }
  expect(value.length).assertLarger(0)
}
