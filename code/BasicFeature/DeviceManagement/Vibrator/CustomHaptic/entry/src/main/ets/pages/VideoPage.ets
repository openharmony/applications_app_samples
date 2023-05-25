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
import {changeOrientation, showTitleBar, PlayVibrateCustom, hideTitleBar} from '../moudle/Util'

export function setAVPlayerCallback(avPlayer, surfaceID:string) {
  avPlayer.reset()
  avPlayer.on('stateChange', async (state, reason) => {
    switch (state) {
      case 'idle':
        console.info('state idle called')
        break;
      case 'initialized':
        console.info('state initialized called ')
        avPlayer.surfaceId = surfaceID
        avPlayer.prepare().then(() => {
          console.info('prepare success');
        }, (err) => {
          console.error('prepare filed,error message is :' + err.message)
        })
        break;
      case 'prepared':
        console.info('state prepared called')
        avPlayer.play()
        break;
      case 'playing':
        console.info('state playing called')
        break;
      case 'completed':
        console.info('state completed called')
        avPlayer.stop()
        avPlayer.reset()
        break;
      case 'stopped':
        console.info('state stopped called')
        avPlayer.release()
        break;
      case 'error':
        console.info('state error called')
        break;
      default:
        console.info('unkown state :' + state)
        break;
    }
  })
}

export async function videoPlayer(audioName:string, surfaceID:string) {
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer, surfaceID)
  let rawFd = undefined
  await globalThis.getContext().resourceManager.getRawFd(audioName).then((value) => {
    rawFd = value
    console.info("rawFd:" + rawFd.fd.toString() + " " +  rawFd.offset.toString() + " " +rawFd.length.toString())
  }).catch((err)=>{
    console.info("getRawFd failed, err:" + err)
  })
  avPlayer.fdSrc = rawFd
}

@Entry
@Component
struct VideoPage {
  @State  videoName:string = router.getParams()['videoName']
  private  pages:string = router.getParams()['pages']
  @State videoSrc: Resource = router.getParams()['videoSrc']
  @State previewUri: Resource = router.getParams()['previewUri']
  private vibrateFileName:string = router.getParams()['vibrateFileName']
  @State  portrait:boolean = true
  videoController: VideoController = new VideoController()

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Video({
        src : this.videoSrc,
        previewUri: this.previewUri,
        controller: this.videoController,
      }).height("100%")
        .width('100%')
        .objectFit(ImageFit.Auto)
        .controls(false)
        .onStart(() => {
          changeOrientation(true)
          hideTitleBar()
          PlayVibrateCustom(this.vibrateFileName)
        })
        .onClick(() => {
          this.portrait = !this.portrait
        })
        .autoPlay(true)
      Row() {
        Button('<').fontSize(20).backgroundColor("#00222222")
          .onClick(()=>{
            changeOrientation(false)
            showTitleBar()
            vibrator.stopVibration()
            if(this.pages === "Index"){
              router.back()
            } else if (this.pages === "VideoListPage") {
              router.pushUrl({
                url:'pages/VideoListPage',
              })
              router.clear()
            }
          })
        Text(this.videoName).fontSize(18).fontColor(Color.White)
      }.width("100%").height("10%").backgroundColor('#80191a32')
      .visibility(this.portrait ? Visibility.Visible : Visibility.Hidden)
    }.width('100%').height('100%').backgroundColor('#f2191a32')
  }
}
