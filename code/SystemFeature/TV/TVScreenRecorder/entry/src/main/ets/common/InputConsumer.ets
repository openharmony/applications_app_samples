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
 
import { inputConsumer } from '@kit.InputKit'
import Logger from './Logger'

const TAG = '[InputConsumer]-->'

export class InputConsumer {
  private keyA: number
  private keyB: number
  private isDownKeyA: boolean = false
  private isDownKeyB: boolean = false
  private gateOpen: boolean = true
  private cb: () => void = (): void => {
  }

  constructor(keyA: number, keyB: number) {
    this.keyA = keyA
    this.keyB = keyB
    this.init()
  }

  private init() {
    const keyADown: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: this.keyA,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    };
    const keyAUp: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: this.keyA,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    };
    const keyBDown: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: this.keyB,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    };
    const keyBUp: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: this.keyB,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    };
    let keyADownCallback = (_keyOptions: inputConsumer.KeyOptions) => {
      this.isDownKeyA = true
      Logger.info(TAG, `keyADownCallback. isDownKeyA: ${this.isDownKeyA}`)
      if (this.isDownKeyA && this.isDownKeyB && this.gateOpen) {
        this.gateOpen = false
        this.cb()
      }
    }
    let keyAUpCallback = (_keyOptions: inputConsumer.KeyOptions) => {
      this.isDownKeyA = false
      this.gateOpen = true
      Logger.info(TAG, `keyAUpCallback. isDownKeyA: ${this.isDownKeyA}`)

    }
    let keyBDownCallback = (_keyOptions: inputConsumer.KeyOptions) => {
      this.isDownKeyB = true
      Logger.info(TAG, `keyBDownCallback. isDownKeyB: ${this.isDownKeyB}`)
      if (this.isDownKeyA && this.isDownKeyB && this.gateOpen) {
        this.gateOpen = false
        this.cb()
      }
    }
    let keyBUpCallback = (_keyOptions: inputConsumer.KeyOptions) => {
      this.isDownKeyB = false
      this.gateOpen = true
      Logger.info(TAG, `keyBUpCallback. isDownKeyB: ${this.isDownKeyB}`)
    }
    try {
      inputConsumer.on('key', keyADown, keyADownCallback)
      inputConsumer.on('key', keyAUp, keyAUpCallback)
      inputConsumer.on('key', keyBDown, keyBDownCallback)
      inputConsumer.on('key', keyBUp, keyBUpCallback)
    } catch (error) {
      Logger.error(TAG, `Subscribe failed, error: ${JSON.stringify(error, ['code', 'message'])}`)
    }
  }

  public setCallback(callback: () => void) {
    this.cb = callback
  }
}
