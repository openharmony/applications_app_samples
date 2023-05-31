/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import vibrator from '@ohos.vibrator';
import media from '@ohos.multimedia.media'
import router from '@ohos.router'
import { changeOrientation, showTitleBar, playVibrateCustom, hideTitleBar } from './Util'
import Logger from '../moudle/Logger'

const TAG = '[VideoPlayModule]'

export function setAVPlayerCallback(avPlayer, surfaceID: string) {
  avPlayer.reset()
  avPlayer.on('stateChange', async (state, reason) => {
    switch (state) {
      case 'idle':
        Logger.info(TAG, 'state idle called')
        break;
      case 'initialized':
        Logger.info(TAG, 'state initialized called ')
        avPlayer.surfaceId = surfaceID
        avPlayer.prepare().then(() => {
          Logger.info(TAG, 'prepare success');
        }, (err) => {
          Logger.info(TAG, 'prepare filed,error message is :' + err.message)
        })
        break;
      case 'prepared':
        Logger.info(TAG, 'state prepared called')
        avPlayer.play()
        break;
      case 'playing':
        Logger.info(TAG, 'state playing called')
        break;
      case 'completed':
        Logger.info(TAG, 'state completed called')
        avPlayer.stop()
        avPlayer.reset()
        break;
      case 'stopped':
        Logger.info(TAG, 'state stopped called')
        avPlayer.release()
        break;
      case 'error':
        Logger.info(TAG, 'state error called')
        break;
      default:
        Logger.info(TAG, 'unkown state :' + state)
        break;
    }
  })
}

export async function videoPlayer(audioName: string, surfaceID: string) {
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer, surfaceID)
  let rawFd = undefined
  await globalThis.getContext()
    .resourceManager
    .getRawFd(audioName)
    .then((value) => {
      rawFd = value
      Logger.info(TAG, "rawFd:" + rawFd.fd.toString() + " " + rawFd.offset.toString() + " " + rawFd.length.toString())
    })
    .catch((err) => {
      Logger.info(TAG, "getRawFd failed, err:" + err)
    })
  avPlayer.fdSrc = rawFd
}

@Entry
@Component
struct VideoPlayModule {
  @State videoName: string = router.getParams()['videoName']
  private pages: string = router.getParams()['pages']
  @State videoSrc: Resource = router.getParams()['videoSrc']
  @State previewUri: Resource = router.getParams()['previewUri']
  private vibrateFileName: string = router.getParams()['vibrateFileName']
  @State portrait: boolean = true
  videoController: VideoController = new VideoController()

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        controller: this.videoController,
      })
        .height("100%")
        .width('100%')
        .objectFit(ImageFit.Auto)
        .controls(false)
        .onStart(() => {
          changeOrientation(false)
          hideTitleBar()
          playVibrateCustom(this.vibrateFileName)
        })
        .onClick(() => {
          this.portrait = !this.portrait
        })
        .autoPlay(true)
      Row() {
        Button('<').fontSize(15).backgroundColor("#00222222")
          .id('videoBack')
          .onClick(() => {
            changeOrientation(false)
            showTitleBar()
            vibrator.stopVibration()
            router.back()
          })
        Text(this.videoName).fontSize(15).fontColor(Color.White)
      }.width("100%").height("10%").backgroundColor('#80191a32')
      .visibility(this.portrait ? Visibility.Visible : Visibility.Hidden)
    }.width('100%').height('100%').backgroundColor('#f2191a32')
  }
}
