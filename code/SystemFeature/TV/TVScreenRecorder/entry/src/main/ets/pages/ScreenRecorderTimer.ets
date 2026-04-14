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
 
import Logger from '../common/Logger'
import { RecordingState } from '../common/Constants'
import { sizeCalc } from '../utils/SizeCalc'

const TAG = '[screenRecorderTimer]'
let storage = LocalStorage.getShared()

@Entry(storage)
@Component
struct ScreenRecorderTimer {
  @LocalStorageProp('recorderState') @Watch('onStateChange') recordingState: RecordingState = RecordingState.Idle
  @State isIconHidden: boolean = false
  textTimerController: TextTimerController = new TextTimerController()
  private timerID: number = -1

  private flashTheRecordingIcon() {
    if (this.timerID == -1) {
      this.timerID = setInterval(() => {
        this.isIconHidden = !this.isIconHidden
      }, 800)
    }
  }

  onStateChange() {
    Logger.info(TAG, 'recorder state change:' + this.recordingState)
    switch (this.recordingState) {
      case RecordingState.Recording: {
        this.flashTheRecordingIcon()
        this.textTimerController.start()
        break;
      }
      case RecordingState.Stopped: {
        this.textTimerController.pause()
        if (this.timerID != -1) {
          clearTimeout(this.timerID)
        }
        this.isIconHidden = false
        break;
      }
      case RecordingState.Error: {
        this.textTimerController.pause()
        if (this.timerID != -1) {
          clearTimeout(this.timerID)
        }
        this.isIconHidden = false
        break;
      }
      default:
        break;
    }
  }

  aboutToAppear(): void {
    Logger.info(TAG, `aboutToAppear`)
    this.onStateChange()
  }

  aboutToDisappear(): void {
    Logger.info(TAG, `aboutToDisappear`)
    if (this.timerID != -1) {
      clearTimeout(this.timerID)
    }
  }

  build() {
    Row() {
      Rect({ width: `${sizeCalc(22)}px`, height: `${sizeCalc(22)}px`, radius: `${sizeCalc(11)}px` })
        .id('Recording')
        .fill(Color.Red)
        .margin({ left: '' })
        .visibility(this.isIconHidden ? Visibility.Hidden : Visibility.Visible)
        .animation({ playMode: PlayMode.Alternate, duration: 800 })
      TextTimer({ controller: this.textTimerController })
        .format('HH:mm:ss')
        .fontColor(Color.White)
        .fontSize(`${sizeCalc(40)}px`)
        .fontWeight(FontWeight.Medium)
        .margin({ left: `${sizeCalc(12)}px` })
      Divider()
        .vertical(true)
        .strokeWidth(`${sizeCalc(1)}px`)
        .height(`${sizeCalc(36)}px`)
        .color(Color.White)
        .margin({ left: `${sizeCalc(12)}px`, right: `${sizeCalc(12)}px` })
      Text(this.recordingState == RecordingState.Error ? '未知错误,录制停止' : '同时按下菜单键与音量减键，即可结束录屏')
        .fontColor(this.recordingState == RecordingState.Error ? '#e00606' : Color.White)
        .fontSize(`${sizeCalc(36)}px`)
        .textOverflow({
          overflow: TextOverflow.MARQUEE
        })
        .fontWeight(FontWeight.Medium)
        .width('62%')
    }
    .padding({ left: `${sizeCalc(24)}px`, right: `${sizeCalc(24)}px` })
    .alignItems(VerticalAlign.Center)
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#B33A3F62')
    .borderRadius(`${sizeCalc(28)}px`)
  }
}
