/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { AnimateView } from '../common/AnimateView'
import { AudioModel } from '../model/AudioModel'
import { updateTime } from '../model/Utils'
import Logger from '../model/Logger'

const TAG = '[Recorder.PlayView]'

@Component
export struct PlayView {
  private audioModel: AudioModel = null
  private millisecond: number = 0
  private duration: string = ''
  @State time: string = '00:00'
  @StorageLink('playState') playState: boolean = true
  @State @Watch('onFileChange') fileName: string = ''
  @State resetAnimation: boolean = false

  aboutToAppear() {
    console.info(`${TAG} aboutToAppear`)
    this.initAudioPlayer()
  }

  onFileChange() {
    Logger.info(TAG, `onFileChange,fileName=${this.fileName}`)
    this.initAudioPlayer()
  }

  initAudioPlayer() {
    if (this.fileName !== '') {
      this.audioModel.play(() => {
        this.playState = true
        this.reset()
      })
      this.audioModel.onFinish(() => {
        this.playState = false
        this.reset()
      })
    } else {
      this.playState = false
      this.reset()
    }
  }

  reset() {
    this.time = '00:00'
    this.millisecond = 0
    this.resetAnimation = !this.resetAnimation
  }

  updateTimeStr() {
    this.millisecond += 1000
    this.time = updateTime(this.millisecond)
  }

  handleChangePlayState = () => {
    if (this.fileName !== '') {
      Logger.info(TAG, `handleChangePlayState this.isPlay= ${this.playState}`)
      if (!this.playState) {
        this.audioModel.play(() => {
          Logger.info(TAG, `handleChangePlayState play success`)
          this.playState = !this.playState
          AppStorage.SetOrCreate('playState', this.playState)
        })
      } else {
        this.audioModel.pause(() => {
          Logger.info(TAG, `handleChangePlayState pause success`)
          this.playState = !this.playState
          AppStorage.SetOrCreate('playState', this.playState)
        })
      }
    }
  }

  build() {
    Column() {
      AnimateView({ resetAnimation: $resetAnimation, updateTimeStr: this.updateTimeStr.bind(this) })
      Image($r('app.media.bg_play'))
        .width('100%')
        .height('30%')
        .objectFit(ImageFit.Fill)
      Column() {
        Text(this.time)
          .fontColor(Color.Black)
          .fontSize(35)
        Text(this.duration)
          .fontColor(Color.Gray)
          .fontSize(25)
      }

      Button() {
        Image(this.playState ? $r('app.media.pause') : $r('app.media.play'))
          .objectFit(ImageFit.Contain)
          .size({ width: 70, height: 70 })
          .key('playItem')
      }
      .type(ButtonType.Circle)
      .size({ width: 70, height: 70 })
      .backgroundColor('#FFFFFF')
      .layoutWeight(1)
      .margin({ bottom: 15 })
      .onClick(this.handleChangePlayState)
    }
  }
}