/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
import context from '@ohos.application.context'
import fileIO from '@ohos.fileio'
import media from '@ohos.multimedia.media'
import Logger from '../util/Logger'

const TAG: string = 'Index'
const FD_PREFIX: string = 'fd://'
let player = media.createAudioPlayer()
@Entry
@Component
struct Index {
  @State hasInit: boolean = false
  private context: context.AbilityContext = null
  build() {
    Row() {
      Button({type: ButtonType.Circle, stateEffect: true}) {
        Image($r("app.media.play")).width(35).height(35)
      }
      .onClick((event) => {
        Logger.info(TAG, "play button clicked, hasInit: " + this.hasInit)
        if (this.hasInit) {
          player.play()
        } else {
          this.initAudioPlayer()
        }
      })
      .backgroundColor(0xFFFFFF)
      .margin({right: 15})

      Button({type: ButtonType.Circle, stateEffect: true}) {
        Image($r("app.media.pause")).width(35).height(35)
      }
      .onClick((event) => {
        player.pause()
      })
      .backgroundColor(0xFFFFFF)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  initAudioPlayer() {
    this.setCallback(player)
    let path = this.context.bundleCodeDir + "/audioFeature/resources/rawfile/1.mp3"
    var fd = ''
    fileIO.open(path).then((fdNumber) => {
      fd = FD_PREFIX + fdNumber
      Logger.info(TAG, "open fd success, fd: " + fd)
    }, (err) => {
      Logger.error(TAG, "open fd failed, err is " + err)
    }).catch((err) => {
      Logger.error(TAG, "open fd failed, err is " + err)
    })
    player.src = fd
  }

  setCallback(player: media.AudioPlayer) {
    player.on('dataLoad', () => {
      Logger.info(TAG, "audio load success")
      this.hasInit = true;
      player.play()
    })
    player.on('play', () => {
      Logger.info(TAG, "audio play success")
    })
    player.on('pause', () => {
      Logger.info(TAG, "audio pause success")
    })
    player.on('finish', () => {
      Logger.info(TAG, "audio play finish")
    })
  }

  aboutToAppear() {
    this.context = getContext(this) as context.AbilityContext
  }
}