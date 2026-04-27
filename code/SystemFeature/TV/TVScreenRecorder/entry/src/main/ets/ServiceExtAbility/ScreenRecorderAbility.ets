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
 
import { ServiceExtensionAbility, Want } from '@kit.AbilityKit'
import SRManager from '../common/SRManager'
import WindowManager from '../common/WindowManager'
import { Rect } from '@kit.ArkGraphics3D'
import Logger from '../common/Logger'
import { sizeCalc } from '../utils/SizeCalc'
import { RecorderConstants, RecordingState } from '../common/Constants'
import { inputConsumer, KeyCode } from '@kit.InputKit'
import { display } from '@kit.ArkUI'

class DoubleClickDetector {
  private timeout = 500
  private firstClickTime = 0
  private timerId = -1

  public handleClick(callback: () => void) {
    const now = Date.now()
    if (this.firstClickTime === 0) {
      this.firstClickTime = now
      if (this.timerId === -1) {
        clearTimeout(this.timerId)
      }
      this.timerId = setTimeout(() => {
        this.firstClickTime = 0
        this.timerId = -1
      }, this.timeout)
    } else {
      const interval = now - this.firstClickTime
      if (interval < this.timeout) {
        if (typeof callback === 'function') {
          callback()
        }
      }
      this.firstClickTime = 0
      if (this.timerId === -1) {
        clearTimeout(this.timerId)
        this.timerId = -1
      }
    }
  }
}

const TIP_RECT: Rect = {
  x: sizeCalc(615),
  y: sizeCalc(46),
  width: sizeCalc(686),
  height: sizeCalc(100)
}

const TAG = '[screenRecorderAbility]-->'

let screenRecorder: SRManager | undefined
let windowMgr: WindowManager | undefined
const storage = new LocalStorage()
const doubleClickDetector = new DoubleClickDetector()

export default class ScreenRecorderAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    Logger.info(TAG, 'screenRecorderAbility on create')
    if (screenRecorder === undefined) {
      screenRecorder = SRManager.getInstance(this.context)

      storage.setOrCreate('recorderState', screenRecorder.getRecorderState())
      storage.setOrCreate('SRAbilityContext', this.context)
      screenRecorder.onStateChange((state) => {
        storage.set('recorderState', state);
        if (state === RecordingState.Error) {
          new Promise<number>((resolve) => setTimeout(resolve, 2000)).then(() => {
            this.context.terminateSelf()
          })
        }
      })
    }
    if (windowMgr === undefined) {
      windowMgr = WindowManager.getInstance()
    }
  }

  onRequest(want: Want, startId: number): void {
    Logger.info(TAG, 'screenRecorderAbility on request. startId: ' + JSON.stringify(startId))
    if (startId === 1) {
      this.startScreenRecording()
    } else {
      this.stopScreenRecording()
    }
  }

  onDestroy(): void {
    Logger.info(TAG, 'screenRecorderAbility on destroy')
    screenRecorder = undefined
    windowMgr?.release()
    windowMgr = undefined
  }

  private async startScreenRecording() {
    if (!windowMgr || !screenRecorder || screenRecorder.getRecorderState() !== RecordingState.Idle) {
      return
    }
    const rect: Rect = {
      x: sizeCalc(96),
      y: sizeCalc(48),
      width: sizeCalc(624),
      height: sizeCalc(56)
    }
    try {
      windowMgr.openTimerWindow('timer', 'pages/ScreenRecorderTimer', rect, this.context, storage)
      await screenRecorder.startRecording()
    } catch (err) {
      Logger.error(TAG, `start recording failed. info`, JSON.stringify(err));
    }
  }

  private async stopScreenRecording() {
    if (!windowMgr || !screenRecorder || screenRecorder.getRecorderState() !== RecordingState.Recording) {
      return
    }
    const rect: Rect = {
      x: sizeCalc(615),
      y: sizeCalc(46),
      width: sizeCalc(686),
      height: sizeCalc(100)
    }
    try {
      windowMgr.get('timer')?.hide()
      await screenRecorder.stopRecording()
      windowMgr.popupRecorderTip('Tip', 'pages/ScreenRecorderDialog', rect, 3000, this.context, () => {
        this.context.terminateSelf()
      })
    } catch (err) {
      Logger.error(TAG, `stop recording failed. info`, JSON.stringify(err));
    }
  }
}
