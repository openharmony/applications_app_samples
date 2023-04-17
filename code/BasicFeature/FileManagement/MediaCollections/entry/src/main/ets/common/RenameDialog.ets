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
import { promptShowToast } from '../model/Prompt'
import display from '@ohos.display'

@CustomDialog
export struct RenameDialog {
  @State title: string = ''
  @State displayWidth: number = undefined
  private suffix: string
  private disPlayType: string
  private setRename: (newName: string) => void
  private controller: CustomDialogController
  async aboutToAppear() {
    this.suffix = this.title.substring(this.title.lastIndexOf('.'))
    let abilityDisplay = await display.getDefaultDisplay()
    this.displayWidth = abilityDisplay.width
  }
  build() {
    Column() {
      Text(`${this.disPlayType}`)
        .fontSize(20)
        .fontColor(this.displayWidth > 2500 ? '#FFFFFF' : '#000000')
        .width(this.displayWidth > 2500 ? 280 : 328)
        .fontWeight(FontWeight.Medium)
        .height(22)

      TextInput({ placeholder: 'input name', text: this.title.substring(this.title.lastIndexOf('.'), 0) })
        .type(InputType.Normal)
        .fontWeight(FontWeight.Regular)
        .maxLength(18)
        .fontSize(16)
        .width(this.displayWidth > 2500 ? 310 : 350)
        .margin({ top: 10 })
        .backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF')
        .fontColor(this.displayWidth > 2500 ? Color.White : Color.Black)
        .onChange((value: string) => {
          this.title = value + this.suffix
        })
      Text()
        .width(this.displayWidth > 2500 ? 270 : 320)
        .height(1)
        .backgroundColor(this.displayWidth > 2500 ? '#8F8F8F' : '#cccccc')
      Row() {
        Button() {
          Text($r('app.string.index_cel')).fontColor(this.displayWidth > 2500 ? '#5291FF' : '#254FF7').fontSize(17)
        }.layoutWeight(5).backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF').onClick(() => {
          promptShowToast($r('app.string.index_celOk'))
          this.controller.close()
        })

        Text().width(1).height(30).backgroundColor(this.displayWidth > 2500 ? '#8F8F8F' : '#cccccc')
        Button() {
          Text($r('app.string.index_sure')).fontColor(this.displayWidth > 2500 ? '#5291FF' : '#254FF7').fontSize(17)
        }.layoutWeight(5).backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF').onClick(() => {
          if (this.title == this.suffix) {
            promptShowToast($r('app.string.renameDialog_inputName'))
            return
          }
          this.setRename(this.title)
          promptShowToast($r('app.string.renameDialog_inputNameOk'))
          this.controller.close()
        })
      }.justifyContent(FlexAlign.SpaceAround).width('100%').margin({ top: '5%' })
    }
    .width(this.displayWidth > 2500 ? '26%' : '90%')
    .padding('3%')
    .borderRadius(24)
    .backgroundColor(this.displayWidth > 2500 ? '#1C1D1F' : '#FFFFFF')
  }
}