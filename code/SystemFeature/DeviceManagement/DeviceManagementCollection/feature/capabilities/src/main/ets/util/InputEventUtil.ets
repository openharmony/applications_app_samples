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
import { logger, formatJson } from '@ohos/common'
import inputMonitor from '@ohos.multimodalInput.inputMonitor'
import inputEventClient from '@ohos.multimodalInput.inputEventClient'

const TAG: string = '[Sample_InputEventUtil]'

/**
 * 注入返回按键事件
 */
export function injectBackEvent(): void {
  try {
    let backKeyDown = {
      isPressed: true,
      keyCode: 2,
      keyDownDuration: 0,
      isIntercepted: false
    }
    inputEventClient.injectEvent({ KeyEvent: backKeyDown })

    let backKeyUp = {
      isPressed: false,
      keyCode: 2,
      keyDownDuration: 0,
      isIntercepted: false
    };
    inputEventClient.injectEvent({ KeyEvent: backKeyUp })
  } catch (error) {
    console.log(`Failed to inject KeyEvent, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }
}

class TouchManagerUtil {
  private callback = null

  public registerTouch(callback): void {
    logger.info(`${TAG} registerTouch`)
    try {
      this.callback = callback
      inputMonitor.on('touch', this.onTouchCallback.bind(this))
    } catch (error) {
      logger.error(`${TAG} register touch on failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }
  }

  public unregisterTouch(): void {
    try {
      inputMonitor.off('touch')
      this.callback = null
      logger.info(`${TAG} Monitor off success`)
    } catch (error) {
      logger.error(`${TAG} unregister touch  execute failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }

  }

  private onTouchCallback(event: inputMonitor.TouchEventReceiver) {
    logger.info(`${TAG} onTouchCallback event: ${JSON.stringify(event)}`)
    if (this.callback) {
      this.callback(formatJson(JSON.stringify(event)))
    }
    return false
  }
}

export default new TouchManagerUtil()