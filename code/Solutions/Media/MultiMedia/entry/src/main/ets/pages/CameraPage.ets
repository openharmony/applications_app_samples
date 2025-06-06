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
import prompt from '@ohos.prompt'
import Logger from '../model/Logger'
import CameraService from '../model/CameraService'
import TitleBar from '../view/TitleBar'

const CameraMode = {
  MODE_PHOTO: 0, // 拍照模式
  MODE_VIDEO: 1 // 录像模式
}

@Entry
@Component
struct CameraPage {
  private tag: string = 'CameraPage'
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId: string = '-1'
  private cameraService: CameraService = new CameraService(getContext(this))
  @State imgThumbnail: string = ''
  @State videoThumbnail: Resource | undefined = undefined
  @State curModel: number = CameraMode.MODE_PHOTO
  @State isRecording: boolean = false

  aboutToAppear() {
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    Logger.info(this.tag, `aboutToAppear,surfaceId=${this.surfaceId}`)
    this.cameraService.setTakePictureCallback(this.handleTakePicture.bind(this))
  }

  getCameraIcon() {
    if (this.curModel === CameraMode.MODE_PHOTO) {
      return $r('app.media.take_photo_normal')
    } else {
      if (this.isRecording) {
        return $r('app.media.take_video_stop')
      } else {
        return $r('app.media.take_video_normal')
      }
    }
  }

  refreshVideoState() {
    if (this.isRecording) {
      Logger.info(this.tag, 'stopVideo begin')
      this.cameraService.stopVideo()
      this.isRecording = false
      this.videoThumbnail = $r('app.media.video_poster')
    } else {
      Logger.info(this.tag, 'startVideo begin')
      this.cameraService.startVideo()
      this.isRecording = true
    }
  }

  handleTakePicture = (thumbnail: string) => {
    this.imgThumbnail = thumbnail
    Logger.info(this.tag, `takePicture end , thumbnail: ${this.imgThumbnail}`)
  }

  build() {
    Column() {
      TitleBar()
      Stack({ alignContent: Alignment.Bottom }) {
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.mXComponentController
        })
          .onLoad(() => {
            Logger.info(this.tag, 'onLoad is called')
            this.mXComponentController.setXComponentSurfaceSize({ surfaceWidth: 640, surfaceHeight: 480 })
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
            Logger.info(this.tag, `onLoad surfaceId: ${this.surfaceId}`)
            this.curModel = CameraMode.MODE_PHOTO
            this.cameraService.initCamera(this.surfaceId)
          })
          .height('100%')
          .width('100%')
          .margin({ bottom: 130 })
        Column() {
          Row() {
            Text($r('app.string.photo'))
              .fontColor(this.curModel === CameraMode.MODE_PHOTO ? Color.White : Color.Gray)
              .fontSize(25)
              .onClick(() => {
                if (this.curModel === CameraMode.MODE_VIDEO) {
                  prompt.showToast({ message: '切换中...', duration: 1000 })
                  if (this.isRecording) {
                    this.cameraService.stopVideo()
                    this.isRecording = false
                  }
                  this.curModel = CameraMode.MODE_PHOTO
                  setTimeout(() => {
                    this.cameraService.initCamera(this.surfaceId)
                  }, 500)
                  this.videoThumbnail = undefined
                }
              })
            Text($r('app.string.video'))
              .fontColor(this.curModel === CameraMode.MODE_VIDEO ? Color.White : Color.Gray)
              .fontSize(25)
              .id('video')
              .margin({ left: 30 })
              .onClick(() => {
                if (this.curModel === CameraMode.MODE_PHOTO) {
                  prompt.showToast({ message: '切换中...', duration: 1000 })
                  this.curModel = CameraMode.MODE_VIDEO
                  this.cameraService.initCamera(this.surfaceId)
                }
              })
          }
          .size({ height: 40, width: '100%' })
          .margin({ left: 50 })
          .justifyContent(FlexAlign.Center)

          Row() {
            if (this.curModel === CameraMode.MODE_VIDEO) {
              Image(this.videoThumbnail)
                .size({ width: 70, height: 70 })
                .aspectRatio(1)
                .borderRadius(40)
                .objectFit(ImageFit.Fill)
                .backgroundColor(Color.Gray)
            } else {
              Image(this.imgThumbnail)
                .size({ width: 70, height: 70 })
                .aspectRatio(1)
                .borderRadius(40)
                .objectFit(ImageFit.Fill)
                .backgroundColor(Color.Gray)
            }

            Image(this.getCameraIcon())
              .size({ width: 70, height: 70 })
              .margin({ left: 50 })
              .id('cameraIcon')
              .onClick(() => {
                if (this.curModel === CameraMode.MODE_PHOTO) {
                  Logger.info(this.tag, 'takePicture begin')
                  prompt.showToast({ message: '拍照中...', duration: 1000 })
                  this.cameraService.takePicture()
                } else if (this.curModel === CameraMode.MODE_VIDEO) {
                  this.refreshVideoState()
                }
              })
          }
          .size({ height: 80, width: '100%' })
          .margin({ right: 50 })
          .justifyContent(FlexAlign.Center)
        }
        .size({ height: 130, width: '100%' })
        .padding({ bottom: 10 })
        .backgroundColor(Color.Black)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .backgroundColor(Color.Grey)
    }
    .width('100%')
    .height('100%')
  }

  async aboutToDisappear() {
    if (this.isRecording) {
      await this.cameraService.stopVideo()
    }
    await this.cameraService.releaseCamera()
  }
}