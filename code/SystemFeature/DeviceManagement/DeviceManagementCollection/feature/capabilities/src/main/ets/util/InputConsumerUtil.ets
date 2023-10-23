/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import inputConsumer from '@ohos.multimodalInput.inputConsumer'
import keyCode from '@ohos.multimodalInput.keyCode'
import { Callback } from '@ohos.base';

/**
 * 组合按键
 */
class InputConsumerUtil {
  private mKeyOptionS: inputConsumer.KeyOptions
  private mKeyOptionD: inputConsumer.KeyOptions
  private mCallback: Callback<inputConsumer.KeyOptions> = () => {
  };

  constructor() {
    this.mKeyOptionS = this.createKeyOptions([keyCode.KeyCode.KEYCODE_ALT_LEFT, keyCode.KeyCode.KEYCODE_SHIFT_LEFT], keyCode.KeyCode.KEYCODE_S)
    this.mKeyOptionD = this.createKeyOptions([keyCode.KeyCode.KEYCODE_ALT_LEFT, keyCode.KeyCode.KEYCODE_SHIFT_LEFT], keyCode.KeyCode.KEYCODE_D)
  }

  /**
   * 订阅组合按键
   * @param callback 回调
   * @param keyOptions 组合键选项 默认：a+b+e组合按键
   */
  subscribe(callback: Callback<inputConsumer.KeyOptions>): void {
    this.mCallback = callback
    // 创建按键监听器
    inputConsumer.on('key', this.mKeyOptionS, callback)
    inputConsumer.on('key', this.mKeyOptionD, callback)
  }

  /**
   * 取消订阅组合按键
   * @param keyOptions 组合键选项 默认：a+b+e组合按键
   */
  unsubscribe(): void {
    if (this.mCallback) {
      inputConsumer.off('key', this.mKeyOptionS, this.mCallback)
      inputConsumer.off('key', this.mKeyOptionD, this.mCallback)
    } else {
      inputConsumer.off('key', this.mKeyOptionS)
      inputConsumer.off('key', this.mKeyOptionD)
    }
  }

  /**
   * 构建组合键选项
   * @param preKeys 前置按键集合，数量范围[0, 4]，前置按键无顺序要求
   * @param finalKey 最终按键，此项必填，最终按键触发上报回调函数
   */
  private createKeyOptions(preKeys: Array<number>, finalKey: number): inputConsumer.KeyOptions {
    return {
      preKeys: preKeys,
      finalKey: finalKey,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }
  }
}

export default new InputConsumerUtil()