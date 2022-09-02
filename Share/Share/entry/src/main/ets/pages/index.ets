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

import { ButtonDialogBuilder } from "@ohos/sharecomponent"

const TAG: string = "[Sample_ShareComponent]"
let context: any = getContext(this)

@Entry
@Component
struct Index {
  @State message1: Resource = $r("app.string.shareTitle1")
  @State message2: Resource = $r("app.string.shareTitle2")
  @State message3: Resource = $r("app.string.shareTitle3")
  @State detail0: string = ''
  @State detail1: string = ' '
  @State title: string = ''
  @State srcImg: string = ''
  controller: TabsController = new TabsController() // 分享弹框
  shareDialog: CustomDialogController

  homeBtn() {
    this.shareDialog = new CustomDialogController({
      builder: ButtonDialogBuilder({
        controller: this.shareDialog,
        detail0: this.detail0,
        detail1: this.detail1,
        title: this.title,
        srcImg: this.srcImg
      }),
      cancel: undefined,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      customStyle: true,
    })
    this.shareDialog.open()
  }

  convertResourceToString(resource: Resource) {
    return context.resourceManager.getStringSync(resource.id)
  }

  aboutToAppear() {
    this.detail0 = this.convertResourceToString($r("app.string.detail0"))
    this.detail1 = this.convertResourceToString($r("app.string.detail1"))
    this.title = this.convertResourceToString($r("app.string.title"))
    this.srcImg = this.convertResourceToString($r("app.string.srcImg"))
  }

  build() {
    Row() {
      Column() {
        Button() {
          Text(this.message1)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({
          bottom: $r("app.float.fontSize_18")
        })
        .onClick(() => {
          this.homeBtn()
        })

        Button() {
          Text(this.message2)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({
          bottom: $r("app.float.fontSize_18")
        })
        .onClick(() => {
          this.homeBtn()
        })

        Button() {
          Text(this.message3)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({
          bottom: $r("app.float.fontSize_18")
        })
        .onClick(() => {
          this.homeBtn()
        })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .padding($r("app.float.padding_24"))
    }
    .height('100%')
  }
}