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

// @ts-nocheck

import { LoadingDialog } from '../phoneView/LoadingDialog'
import { myMedia } from '../model/myMedia'
import Logger from '../model/Logger'

const TAG = 'InputDialog: '

@Component
export struct TitleBar {
  @Link isPlaying: $isPlaying
  @Link currentTime: number
  @Link myMedia: myMedia
  @Prop httpUrl: string
  @Link isXComponent: boolean
  @State search: boolean = true
  @State isInputBg: string = 'rgba(255,255,255,1)'
  private timer: number = undefined
  private mXComponentController: XComponentController
  private LoadingDialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  build() {
    Row() {
      Button({ stateEffect: false }) {
        TextInput({ text: this.httpUrl })
          .fontColor(this.isInputBg)
          .backgroundColor('#343434')
          .width('100%')
          .height('100%')
          .fontSize(18)
          .align(Alignment.Center)
          .onChange((value) => {
            this.httpUrl = value
            this.isXComponent = true
            this.search = false
          })
          .onEditChange(() => {
            this.search = false
          })
          .onSubmit(() => {
            this.isInputBg = 'rgba(255,255,255,0.6)'
            this.isPlaying = true
            Logger.info(TAG + `${this.httpUrl}`)
            let surfaceId = this.mXComponentController.getXComponentSurfaceId()
            Logger.info(TAG + surfaceId)
            this.myMedia.httpInit(this.httpUrl, surfaceId)
            if (this.timer !== undefined) {
              clearInterval(this.timer)
            }
            this.timer = setInterval(() => {
              this.currentTime = this.myMedia.getCurrentTime()
              if (this.currentTime < 1) {
                this.LoadingDialog.open()
              } else {
                this.LoadingDialog.close()
              }
            }, 1000)
          })
      }
      .width('85%')
      .backgroundColor('#343434')
      .height('5%')

      Image($r('app.media.phone_icon_setting'))
        .width(24)
        .height(24)
        .opacity(0.4)
      if (this.search) {
        Image($r('app.media.phone_icon_search'))
          .width(24)
          .height(24)
          .opacity(0.4)
          .position({ x: '6%', y: '7' })
      }
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width('100%')
    .margin({ top: 15, bottom: 15 })
  }
}