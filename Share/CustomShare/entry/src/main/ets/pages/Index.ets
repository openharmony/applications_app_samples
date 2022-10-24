// @ts-nocheck
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

import { ButtonDialogBuilder } from '@ohos/sharecomponent'

@Entry
@Component
struct Index {
  @State shareLinkResource: Resource = $r('app.string.share_link')
  @State shareFileResource: Resource = $r('app.string.share_file')
  @State shareOtherResource: Resource = $r('app.string.share_other')
  @State detailTitleText: string = ''
  @State detailPriceText: string = ' '
  @State title: string = ''
  @State srcImage: string = ''
  private controller: TabsController = new TabsController() // 分享弹框
  private shareDialog: CustomDialogController

  homeBtn() {
    this.shareDialog = new CustomDialogController({
      builder: ButtonDialogBuilder({
        controller: this.shareDialog,
        detailTitleText: this.detailTitleText,
        detailPriceText: this.detailPriceText,
        title: this.title,
        srcImage: this.srcImage
      }),
      cancel: undefined,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      customStyle: true
    })
    this.shareDialog.open()
  }

  convertResourceToString(resource: Resource) {
    let context = getContext(this) as any
    return context.resourceManager.getStringSync(resource.id)
  }

  aboutToAppear() {
    this.detailTitleText = this.convertResourceToString($r('app.string.detail_title'))
    this.detailPriceText = this.convertResourceToString($r('app.string.detail_price'))
    this.title = this.convertResourceToString($r('app.string.title'))
    this.srcImage = this.convertResourceToString($r('app.string.src_img'))
  }

  build() {
    Row() {
      Column() {
        Button() {
          Text(this.shareLinkResource)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({ bottom: $r('app.float.fontSize_eighteen') })
        .onClick(() => {
          this.homeBtn()
        })

        Button() {
          Text(this.shareFileResource)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({ bottom: $r('app.float.fontSize_eighteen') })
        .onClick(() => {
          this.homeBtn()
        })

        Button() {
          Text(this.shareOtherResource)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width("60%")
        .height("6%")
        .margin({ bottom: $r('app.float.fontSize_eighteen') })
        .onClick(() => {
          this.homeBtn()
        })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .padding($r('app.float.padding_two_four'))
    }
    .height('100%')
  }
}