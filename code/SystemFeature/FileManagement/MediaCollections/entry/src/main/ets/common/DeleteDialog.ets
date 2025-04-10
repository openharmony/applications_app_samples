/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import display from '@ohos.display'
import userFileManager from '@ohos.filemanagement.userFileManager';
import { promptShowToast } from '../model/Prompt'
import MediaUtils from '../model/MediaUtils'

@CustomDialog
export struct DeleteDialog {
  @State displayWidth: number = 0
  private index: number = 0
  private mediaData: userFileManager.FileAsset[] = []
  private controller: CustomDialogController = {} as CustomDialogController
  private mediaType: userFileManager.FileType = userFileManager.FileType.AUDIO

  aboutToAppear() {
    let abilityDisplay = display.getDefaultDisplaySync()
    this.displayWidth = abilityDisplay.width
  }

  build() {
    Column() {
      Text(this.mediaType == userFileManager.FileType.AUDIO ? $r('app.string.index_del_audio') : $r('app.string.index_del'))
        .fontSize(18)
        .fontColor(this.displayWidth > 2500 ? Color.White : Color.Black)
        .margin({ top: 10 })
      Row() {
        Button() {
          Text($r('app.string.index_cel'))
            .fontColor(this.displayWidth > 2500 ? '#5291FF' : '#254FF7')
            .fontSize(17)
        }
        .layoutWeight(5)
        .backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF')
        .onClick(() => {
          promptShowToast($r('app.string.index_celOk'))
          this.controller.close()
        })

        Text()
          .width(1)
          .height(30)
          .backgroundColor(this.displayWidth > 2500 ? '#8F8F8F' : '#cccccc')

        Button() {
          Text($r('app.string.index_sure'))
            .fontColor(this.displayWidth > 2500 ? '#5291FF' : '#254FF7')
            .fontSize(17)
        }
        .layoutWeight(5)
        .backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF')
        .onClick(() => {
          MediaUtils.deleteFile(this.mediaData[this.index])
          this.mediaData.splice(this.index, 1)
          this.controller.close()
          promptShowToast($r('app.string.index_deleteOk'))
        })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      .margin({ top: '5%' })
    }
    .width(this.displayWidth > 2500 ? '26%' : '80%')
    .padding('3%')
    .borderRadius(24)
    .backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF')
  }
}